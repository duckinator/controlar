require 'httparty'
require 'open3'

module Controlar::Recognizers
  class Google
    attr_accessor :hypotheses, :bad_hypotheses

    API_URL = 'https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US'

    # Arguments for rec's "silent" argument.
    ABOVE_PERIODS   = '1'
    ABOVE_DURATION  = '0.01'
    ABOVE_THRESHOLD = '3%'

    BELOW_PERIODS   = '1'
    BELOW_DURATION  = '3.0'
    BELOW_THRESHOLD = '4.5%' #'3%'

    # Don't accept a response if the confidence is below a certain amount.
    MIN_CONFIDENCE = 0.8

    def self.get_text!
      tmp = self.new
      tmp.record!
      tmp.transcribe!
      tmp.most_likely
    end

    def initialize
      date = Time.now.to_i
      @filename = File.expand_path("speech.flac", File.join(File.dirname(__FILE__), '..', '..'))
    end

    def record!
      i, o, e, t = Open3.popen3("rec --clobber -r 16000 -q -b 16 #{@filename} silence -l #{ABOVE_PERIODS} #{ABOVE_DURATION} #{ABOVE_THRESHOLD} #{BELOW_PERIODS} #{BELOW_DURATION} #{BELOW_THRESHOLD}")
      t.join
    end

    def transcribe!
      data = open(@filename).read
      ret = HTTParty.post(API_URL, :body => data, :headers => {'Content-type' => 'audio/x-flac; rate=16000'})
      File.delete(@filename)
      all_hypotheses = parse_response(ret.response.body)
      @hypotheses = good_hypotheses_from(all_hypotheses)
      @bad_hypotheses = all_hypotheses - @hypotheses
      self
    rescue JSON::ParserError => e
      # Debugging crap because apparently Google likes giving invalid JSON?
      p json
      raise
    end

    def most_likely
      tmp = @hypotheses.sort_by {|x| x['confidence']}.last || {}
      tmp['utterance']
    end

    def meet_minimum_confidence?
      !@hypotheses.empty?
    end

    private
    def parse_response(text)
      lines = text.strip.split("\n")
      lines.map {|x| x.empty? ? nil : JSON.parse(x)}
           .reject {|x| x.nil? || (x.has_key?('hypotheses') && x['hypotheses'].empty?)}
           .map {|x| x['hypotheses']}
           .flatten
    end

    def good_hypotheses_from(hypotheses)
      hypotheses.reject {|x| x['confidence'] < MIN_CONFIDENCE}
    end
  end
end

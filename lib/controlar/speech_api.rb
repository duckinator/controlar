require 'httparty'
require 'open3'
require 'pp'

module Controlar
  class SpeechAPI
    API_URL = 'https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US'

    def self.transcribe!
      self.new.transcribe!
    end

    def initialize
      date = Time.now.to_i
      @filename = File.expand_path("speech.flac", File.join(File.dirname(__FILE__), '..', '..'))
    end

    def record!
      i, o, e, t = Open3.popen3("rec --clobber -r 16000 -q -b 16 #{@filename} silence 1 0.01 3% 1 3.0 3%")
      t.join
    end

    def transcribe!(options = {:record => true})
      record! if options[:record]

      data = open(@filename).read
      ret = HTTParty.post(API_URL, :body => data, :headers => {'Content-type' => 'audio/x-flac; rate=16000'})
      File.delete(@filename)
      json = ret.response.body.strip
      @data = json.empty? ? {'hypotheses' => []} : JSON.parse(json)
      self
    rescue JSON::ParserError => e
      # Debugging crap because apparently this gets invalid JSON sometimes?
      p ret
      raise
    end

    def most_likely
      (@data['hypotheses'].sort_by {|x| x['confidence']}.last || {})['utterance']
    end
  end
end

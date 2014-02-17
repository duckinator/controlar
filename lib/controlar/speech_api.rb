require 'httparty'
require 'open3'
require 'pp'

module Controlar
  class SpeechAPI
    API_URL = 'https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US'
    FILENAME = File.join(File.dirname(__FILE__), 'speech.flac')

    class << self
      def record_and_transcribe
        i, o, e, t = Open3.popen3("rec --clobber -r 16000 -q -b 16 #{FILENAME} silence 1 0.01 3% 1 3.0 3%")
        t.join
        transcribe('speech.flac')
      end

      def transcribe(filename)
        data = open(filename).read
        ret = HTTParty.post(API_URL, :body => data, :headers => {'Content-type' => 'audio/x-flac; rate=16000'})
        ret = ret.response.body.strip
        ret.empty? ? {'hypotheses' => []} : JSON.parse(ret)
      rescue JSON::ParserError => e
        # Debugging crap because apparently this gets invalid JSON sometimes?
        p ret
        raise
      end
    end
  end
end

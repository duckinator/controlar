require 'controlar/version'
require 'controlar/speech_api'

module Controlar
  CONFIG_DIR = File.join(ENV['HOME'], '.controlar')

  @@commands = {}

  class << self
    def on(regexp, &block)
      @@commands[regexp] = block
    end

    def handle(most_likely)
      p most_likely
    end

    def run!
      setup!
      #load File.join(CONFIG_DIR, 'config.rb')
      # FIXME: Gross hacky bullshit.
      eval(open(File.join(CONFIG_DIR, 'config.rb')).read)

      loop do
        print "Waiting for input... "
        results = Controlar::SpeechAPI.transcribe!
        puts "Done!"
        handle(results.most_likely)
      end
    end

    private
    def setup!
      File.mkdir(CONFIG_DIR) unless File.directory?(CONFIG_DIR)
    end
  end
end


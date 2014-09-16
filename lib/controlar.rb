require 'controlar/version'
require 'controlar/config'
require 'controlar/events'
require 'controlar/synthesizers'
require 'controlar/recognizers'

module Controlar
  DEFAULT_CONFIG_DIR = File.join(ENV['HOME'], '.controlar')
  CONFIG_FILE = ENV['CONTROLAR_CONFIG'] || File.join(DEFAULT_CONFIG_DIR, 'config.rb')

  Synthesizer = Synthesizers::Festival
  Recognizer  = Recognizers::Google

  class << self
    def config(&block)
      Config.new.configure!(&block)
    end

    def run!
      load_config!

      loop do
        print "Waiting for input... "
        results = Recognizer.get_text!
        puts "Done!"
        Config.run(results.most_likely)
      end
    end

    private
    def load_config!
      unless File.exist?(CONFIG_FILE)
        $stderr.puts "Configuration file (#{CONFIG_FILE}) does not exist."
        $stderr.puts "You can specify the file's location with the CONTROLAR_CONFIG environment variable."
        exit 1
      end

      load CONFIG_FILE
    end
  end
end


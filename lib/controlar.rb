require 'controlar/version'
require 'controlar/config_dsl'
require 'controlar/events'
require 'controlar/synthesizers'
require 'controlar/recognizers'

module Controlar
  DEFAULT_CONFIG_DIR = File.join(ENV['HOME'], '.controlar')
  CONFIG_FILE = ENV['CONTROLAR_CONFIG'] || File.join(DEFAULT_CONFIG_DIR, 'config.rb')

  Synthesizer = Synthesizers::Festival
  Recognizer  = Recognizers::Text

  class << self
    def config(&block)
      ConfigDSL.new.configure!(&block)
    end

    def run!
      load_config!

      loop do
        result = prompt { Recognizer.get_text! }

        ConfigDSL.run(result)
      end
    end

    private
    def prompt(&block)
      if Recognizer == Recognizers::Text
        "> "
      else
        "Waiting for input... "
      end

      ret = yield block

      if Recognizer != Recognizers::Text
        "Done!"
      end

      ret
    end

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


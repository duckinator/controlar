require 'controlar/version'

module Controlar
  CONFIG_DIR = File.join(ENV['HOME'], '.controlar')

  @@commands = {}

  class << self
    def setup

    def on(regexp, &block)
      @@commands[regexp] = block
    end

    def run!
      setup!
      load File.join(CONFIG_DIR, 'config.rb')

      loop do
        
      end
    end

    private
    def setup!
      File.mkdir(CONFIG_DIR) unless File.directory?(CONFIG_DIR)
    end
  end
end


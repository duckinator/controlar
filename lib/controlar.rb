require 'controlar/version'

Dir.glob(File.join(File.dirname(__FILE__), 'controlar', 'synthesizers', '*.rb')).each do |f|
  require f
end

Dir.glob(File.join(File.dirname(__FILE__), 'controlar', 'recognizers', '*.rb')).each do |f|
  require f
end

module Controlar
  CONFIG_DIR = File.join(ENV['HOME'], '.controlar')

  @@commands = {}

  Synthesizer = Synthesizers::Festival
  Recognizer  = Recognizers::Google

  class << self
    def synthesizer(name)
      ::Controlar.send(:remove_const, :Synthesizer)
      ::Controlar.const_set(:Synthesizer, Synthesizers.const_get(name))
    end

    def recognizer(name)
      ::Controlar.send(:remove_const, :Recognizer)
      ::Controlar.const_set(:Recognizer, Recognizers.const_get(name))
    end

    def on(regexp, &block)
      @@commands[regexp] = block
    end

    def say(text)
      puts 'wat'
      puts text
      Synthesizer.say(text)
    end

    def handle(most_likely)
      p most_likely
      matches = @@commands.map {|k, v| most_likely =~ k && v}.reject(&:nil?)
      if matches.length > 1
        "More than one command matched what you said.".to_speech
      elsif matches.length == 1
        p matches[0]
        matches[0].call(most_likely)
      end
    end

    def run!
      setup!
      #load File.join(CONFIG_DIR, 'config.rb')
      # FIXME: Gross hacky bullshit.
      eval(open(File.join(CONFIG_DIR, 'config.rb')).read)

      loop do
        print "Waiting for input... "
        results = Recognizer.get_text!
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


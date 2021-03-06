require 'default'

module Controlar
  class ConfigDSL
    @@commands = {}
    @@dispatch = {}

    def configure!(&block)
      instance_eval(&block)
    end

    def synthesizer(name)
      ::Controlar.send(:remove_const, :Synthesizer)
      ::Controlar.const_set(:Synthesizer, Synthesizers.const_get(name))
    end

    def recognizer(name)
      ::Controlar.send(:remove_const, :Recognizer)
      ::Controlar.const_set(:Recognizer, Recognizers.const_get(name))
    end

    def command(name, &block)
      @@commands[name] = block
    end

    def on(regexp, command=default)
      if regexp.is_a?(Hash) && command.default?
        return regexp.map{|rgxp, cmd| on(rgxp, cmd)}
      end

      @@dispatch[regexp] = command
    end

    def say(text)
      puts "=> #{text}"
      Synthesizer.say(text)
    end

    def self.run(text)
      possible_dispatches = @@dispatch.find_all {|k, v| text =~ k}

      if possible_dispatches.length > 1
        Synthesizer.say "More than one command matched what you said."
        $stderr.puts "Commands matched: #{possible_dispatches.join(', ')}"
      elsif possible_dispatches.length == 1
        regexp, command = possible_dispatches.first

        $stderr.puts "Running command:  #{command}." if $DEBUG

        matches = regexp.match(text)

        @@commands[command].call(*matches.to_a)

        $stderr.puts "Finished command: #{command}." if $DEBUG
      end
    end
  end
end

require 'festivaltts4r'

module Controlar::Synthesizers
  module Festival
    def self.say(text)
      text.to_speech
    end
  end
end

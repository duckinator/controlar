require 'httparty'
require 'open3'

module Controlar::Recognizers
  class Text
    def self.get_text!
      print "> "
      $stdin.gets
    end
  end
 end

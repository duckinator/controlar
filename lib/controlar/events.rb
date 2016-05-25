require 'default'
require 'timers'
require 'chronic'

module Controlar
  class EventGroup
    attr_accessor :events

    def initialize
      @timers = Timers::Group.new
      @events = {}
    end

    def at(time, category=default, name=default, &block)
      time = Chronic.parse(time)
      full_name =
        if category.default && name.default?
          :default
        else
          [category, name].join('/')
        end

      @events[full_name] = @timers.after(Time.now - time.to_time, &block)
    end
  end

  Events = EventGroup.new
end

require 'default'
require 'timers'

module Controlar
  class EventGroup < Timers::Group
    @events = {}

    def self.at(time, category=default, name=default, &block)
      full_name =
        if category.default && name.default?
          :default
        else
          [category, name].join('/')
        end

      @events[full_name] = after(Time.now - time.to_time, &block)
    end
  end

  Events = EventGroup.new
end

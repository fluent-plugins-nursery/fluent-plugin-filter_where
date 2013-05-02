require_relative 'core'

module Fluent
  class Plugin::FilterWhere < Plugin::Filter
    Fluent::Plugin.register_output('where', self)

    helpers :event_emitter
    include ::Fluent::FilterWhere::Core

    def initialize
      super
    end
    
    def configure(conf)
      super
    end

    def process(tag, es)
      super
    end
  end
end

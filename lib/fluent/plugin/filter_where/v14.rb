require_relative 'core'

module Fluent
  class Plugin::FilterWhere < Plugin::Filter
    Fluent::Plugin.register_filter('where', self)

    include ::Fluent::FilterWhere::Core

    def initialize
      super
    end
    
    def configure(conf)
      super
    end

    def filter(tag, time, record)
      super
    end
  end
end

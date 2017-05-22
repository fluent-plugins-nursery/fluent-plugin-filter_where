require_relative 'core'

module Fluent
  class FilterWhere < Filter
    Fluent::Plugin.register_filter('where', self)

    include ::Fluent::FilterWhere::Core

    def initialize
      super
    end

    # To support log_level option implemented by Fluentd v0.10.43
    unless method_defined?(:log)
      define_method("log") { $log }
    end

    def configure(conf)
      super
    end

    def filter(tag, time, record)
      super
    end
  end
end

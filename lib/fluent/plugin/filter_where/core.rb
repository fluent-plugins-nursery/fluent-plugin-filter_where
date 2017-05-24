require_relative 'version'
require_relative 'parser'

module Fluent::FilterWhere
  module Core
    def initialize
      super
    end

    def self.included(klass)
      klass.config_param :where, :string, :desc => 'The SQL-like WHERE statement.'
    end

    def configure(conf)
      super

      parser = Fluent::FilterWhere::Parser.new(log: log)
      @evaluator = parser.scan(@where)
    end

    def filter(tag, time, record)
      if @evaluator.eval(record)
        record
      else
        nil # remove
      end
    rescue => e
      log.warn "filter_where: #{e.class} #{e.message} #{e.backtrace.first}"
      log.debug "filter_where:: tag:#{tag} time:#{time} record:#{record}"
    end
  end
end

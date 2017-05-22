require 'fluent/plugin/filter_where/parser.tab'

module Fluent; module FilterWhere; end; end
module Fluent
  module FilterWhere::Core
    def initialize
      super
    end
    
    def self.included(klass)
      klass.config_param :where, :string, :desc => 'The SQL-like WHERE statement.'
    end

    def configure(conf)
      super

      parser = Fluent::FilterWhere::Parser.new
      @scanner = parser.scan(@where)
    end

    def filter(tag, time, record)
      if @scanner.eval(record)
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

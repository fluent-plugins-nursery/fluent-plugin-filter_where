require 'test/unit'
require 'test/unit/rr'
require 'timecop'
require 'fluent/log'
require 'fluent/test'

ROOT = File.dirname(__dir__)

unless defined?(Test::Unit::AssertionFailedError)
  class Test::Unit::AssertionFailedError < StandardError
  end
end

# Reduce sleep period at
# https://github.com/fluent/fluentd/blob/a271b3ec76ab7cf89ebe4012aa5b3912333dbdb7/lib/fluent/test/base.rb#L81
module Fluent
  module Test
    class TestDriver
      def run(num_waits = 10, &block)
        @instance.start
        begin
          # wait until thread starts
          # num_waits.times { sleep 0.05 }
          sleep 0.05
          return yield
        ensure
          @instance.shutdown
        end
      end
    end
  end
end

## v0.14
# d = create_driver(conf, syntax: :v1)
# d.run(default_tag: default_tag) do
#   d.feed(time, record)
# end
# d.filtered_records
#
## v0.12
# d = create_driver(conf, use_v1, default_tag: tag)
# d.run do
#   d.emit(record, time)
# end
# d.filtered # es
#
## Ours
# d = create_driver(conf, syntax: :v1, default_tag: tag)
# d.run do
#   d.feed(time, record)
# end
# d.filtered_records

require 'fluent/version'
major, minor, patch = Fluent::VERSION.split('.').map(&:to_i)
if major > 0 || (major == 0 && minor >= 14)
  require 'fluent/test/driver/filter'
  require 'fluent/test/helpers'
  include Fluent::Test::Helpers

  class FilterWhereTestDriver < Fluent::Test::Driver::Filter
    def initialize(klass, tag)
      super(klass)
      @tag = tag
    end

    def run(&block)
      super(default_tag: @tag, &block)
    end
  end

  def create_driver(conf, syntax: :v1, default_tag: 'tag')
    FilterWhereTestDriver.new(Fluent::Plugin::FilterWhere, default_tag).configure(conf, syntax: syntax)
  end
else # <= v0.12
  def event_time(str)
    Time.parse(str)
  end

  class FilterWhereTestDriver < Fluent::Test::FilterTestDriver
    def configure(conf, syntax: :v1)
      syntax == :v1 ? super(conf, true) : super(conf, false)
    end

    def feed(time, record)
      emit(record, time)
    end

    def filtered_records
      @filtered.map {|_time, record| record }
    end
  end

  def create_driver(conf, syntax: :v1, default_tag: 'tag')
    FilterWhereTestDriver.new(Fluent::Plugin::FilterWhere, default_tag).configure(conf, syntax: syntax)
  end
end

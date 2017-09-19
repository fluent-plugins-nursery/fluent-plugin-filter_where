# This test driver makes a compatibility layer for v0.14 as of v0.12

# d = create_driver(conf, use_v1)
# time = event_time("2010-05-04 03:02:01")
# d.run do
#   d.emit(record, time)
# end
# d.filtered

require 'fluent/version'
major, minor, patch = Fluent::VERSION.split('.').map(&:to_i)
if major > 0 || (major == 0 && minor >= 14)
  require 'fluent/test/driver/filter'
  require 'fluent/test/helpers'
  include Fluent::Test::Helpers

  class FilterTestDriver < Fluent::Test::Driver::Filter
    def initialize(klass, tag)
      super(klass)
      @tag = tag
    end

    def configure(conf, use_v1)
      super(conf, syntax: use_v1 ? :v1 : :v0)
    end

    def emit(record, time)
      feed(time, record)
    end

    def run(&block)
      super(default_tag: @tag, &block)
    end
  end

  def create_driver(conf, use_v1 = true, default_tag: 'filter.test')
    FilterTestDriver.new(Fluent::Plugin::FilterWhere, default_tag).configure(conf, use_v1)
  end
else
  def event_time(str)
    Time.parse(str)
  end

  def create_driver(conf, use_v1 = true, default_tag: 'filter.test')
    Fluent::Test::FilterTestDriver.new(Fluent::PluginFilterWhere, default_tag).configure(conf, use_v1)
  end
end

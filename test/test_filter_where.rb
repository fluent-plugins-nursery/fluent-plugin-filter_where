require_relative 'helper'
require 'time'
require 'fluent/plugin/filter_where'

Fluent::Test.setup

class FilterWhereTest < Test::Unit::TestCase
  setup do
    @time = event_time("2010-05-04 03:02:01")
    Timecop.freeze(@time)
  end

  teardown do
    Timecop.return
  end

  sub_test_case '#configure' do
    test 'check default' do
      assert_raise(Fluent::ConfigError) { create_driver(%[]) }
    end

    test "where" do
      assert_nothing_raised { create_driver(%[where foo = 'foo']) }
    end
  end

  sub_test_case '#filter' do
    test "where" do
      d = create_driver(%[where foo = 'foo'])
      d.run do
        d.feed(@time, {'foo' => 'foo'})
        d.feed(@time, {'foo' => 'bar'})
      end
      assert { d.filtered_records == [{'foo' => 'foo'}] }
    end
  end
end

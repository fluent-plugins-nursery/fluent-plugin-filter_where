# encoding: UTF-8
require_relative 'helper'
require 'fluent/plugin/filter_where'
require 'benchmark'
Fluent::Test.setup

# setup
message = {'message' => "2013/01/13T07:02:11.124202 INFO GET /ping"}
time = event_time

string_eq = create_driver(%[where string = 'string'])
string_regexp = create_driver(%[where string REGEXP '.*string.*'])

# bench
n = 10000
Benchmark.bm(7) do |x|
  x.report("string_eq")  { string_eq.run  { n.times { string_eq.feed(time, message)  } } }
  x.report("string_regexp")  { string_regexp.run  { n.times { string_regexp.feed(time, message)  } } }
end

#               user     system      total        real
# string_eq  0.030000   0.000000   0.030000 (  0.036840)
# string_regexp  0.040000   0.000000   0.040000 (  0.043812)

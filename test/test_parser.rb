require_relative 'helper'

class ParserTest < Test::Unit::TestCase
  class << self
    def startup
      system "rake compile"
      require 'fluent/plugin/filter_where/parser'
    end
  end

  def parser
    @parser ||= Fluent::FilterWhere::Parser.new
  end

  def record
    {'boolean' => true, 'integer' => 1, 'float' => 1.5, 'string' => 'string', 'time' => 0}
  end

  def test_parse
    result = parser.scan(%q[boolean = true])
    assert_true(result.eval(record))
    result = parser.scan(%q[boolean = false])
    assert_false(result.eval(record))

    result = parser.scan(%q[integer = 1])
    assert_true(result.eval(record))
    result = parser.scan(%q[integer = 0])
    assert_false(result.eval(record))

    result = parser.scan(%q[float = 1.5])
    assert_true(result.eval(record))
    result = parser.scan(%q[float = 1])
    assert_false(result.eval(record))

    result = parser.scan(%q[string = 'string'])
    assert_true(result.eval(record))
    result = parser.scan(%q[string = 'foobar'])
    assert_false(result.eval(record))
  end

  def test_identifier_literal
    result = parser.scan(%q["boolean" = true])
    assert_true(result.eval(record))
  end

  def test_string_literal
    result = parser.scan(%q["string" = 'string'])
    assert_true(result.eval(record))
  end

  def test_boolean_op
    result = parser.scan(%q[boolean = true])
    assert_true(result.eval(record))
    result = parser.scan(%q[boolean != false])
    assert_true(result.eval(record))
    result = parser.scan(%q[boolean <> false])
    assert_true(result.eval(record))
    assert_raise(Fluent::ConfigError) { parser.scan(%q[boolean > false]) }
  end

  def test_number_op
    result = parser.scan(%q[integer = 1])
    assert_true(result.eval(record))
    result = parser.scan(%q[integer != 0])
    assert_true(result.eval(record))
    result = parser.scan(%q[integer <> 0])
    assert_true(result.eval(record))
    result = parser.scan(%q[integer > 0])
    assert_true(result.eval(record))
    result = parser.scan(%q[integer >= 0])
    assert_true(result.eval(record))
    result = parser.scan(%q[integer < 2])
    assert_true(result.eval(record))
    result = parser.scan(%q[integer <= 2])
    assert_true(result.eval(record))
  end

  def test_string_op
    result = parser.scan(%q[string = 'string'])
    assert_true(result.eval(record))
    result = parser.scan(%q[string != 'foobar'])
    assert_true(result.eval(record))
    result = parser.scan(%q[string <> 'foobar'])
    assert_true(result.eval(record))
    result = parser.scan(%q[string start_with'str'])
    assert_true(result.eval(record))
    result = parser.scan(%q[string end_with 'ing'])
    assert_true(result.eval(record))
    result = parser.scan(%q[string include 'str'])
    assert_true(result.eval(record))
    result = parser.scan(%q[string regexp '.*str.*'])
    assert_true(result.eval(record))
  end

  def test_null_op
    result = parser.scan(%q[nothing IS NULL])
    result.eval(record)
    assert_true(result.eval(record))
    result = parser.scan(%q[string IS NOT NULL])
    assert_true(result.eval(record))
  end

  def test_logical_op
    result = parser.scan(%q[boolean = true AND string = 'string'])
    assert_true(result.eval(record))
    result = parser.scan(%q[boolean = true OR string = 'foobar'])
    assert_true(result.eval(record))
  end

  def test_negate_op
    result = parser.scan(%q[NOT boolean = true])
    assert_false(result.eval(record))
  end
end

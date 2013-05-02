# Literal Node of AST (Abstract Syntax Tree)
require 'time'

module Fluent
  module FilterWhere
    class ParserLiteral
      attr_reader :text
      attr_reader :val

      def get(record)
        @val
      end
    end

    class BooleanLiteral < ParserLiteral
      def initialize(text)
        @text = text
        if text.downcase == 'true'.freeze
          @val = true
        elsif text.downcase == 'false'.freeze
          @val = false
        else
          raise ConfigError.new("\"%s\" is not a Boolean literal" % text)
        end
      end
    end

    class NumberLiteral < ParserLiteral
      def initialize(text)
        @text = text
        @val = Float(text)
      end
    end

    class StringLiteral < ParserLiteral
      def initialize(text)
        @text = text
        @val = text
      end
    end

    class TimestampLiteral < ParserLiteral
      def self.default_timezone
        "UTC"
      end

      def initialize(literal)
        case literal
        when StringLiteral
          initializeWithStringLiteral(literal)
        when NumberLiteral
          initializeWithNumberLiteral(literal)
        when TimestampLiteral
          initializeWithTimestampLiteral(literal)
        else
          raise ArgumentError.new("\"%s\" is not a Timestamp literal" % literal.text)
        end
      end

      if defined?(EventTime)
        Time = ::Fluent::EventTime
      else
        Time = ::Time
      end

      def initializeWithStringLiteral(literal)
        @text = literal.text
        @val = Time.parse(literal.val)
      end

      def initializeWithNumberLiteral(literal)
        @text = literal.text
        @val = Time.new(literal.val) # ToDo: Do not convert to float and use Fluent::EventTime.new(sec, nsec)
      end

      def initializeWithTimestampLiteral(literal)
        @text = literal.text
        @val = literal.val
      end
    end

    class IdentifierLiteral < ParserLiteral
      attr_reader :name

      def initailize(name)
        @name = name
      end

      def get(record)
        record[@name]
      end
    end
  end
end

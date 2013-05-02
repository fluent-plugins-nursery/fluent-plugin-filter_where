# Operation Node of AST (Abstract Syntax Tree)
module Fluent
  module FilterWhere
    class  ParserExp
      def eval(record)
        raise NotImplementedError
      end
    end

    class BinaryOpExp < ParserExp
      attr_reader :left, :right, :operator

      # @param [ParserLiteral] left
      # @param [ParserLiteral] right
      # @param [Symbol] operator
      def initailize(left, right, operator)
        @left = left
        @right = right
        @operator = operator
      end
    end

    class BooleanOpExp < BinaryOpExp
      # @return [Boolean]
      def eval(record)
        l = left.get(record)
        r = right.get(record)
        case operator
        when :EQ
          l == r
        when :NEQ
          l != r
        else
          assert(false)
          false
        end
      end
    end

    class NumberOpExp < BinaryOpExp
      # @return [Boolean]
      def eval(record)
        l = left.get(record)
        r = right.get(record)
        case operator
        when :EQ
          l == r
        when :NEQ
          l != r
        when :GT
          l > r
        when :GE
          l >= r
        when :LT
          l < r
        when :LE
          l <= r
        else
          assert(false)
          false
        end
      end
    end

    class TimestampOpExp < BinaryOpExp
      def initialize(lef, right, operator)
        @left = left.is_a?(IdentifierLiteral) ? left : TimestampLiteral.new(left)
        @right = right.is_a?(IdentifierLiteral) ? right : TimestampLiteral.new(right)
        @operator = operator
      end

      def eval(record)
        l = left.get(record)
        r = right.get(record)
        case operator
        when :EQ
          l == r
        when :NEQ
          l != r
        when :GT
          l > r
        when :GE
          l >= r
        when :LT
          l < r
        when :LE
          l <= r
        else
          assert(false)
          false
        end
      end
    end

    class StringOpExp < BinaryOpExp
      def eval(record)
        l = left.get(record)
        r = right.get(record)
        case operator
        when :EQ
          l == r
        when :NEQ
          l != r
        when :GT
          l > r
        when :GE
          l >= r
        when :LT
          l < r
        when :LE
          l <= r
        when :START_WITH
          l.start_with?(r)
        when :END_WITH
          l.end_with?(r)
        when :INCLUDE
          l.include?(r)
        else
          assert(false)
          false
        end
      end
    end

    class RegexpOpExp < BinaryOpExp
      attr_reader :pattern

      def initailize(left, right, operator)
        super(left, right, operator)
        @pattern = Regexp.compile(right.val)
      end

      def eval(record)
        l = left.get(record)
        !!@pattern.match(l)
      end
    end

    class NullOpExp < ParserExp
      # @param [ParserLiteral] literal
      # @param [Symbol] operator
      def initialize(literal, operator)
        @literal = literal
        @operator = operator
      end

      # @return [Boolean]
      def eval(record)
        is_null = literal.get(record).nil?
        case operator
        when :EQ
          is_null
        when :NEQ
          ! is_null
        else
          assert(false)
          false
        end
      end
    end

    class LogicalOpExp < ParserExp
      # @param [ParserLiteral] left
      # @param [ParserLiteral] right
      # @param [Symbol] operator
      def initialize(left, right, operator)
        @left = left
        @right = right
        @operator = operator
      end

      def eval(record)
        l = left.eval(record)
        r = right.eval(record)
        case operator
        when :OR
          return l || r
        when :AND
          l && r
        else
          assert(false)
          false
        end
      end
    end

    class NegateOpExp < ParserExp
      # @param [ParserExp] exp
      def initailize(exp)
        @exp = exp
      end

      def eval(record)
        ! exp.eval(record)
      end
    end
  end
end

#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.5
# from lexical definition file "lib/fluent/plugin/filter_where/parser.rex".
#++

require 'racc/parser'
class Fluent::FilterWhere::Parser < Racc::Parser
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader   :lineno
  attr_reader   :filename
  attr_accessor :state

  def scan_setup(str)
    @ss = StringScanner.new(str)
    @lineno =  1
    @state  = nil
  end

  def action
    yield
  end

  def scan_str(str)
    scan_setup(str)
    do_parse
  end
  alias :scan :scan_str

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_setup(f.read)
    end
  end

  def scan_file( filename )
    load_file(filename)
    do_parse
  end


  def next_token
    return if @ss.eos?
    
    # skips empty actions
    until token = _next_token or @ss.eos?; end
    token
  end

  def _next_token
    text = @ss.peek(1)
    @lineno  +=  1  if text == "\n"
    token = case @state
    when nil
      case
      when (text = @ss.scan(/\(/i))
         action { [:"(", text] }

      when (text = @ss.scan(/\)/i))
         action { [:")", text] }

      when (text = @ss.scan(/\=/i))
         action { [:EQ, text] }

      when (text = @ss.scan(/\<\>/i))
         action { [:NEQ, text] }

      when (text = @ss.scan(/\!\=/i))
         action { [:NEQ, text] }

      when (text = @ss.scan(/\>\=/i))
         action { [:GE, text] }

      when (text = @ss.scan(/\>/i))
         action { [:GT, text] }

      when (text = @ss.scan(/\<\=/i))
         action { [:LE, text] }

      when (text = @ss.scan(/\</i))
         action { [:LT, text] }

      when (text = @ss.scan(/-?[0-9]+(\.[0-9]+)?/i))
         action { [:NUMBER, NumberLiteral.new(text)] }

      when (text = @ss.scan(/[a-zA-Z$][a-zA-z0-9\.\-_]*/i))
         action {
                          case text.downcase
                          when 'and'.freeze
                            [:AND, text]
                          when 'or'.freeze
                            [:OR, text]
                          when 'start_with'.freeze
                            [:START_WITH, text]
                          when 'end_with'.freeze
                            [:END_WITH, text]
                          when 'include'.freeze
                            [:INCLUDE, text]
                          when 'regexp'.freeze
                            [:REGEXP, text]
                          when 'is'.freeze
                            [:IS, text]
                          when 'not'.freeze
                            [:NOT, text]
                          when 'null'.freeze
                            [:NULL, text]
                          when 'true'.freeze
                            [:BOOLEAN, BooleanLiteral.new(text)]
                          when 'false'.freeze
                            [:BOOLEAN, BooleanLiteral.new(text)]
                          else
                            [:IDENTIFIER, IdentifierLiteral.new(text)]
                          end
                        }


      when (text = @ss.scan(/\"/i))
         action { @state = :IDENTIFIER; @string = ''; nil }

      when (text = @ss.scan(/\'/i))
         action { @state = :STRING; @string = ''; nil }

      when (text = @ss.scan(/[ \t]+/i))
         action { }

      when (text = @ss.scan(/\n|\r|\r\n/i))
         action { }

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    when :IDENTIFIER
      case
      when (text = @ss.scan(/\"/i))
         action { @state = nil; [:IDENTIFIER, IdentifierLiteral.new(@string)] }

      when (text = @ss.scan(/[^\r\n\"\\]+/i))
         action { @string << text; nil }

      when (text = @ss.scan(/\\\"/i))
         action { @string << '"'; nil }

      when (text = @ss.scan(/\\\'/i))
         action { @string << "'"; nil }

      when (text = @ss.scan(/\\\\/i))
         action { @string << "\\"; nil }

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    when :STRING
      case
      when (text = @ss.scan(/\'/i))
         action { @state = nil; [:STRING, StringLiteral.new(@string)] }

      when (text = @ss.scan(/[^\r\n\'\\]+/i))
         action { @string << text; nil }

      when (text = @ss.scan(/\b/i))
         action { @string << "\b"; nil }

      when (text = @ss.scan(/\t/i))
         action { @string << "\t"; nil }

      when (text = @ss.scan(/\n/i))
         action { @string << "\n"; nil }

      when (text = @ss.scan(/\f/i))
         action { @string << "\f"; nil }

      when (text = @ss.scan(/\r/i))
         action { @string << "\r"; nil }

      when (text = @ss.scan(/\"/i))
         action { @string << '"'; nil }

      when (text = @ss.scan(/\'/i))
         action { @string << "'"; nil }

      when (text = @ss.scan(/\\/i))
         action { @string << "\\"; nil }

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    else
      raise  ScanError, "undefined state: '" + state.to_s + "'"
    end  # case state
    token
  end  # def _next_token

  def on_error(error_token_id, error_value, value_stack)
    super
  end
end # class

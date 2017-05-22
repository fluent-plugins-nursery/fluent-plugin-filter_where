class Fluent::FilterWhere::Parser
option
  ignorecase
macro
  Number -?[0-9]+(\.[0-9]+)?
  QuotedIdentifierChar [^\r\n\"\\]
  NonQuotedIdentifier [a-zA-Z$][a-zA-z0-9\.\-_]*
  StringChar [^\r\n\'\\]
  Newline \n|\r|\r\n
  Whitespace [\ \t]+
rule
  \(                    { [:"(", text] }
  \)                    { [:")", text] }
  \=                    { [:EQ, text] }
  \<\>                  { [:NEQ, text] }
  \!\=                  { [:NEQ, text] }
  \>\=                  { [:GE, text] }
  \>                    { [:GT, text] }
  \<\=                  { [:LE, text] }
  \<                    { [:LT, text] }

  # number literal
  {Number}              { [:NUMBER, NumberLiteral.new(text)] }

  # identifier literal
  {NonQuotedIdentifier} {
                          # rexical gem does not do longest match, so following rule is wrong
                          # rule
                          #   NOT { [:NOT, text] }
                          #   {NonQuotedIdentifier} { [:IDENTIFIER, text] }
                          # because `nothing` is treated as `not` and `hing`
                          # Because of it, I had to write everything in {NonQuotedIdentifier}

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
  \"                    { @state = :IDENTIFIER; @string = ''; nil }

  # string literal
  \'                    { @state = :STRING; @string = ''; nil }

  {Whitespace}          { }
  {Newline}             { }

:IDENTIFIER   \"                      { @state = nil; [:IDENTIFIER, IdentifierLiteral.new(@string)] }
:IDENTIFIER   {QuotedIdentifierChar}+ { @string << text; nil }
# escape sequences
:IDENTIFIER   \\\"                    { @string << '"'; nil }
:IDENTIFIER   \\\'                    { @string << "'"; nil }
:IDENTIFIER   \\\\                    { @string << "\\"; nil }

:STRING       \'                      { @state = nil; [:STRING, StringLiteral.new(@string)] }
:STRING       {StringChar}+           { @string << text; nil }
# escape sequences
:STRING       \b                      { @string << "\b"; nil }
:STRING       \t                      { @string << "\t"; nil }
:STRING       \n                      { @string << "\n"; nil }
:STRING       \f                      { @string << "\f"; nil }
:STRING       \r                      { @string << "\r"; nil }
:STRING       \"                      { @string << '"'; nil }
:STRING       \'                      { @string << "'"; nil }
:STRING       \\                      { @string << "\\"; nil }

inner
  def on_error(error_token_id, error_value, value_stack)
    super
  end
end

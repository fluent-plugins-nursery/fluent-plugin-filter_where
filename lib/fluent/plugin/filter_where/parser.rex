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
  AND                   { [:AND, text] }
  OR                    { [:OR, text] }
  \=                    { [:EQ, text] }
  \<\>                  { [:NEQ, text] }
  \!\=                  { [:NEQ, text] }
  \>\=                  { [:GE, text] }
  \>                    { [:GT, text] }
  \<\=                  { [:LE, text] }
  \<                    { [:LT, text] }
  START_WITH            { [:START_WITH, text] }
  END_WITH              { [:END_WITH, text] }
  INCLUDE               { [:INCLUDE, text] }
  IS                    { [:IS, text] }
  NOT                   { [:NOT, text] }
  NULL                  { [:NULL, text] }
  TIMESTAMP             { [:TIMESTAMP, text] }

  # boolean literal
  TRUE                  { [:BOOLEAN, BooleanLiteral.new(text)] }
  FALSE                 { [:BOOLEAN, BooleanLiteral.new(text)] }

  # number literal
  {Number}              { [:NUMBER, NumberLiteral.new(text)] }

  # identifier literal
  {NonQuotedIdentifier} { @state = nil; [:IDENTIFIER, IdentifierLiteral.new(text)] }
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

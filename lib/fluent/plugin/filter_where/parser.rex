class Fluent::FilterWhere::Parser
option
  ignorecase
macro
  Number -?[0-9]+(\.[0-9]+)?
  QuotedIdentifierChar [^\r\n\"\\]
  NonQuotedIdentifier [a-zA-Z$][a-zA-z0-9\.\-_]*
  StringChar [^\r\n\'\\]+
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
  \>                    { [:GT, text] }
  \>\=                  { [:GE, text] }
  \<                    { [:LT, text] }
  \<\=                  { [:LE, text] }
  START_WITH            { [:START_WITH, text] }
  END_WITH              { [:END_WITH, text] }
  INCLUDE               { [:INCLUDE, text] }
  IS                    { [:IS, text] }
  NOT                   { [:NOT, text] }
  NULL                  { [:NULL, text] }
  TIMESTAMP             { [:TIMESTAMP, text] }

  # boolean literal
  TRUE                  { [:BOOLEAN, BooleanLiteral.new(true)] }
  FALSE                 { [:BOOLEAN, BooleanLiteral.new(false)] }

  # number literal
  {Number}              { [:NUMBER, NumberLiteral.new(text)] }

  # identifier literal
  {NonQuotedIdentifier} { state = nil; [:IDENTIFIER, IdentifierLiteral.new(text)] }
  \"                    { state = :IDENTIFIER; @string = '' }

  # string literal
  \'                    { state = :STRING; @string = '' }

  {Whitespace}          { }
  {Newline}             { }

:IDENTIFIER   \"                      { state = nil; [:IDENTIFIER, IdentifierLiteral.new(@string)] }
:IDENTIFIER   {QuotedIdentifierChar}+ { @string << text }
# escape sequences
:IDENTIFIER   \\\"                    { @string << '"' }
:IDENTIFIER   \\\'                    { @string << "'" }
:IDENTIFIER   \\\\                    { @string << "\\" }

:STRING       \'                      { state = nil; [:STRING, StringLiteral.new(@string)] }
:STRING       {StringChar}+           { @string << text }
# escape sequences
:STRING       \b                      { @string << "\b" }
:STRING       \t                      { @string << "\t" }
:STRING       \n                      { @string << "\n" }
:STRING       \f                      { @string << "\f" }
:STRING       \r                      { @string << "\r" }
:STRING       \"                      { @string << '"' }
:STRING       \'                      { @string << "'" }
:STRING       \\                      { @string << "\\" }

inner
end

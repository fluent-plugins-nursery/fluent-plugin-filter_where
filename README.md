# fluent-plugin-filter_where

[![Build Status](https://secure.travis-ci.org/sonots/fluent-plugin-filter_where.png?branch=master)](http://travis-ci.org/sonots/fluent-plugin-filter_where)

Fluentd plugin to filter records with SQL-like WHERE statements

## Requirements

See [.travis.yml](.travis.yml)

`fluent-plugin-filter_where` supports both v0.14 API and v0.12 API in one gem.

## Installation

Use RubyGems:

    gem install fluent-plugin-filter_where

## Configuration

- where

    The SQL-like WHERE statements. See [SQL-like Syntax](#sql-like-syntax) for more details.

### Example

```apache
<filter foo.**>
  @type where
  where string_key = 'string' OR number_key >= 0.1
</filter>
```

## SQL-like Syntax

Example:

```sql
where (string_key START_WITH 'str' AND number_key > 1.0) OR ("true_key" = true AND string_key REGEXP '^reg')
```

## Literals

### Boolean Literal

`true` or `TRUE` or `false` or `FALSE` are considered as a boolean literal

### Number Literal

Characters matching with a regular expression `-?[0-9]+(\.[0-9]+)?` is considered as a number literal

### String Literal

Characters surrounded by `'` such as `'foo'` is considered as a string literal

### Json Literal

Not supported yet

### Identifier Literal

Characters matching with a regular expression `[a-zA-Z_][a-zA-z0-9_]*` such as `foobar`, and characters surrounded by `"` such as `"foo-bar"`, `"foo.bar"`, and `"foo\"bar"` are considred as an identifier literal, that is, embulk's column name.

## Operators

### Boolean Operator

* `=`
* `!=`

### Number Operator (Long and Double)

* `=`
* `!=`
* `>`
* `>=`
* `<=`
* `<`

### String Operator

* `=`
* `!=`
* `START_WITH`
* `END_WITH`
* `INCLUDE`
* `REGEXP`

### Json Operator

Not supported yet

### unary operator

* "xxx IS NULL"
* "xxx IS NOT NULL"
* "NOT xxx"

## ChangeLog

See [CHANGELOG.md](CHANGELOG.md) for details.

## Development

Run test:

```
$ bundle exec rake test
```

Release:

Modify gemspec and CHANGELOG.md, then

```
$ bundle exec rake release
```

## Development of SQL-like Syntax

This plugin uses [rexical](https://github.com/tenderlove/rexical) for lexical scanner generator, and [racc](https://github.com/tenderlove/racc) for parser generator.

If you modify `praser.rex` or `praser.racc`, you must compile them as:

```
$ bundle exec rake compile
```

The `test` task runs the `compile` task before running.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2017 - Naotoshi Seo. See [LICENSE](LICENSE) for details.

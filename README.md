# SystemSettings
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'system_settings'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install system_settings
```
## Development

`5.0.7.2`, `5.1.7`, `5.2.3`, `6.0.0.rc1`

`RAILS_VERSION=5.0.7.2 SQLITE3_VERSION=1.3.13 ./bin/rails app:db:drop app:db:create app:db:migrate app:db:test:prepare test`
`RAILS_VERSION=5.1.7 SQLITE3_VERSION=1.4.1 ./bin/rails app:db:drop app:db:create app:db:migrate app:db:test:prepare test`
`RAILS_VERSION=5.2.3 SQLITE3_VERSION=1.4.1 ./bin/rails app:db:drop app:db:create app:db:migrate app:db:test:prepare test`
`RAILS_VERSION=6.0.0.rc1 SQLITE3_VERSION=1.4.1 ./bin/rails app:db:drop app:db:create app:db:migrate app:db:test:prepare test`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

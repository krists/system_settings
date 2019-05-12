# System Settings
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

Required development dependencies:
* [Node.js](https://nodejs.org/) - JavaScript runtime
* [Yarn](https://yarnpkg.com/) - package manager

Optional development tools:
* [overmind](https://github.com/DarthSim/overmind) - Process manager for Procfile-based applications and tmux
* [direnv](https://direnv.net/) - Unclutter your .profile 

Required environment variables:
* `RAILS_VERSION`
* `SQLITE3_VERSION`

As System Settings gem is being developed to be compatible with multiple [rails](https://github.com/rails/rails),
you need to set `RAILS_VERSION` and `SQLITE3_VERSION` environment variables when running `bundle install` or any `./bin/rails` command.
It is recommended to set these up using [direnv](https://direnv.net/) and `.envrc` file.


Getting started with development:
1) `RAILS_VERSION=5.2.3 SQLITE3_VERSION=1.4.1 bundle`
2) `RAILS_VERSION=5.2.3 SQLITE3_VERSION=1.4.1 ./bin/rails db:create db:migrate`
3) `RAILS_VERSION=5.2.3 SQLITE3_VERSION=1.4.1 ./bin/rails test`
4) `RAILS_VERSION=5.2.3 SQLITE3_VERSION=1.4.1 ./bin/rails frontend:install`
4) `RAILS_VERSION=5.2.3 SQLITE3_VERSION=1.4.1 ./bin/rails app:system_settings:load`
4) `RAILS_VERSION=5.2.3 SQLITE3_VERSION=1.4.1 overmind start`


## Build status
SystemSettings is being tested with Rails versions - `5.0`, `5.1`, `5.2`, `6.0`, `rails repo master branch`

[![Build Status](https://dev.azure.com/kristsozols/System%20Settings/_apis/build/status/krists.system_settings?branchName=master)](https://dev.azure.com/kristsozols/System%20Settings/_build/latest?definitionId=1&branchName=master)


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

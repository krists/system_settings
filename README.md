# System Settings
System Settings is a Rails engine that adds settings functionality.

Initial setting values can be loaded from file and later edited in a System Settings provided admin panel.


## Getting started
Add this line to your application's Gemfile:

```ruby
gem 'system_settings'
```

And then execute:
```bash
$ bundle
```

Copy migrations:
```bash
$ bin/rails system_settings:install:migrations
```

And then run the migrations:
```bash
$ bin/rails db:migrate
```

Create settings file where all settings will be defined:
```bash
$ touch config/system_settings.rb
```

Add your first setting to `config/system_settings.rb`:
```ruby
# String type values
string :default_mail_from, value: "Example Company <noreply@example.com>", description: "This email will be used for all outgoing emails"
string :date_format, value: "%Y-%m-%d"
string :default_locale, value: "en"

# Integer type values
integer :default_records_per_page, value: 25
integer :remainder_interval_in_hours, value: 48

# Array type strings and integers
string_list :admin_emails, description: "Will receive alerts"
string_list :upload_allowed_extensions, value: ["docx", "pdf", "txt"]
integer_list :lucky_numbers, description: "Prime numbers are more effective", value: [2, 3, 5, 11]
```

Load values from `config/system_settings.rb` into database:
```bash
$ ./bin/rails system_settings:load
```

Add System Settings admin panel to Rails routes:
```ruby
Rails.application.routes.draw do
  mount SystemSettings::Engine, at: "/system_settings"
  # rest of your routes..
end
```

Final step. Access settings values anywhere in your code:
```ruby
SystemSettings[:date_format] # => "%Y-%m-%d"
SystemSettings[:lucky_numbers] # => [2, 3, 5, 11]

# You can change setting's value like any other Rails model.
SystemSettings::Setting.find_by(name: "default_mail_from").update({value: "No-Reply <noreply@example.com>"})
```


## Do not forget!
Before using System settings in production please protect the `/system_settings` endpoint with routing constraint. You can read more about it in [Rails Guides: Rails Routing from the Outside In](https://guides.rubyonrails.org/routing.html#advanced-constraints)

```ruby
Rails.application.routes.draw do
  mount SystemSettings::Engine, at: "/system_settings", constraints: AdminRoutingConstraint.new
  # rest of your routes..
end
```


## Few more things

When you run `./bin/rails system_settings:load` task it will read `config/system_settings.rb` file and add new entries to the database. If you would like to replace all values with the ones from the file then run `./bin/rails system_settings:reset` 

System Settings admin panel is precompiled at gem's build time. So it does not require any Javascript runtime and can be used with api-only Rails applications.

If you would like to store your settings somewhere else than `config/system_settings.rb` you can use ENV variable `SYSTEM_SETTINGS_PATH` to specify custom path.


## Using System Settings in tests

Your test suite probably clears database before/after every test example. Fortunately is very easy to load fresh settings from configuration file.
It can be done by running `SystemSettings.load`. It will persist all loaded settings. But if you would like to persist only a subset of loaded settings run `SystemSettings.load(:one, :two, :three)`.

And if you modify settings values in test example you can reset to defaults with `SystemSettings.reset_to_defaults`.


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

As System Settings gem is being developed to be compatible with multiple [Rails](https://github.com/rails/rails) versions,
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
System Settings is being tested with Rails versions - `5.0`, `5.1`, `5.2`, `6.0`, `rails repo master branch`

[![Build Status](https://dev.azure.com/kristsozols/System%20Settings/_apis/build/status/krists.system_settings?branchName=master)](https://dev.azure.com/kristsozols/System%20Settings/_build/latest?definitionId=1&branchName=master)


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

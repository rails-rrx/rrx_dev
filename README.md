# RRXDev

Opinionated core development dependencies and configuration for Ruby on Rails projects

## Installation

To create a new app or gem, use the `rrx_rails` command.

```shell
gem install rrx_rails
rrx_rails help
```

To add `rrx_dev` to an existing Ruby on Rails application or gem:

```shell
bundle add rrx_dev --group "development, test"
```

Then run the generator to set up the project:

```shell
bundle exec rails g rrx_dev:install
```

If you intend to use Swagger for API documentation, you can also run:

```shell
bundle exec rails g rrx_dev:swagger
```

## Usage

TODO

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dan-drew/rrx_dev. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/dan-drew/rrx_dev/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RrxDev project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dan-drew/rrx_dev/blob/main/CODE_OF_CONDUCT.md).

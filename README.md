# Bchess

Why bchess? Becasue BChess love chess :)

## Installation

Standard instalation. Add this line to your application's Gemfile:

```ruby
gem 'bchess'
```
And then execute:
    $ bundle

Or install it yourself as:
    $ gem install bchess

## Usage

### Reading chess game from the file

Parsing a game file
```ruby
file = Bchess::PGN::PGNFile.new('./games_to_read.pgn')
parser = Bchess::PGN::Parser.new(file)
parsed_games = parser.parse
```

If the file is invalid you will get an error. Otherwise you'll receive an array of games containing games headers and moves in proper order.

Validating game on the board

```ruby
parsed_game = parser.parse.first
Bchess::PGN::Game.new(parsed_game)

## Getting moves
game.convert_body_to_moves

## Accessing headers
game.header.player_white

```

### Testing
Due to the nature of the gem I tested it on a large amount of games to make sure it covers all or almost all edgecases. Full tests take a lot of time, so you can run a basic test with test.sh script. If you want to run the full suite the run full_test.sh or just rspec spec. 


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/visualitypl/bchess. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bchess project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/bchess/blob/master/CODE_OF_CONDUCT.md).

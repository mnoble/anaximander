[![TravisCI](https://travis-ci.org/mnoble/anaximander.svg?branch=master)](https://travis-ci.org/mnoble/anaximander) &nbsp;
[![CodeClimate](https://codeclimate.com/github/mnoble/anaximander.png)](https://codeclimate.com/github/mnoble/anaximander)

# Anaximander

Anaximander is a small library for crawling a website and rendering the
resulting site map to the console.

## Installation &amp; Usage

```sh
gem install anaximander
```

```sh
mapgen <url>
```

## Example Site

```sh
mapgen http://anaximander.herokuapp.com/index.html
```

## Running Tests

```sh
bundle install
bundle exec rspec spec
```

### End to End Tests

There are two tests marked with the tag `endtoend`. These tests start up
a Rack app which serves a simple website and run against that server
like the library would in "production". Think of them as the Acceptance
tests for a library.

The end to end tests are run by default. To exclude them:

```sh
bundle exec rspec spec --tag ~endtoend
```

## What does Anaximander mean?

Anaximander was a Greek cartographer who was the first person to try to
map the entire world.

## Contributing

1. Fork it ( https://github.com/mnoble/anaximander/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

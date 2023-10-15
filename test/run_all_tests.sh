#!/bin/bash
set -e

cd /src/test

# Install test dependencies
bundle config --global silence_root_warning 1
bundle install

# Run all the tests
bundle exec rake

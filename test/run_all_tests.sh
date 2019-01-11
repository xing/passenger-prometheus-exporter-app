#!/bin/bash
set -e

cd /src/test

# Install test dependencies
bundle config --global silence_root_warning 1
bundle install

# Run all the tests
for file in tests/*_test.rb; do bundle exec ruby $file; done

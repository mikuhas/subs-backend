ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# Bootsnap is not compatible with Ruby 4.0, so we conditionally load it
if RUBY_VERSION < "4.0"
  require "bootsnap/setup" # Speed up boot time by caching expensive operations.
end

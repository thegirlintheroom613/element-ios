source "https://rubygems.org"

gem "xcode-install", ">= 2.6.6"
gem "fastlane", "~> 2.156.0"
gem "cocoapods", '~>1.9.3'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)

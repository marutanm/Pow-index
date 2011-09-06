# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "pow-index"
  gem.homepage = "http://github.com/marutanm/pow-index"
  gem.license = "MIT"
  gem.summary = "Create index page of 37signals-Pow"
  gem.description = "Create index page of 37signals-Pow"
  gem.email = "marutanm@gmail.com"
  gem.authors = ["marutanm"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

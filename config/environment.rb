# Load the rails application
require File.expand_path('../application', __FILE__)
#config.gem 'paperclip', :source => 'http://gemcutter.org'
# Initialize the rails application
ENV['RAILS_ENV'] ||= 'production'
Paperclip.options[:command_path] = "C:\Archivos de programa"
Acbro::Application.initialize!

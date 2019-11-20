require 'nokogiri'
require 'open-uri'
require 'pry'
require 'rubygems'
require 'rubygems/gem_runner'
require 'rubygems/exceptions'
require 'mechanize'
require 'zlib'
require 'byebug'
require 'date'
require 'bundler/inline'
require 'colorize'
require 'colorized_string'
class App
    def install(lib)
        begin
          Gem::GemRunner.new.run ['install', lib]
        rescue Gem::SystemExitException => e
        end
      end
    def bundler
            install 'nokogiri'
            install 'pry'
            install 'mechanize'
            install 'byebug'
            install 'date'
            install 'colorize'
    end
end
puts "Installing required dependencies"

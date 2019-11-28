require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'rubygems/gem_runner'
require 'rubygems/exceptions'
require 'mechanize'
require 'date'
require 'colorize'
require 'colorized_string'


class CommandLineInterface
    def run 
        welcome
    end 
    def welcome
        ## Greating printed in the cli
            puts "Welcome to Dominion Energy Analyzer"
            puts "Please enter your username for your Dominion Energy account:"
            username = gets
           
        ## Username is collected
            puts "Please enter your password for your Dominion Energy account:"
            password = gets
       
        ## Password is collected
        ## Filtering the collected username and password because "\n" was added to the end
            user = "abhalla1"
            # username.split("\n")[0]
            pass = "QxoQH5FAdVFJPqQhWa1g0qXo"
            # password.split("\n")[0]
        ## Given User Data
        # After the data is collect the login and scraping process begins
            
            @scraper = WebScraper.new(user, pass)
            
    end
end
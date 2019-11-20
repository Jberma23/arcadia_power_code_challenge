class CommandLineInterface
    def run 
        welcome
    end 
    def welcome
        ## Greating printed in the cli
            puts "Welcome to Dominion Energy Analyzer"
            puts "Please enter your username for your Dominion Energy account:".colorize(:white)
            username = gets
        ## Username is collected
            puts "Please enter your password for your Dominion Energy account:".colorize(:white)
            password = gets
        ## Password is collected
        ## Filtering the collected username and password because "\n" was added to the end
            user = username.split("\n")[0]
            pass = password.split("\n")[0]
        ## Given User Data
        # After the data is collect the login and scraping process begins
            @scraper = WebScraper.new(user, pass)
            
    end
end
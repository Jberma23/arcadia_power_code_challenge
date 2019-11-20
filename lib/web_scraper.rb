require_relative 'app.rb'

class WebScraper
    AGENT = Mechanize.new
    USER_DATA = {"Billing" => {}, "Service Info" => {}}
        def initialize(username, password)
            @username = username
            @password = password
            login(@username, @password)
        end    

        def login(username, password)
            # Getting login page
                login_page = AGENT.get('https://mydom.dominionenergy.com/siteminderagent/forms/login.fcc?TYPE=33554433&REALMOID=06-b1426164-283c-487c-b4ad-645d5f3e03af&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=FTym4CzlYxlWQmppoRodMtOB72IsaekMnbsUs4TpBqmjxyc89Akr5Hrundmzou72&TARGET=-SM-https%3a%2f%2fmydom%2edominionenergy%2ecom%2f')
            # Collecting login form
                form = login_page.forms.first
            # Setting the value of the username and password fields and submit the login
                form["USER"] = username
                form["PASSWORD"] = password
                result = form.submit
            # Printing the http code to make sure we are successfully logged in
                if result.code == "200"
                    puts "              "
                    puts  "Login Sucessful".colorize(:green)
                    puts "_________________________"
                    HomePage()
                else 
                    puts "something may have gone wrong while logging in. Please try again"
                end
        end

        def HomePage
            # collecting home_page and setting it to a variable
                home_page = AGENT.get('https://mya.dominionenergy.com/')
            # Found the elements we needed using css tags and grabbed the corrct ones then added each to billing section of user data with appropriate labels
            # Several of the elements collected needed to be formatted so I created helper method for ones that could be reused
                USER_DATA["Billing"]["Total Amount Due By"] = home_page.css("p")[0].text.split("\r\n")[1].gsub("                 ", "")
                USER_DATA["Billing"]["Total Amount Due"] = formatHomePage(home_page.css("p"), 1)
                USER_DATA["Billing"]["Last Payment Received On Date"] = formatHomePage(home_page.css("p"), 2)
                USER_DATA["Billing"]["Last Payment Received Amount"] = formatHomePage(home_page.css("p"), 3)
                USER_DATA["Billing"]["Current Charges Billed On"] = Date.parse(formatHomePage(home_page.css("p"), 4)).strftime("%m/%d/%Y")
                USER_DATA["Billing"]["Current Charges Billed Amount"] = formatHomePage(home_page.css("p"), 5)
                USER_DATA["Billing"]["Next Bill Date"] = formatHomePage(home_page.css("p"), 6)
                usageData()
        end
        def usageData
            # Getting detailed usage page
                detailed_usage_page = AGENT.get('https://mya.dominionenergy.com/Usage/ViewPastUsage?statementType=4')
            #collected the first row in the usage table after the table heads (e.i. the most recent bill). But this can easily be modified to collect more date ranges
                row = detailed_usage_page.css("tr")[2]
            #Formatting the dates taken so that they are in the ("Month/Day/Year") format
                rawDate =  Date.strptime(formatDate(row.text.split("\r\n")[2]).split("/")[0] + '/' + formatDate(row.text.split("\r\n")[2]).split("/")[1] + '/' +  formatDate(row.text.split("\r\n")[2]).split("/")[2][2..3], '%m/%d/%y')
            #Collecting the days which represent the duration of this period and subtracting them from the end date to find the correct start day
                days = formatNumber(row.text.split("\r\n")[5]).to_i
            # After finding the date they are formatted and added to the user data hash  in the service info section using appropriate labels
                USER_DATA["Service Info"]["Service-end-date"] = rawDate.strftime("%m/%d/%Y")
                USER_DATA["Service Info"]["Service-start-date"] = (rawDate - days).strftime("%m/%d/%Y")
                USER_DATA["Service Info"]["Usage"] = "#{formatNumber(row.text.split("\r\n")[14])} (kWh)"
                OutputUserData()
        end

        def OutputUserData
            #outputting user data
                puts "        "   
                puts "Data:"
                puts "        "
                puts "Service Start date:" + " " + "#{USER_DATA["Service Info"]["Service-start-date"]}".colorize(:red)
                puts "        "
                puts "Service End date:" + " " + "#{USER_DATA["Service Info"]["Service-end-date"]}".colorize(:red)
                puts "        "
                puts "Usage:" + " " + "#{USER_DATA["Service Info"]["Usage"]}".colorize(:red)
                puts "        "
                puts "Bill Amount:" + " " + "#{USER_DATA["Billing"]["Current Charges Billed Amount"]}".colorize(:red)
                puts "        "
            #I belive this is the bill due date you mean because it is Current Charges Billed On date 
                puts "Bill Due Date:" + " " + "#{USER_DATA["Billing"]["Current Charges Billed On"]}".colorize(:red)
        end


        private
            #Helper Methods      
            def formatHomePage(element, num)
            # used to just collect the text from each element needed. Simple but help prevent using the same code repeatedly
                return element[num].text
            end

            def formatDate(string)
            # used to just collect dates form a string using regex looking for integers that match the format "00/00/0000"
                return string.match(/(\d{2}\/\d{2}\/\d{4})/)[0]
            end

            def formatNumber(string)
            # used to just numbers from the billing info using regex looking for integers that fit into this format "00.00"
                return string.gsub(/[^\d.]/, '')
            end

            def formatPrice(string)
            #same as formating number but just adding $
                return "$" + formatNumber(string)
            end
end 
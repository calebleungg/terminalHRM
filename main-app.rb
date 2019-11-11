require "colorize"
require "terminal-table"

# method for displaying tabular information in jobs overview ui
def print_table(rows)
    table = Terminal::Table.new :headings => [
        "Job ID", "Job Title", 
        "Type", "Salary", 
        "# of Openings", "Target Start Date", 
        "Hiring Manager", "Total Applications" 
        ], :rows => rows
    puts table
end

# class for User Inferface used to store methods for displaying application features
class UserInterface 
    
    @@user = ""
    @@company = ""
    @@industry = ""
    @@total_employees = 0

    def self.create_company()
        print "Company Name: "
        @@company = "Coder Academy"#gets.chomp.to_s
        print "Industry: "
        @@industry = "Education" #gets.chomp.to_s
        print "No. of Employees: "
        @@total_employees = 15#gets.chomp.to_i
        print "Your Name: "
        @@user = "Caleb"#gets.chomp.to_s
    end

    def self.header()
        system("clear")
        puts "------ Heich-aR-eM -------\n\n"
        puts "Welcome, #{@@user}\n\n"
        puts "Company Name:     #{@@company}"
        puts "Industry:         #{@@industry}"
        puts "Employee count:   #{@@total_employees}" 
    end


    def self.control_panel()
        puts "Job list [1] Job Management [2] Back [3] Exit [x]"
    end
end

# class specific to Jobs Listing functionality used to store job listings features
class JobsOverview < UserInterface

    @@joblist = {}
    @@open_job_count = 0
    @@table_info = []

    def self.display()
        @@table_info = []
        puts "\nJob Opportunities Overview (Open Positions)\n\n"
        for key, value in @@joblist
            @@table_info.push([key, value[:title], value[:type], value[:salary], value[:openings], value[:start_date], value[:manager], value[:applications] ])
        end
        print_table(@@table_info)
    end

    def self.control_panel()
        puts "\nCreate Job [1], Edit Job Details [2], Manage Job [3], Back [b], Exit [x]"
    end

    def self.create()
        job = {}
        UserInterface.header()
        puts "\n - Create New Jobs -\n\n"
        print "Job Title: "
        job[:title] = gets.chomp.to_s
        print "Employment Tyle: "
        job[:type] = gets.chomp.to_s
        print "Salary (AUD): "
        job[:salary] = gets.chomp.to_s
        print "# of Openings: "
        job[:openings] = gets.chomp.to_s
        print "Target Start Date: "
        job[:start_date] = gets.chomp.to_s
        print "Hiring Manager: "
        job[:manager] = gets.chomp.to_s
        job[:applications] = 0
        @@joblist.store("100#{@@open_job_count}", job)
        @@open_job_count += 1 
    end

    def self.edit()
        UserInterface.header()
        self.display()
        print "Enter Job ID: "
        id = gets.chomp.to_s
        puts "Select field to edit:"
        puts "Job Title [1], Employment Type [2], Salary [3], # of Openings [4], Target Start Date [5], Hiring Manager [6]"
        option = gets.chomp.to_s
        print "Change to: "
        case option
        when "1"
            @@joblist[id][:title] = gets.chomp.to_s
        when "2"
            @@joblist[id][:type] = gets.chomp.to_s
        when "3"
            @@joblist[id][:salary] = gets.chomp.to_s
        when "4"
            @@joblist[id][:openings] = gets.chomp.to_s
        when "5"
            @@joblist[id][:start_date] = gets.chomp.to_s
        when "6"
            @@joblist[id][:manager] = gets.chomp.to_s
        end
    end

end


# main script
system("clear")

puts "Welcome to Heich-aR-Em"
puts "Please enter your company details,\n\n"

UserInterface.create_company()

app_on = true 
while app_on
    system("clear")
    UserInterface.header()

    JobsOverview.display()

    JobsOverview.control_panel()

    option = gets.chomp.to_s
    case option
    when "1"
        JobsOverview.create()
    when "2"
        JobsOverview.edit()
    when "x"
        system("clear")
        app_on = false
    end
end
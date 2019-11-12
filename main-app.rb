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
    @@open_job_count = 4
    @@table_info = []

    def self.display()
        @@table_info = []
        puts "\nJob Opportunities Overview (Open Positions)\n\n"
        puts "Total Listings: #{@@joblist.length}"
        for key, value in @@joblist
            @@table_info.push([key, value.title, value.type, value.salary, value.openings, value.start_date, value.manager, value.applications])
        end
        print_table(@@table_info)
    end

    def self.control_panel()
        puts "\nCreate Job [1], Edit Job Details [2], Manage Job [3], Exit [x]"
    end

    def self.joblist()
        @@joblist
    end

    def self.open_job_count()
        @@open_job_count
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
        job[:salary] = gets.chomp.to_i
        print "# of Openings: "
        job[:openings] = gets.chomp.to_i
        print "Target Start Date: "
        job[:start_date] = gets.chomp.to_s
        print "Hiring Manager: "
        job[:manager] = gets.chomp.to_s
        job[:applications] = 0
        @@joblist.store("100#{@@open_job_count}", JobManager.new("100#{@@open_job_count}", job[:title], job[:type], job[:salary], job[:openings], job[:start_date], job[:manager]))
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
            @@joblist[id].title = gets.chomp.to_s
        when "2"
            @@joblist[id].type = gets.chomp.to_s
        when "3"
            @@joblist[id].salary = gets.chomp.to_s
        when "4"
            @@joblist[id].openings = gets.chomp.to_s
        when "5"
            @@joblist[id].start_date = gets.chomp.to_s
        when "6"
            @@joblist[id].manager = gets.chomp.to_s
        end
    end

end

# class for Managing selected job
class JobManager < JobsOverview
    attr_accessor :title, :type, :salary, :openings, :start_date, :manager, :applications, :cumulative
    attr_accessor :candidate_pool, :applied_pool, :contacted_pool, :screened_pool, :shortlisted_pool, :interview_pool, :offer_pool, :accepted_pool

    def initialize(id, title, type, salary, openings, start_date, manager)
        @candidate_pool = []

        @applied_pool = []
        @contacted_pool = []
        @screened_pool = []
        @shortlisted_pool = []
        @interview_pool = []
        @offer_pool = []
        @accepted_pool = []

        @id = id
        @title = title
        @type = type
        @salary = salary
        @openings = openings
        @start_date = start_date
        @manager = manager
        @applications = 0

        @cumulative = []

    end

    def self.add_applied(name)
        @applied_pool.push(name)
    end


    def self.header_ui(id, job)
        system("clear")
        puts "------ Heich-aR-eM -------\n\n"
        puts "Job ID:           #{id}"
        puts "Job Title:        #{job.title}"
        puts "Type:             #{job.type}"
        puts "Salary:           #{job.salary}"
        puts "# of Openings:    #{job.openings}"
        puts "Start Date:       #{job.start_date}"
        puts "Reporting to:     #{job.manager}\n\n"
    end

    def self.progress_bar(job) 
        job.cumulative = []
        if job.candidate_pool.length == 0
            x = 0
        else
            x = job.candidate_pool.length
        end
        until x == 0
            x.times { job.cumulative.push(["", "", "", "", "", "", ""]) }
            for i in job.applied_pool
                job.cumulative[x-1][0] = i
                x -= 1
            end
        end

        table = Terminal::Table.new :headings => [
            "Applied [a] - (#{job.applied_pool.length})", "Contacted [c]", 
            "Screened [s]", "Shortlisted [sl]", 
            "Interview [i]", "Offer [o]", 
            "Accepted [a]" 
            ], :rows => job.cumulative 
        puts table
    
    end

    def self.control_panel()
        puts "\nCreate Candidate [1], View Candidate [2], Progress Candidate [3], Schedule Interview [4], Offer Candidate [5], Back [b]"
    end

    def self.option()
        option = gets.chomp.to_s
        return option
    end

end

# class for Candidate creation and management
class Candidate
    attr_reader :name, :occupation, :email, :number, :address
    attr_accessor :status    

    def initialize(name, occupation, email, number, address) 
        @name = name
        @occupation = occupation
        @email = email
        @number = number
        @address = address
        @status = "Applied"
    end

    def self.create(job)
        puts "Enter candidate details,"
        print "Name: "
        name = gets.chomp.to_s
        print "Occupation: "
        occupation = gets.chomp.to_s
        print "Email: "
        email = gets.chomp.to_s
        print "Number: "
        number = gets.chomp.to_s
        print "Address: "
        address = gets.chomp.to_s
        candidate = Candidate.new(name, occupation, email, number, address)
        job.candidate_pool.push(candidate)
        job.applied_pool.push(candidate.name)
        job.applications += 1
    end

    def self.view(job)
        puts "- View Candidate -"
        print "Enter name: "
        name = gets.chomp.to_s
        for i in job.candidate_pool
            if i.name == name
                puts "=============================="
                puts "Details"
                puts "=============================="
                puts "Status:       #{i.status}"
                puts "Occupation:   #{i.occupation}"
                puts "Email:        #{i.email}"
                puts "Number:       #{i.number}"
                puts "Address:      #{i.address}"
                puts "\nPress Enter to return."
                gets
                return
            end
        end
        puts "Couldnt find candidate..."
        sleep 2
    end

end


# entering dummy jobs for testing
job1 = JobManager.new("1000", "Store Manager", "Permanent - Full Time", "70,000", 1, "30/11/19", "Jody Foster")
job2 = JobManager.new("1001", "Stock Filler", "Casual - Part Time", "24.50/hour", 3, "15/12/19", "Andy Lee")   
job3 = JobManager.new("1002", "Floor Assistant", "Casual - Part Time", "24.50/hour", 2, "15/12/19", "Charles Dickens")   
job4 = JobManager.new("1003", "Senior Butcher", "Permanent - Full Time", "65,000", 1, "27/11/19", "Shingo Nakamura")  

JobsOverview.joblist.store("1000", job1)
JobsOverview.joblist.store("1001", job2)
JobsOverview.joblist.store("1002", job3)
JobsOverview.joblist.store("1003", job4)


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
    when "3"
        print "Enter Job ID: "
        id = gets.chomp.to_s
        manage = true
        while manage
            JobManager.header_ui(id, JobsOverview.joblist[id])
            JobManager.progress_bar(JobsOverview.joblist[id])
            JobManager.control_panel()
            x = gets.chomp.to_s
            case x
            when "1"
                Candidate.create(JobsOverview.joblist[id])
            when "2"
                Candidate.view(JobsOverview.joblist[id])
            when "b"
                manage = false
            end
        end
    when "x"
        system("clear")
        app_on = false
    end
end
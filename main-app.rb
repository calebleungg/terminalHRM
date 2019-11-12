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

    # method for creating company when initialising application
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

    # method for displaying company information as the header display 
    def self.header()
        system("clear")
        puts "------ Heich-aR-eM -------\n\n"
        puts "Welcome, #{@@user}\n\n"
        puts "Company Name:     #{@@company}"
        puts "Industry:         #{@@industry}"
        puts "Employee count:   #{@@total_employees}" 
    end

end

# class specific to Jobs Listing functionality used to store job listings features
class JobsOverview < UserInterface

    @@joblist = {}
    @@open_job_count = 4
    @@table_info = []

    # class method for displaying tabular job listing information
    def self.display()
        @@table_info = []
        puts "\nJob Opportunities Overview (Open Positions)\n\n"
        puts "Total Listings: #{@@joblist.length}"
        for key, value in @@joblist
            @@table_info.push([key, value.title, value.type, value.salary, value.openings, value.start_date, value.manager, value.applications])
        end
        print_table(@@table_info)
    end

    # class method for displaying control panel 
    def self.control_panel()
        puts "\nCreate Job [1], Edit Job Details [2], Manage Job [3], Exit [x]"
    end

    # method for accessing job list 
    def self.joblist()
        @@joblist
    end

    # method for accessing job_count 
    def self.open_job_count()
        @@open_job_count
    end

    # method for creating a job opportunity
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

    # method for editing a job opportunity information
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
    attr_accessor :title, :type, :salary, :openings, :start_date, :manager, :applications, :cumulative, :column_count, :interview_log
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

        @column_count = [
            @applied_pool.length, @contacted_pool.length, 
            @screened_pool.length, @shortlisted_pool.length, 
            @interview_pool.length, @offer_pool.length, @accepted_pool.length
        ]

        @id = id
        @title = title
        @type = type
        @salary = salary
        @openings = openings
        @start_date = start_date
        @manager = manager
        @applications = 0

        @cumulative = []

        @interview_log = {}

    end

    # method for pushing new candidate name into the applied candidate pool
    def self.add_applied(name)
        @applied_pool.push(name)
    end

    # method for updating column statistics 
    def self.update_columns(job)
        job.column_count = [
            job.applied_pool.length, job.contacted_pool.length, 
            job.screened_pool.length, job.shortlisted_pool.length, 
            job.interview_pool.length, job.offer_pool.length, job.accepted_pool.length
        ]
    end

    # method for displaying job information in the header UI
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

    # method for adding candidates in each pool to the tabular display
    def self.add_to_column(pool, column, cumulative)
        counter = 0
        for i in pool
            cumulative[counter][column] = i
            counter += 1
        end
    end

    # method for displaying candidate progression stages in tabular form
    def self.progress_bar(job) 
        JobManager.update_columns(job)
        job.cumulative = []

        x = job.column_count.max
        counter = 0 

        until x == 0
            job.cumulative.push(["", "", "", "", "", "", ""])
            x -= 1 
        end

        JobManager.add_to_column(job.applied_pool, 0, job.cumulative)
        JobManager.add_to_column(job.contacted_pool, 1, job.cumulative)
        JobManager.add_to_column(job.screened_pool, 2, job.cumulative)
        JobManager.add_to_column(job.shortlisted_pool, 3, job.cumulative)
        JobManager.add_to_column(job.interview_pool, 4, job.cumulative)
        JobManager.add_to_column(job.offer_pool, 5, job.cumulative)
        JobManager.add_to_column(job.accepted_pool, 6, job.cumulative)

        table = Terminal::Table.new :headings => [
            "Applied [a] - (#{job.applied_pool.length})", "Contacted [c] - (#{job.contacted_pool.length})", 
            "Screened [s] - (#{job.screened_pool.length})", "Shortlisted [sl] - (#{job.shortlisted_pool.length})", 
            "Interview [i] - (#{job.interview_pool.length})", "Offer [o] - (#{job.offer_pool.length})", 
            "Accepted [y] - (#{job.accepted_pool.length})"
            ], :rows => job.cumulative 
        puts table
    
    end

    def self.schedule_interview(job)
        puts "- Schedule interview - "
        print "Enter Candidate (with correct capitalisation): "
        name = gets.chomp.to_s
        for i in job.candidate_pool
            if i.name == name
                candidate = i
            end
        end
        if job.shortlisted_pool.include?(name) == true 
            print "Enter Interview Date: "
            date = gets.chomp.to_s
            print "Enter Interviewer(s): "
            interviewers = gets.chomp.to_s
            print "Enter Duration: "
            duration = gets.chomp.to_s
            print "Location: "
            location = gets.chomp.to_s
            job.interview_log.store(name, {date: date, interviewers: interviewers, duration: duration, location: location, status: "Booked", notes: "", rating: 0})
            candidate.status = "Interview"
            Candidate.move(name, job.shortlisted_pool, job.interview_pool)
            return
        end
        puts "Candidates need to be shortlisted to be interviewed."
        puts "\nPress Enter to return"
        gets
    end

    def self.display_interview_list(job)
        puts "- Interview Log - "
        puts "------------------------------"
        for key, value in job.interview_log
            puts "Candidate:    #{key}"
            puts "Date:         #{value[:date]}"
            puts "Interviewers: #{value[:interviewers]}"
            puts "Duration:     #{value[:duration]}"
            puts "Location:     #{value[:location]}\n\n"
            puts "Status:       #{value[:status]}"
            puts "Notes:        #{value[:notes]}"
            puts "Rating:       #{value[:rating]}"
            puts "------------------------------"
        end
        puts "\nPress Enter to return"
        gets
    end

    def self.complete_interview(job)
        puts "- Complete Interview - "
        puts "------------------------------"
        puts "Completed interview for,"
        print "Enter Name (with correct capitalisation): "
        name = gets.chomp.to_s
        for key, value in job.interview_log
            if name == key 
                value[:status] = "Completed"
                print "Enter Rating /5: "
                value[:rating] = gets.chomp.to_i
                puts "Additional comments, type below: "
                value[:notes] = gets.chomp.to_s
                return
            end
        end
        puts "Invalid Candidate, please enter name correctly."
        puts "\nPress Enter to return"
        gets
    end

    # method for displaying job management controls
    def self.control_panel()
        puts "\nCreate Candidate [1], View Candidate [2], Progress Candidate [3], Email Candidate [4], Make Note [5]"
        puts "Schedule Interview [6], View Interview Log [7], Complete Interview [8] Back [b]"
    end

end


# class for Candidate creation and management
class Candidate
    attr_reader :name, :occupation, :email, :number, :address
    attr_accessor :status, :notes

    def initialize(name, occupation, email, number, address) 
        @name = name
        @occupation = occupation
        @email = email
        @number = number
        @address = address
        @status = "Applied"
        @notes = {}
    end

    # method for creating a candidate
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

    # method for viewing candidate details
    def self.view(job)
        puts "- View Candidate -"
        print "Enter name: "
        name = gets.chomp.to_s.downcase
        for i in job.candidate_pool
            if i.name.downcase == name
                puts "=============================="
                puts "Details"
                puts "=============================="
                puts "Status:       #{i.status}"
                puts "Occupation:   #{i.occupation}"
                puts "Email:        #{i.email}"
                puts "Number:       #{i.number}"
                puts "Address:      #{i.address}"
                puts "------------------------------"
                puts "Notes: "
                puts "------------------------------"
                for key, value in i.notes
                    puts "Date: #{key}"
                    puts value
                    puts "------------------------------"
                end
                puts "\nPress Enter to return."
                gets
                return
            end
        end
        puts "Invalid Candidate, please enter name correctly."
        puts "\nPress Enter to return"
        gets
    end

    def self.make_note(job)
        puts "- Make Note - "
        print "For (Enter Name): "
        name = gets.chomp.to_s.downcase
        for i in job.candidate_pool
            if i.name.downcase == name
                print "Enter Date: "
                date = gets.chomp.to_s
                puts "Type Note Below, (Press Enter to save)"
                note = gets.chomp.to_s
                i.notes.store(date, note)
                return
            end
        end
        puts "Invalid Candidate, please enter name correctly."
        puts "\nPress Enter to return"
        gets
    end

    # method for moving candidates between pools
    def self.move(candidate, current_stage, new_stage)
        current_stage.delete(candidate)
        new_stage.push(candidate)
    end

    # method for progressing candidate into next stage of recruitment
    def self.progress(job)
        puts "- Select candidate to be progressed -"
        print "Enter Name: "
        name = gets.chomp.to_s
        name_down = name.downcase
        for i in job.candidate_pool
            if i.name.downcase == name_down
                status = i.status
                case status 
                when "Applied"
                    i.status = "Contacted"
                    Candidate.move(i.name, job.applied_pool, job.contacted_pool)
                    return
                when "Contacted"
                    i.status = "Screened"
                    Candidate.move(i.name, job.contacted_pool, job.screened_pool)
                    return
                when "Screened"
                    i.status = "Shortlisted"
                    Candidate.move(i.name, job.screened_pool, job.shortlisted_pool)
                    return
                when "Shortlisted"
                    puts "Candidate must be booked in for interview before progressing"
                    puts "\nPress Enter to return"
                    gets
                    return
                when "Interview"
                    if job.interview_log[name][:status] != "Completed"
                        puts "Interview must be completed before sending offer"
                        puts "\nPress Enter to return"
                        gets
                        return
                    end
                    i.status = "Offered"
                    Candidate.move(i.name, job.interview_pool, job.offer_pool)
                    return
                when "Offered"
                    i.status = "Accepted"
                    Candidate.move(i.name, job.offer_pool, job.accepted_pool)
                    return
                end
            end
        end
        puts "Invalid Candidate, please enter name correctly. "
        puts "\nPress Enter to return."
        gets
        return
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

list1 =[]
list2 =[]
list3 =[]

candidate1 = Candidate.new("James Mackavoy", "Actor", "jmackavoy@gmail.com", "0400 000 111", "81 cresent round India Valley")
candidate2 = Candidate.new("Andrew Simon", "Professional Cricket Player", "ilovecricket@hotmail.com", "0400 000 222", "1/232 complex 3 James Street")
candidate3 = Candidate.new("Steve Jobs", "Apple CEO", "apple@apple.io", "0400 000 333", "100 Edward Street Brisbane City")
candidate4 = Candidate.new("Daniel Napalm", "Student", "daniel.napalm@gmail.com", "0400 000 444", "223 Adelaide Avenue Tasmania")
candidate5 = Candidate.new("Elizabeth Warren", "Politician", "voteforme1@usa.com", "0400 000 555", "8 Court House Road West End")
candidate6 = Candidate.new("Glen Kumar", "Educator at Coder Academy", "gkumar@coderacademy.com", "0400 000 666", "97 Eagle Farm Terrace, Gold Coast")
candidate7 = Candidate.new("Naveen Johnson", "Educator at Coder Academy", "njohnson@coderacademy.com", "0400 000 777", "Homeless")
candidate8 = Candidate.new("Amy Whinehouse", "Singer", "private", "0400 000 888", "91210 Beverly Road California")
candidate9 = Candidate.new("Pepsi Max", "A Soft Drink", "pepsi@co", "04000 000 999", "Everywhere")

list1 << candidate1
list1 << candidate2
list1 << candidate3
list1 << candidate4
list2 << candidate5
list2 << candidate6
list3 << candidate7
list3 << candidate8
list3 << candidate9

for i in list1 
    job1.candidate_pool.push(i)
    job1.applied_pool.push(i.name)
    job1.applications += 1
end
for i in list2
    job2.candidate_pool.push(i)
    job2.applied_pool.push(i.name)
    job2.applications += 1
end
for i in list3
    job3.candidate_pool.push(i)
    job3.applied_pool.push(i.name)
    job3.applications += 1
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
    when "3"
        print "Enter Job ID: "
        check = true
        while check
            id = gets.chomp.to_s
            if JobsOverview.joblist.has_key?(id) == false
                puts "Invalid ID, please enter correct ID."
                print "Enter Job ID:"
            else
                check = false
            end
        end
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
            when "3"
                Candidate.progress(JobsOverview.joblist[id])
            when "5"
                Candidate.make_note(JobsOverview.joblist[id])
            when "6"
                JobManager.schedule_interview(JobsOverview.joblist[id])
            when "7"
                JobManager.display_interview_list(JobsOverview.joblist[id])
            when "8"
                JobManager.complete_interview(JobsOverview.joblist[id])
            when "b"
                manage = false
            end
        end
    when "x"
        system("clear")
        app_on = false
    end
end
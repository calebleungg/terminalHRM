# class used to store job listings level features
class JobsOverview #< UserInterface

    @@joblist = {}
    @@open_job_count = 0
    
    @@table_info = []

    # class method for displaying tabular job listing information
    def self.display()
        # variable reset to ensure changes display
        @@table_info = []
        
        puts "\nJob Opportunities Overview\n\n"
        puts "Total Listings: #{@@joblist.length}"

        # for statement iterating through joblist class variable to organise data
        for key, value in @@joblist
            @@table_info.push([
                key, 
                value.title, 
                value.type, 
                value.salary, 
                value.openings, 
                value.start_date, 
                value.manager, 
                value.applications, 
                value.status
                ]
            )
        end

        # initialising table using terminal-table gem to display @@table_info data
        table = Terminal::Table.new :headings => [
            "Job ID", 
            "Job Title", 
            "Type", 
            "Salary $(AUD)", 
            "# of Openings", 
            "Target Start Date", 
            "Hiring Manager", 
            "Total Applications", 
            "Status" 
            ], :rows => @@table_info
        puts table
    end

    # method for accessing job list 
    def self.joblist()
        @@joblist
    end

    # method for accessing job_count 
    def self.open_job_count()
        @@open_job_count
    end

    # method to increasing job count
    def self.count_job()
        @@open_job_count += 1
    end

    # method for creating a job opportunity
    def self.create()
        # method variable as instance storage
        job = {}
        UserInterface.header()

        # storing user input for new job details
        puts "\n - Create New Jobs -\n\n"
        print "Job Title: "
        job[:title] = gets.chomp.to_s
        print "Employment Tyle: "
        job[:type] = gets.chomp.to_s
        print "Salary (AUD): "
        job[:salary] = gets.chomp.to_s
        print "# of Openings: "
        job[:openings] = gets.chomp.to_i
        print "Target Start Date: "
        job[:start_date] = gets.chomp.to_s
        print "Hiring Manager: "
        job[:manager] = gets.chomp.to_s
        job[:applications] = 0
        job[:status] = "Open"

        # appending info into joblist class variable using job_id as key and a job object instanced by the info above
        @@joblist.store("100#{@@open_job_count}", 
            JobManager.new(
                "100#{@@open_job_count}", 
                job[:title], 
                job[:type], 
                job[:salary], 
                job[:openings], 
                job[:start_date], 
                job[:manager], 
                job[:status]
            )
        )

        # method variable used for saving to yaml file below
        saving = { 
            id: "100#{@@open_job_count}", 
            title: job[:title], 
            type: job[:type],
            salary: job[:salary],
            openings: job[:openings],
            start_date: job[:start_date],
            manager: job[:manager],
            applications: job[:applications],
            status: job[:status]
        }

        # loading yaml file contents into an instanced array
        load_jobs = []
        YAML.load_stream(File.read './info/job_database.yml') { |job| load_jobs << job }

        # if check to skip load sequence if yaml file is empty
        if load_jobs[0] == [nil]
            load_jobs[0] = [saving]
        else
            # if not empty, appenging the 'saving' hash above into the instanced array
            load_jobs[0] << saving
        end

        # writing new instanced array back into the yaml file with new information added
        File.open("./info/job_database.yml", 'w') { |file| file.write(load_jobs[0].to_yaml, file) }

        @@open_job_count += 1 
    end

    # method for editing a job details
    def self.edit()
        UserInterface.header()
        self.display()
        print "Enter Job ID: "
        id = gets.chomp.to_s

        # if statement checking invalid id 
        if JobsOverview.joblist.has_key?(id) == false
            puts "Invalid ID..."
            puts "\nPress Enter to return"
            gets
            return
        end

        prompt = TTY::Prompt.new
        option = prompt.select("Select Option (scroll to display all)", 
            %w(Job_Title Employment_Type Salary #_of_Openings Target_Start_Date Hiring_Manager Status Back))

        # case statement applying changes to selected element from tty-prompt 
        print "Change to: "
        case option
        when "Job_Title"
            change = gets.chomp.to_s
            # chagning selected element in the job object
            @@joblist[id].title = change
            # method for saving edits (see bottom) for job details in yaml file
            JobsOverview.save_edits(id, :title, change)

        when "Employment_Type"
            change = gets.chomp.to_s
            @@joblist[id].type = change
            JobsOverview.save_edits(id, :type, change)

        when "Salary"
            change = gets.chomp.to_s
            @@joblist[id].salary = change
            JobsOverview.save_edits(id, :salary, change)

        when "#_of_Openings"
            change = gets.chomp.to_s
            @@joblist[id].openings = change
            JobsOverview.save_edits(id, :openings, change)

        when "Target_Start_Date"
            change = gets.chomp.to_s
            @@joblist[id].start_date = change
            JobsOverview.save_edits(id, :start_date, change)

        when "Hiring_Manager"
            change = gets.chomp.to_s
            @@joblist[id].manager = change
            JobsOverview.save_edits(id, :manager, change)

        when "Status"
            prompt = TTY::Prompt.new
            answer = prompt.select("Change Status to", %w(Open Pending Closed))

            # changing status is limited to 3 options, a case statement used to select from
            case answer 
            when "Open"
                change = "Open"
                @@joblist[id].status = change
                JobsOverview.save_edits(id, :status, change)
                return
            when "Pending"
                change = "Pending"
                @@joblist[id].status = change
                JobsOverview.save_edits(id, :status, change)
                return
            when "Closed"
                change = "Closed"
                @@joblist[id].status = change
                JobsOverview.save_edits(id, :status, change)
                return
            end
            puts "Invalid input. Press Enter to return"
            gets
            
        when "Back"
            return
        end
    end

    # method for saving edits to information used above
    def self.save_edits(id, element, change)

        # using method variable to load yaml data into
        load_jobs = []
        YAML.load_stream(File.read './info/job_database.yml') { |job| load_jobs << job }

        # for loop to identify and change element with passed in variables
        for i in load_jobs[0]
            if i[:id] == id
                i[element] = change
            end
        end

        # overwriting yaml file with updated method variable
        File.open("./info/job_database.yml", 'w') { |file| file.write(load_jobs[0].to_yaml, file) }
    end


end
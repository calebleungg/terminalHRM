# class specific to Jobs Listing functionality used to store job listings features
class JobsOverview < UserInterface

    @@joblist = {}
    @@open_job_count = 0
    @@table_info = []

    # class method for displaying tabular job listing information
    def self.display()
        @@table_info = []
        
        puts "\nJob Opportunities Overview (Open Positions)\n\n"
        puts "Total Listings: #{@@joblist.length}"
        for key, value in @@joblist
            @@table_info.push([key, value.title, value.type, value.salary, value.openings, value.start_date, value.manager, value.applications, value.status])
        end

        table = Terminal::Table.new :headings => [
            "Job ID", "Job Title", 
            "Type", "Salary $(AUD)", 
            "# of Openings", "Target Start Date", 
            "Hiring Manager", "Total Applications", "Status" 
        ], :rows => @@table_info

        puts table
    end

    # class method for displaying control panel 
    def self.control_panel()
        puts "\n[1] Create Job    [2] Edit Job Details    [3] Manager Job"
        puts "[x] Exit"
    end

    # method for accessing job list 
    def self.joblist()
        @@joblist
    end

    # method for accessing job_count 
    def self.open_job_count()
        @@open_job_count
    end

    def self.count_job()
        @@open_job_count += 1
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
        job[:salary] = gets.chomp.to_s
        print "# of Openings: "
        job[:openings] = gets.chomp.to_i
        print "Target Start Date: "
        job[:start_date] = gets.chomp.to_s
        print "Hiring Manager: "
        job[:manager] = gets.chomp.to_s
        job[:applications] = 0
        job[:status] = "Open"
        @@joblist.store("100#{@@open_job_count}", JobManager.new(
                "100#{@@open_job_count}", job[:title], job[:type], 
                job[:salary], job[:openings], job[:start_date], job[:manager]
            )
        )


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

        load_jobs = []
        YAML.load_stream(File.read 'job_database.yml') { |job| load_jobs << job }
        load_jobs[0] << saving
        File.open("job_database.yml", 'w') { |file| file.write(load_jobs.to_yaml, file) }
        p load_jobs
        gets

        @@open_job_count += 1 
    end

    # method for editing a job opportunity information
    def self.edit()
        UserInterface.header()
        self.display()
        print "Enter Job ID: "
        id = gets.chomp.to_s
        if JobsOverview.joblist.has_key?(id) == false
            puts "Invalid ID..."
            sleep 1.5
            return
        end
        puts "Select field to edit:"
        puts "[1] Job Title     [2] Employment Type     [3] Salary,"
        puts "[4] # of Openings [5] Target Start Date   [6] Hiring Manager  [7] Status"
        option = gets.chomp.to_s
        print "Change to: "
        case option
        when "1"
            change = gets.chomp.to_s
            @@joblist[id].title = change
            JobsOverview.save_edits(id, :title, change)
        when "2"
            change = gets.chomp.to_s
            @@joblist[id].type = change
            JobsOverview.save_edits(id, :type, change)
        when "3"
            change = gets.chomp.to_s
            @@joblist[id].salary = change
            JobsOverview.save_edits(id, :salary, change)
        when "4"
            change = gets.chomp.to_s
            @@joblist[id].openings = change
            JobsOverview.save_edits(id, :openings, change)
        when "5"
            change = gets.chomp.to_s
            @@joblist[id].start_date = change
            JobsOverview.save_edits(id, :start_date, change)
        when "6"
            change = gets.chomp.to_s
            @@joblist[id].manager = change
            JobsOverview.save_edits(id, :manager, change)
        when "7"
            puts "Change status to:

            [1] Open
            [2] Pending
            [3] Closed
            "
            print "Select: "
            answer = gets.chomp.to_s
            case answer 
            when "1"
                change = "Open"
                @@joblist[id].status = change
                JobsOverview.save_edits(id, :status, change)
                return
            when "2"
                change = "Pending"
                @@joblist[id].status = change
                JobsOverview.save_edits(id, :status, change)
                return
            when "3"
                change = "Closed"
                @@joblist[id].status = change
                JobsOverview.save_edits(id, :status, change)
                return
            end
            puts "Invalid input. Press Enter to return"
            gets
        end
    end

    def self.save_edits(id, element, change)
        load_jobs = []
        YAML.load_stream(File.read 'job_database.yml') { |job| load_jobs << job }
        for i in load_jobs[0]
            if i[:id] == id
                i[element] = change
            end
        end
        File.open("job_database.yml", 'w') { |file| file.write(load_jobs[0].to_yaml, file) }
    end

    def self.delete()
        UserInterface.header()
        self.display()
        print "Enter Job ID: "
        id = gets.chomp.to_s
        if JobsOverview.joblist.has_key?(id) == false
            puts "Invalid ID..."
            sleep 1.5
            return
        end
        puts "Are you sure you want to delete jobs? Type 'confirm' to confirm. "
        puts "Press Enter to go back"
        answer = gets.chomp.to_s

        load_jobs = []
        YAML.load_stream(File.read 'job_database.yml') { |job| load_jobs << job }
        for i in load_jobs[0]
            if i[:id] == id
                load_jobs[0].delete(i)
            end
        end

        File.open("job_database.yml", 'w') { |file| file.write(load_jobs[0].to_yaml, file) }

    
        @@joblist.delete(id)
        
        return
    end

end
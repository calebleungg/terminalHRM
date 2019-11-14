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
        job[:salary] = gets.chomp.to_i
        print "# of Openings: "
        job[:openings] = gets.chomp.to_i
        print "Target Start Date: "
        job[:start_date] = gets.chomp.to_s
        print "Hiring Manager: "
        job[:manager] = gets.chomp.to_s
        job[:applications] = 0
        @@joblist.store("100#{@@open_job_count}", JobManager.new(
                "100#{@@open_job_count}", job[:title], job[:type], 
                job[:salary], job[:openings], job[:start_date], job[:manager]
            )
        )

        saving = { id: "100#{@@open_job_count}", 
            info: [ { 
                title: job[:title], 
                type: job[:type],
                salary: job[:salary],
                openings: job[:openings],
                start_date: job[:start_date],
                manager: job[:manager],
                applications: job[:applications],
                }
            ]
        }       

        File.open("job_database.yml", "a") { |file| file.write(saving.to_yaml) }

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
                @@joblist[id].status = "Open"
                return
            when "2"
                @@joblist[id].status = "Pending"
                return
            when "3"
                @@joblist[id].status = "Closed"
                return
            end
            puts "Invalid input. Press Enter to return"
            gets
        end
    end

    # def self.delete()
    #     UserInterface.header()
    #     self.display()
    #     print "Enter Job ID: "
    #     id = gets.chomp.to_s
    #     if JobsOverview.joblist.has_key?(id) == false
    #         puts "Invalid ID..."
    #         sleep 1.5
    #         return
    #     end
    #     puts "Are you sure you want to delete jobs? Type 'confirm' to confirm. "
    #     puts "Press Enter to go back"
    #     answer = gets.chomp.to_s
    #     if answer == "confirm"
    #         @@joblist.delete(id)
    #         load_list = []
    #         YAML.load_stream(File.read 'job_database.yml') { |job| load_list << job }
    #         for job in load_list
    #             if job[:id] == id
    #                 load_list.delete(job)
    #             end
    #         end
        
    #         return
    #     end
    #     return
    # end

end
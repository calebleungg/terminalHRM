# class for Managing selected job
class JobManager < JobsOverview
    attr_accessor :title, :type, :salary, :openings, :start_date, :manager, :applications, :cumulative, :column_count, :interview_log, :status, :all_pools
    attr_accessor :candidate_pool, :applied_pool, :contacted_pool, :screened_pool, :shortlisted_pool, :interview_pool, :offer_pool, :accepted_pool, :disqualified_pool
    attr_reader :id

    def initialize(id, title, type, salary, openings, start_date, manager)
        @candidate_pool = []

        @applied_pool = []
        @contacted_pool = []
        @screened_pool = []
        @shortlisted_pool = []
        @interview_pool = []
        @offer_pool = []
        @accepted_pool = []
        @disqualified_pool = []

        @column_count = [
            @applied_pool.length, @contacted_pool.length, 
            @screened_pool.length, @shortlisted_pool.length, 
            @interview_pool.length, @offer_pool.length, @accepted_pool.length,
            @disqualified_pool.length
        ]

        @all_pools = [
            @applied_pool, @contacted_pool, @screened_pool, 
            @shortlisted_pool, @interview_pool, @offer_pool, 
            @accepted_pool, @disqualified_pool
        ]

        @id = id
        @title = title
        @type = type
        @salary = salary
        @openings = openings
        @start_date = start_date
        @manager = manager
        @status = "Open"
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
            job.interview_pool.length, job.offer_pool.length, job.accepted_pool.length, 
            job.disqualified_pool.length 
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
            cumulative[counter][column] = i.name
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
            job.cumulative.push(["", "", "", "", "", "", "", ""])
            x -= 1 
        end

        JobManager.add_to_column(job.applied_pool, 0, job.cumulative)
        JobManager.add_to_column(job.contacted_pool, 1, job.cumulative)
        JobManager.add_to_column(job.screened_pool, 2, job.cumulative)
        JobManager.add_to_column(job.shortlisted_pool, 3, job.cumulative)
        JobManager.add_to_column(job.interview_pool, 4, job.cumulative)
        JobManager.add_to_column(job.offer_pool, 5, job.cumulative)
        JobManager.add_to_column(job.accepted_pool, 6, job.cumulative)
        JobManager.add_to_column(job.disqualified_pool, 7, job.cumulative)

        table = Terminal::Table.new :headings => [
            "Applied (#{job.applied_pool.length})", "Contacted (#{job.contacted_pool.length})", 
            "Screened (#{job.screened_pool.length})", "Shortlisted (#{job.shortlisted_pool.length})", 
            "Interview (#{job.interview_pool.length})", "Offer (#{job.offer_pool.length})", 
            "Accepted (#{job.accepted_pool.length})", "Disqualified (#{job.disqualified_pool.length})"
            ], :rows => job.cumulative 
        puts table
    
    end

    def self.schedule_interview(job)
        puts "- Schedule interview - "
        print "Enter Candidate: "
        name = gets.chomp.to_s.downcase
        for i in job.candidate_pool
            if i.name.downcase == name && job.shortlisted_pool.include?(i) == true
                print "Enter Interview Date: "
                date = gets.chomp.to_s
                print "Enter Interviewer(s): "
                interviewers = gets.chomp.to_s
                print "Enter Duration: "
                duration = gets.chomp.to_s
                print "Location: "
                location = gets.chomp.to_s
                i.status = "Interview"
                Candidate.save_edits(i.name, :status, i.status)
                Candidate.move(i, job.shortlisted_pool, job.interview_pool)

                saving = { 
                    job_id: job.id, 
                    name: i.name, 
                    date: date,
                    interviewers: interviewers,
                    duration: duration,
                    location: location,
                    status: "Booked",
                    notes: "",
                    rating: 0
                }
        
                load_logs = []
                YAML.load_stream(File.read 'interview_logs.yml') { |interview| load_logs << interview }
                load_logs[0] << saving
                File.open("interview_logs.yml", 'w') { |file| file.write(load_logs[0].to_yaml, file) }

                return
            end
        end
        puts "Invalid Candidate, please enter name correctly."
        puts "\nPress Enter to return"
        gets
    end

    def self.display_interview_list(job)

        load_logs = []

        YAML.load_stream(File.read 'interview_logs.yml') { |interview| load_logs << interview }

        puts "- Interview Log - "
        puts "------------------------------"
        for i in load_logs[0]
    
            if i[:job_id] == job.id
                puts "Candidate:    #{i[:name]}"
                puts "Date:         #{i[:date]}"
                puts "Interviewers: #{i[:interviews]}"
                puts "Duration:     #{i[:duration]}"
                puts "Location:     #{i[:location]}\n\n"
                puts "Status:       #{i[:status]}"
                puts "Notes:        #{i[:notes]}"
                puts "Rating:       #{i[:rating]}"
                puts "------------------------------"
            end
        end
        puts "\nPress Enter to return"
        gets
    end

    def self.complete_interview(job)
        puts "- Complete Interview - "
        puts "------------------------------"
        puts "Completed interview for,"
        print "Enter Name: "
        name = gets.chomp.to_s.downcase

        load_logs = []
        YAML.load_stream(File.read 'interview_logs.yml') { |interview| load_logs << interview }
        for i in load_logs[0]
            if i[:job_id] == job.id && i[:name].downcase == name
                p i 
                gets
                i[:status] = "Completed"
                print "Enter Rating /5: "
                i[:rating] = gets.chomp.to_i
                puts "Additional comments, type below: "
                i[:notes] = gets.chomp.to_s
    
                File.open("interview_logs.yml", 'w') { |file| file.write(load_logs[0].to_yaml, file) }
                return
            end
        end

        puts "Candidate needs to be shortlisted to schedule an interview."
        puts "\nPress Enter to return"
        gets
    end

    def self.details_report(id, job)
        system("clear")
        JobManager.header_ui(id, job)
        rows = []

        for i in job.candidate_pool
            rows << [i.name, i.status, i.occupation, i.email, i.number, i.address, i.notes.values.last]
        end

        table = Terminal::Table.new :headings => [
            "Candidate Name", "Status", 
            "Occupation", "Email", 
            "Number", "Address", 
            "Latest Note"
            ], :rows => rows

        puts table
        puts "\n Press Enter to return"
        gets
    end

    # method for displaying job management controls
    def self.control_panel()
        puts "\n[1] Create Candidate          [2] View Candidate          [3] Progress Candidate   [4] Make Note "
        puts "[5] Schedule Interview        [6] View Interview Log      [7] Complete Interview   [8] Edit Candidate Details" 
        puts "[9] Disqualify Candidate"
        puts "[b] Back "
    end

end
# class for Managing selected job
class JobManager < JobsOverview
    attr_accessor :title, :type, :salary, :openings, :start_date, :manager, :interview_pool, :offer_pool
    attr_accessor :applications, :cumulative, :column_count, :interview_log, :status, :disqualified_pool, :all_pools
    attr_accessor :candidate_pool, :applied_pool, :contacted_pool, :screened_pool, :shortlisted_pool, :accepted_pool
    attr_reader :id

    # initializing class with details below
    def initialize(id, title, type, salary, openings, start_date, manager, status)
        # overall pool storing all candidates
        @candidate_pool = []

        # progress pools storing candidates dependent on stage
        @applied_pool = []
        @contacted_pool = []
        @screened_pool = []
        @shortlisted_pool = []
        @interview_pool = []
        @offer_pool = []
        @accepted_pool = []
        @disqualified_pool = []

        # instance array used to determine number of rows in table
        @column_count = [
            @applied_pool.length, @contacted_pool.length, 
            @screened_pool.length, @shortlisted_pool.length, 
            @interview_pool.length, @offer_pool.length, @accepted_pool.length,
            @disqualified_pool.length
        ]

        # instance variable referenced when disqualifying candidate
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
        @status = status
        @applications = 0
        @interview_log = {}

        # instance variable for organising information correctly in tabular
        @cumulative = []

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
            job.interview_pool.length, job.offer_pool.length, 
            job.accepted_pool.length, job.disqualified_pool.length 
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

    # method for adding candidates in each pool to currectly tabulate below
    def self.add_to_column(pool, column, cumulative)
        counter = 0
        for i in pool
            cumulative[counter][column] = i.name
            counter += 1
        end
    end

    # method for displaying candidate progression stages in tabular form
    def self.progress_bar(job) 
        # class method for updating columns before displaying
        JobManager.update_columns(job)

        # to reset data to ensure changes are made
        job.cumulative = []

        # determining number of rows for table (using the pool with highest number of candidates)
        number_of_rows = job.column_count.max
        counter = 0 
        until number_of_rows == 0
            job.cumulative.push(["", "", "", "", "", "", "", ""])
            number_of_rows -= 1 
        end
        
        # adding candidate names into the correct pool column using the correct index (assigning column) in cumulative
        JobManager.add_to_column(job.applied_pool, 0, job.cumulative)
        JobManager.add_to_column(job.contacted_pool, 1, job.cumulative)
        JobManager.add_to_column(job.screened_pool, 2, job.cumulative)
        JobManager.add_to_column(job.shortlisted_pool, 3, job.cumulative)
        JobManager.add_to_column(job.interview_pool, 4, job.cumulative)
        JobManager.add_to_column(job.offer_pool, 5, job.cumulative)
        JobManager.add_to_column(job.accepted_pool, 6, job.cumulative)
        JobManager.add_to_column(job.disqualified_pool, 7, job.cumulative)

        # initialising table using terminal-table passing the instance variable cumulative to display info
        table = Terminal::Table.new :headings => [
            "Applied (#{job.applied_pool.length})", "Contacted (#{job.contacted_pool.length})", 
            "Screened (#{job.screened_pool.length})", "Shortlisted (#{job.shortlisted_pool.length})", 
            "Interview (#{job.interview_pool.length})", "Offer (#{job.offer_pool.length})", 
            "Accepted (#{job.accepted_pool.length})", "Disqualified (#{job.disqualified_pool.length})"
            ], :rows => job.cumulative 
        puts table
    
    end

    # method for scheduling an interview
    def self.schedule_interview(job)
        puts "- Schedule interview - "
        print "Enter Candidate: "
        name = gets.chomp.to_s.downcase

        # for loop to determine if candidate is at the correct stage to continue
        for i in job.candidate_pool

            # checking if name is same as selected, and candidate is in the shortlisted pool 
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

                # class method for changing candidate status and saving to yaml file- "./classes/candidate-class.rb"
                Candidate.save_edits(i.name, :status, i.status)
                # class method for moving a candidate to next pool- "./classes/candidate-class.rb"
                Candidate.move(i, job.shortlisted_pool, job.interview_pool)

                # method variable use for saving to yaml file later
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
                
                # loading yaml file contents into an instanced array
                load_logs = []
                YAML.load_stream(File.read './info/interview_logs.yml') { |interview| load_logs << interview }

                # if check to skip load sequence if yaml file is empty
                if load_logs[0] == [nil]
                    load_logs[0] = [saving]
                else
                    # if not empty, appenging the 'saving' hash above into the instanced array
                    load_logs[0] << saving
                end

                # writing new instanced array back into the yaml file with new information added
                File.open("./info/interview_logs.yml", 'w') { |file| file.write(load_logs[0].to_yaml, file) }
                return
            end
        end

        # notifying invalid candidate if above conditions arent met
        puts "Candidate needs to be shortlisted to schedule an interview."
        puts "\nPress Enter to return"
        gets
    end

    # method for displaying interview log
    def self.display_interview_list(job)

        # loading yaml file contents into an instanced array to reference from
        load_logs = []
        YAML.load_stream(File.read './info/interview_logs.yml') { |interview| load_logs << interview }

        # if check to display no entires when yaml is empty
        if load_logs[0] == [nil]
            puts "- Interview Log - "
            puts "------------------------------"
            puts "No entries..."
        else
            # iterating through instanced array to access relevant details for interview log to displayed below
            puts "- Interview Log - "
            puts "------------------------------"
            for i in load_logs[0]
                # if to check for only the interviews with the correct job id to be displayed
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
        end

        puts "\nPress Enter to return"
        gets
    end

    # class method for marking an interview complete
    def self.complete_interview(job)
        puts "- Complete Interview - "
        puts "------------------------------"
        puts "Completed interview for,"
        print "Enter Name: "
        name = gets.chomp.to_s.downcase

        # loading yaml file contents into an instanced array to reference from
        load_logs = []
        YAML.load_stream(File.read './info/interview_logs.yml') { |interview| load_logs << interview }

        # if check to display an error when no valid interviews can be completed
        if load_logs[0] == [nil]
            puts "Invalde Error: "
        else
            # iterating through the logs using an if statement to 
            # determine the correct job id and the name of candidate typed in by user
            # downcase is used to allow for user input variability
            for i in load_logs[0]
                if i[:job_id] == job.id && i[:name].downcase == name
                    i[:status] = "Completed"
                    print "Enter Rating /5: "
                    i[:rating] = gets.chomp.to_i
                    puts "Additional comments, type below: "
                    i[:notes] = gets.chomp.to_s
                    
                    # writing the edited instanced array with updated information back into the yaml file
                    File.open("./info/interview_logs.yml", 'w') { |file| file.write(load_logs[0].to_yaml, file) }
                    return
                end
            end
        end
        
        # notifying user when condidtions above arent met
        puts "Candidate needs to be shortlisted to schedule an interview."
        puts "\nPress Enter to return"
        gets
    end

end
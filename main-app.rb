# requiring relevant gems and yaml ability
require "yaml"
require "colorize"
require "terminal-table"
require "date_format"
require "tty-prompt"
require "tty-spinner"

# requiring relevant class definitions
require "./classes/ui-class"
require "./classes/jobs-overview-class"
require "./classes/job-manager-class"
require "./classes/candidate-class"

# loop variable condition
app_on = true 

# loading animation sequence using tty-spinner
spinner = TTY::Spinner.new("[:spinner] Initializing ...")
8.times do
  spinner.spin
  sleep(0.1)
end
spinner.success('(successful)')

#------------------------ loading portion of the script ------------------------

spinner1 = TTY::Spinner.new("[:spinner] Loading jobs ...")
10.times do
  spinner1.spin
  sleep(0.1)
end

# Error handling to catch loading errors from yaml file
begin
    # method for loading yaml files
    def load_yaml(yaml_file)
        data = []
        YAML.load_stream(File.read yaml_file) { |f| data << f }
        return data
    end

    # load sequence for saved job data- appending yaml data into an array of hashes 
    load_queue_jobs = load_yaml('./info/job_database.yml') #[]

    # if condition for skipping sequence if yaml file is empty
    if load_queue_jobs[0] == [nil]
        puts ""
    else
        for job in load_queue_jobs[0]

            #initialising saved jobs into objects for the program to use throughout- iterating through the list of hashes 
            JobsOverview.joblist.store(job[:id], 
                JobManager.new(
                    job[:id], 
                    job[:title], 
                    job[:type], 
                    job[:salary], 
                    job[:openings], 
                    job[:start_date], 
                    job[:manager], 
                    job[:status]
                )
            )
            JobsOverview.count_job()
        end
    end

    spinner1.success('(successful)')

    spinner2 = TTY::Spinner.new("[:spinner] Loading candidates ...")
    15.times do
    spinner2.spin
    sleep(0.1)
    end

    # load sequence for candidate only if job data has been loaded successfully
    begin
        load_queue_candidates = load_yaml('./info/candidate_database.yml')
    
        # if condition for skipping sequence if yaml file is empty
        if load_queue_candidates[0] == [nil]
            puts ""
        else   
            # initialising saved candidates into candidate objects by iterating through array of hashes 
            for i in load_queue_candidates[0]
                candidate = Candidate.new(i[:name], i[:occupation], i[:email], i[:number], i[:address], i[:status], i[:notes])
                JobsOverview.joblist[i[:job_id]].candidate_pool.push(candidate)
    
                # case statement specifying the candidate's status as a condition to append into in the right pool
                case candidate.status
                when "Applied"
                    JobsOverview.joblist[i[:job_id]].applied_pool.push(candidate)
                when "Contacted"
                    JobsOverview.joblist[i[:job_id]].contacted_pool.push(candidate)
                when "Screened"
                    JobsOverview.joblist[i[:job_id]].screened_pool.push(candidate)
                when "Shortlisted"
                    JobsOverview.joblist[i[:job_id]].shortlisted_pool.push(candidate)
                when "Interview"
                    JobsOverview.joblist[i[:job_id]].interview_pool.push(candidate)
                when "Offer"
                    JobsOverview.joblist[i[:job_id]].offer_pool.push(candidate)
                when "Accepted"
                    JobsOverview.joblist[i[:job_id]].accepted_pool.push(candidate)
                when "Disqualified"
                    JobsOverview.joblist[i[:job_id]].disqualified_pool.push(candidate)
                end
                JobsOverview.joblist[i[:job_id]].applications += 1
            end
        end
        spinner2.success('(successful)')
        sleep 0.5
        system("clear")
    
        puts "Welcome to terminalHRM"
        puts "Please enter your company details,\n\n"
        UserInterface.create_company()
    rescue
        spinner2.success('(failed)')
        puts "Error: Could not load candidates from database- check './info/candidate_database.yml' is laid out correctly for loading."
        puts "       An Example of correct yaml folder layout can be seen in './help.md'"
        app_on = false
    end
rescue
    spinner1.success('(failed)')
    puts "Error: Could not load jobs from database- check './info/job_database.yml' is laid out correctly for loading."
    puts "       An Example of correct yaml folder layout can be seen in './help.md'"
    app_on = false
end


#------------------------ main script for running the program ------------------------

# class method for creating the company- information has already been hardcoded in "./classes/ui-class.rb"

# run loop for program
while app_on
    system("clear")

    # class method for displaying the program's Header UI "./classes/ui-class.rb"
    UserInterface.header()

    # class method for displaying tabular job data "./classes/jobs-overview-class.rb"
    JobsOverview.display()

    prompt = TTY::Prompt.new
    option = prompt.select("Select Option", %w(Create_Job Edit_Job Manage_Job Exit))

    # case statement using the option selected by tty-prompt
    case option
    when "Create_Job"
        # class method for creating a job "./classes/jobs-overview-class.rb"
        JobsOverview.create()

    when "Edit_Job"
        # class method for editing a job "./classes/jobs-overview-class.rb"
        JobsOverview.edit()

    when "Manage_Job"

        manage = true
        print "Enter Job ID: "
        id = gets.chomp.to_s

        # if statement to catch non-existent job ids
        if JobsOverview.joblist.has_key?(id) == false
            puts "Invalid ID..."
            puts "\nPress Enter to return"
            gets
            manage = false
        end

        # run loop for managing a job
        while manage

            # class method for displaying program ui "./classes/job-manager-class.rb"
            JobManager.header_ui(id, JobsOverview.joblist[id])
            JobManager.progress_bar(JobsOverview.joblist[id])

            prompt = TTY::Prompt.new
            option = prompt.select("Select Option (scroll to display all)", 
                %w(Create View Progress Make_note Schedule_interview Interview_Log 
                Complete_interview Edit_Candidate Disqualify_Candidate Back))
                
            # case statement using selected option from tty-prompt, passing the job_id to determine specific job in each class method argument
            case option
            when "Create"
                # class method for creating a candidate "./classes/candidate-class.rb"
                Candidate.create(JobsOverview.joblist[id])

            when "View"
                # class method for viewing a candidate "./classes/candidate-class.rb"
                Candidate.view(JobsOverview.joblist[id])

            when "Progress"
                # class method for progressing a candidate "./classes/candidate-class.rb"
                Candidate.progress(JobsOverview.joblist[id])

            when "Make_note"
                # class method for making a note on a candidate "./classes/candidate-class.rb"
                Candidate.make_note(JobsOverview.joblist[id])

            when "Schedule_interview"
                # class method for scheduling a candidate interview "./classes/job-manager-class.rb"
                JobManager.schedule_interview(JobsOverview.joblist[id])

            when "Interview_Log"
                # class method for displaying interview log "./classes/job-manager-class.rb"
                JobManager.display_interview_list(JobsOverview.joblist[id])

            when "Complete_interview"
                # class method for making an interview completed "./classes/job-manager-class.rb"
                JobManager.complete_interview(JobsOverview.joblist[id])

            when "Edit_Candidate"
                # class method for editing a candidate "./classes/candidate-class.rb"
                Candidate.edit(JobsOverview.joblist[id])

            when "Disqualify_Candidate"
                # class method for disqualifying a candidate "./classes/candidate-class.rb"
                Candidate.disqualify(JobsOverview.joblist[id])

            when "Back"
                manage = false
            end
        end

    when "Exit"
        system("clear")
        app_on = false
    end
end


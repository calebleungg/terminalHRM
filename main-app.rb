require "yaml"
require "colorize"
require "terminal-table"
require "date_format"

require "./classes/ui-class"
require "./classes/jobs-overview-class"
require "./classes/job-manager-class"
require "./classes/candidate-class"


load_queue_jobs = []
YAML.load_stream(File.read './info/job_database.yml') { |job| load_queue_jobs << job }

if load_queue_jobs[0] == [nil]
    puts "loading jobs..."
    sleep 0.5
else
    puts "loading jobs..."
    sleep 0.5
    for job in load_queue_jobs[0]
        JobsOverview.joblist.store(job[:id], JobManager.new(job[:id], job[:title], job[:type], job[:salary], job[:openings], job[:start_date], job[:manager], job[:status]))
        JobsOverview.count_job()
    end
end

load_queue_candidates = []
YAML.load_stream(File.read './info/candidate_database.yml') { |candidate| load_queue_candidates << candidate }

if load_queue_candidates[0] == [nil]
    puts "loading candidates..."
    sleep 0.5
else   
    puts "loading candidates..."
    sleep 0.5

    for i in load_queue_candidates[0]
        candidate = Candidate.new(i[:name], i[:occupation], i[:email], i[:number], i[:address], i[:status], i[:notes])
        JobsOverview.joblist[i[:job_id]].candidate_pool.push(candidate)
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
        # JobsOverview.joblist[i[:job_id]].applied_pool.push(candidate)
        JobsOverview.joblist[i[:job_id]].applications += 1
    end

end


# main script
system("clear")

puts "Welcome to terminalHRM"
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
        if JobsOverview.joblist.has_key?(id) == false
            puts "Invalid ID..."
            puts "\nPress Enter to return"
            gets
            return
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
            when "4"
                Candidate.make_note(JobsOverview.joblist[id])
            when "5"
                JobManager.schedule_interview(JobsOverview.joblist[id])
            when "6"
                JobManager.display_interview_list(JobsOverview.joblist[id])
            when "7"
                JobManager.complete_interview(JobsOverview.joblist[id])
            when "8"
                Candidate.edit(JobsOverview.joblist[id])
            when "9"
                Candidate.disqualify(JobsOverview.joblist[id])
            when "10"
                JobManager.details_report(id, JobsOverview.joblist[id])
            when "b"
                manage = false
            end
        end
    when "4"
        JobsOverview.delete()
    when "x"
        system("clear")
        app_on = false
    end
end


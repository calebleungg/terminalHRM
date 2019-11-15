require "yaml"
require "colorize"
require "terminal-table"
require "date_format"

require "./classes/ui-class"
require "./classes/jobs-overview-class"
require "./classes/job-manager-class"
require "./classes/candidate-class"


load_queue_jobs = []
YAML.load_stream(File.read 'job_database.yml') { |job| load_queue_jobs << job }
# p load_queue_jobs
# gets

for job in load_queue_jobs[0]
    JobsOverview.joblist.store(job[:id], JobManager.new(job[:id], job[:title], job[:type], job[:salary], job[:openings], job[:start_date], job[:manager]))
    JobsOverview.count_job()
end

load_queue_candidates = []
YAML.load_stream(File.read 'candidate_database.yml') { |candidate| load_queue_candidates << candidate }

for i in load_queue_candidates
    candidate = Candidate.new(i[:name], i[:occupation], i[:email], i[:number], i[:address])
    JobsOverview.joblist[i[:job_id]].candidate_pool.push(candidate)
    JobsOverview.joblist[i[:job_id]].applied_pool.push(candidate)
    JobsOverview.joblist[i[:job_id]].applications += 1
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


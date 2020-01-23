class JobController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :setup_jobs


    private
    def setup_jobs
        # session[:jobs] = [
        #     { id: 1001, title: "Junior Developer", type: "Full Time", salary: 65000, openings: 2, reporting_to: "Glen Kumar"}
        # ] unless session[:jobs]

        # @jobs = session[:jobs]

        @jobs = [
            { id: 1001, title: "Junior Developer", type: "Full Time", salary: 65000, openings: 2, start_date: "01/07/2020", reporting_to: "Glen Kumar"}
        ]
        
        @candidates = [
            { job_id: 1001, first_name: "Caleb", last_name: "Leung", status: "contacted" },
            { job_id: 1001, first_name: "John", last_name: "Wick", status: "offer" },
            { job_id: 1001, first_name: "Thanos", last_name: "", status: "disqualified" },
            { job_id: 1001, first_name: "Barack", last_name: "Obama", status: "applied" },
            { job_id: 1001, first_name: "Conor", last_name: "McGregor", status: "applied" },
            { job_id: 1001, first_name: "Colonel", last_name: "Sanders", status: "applied" },
            { job_id: 1001, first_name: "Tim", last_name: "Cook", status: "screened" },
            { job_id: 1001, first_name: "Roger", last_name: "Federer", status: "applied" },
            { job_id: 1001, first_name: "Scott", last_name: "Morrison", status: "applied" },
            { job_id: 1001, first_name: "Snoop", last_name: "Lion", status: "applied" },
            { job_id: 1001, first_name: "Harry", last_name: "Potter", status: "contacted" },
            { job_id: 1001, first_name: "Naruto", last_name: "Uzumaki", status: "contacted" },
            { job_id: 1001, first_name: "James", last_name: "Bond", status: "contacted" },
            { job_id: 1001, first_name: "Edward", last_name: "Snowden", status: "shortlisted" },
            { job_id: 1001, first_name: "Albert", last_name: "Einstein", status: "shortlisted" },
            { job_id: 1001, first_name: "Pikachu", last_name: "", status: "interview" }
        ]
    end

end

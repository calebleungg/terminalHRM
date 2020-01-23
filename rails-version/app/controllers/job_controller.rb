class JobController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :setup_jobs


    private
    def setup_jobs
        session[:jobs] = [
            { id: 1001, job_name: "Junior Developer" },
            { id: 1002, job_name: "Marketing Coordinator" },
            { id: 1003, job_name: "General Manager" }
        ] unless session[:jobs]

        @jobs = session[:jobs]
    end

end

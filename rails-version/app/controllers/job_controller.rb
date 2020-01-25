class JobController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :setup_jobs

    def index
        # render layout: "job_manager"
    end

    def job_manager
        render layout: "job_manager"
    end

    def candidate
        @candidates.each do | candidate |
            if candidate[:id] == params[:id].to_i
                @candidate = candidate
            else
                @error = "Error: non-existent candidate"
            end
        end
        render layout: "job_manager"
    end

    
    private
    def setup_jobs
        @jobs = Job.all
        @candidates = Candidate.all
    end

end

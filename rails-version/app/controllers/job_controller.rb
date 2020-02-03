require 'date_format'

class JobController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :setup_jobs
    attr_reader :candidate

    def index
    end

    def new
        @job = Job.new
    end

    def create
        @job = Job.new(job_params)
        @job.status = "open"

        if @job.valid? && @job.save
            redirect_to manager_path(@job[:id])
        else
            render "new"
        end
    end

    def job_manager
        @job = @jobs.find(params[:job_id])
        @candidate_pool = @candidates.where(job_id: params[:job_id])

        @columns = { "applied" => 0, "contacted" => 1, "screened" => 2, "shortlisted" => 3, "interview" => 4, "offer" => 5, "accepted" => 6, "disqualified" => 7}
        @repeats = Hash.new(0)

        if @candidate_pool != []
            @candidate_pool.each do | candidate |
                if candidate[:id] == params[:id].to_i
                    @candidate = candidate
                else
                    @error = "Error: non-existent candidate"
                end

                @repeats[candidate[:status].downcase] += 1
            end
        
            @row_count = @repeats.values.max
            @row_data = []

            until @row_count == 0 
                @row_data.push(["", "", "", "", "", "", "", ""])
                @row_count -= 1
            end
        end

        @candidate = @candidates.where(id: params[:candidate_id]).first

        if @candidate
            @notes = Note.where(candidate_id: @candidate[:id]).reverse
            @interviews = Interview.where(candidate_id: @candidate[:id]).reverse
        end

        @prog_error = params[:prog_error]

    end

    
    private
    def setup_jobs
        @jobs = Job.all
        @candidates = Candidate.all
    end

    def job_params
        params.require(:job).permit(:title, :work_type, :salary, :openings, :start_date, :reporting_to, :status)
    end

end

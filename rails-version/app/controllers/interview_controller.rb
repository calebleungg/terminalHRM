class InterviewController < ApplicationController
    def new
        @candidate = Candidate.find(params[:candidate_id])
        @job = Job.find(@candidate[:job_id])
    end

    def create
        @interview = Interview.new
        @interview.date = params[:date].in_time_zone('Australia/Brisbane')
        @interview.candidate_id = params[:candidate_id]
        @interview.job_id = params[:job_id]
        @interview.interviewer = params[:interviewer]
        @interview.status = "booked"
        @interview.comments = params[:comments]

        if @interview.valid? && @interview.save
            redirect_to candidate_path(:job_id => @interview[:job_id].to_i, :candidate_id => params[:candidate_id])
        else
            render "new"
        end
    end
end

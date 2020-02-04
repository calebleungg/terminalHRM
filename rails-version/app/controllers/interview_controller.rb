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

    def show
        @job = Job.find(params[:job_id])
        @interviews = Interview.where(job_id: params[:job_id])
        @candidate_pool = Candidate.where(job_id: params[:job_id])
    end

    def complete
        @interview = Interview.where(candidate_id: params[:candidate_id])
        @interview.update(status: "completed")
        if @interview[0].valid? && @interview[0].save
            redirect_to interview_list_path(@interview[0][:job_id])
        else
            render "job_manager"
        end
    end

    def reschedule
        @interview = Interview.where(candidate_id: params[:candidate_id]).first
        @candidate = Candidate.find(@interview[:candidate_id])

        @interview.update(date: params[:date])

        if @interview.valid? && @interview.save
            redirect_to interview_list_path(@interview[:job_id])
        else
            render "job_manager"
        end
    end

    private
    def interview_params
        params.require(:interview).permit(:status, :date)
    end
end

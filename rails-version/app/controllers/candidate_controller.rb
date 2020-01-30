class CandidateController < ApplicationController

    def new
    end

    def create
        @candidate = Candidate.new
        @candidate.job_id = params[:job_id]
        @candidate.first_name = params[:first_name]
        @candidate.last_name = params[:last_name]
        @candidate.occupation = params[:occupation]
        @candidate.email = params[:email]
        @candidate.number = params[:number]
        @candidate.status = "applied"

        if @candidate.save
            redirect_to manager_path(@candidate[:job_id])
        else
            render "new"
        end
    end

    def progress
        stage = ["applied", "contacted", "screened", "shortlisted", "interview", "offer", "accepted", "disqualified"]
        @candidate = Candidate.find(params[:candidate_id])
        @candidate.update(status: stage[stage.index(@candidate.status)+1])

        @note = Note.new
        @note.candidate_id = params[:candidate_id]
        @note.note = "Progressed to #{stage[stage.index(@candidate.status)+1]}"
        @note.save

        if @candidate.save
            redirect_to candidate_path(:job_id => @candidate[:job_id].to_i,:candidate_id => @candidate[:id])
        else
            render "new"
        end
    end

    def disqualify
        @candidate = Candidate.find(params[:candidate_id])
        @candidate.update(status: "disqualified")

        @note = Note.new
        @note.candidate_id = params[:candidate_id]
        @note.note = "Disqualified"
        @note.save

        if @candidate.save
            redirect_to manager_path(@candidate[:job_id])
        else
            render "new"
        end
    end

    def edit 
        @candidate = Candidate.find(params[:candidate_id])
    end

    def update
        candidate = Candidate.find(params[:candidate_id])
        candidate.update(
            job_id: params[:candidate][:job_id],
            first_name: params[:candidate][:first_name],
            last_name: params[:candidate][:last_name],
            status: params[:candidate][:status],
            occupation: params[:candidate][:occupation],
            email: params[:candidate][:email],
            number: params[:candidate][:number]
        )
        if candidate.save
            redirect_to candidate_path(:job_id => candidate[:job_id].to_i, :candidate_id => candidate[:id])
            # redirect_to manager_path(candidate[:job_id])
        else
            render "edit"
        end
    end

end

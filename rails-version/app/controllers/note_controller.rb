class NoteController < ApplicationController

    def new
        @candidate = Candidate.find(params[:candidate_id])
    end

    def create
        @candidate = Candidate.find(params[:candidate_id])
        @note = Note.new
        @note.candidate_id = params[:candidate_id].to_i
        @note.note = params[:note]
        p @note

        if @note.save
            redirect_to candidate_path(:job_id => @candidate[:job_id].to_i, :candidate_id => params[:candidate_id])
        else
            render "new"
        end
    end

end

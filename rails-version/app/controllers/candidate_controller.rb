class CandidateController < ApplicationController

    def new
        @candidate = Candidate.new
    end

    def create
        @candidate = Candidate.new(candidate_params)
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

        if @candidate[:status] == "accepted"
            @prog_error = "Can't progress further."
            redirect_to candidate_path(:job_id => @candidate[:job_id].to_i,:candidate_id => @candidate[:id], :prog_error => @prog_error)
        elsif @candidate[:status] == "disqualified"
            @prog_error = "#{@candidate[:first_name]} #{@candidate[:last_name]} has been disqualified."
            redirect_to candidate_path(:job_id => @candidate[:job_id].to_i,:candidate_id => @candidate[:id], :prog_error => @prog_error)
        else
            @candidate.update(status: stage[stage.index(@candidate.status)+1])

            @note = Note.new
            @note.candidate_id = params[:candidate_id]
            @note.note = "Progressed to #{stage[stage.index(@candidate.status)]}"
            @note.save

            if @candidate.save
                redirect_to candidate_path(:job_id => @candidate[:job_id].to_i,:candidate_id => @candidate[:id], :prog_error => @prog_error)
            else
                render "new"
            end
        end

    end

    def disqualify
        
        @candidate = Candidate.find(params[:candidate_id])
        if @candidate[:status] == "disqualified"
            @prog_error = "#{@candidate[:first_name]} #{@candidate[:last_name]} is already disqualified."
            redirect_to candidate_path(:job_id => @candidate[:job_id].to_i,:candidate_id => @candidate[:id], :prog_error => @prog_error)
        else
            @candidate.update(status: "disqualified")
    
            @note = Note.new
            @note.candidate_id = params[:candidate_id]
            @note.note = "Disqualified"
            @note.save
    
            if @candidate.save
                redirect_to candidate_path(:job_id => @candidate[:job_id].to_i,:candidate_id => @candidate[:id], :prog_error => @prog_error)
            else
                render "new"
            end
        end

    end

    def edit 
        @candidate = Candidate.find(params[:candidate_id])
    end

    def update
        candidate = Candidate.find(params[:candidate_id])
        candidate.update(candidate_params)
        if candidate.valid? && candidate.save
            redirect_to candidate_path(:job_id => candidate[:job_id].to_i, :candidate_id => candidate[:id])
        else
            render "edit"
        end
    end

    private
    def candidate_params
        params.require(:candidate).permit(:job_id, :first_name, :last_name, :occupation, :email, :number, :status)
    end

end

# class for Candidate creation and management
class Candidate
    attr_accessor :name, :occupation, :email, :number, :address
    attr_accessor :status, :notes

    # initializing class with details below
    def initialize(name, occupation, email, number, address, status, notes) 
        @name = name
        @occupation = occupation
        @email = email
        @number = number
        @address = address
        @status = status
        @notes = notes
    end

    # method for creating a candidate
    def self.create(job)
        puts "Enter candidate details,"
        print "Name: "
        name = gets.chomp.to_s
        print "Occupation: "
        occupation = gets.chomp.to_s
        print "Email: "
        email = gets.chomp.to_s
        print "Number: "
        number = gets.chomp.to_s
        print "Address: "
        address = gets.chomp.to_s

        # instancing a candidate objct
        candidate = Candidate.new(name, occupation, email, number, address, "Applied", {})
        # appending candidate object to total pool
        job.candidate_pool.push(candidate)
        # appending new candidate object to applied pool
        job.applied_pool.push(candidate)
        # updating count for correct ui info display
        job.applications += 1

        # method variable used for saving to yaml file later
        saving = { 
            job_id: job.id, 
            name: name, 
            occupation: occupation, 
            email: email,
            number: number,
            address: address,
            status: "Applied",
            notes: {}
        }

        # loading yaml file contents into an instanced array
        load_candidates = []
        YAML.load_stream(File.read './info/candidate_database.yml') { |candidate| load_candidates << candidate }

        # if check to skip load sequence if yaml file is empty
        if load_candidates[0] == [nil]
            load_candidates[0] = [saving]
        else
            # if not empty, appenging the 'saving' hash above into the instanced array
            load_candidates[0] << saving
        end
        
        # writing new instanced array back into the yaml file with new information added
        File.open("./info/candidate_database.yml", 'w') { |file| file.write(load_candidates[0].to_yaml, file) }

    end

    # class method for viewing candidate details
    def self.view(job)
        puts "- View Candidate -"
        print "Enter name: "
        name = gets.chomp.to_s.downcase

        # for loop to iterate through total candidate pool to find selected candidate by name 
        for i in job.candidate_pool
            if i.name.downcase == name
                puts "=============================="
                puts "Details for: #{i.name}"
                puts "=============================="
                puts "Status:       #{i.status}"
                puts "Occupation:   #{i.occupation}"
                puts "Email:        #{i.email}"
                puts "Number:       #{i.number}"
                puts "Address:      #{i.address}"
                puts "------------------------------"
                puts "          Notes: "
                puts "------------------------------"

                # for loop to iterate through the notes hash of the candidate to display notes in list form (if multiple)
                for key, value in i.notes
                    puts "Date: #{key}"
                    puts value
                    puts "------------------------------"
                end
                puts "\nPress Enter to return."
                gets
                return
            end
        end

        # notifies when invalid/non-existent candidate name is entered
        puts "Invalid Candidate, please enter name correctly."
        puts "\nPress Enter to return"
        gets
    end

    # class method for making notes on candidate profile
    def self.make_note(job)
        puts "- Make Note - "
        print "For (Enter Name): "
        name = gets.chomp.to_s.downcase

        # for loop to iterate through total candidate pool to find selected candidate by name
        for i in job.candidate_pool
            if i.name.downcase == name

                # recording current time/date
                date = Time.now
                # formatting current time/date using date_format gem
                format_date = "#{DateFormat.change_to(date, "MEDIUM_DATE")} #{DateFormat.change_to(date, "MEDIUM_TIME")} "

                puts "Type Note Below, (Press Enter to save)"
                note = gets.chomp.to_s

                # storing note information (with formatted date as key) into candidate object notes instance variable
                i.notes.store(format_date, note)

                # usual load save sequence for updating and writing to yaml file 
                load_candidates = []
                YAML.load_stream(File.read './info/candidate_database.yml') { |candidate| load_candidates << candidate }
                for candidate in load_candidates[0]
                    if candidate[:name] == i.name 
                        candidate[:notes][format_date] = note
                    end
                end
                File.open("./info/candidate_database.yml", 'w') { |file| file.write(load_candidates[0].to_yaml, file) }
                return
            end
        end

        # notifies when invalid/non-existent candidate name is entered
        puts "Invalid Candidate, please enter name correctly."
        puts "\nPress Enter to return"
        gets
    end

    # method for moving candidates between pools
    def self.move(candidate, current_stage, new_stage)
        current_stage.delete(candidate)
        new_stage.push(candidate)
    end

    # method for progressing candidate into next stage of recruitment
    def self.progress(job)
        puts "- Select candidate to be progressed -"
        print "Enter Name: "
        name = gets.chomp.to_s.downcase

        # for loop to iterate through total candidate pool to find selected candidate by name
        for i in job.candidate_pool
            if i.name.downcase == name

                # case statement passing candidate object status to determine progression stage
                case i.status 
                when "Applied"
                    # updating object status 
                    i.status = "Contacted"
                    # class method for saving updated status into yaml file- see below 
                    Candidate.save_edits(i.name, :status, i.status)
                    # class method for moving candidate to next progression pool
                    Candidate.move(i, job.applied_pool, job.contacted_pool)
                    return
                when "Contacted"
                    i.status = "Screened"
                    Candidate.save_edits(i.name, :status, i.status)
                    Candidate.move(i, job.contacted_pool, job.screened_pool)
                    return
                when "Screened"
                    i.status = "Shortlisted"
                    Candidate.save_edits(i.name, :status, i.status)
                    Candidate.move(i, job.screened_pool, job.shortlisted_pool)
                    return
                when "Shortlisted"
                    # notifies that progression is invalid without scheduling an interview
                    puts "Candidate must be booked in for interview before progressing"
                    puts "\nPress Enter to return"
                    gets
                    return
                when "Interview"
                    # usual load_stream into instance variable for reference sequence
                    load_logs = []
                    YAML.load_stream(File.read './info/interview_logs.yml') { |interview| load_logs << interview }

                    # checking yaml data for if selected candidate's interview status is completed
                    for log in load_logs[0]
                        if log[:job_id] == job.id && log[:name].downcase == name && log[:status] == "Completed"
                            i.status = "Offer"
                            # progressing if condition is met
                            Candidate.save_edits(i.name, :status, i.status)
                            Candidate.move(i, job.interview_pool, job.offer_pool)
                            return
                        end
                    end

                    # notifies for when invalid candidate has been selected to progress past interview stage 
                    puts "Interview must be completed before sending offer"
                    puts "\nPress Enter to return"
                    gets
                    return
                when "Offer"
                    i.status = "Accepted"
                    Candidate.save_edits(i.name, :status, i.status)
                    Candidate.move(i, job.offer_pool, job.accepted_pool)
                    return
                end
            end
        end

        # notifies when invalid candidate is selected for progression
        puts "Invalid Candidate, please enter name correctly. "
        puts "\nPress Enter to return."
        gets
        return
    end

    # class method for editing candidate details
    def self.edit(job)
        puts "- Edit Candidate Details -"
        print "Enter name: "
        name = gets.chomp.to_s.downcase

        # iterating through total candidates to find selected by name
        for i in job.candidate_pool
            if i.name.downcase == name
                
                prompt = TTY::Prompt.new
                option = prompt.select("Field to Change?", %w(Name Occupation Email Number Address))
                
                # case statement passing option select from tty-prompt above
                case option
                when "Name"
                    puts "Enter new name: "
                    change = gets.chomp.to_s
                    # class method for 
                    Candidate.save_edits(i.name, :name, change)
                    
                    # load reference sequence for yaml data 
                    load_logs = []
                    YAML.load_stream(File.read './info/interview_logs.yml') { |interview| load_logs << interview }

                    # if check to skip loading sequence if yaml file is empty
                    if load_logs[0] == [nil]
                        # if empty, changes object data for session then returns
                        i.name = change
                        return
                    else
                        # updating the name change in interview logs also if the candidate has been booked in/completed one
                        for log in load_logs[0]
                            if log[:name] == i.name
                                log[:name] = change
                                File.open("./info/interview_logs.yml", 'w') { |file| file.write(load_logs[0].to_yaml, file) }
                            end
                        end
                    end
                    
                    # chaing object data in session also after updating interview logs
                    i.name = change
                    return
                when "Occupation"
                    # as above, changes to instance object and yaml files done for info if selected
                    puts "Enter new occupation: "
                    change = gets.chomp.to_s
                    Candidate.save_edits(i.name, :occupation, change)
                    i.occupation = change
                    return
                when "Email"
                    puts "Enter new email: "
                    change = gets.chomp.to_s
                    Candidate.save_edits(i.name, :email, change)
                    i.email = change
                    return
                when "Number"
                    puts "Enter new number: "
                    change = gets.chomp.to_s
                    Candidate.save_edits(i.name, :number, change)
                    i.number = change
                    return
                when "Address"
                    puts "Enter new address: "
                    change = gets.chomp.to_s
                    Candidate.save_edits(i.name, :address, change)
                    i.address = change
                    return
                end
            end
        end

        # notifies if invalid/non-existent candidate is selected
        puts "Invalid Candidate, please enter name correctly. "
        puts "\nPress Enter to return."
        gets
        return
    end

    # class method for disqualifying a candidate
    def self.disqualify(job)
        puts "- Disqualify Candidates -"
        print "Enter name: "
        name = gets.chomp.to_s.downcase

        # iterating through total pool to find candidate by name
        for i in job.candidate_pool
            if i.name.downcase == name

                # recording display date for reference with note
                date = Time.now
                format_date = "#{DateFormat.change_to(date, "MEDIUM_DATE")} #{DateFormat.change_to(date, "MEDIUM_TIME")} "

                # user input for reason which then stores into the interview log comments with above formated date
                puts "Reason for disqualification: "
                reason = gets.chomp.to_s
                i.notes.store(format_date, "DQ - Not Suitable: " + reason)

                # updating object status and yaml file status and moving into correct pool
                i.status = "Disqualified"
                Candidate.save_edits(i.name, :status, i.status)
                Candidate.move(i, Candidate.delete_from(job, i), job.disqualified_pool)
                return
            end
        end

        # notifies when invalid/non-existent candidate is chosen for disqualification
        puts "Invalid Candidate, please enter name correctly. "
        puts "\nPress Enter to return."
        gets
        return
    end

    # class method for saving edits to yaml file as used in above methods
    def self.save_edits(name, element, change)
        load_candidates = []
        YAML.load_stream(File.read './info/candidate_database.yml') { |candidate| load_candidates << candidate }
        for i in load_candidates[0]
            if i[:name] == name
                i[element] = change
            end
        end
        File.open("./info/candidate_database.yml", 'w') { |file| file.write(load_candidates[0].to_yaml, file) }
    end

end
# class for Candidate creation and management
class Candidate
    attr_accessor :name, :occupation, :email, :number, :address
    attr_accessor :status, :notes

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
        candidate = Candidate.new(name, occupation, email, number, address, "Applied", {})
        job.candidate_pool.push(candidate)
        job.applied_pool.push(candidate)
        job.applications += 1

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

        # File.open("candidate_database.yml", "a") { |file| file.write(saving.to_yaml) }

        load_candidates = []
        YAML.load_stream(File.read 'candidate_database.yml') { |candidate| load_candidates << candidate }
        load_candidates[0] << saving
        File.open("candidate_database.yml", 'w') { |file| file.write(load_candidates[0].to_yaml, file) }

    end

    # method for viewing candidate details
    def self.view(job)
        puts "- View Candidate -"
        print "Enter name: "
        name = gets.chomp.to_s.downcase
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
        puts "Invalid Candidate, please enter name correctly."
        puts "\nPress Enter to return"
        gets
    end

    def self.make_note(job)
        puts "- Make Note - "
        print "For (Enter Name): "
        name = gets.chomp.to_s.downcase
        for i in job.candidate_pool
            if i.name.downcase == name
                date = Time.now
                format_date = "#{DateFormat.change_to(date, "MEDIUM_DATE")} #{DateFormat.change_to(date, "MEDIUM_TIME")} "
                puts "Type Note Below, (Press Enter to save)"
                note = gets.chomp.to_s
                i.notes.store(format_date, note)
                load_candidates = []
                YAML.load_stream(File.read 'candidate_database.yml') { |candidate| load_candidates << candidate }
                for candidate in load_candidates[0]
                    if candidate[:name] == i.name 
                        candidate[:notes][format_date] = note
                    end
                end
                File.open("candidate_database.yml", 'w') { |file| file.write(load_candidates[0].to_yaml, file) }
                return
            end
        end
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
        for i in job.candidate_pool
            if i.name.downcase == name
                case i.status 
                when "Applied"
                    i.status = "Contacted"
                    Candidate.save_edits(i.name, :status, i.status)
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
                    puts "Candidate must be booked in for interview before progressing"
                    puts "\nPress Enter to return"
                    gets
                    return
                when "Interview"
                    load_logs = []
                    YAML.load_stream(File.read 'interview_logs.yml') { |interview| load_logs << interview }
                    for log in load_logs[0]
                        if log[:job_id] == job.id && log[:name].downcase == name && log[:status] == "Completed"
                            i.status = "Offer"
                            Candidate.save_edits(i.name, :status, i.status)
                            Candidate.move(i, job.interview_pool, job.offer_pool)
                            return
                        end
                    end
                
                    puts "Interview must be completed before sending offer"
                    puts "\nPress Enter to return"
                    return

                    # i.status = "Offered"
                    # Candidate.save_edits(i.name, :status, i.status)
                    # Candidate.move(i, job.interview_pool, job.offer_pool)
                    # return
                when "Offered"
                    i.status = "Accepted"
                    Candidate.save_edits(i.name, :status, i.status)
                    Candidate.move(i, job.offer_pool, job.accepted_pool)
                    return
                end
            end
        end
        puts "Invalid Candidate, please enter name correctly. "
        puts "\nPress Enter to return."
        gets
        return
    end

    def self.edit(job)
        puts "- Edit Candidate Details -"
        print "Enter name: "
        name = gets.chomp.to_s.downcase
        puts "Field to Change? Name [1] Occupation [2], Email [3], Number [4], Address [5]"
        option = gets.chomp.to_s
        for i in job.candidate_pool
            if i.name.downcase == name
                case option
                when "1"
                    puts "Enter new name: "
                    change = gets.chomp.to_s
                    Candidate.save_edits(i.name, :name, change)
                    i.name = change
                    return
                when "2"
                    puts "Enter new occupation: "
                    change = gets.chomp.to_s
                    Candidate.save_edits(i.name, :occupation, change)
                    i.occupation = change
                    return
                when "3"
                    puts "Enter new email: "
                    change = gets.chomp.to_s
                    Candidate.save_edits(i.name, :email, change)
                    i.email = change
                    return
                when "4"
                    puts "Enter new number: "
                    change = gets.chomp.to_s
                    Candidate.save_edits(i.name, :number, change)
                    i.number = change
                    return
                when "5"
                    puts "Enter new address: "
                    change = gets.chomp.to_s
                    Candidate.save_edits(i.name, :occupation, change)
                    i.address = change
                    return
                end
            end
        end
    end

    def self.delete_from(job, candidate)
        for i in job.all_pools
            if i.include?(candidate)
                i.delete(candidate)
            end
        end
    end

    def self.disqualify(job)
        puts "- Disqualify Candidates -"
        print "Enter name: "
        name = gets.chomp.to_s.downcase
        for i in job.candidate_pool
            if i.name.downcase == name
                date = Time.now
                format_date = "#{DateFormat.change_to(date, "MEDIUM_DATE")} #{DateFormat.change_to(date, "MEDIUM_TIME")} "
                puts "Reason for disqualification: "
                reason = gets.chomp.to_s
                i.notes.store(format_date, "Not Suitable: " + reason)
                i.status = "Disqualified"
                Candidate.move(i, Candidate.delete_from(job, i), job.disqualified_pool)
                return
            end
        end
        puts "Invalid Candidate, please enter name correctly. "
        puts "\nPress Enter to return."
        gets
        return
    end

    def self.save_edits(name, element, change)
        load_candidates = []
        YAML.load_stream(File.read 'candidate_database.yml') { |candidate| load_candidates << candidate }
        for i in load_candidates[0]
            if i[:name] == name
                i[element] = change
            end
        end
        File.open("candidate_database.yml", 'w') { |file| file.write(load_candidates[0].to_yaml, file) }
    end

end
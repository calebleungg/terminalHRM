class ApplicationController < ActionController::Base
    def get_candidate_id(name)
        @candidates.each do | candidate |
            if candidate[:name] == name
                @target_id = candidate[:id]
            end
        end
    end
end

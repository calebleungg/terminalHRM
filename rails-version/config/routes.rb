Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/", to: "job#index", as: "root"
  get "/job-manager/:job_id", to: "job#job_manager", as: "manager"
  get "/job-manager/:job_id/candidate/:candidate_id", to: "job#job_manager", as: "candidate"

  get "/new-job", to: "job#new", as: "new_job"
  get "/new-candidate", to: "candidate#new", as: "new_candidate"

  post "/new-candidate", to: "candidate#create", as: "create_candidate"
  post "/new-job", to: "job#create", as: "create_job"

  get "/progress-candidate", to: "candidate#progress", as: "progress_candidate"
  get "/disqualify-candidate", to: "candidate#disqualify", as: "disqualify_candidate"
  get "/edit-candidate/:candidate_id", to: "candidate#edit", as: "edit_candidate"

  patch "/job-manager/:job_id/candidate/:candidate_id", to: "candidate#update"

  get "/new-note/candidate/:candidate_id", to: "note#new", as: "new_note"
  post "/new-note/candidate/:candidate_id", to: "note#create"

  get "/new-interview/candidate/:candidate_id", to: "interview#new", as: "new_interview"
  post "/new-interview/candidate/:candidate_id", to: "interview#create"

end

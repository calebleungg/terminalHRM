Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/", to: "job#index", as: "root"
  get "/job-manager/:job_id", to: "job#job_manager", as: "manager"
  get "/job-manager/:job_id/candidate/:candidate_id", to: "job#job_manager", as: "candidate"

  get "/new-job", to: "job#new", as: "new_job"
  get "/new-candidate", to: "candidate#new", as: "new_candidate"

end

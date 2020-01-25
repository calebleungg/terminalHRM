Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/", to: "job#index", as: "root"
  get "/candidate/:id", to: "job#candidate", as: "candidate"
  get "/job-manager", to: "job#job_manager", as: "manager"

end

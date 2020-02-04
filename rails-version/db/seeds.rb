# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Candidate.destroy_all
Job.destroy_all

Candidate.create(first_name: "Caleb", last_name: "Leung", job_id: 14, occupation: "x", email: "test@email.com", number: "0423 111 222", status: "contacted")
Candidate.create(first_name: "John", last_name: "Wick", job_id: 14, occupation: "x", email: "test@email.com", number: "0423 111 222", status: "offer")
Candidate.create(first_name: "Thanos", last_name: "", job_id: 14, occupation: "x", email: "test@email.com", number: "0423 111 222", status: "disqualified")
Candidate.create(first_name: "Barack", last_name: "Obama", job_id: 14, occupation: "x", email: "test@email.com", number: "0423 111 222", status: "applied")
Candidate.create(first_name: "Conor", last_name: "McGregor", job_id: 14, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "applied")
Candidate.create(first_name: "Tim", last_name: "Cook", job_id: 14, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "screened")
Candidate.create(first_name: "Roger", last_name: "Federer", job_id: 14, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "applied")
Candidate.create(first_name: "Scott", last_name: "Morrison", job_id: 14, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "applied")
Candidate.create(first_name: "Snoop", last_name: "Lion", job_id: 1, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "applied")
Candidate.create(first_name: "Harry", last_name: "Potter", job_id: 1, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "contacted")
Candidate.create(first_name: "Naruto", last_name: "Uzumaki", job_id: 1, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "contacted")
Candidate.create(first_name: "James", last_name: "Bond", job_id: 1, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "contacted")
Candidate.create(first_name: "Edward", last_name: "Snowden", job_id: 1, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "shortlisted")
Candidate.create(first_name: "Albert", last_name: "Einstein", job_id: 1, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "shortlisted")
Candidate.create(first_name: "Pikachu", last_name: "", job_id: 1, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "interview")
Candidate.create(first_name: "Colonel", last_name: "Sanders", job_id: 1, occupation: "x", email: "test@email.com", number: "0423 111 222",  status: "applied")

Job.create(title: "Junior Developer", work_type: "Full time", salary: 65000, openings: 4, start_date: "01/07/2020", reporting_to: "Glen Kumar", status: "open")
Job.create(title: "Operations Manager", work_type: "Full time", salary: 80000, openings: 1, start_date: "01/07/2020", reporting_to: "Glen Kumar", status: "open")
Job.create(title: "Chief Technology Officer", work_type: "Full time", salary: 130000, openings: 1, start_date: "01/07/2020", reporting_to: "Glen Kumar", status: "open")
Job.create(title: "Financial Analyst", work_type: "Full time", salary: 75000, openings: 2, start_date: "01/07/2020", reporting_to: "Glen Kumar", status: "open")
Job.create(title: "Sales Consultant", work_type: "Full time", salary: 55000, openings: 3, start_date: "01/07/2020", reporting_to: "Glen Kumar", status: "closed")
Job.create(title: "Senior DevOps Engineer", work_type: "Full time", salary: 82000, openings: 1, start_date: "01/07/2020", reporting_to: "Glen Kumar", status: "closed")
require "./main-app"

# entering dummy jobs for testing


job1 = JobManager.new("1000", "Store Manager", "Permanent - Full Time", "70,000", 1, "30/11/19", "Jody Foster")
job2 = JobManager.new("1001", "Stock Filler", "Casual - Part Time", "24.50/hour", 3, "15/12/19", "Andy Lee")   
job3 = JobManager.new("1002", "Floor Assistant", "Casual - Part Time", "24.50/hour", 2, "15/12/19", "Charles Dickens")   
job4 = JobManager.new("1003", "Senior Butcher", "Permanent - Full Time", "65,000", 1, "27/11/19", "Shingo Nakamura")  


list1 =[]
list2 =[]
list3 =[]

candidate1 = Candidate.new("James Mackavoy", "Actor", "jmackavoy@gmail.com", "0400 000 111", "81 cresent round India Valley")
candidate2 = Candidate.new("Andrew Simon", "Professional Cricket Player", "ilovecricket@hotmail.com", "0400 000 222", "1/232 complex 3 James Street")
candidate3 = Candidate.new("Steve Jobs", "Apple CEO", "apple@apple.io", "0400 000 333", "100 Edward Street Brisbane City")
candidate4 = Candidate.new("Daniel Napalm", "Student", "daniel.napalm@gmail.com", "0400 000 444", "223 Adelaide Avenue Tasmania")
candidate5 = Candidate.new("Elizabeth Warren", "Politician", "voteforme1@usa.com", "0400 000 555", "8 Court House Road West End")
candidate6 = Candidate.new("Glen Kumar", "Educator at Coder Academy", "gkumar@coderacademy.com", "0400 000 666", "97 Eagle Farm Terrace, Gold Coast")
candidate7 = Candidate.new("Naveen Johnson", "Educator at Coder Academy", "njohnson@coderacademy.com", "0400 000 777", "Homeless")
candidate8 = Candidate.new("Amy Whinehouse", "Singer", "private", "0400 000 888", "91210 Beverly Road California")
candidate9 = Candidate.new("Pepsi Max", "A Soft Drink", "pepsi@co", "04000 000 999", "Everywhere")

list1 << candidate1
list1 << candidate2
list1 << candidate3
list1 << candidate4
list2 << candidate5
list2 << candidate6
list3 << candidate7
list3 << candidate8
list3 << candidate9

for i in list1 
    job1.candidate_pool.push(i)
    job1.applied_pool.push(i.name)
    job1.applications += 1
end
for i in list2
    job2.candidate_pool.push(i)
    job2.applied_pool.push(i.name)
    job2.applications += 1
end
for i in list3
    job3.candidate_pool.push(i)
    job3.applied_pool.push(i.name)
    job3.applications += 1
end
# Help File: terminalHRM

## Example Layout for YAML files to load correctly

## **Requirements**
Ensure all the key areas of information are included for each database

'---' is required at the top of the file

'-' is required to identify new recording.

These '-' are to indicate correct hash and array storage layouts in the yaml file to be loaded and edited correctly throughout the application.

#### For Job Database File

```
---
- :id: '1000'
  :title: Assistant Educator
  :type: Permanent - Part Time
  :salary: "$56,000"
  :openings: '1'
  :start_date: 01/02/20
  :manager: Glen Kumar
  :applications: 0
  :status: Open
- :id: '1001'
  :title: Lead Educataor
  :type: Permanent - Full Time
  :salary: "$72,000"
  :openings: '2'
  :start_date: 01/12/19
  :manager: Kanye West
  :applications: 0
  :status: Open
#<File:0x00007fca4f1a2450>
```
#### For Candidate Database File

```
---
- :job_id: '1000'
  :name: Barack Obama
  :occupation: Ex-President USA
  :email: classified information
  :number: classified information
  :address: classified information
  :status: Applied
  :notes: {}
- :job_id: '1000'
  :name: Harry Potter
  :occupation: Wizard
  :email: hpotter@hogwarts.com
  :number: 0404 939 020
  :address: Uncle's house under the stairs (for now...)
  :status: Contacted
  :notes:
    '17-Nov-2019 12:04 PM ': Kinda Clumsy
#<File:0x00007fa89d815f90>
```
#### For Interview Log File
```
---
- :job_id: '1000'
  :name: Thanos
  :date: 10/11/19
  :interviewers: Naveen & Glen & Ashleigh
  :duration: 45 minutes
  :location: Coder Academy Room 5
  :status: Completed
  :notes: 'Had strong feelings about halving the universe''s population. Probably
    not a good culture fit because of that. '
  :rating: 1
- :job_id: '1000'
  :name: caleb
  :date: d
  :interviewers: d
  :duration: d
  :location: d
  :status: Booked
  :notes: ''
  :rating: 0
#<File:0x00007fa89a9ef580>
```

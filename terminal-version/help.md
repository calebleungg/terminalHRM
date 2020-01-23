# terminalHRM - help file

## **Features**
* Multi-job management tool
* Extensive editing features
* User friendly error feedback
* Intuitive information display
* Comprehensive candidate handling features
* Compatible with ruby 
* Simplified save/load ability with terminal
* ```terminalHRM``` works across all systems that have ruby installed

## **Requirements**

* Ruby- updated to version 2.6.3 is recommended
* Windows OS / Mac OS both compatible
* Command Line access 

## **Usage (Auto)**

If you wish to manually run from the ruby executable- see "Installation-Manual" section below.

In order to turn on the application, ensure you're in the terminalHRM directory as downloaded onto your computer. 

And then execute:
```
$ ./terminal-hrm.sh
```



## **Installation (Manual)**

If you wish to manually run from the ruby executable- the following ruby gems must be installed on your computer:
```
gem "colorize", "~> 0.8.1"

gem "terminal-table", "~> 1.8"

gem "date_format", "~> 0.3.3"

gem "tty-prompt", "~> 0.19.0"

gem "tty-spinner", "~> 0.9.1"
```
These should already be in the Gemfile bundle, however if any one is missing, you can add each to your applications gem file like so:
```
gem 'tty-prompt'
```
Once, you have all the above gems, execute:
```
$ bundle install
```
Or install each yourself as:
```
$ gem install terminal-table
```
Once all gems have been installed, you can now start the application by executing:
```
$ ruby main-app.rb
```

# Support


## **Example Layout for YAML files to load correctly**

```
--- #is required at the top of the file
```
```
-   #is required to identify a new recording.
``` 

These indicate correct hash and array storage layouts in the yaml file to be loaded and edited correctly throughout the application.

If you would like to reset your applications database.

Initialising each file with a simple:
```
---
-
```

will allow for an empty Job listing UI to load up when starting.

Ensure all the key areas of information are included for each database. Find examples of correct yaml file layouts for each database below:


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
  :name: example name
  :date: example info
  :interviewers: example info
  :duration: example info
  :location: example info
  :status: Booked
  :notes: ''
  :rating: 0
#<File:0x00007fa89a9ef580>
```

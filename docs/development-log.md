# Development Log
#### terminalHRM - Caleb Leung

### 12.11.19 || Entry 1
* Initial progress sees a functioning UI developed for the top level overview of job listings, with the ability to create, edit, and manage jobs
* Next level UI on the job specific level is functional also
* However only the add a candidate feature has been added thus far
* A sizable hurdle was found when thinking of a way to appropriately display the tabular information showing a candidates progression- the main issue is terminal-table displays its information by row, thus making categorising things by column a challenge to organise and display correctly
* Currently, the way around this was to create an empty intial array that would be read as the rows, when a candidate is added, this would also add the following ["" , "", "", "", "", ""], to the empty "cumulative" array, and depending on the stage the candidate is at, each progress pool would be iterated through and the names appended to the correct index in the cumulative array, corresponding to their correct progression stage column
* Initially the  variables used to store a specific job's candidate pool was assigned a at the class level however it was realised this would pose a problem as it displayed the same pool for all job listings across the system. 
* The fix was to instance all the jobs created (these were stored in a hash previously at the JobOverview class level), and from there store all the candidate pools as an instance variable inside the job object
* As of now, functionality is fairly sound for all the available features
* It was thought up that a Job ID assigned to each job object would be a good way to instance, and bring forth selected jobs going forward.

#### Next Steps
* Will be to continue building upon the features at the job management level
* Test to see if the current interation method for correctly displaying progress information will work when integrating the other progression pools
* If not, find a better way to display the information

<br> 

### 12.11.19 || Entry 2
* Probably the most challenge aspect of development was figuring out a way to display a candidates progression through the stages correctly in tabular form yet keep the table dynamic depending on the number of candidates in each stage
* The solution was to create class variable counting the number of candidates in each stage stored in a separate array- and use the maximum value from that array to determine how many rows the table would dispaly 
* Next difficulties again were had in trying to understand how to get the candidate names stored in each separate progress pool, to display correctly in the corresponding column of progression
* A method was chosen to iterate through the cumulative array, using a counter to determine the index through each column, and to set the index correct for each row that corresponded to the candidate pool 
* After much efforts a correct way to display the progression was found
* From here a method for progressing/moving candidates to the next stage of the recruitment process was formed (relatively straight forward) using the candidate.status instance variable as a case variable for the corresponding options


#### Next Steps
* Will be to tie in the rest of the features such as scheduling interview, adding notes to candidate profiles with the rest of the application.

<br> 

### 14.11.19 || Entry 3
* All-round functionality of the application is now sound and fairly tested in all aspects
* Creating a job, adding a candidate, viewing details reports, adding notes, scheduling interviews, and all that have now viable
* Reporting can be more detailed and will be worked on
* Now the aim is to incorporate a save/load function so the application is actually practical in a real world sense (ie. all work being done in one terminal session isnt lost and is kept after closing the script)
* This will be done with YAML as the chosen method- using .yml documents to store the hash information when creating a job and candidate
* These YAML docs will be read and the iterated contents be loaded into job and candidate objects, to be initially stored for the application to load any previous work saved in these files
* Save/load functionality is very initial as it only allows for the creating and loading of the first instance created of the object
* Any further editing to the objects details (includes both jobs and candidates class) has not yet been coded to save properly as such is still lost when the application is terminated

#### Next Steps
* Continue incorporating proper save/load methods to store all progressed worked on
* A suggestion for creating a total search function of the database using any specific value could also be a next target feature

<br/>

### 16.11.19 || Entry 4
* Save and load function now works for all editing/adding features of the application
* A significant hurdle was trying to integrate save/loading correctly to yaml for each and every information piece that could be edited as the process to write to file was different for each depending on what I wanted to do with the specific information
* YAML files was used to store all information inside an Array containing an Array, that contained a list of hashes
* The way the information is retrived is by load_streaming the file onto a method variable that stores it initially, iterating onto that first index of the load_stream, then iterating through the list of arrays inside to find the correct piece of information to either change it, or to add another hash of information to the list of hashes in the array (first index of load_stream) to then write back the method variable onto the yaml file with the change.
* As save/load was integrated from bottom up (candidate level info to job info), the application was made dependent on having information already stored inside of the YAML files. 
* When I tried running the application as a fresh database without any information- the load process would iterate through the empty YAML file and throw an error (as an empty yaml file returns a nil value)
* The way around this was to add an if condition before every load/save requirement in the application to skip the loading process if the yaml file returned a nil. If it didnt then the load process would be passed through. 

#### Next Steps
* Possibly make load/save code a bit more DRY (a little repetitive currently)




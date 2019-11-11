# Development Log
#### Heich-aR-eM - Caleb Leung

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

<br> 

#### Next Steps
* Will be to continue building upon the features at the job management level
* Test to see if the current interation method for correctly displaying progress information will work when integrating the other progression pools
* If not, find a better way to display the information






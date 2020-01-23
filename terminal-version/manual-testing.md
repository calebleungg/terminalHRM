# Manual Test Records

## **Test 1**

**Scenario**: Progressing candidate past interview stage without completing interview

**Related Requirements**: R1 (Correct progression)

**Description**: Testing the application correctly blocks incorrect progressions when prerequisites aren’t met. The assumption will be that this is a returning user who has an active job with active candidates.

**Steps**:
1. Start the application in terminal
2. Select the “Manage” option from menu
3. Enter the job ID of an active job opening you wish to progress a candidate into offer stage for- you will be brought into the job management UI which will display all the candidates and stages of progression.
4. Progress a candidate who is in any pre shortlisted stage- this is done by selecting the “Progress Candidate” option from menu and entering the candidates name.
5. The candidate will move to the next stage column once this is done.
Do this again until the candidate reaches the shortlisted stage.
6. Once at the shortlisting stage, select the “Schedule Interview” option from the menu
7. Enter necessary details for the candidate’s interview- (dummy information is fine for the test)- press enter to save and return
8. Check to see the interview is recorded correctly by selecting the “Interview Log” option from menu- this will display an interview log below the progression UI with the newly scheduled interview. The status should read “Booked”- press enter to return
9. Now select the “Progress Candidate” option again and type in the candidates name you have just scheduled an interview for.
10. If successful, the application will prevent the candidate from progressing into offer stage.

**Expected Result**:<br> 
The application will throw a “Candidate interview must be completed before an offer can be made” error and prevent you from progressing the candidate.

<br> 

**Case 1**- as performed on 17/11/2019<br> 
**Test:**<br> 
1. Test-candidate-1 was created to perform the manual test. <br> 
2. Test-candidate-1 was progressed through to the shortlisting stage starting at the applied pool successfully. <br> 
3. An attempt was made to progress test-candidate-1 further but a prompt message prevented further progression until an interview was scheduled.<br> 
4. An interview was successfully scheduled with test candidate one- correctly showing in the interview log option.<br> 
5. A attempt was then made to progress test-candidate-1 onto offer stage. 
6. An error message notifying their interview must be marked completed showed, preventing the candidate from further progression until doing so. <br> 

**Result:** Expected- Test successful

**Case 2**- as performed on 18/11/2019<br> 
**Test:** 
1. An existing candidate was used for the test, already currently at interview stage. <br> 
2. Another variable added to ensure consistency, the candidate name was edited to see if this would affect the progression block. <br> 
3. The name change was reflected both when the application was exited and brought up again, in the interview logs, and also in the candidate profile.<br> 
4. An attempt was made to progress the candidate with the old name, however an invalid/5. non-existent candidate error message was thrown.<br> 
6. The candidate was progressed into the interview pool after scheduling an interview.
7. From there it was attempted to progress without completing the interview- the application through an error stating interviews must be completed before a candidate can progress further into offer stage. <br> 

**Result:** Expected- Test successful

<br>

## **Test 2**

**Scenario**: Edits to job details are saved correctly once terminal session ends.

**Related Requirements**: R2 (Save functionality)

**Description**: Testing the application correctly saves edits made to a job in one session carries over when the application is exited, and started again in another session. 

**Steps**:
1. Start the application in terminal.
2. Select the “Edit” option from menu.
3. Enter the job ID of an active job opening you wish to edit details for.
4. Select the information you wish to edit for the job.
5. Input your desired change- press enter to save and return
6. Once back at the job listing UI, your edits should be displayed correctly for the job listing.
7. Exit the application.
8. Start the application again.
9. Direct your attention towards the information you had previously edited for the job you chose.
10. If successfully saved from the previous session, your latest edit should still be there.

**Expected Result**:<br> 
The application save any changes to job details or candidate actions made in one session, and carry them over once closed, when the user opens the application again.

**Case 1**- as performed on 18/11/2019<br> 
**Test:**
1. For this case, it was aimed to change the job Assistant Educator's job status to pending.<br> 
2. The current status of the job was Open upon loading. <br> 
3. Navigating to the user selection point was successful- and the status was changed to Pending. <br> 
4. Pending was correctly shown in both the job listing UI, and also the job management UI in the job information section when we chose to manage the job. <br> 
5. The application was exited and loaded up again.
6. As seen, the job status was still set to Pending- reflective of our edit. <br> 

**Result:** Expected- Test successful

**Case 2**- as performed on 19/11/2019<br> 
**Test:**
1. For this test, the focus was changed to seeing if created candidate applications would save correctly to corresponding job openings. <br> 
2. First 2 test jobs were created with dummy information entered. <br> 
3. Selecting the manage option for the first test, 2 test candidates were entered in for the position.<br> 
4. Going back and managing the second test job, only 1 candidate was created for this opening.<br> 
6. The application was exited and restarted.
7. Focusing on the information- job 1's total application count was 2, and job 2's total application count was 1. <br> 
8. Entering in to both jobs, the correct candidate names that were created underneath each were found. <br>
9. To further test, we progressed one of job 1's candidates into the shortlisting stage- exited out of the application. Restarted, entered back in to manage job 1, and found the candidate correct saved still in the shortlisting pool column.

**Result:** Expected- Test successful

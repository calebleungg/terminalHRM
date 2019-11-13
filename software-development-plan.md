# Software Development Plan
### For **terminalHRM**

#### Founder, Caleb Leung - 10.11.19
![logo](./terminalHRM-logo.png)

## **Statement of Purpose and Scope**

terminalHRM is a terminal application software that provides a Human Resource Management solution for businesses of all sizes. terminalHRM will be all open source for the market (our class) to contribute and use freely. 

The application will aim to have the ability to open a job request, receive incoming applications, sort and manage candidates throughout the recruitment process, and have useful user tools at each step. 

Human resource management is essential for any business attempting to scale and grow, and is integrated in everything the business does. People make up the business, and well managed people allow for a well run business. Businesses that have little to no human resource management, or ones that choose to ignore it may find it coupable in early stage scaling, however when employee numbers grow, payroll accountabilities grow, workflow scope changes, without a well integrated system that keeps all these aspects interconnected, the business will suffer short term inefficiencies, and long term sustainability is very unlikely. 

terminalHRM has three clearly defined goals for development.

1. To make HRM easy and understandable for all levels of employees in the company
2. To simplify the end to end recruitment process into clearly defined stages
3. To provide meaningful information that the business can leverage to find opportunities for improvement across all areas. 

terminalHRM’s target audience include businesses of all sizes, in all industries, who are looking to grow their workforce with an easy, free, user-friendly solution to manage the process. 

Businesses without a current HRM solution will be a key target audience. terminalHRM provides a very introductory solution that they can try out and use indefinitely, that also is competitive and complete with all the features of large enterprise HRMs however who can provide on the fly, tailored features for clients due to being open source.  

Ones that have a current solution still show large opportunities for targeting, as terminalHRM will provide a financially better alternative and a software that is easier to utilise and simpler to understand with less complexities when compared to solutions that are hard to understand, higher barriers to learn, and causes user paralysis with too many unnecessary features. 

<br>

## **List of Features**

1. **Manage job opportunities**. The software will have a feature to manage multiple job opportunities, and provide a high-level overview of all current opportunities in the business. The software will also allow the user to manage the recruitment process of each opportunity separately. The software will provide a useful high-level details report summarising the progress of each opportunity. 

2. **Receive, record applications**. Within each job opportunity, the software will provide multiple features to- receive external applications, record indirect applications, view each candidate’s profile, see relevant details, edit these if necessary, and provide useful information reports on total applications, type of applicants, days live for the job posting etc. 

3. **To select and shortlist potential candidates**. This feature will also allow the user go through each candidate’s profile and shortlist them to the next stage if they have potential. Then from here, a user can schedule an interview with each shortlisted candidate. Once interviews are completed a user can then provide comments, feedback, and a star rating of each, or even request a 2nd stage interview if necessary. 

4. **Extend an offer**. The software will allow the user to select and send out an offer email for successful candidates, and to set a start date for each. From here the user can either close off the job opportunity if all the openings are filled, or continue to recruit for the roles, storing successful candidates in a completed pool.

5. **Reporting**. Throughout the applications, at almost each step of the process, the user will have access to an information report that displays all relevant information on the jobs/candidates/shortlists. This information can be printed out, edited, and shared/emailed to others working in the company. 

6. **Communication**. The application will allow a user to communicate and send emails to candidates or other work colleagues, and to make progress notes on specific jobs/candidates if multiple users are working on the same opportunity (to avoid double-work).

<br>

## **Implementation Plan**

| Features      | Description |
| ----------- | ----------- |
| **1. User Interface** | Create a class to display a basic UI for the software, includes all levels of the application     |
| 1.1 Homepage - Job listing UI |    Priority: **Important**      |
| 1.2 Job level - management UI |   Total Estimated Time: **1:30 hrs**       |
| 1.3 Details report UIs (all levels)|      |
| 1.4 Communication UIs |         |
|    |  |
| **2. Opportunities Features (Top Level)** | Main menu job creation/listing and management. The first thing the user lands on when opening the application.        |
| 2.1 Feature to create job listings|  Priority: **Required**        |
| 2.2 Feature to edit job listings |  Total Estimated Time: **1:30 hrs**        |
| 2.3 Feature to view job listings |      |
| 2.4 Feature to close job listings |    |
| | 
| **3. Job Management Features (Mid Level)** | Management of currently open jobs- recruitment proess for reviewing, screening, and organising candidates. |
| 3.1 Feature to accept candidates|  Priority: **Required**        |
| 3.2 Feature to record indirect candidate applications |  Total Estimated Time: **2:00 hrs**        |
| 3.3 Feature to view candidate profile |      |
| 3.4 Feature to edit candidate details |    |
| 3.5 Feature to view a report on total applicants |         |
| 3.6 Feature to shortlist a candidate |         |
||
| **4. Offer Features (Mid Level)** | Offering, accepting, and recording successful candidates |
| 4.1 Feature to schedule an interview with a candidate|  Priority: **Mid-level**        |
| 4.2 Feature to mark completed interviews- provide feedback and comments show on candidate profile |  Total Estimated Time: **2:00 hrs**        |
| 4.3 Feature to make notes on current candidate progression |      |
| 4.5 Feature to send out an offer letter email to candidates |    |
||
| **5. Reporting Features (Low Level)** | Reporting features across all stages of the application of relevant helpful information |
| 5.1 Feature to provide a report on total job opportunities currently open, previously completed and closed as well|  Priority: **Additional**        |
| 5.2 Feature to provide a report on current applicants across all jobs |  Total Estimated Time: **2:00 hrs**        |
| 5.3 Feature to provide a report on total shortlisted candidates across all jobs |      |
| 5.4 Feature to provide a report on total interviewed/scheduled to interview candidates across all jobs |    |
| 5.5 Feature to provide a report on all successfully offered candidates|    |
| 5.6 Feature to provide a report on all unsuccessful candidates|    |
||
| **6. Communications Features (Low Level)** | Communication features across the application to allow multi-member use in larger companies |
| 6.1 Feature to email candidates throughout all steps|  Priority: **Additional**        |
| 6.2 Feature to make progression notes on candidates or specific job openings |  Total Estimated Time: **1:00 hrs**        |
| 6.3 Feature to email colleagues reports/candidate profies/job opening information|      |





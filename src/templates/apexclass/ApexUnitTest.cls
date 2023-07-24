/**
 * @author      WDCi ()
 * @date        Aug 2023
 * @group       Test
 * @description Test class for 
 * @changehistory
 * 
 */
@isTest
private with sharing class <%= apiName %> {

	@TestSetup
    static void makeData(){
        
		// Create Test Data:
        final Integer APPLICANTS_QTY = 10;
        final Integer EDUCATIONAL_INSTITUTIONS_QTY = 1;
        final Integer UNIVERSITY_DEPARTMENTS_QTY = 1;   // per Educational Institution
        final Integer ACADEMIC_PROGRAMS_QTY = 1;        // per University Department        
        final Integer NUMBER_OF_TERMS = 2;
        
        // Create the RIO Edu Custom Settings:
        rio_ed__RIO_Education_Settings__c reduCustomSettings = REDU_TestDataFactory_UTIL.createRIOEduCustomSettings();
        
        // Set the RIO Edu Custom Settings for Auto-Student-Registration: 
        reduCustomSettings.Auto_Student_Community_Registration__c = true;
        reduCustomSettings.rio_ed__Student_Permission_Set__c = 'REDU_Student'; 
        reduCustomSettings.Student_User_Profile__c = 'REDU - Student';
        reduCustomSettings.rio_ed__Auto_Program_Enrollment_EDA_Application__c = true;
        reduCustomSettings.rio_ed__Enable_PE_Deletion_From_EDA_Application__c = false;

        update reduCustomSettings;
        
        // Create Trigger Handler records (TDTM):
        REDU_TestDataFactory_UTIL.createTdtmTriggerHandlers();
        
        // Create Applicants (i.e. Contacts):
        List<Id> applicantIdList = new List<Id>();
        applicantIdList = REDU_TestDataFactory_UTIL.createContacts(APPLICANTS_QTY);
        
        // Create Educational Institutions (i.e. Account RT: Educational Institution):
        List<Id> educationalInstitutionIdList = new List<Id>();
        educationalInstitutionIdList = REDU_TestDataFactory_UTIL.createEducationalInstitutions(EDUCATIONAL_INSTITUTIONS_QTY);
        
        // Create Campus Location
        List<Account> campusLocationAccounts = REDU_TestDataFactory_UTIL.getLocations(1, educationalInstitutionIdList[0]);
        insert campusLocationAccounts;

        // Create University Departments (i.e. Account RT: University Department):
        List<Id> universityDepartmentIdList = new List<Id>();
        universityDepartmentIdList = REDU_TestDataFactory_UTIL.createUniversityDepartments(educationalInstitutionIdList, UNIVERSITY_DEPARTMENTS_QTY);
        
        // Create Academic Programs (i.e. Account RT: Academic Program):
        List<Id> academicProgramIdList = new List<Id>();
        academicProgramIdList = REDU_TestDataFactory_UTIL.createAcademicPrograms(universityDepartmentIdList, ACADEMIC_PROGRAMS_QTY);

        List<hed__Term__c> listTerms = REDU_TestDataFactory_UTIL.createTerms(educationalInstitutionIdList[0], NUMBER_OF_TERMS);
        //Setup Previous_Term__c
        listTerms[1].rio_ed__Previous_Term__c = listTerms[0].Id;
        update listTerms[1];

        //Create Fees
        List<rio_ed__Fee__c> feeList = new List<rio_ed__Fee__c>();

        rio_ed__Fee__c courseFee = new rio_ed__Fee__c();
        courseFee.Name = 'courseFee';
        courseFee.rio_ed__Fee_Type__c = 'Tuition';
        courseFee.rio_ed__Fee_Unit__c = 'Course';
        courseFee.rio_ed__Loan_Fee__c = 10;
        courseFee.rio_ed__Discountable__c = true;

        rio_ed__Fee__c courseFeeCredit = new rio_ed__Fee__c();
        courseFeeCredit.Name = 'courseFeeCredit';
        courseFeeCredit.rio_ed__Fee_Type__c = 'Tuition';
        courseFeeCredit.rio_ed__Fee_Unit__c = 'Credit';

        rio_ed__Fee__c programFee = new rio_ed__Fee__c();
        programFee.Name = 'programFee';
        programFee.rio_ed__Fee_Type__c = 'Tuition';
        programFee.rio_ed__Fee_Unit__c = 'Program';

        feeList.add(courseFee);
        feeList.add(courseFeeCredit);
        feeList.add(programFee);

        insert feeList;

        //Create Fee Schedules
        List<rio_ed__Fee_Schedule__c> feeScheduleList = new List<rio_ed__Fee_Schedule__c>();
        
        for (rio_ed__Fee__c fee : feeList){
            rio_ed__Fee_Schedule__c fs = new rio_ed__Fee_Schedule__c();
            fs.Name = fee.Name + ' Fs';
            fs.rio_ed__Fee__c = fee.Id;
            fs.rio_ed__Fee_Start_Date__c = listTerms[0].hed__Start_Date__c;
            fs.rio_ed__Fee_End_Date__c = listTerms[1].hed__End_Date__c;
            fs.rio_ed__Current__c = true;

            if (fee.rio_ed__Fee_Unit__c == 'Course') {
                fs.rio_ed__Fee_Amount_Domestic__c = 1000;
                fs.rio_ed__Fee_Amount_International__c = 1100;
            } else if (fee.rio_ed__Fee_Unit__c == 'Credit') {
                fs.rio_ed__Fee_Amount_Domestic__c = 10;
                fs.rio_ed__Fee_Amount_International__c = 11;
            } else {
                fs.rio_ed__Fee_Amount_Domestic__c = 2000;
                fs.rio_ed__Fee_Amount_International__c = 2200;
            }

            feeScheduleList.add(fs);
        }
        insert feeScheduleList;

        //Create Fee Schedule Terms
        List<rio_ed__Fee_Schedule_Term__c> fstList = new List<rio_ed__Fee_Schedule_Term__c>();
        for (rio_ed__Fee_Schedule__c fs : feeScheduleList){
            for (hed__Term__c term : listTerms){
                rio_ed__Fee_Schedule_Term__c fst = new rio_ed__Fee_Schedule_Term__c();
                fst.rio_ed__Fee_Schedule__c = fs.Id;
                fst.rio_ed__Term__c = term.Id;
                fstList.add(fst);
            }
            
        }
        insert fstList;

        for (rio_ed__Fee_Schedule__c fs : feeScheduleList) {
            fs.rio_ed__Status__c = REDU_Contants.FEE_SCHEDULE_STATUS_APPROVED;
        }

        update feeScheduleList;

        // Create Program Plan
        List<hed__Program_Plan__c> listProgPlan = REDU_TestDataFactory_UTIL.createProgramPlans(academicProgramIdList, listTerms[0]);
        insert listProgPlan;
        
        // Create Program Group
        Map<String, String> progGroupNameMap = new Map<String, String>{'Computer Science Mandatory' => 'Computer Science Mandatory', 'Computer Science Elective' => 'Computer Science Elective'};
            String GROUP_CRITERIA_VALUE = 'All';
        List<hed__Plan_Requirement__c> programGroupList = REDU_TestDataFactory_UTIL.createPlan_Requirement_Groups(listProgPlan, progGroupNameMap.keySet(), false, GROUP_CRITERIA_VALUE);
        
        insert programGroupList;
        List<hed__Plan_Requirement__c> programGroupList1 = new List<hed__Plan_Requirement__c>{programGroupList[0]};
        List<hed__Plan_Requirement__c> programGroupList2 = new List<hed__Plan_Requirement__c>{programGroupList[1]};
        System.assertEquals(2, programGroupList.size());
        
        // Create Course:
        List<hed__Course__c> courseList = new List<SObject>();
        //Assign Fees
        for (hed__Course__c course : REDU_TestDataFactory_UTIL.createCourses(universityDepartmentIdList, false)){

            course.rio_ed__Fee__c = courseFee.Id;
            course.rio_ed__Use_Default_Fee__c = true;

            courseList.add(course);
        }

        for (hed__Course__c course : REDU_TestDataFactory_UTIL.createCourses(universityDepartmentIdList, false)){

            course.rio_ed__Fee__c = courseFeeCredit.Id;
            course.rio_ed__Use_Default_Fee__c = true;

            courseList.add(course);
        }

        for (hed__Course__c course : REDU_TestDataFactory_UTIL.createCourses(universityDepartmentIdList, false)){

            course.rio_ed__Fee__c = courseFee.Id;
            course.rio_ed__Use_Default_Fee__c = true;

            courseList.add(course);
        }

        insert courseList;

        //Create Course Offerings
        List<hed__Course_Offering__c> coList = new List<hed__Course_Offering__c>();
        for (hed__Term__c term : listTerms){
            List<hed__Course_Offering__c> newCos = REDU_TestDataFactory_UTIL.createCourseOfferings(courseList, term, false);
            coList.addAll(newCos);
        }
        insert coList;
        
        // Create Program Course
        List<hed__Plan_Requirement__c> programCourseList = new List<hed__Plan_Requirement__c>();
        List<hed__Plan_Requirement__c> pc1 = REDU_TestDataFactory_UTIL.createPlan_Requirement_Courses(false, courseList[0], programGroupList1, '');
        List<hed__Plan_Requirement__c> pc2 = REDU_TestDataFactory_UTIL.createPlan_Requirement_Courses(false, courseList[1], programGroupList1, '');
        List<hed__Plan_Requirement__c> pc3 = REDU_TestDataFactory_UTIL.createPlan_Requirement_Courses(false, courseList[2], programGroupList2, '');
        programCourseList.addAll(pc1);
        programCourseList.addAll(pc2);
        programCourseList.addAll(pc3);

        insert programCourseList;

        //Create Program Pathway
        List<rio_ed__Program_Pathway__c> programPathwayList = new List<rio_ed__Program_Pathway__c>();
        programPathwayList = REDU_TestDataFactory_UTIL.createProgramPathways('Test', 1, listProgPlan, 'Full-time');

        insert programPathwayList;
        
        //Create Program Pathway Unit
        List<rio_ed__Pathway_Unit__c> pathwayUnitList = new List<rio_ed__Pathway_Unit__c>();
        List<rio_ed__Pathway_Unit__c> pathwayUnitList1 = REDU_TestDataFactory_UTIL.createPathwayUnits(null, 1, programCourseList[0].Id, programPathwayList, null);
        List<rio_ed__Pathway_Unit__c> pathwayUnitList2 = REDU_TestDataFactory_UTIL.createPathwayUnits(null, 1, programCourseList[1].Id, programPathwayList, null);
        List<rio_ed__Pathway_Unit__c> pathwayUnitList3 = REDU_TestDataFactory_UTIL.createPathwayUnits(null, 2, programCourseList[2].Id, programPathwayList, null);
        pathwayUnitList.addAll(pathwayUnitList1);
        pathwayUnitList.addAll(pathwayUnitList2);
        pathwayUnitList.addAll(pathwayUnitList3);
        insert pathwayUnitList;

        for (hed__Program_Plan__c pp : listProgPlan) {
            for (rio_ed__Program_Pathway__c ppathway : programPathwayList){
                if (pp.Id == ppathway.rio_ed__Program_Plan__c) {
                    pp.rio_ed__Default_Program_Pathway__c = ppathway.Id;
                }
            }
        }

        update listProgPlan;

        insert REDU_TestDataFactory_UTIL.createFundings();		
		
    }
	
    @isTest
    static void testForAdmin() {
	
        // TO DO: implement unit test run as admin
		System.runAs(adminUser){
		
		}
		
    }
	
	@isTest
    static void testForStudent() {
		
		List<Contact> students = [SELECT Id, AccountId, Account.Name, FirstName, LastName, Email FROM Contact WHERE rio_ed__Faculty_Member__c = FALSE LIMIT 1];

        User adminUser = REDU_TestDataFactory_UTIL.createTestAdminUser();
        List<User> studentUsers = REDU_TestDataFactory_UTIL.createTestCommunityUsers(adminUser, students, 'REDU - Student');
		
        // TO DO: implement unit test run as student
		System.runAs(studentUsers[0]){
		
		}
		
    }
	
	@isTest
    static void testForFaculty() {
	
		List<Contact> faculties = [SELECT Id, AccountId, Account.Name, FirstName, LastName, Email FROM Contact WHERE rio_ed__Faculty_Member__c = TRUE LIMIT 1];

        User adminUser = REDU_TestDataFactory_UTIL.createTestAdminUser();
        List<User> facultyUsers = REDU_TestDataFactory_UTIL.createTestCommunityUsers(adminUser, faculties, 'REDU - Faculty');
		
        // TO DO: implement unit test run as faculty
		System.runAs(facultyUsers[0]){
		
		}
		
    }
	
}
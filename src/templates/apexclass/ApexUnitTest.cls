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
        
        // Create the RIO Edu Custom Settings:
        rio_ed__RIO_Education_Settings__c reduCustomSettings = redu_TestData_FACTORY.createRIOEduCustomSettings();
        // Set the RIO Edu Custom Settings for Auto-Student-Registration: 
        update reduCustomSettings;
        
        // Create Trigger Handler records (TDTM):
        redu_TestData_FACTORY.createTdtmTriggerHandlers();

        // Create Master Data
        redu_TestData_FACTORY.initMasterData();
        
        // Create Applicants (i.e. Contacts):
        List<Id> applicantIdList = new List<Id>();
        applicantIdList = redu_TestData_FACTORY.createContacts(APPLICANTS_QTY);
		
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

        User adminUser = redu_TestData_FACTORY.createTestAdminUser();
        List<User> studentUsers = redu_TestData_FACTORY.createTestCommunityUsers(adminUser, students, 'REDU - Student');
		
        // TO DO: implement unit test run as student
		System.runAs(studentUsers[0]){
		
		}
		
    }
	
	@isTest
    static void testForFaculty() {
	
		List<Contact> faculties = [SELECT Id, AccountId, Account.Name, FirstName, LastName, Email FROM Contact WHERE rio_ed__Faculty_Member__c = TRUE LIMIT 1];

        User adminUser = redu_TestData_FACTORY.createTestAdminUser();
        List<User> facultyUsers = redu_TestData_FACTORY.createTestCommunityUsers(adminUser, faculties, 'REDU - Faculty');
		
        // TO DO: implement unit test run as faculty
		System.runAs(facultyUsers[0]){
		
		}
		
    }
	
}
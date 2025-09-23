/**
 * @author      WDCi ()
 * @date        Aug 2023
 * @group       Test
 * @description Test data factory.
 * @changehistory
 * 
 */
public inherited sharing class redu_TestData_FACTORY {

    public static final Integer EDUCATIONAL_EDUCATION_QTY = 1;
    public static final Integer UNIVERSITY_DEPARTMENT_QTY = 1;  // per Educational Institution
    public static final Integer ACADEMIC_PROGRAM_QTY = 1;       // per University Department    
    public static final Integer NO_OF_TERMS = 2;
    public static final String FEE_SCHEDULE_STATUS_APPROVED = 'Approved';
	public static final String PLANREQUIREMENT_REQUIRED = 'Required';
	public static final String ENROLLMENT_METHOD_MANUAL = 'Manual';
	public static final String FUNDING_TYPE_SCHOLARSHIP = 'Scholarship';
	public static final String FUNDING_TYPE_DISCOUNT = 'Discount';
	public static final String FUNDING_TYPE_DISCOUNT_PERCENT = 'Discount %';

    /**
     * @description Creates default RIO Education custom settings
     * @return RIO_Education_Settings
     */
    public static rio_ed__RIO_Education_Settings__c createRIOEduCustomSettings() {
        
        rio_ed__RIO_Education_Settings__c customSettings = rio_ed__RIO_Education_Settings__c.getOrgDefaults();

        if (customSettings == null) {
            customSettings = new rio_ed__RIO_Education_Settings__c();
        }

        customSettings.rio_ed__Auto_Program_Enrollment__c = true;
        customSettings.rio_ed__Auto_Student_Community_Registration__c = false;
        customSettings.rio_ed__Student_User_Profile__c = 'REDU - Student Plus';
        customSettings.rio_ed__Faculty_User_Profile__c = 'REDU - Faculty';
        customSettings.rio_ed__Payment_URL__c = 'https://www.fakewebsite.net/payment';
        customSettings.rio_ed__Pathway_Prefix__c = 'myTerm';
        customSettings.rio_ed__Community_Username_Suffix__c = '@testuni.test';
        customSettings.rio_ed__Set_Program_Fee_Description__c = 'Full tuition fee for {!Program.Name}';
        customSettings.rio_ed__Auto_Lead_Conversion__c = true;
        customSettings.rio_ed__Lead_Converted_Status__c = 'Qualified';
        customSettings.rio_ed__Location_Resource_Calendar_Field__c = 'Name';
        customSettings.rio_ed__Late_Payment_Repeat_Setting__c = 'Once';
        customSettings.rio_ed__Late_Payment_Batch_Size__c = 200;
        customSettings.rio_ed__Academic_Program_Account_Record_Type__c = Schema.SObjectType.Account.getRecordtypeInfosByDeveloperName()
            .get('Academic_Program')
            .getRecordTypeId();
        customSettings.rio_ed__Educational_Institution_RT_Id__c = Schema.SObjectType.Account.getRecordtypeInfosByDeveloperName()
            .get('Educational_Institution')
            .getRecordTypeId();
        customSettings.rio_ed__University_Department_RT_Id__c = Schema.SObjectType.Account.getRecordtypeInfosByDeveloperName()
            .get('University_Department')
            .getRecordTypeId();
        customSettings.rio_ed__Location_RT_Id__c = Schema.SObjectType.Account.getRecordtypeInfosByDeveloperName()
            .get('Location')
            .getRecordTypeId();
        customSettings.rio_ed__Template_Session_RT_Id__c = Schema.SObjectType.rio_ed__Session__c.getRecordtypeInfosByDeveloperName()
            .get('Template')
            .getRecordTypeId();
        customSettings.rio_ed__Class_Session_RT_Id__c = Schema.SObjectType.rio_ed__Session__c.getRecordtypeInfosByDeveloperName()
            .get('Class')
            .getRecordTypeId();
        customSettings.rio_ed__Group_Plan_Requirement_RT_Id__c = Schema.SObjectType.hed__Plan_Requirement__c.getRecordtypeInfosByDeveloperName()
            .get('Group')
            .getRecordTypeId();
        customSettings.rio_ed__Course_Plan_Requirement_RT_Id__c = Schema.SObjectType.hed__Plan_Requirement__c.getRecordtypeInfosByDeveloperName()
            .get('Course')
            .getRecordTypeId();
        customSettings.rio_ed__Group_Discipline_Requirement_Id__c = Schema.SObjectType.rio_ed__Discipline_Requirement__c.getRecordtypeInfosByDeveloperName()
            .get('Group')
            .getRecordTypeId();
        customSettings.rio_ed__Course_Discipline_Requirement_RT_Id__c = Schema.SObjectType.rio_ed__Discipline_Requirement__c.getRecordtypeInfosByDeveloperName()
            .get('Course')
            .getRecordTypeId();
        customSettings.rio_ed__Group_PE_Discipline_Requirement_RT_Id__c = Schema.SObjectType.rio_ed__PE_Discipline_Requirement__c.getRecordtypeInfosByDeveloperName()
            .get('Group')
            .getRecordTypeId();
        customSettings.rio_ed__Course_PE_Discipline_Requirement_RT_Id__c = Schema.SObjectType.rio_ed__PE_Discipline_Requirement__c.getRecordtypeInfosByDeveloperName()
            .get('Course')
            .getRecordTypeId();
        customSettings.rio_ed__Grade_RT_Id__c = Schema.SObjectType.rio_ed__Grade__c.getRecordtypeInfosByDeveloperName()
            .get('Grade')
            .getRecordTypeId();
        customSettings.rio_ed__Sub_Grade_RT_Id__c = Schema.SObjectType.rio_ed__Grade__c.getRecordtypeInfosByDeveloperName()
            .get('Sub_Grade')
            .getRecordTypeId();
        customSettings.rio_ed__Resource_Type_Plan_RT_Id__c = Schema.SObjectType.rio_ed__Plan__c.getRecordTypeInfosByDeveloperName()
            .get('Resource_Type')
            .getRecordTypeId();
        customSettings.rio_ed__Session_Scheduler_REST_API_Url__c =
            'https://' +
            System.URL.getOrgDomainUrl().getHost() +
            '/services/apexrest/rio_ed/calendarevent';

        return customSettings;
    }

    /**
    * @description Create REDU TDTM trigger handlers.
    * @return void
    */
    public static void createTdtmTriggerHandlers() {

        // Installs the REDU TDTM trigger handlers:
        installTdtmTriggerHandlers();
    }

    /**
     * @description Helper method to initiate all RIO Education TDTM configuration (used in test class only)
     * @return void
     */
    public static void installTdtmTriggerHandlers() {

        // first retrieve default EDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();

        //Create RIO Ed trigger handlers using global method
        rio_ed.REDU_PostInstallation rpi = new rio_ed.REDU_PostInstallation();
        rpi.createAllTriggerHandlers();

        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);

        //Create all custom trigger handlers:
        List<hed__Trigger_Handler__c> triggerHandlers = new List<hed__Trigger_Handler__c>();
        triggerHandlers = redu_TestData_FACTORY.initCustomTriggerHandlers();

        insert triggerHandlers;
    }

    public static List<hed__Trigger_Handler__c> initCustomTriggerHandlers() {

        List<hed__Trigger_Handler__c> tHandlers = new List<hed__Trigger_Handler__c>();
        //Add custom trigger handler here
        tHandlers.add(createTriggerHandler('redu_CO_StudyOfferingSync','Course_Offering__c','BeforeDelete;AfterInsert;AfterUpdate','redu_CO_StudyOfferingSync_TDTM',3,true,true));

        return tHandlers;
    }

    private static hed__Trigger_Handler__c createTriggerHandler(String nameStr,String objectName,String triggerAction,String className,Integer loadOrder,Boolean userManaged,Boolean isActive) {
        
        hed__Trigger_Handler__c tHandler = new hed__Trigger_Handler__c();
        tHandler.Name = nameStr;
        tHandler.hed__Active__c = isActive;
        tHandler.hed__Class__c = className;
        tHandler.hed__Load_Order__c = loadOrder;
        tHandler.hed__Object__c = objectName;
        tHandler.hed__Trigger_Action__c = triggerAction;
        tHandler.hed__User_Managed__c = userManaged;
        tHandler.rio_ed__Unique_Key__c =
        objectName +
        '_' +
        className +
        '_' +
        String.valueOf(loadOrder);

        return tHandler;
    }

    /**
     * @description Default method to initiate master data
     * @param skipAfterObject Object to skip
     */
    public void initMasterData(String skipAfterObject) {

        // Create Test Data:
        Integer EDUCATIONAL_EDUCATION_QTY = 1;
        Integer UNIVERSITY_DEPARTMENT_QTY = 1;   // per Educational Institution
        Integer ACADEMIC_PROGRAM_QTY = 1;        // per University Department        
        Integer NO_OF_TERMS = 2;

        // Create Educational Institutions (i.e. Account RT: Educational Institution):
        List<Account> educationalInstitutionIdList = new List<Account>();
        educationalInstitutionIdList = redu_TestData_FACTORY.createEducationalInstitutions(true, EDUCATIONAL_EDUCATION_QTY);

        // Create Campus Location
        List<Account> campusLocationAccounts = redu_TestData_FACTORY.createLocations(true, 1, educationalInstitutionIdList[0].Id);

        // Create University Departments (i.e. Account RT: University Department):
        List<Account> universityDepartmentList = new List<Account>();
        universityDepartmentList = redu_TestData_FACTORY.createUniversityDepartments(true, educationalInstitutionIdList, UNIVERSITY_DEPARTMENT_QTY);

        // Create Academic Programs (i.e. Account RT: Academic Program):
        List<Account> academicProgramList = redu_TestData_FACTORY.createAcademicPrograms(true, universityDepartmentList, ACADEMIC_PROGRAM_QTY);

        List<hed__Term__c> listTerms = redu_TestData_FACTORY.createTerms(true, educationalInstitutionIdList[0].Id, NO_OF_TERMS);
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
        courseFee.rio_ed__Description__c = 'courseFee';

        rio_ed__Fee__c courseFeeCredit = new rio_ed__Fee__c();
        courseFeeCredit.Name = 'courseFeeCredit';
        courseFeeCredit.rio_ed__Fee_Type__c = 'Tuition';
        courseFeeCredit.rio_ed__Fee_Unit__c = 'Credit';
        courseFee.rio_ed__Description__c = 'courseFeeCredit';

        rio_ed__Fee__c programFee = new rio_ed__Fee__c();
        programFee.Name = 'programFee';
        programFee.rio_ed__Fee_Type__c = 'Tuition';
        programFee.rio_ed__Fee_Unit__c = 'Program';
        courseFee.rio_ed__Description__c = 'programFee';

        feeList.add(courseFee);
        feeList.add(courseFeeCredit);
        feeList.add(programFee);

        insert feeList;

        //Create Fee Schedules
        List<rio_ed__Fee_Schedule__c> feeScheduleList = redu_TestData_FACTORY.createFeeSchedules(false, feeList, listTerms[0], true);
        for(rio_ed__Fee_Schedule__c fs : feeScheduleList){

            if (fs.rio_ed__Fee_Description__c == 'courseFee') {
                fs.rio_ed__Fee_Amount_Domestic__c = 1000;
                fs.rio_ed__Fee_Amount_International__c = 1100;
            } else if (fs.rio_ed__Fee_Description__c == 'courseFeeCredit') {
                fs.rio_ed__Fee_Amount_Domestic__c = 10;
                fs.rio_ed__Fee_Amount_International__c = 11;
            } else {
                fs.rio_ed__Fee_Amount_Domestic__c = 2000;
                fs.rio_ed__Fee_Amount_International__c = 2200;
            }
        }
        insert feeScheduleList;

        //Create Fee Schedule Terms
        List<rio_ed__Fee_Schedule_Term__c> fstList = redu_TestData_FACTORY.createFeeScheduleTerms(true, feeScheduleList, listTerms[0]);

        for (rio_ed__Fee_Schedule__c fs : feeScheduleList) {
            fs.rio_ed__Status__c = FEE_SCHEDULE_STATUS_APPROVED;
        }
        update feeScheduleList;

        // Create Program Plan
        List<hed__Program_Plan__c> listProgPlan = redu_TestData_FACTORY.createProgramPlans(true, academicProgramList, listTerms[0]);

        // Create Program Group
        Map<String, String> progGroupNameMap = new Map<String, String>{'Computer Science Mandatory' => 'Computer Science Mandatory', 'Computer Science Elective' => 'Computer Science Elective'};
        String GROUP_CRITERIA_VALUE = 'All';
        List<hed__Plan_Requirement__c> programGroupList = redu_TestData_FACTORY.createPlan_Requirement_Groups(true, listProgPlan, progGroupNameMap.keySet(), GROUP_CRITERIA_VALUE);
        
        List<hed__Plan_Requirement__c> programGroupList1 = new List<hed__Plan_Requirement__c>{programGroupList[0]};
        List<hed__Plan_Requirement__c> programGroupList2 = new List<hed__Plan_Requirement__c>{programGroupList[1]};

        // Create Course:
        List<hed__Course__c> courseList = new List<SObject>();
        //Assign Fees
        for (hed__Course__c course : redu_TestData_FACTORY.createCourses(false, universityDepartmentList)){

            course.rio_ed__Fee__c = courseFee.Id;
            course.rio_ed__Use_Default_Fee__c = true;
            courseList.add(course);
        }

        for (hed__Course__c course : redu_TestData_FACTORY.createCourses(false, universityDepartmentList)){

            course.rio_ed__Fee__c = courseFeeCredit.Id;
            course.rio_ed__Use_Default_Fee__c = true;
            courseList.add(course);
        }

        for (hed__Course__c course : redu_TestData_FACTORY.createCourses(false, universityDepartmentList)){

            course.rio_ed__Fee__c = courseFee.Id;
            course.rio_ed__Use_Default_Fee__c = true;
            courseList.add(course);
        }

        insert courseList;

        //Create Course Offerings
        List<hed__Course_Offering__c> coList = new List<hed__Course_Offering__c>();
        for (hed__Term__c term : listTerms){
            List<hed__Course_Offering__c> newCos = redu_TestData_FACTORY.createCourseOfferings(false, courseList, term);
            coList.addAll(newCos);
        }
        insert coList;

        // Create Program Course
        List<hed__Plan_Requirement__c> programCourseList = new List<hed__Plan_Requirement__c>();
        List<hed__Plan_Requirement__c> pc1 = redu_TestData_FACTORY.createPlan_Requirement_Courses(false, courseList[0], programGroupList1, '');
        List<hed__Plan_Requirement__c> pc2 = redu_TestData_FACTORY.createPlan_Requirement_Courses(false, courseList[1], programGroupList1, '');
        List<hed__Plan_Requirement__c> pc3 = redu_TestData_FACTORY.createPlan_Requirement_Courses(false, courseList[2], programGroupList2, '');
        programCourseList.addAll(pc1);
        programCourseList.addAll(pc2);
        programCourseList.addAll(pc3);
        insert programCourseList;

        //Create Program Pathway
        List<rio_ed__Program_Pathway__c> programPathwayList = new List<rio_ed__Program_Pathway__c>();
        programPathwayList = redu_TestData_FACTORY.createProgramPathways(true, 'Test', 1, listProgPlan, 'Full-time');

        //Create Program Pathway Unit
        List<rio_ed__Pathway_Unit__c> pathwayUnitList = new List<rio_ed__Pathway_Unit__c>();
        List<rio_ed__Pathway_Unit__c> pathwayUnitList1 = redu_TestData_FACTORY.createPathwayUnits(false, null, 1, programCourseList[0].Id, programPathwayList, null);
        List<rio_ed__Pathway_Unit__c> pathwayUnitList2 = redu_TestData_FACTORY.createPathwayUnits(false, null, 1, programCourseList[1].Id, programPathwayList, null);
        List<rio_ed__Pathway_Unit__c> pathwayUnitList3 = redu_TestData_FACTORY.createPathwayUnits(false, null, 2, programCourseList[2].Id, programPathwayList, null);
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

        List<rio_ed__Funding__c> funding = redu_TestData_FACTORY.createFundings(false);
    }

    /**
     * @description Create contacts, skipping the dummyaccount flow
     * @param numContacts number of contacts to be created
     * @return List<Contact>
     */
    public static List<Contact> createContacts(Integer numContacts) {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < numContacts; i++) {
            Account acc = createAdminAccount('Test-' + i);
            accs.add(acc);
        }
        insert accs;

        Integer conCounter = 0;
        List<Contact> cons = new List<Contact>();
        for (Account acc : accs) {
            Contact con = new Contact(
                FirstName = acc.Name.substringBefore(' '),
                LastName = acc.Name.substringBefore(' '),
                Email = acc.Name.substringBefore('-') +
                acc.Name.substringAfter('-').left(1) +
                '.' +
                acc.Name.substringBefore('-') +
                acc.Name.substringAfter('-').left(1) +
                '@email.com',
                AccountId = acc.Id
            );
            con.rio_ed__Community_Username__c = con.Email;
            con.rio_ed__Community_Username_Prefix__c = 'testStud_' + conCounter + '_' + numContacts;
            con.hed__Preferred_Email__c = redu_PaymentConstant_UTIL.PREFERREDEMAIL_ALTERNATE;
            con.hed__AlternateEmail__c = con.Email;
            con.hed__PreferredPhone__c = 'Mobile Phone';
            con.MobilePhone = '1234567';
            cons.add(con);
            conCounter++;
        }

        return cons;
    }

    /**
     * @description Creates the dummy account
     * @return Account
     */
    public static Account createAdminAccount(String name) {
        Account adminAccount = new Account();
        adminAccount.Name = name + ' Admin Account';
        adminAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
            .get('Administrative')
            .getRecordTypeId();
        return adminAccount;
    }

    /**
     * @description Create educational institutions
     * @param numRecords number of EducationalInstitution to be created
     * @return List<Account>
     */
    public static List<Account> createEducationalInstitutions(Boolean dmlInsert, Integer numRecords) {
        Id eiRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
            .get('Educational Institution')
            .getRecordTypeId();
        List<Account> eiList = new List<Account>();

        for (Integer i = 0; i < numRecords; i++) {
            Account ei = new Account(
                Name = 'EducationalInstitution-' + i,
                rio_ed__EFTSL_Credit_Points__c = 100,
                RecordTypeId = eiRecordTypeId
            );
            eiList.add(ei);
        }
        if(dmlInsert){
            insert eiList;
        }

        return eiList;
    }

    /**
    * @description Create Locations.
    * @param numRecords number of Locations to be created
    * @return List<Account>
    */
    public static List<Account> createLocations(Boolean dmlInsert, Integer numRecords, Id eduInstId) {

        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        List<Account> listLoc = new List<Account>();

        for (Integer i = 0; i < numRecords; i++)
            listLoc.add(new Account(Name = 'Location-'+i, RecordTypeId = recTypeId, ParentId = eduInstId, rio_ed__Campus__c = true, rio_ed__Timezone__c = 'Australia/Sydney'));	// CAUTION: Account.Name = Location-X may be hardcoded in test classes

            
        if(dmlInsert){
            insert listLoc;
        }
        return listLoc;
    }

    /**
    * @description Create university department.
    * @param educationalInstitutionList list of educational institution record id
    * @param universityDepartmentNum number of contacts to be created
    * @return List<Id>
    */
    public static List<Account> createUniversityDepartments(Boolean dmlInsert, List<Account> educationalInstitutionList, Integer universityDepartmentNum) {

        Id udRecordTypeId = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('University Department').getRecordTypeId();

        List<Account> universityDepartmentList = new List<Account>();

        for (Account ei : educationalInstitutionList) {
            for (Integer i = 0; i < universityDepartmentNum; i++) {
                Account universityDepartment = 
                    new Account(Name = ei.Name + '-UniversityDepartment-' + i, 
                                ParentId = ei.Id, 
                                rio_ed__EFTSL_Credit_Points__c = 100, 
                                RecordTypeId = udRecordTypeId);
                universityDepartmentList.add(universityDepartment);
            }
        }

        if(dmlInsert){
            insert universityDepartmentList;
        }

        return universityDepartmentList;
    }

    /**
    * @description Create academic program.
    * @param universityDepartmentList list of university department record id
    * @param academicProgramNum number of contacts to be created
    * @return List<Id>
    */
    public static List<Account> createAcademicPrograms(Boolean dmlInsert, List<Account> universityDepartmentList, Integer academicProgramNum) {

        Id apRecordTypeId = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Academic Program').getRecordTypeId();

        List<Account> academicProgramList = new List<Account>();        
        for (Account ud : universityDepartmentList) {
            for (Integer i = 0; i < academicProgramNum; i++) {
                Account academicProgram = 
                    new Account(Name = ud.Name + '-AcademicProgram-' + i, 
                                ParentId = ud.Id, 
                                rio_ed__EFTSL_Credit_Points__c = 100,
                                rio_ed__Program_Code__c = 'AP' + i, //CM 26/11/2018 - Added for Grade Setting unique name assignment
                                rio_ed__Fee_Due_Days__c = 60, //CM 24/06/2019 - ISS-000135
                                RecordTypeId = apRecordTypeId);
                academicProgramList.add(academicProgram);
            }
        }

        if(dmlInsert){
            insert academicProgramList;
        }
        
        return academicProgramList;
    }

    /**
    * @description Create term.
    * @param instituteId educational institution id
    * @param numberOfTerms number of terms to be created
    * @return List<hed__Term__c>
    */
    public static List<hed__Term__c> createTerms(Boolean dmlInsert, Id instituteId, Integer numberOfTerms){
        List<hed__Term__c> listTerms = new List<hed__Term__c>();
        Integer term_length_in_months = 11;
        Integer number_of_months_in_term = 12;
        //Date termStartDate = Date.newInstance(Date.today().Year(),01,01);
        Date termStartDate = System.today().addDays(-30);
        Date termEndDate   = termStartDate.addMonths(term_length_in_months);
        
        for (Integer i = 0; i < numberofTerms; i++ ) {
            hed__Term__c term = new hed__Term__c(hed__Account__c = instituteId);
            term.Name = termStartDate.year() +' - Term '+i;
            term.hed__Start_Date__c = termStartDate;
            term.hed__End_Date__c = termEndDate;
            listTerms.add(term);
            
            termStartDate = termStartDate.addMonths(number_of_months_in_term);
            termEndDate = termStartDate.addMonths(term_length_in_months);
        }
        
        if(dmlInsert){
            insert listTerms;
        }
        
        return listTerms;
    }

    /**
     * @description Create Fee Schedules
     * @param feeList Fee list
     * @param term Term
     * @param current Is this fee schedule current?
     * @return List<rio_ed__Fee_Schedule__c>
     */
    public static List<rio_ed__Fee_Schedule__c> createFeeSchedules(Boolean dmlInsert, List<rio_ed__Fee__c> feeList, hed__Term__c term, Boolean current){

        List<rio_ed__Fee_Schedule__c> fsList = new List<rio_ed__Fee_Schedule__c>();
        Integer feeAmount = 1000;
        for (rio_ed__Fee__c fee : feeList){
            rio_ed__Fee_Schedule__c fs = new rio_ed__Fee_Schedule__c();
            fs.Name = fee.Name + ' Fs';
            fs.rio_ed__Fee__c = fee.Id;
            fs.rio_ed__Fee_Start_Date__c = term.hed__Start_Date__c;
            fs.rio_ed__Fee_End_Date__c = term.hed__End_Date__c;
            fs.rio_ed__Current__c = current;
            fs.rio_ed__Fee_Amount_Domestic__c = feeAmount;
            fs.rio_ed__Fee_Amount_International__c = feeAmount + 1;
            fs.rio_ed__Fee_Description__c = fee.rio_ed__Description__c;
            fs.rio_ed__Fee_Schedule_Fee_Unit__c = fee.rio_ed__Fee_Unit__c;
            fs.rio_ed__Discountable__c = fee.rio_ed__Discountable__c;
            fs.rio_ed__Non_repeatable__c = fee.rio_ed__Non_repeatable__c;
            fsList.add(fs);
            feeAmount += 1000;
        }

        if(dmlInsert){
            insert fsList;
        }
        return fsList;
    }

    /**
     * @description Create Fee Schedule Terms
     * @param fsList Fee Schedule list
     * @param term Term
     * @return List<rio_ed__Fee_Schedule_Term__c>
     */
    public static List<rio_ed__Fee_Schedule_Term__c> createFeeScheduleTerms(Boolean dmlInsert, List<rio_ed__Fee_Schedule__c> fsList, hed__Term__c term){

        List<rio_ed__Fee_Schedule_Term__c> fstList = new List<rio_ed__Fee_Schedule_Term__c>();
        for (rio_ed__Fee_Schedule__c fs : fsList){
            rio_ed__Fee_Schedule_Term__c fst = new rio_ed__Fee_Schedule_Term__c();
            fst.rio_ed__Fee_Schedule__c = fs.Id;
            fst.rio_ed__Term__c = term.Id;
            fstList.add(fst);
        }

        if(dmlInsert){
            insert fstList;
        }
        return fstList;
    }

    /**
    * @description Create Program Plans.
    * @param programList List of Academic Programs to create plans for
    * @param termList List of Terms, mainly just used to determine dates of the Program Plan
    * @return List<hed__Program_Plan__c>
    */
    public static List<hed__Program_Plan__c> createProgramPlans(Boolean dmlInsert, List<Account> programList, hed__Term__c term){

        List<hed__Program_Plan__c> programPlanList = new List<hed__Program_Plan__c>();
        for (Account program : programList){
            hed__Program_Plan__c pp = new hed__Program_Plan__c();
            pp.Name = 'Program Plan ' + term.Name;
            pp.hed__Account__c = program.Id;
            pp.hed__Start_Date__c = term.hed__Start_Date__c;
            pp.hed__End_Date__c = term.hed__End_Date__c;
            pp.hed__Is_Primary__c = true;
            pp.hed__Status__c = 'Current';
            pp.rio_ed__Next_Starting_Term__c = term.Id;
            pp.rio_ed__Fee_Method__c = 'Course';
            pp.rio_ed__Pay_Upfront__c = 'No';
            
            programPlanList.add(pp);
        }

        if(dmlInsert){
            insert programPlanList;
        }
        return programPlanList;
    }

    /**
    * @description Create Plan Requirement groups.
    * @param progPlans list of program plans
    * @param progGroupName set of program group's name
    * @param dmlInsert indicate to create or just initialise the records
    * @param groupCriteria group criteria for completion engine (e.g, All/Credits Earned/Courses Passed)
    * @return List<SObject>
    */
    public static List<SObject> createPlan_Requirement_Groups(Boolean dmlInsert, List<hed__Program_Plan__c> progPlans, Set<String> progGroupName, String groupCriteria) {

        List<hed__Plan_Requirement__c> progGroups = new List<hed__Plan_Requirement__c>();
        for (String groupName: progGroupName) {
            for (hed__Program_Plan__c pp: progPlans) {
                hed__Plan_Requirement__c progGroup = new hed__Plan_Requirement__c();
                progGroup.hed__Program_Plan__c = pp.Id;
                progGroup.Name = groupName;
                progGroup.hed__Category__c = PLANREQUIREMENT_REQUIRED;
                progGroup.hed__Credits__c = 10;
                //progGroup.rio_ed__Requirement_Logic__c = groupCriteria;
                progGroup.recordTypeId = Schema.SObjectType.hed__Plan_Requirement__c.getRecordTypeInfosByDeveloperName().get('Group').getRecordTypeId();
                progGroups.add(progGroup);
            }
        }

        if(dmlInsert){
            insert progGroups;
        }

        return progGroups;
    }

    /**
    * @description Create course.
    * @param departmentsId list of department id
    * @param dmlInsert indicate to create or just initialise the records
    * @return List<SObject>
    */
    public static List<hed__Course__c> createCourses(Boolean dmlInsert, List<Account> departmentList) {
        
        List<hed__Course__c> courseList = new List<hed__Course__c>();
        
        integer counter = 1;
        for (Account dptmentAcc: departmentList) {
            hed__Course__c course = new hed__Course__c();
            course.hed__Account__c = dptmentAcc.Id;
            course.Name = 'COURSE_'+ counter;
            course.hed__Course_ID__c = 'CO_'+ counter;
            course.hed__Credit_Hours__c = 7.000;
            course.rio_ed__Credit_Points__c = 7;
            counter++;
            courseList.add(course);
        }
        
        if(dmlInsert){
            insert courseList;
        }
        
        return courseList;
    }

    /**
    * @description Create course offering.
    * @param courseList list of course (hed__Course__c)
    * @param term related term (hed__Term__c)
    * @param dmlInsert whether to insert the Course Offerings
    * @return List<hed__Course_Offering__c>
    */
    public static List<hed__Course_Offering__c> createCourseOfferings(Boolean dmlInsert, List<hed__Course__c> courseList, hed__Term__c term) {
        
        List<hed__Course_Offering__c> listCO = new List<hed__Course_Offering__c>();
        Integer counter = 1;

        for (hed__Course__c c : courseList) {
            hed__Course_Offering__c co = new hed__Course_Offering__c();
            co.hed__Course__c = c.Id;
            co.hed__Capacity__c = 100;
            co.hed__Term__c = term.Id;
            co.hed__Start_Date__c = term.hed__Start_Date__c;
            co.hed__End_Date__c = term.hed__End_Date__c;
            co.Name = 'COURSE_OFFERING_'+ counter;
            counter++;
            listCO.add(co);
              
        }

        if (dmlInsert){
            insert listCO;
        }
        return listCO;
    }

    /**
    * @description Create Plan Requirement courses.
    * @param academicProgramIdList list of academic program id (account Id)
    * @param dmlInsert indicate to create or just initialise the records
    * @param course course (hed__Course__c) record
    * @param programGroupList list of Plan Requirement group (hed__Plan_Requirement__c)
    * @param reqLogic requirement logic string if you are going to define program requirement status
    * @return List<SObject>
    */
    public static List<hed__Plan_Requirement__c> createPlan_Requirement_Courses(Boolean dmlInsert, hed__Course__c course, List<hed__Plan_Requirement__c> planRequirementGroupList, String reqLogic) {
                                 
        List<hed__Plan_Requirement__c> planReqCourses = new List<hed__Plan_Requirement__c>();
        Set<String> progPlanId_courseIdSet = new Set<String>();
        
        for (hed__Plan_Requirement__c progGroup : planRequirementGroupList) {
            //Prevent duplicates
            String progPlanId_courseId = progGroup.hed__Program_Plan__c + '_' + course.Id;
            if (!progPlanId_courseIdSet.contains(progPlanId_courseId)){
                progPlanId_courseIdSet.add(progPlanId_courseId);
                
                hed__Plan_Requirement__c planReqCourse = new hed__Plan_Requirement__c();
                planReqCourse.hed__Course__c = course.Id;
                //planReqCourse.hed__Program_Plan__c = prog.Id;
                planReqCourse.hed__Program_Plan__c = progGroup.hed__Program_Plan__c;
                planReqCourse.hed__Plan_Requirement__c = progGroup.Id;
                planReqCourse.rio_ed__Requirement_Logic__c = reqLogic;
                planReqCourse.hed__Category__c = PLANREQUIREMENT_REQUIRED;
                planReqCourse.hed__Credits__c = 10; //Added 07/07/2021 by CM to pass validation rule
                planReqCourse.recordTypeId = Schema.SObjectType.hed__Plan_Requirement__c.getRecordTypeInfosByDeveloperName().get('Course').getRecordTypeId();
                planReqCourses.add(planReqCourse);
            }
        }
        
        if (dmlInsert){
            insert planReqCourses;
        }
        
        return planReqCourses;
    }

    /**
    * @description Create program pathway.
    * @param noteStr note or description for a program pathway
    * @param noOfTerm number of term to complete a pathway
    * @param progPlanList list of program plans
    * @param studyModeStr default study mode
    * @return List<rio_ed__Program_Pathway__c>
    */
    public static List<rio_ed__Program_Pathway__c> createProgramPathways(Boolean dmlInsert, String noteStr, Integer noOfTerm, List<hed__Program_Plan__c> progPlanList, String studyModeStr) {
        
        List<rio_ed__Program_Pathway__c> progPathways = new List<rio_ed__Program_Pathway__c>();
         
        for (hed__Program_Plan__c progPlan: progPlanList) {
            rio_ed__Program_Pathway__c pp = new rio_ed__Program_Pathway__c();
            pp.rio_ed__Notes__c = noteStr;
            pp.rio_ed__Number_of_Terms__c = noOfTerm;
            pp.rio_ed__Program_Plan__c = progPlan.Id;
            pp.rio_ed__Study_Mode__c = studyModeStr;
            pp.rio_ed__Enrollment_Method__c = ENROLLMENT_METHOD_MANUAL;
            
            progPathways.add(pp);
        }
        if(dmlInsert){
            insert progPathways;
        }
        return progPathways;
    }

    /**
    * @description Create pathway units.
    * @param numCourseFromGroup number of elective courses to be completed for a pathway unit if there is no specific core course to be done 
    * @param termNum number of term to complete a pathway
    * @param progCourseId program course (rio_ed__Program_Course__c) id
    * @param progPathwayIdList list of program pathway (rio_ed__Program_Pathway__c) id
    * @param progGroupId program group (rio_ed__Program_Group__c) id
    * @return List<rio_ed__Pathway_Unit__c>
    */
    public static List<rio_ed__Pathway_Unit__c> createPathwayUnits(Boolean dmlInsert, Integer numCourseFromGroup, Integer termNum, 
                                                   Id progCourseId, List<rio_ed__Program_Pathway__c> progPathwayIdList, Id progGroupId){
    
        List<rio_ed__Pathway_Unit__c> pathwayUnits = new List<rio_ed__Pathway_Unit__c>();
        
        for (rio_ed__Program_Pathway__c pp: progPathwayIdList) {
            rio_ed__Pathway_Unit__c pu = new rio_ed__Pathway_Unit__c();
            
            if (progCourseId != null){
                pu.rio_ed__Plan_Requirement_Course__c = progCourseId;
            } else {
                pu.rio_ed__Number_of_Courses_from_Group__c = numCourseFromGroup;
                pu.rio_ed__Plan_Requirement_Group__c = progGroupId;
            }
            
            pu.rio_ed__Program_Pathway__c = pp.Id;
            pu.rio_ed__Term_Number__c = termNum;
            
            pathwayUnits.add(pu);
        }
        
        if(dmlInsert){
            insert pathwayUnits;
        }
        return pathwayUnits;
    }

    /**
     * @description Creates 3 Funding records
     *              [0] - Scholarship for $10,000
     *              [1] - Discount Amount for $800
     *              [2] - Discount % for 5%
     * @return List<rio_ed__Funding__c>
     */
    public static List<rio_ed__Funding__c> createFundings(Boolean dmlInsert){
        List<rio_ed__Funding__c> fundingList = new List<rio_ed__Funding__c>();
        rio_ed__Funding__c f0 = new rio_ed__Funding__c();
        f0.Name = 'Scholarship Funding';
        f0.rio_ed__Total_Fund__c = 10000;
        f0.rio_ed__Funding_Start_Date__c = System.today().addDays(-30);
        f0.rio_ed__Funding_End_Date__c = System.today().addDays(366);
        f0.rio_ed__Funding_Type__c = FUNDING_TYPE_SCHOLARSHIP;
        f0.rio_ed__Status__c = 'Active';
        f0.rio_ed__Code__c = 'SCHOLAR001';
        rio_ed__Funding__c f1 = new rio_ed__Funding__c();
        f1.Name = 'Discount Amount';
        f1.rio_ed__Discount_Amount__c = 800;
        f1.rio_ed__Funding_Start_Date__c = System.today().addDays(-30);
        f1.rio_ed__Funding_End_Date__c = System.today().addDays(366);
        f1.rio_ed__Funding_Type__c = FUNDING_TYPE_DISCOUNT;
        f1.rio_ed__Status__c = 'Active';
        f1.rio_ed__Code__c = 'CODE001';
        rio_ed__Funding__c f2 = new rio_ed__Funding__c();
        f2.Name = 'Discount Percent';
        f2.rio_ed__Discount_Percent__c = 5;
        f2.rio_ed__Funding_Start_Date__c = System.today().addDays(-30);
        f2.rio_ed__Funding_End_Date__c = System.today().addDays(366);
        f2.rio_ed__Funding_Type__c = FUNDING_TYPE_DISCOUNT_PERCENT;
        f2.rio_ed__Status__c = 'Active';
        f2.rio_ed__Code__c = 'CODE002';
        fundingList.add(f0);
        fundingList.add(f1);
        fundingList.add(f2);

        if(dmlInsert){
            insert fundingList;
        }
        return fundingList;
    }

    public static User createTestAdminUser(){
        // Create an Admin User to update the Crud/Fls permissions for testing:
        User adminUser = new User();
        adminUser.FirstName = 'AdminUserFirstname';
        adminUser.Lastname = 'AdminUserLastname';
        adminUser.Username = adminUser.FirstName + '.' + adminUser.LastName.deleteWhitespace() + '@rioedu.net';
        adminUser.Email = adminUser.Username;
        adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        adminUser.TimeZoneSidKey = 'Australia/Brisbane';
        adminUser.LocaleSidKey = 'en_AU';
        adminUser.EmailEncodingKey = 'UTF-8';
        adminUser.LanguageLocaleKey = 'en_US';
        adminUser.Alias = adminUser.Firstname.deleteWhitespace().left(2) + 
                    adminUser.Lastname.deleteWhitespace().right(2) + 
                    adminUser.Firstname.right(1);
        adminUser.CommunityNickname = adminUser.Username.substringBefore('@');
        adminUser.isActive = true;
        insert adminUser;
        System.assert(adminUser.Id != null, 'No user created');

        return adminUser;
    }

    public static List<User> createTestCommunityUsers(User runAsUser, List<Contact> contacts, String profileName){
        
        List<User> commUsers = new List<User>();
        Id profileId = [SELECT Id FROM Profile WHERE Name =: profileName LIMIT 1].Id;

        for(Contact cont : contacts){
            // Create a Test User to test the Crud/Fls permissions:
            User testUser = new User();
            testUser.ContactId = cont.Id;
            testUser.FirstName = cont.FirstName;
            testUser.Lastname = cont.LastName;
            testUser.Username = testUser.FirstName + '.' + testUser.LastName.deleteWhitespace() + '@rioedu.net';
            testUser.Email = testUser.Username;
            testUser.ProfileId = profileId;
            testUser.TimeZoneSidKey = 'Australia/Brisbane';
            testUser.LocaleSidKey = 'en_AU';
            testUser.EmailEncodingKey = 'UTF-8';
            testUser.LanguageLocaleKey = 'en_US';
            testUser.Alias = testUser.Firstname.deleteWhitespace().left(2) + 
                        testUser.Lastname.deleteWhitespace().right(2) + 
                        testUser.Firstname.right(1);
            testUser.CommunityNickname = testUser.Username.substringBefore('@');
            testUser.isActive = true;

            commUsers.add(testUser);
        }

        insert commUsers;

        // Assign the 'REDU - Admin' Permission Set to the Test User:
        System.runAs(runAsUser) {
            PermissionSet ReduAdminPs = [SELECT Id FROM PermissionSet WHERE Name = 'REDU_Student'];
            System.assertNotEquals(null, ReduAdminPs.Id);

            List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
            for(User testUser : commUsers){
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.PermissionSetId = ReduAdminPs.Id;
                psa.AssigneeId = testUser.Id;

                psaList.add(psa);
            }

            insert psaList;
        }

        return commUsers;
    }
}
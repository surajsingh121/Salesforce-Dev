@isTest
private class LeadProcessorTest {
    @testSetup
    static void setup() {
        // Insert 200 Lead records
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(LastName = 'Test' + i, Company = 'TestCompany' + i));
        }
        insert leads;
    }

    @isTest
    static void testLeadProcessor() {
        // Start the test
        Test.startTest();
        
        // Execute the LeadProcessor batch class
        LeadProcessor leadProcessor = new LeadProcessor();
         Id batchId = Database.executeBatch(leadProcessor, 200);
        
        // End the test
        Test.stopTest();
        
        // Verify that all Lead records were updated correctly
        for (Lead lead : [SELECT LeadSource FROM Lead]) {
            System.assertEquals('Dreamforce', lead.LeadSource);
        }
    }
}
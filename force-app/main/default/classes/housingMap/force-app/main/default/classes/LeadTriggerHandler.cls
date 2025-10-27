public class LeadTriggerHandler {

    public static void createCaseForNewLeads(List<Lead> newLeads) {
        Set<Id> ownerIds = new Set<Id>();
       
        List<Case> casesToCreate = new List<Case>();

        for (Lead lead : newLeads) {
            Case newCase = new Case();
            newCase.Origin = 'Web';
            newCase.Status = 'New';
            newCase.SuppliedName = lead.Name;
            newCase.SuppliedEmail = lead.Email;
            newCase.SuppliedPhone = lead.Phone;
            newCase.OwnerId = lead.OwnerId; 
            newCase.Agent_Name__c = lead.Id;
            
            casesToCreate.add(newCase);
        }

        if (!casesToCreate.isEmpty()) {
            insert casesToCreate;
        }
    }
   /* public  static void createDuplicateLead(List<Lead> newLead){
        List<Lead> duplicateLead = new List<Lead>();
        for(Lead leadList : newLead){
           
           // leadList.Company = leadList.Company;
            leadList.LastName =leadList.LastName;
            leadList.Status = leadList.Status;
            duplicateLead.add(leadList);
        }
	
        if(!duplicateLead.isEmpty()){
            update duplicateLead;
        }
    } */
    public static void changeStatusAfterUpdate(List<Lead> newLeads){
        for(Lead leadRecord : newLeads){
            leadRecord.Status ='Working-Contacted';
        }
    }
    public static void updateLead(List<Lead> newList){
        
        for(Lead leadRecord : newList){
            if(leadRecord.Industry == 'Healthcare'){
                leadRecord.LeadSource = 'Purchased-List';
                leadRecord.SICCode__c = '1100';
               	leadRecord.Primary__c = 'Yes';
            }
        }
    }
    public static void createTaskForLeadOwner(List<Lead> newList){
        
        List<Task> taskToUpdate = new List<Task>();
        for(Lead leadRecord : newList){
            Task taskObj = new Task();
            taskObj.OwnerId = leadRecord.OwnerId;
            taskObj.Status = 'Completed';
            taskObj.Subject = 'Task Assigned';
            taskObj.Priority = 'Normal';
            taskObj.WhoId = leadRecord.ID;
            taskToUpdate.add(taskObj);
        }
    }
    
    
   

    public static void createDuplicateLead(List<Lead> newLeads) {
        List<Lead> duplicateLeads = new List<Lead>();
        

        for (Lead newLead : newLeads) {
            Lead duplicateLead = new Lead();
            

            duplicateLead.FirstName = newLead.FirstName;
            duplicateLead.LastName = newLead.LastName;
            duplicateLead.Email = newLead.Email;
            duplicateLead.Phone = newLead.Phone;
            duplicateLead.Company = newLead.Company;
            duplicateLead.Status = newLead.Status;

            duplicateLead.LastName = newLead.LastName + ' Duplicate';
            
            duplicateLeads.add(duplicateLead);
        }
        

        if (!duplicateLeads.isEmpty()) {
            insert duplicateLeads;
        }
   }

   
    public static void deniedDuplicateEmailAndPhoneInsertion(List<Lead> newList, Map<Id,Lead> oldMap){
        
        
        Set<String> firstNameSet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        
        for(Lead ld : newList){
           firstNameSet.add(ld.FirstName);
            emailSet.add(ld.Email);
        }
        
        List<Lead> leadToUpdate = [SELECT Id,FirstName,Email FROM Lead
                                  WHERE FirstName IN : firstNameSet
                                  AND Email IN : emailSet
                                  AND ID NOT IN : newList];
        for(Lead lead : newList){
            for(Lead leadList : leadToUpdate){
                if(lead.FirstName == leadList.FirstName && lead.Email == leadList.Email){
                    lead.addError('Lead With firstName or email is already exists');
                }
            }
        }
    }
    
    
    
    
    
}
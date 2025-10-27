trigger LeadTrigger on Lead (before insert,after insert,before update) {
    if(Trigger.isInsert) {
        if (Trigger.isBefore){
            LeadTriggerHandler.createTaskForLeadOwner(Trigger.new);
           
        }
        else if(Trigger.isAfter){
             LeadTriggerHandler.createCaseForNewLeads(Trigger.new);
        	// LeadTriggerHandler.createDuplicateLead(Trigger.new);
            LeadTriggerHandler.deniedDuplicateEmailAndPhoneInsertion(Trigger.New , Trigger.OldMap);
        }
       
    }
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
           LeadTriggerHandler.changeStatusAfterUpdate(Trigger.new); 
           LeadTriggerHandler.updateLead(Trigger.new);
        }
    }
}
trigger AccountTrigger on Account (before insert,before update,after insert, after update) {
    
    if(Trigger.isInsert && Trigger.isBefore){
        system.debug('trigger.oldmap==>>'+Trigger.oldMap);
        AccountTriggerHandler.insertAddress(Trigger.new);
        AccountTriggerHandler.checkValidation(Trigger.new);
        AccountTriggerHandler.updateAccountNumber(Trigger.new);
        AccountTriggerHandler.insertBillingAddressToShipping(Trigger.new);
        AccountTriggerHandler.preventDuplicateInsertionNameAndRating(Trigger.New);
        
        
    }  
    if(Trigger.isInsert && Trigger.isAfter){
        system.debug('trigger.oldmap after==>>'+Trigger.oldMap);
        AccountTriggerHandler.createRelatedContact(Trigger.new);
        AccountTriggerHandler.createContactWithNameOfAccount(Trigger.new);
        AccountTriggerHandler.sendAccountCreationEmail(Trigger.new);
        AccountTriggerHandler.createNContact(Trigger.new);
        //  AccountTriggerHandler.createClientContact(Trigger.new);
        // AccountTriggerHandler.checkAccountCreation(Trigger.new);
    }
    
    if( Trigger.isUpdate && Trigger.isBefore){
        AccountTriggerHandler.updateDiscription(Trigger.new, Trigger.oldMap);
        AccountTriggerHandler.updatePhoneDiscription(Trigger.new,Trigger.oldMap);
        AccountTriggerHandler.deniedToSetOwnership(Trigger.new,Trigger.oldMap);
        
        
    } 
    if (Trigger.isUpdate && Trigger.isAfter){
        /*	AccountTriggerHandler.checkAccountOpportunityUpdate(Trigger.new);
			AccountTriggerHandler.handleAfterAccountWebsiteUpdate(Trigger.new, Trigger.oldMap);
			AccountTriggerHandler.updateAccountLineOpportunityItem(Trigger.New, Trigger.oldMap);
			AccountTriggerHandler.updateAllContactMailCity(Trigger.new,Trigger.oldMap);
			AccountTriggerHandler.updateOpportunitiesOnAccountChange(Trigger.oldMap);
			AccountTriggerHandler.updateAccountRelatedContactPhones(Trigger.new, Trigger.oldMap);
			  AccountTriggerHandler.updateTotalOpportunityAmount(Trigger.new);
		   	AccountTriggerHandler.sendAccountUpdateEmails(Trigger.newMap, Trigger.oldMap);
			*/
        AccountTriggerHandler.updateAccountRelatedOpportunityDescription(Trigger.new, Trigger.oldMap);
      //AccountTriggerHandler.updateAccountRelContactPhone(Trigger.new, Trigger.oldMap);
        AccountTriggerHandler.checkRelatedContacts(Trigger.New);
        
        
        
        
    }
    
    
}
trigger ContactGenericTrigger on Contact ( before insert, before update,after insert,after update ) {
   
	if(Trigger.isInsert){
        
    if(Trigger.isBefore){
        //ContactController.validateWithEmailAndPhone(Trigger.new);
       // ContactController.validateWithEmailAndPhone(Trigger.new);
       // ContactController.insertDescriptionWhenEmpty(Trigger.new);
    } else if(Trigger.isAfter){
         /*   ContactController.callSentEmail(Trigger.new);
           	ContactController.sendEmailToAdmin(Trigger.new);
	    	ContactController.sentEmail(Trigger.new);  */
          	//  ContactController.handleAfterInsert(Trigger.new);
			//ContactController.assignContactNameWithAccountWebsite(Trigger.new);
			ContactController.getAllCount(Trigger.new);
        }
    } 
    
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
         //  ContactController.updateAccountDescriptions(Trigger.new, Trigger.oldMap);
         	ContactController.test(Trigger.New, Trigger.oldMap);
            ContactController.updateContactWithSalutation(Trigger.new);
            ContactController.updateAccountFieldHasRelatedContact(Trigger.new , Trigger.oldMap);
            ContactController.checkRelatedContactCount(Trigger.new);
        }
    }  

}
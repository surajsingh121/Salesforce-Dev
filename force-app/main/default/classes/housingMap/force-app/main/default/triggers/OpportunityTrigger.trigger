trigger OpportunityTrigger on Opportunity (before insert,before update, after insert , after update, after delete,before delete) {

    
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            OpportunityHandler.createOpportunityForOwner(Trigger.new);
        }else if(Trigger.isAfter){
				OpportunityHandler.createQuoteOnOpportunityLineItemCreation(Trigger.new);
            	//OpportunityHandler.countRelatedOpportunity(Trigger.new, null);
            OpportunityHandler.getMinAndMaxRelatedOpportunity(Trigger.new);
                }
    }
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            OpportunityHandler.updateOpportunityAmmount(Trigger.New,Trigger.oldMap);
        } else if (Trigger.isAfter){
            OpportunityHandler.AccountNameWithOppName(Trigger.new , Trigger.oldMap);
            OpportunityHandler.updateAccountName(Trigger.new , Trigger.oldMap);
        }
    }
    if(Trigger.isDelete && Trigger.isBefore){
        OpportunityHandler.validataOpportunityStage(Trigger.new);
    }

    
   /* 
    if(Trigger.isAfter && Trigger.isInsert ){
       // OpportunityHandler.countRelatedOpportunity(Trigger.new , null);
       	 OpportunityHandler.getMinAndMaxRelatedOpportunity(Trigger.New);
    }
    
        if(Trigger.isAfter && Trigger.isDelete ){
        OpportunityHandler.countRelatedOpportunity(null , Trigger.old);
    }
*/
}
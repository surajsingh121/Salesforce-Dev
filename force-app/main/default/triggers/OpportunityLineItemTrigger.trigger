trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert,after insert,after update) {

    if(Trigger.isInsert && Trigger.isAfter ){
  		//OpportunityLineItemTriggerHandler.insertQuotation(Trigger.new);
  		OpportunityLineItemTriggerHandler.updateOpportunityDescription(Trigger.new);

 		}
    if(Trigger.isUpdate && Trigger.isAfter){
        OpportunityLineItemTriggerHandler.updateOpportunityDescription(Trigger.new);
    }
}
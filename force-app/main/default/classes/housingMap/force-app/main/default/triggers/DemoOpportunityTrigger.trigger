trigger DemoOpportunityTrigger on Opportunity (before delete,after update) {

if(Trigger.isDelete){
    if(Trigger.isBefore){
        DemoOpportunityTriggerHandler.preventDeletionOfOpportuniity(Trigger.new);
    }
}
if(Trigger.isUpdate){
    if(Trigger.isAfter){
        DemoOpportunityTriggerHandler.updateAccountAnnualRevenue(Trigger.new, Trigger.oldMap);
    }
}
}
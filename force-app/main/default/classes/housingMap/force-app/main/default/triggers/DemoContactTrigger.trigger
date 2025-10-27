trigger DemoContactTrigger on Contact (before insert) {
if(Trigger.isInsert ){
    if(Trigger.isBefore){
        DemoContactTriggerHandler.validateContactWithEmail(Trigger.new,Trigger.oldMap);
    }
}
}
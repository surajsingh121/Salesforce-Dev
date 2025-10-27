trigger DemoAccountTrigger on Account (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        DemoAccountTriggerHandler.check(Trigger.new);
    }

    
}
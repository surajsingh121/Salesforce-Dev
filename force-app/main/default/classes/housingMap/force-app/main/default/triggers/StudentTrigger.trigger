trigger StudentTrigger on Student__c (before insert,after insert) {

    if(Trigger.isInsert){
        if(Trigger.isBefore){
            StudentTriggerHandler.createStudentRecordsAndPhoneValidate(Trigger.new);
        }else if (Trigger.isAfter){
            StudentTriggerHandler.insertTotalNumberOfStudentInAccount(Trigger.new);
        }
    }
}
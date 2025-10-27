public class WireDemo {

    @AuraEnabled(cacheable=true)
    public static List<Student__c> getData(){
        List<Student__c> stdInfo = [Select Id, Name,Email__c From Student__c];
        return stdInfo;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContact(){
        List<Contact> getList = [SELECT Id, Name,Email 
                                 FROM Contact
                                 WHERE AccountId <> NULL];
        return getList;
    }
}
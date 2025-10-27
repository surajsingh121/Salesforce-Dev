public with sharing class ContactLWC {


    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        List<Contact> query = [SELECT Id, Name,Phone, Email
            			FROM Contact
            			LIMIT 10];
        return query;
    }

}
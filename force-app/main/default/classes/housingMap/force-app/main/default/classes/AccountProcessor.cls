public class AccountProcessor {
    @future
    public static void countContacts(List<Id> ids){
        List<Account> accList =[SELECT Id,(SELECT Id FROM Contacts) 
                                FROM Account WHERE Id IN :ids ];
        for(Account acc : accList){
            acc.Number_of_Contacts__c = acc.Contacts.size();
        }
        if(!accList.isEmpty()){
            update accList;
            system.debug('Total Contact Count is : '+accList);
        }
    }

}
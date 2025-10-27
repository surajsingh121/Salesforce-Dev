public with sharing class DemoAccountTriggerHandler {

   public static void check(List<Account> newList){
    for(Account acc : newlist){
        if(acc.Phone != null){
            acc.Industry = 'Chemicals';
        }
    }

   }
}
public class wireAccount {

    @AuraEnabled(cacheable=true)
    public static List<Account> getData(){
        List<Account> getInfo = [Select Id,Name,Phone,AccountNumber,Rating,OwnerId From Account];
        return getInfo;
    }
}
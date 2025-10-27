public class AccountFuture {
    
    @future
    public static void insertAccountNumber(List<Id> ids){
        List<Account> accList =[SELECT Id,AccountNumber FROM Account WHERE Id IN :ids];
        Integer count =12;
        for(Account acc : accList){
            acc.AccountNumber ='1234566789'+count++;
        }
        if(!accList.isEmpty()){
            update accList;
        }
    }

}
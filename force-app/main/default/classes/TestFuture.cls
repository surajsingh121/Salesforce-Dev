public class TestFuture {

    @future
    public static void demo(List<Id> ids){
        List<Account> accList =[SELECT Id,Name FROM Account WHERE Id IN:ids];
        Integer count=12;
        for(Account acc : accList){
          acc.Name = acc.Name+'*';
       	  acc.AccountNumber= acc.AccountNumber==null? '489410110002927':acc.AccountNumber;
       		//acc.AccountNumber='12345678901';
        }
        if(!accList.isEmpty()){
            update accList;
        }
    }
}
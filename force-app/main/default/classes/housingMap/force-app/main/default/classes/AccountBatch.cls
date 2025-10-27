global class AccountBatch implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id,Name FROM Account');
    }

    public void execute(Database.BatchableContext bc,List<Account> scopes){
        for(Account acc : scopes){
            acc.Name = acc.Name + 'processed';
        }
        update scopes;
    }
    public void finish(Database.BatchableContext bc){

        System.debug('batch job processed');
    }
}
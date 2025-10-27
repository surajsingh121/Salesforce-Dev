global class ContactBatch implements Database.Batchable<sObject> {

   public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id,FirstName FROM Contact');
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> scope){
        for(Contact con : scope){
            con.FirstName = '* '+ con.FirstName==null ? ' ' : 'user';
        }
        update scope;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('Bath processed sucessfully');
    }
}
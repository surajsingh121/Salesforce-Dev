global class LeadProcessor implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id,Name,LeadSource FROM Lead');
    }
    
    public void execute(Database.BatchableContext bc, List<Lead> records){
        for(Lead lead : records){
            lead.LeadSource = 'DreamForce';
    	}
        
 }  
    public void finish(Database.BatchableContext bc){
        System.debug('Batch Apex Completed');
    }
}
public with sharing class DemoOpportunityTriggerHandler {
    public static void preventDeletionOfOpportuniity(List<Opportunity> newList) {

        for(Opportunity opp : newList){
            if(opp.StageName != null && opp.StageName == 'Closed Won'){
                opp.addError('You cannot delete an opportunity that is Closed Won.');
            }
        }
    }

    public static void updateAccountAnnualRevenue(List<Opportunity> newList, Map<Id,Opportunity> oldMap){

        Set<Id> accountIds = new Set<Id>();

        for(Opportunity opp : newList){
            if(opp.AccountId != null && opp.StageName != oldMap.get(opp.Id).StageName ){

                accountIds.add(opp.AccountId);
            }
        }

        List<Opportunity> oppList = [SELECT Id,AccountId, Amount
                                    FROM Opportunity 
                                    WHERE AccountId IN :accountIds AND StageName = 'Closed Won'];

        List<Account> accountToUpdate = new List<Account>();

        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                Account acc = new Account();
                acc.Id = opp.AccountId;
                acc.AnnualRevenue = (opp.Amount != null) ? opp.Amount * 12 : 0; // Assuming Amount is monthly 
                accountToUpdate.add(acc);
            }
        }
        if(!accountToUpdate.isEmpty()){
            try{
                update accountToUpdate;
            }catch(Exception e){
                System.debug('Error updating account annual revenue: ' + e.getMessage());
            }
        }
    }
    
}
public class OpportunityHandler {
    
    public static void createOpportunityForOwner(List<Opportunity> newList){
        for(Opportunity opp : newList){
            if(opp.StageName =='Closed Won'){
                Task taskObj = new Task();
                taskObj.Status = 'Completed';
                taskObj.Priority = 'High';
                taskObj.Subject = ' Urgent Call';
              	taskObj.OwnerId = opp.OwnerId;
                taskObj.Description = 'please split the revenue';
            }
        }
    }

    public static void updateOpportunityAmmount(List<Opportunity> newOpp, Map<Id,Opportunity> oldMap){
        for(Opportunity opp : newOpp){
            if(oldMap.get(opp.Id).StageName != opp.StageName){
                opp.Amount = opp.Probability * opp.ExpectedRevenue;
            }
        }
        
    }
    
    
   
	public static void createQuoteOnOpportunityLineItemCreation(List<Opportunity> newListOpp) {
		
        Set<Id> oppIds = new Set<Id>();
        for(Opportunity opp : newListOpp){
            if(opp.AccountId != null){
                oppIds.add(opp.AccountId);
            }
        }
}
    
    public static void updateAccountNameOnOpportunityChange(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        Set<Id> accountIdsToUpdate = new Set<Id>();
        Map<Id, String> oppIdToNewNameMap = new Map<Id, String>();

       
        for(Opportunity opp : newList){
            Opportunity oldOpp = oldMap.get(opp.Id);
            if(opp.Name != oldOpp.Name && opp.AccountId != null){
                accountIdsToUpdate.add(opp.AccountId);
                oppIdToNewNameMap.put(opp.Id, opp.Name);
            }
        }

       
        List<Account> accountsToUpdate = new List<Account>();
        for(Account acc : [SELECT Id, Name,
                           (SELECT Id, Name FROM Opportunities ORDER BY LastModifiedDate DESC LIMIT 1)
                           FROM Account WHERE Id IN :accountIdsToUpdate]){
            if(!acc.Opportunities.isEmpty()){
                Opportunity recentOpp = acc.Opportunities[0];
                acc.Name = recentOpp.Name;
                accountsToUpdate.add(acc);
            }
        }

       
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }

  
    public static void updateAccountNameWithOppName(List<Opportunity>newList, Map<Id,Opportunity>oldMap){
        
        Set<Id> ids = new Set<Id>();
        Map<Id,String> oppToUpdate = new Map<Id,String>();
        for(Opportunity opp : newList){
            if(opp.Name != oldMap.get(opp.Id).Name && opp.AccountId != null){
                ids.add(opp.AccountId);
                oppToUpdate.put(opp.Id, opp.Name);
            }
        }
         List<Account> accountsToUpdate = [SELECT Id, Name,
                           (SELECT Id, Name FROM Opportunities ORDER BY LastModifiedDate DESC LIMIT 1)
                           FROM Account WHERE Id IN :ids];
        for(Account acc :accountsToUpdate ){
            if(!acc.Opportunities.isEmpty()){
                Opportunity recentOpp = acc.Opportunities[0];
                acc.Name = recentOpp.Name;
                accountsToUpdate.add(acc);
            }
        }
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }


    public static void AccountNameWithOppName(List<Opportunity> newList, Map<Id,Opportunity> oldMap){
        
        Set<Id> accIds = new Set<Id>();
        Map<Id,String> oppUpdate = new Map<Id,String>();
        
        for(Opportunity opp : newList){
            if(opp.Name != oldMap.get(opp.Id).Name && opp.AccountId !=null){
                accIds.add(opp.AccountId);
                oppUpdate.put(opp.Id, opp.Name);
            }
        }
        
        List<Account> accountToUpdate = [SELECT Id, Name,
                                        (SELECT Id,Name FROM Opportunities ORDER BY LastModifiedDate DESC LIMIT 1)
                                        FROM Account WHERE ID IN : accIds];
        
        for(Account acc : accountToUpdate){
            if(acc.Opportunities.isEmpty()){
                Opportunity oldopp = acc.Opportunities[0];
                acc.Name = oldopp.Name;
            }
        }
        if(!accountToUpdate.isEmpty()){
            update accountToUpdate;
        }
    }
    
    
    public static void updateAccountName(List<Opportunity>newList, Map<Id,Opportunity>oldMap){
        
        Map<Id,String> accountIdsAndName = new Map<Id,String>();
        
        for(Opportunity opp : newList){
            if(opp.AccountId != null && opp.Name != oldMap.get(opp.Id).Name){
                accountIdsAndName.put(opp.AccountId, opp.Name);
            }
        }
        List<Account> accountToUpdate = new List<Account>();
        if(!accountIdsAndName.isEmpty()){
            for(Id ids : accountIdsAndName.keySet()){
                Account acc = new Account();
                acc.Id = ids;
                acc.Name = accountIdsAndName.get(ids);
                accountToUpdate.add(acc);
            }
        }
        if(!accountToUpdate.isEmpty()){
            update accountToUpdate;
        }
    }
    
    
    public static void updateAccountNameWithOpportunityName(List<Opportunity> newList, Map<Id,Opportunity> oldMap){
        
        Map<Id,String> accountIdAndName = new Map<Id,String>();
        
        for(Opportunity opp : newList){
            if(opp.AccountId != null && opp.Name != oldMap.get(opp.Id).Name){
                accountIdAndName.put(opp.AccountId, opp.Name);
            }
        }
        List<Account> accountToUpdate = new List<Account>();
        if(!accountIdAndName.isEmpty()){
            for(Id ids : accountIdAndName.keySet()){
                Account acc = new Account();
                acc.Id = ids ;
                acc.Name = accountIdAndName.get(ids);
                accountToUpdate.add(acc);
                
            }
        }
        if(!accountToUpdate.isEmpty()){
            update accountToUpdate;
        }
        
    }  
    
    public static void insertOpportunityIfNotAvailable(List<Opportunity> newList, Map<Id,Opportunity> oldMap){
        Set<Id> ids = new Set<Id>();
        for(Opportunity opp : newlist){
            if(opp.AccountId != null){
                ids.add(opp.AccountId);
            }
        }
        List<Account> accountList = [SELECT Id,Name,(SELECT Id,Name FROM Opportunities) FROM Account 
                                    WHERE ID IN : ids];
        if(!accountList.isEmpty()){
            for(Account account : accountList){
                Opportunity obj = new Opportunity();
                obj.AccountId = account.Id;
                obj.Name = account.Name;
                
                
            }
            if(!accountList.isEmpty()){
                insert accountList;
            }
        }
    }     
    
    
    public static void countRelatedOpportunity(List<Opportunity> newList, List<Opportunity> oldList){
        Set<Id> ids = new Set<Id>();
        if(newList != null){
            
        for(Opportunity opp : newList){
            if(opp.AccountId != null){
                ids.add(opp.AccountId);
            }
            
        }
      }
        
         if(oldList != null){
            
        for(Opportunity opp : oldList){
            if(opp.AccountId != null){
                ids.add(opp.AccountId);
            }
            
        }
      }
        
        List<AggregateResult> oppList = [SELECT Count(Id) s, AccountId 
                                        From Opportunity
                                        WHERE AccountId IN : ids
          							    GROUP BY AccountId];
        
        List<Account> accountToUpdate = new LIst<Account>();
        if(!oppList.isEmpty()){
            for(AggregateResult newOpp : oppList){
                Id accountId = (Id)newOpp.get('AccountId');
                Decimal count = (Decimal)newOpp.get('s');
                Account obj = new Account();
                obj.Id = accountId;
                obj.Related_Opportunity_Count__c = count;
                accountToUpdate.add(obj);
            }
        }
        if(!accountToUpdate.isEmpty()){
            update accountToUpdate;
        }
    }  
    
    
    
    
    public static void getMinAndMaxRelatedOpportunity(List<Opportunity> newList){
        
        Set<Id> ids = new Set<Id>();
        for(Opportunity opp : newList){
            if(opp.AccountId != null){
                ids.add(opp.AccountId);
            }
        }
        List<AggregateResult> oppList = [SELECT MIN(Amount)min, MAX(Amount) max,AccountId
                                        FROM Opportunity
                                        WHERE AccountId IN : ids
                                        GROUP BY AccountId];
        
        List<Account> accountToUpdate = new List<Account>();
        if(!oppList.isEmpty()){
            for(AggregateResult ar : oppList){
            	Id accountId = (Id)ar.get('AccountId');
                Decimal min = (Decimal)ar.get('min');
                Decimal max = (Decimal)ar.get('max');
                Account obj = new Account();
                obj.Id = accountId ;
                obj.Min_Amount__c = min;
                obj.Max_Amount__c = max;
                accountToUpdate.add(obj);
        	}
        }
        if(!accountToUpdate.isEmpty()){
            update accountToUpdate;
        }
    } 
   
    public static void validataOpportunityStage(List<Opportunity> newList){
        
        for(Opportunity opp : newList){
            if(opp.StageName != null && opp.StageName != 'Closed Won'){
                opp.addError('Opportunity can not be deleted while stage is Close Won');
            }
        }

    }
    
  
    
    
    
}
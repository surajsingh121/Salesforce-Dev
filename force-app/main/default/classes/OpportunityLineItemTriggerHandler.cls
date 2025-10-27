public class OpportunityLineItemTriggerHandler {

    public static void insertQuotation(List<OpportunityLineItem> newList){
       		List<Quote> quoteToUpdate = new List<Quote>();
        		for(OpportunityLineItem oli : newList){
                    Quote quoteObj = new Quote();
                    quoteObj.Name = oli.Name;
                    quoteObj.Status = 'Approved';
           			oli.Description =' OpportunityLineItem created successfully';
                    quoteToUpdate.add(quoteObj);       
        }
        if(!quoteToUpdate.isEmpty()){
            insert quoteToUpdate;
        }
    }
    
    /*
     Write a trigger, when an opportunity Product is added related to opportunity. 
	 Then the name of product on the oppLineItem is updated to related
	 opportunity Description field(create field, if not available) 
 */
    
    public static void updateOpportunityDescription(List<OpportunityLineItem> newItems){
      
        Set<Id> oppIds = new Set<Id>();
        for(OpportunityLineItem oli : newItems) {
            if(oli.OpportunityId != null) {
                oppIds.add(oli.OpportunityId);
            }
        }
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
            [SELECT Id, Description FROM Opportunity WHERE Id IN :oppIds]);

        List<Opportunity> oppToUpdate = new List<Opportunity>();
        for(OpportunityLineItem oli : newItems) {
            Opportunity opp = oppMap.get(oli.OpportunityId);
                opp.Description = oli.Name;
            	opp.Id = oli.OpportunityId;
            	oppToUpdate.add(opp);
            
        }
         if(!oppToUpdate.isEmpty()){
        update oppToUpdate;
    }
    }
   
}
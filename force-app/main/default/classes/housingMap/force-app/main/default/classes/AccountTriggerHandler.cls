public class AccountTriggerHandler {

    public static void insertAddress(List<Account> newList){
            for(Account acc : newList){
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingCountry = acc.BillingCountry;
                acc.ShippingLatitude = acc.BillingLatitude;
                acc.ShippingGeocodeAccuracy = acc.BillingGeocodeAccuracy;
                acc.ShippingStreet = acc.BillingStreet;
                acc.ShippingPostalCode = acc.BillingPostalCode;
            } 
        }
    
    public static void checkValidation(List<Account> newList){
        for(Account acc : newList){
            if(String.isBlank(acc.Phone) || acc.Phone.length() <10){
                acc.Phone.addError('please enter the valid phone number');
            }
        }
    }
    
    public static void updateDiscription(List<Account> newList, Map<Id,Account> oldMap){
        for(Account acc : newList){
            if(oldMap != null && acc.Phone != oldMap.get(acc.Id).Phone){
                acc.Description =' Phone is Updated';
            }
        }
    }
    
    public static void updateDiscr(){
        List<Account> newList = new List<Account>();
        Map<Id,Account> oldMap = new Map<Id,Account>();
        for(Account acc : newList){
            if(oldMap != null && acc.Phone != oldMap.get(acc.Id).Phone){
                acc.Description = 'Updated Phone';
            }
        }
    }
    
    public static void updateAccountNumber(List<Account> newList){
        
        for(Account acc : newList){
            if(acc.Active__c != null && acc.Industry != null){
                acc.AccountNumber = '12345678';
                
            }
        }
    }
    
    public static void createRelatedContact(List<Account> newList){
        
        List<Contact> conList = new List<Contact>();
        
        for(Account acc : newList){
            Contact conObj = new Contact();
            conObj.AccountId = acc.Id;
            conObj.LastName = acc.Name;
            conList.add(conObj);
        }
        if(!conList.isEmpty()){
            insert conList;
		}
    }
    
    public static void updatePhoneDiscription(List<Account> newList, Map<Id,Account> oldMap){
        for(Account acc : newList){
            if(oldMap !=null && acc.Phone != oldMap.get(acc.Id).Phone){
                
                acc.Description = 'Phone is updated';
            }
        }
    }
    
    public static void insertBillingAddressToShipping(List<Account> newList){
        for(Account acc : newList){
            acc.ShippingCity = acc.BillingCity;
            acc.ShippingCountry = acc.BillingCountry;
            acc.ShippingCountryCode = acc.BillingCountryCode;
            acc.ShippingGeocodeAccuracy = acc.BillingGeocodeAccuracy;
            acc.ShippingPostalCode = acc.BillingPostalCode;
            acc.ShippingState = acc.BillingState;
            
        }
    }
    
    
    public static void checkAccountOpportunityUpdate(List<Account> newList){
        System.debug('newList:::>'+newList);
        List<Opportunity> oopList = new List<Opportunity>();
        Set<Id> accountIds = new Set<Id>();
        for(Account acc : newList){
               accountIds.add(acc.Id);
            }
        List<Opportunity> listOpp =[SELECT Id,AccountId, StageName FROM Opportunity WHERE AccountId IN :accountIds]; 
       	System.debug('listOpp:::>'+listOpp);
        for(Opportunity opp : ListOpp){
            if(opp.StageName !='Closed Won'){
                opp.StageName = 'Closed Lost';
                oopList.add(opp);
            }
            if(!oopList.isEmpty()){
                update oopList;
            }
        }
  }
    public static void createContactWithNameOfAccount(List<Account> newList){
        List<Contact> newContact = new List<Contact>();
        for(Account acc : newList){
            Contact conObj = new Contact();
            conObj.AssistantName = acc.Name;
            conObj.LastName = 'user';
            conObj.AccountId = acc.Id;           
            newContact.add(conObj);

        }
        if(!newContact.isEmpty()){
            insert newContact;
        }
     
    }
    
    

    public static void sendAccountCreationEmail(List<Account> newAccounts) {

        User adminUser = [SELECT Id, Email FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Account acc : newAccounts) {
            if (acc.Name != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { adminUser.Email });
                mail.setSubject('New Account Created');
                mail.setPlainTextBody('An account has been created and name is "' + acc.Name + '".');
                emails.add(mail);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
    public static void deniedToSetOwnership(List<Account> newList, Map<Id,Account> oldAccountMap){
        for(Account acc : newList){
            if(acc.Industry == 'Agriculture' && acc.Type == 'Prospect'){
                if(oldAccountMap.get(acc.Id).Ownership != acc.Ownership){
					acc.addError('Ownership can not be modified');
                }
				
            }
        }
    }
    public static void handleAfterAccountWebsiteUpdate(List<Account> newList, Map<Id,Account> oldMap){
        Map<Id,String> accMapWebsite = new Map<Id,String>();
        for(Account acc : newList){
            if(acc.Website != oldMap.get(acc.Id).Website){
                accMapWebsite.put(acc.Id, acc.Website);
            }
        }
        if(!accMapWebsite.isEmpty()){
            List<Contact> conListToUpdate = new List<Contact>();
            List<Contact> conList =[SELECT Id,Name,Website__c, AccountId FROM Contact WHERE ID IN :accMapWebsite.keyset()];
            for(Contact con : conList){
                con.Website__c = accMapWebsite.get(con.AccountId);
                conListToUpdate.add(con);
            }
            
            if(!conListToUpdate.isEmpty()){
                update conListToUpdate;
            }
        }
}
    public static void createNContact(List<Account> newList){
        List<Contact> contactToUpdate = new List<Contact>();
        for(Account acc : newList){
            if(acc.Number_of_Contacts__c != null){
                for(Integer i=0; i<= acc.Number_of_Contacts__c; i++){
                    Contact conList = new Contact();
                    conList.LastName = acc.Name;
                    conList.AccountId = acc.Id;
  
                    contactToUpdate.add(conList);
                    
                }
            }
            if(!contactToUpdate.isEmpty()){
                insert contactToUpdate;
            }
        }
    }
    public static void updateAccountLineOpportunityItem(List<Account> newList, Map<Id,Account> oldMap){
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        for(Account acc : newList){
            if( acc.Name != oldMap.get(acc.Id).Name){
                Opportunity opp = new Opportunity();
               	opp.Amount = acc.Total_Opportunity_Amount__c;
                oppToUpdate.add(opp);
                
            }
        }
        if(oppToUpdate.isEmpty()){
            insert oppToUpdate;
        }
        
    }
    
    
    
    public static void updateAllContactMailCity(List<Account> newList, Map<Id,Account> oldMap){
        List<Contact> contactToUpdate = new List<contact>();
        for(Account acc : newList){
            if(acc.BillingCity != oldMap.get(acc.Id).BillingCity){
                Contact cont = new Contact();
                cont.MailingCity = acc.BillingCity;
                cont.LastName = acc.Name;
                contactToUpdate.add(cont);
            }
        }
        if(!contactToUpdate.isEmpty()){
			insert contactToUpdate;
        }
    }

    
    
	public static void updateOpportunitiesOnAccountChange(Map<Id, Account> newMap) {
		Set<Id> accountIds = newMap.keySet();
		List<Opportunity> oppsToUpdate = new List<Opportunity>();

		DateTime thirtyDaysAgo = DateTime.now().addDays(-30);

		List<Opportunity> relatedOpps = [
		SELECT Id, StageName, CreatedDate
		FROM Opportunity
		WHERE AccountId IN :accountIds
		AND CreatedDate < :thirtyDaysAgo
		AND StageName != 'Closed Won'
		];

		for (Opportunity opp : relatedOpps) {
			opp.StageName = 'Closed Lost';
			oppsToUpdate.add(opp);
			}


		if (!oppsToUpdate.isEmpty()) {
				update oppsToUpdate;
			} 
		}	
    
    
    public static void updateAccountRelatedContactPhones(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
        Map<Id, String> accountsToUpdate = new Map<Id, String>();

        // Identify which accounts had their phone number changed
        for (Account acc : newAccounts) {
            Account oldAcc = oldAccountMap.get(acc.Id);
            if (acc.Phone != oldAcc.Phone) {
                accountsToUpdate.put(acc.Id, acc.Phone);
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            // Query related contacts
            List<Contact> contactsToUpdate = [
                SELECT Id, Phone, AccountId
                FROM Contact
                WHERE AccountId IN :accountsToUpdate.keySet()
            ];

            // Update contact phone numbers
            for (Contact con : contactsToUpdate) {
                con.Phone = accountsToUpdate.get(con.AccountId);
            }

            update contactsToUpdate;
        }
    }

  
  /*  public static void updateTotalOpportunityAmount(Map<Id, Account> newAccountMap) {
        Set<Id> accountIds = newAccountMap.keySet();

        // Query Opportunities related to the updated Accounts
        List<Opportunity> oppList = [
            SELECT AccountId, Amount
            FROM Opportunity
            WHERE AccountId IN :accountIds
        ];

        // Aggregate opportunity amounts per account
        Map<Id, Decimal> accountToTotalAmountMap = new Map<Id, Decimal>();
        for (Opportunity opp : oppList) {
            if (opp.AccountId != null) {
                accountToTotalAmountMap.put(
        opp.AccountId,
        accountToTotalAmountMap.get(opp.AccountId) + (opp.Amount == null ? 0 : opp.Amount)
    );
            }
        }

        // Prepare list of accounts to update
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            Decimal totalAmount = accountToTotalAmountMap.(accId, 0);
            accountsToUpdate.add(new Account(
                Id = accId,
                Total_Opportunity_Amount__c = totalAmount
            ));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    } */

   
 /*   public static void createClientContact(List<Account> newAccounts) {
        List<Contact> contactsToInsert = new List<Contact>();
        List<Account> accountsToUpdate = new List<Account>();
        
       
        for (Account acc : newAccounts) {
           
            Contact newContact = new Contact();
            newContact.FirstName = acc.Name; 
            newContact.LastName = 'Client';  
            
           
            newContact.Email = '';  
            
           
            contactsToInsert.add(newContact);
        }

       
        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }

      
        for (Integer i = 0; i < newAccounts.size(); i++) {
    
            Account acc = newAccounts[i];
            Contact createdContact = contactsToInsert[i];
            
            acc.Client_Contact__c = createdContact.Id; 
            accountsToUpdate.add(acc);
        }

       
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    } */



    public static void sendAccountUpdateEmails(Map<Id, Account> newMap, Map<Id, Account> oldMap) {
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        
        for (Id accId : newMap.keySet()) {
            Account newAcc = newMap.get(accId);
            Account oldAcc = oldMap.get(accId);

            // Check if Account Type changed
            if (newAcc.Type != oldAcc.Type) {
                // Query contacts related to the account
                List<Contact> relatedContacts = [
                    SELECT Id, Email
                    FROM Contact
                    WHERE AccountId = :accId AND Email != null
                ];

                for (Contact con : relatedContacts) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<String>{con.Email});
                    mail.setSubject('Account Update Info');
                    mail.setPlainTextBody('Your account information has been updated successfully. Account Name: ' + newAcc.Name);
                    emailsToSend.add(mail);
                }
            }
        }

        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }
   
    
    public static void updateAccountRelatedOpportunityDescription(List<Account> newList, Map<Id,Account>oldMap){
        
        Map<Id,String> updateRelDescription = new Map<Id,String>();
        
        for(Account acc : newList){
            if(acc.Description != oldMap.get(acc.Id).Description){
                system.debug('newList;;;;>'+ newList);
                system.debug('oldMap :::::>'+ oldMap);
                updateRelDescription.put(acc.Id,acc.Description);
            	}
   		} 
        system.debug('Map description :::::>'+ updateRelDescription);
        if(!updateRelDescription.isEmpty()){
			List<Opportunity> oppList = [SELECT Id,Description FROM Opportunity
                                      WHERE ID IN : updateRelDescription.keySet()];
        
       system.debug('opportunity description list ::::>'+ oppList);
            List<Opportunity> oppToBeUpdate = new List<Opportunity>();
            for(Opportunity opp : oppList){
                opp.Description = updateRelDescription.get(opp.AccountId);
                oppToBeUpdate.add(opp);
            
        }
        if(!oppToBeUpdate.isEmpty()){
            update oppToBeUpdate ;
        }
   }
   
 } 
   
    
    public static void updateAccountRelContactPhone(List<Account> newList, Map<Id,Account> oldMap){
        Map<Id,String> updateRelPhone = new Map<Id,String>();
        
        for(Account acc : newList){
            if(acc.Phone != oldMap.get(acc.Id).Phone){
                updateRelPhone.put(acc.Id,acc.Phone);
            }
        }
        
        if(updateRelPhone.isEmpty()){
            List<Contact> contactPhone =[SELECT ID,Phone,AccountId FROM Contact
                                     WHERE ID IN : updateRelPhone.keySet()];

            for(Contact con : contactPhone ){
					con.Phone = updateRelPhone.get(con.Id);
            }
            if(!contactPhone.isEmpty()){
                update contactPhone;
            }
        }
                
        
    }
    
    public static void preventDuplicateInsertionNameAndRating(List<Account> newList){
        
        Set<String> nameSet = new Set<String>();
        Set<String> ratingSet = new Set<String>();
        for(Account acc : newList){
            nameSet.add(acc.Name);
            ratingSet.add(acc.Rating);
        }
        
        List<Account> existAccounts = [SELECT Id, Name,Rating
                                          FROM Account WHERE Name IN : nameSet
                                          AND Rating IN : ratingSet
                                          AND Id NOT IN : newList
                                          LIMIT 50000];
        for(Account acc : newList){
            for(Account accList : existAccounts){
                if(acc.Name == accList.Name && acc.Rating == accList.Rating){

                    acc.addError('Dupicate Name with Rating are not allowed');
                }
            }
        }
    }
    
   // practice question -- RM
   
    
    //Q1
    
    public static void checkAccountType(List<Account> newList){
        
        for(Account acc : newList){
            if(acc.Type == null){
                acc.addError('Account Type must be filled');
            }
        }
    } 
    
    
    public static void validateAccountName(List<Account> newList){
        Set<String> nameSet = new Set<String>();
        
        for(Account acc : newList){
            nameSet.add(acc.Name);
            system.debug('acc.Name :::: >>>>'+ acc.Name);
        }
        
        List<Account> accountToUpdate = [SELECT Id,Name FROM Account
                                        WHERE ID IN : nameSet
                                        AND ID NOT IN : newList];
        
        if(!accountToUpdate.isEmpty()){
            system.debug('accountToUpdate :::>>>'+ accountToUpdate);
            for(Account accList : accountToUpdate){
                for(Account aa : newList){
                    if(accList.Name == aa.Name){
                        aa.addError('Account with same name found');
                    }
                }
            }
        }
    }
    
    public static void checkContactMobileAndEmail(List<Contact> newList){
        for(Contact con : newList){
            if(con.Phone == null && con.Email == null ){
                con.addError('phone and email must be filled');
            }
        }
    }
    
    public static void updateContactPhone(List<Account> newList, Map<Id,Account> oldMap){
        
       Map<Id,String> accPhone = new Map<Id,String>();
        for(Account acc : newList){
            if(acc.Phone != null && acc.Phone != oldMap.get(acc.Id).Phone){
                accPhone.put(acc.Id,acc.Phone);
            }
        }
        List<Contact> contactToUpdate = new List<Contact>();
        if(!accPhone.isEmpty()){
            for(Id ids : accPhone.keySet()){
                Contact con = new Contact();
                con.AccountId = ids;
                con.Phone = accPhone.get(ids);
            }
        }
        
    }
    
    public static void updateAccountPhoneWithContactPhone(List<Account> newList, Map<Id,Account> oldMap){
        
        Map<Id,String> accPhoneMap = new Map<Id,String>();
         
        for(Account acc : newList){
            if(acc.Phone != null ){
                accPhoneMap.put(acc.Id, acc.Phone);
            }
        }
        List<Contact> contactToUpdate = new List<Contact>();
        for(Id ids : accPhoneMap.keySet()){
            Contact con = new Contact();
            con.AccountId = ids;
            con.Phone = accPhoneMap.get(ids);
            
        }
        if(!contactToUpdate.isEmpty()){
            update contactToUpdate ;
        }
    }
    
    
    public static void checkAccountHasrelatedContact(List<Account> newList){
        
        Set<Id> ids = new Set<Id>();
        for(Account acc : newList){
  			ids.add(acc.Id);
        }
       List<Account> accList = [SELECT Id, Has_Related_Contact__c ,(SELECT Id From Contacts)FROM Account 
                                WHERE ID IN : ids];
        
        for(Account aa : accList ){
            if(aa.Contacts.size()>0){
                aa.Has_Related_Contact__c = True ;
            }
        }
    } 
    
    public static void checkRelatedContacts(List<Account> newList){
     
        
    Set<Id> accountIds = new Set<Id>();
    for (Account acc : newList) {
   
        accountIds.add(acc.Id);
    }

    List<Account> accountsWithContacts = [SELECT Id, Name,Has_Related_Contact__c, (SELECT Id, Name FROM Contacts)
                                          FROM Account WHERE Id IN :accountIds];
        
        
        for(Account accountList : accountsWithContacts){
            if(accountList.Has_Related_Contact__c != null){
                accountList.Has_Related_Contact__c = True ;
				}
        }   
      
  }
    
}
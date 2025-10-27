public class  ContactController {
    
    public static void test(List<Contact> newList , Map<Id,Contact>oldMap){
        
        for(Contact con : newList){
            system.debug('AccountId ::::>'+ con.AccountId);
        }
    }
    
    public static void callSentEmail(List<Contact> newList){
       	Map<Id, Contact> idVSContact = new Map<Id, Contact>();
        List<Account> accToUpdate = new List<Account>();
       
        for(Contact con : newList){
            if(con.Email != null){
                ContactController.sendEmailFromTemplate(con.Id);
            }
            idVSContact.put(con.AccountId, con);
        }
        List<Account> accList = [Select Id, Client_Contact__c from Account where Id in :idVSContact.KeySet()];
        for(Account acc : accList){
            acc.Client_Contact__c = idVSContact.get(acc.Id).Id;
            accToUpdate.add(acc);
        }
        
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }
    
    public static void validateWithEmailAndPhone(List<Contact> newList){
        
        Set<String> emails = new Set<String>();
        Set<String> phones = new Set<String>();
        
        for (Contact con : newList) {
            if (con.Email != null) {
                emails.add(con.Email.toLowerCase());
            }
            if (con.Phone != null) {
                phones.add(con.Phone.replaceAll('[^0-9]', ''));
            }
        }
            List<Contact> existingContacts = [
                SELECT Id, Email, Phone
                FROM Contact
                WHERE Email IN :emails
                OR Phone IN :phones
            ];
            
            Map<String, Contact> emailToContactMap = new Map<String, Contact>();
            Map<String, Contact> phoneToContactMap = new Map<String, Contact>();
            if(!existingContacts.isEmpty()){  
                for (Contact existingCon : existingContacts) {
                    if (existingCon.Email != null) {
                        emailToContactMap.put(existingCon.Email.toLowerCase(), existingCon);
                    }
                    if (existingCon.Phone != null) {
                        phoneToContactMap.put(existingCon.Phone.replaceAll('[^0-9]', ''), existingCon);
                    }  
                }
                
            /*    for (Contact newCon : newList) {
                    if (emailToContactMap.containsKey(newCon.Email)) {
                        newCon.Email.addError('A contact with this email already exists: ' + newCon.Email);
                    }
                    
                    if (phoneToContactMap.containsKey(newCon.Phone)) {
                        newCon.Phone.addError('A contact with this phone number already exists: ' + newCon.Phone);
                    }
                } */
        }
    }
    
    public static void sendEmailFromTemplate(Id contactId) {
            EmailTemplate template = [
                SELECT Id 
                FROM EmailTemplate 
                WHERE DeveloperName = 'Contact_Insert_Notification' 
                LIMIT 1
            ];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(template.Id);
            mail.setTargetObjectId(contactId);
            mail.setSaveAsActivity(false); 
            
            try {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(
                    new Messaging.SingleEmailMessage[] { mail }
                );
                
                if (results[0].isSuccess()) {
                    System.debug('Email sent successfully.');
                } else {
                    System.debug('Error sending email: ' + results[0].getErrors()[0].getStatusCode() + ' - ' + results[0].getErrors()[0].getMessage());
                }
            } catch (Exception e) {
                System.debug('Error sending email: ' + e.getMessage());
            }
        }
    
    public static void sendEmailToAdmin(List<Contact> newList){
        for(Contact con : newList){
            if(con.Email != null){
                ContactController.sendEmailFromTemplate(con.Id);

            }
    }
  }
    
    public static void checkBeforeContactCreate(List<Contact> newList){
        for(Contact conList : newList){
            if(conList.AccountId == null){
                conList.addError('Need Parent account to be add');
            }
        }
    }
    
    
    public static void sentEmail(List<Contact> newList){
       
        Set<Id> idset = new Set<Id>();
        List<messaging.SingleEmailMessage> emaillist = new List<messaging.SingleEmailMessage>();
        
		for (Contact ct : newList){
				idset.add(ct.Id);
        }
			Contact con = [SELECT Id,Name,Email FROM Contact WHERE Id IN : idset];
			List<string > sendTo = new List<string>();
			sendTo.add (con.Email);
			messaging.SingleEmailMessage sEmail = new messaging.SingleEmailMessage();
			sEmail.setToAddresses(sendTo);
			String[] cEmails = new String[]{'dilsanyal12@gmail.com', 'dilsanyal12@gmail.com'};
			sEmail.setCcAddresses(cEmails);
			sEmail.setReplyTo('dilsanyal12@gmail.com');
	
			sEmail.setSenderDisplayName(con.Name);
			sEmail.setSubject('New Contact was created by suraj singh'); sEmail.setPlainTextBody('Salesforce Account Created Successfully');
			emailList.add(sEmail);
			messaging.sendEmail(emaillist);

        }  
    
    
 
    public static void handleAfterInsert(List<Contact> newContacts) {
        Set<Id> accountIds = new Set<Id>();

       
        for (Contact con : newContacts) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }

        if (!accountIds.isEmpty()) {
            List<Account> accountsToUpdate = [
                SELECT Id, Contact_Created__c 
                FROM Account 
                WHERE Id IN :accountIds AND Contact_Created__c = FALSE
            ];

            for (Account acc : accountsToUpdate) {
                acc.Contact_Created__c = true;
            }

            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
        }
    }


    public static void insertDescriptionWhenEmpty(List<Contact> newList){
        List<Contact> contactToUpdate = new List<Contact>();
        
        for(Contact con : newList){
            Contact contact = new Contact();
            if(con.Description == null){ 
                con.Description = (con.FirstName == null? 'user': con.FirstName) + con.LastName;
            }
            contactToUpdate.add(contact);
        }
    }
    
    public static void assignContactNameWithAccountWebsite(List<Contact> contactList){
               
        Set<Id> accountIds = new Set<Id>();
        
        for (Contact con : contactList) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }

        if (accountIds.isEmpty()) return;

       
        Map<Id, Account> accountMap = new Map<Id, Account>(
            [SELECT Id, Website FROM Account WHERE Id IN :accountIds]
        );

        
        for (Contact con : contactList) {
            if (con.AccountId != null && accountMap.containsKey(con.AccountId)) {
                Account acc = accountMap.get(con.AccountId);
                acc.Website = con.Name; 
            }
        }

        update accountMap.values();
    }

    
  
    public static void updateAccountDescriptions(List<Contact> newList, Map<Id, Contact> oldMap) {
        Map<Id, String> accountIdToDescription = new Map<Id, String>();

        for (Contact con : newList) {
            Contact oldCon = oldMap.get(con.Id);

           
            if (con.AccountId != null && con.Description != oldCon.Description) {
                accountIdToDescription.put(con.AccountId, con.Description);
            }
        }

       
        if (!accountIdToDescription.isEmpty()) {
            List<Account> accountsToUpdate = new List<Account>();

            for (Id accId : accountIdToDescription.keySet()) {
                accountsToUpdate.add(new Account(
                    Id = accId,
                    Description = accountIdToDescription.get(accId)
                ));
            }

            update accountsToUpdate;
        }
    }

    public static void updateAccountDes(List<Contact> newList,Map<Id,Contact> oldMap){
        Map<Id,String> descToUpdate = new Map<Id,String>();
        
        for(Contact con : newList){
            if(con.AccountId != null &&  con.Description != oldMap.get(con.AccountId).Description){
                descToUpdate.put(con.Id, con.Description);
            }
        }
        if(!descToUpdate.isEmpty()){
            List<Account> accList = new List<Account>();
            for(Id ids : descToUpdate.keySet()){
               Account accObj = new Account();
                accObj.Id = ids;
                accObj.Description = descToUpdate.get(ids);
                accList.add(accObj);
            }
            update accList;
        }
      
    }

    
    
    public static void updateAccDes(List<Contact> newList, Map<Id,Contact> oldMap){
        
        Map<Id,String> accIdsAndDes = new Map<Id,String>();
        for(Contact con : newList){
            if(con.AccountId != null && con.Description != oldMap.get(con.Id).Description){
                accIdsAndDes.put(con.AccountId, con.Description);
            }
        }
        
        List<Account> accountToUpdate = new List<Account>();
        if(!accIdsAndDes.isEmpty()){
            for( Id ids : accIdsAndDes.keySet()){
                Account acc = new Account();
                acc.Id = ids ;
                acc.Description = accIdsAndDes.get(ids);
                accountToUpdate.add(acc);
            }
        }
        if(!accountToUpdate.isEmpty()){
            update accountToUpdate;
        }
    }
    
    
    public static void updateAccountPhoneAfterChangingContactPhone(List<Contact> newList, Map<Id,Contact> oldMap){
        
        Map<Id,String> accountIdAndPhone = new Map<Id,String>();
        
        for(Contact con : newList){
            if(con.AccountId != null && con.Phone != oldMap.get(con.Id).Phone){
                accountIdAndPhone.put(con.AccountId, con.Phone);
            }
        }
        
        List<Account> accountToUpdate = new List<Account>();
        if(!accountIdAndPhone.isEmpty()){
            for(Id ids : accountIdAndPhone.keySet()){
                Account acc = new Account();
                acc.Id = ids ;
                acc.Phone = accountIdAndPhone.get(ids);
                accountToUpdate.add(acc);
            }
        }
        if(!accountToUpdate.isEmpty()){
            update accountToUpdate;
        }
    }
    

    
    
    
    
    
    
    
    
    public static void updateAccountNameWithCountactNameUpdate(List<Contact> newList, Map<Id,Contact> oldMap){
 		Map<Id,String> accountIdAndPhone = new Map<Id,String>();
        for(Contact con : newList){
            if( con.AccountId != null && con.Phone != oldMap.get(con.Id).Phone){
                accountIdAndPhone.put(con.AccountId, con.Phone);
            }
        }
        
        List<Account> accountToUpdate = new List<Account>();
        if(!accountIdAndPhone.isEmpty()){
            for(Id ids : accountIdAndPhone.keySet()){
                Account acc = new Account();
                acc.Id = ids;
                acc.Phone = accountIdAndPhone.get(ids);
            }
        }
        if(!accountToUpdate.isEmpty()){
            update accountToUpdate;
        }
    }
  
    public static void avoidDuplicate(List<Contact> newList){
        Map<Id,String> contactName = new Map<Id,String>();
        
        for(Contact con : newList){
            if(con.Name != null ){
                contactName.put(con.Id , con.Name);
            }
        }
        if(!contactName.isEmpty()){
            
        }
    }
    
    
    public static void updateContactWithSalutation(List<Contact> newList){
        
        Map<Id,String> salutationMapList = new Map<Id,String>();
        for(Contact con : newList){
            if(con.Salutation != null){
                salutationMapList.put(con.Id, con.Salutation);
            }
            
        }
            List<Contact> contactToUpdate = new List<Contact>();
            for(Id ids : salutationMapList.keySet()){
                
                Contact obj = new Contact();
                obj.Id = ids ;
                obj.Salutation = salutationMapList.get(ids);
                 if(obj.Salutation == 'Mr' || obj.Salutation == 'Dr'){
                    obj.Gender__c = 'Male';
                   
                }else if(obj.Salutation =='Ms' || obj.Salutation =='Mrs'){
                    obj.Gender__c = 'Female';
                   
                }
                contactToUpdate.add(obj);
            }
        
        
       }
   
    
    
    public static void updateAccountFieldHasRelatedContact(List<Contact> newList, Map<Id,Contact> oldMap){
        
    Set<Id> accountIds = new Set<Id>();
    for(Contact con : newList) {
        if(con.AccountId != null){
            accountIds.add(con.AccountId);
        }
        
    }

    List<Account> accountsWithContacts = [SELECT Id, Name,Has_Related_Contact__c,
                                          (SELECT Id, Name FROM Contacts) 
                                          FROM Account WHERE Id IN :accountIds];

      	List<Account> accountToUpdate = new List<Account>();  
    	for (Account account : accountsWithContacts) {
            if(!accountsWithContacts.isEmpty()){
                
                Account obj = new Account();
                obj.Id = account.Id;
                obj.Has_Related_Contact__c = True;
                accountToUpdate.add(obj);
            }
    }
        if(!accountToUpdate.isEmpty()){
            update accountToUpdate ;
        }
}
  
    public static void checkRelatedContactCount(List<Contact> newList){
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : newList){
            if(con.AccountId != null ){
                accountIds.add(con.AccountId);
            }
        }
        
        List<Account> accContactCount = [SELECT Id,Related_Contact_Count__c,Name,
                                         (SELECT Id,Name FROM Contacts)
                                        FROM Account WHERE ID IN : accountIds ];
        
       
        
        List<Account> accountToUpdate = new List<Account>();
        for(Account acc :accContactCount){
            //Account obj = new Account();
           	//obj.Id = acc.Id;
            acc.Related_Contact_Count__c = acc.Contacts.size();
            accountToUpdate.add(acc);
            
        }
        if(!accountToUpdate.isEmpty()){
            update accountToUpdate ;
        }
    }
    
   
    public static void getAllCount(List<Contact> newList){
        
        Set<String> roleList = new Set<String>();
        Set<Id> ids = new Set<Id>();
        for(Contact con : newList){
            if(con.AccountId != null && con.Role__c != null){
                if(con.Role__c =='HR' || con.Role__c == 'QA' || con.Role__c == 'Admin' || con.Role__c == 'Dev'){
                    ids.add(con.AccountId);
                    roleList.add(con.Role__c);
                }
                
            }
        }
        List<AggregateResult> conList = [SELECT COUNT(Id) c,AccountId
                                        FROM Contact
                                        WHERE AccountId IN : ids AND Role__c IN : roleList
                                        GROUP BY AccountId];
        
        system.debug(conList + 'conlist ::::::>>>>>>>>>>>>>>>>>>');
       
        List<Account> accountToUpdate = new List<Account>();
        Map<Id,Aggregateresult> mapList = new Map<Id,Aggregateresult>();
        
        if(!conList.isEmpty()){
            for(AggregateResult ar : conList){
                Id accountId = (Id)ar.get('AccountId');
                mapList.put(accountId , ar);
               
            }
            for( Contact newCon : newList){
                AggregateResult result = mapList.get(newCon.AccountId);
                Decimal countOf = (Decimal)result.get('c');
                Account obj = new Account();
                obj.Id = newCon.AccountId;
                
                if(newCon.Role__c == 'HR'){
                    obj.Number_Of_HR__c =countOf;
                } else if(newCon.Role__c =='QA'){
                    obj.Number_Of_QA__c = countOf;
                }else if (newCon.Role__c == 'Admin'){
                    obj.Number_Of_Admin__c = countOf;
                }else{
                    obj.Number_Of_Dev__c = countOf;
                }
                
                accountToUpdate.add(obj);
               
                
            }
            if(!accountToUpdate.isEmpty()){
                update accountToUpdate;
            }
 		}
     }
        
    
}
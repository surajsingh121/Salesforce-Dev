public with sharing class DemoContactTriggerHandler {
   
    public static void validateContactWithEmail(List<Contact> newList, Map<Id,Contact> oldMap){
        Set<String> emailSet =  new Set<String>();

        for(Contact con : newList){
            if(con.Email != null && con.Email != oldMap.get(con.Id).Email){
               emailSet.add(con.Id);
            }
        }
      List<Contact> existingContacts = [SELECT Id, Email FROM Contact WHERE Email IN :emailSet];

     
      if(!existingContacts.isEmpty()){
        for(Contact con : newList){
            for(Contact existingCon : existingContacts){
                if(con.Email != null && con.Email == existingCon.Email && con.Id != existingCon.Id){
                    con.addError('A contact with this email already exists.');
                }
            }
           
        }
  }
}
}
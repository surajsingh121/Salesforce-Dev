public class CaseTriggerHandler {
    //whenever a case is created  and case origin is phone ,set priority as High,else set Priority as Low.
    public static void createCase(List<Case> newCase){
        
        for(Case caseList : newCase){
            if( caseList.Origin != null && caseList.Origin == 'Phone'){
                caseList.Priority = 'High';
            }else{
                caseList.Priority = 'Low';
            }
        }
    }
}
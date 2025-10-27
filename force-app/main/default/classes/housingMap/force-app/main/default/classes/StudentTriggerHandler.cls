public class StudentTriggerHandler {

    public static void createStudentRecordsAndPhoneValidate(List<Student__c> newList){
       
        for(Student__c std : newList){
            Contact cont = new Contact();
            cont.LastName = std.Name;
           if(String.isBlank(std.Phone__c) || std.Phone__c.length()<10){
               std.Name = std.Name;
               std.phone__c.addError('enter the valid phone number');
            }
        }
       
    }
    public static void insertTotalNumberOfStudentInAccount(List<Student__c> newList){
        
        
    }
}
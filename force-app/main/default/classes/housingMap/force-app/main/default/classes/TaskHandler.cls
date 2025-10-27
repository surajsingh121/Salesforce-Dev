public class TaskHandler {
    public static void preventTaskDeleteForNonAdmins(List<Task> tasksToDelete) {

        Id currentUserProfileId = UserInfo.getProfileId();


        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];


        if (currentUserProfileId != sysAdminProfile.Id) {
            for (Task t : tasksToDelete) {
                t.addError('Only System Administrators can delete tasks.');
            }
        }
    }
}
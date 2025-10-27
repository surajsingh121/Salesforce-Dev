trigger TaskTrigger on Task (before delete) {
    if (Trigger.isBefore && Trigger.isDelete) {
        TaskHandler.preventTaskDeleteForNonAdmins(Trigger.old);
    }
}
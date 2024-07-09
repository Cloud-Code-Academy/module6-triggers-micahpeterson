trigger OpportunityTrigger on Opportunity (before update, before delete, after update) {
    if(Trigger.isBefore && Trigger.isDelete){
        OpportunityTriggerHandler.beforeDelete(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        OpportunityTriggerHandler.beforeUpdate(Trigger.new);
    }
}
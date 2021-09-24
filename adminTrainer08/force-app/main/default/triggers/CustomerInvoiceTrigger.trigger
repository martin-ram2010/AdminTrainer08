trigger CustomerInvoiceTrigger on Customer_Invoice__c (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            System.debug('Before Insert event');
            System.debug('Trigger.new :'+Trigger.new);
            System.debug('Trigger.newMap : '+ Trigger.newMap);
            System.debug('Trigger.old : '+Trigger.old);
            System.debug('Trigger.oldMap '+Trigger.oldMap);
        }
        if(Trigger.isUpdate){
            System.debug('Before Update event');
            System.debug('Trigger.new :'+Trigger.new);
            System.debug('Trigger.newMap : '+ Trigger.newMap);
            System.debug('Trigger.old : '+Trigger.old);
            System.debug('Trigger.oldMap '+Trigger.oldMap);

            CustomerInvoiceTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        if(Trigger.isDelete){
            System.debug('Before Delete event');
            System.debug('Trigger.new :'+Trigger.new);
            System.debug('Trigger.newMap : '+ Trigger.newMap);
            System.debug('Trigger.old : '+Trigger.old);
            System.debug('Trigger.oldMap '+Trigger.oldMap);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            System.debug('After Insert event');
            System.debug('Trigger.new :'+Trigger.new);
            System.debug('Trigger.newMap : '+ Trigger.newMap);
            System.debug('Trigger.old : '+Trigger.old);
            System.debug('Trigger.oldMap '+Trigger.oldMap);
        }
        if(Trigger.isUpdate){
            System.debug('After Update event');
            System.debug('Trigger.new :'+Trigger.new);
            System.debug('Trigger.newMap : '+ Trigger.newMap);
            System.debug('Trigger.old : '+Trigger.old);
            System.debug('Trigger.oldMap '+Trigger.oldMap);
            
            CustomerInvoiceTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        if(Trigger.isDelete){
            System.debug('After Delete event');
            System.debug('Trigger.new :'+Trigger.new);
            System.debug('Trigger.newMap : '+ Trigger.newMap);
            System.debug('Trigger.old : '+Trigger.old);
            System.debug('Trigger.oldMap '+Trigger.oldMap);
        }
        if(Trigger.isUndelete){
            System.debug('After Undelete event');
            System.debug('Trigger.new :'+Trigger.new);
            System.debug('Trigger.newMap : '+ Trigger.newMap);
            System.debug('Trigger.old : '+Trigger.old);
            System.debug('Trigger.oldMap '+Trigger.oldMap);
        }
    }
}
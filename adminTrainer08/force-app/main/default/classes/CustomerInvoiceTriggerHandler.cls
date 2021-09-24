public with sharing class CustomerInvoiceTriggerHandler {
    public static final String BEFORE_UPDATE = 'BEFORE_UPDATE';
    public static final String AFTER_UPDATE = 'AFTER_UPDATE';
    public static Map<String, Set<Id>> recursiveMap = new Map<String, Set<Id>>();

    public static void beforeInsert(){}

    public static void beforeUpdate(List<Customer_Invoice__c> newInvoices, Map<Id, Customer_Invoice__c> oldMap){

        //Fetch the related Invoice Line Item records for which the Price is null
        Set<Id> nullPricedInvoiceIds = new Set<Id>();
        for(Invoice_Line_Item__c invoiceLineItem : [SELECT Id, Name, Price__c, Customer_Invoice__c FROM Invoice_Line_Item__c WHERE Customer_Invoice__c IN :newInvoices AND Price__c = NULL]){
            nullPricedInvoiceIds.add(invoiceLineItem.Customer_Invoice__c);
        }

        //Process Invoice Records
        for(Customer_Invoice__c invoice : newInvoices){
            if(!recursiveMap.containsKey(BEFORE_UPDATE)){
                recursiveMap.put(BEFORE_UPDATE, new Set<Id>());
            }
            if(recursiveMap.containsKey(BEFORE_UPDATE) && !recursiveMap.get(BEFORE_UPDATE).contains(invoice.Id)){
                recursiveMap.get(BEFORE_UPDATE).add(invoice.Id);
                //Check if the Status is changing to Processed and INVL's Price is null, if so then show the error message
                Customer_Invoice__c oldInvoice = oldMap.get(invoice.Id);
                if(nullPricedInvoiceIds.contains(invoice.Id) && invoice.Status__c != oldInvoice.Status__c && invoice.Status__c == 'Processed'){
                    invoice.addError('The Current Invoice Record\'s Invoice Line Item Price is null.');
                }
            }
        }
    }
    public static void beforeDelete(){}
    public static void afterInsert(){}

    public static void afterUpdate(List<Customer_Invoice__c> newInvoices, Map<Id, Customer_Invoice__c> oldMap){
        //Process Invoice Records
        Set<Id> processedInvoiceId = new Set<Id>();
        for(Customer_Invoice__c invoice : newInvoices){
                if(!recursiveMap.containsKey(AFTER_UPDATE)){
                    recursiveMap.put(AFTER_UPDATE, new Set<Id>());
                }
                if(recursiveMap.containsKey(AFTER_UPDATE) && !recursiveMap.get(AFTER_UPDATE).contains(invoice.Id)){

                    recursiveMap.get(AFTER_UPDATE).add(invoice.Id);
                    //Check if the Status is changing to Processed, if so collect those Invoice record Ids
                    Customer_Invoice__c oldInvoice = oldMap.get(invoice.Id);
                    if(invoice.Status__c != oldInvoice.Status__c && invoice.Status__c == 'Processed'){
                        processedInvoiceId.add(invoice.Id);
                    }
            }
        }

        //Query the related(processedInvoiceId) Invoice Line item records for which the INVL's Status__c is not Processed, update the Status__c to Processed
        List<Invoice_Line_Item__c> invoiceLineItems = new List<Invoice_Line_Item__c>();

        if(!processedInvoiceId.isEmpty()){
            for(Invoice_Line_Item__c invoiceLineItem : [SELECT Id, Name, Customer_Invoice__c, Status__c FROM Invoice_Line_Item__c WHERE Customer_Invoice__c IN :processedInvoiceId AND Status__c != 'Processed']){
                invoiceLineItem.Status__c = 'Processed';
                invoiceLineItems.add(invoiceLineItem);
            }
        }

        if(!invoiceLineItems.isEmpty()){
            update invoiceLineItems;
        }
    }

    public static void afterDelete(){}
    public static void afterUdelete(){}
}

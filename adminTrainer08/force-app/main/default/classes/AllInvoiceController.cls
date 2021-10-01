public with sharing class AllInvoiceController {

     //Get all the Invoice records
     @AuraEnabled
     public static List<Customer_Invoice__c> getAllInvoice(){
         List<Customer_Invoice__c> invoiceList = [SELECT Id, Name from Customer_Invoice__c];
         return invoiceList;
     }

    //Get INVL list records for the passed invoice record Id
    @AuraEnabled
    public static List<Invoice_Line_Item__c> getInvoiceLineItems(Id invoiceId){
        return [SELECT Id, Product_Name__c, Price__c, Status__c from Invoice_Line_Item__c WHERE Customer_Invoice__c=:invoiceId];
    }

    //Get Invoice Record records for the passed invoice record Id
    @AuraEnabled
    public static Customer_Invoice__c getInvoiceRecord(Id invoiceId){
        Customer_Invoice__c invoiceRecord = [SELECT Id, Name, Status__c, Price__c FROM Customer_Invoice__c WHERE Id =: invoiceId];
        return invoiceRecord;
    }
}

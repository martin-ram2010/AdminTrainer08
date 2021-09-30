public with sharing class InvoiceDetailsWithINVLLtng {
    
    //To send this class data as a response when the lightning component is loaded
    public class InvoiceData{
        @AuraEnabled
        public Customer_Invoice__c invoiceRecord;
        @AuraEnabled
        public List<Invoice_Line_Item__c> invls;
    }

    @AuraEnabled
    public static InvoiceData getInvoiceData(Id invoiceId){
        InvoiceData data = new InvoiceData();
        try {
            //Fetch the Invoice Record based on invoiceId
            data.invoiceRecord = [SELECT Id, Name, Billing_Date__c, Country__c, Status__c, Max_INVL_Price__c, Min_INVL_Price__c, SOA_External_ID__c, Price__c FROM Customer_Invoice__c WHERE Id =:invoiceId];
        
            //Fetch the related INVL Records based on invoiceId
    	    data.invls = [SELECT Id, Product_Name__c, Price__c, Status__c, Customer_Invoice__c FROM Invoice_Line_Item__c WHERE Customer_Invoice__c = :invoiceId];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return data;
    }
}

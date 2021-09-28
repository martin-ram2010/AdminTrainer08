public class InvoiceWithINVLClassic {
	//Model
    public List<Customer_Invoice__c> invoices {get; set;}
    public Customer_Invoice__c invoiceRecord {get; set;}
    public List<Invoice_Line_Item__c> invoiceLineItems {get; set;}
    public Id invoiceId {get; set;}
    
    //Constructor to initialize the Invoices
    public InvoiceWithINVLClassic(){
        invoices = [SELECT Id, Name, Billing_Date__c, Country__c, Status__c FROM Customer_Invoice__c];
    }
    
    public void getInvoiceDetail(){
        System.debug('invoiceId:' +invoiceId);
        invoiceRecord = [SELECT Id, Name, Billing_Date__c, Country__c, Status__c, Max_INVL_Price__c, Min_INVL_Price__c, SOA_External_ID__c FROM Customer_Invoice__c WHERE Id =:invoiceId];
    	invoiceLineItems = [SELECT Id, Product_Name__c, Price__c, Status__c, Customer_Invoice__c FROM Invoice_Line_Item__c WHERE Customer_Invoice__c = :invoiceId];
    }
    
}
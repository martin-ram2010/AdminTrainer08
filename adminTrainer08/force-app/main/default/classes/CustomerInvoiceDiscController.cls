public class CustomerInvoiceDiscController {
	//Action - to calculate the percentage
	@AuraEnabled
    public static Decimal calculatePercentage(Id invoiceId, Double percentage){
        Decimal discountPrice = 0;
        //Fetch Current Invoice record based on invoiceId
        Customer_Invoice__c invoice = [SELECT Id, Price__c FROM Customer_Invoice__c WHERE Id =:invoiceId];
        System.debug('percentage:'+percentage);
        System.debug('invoice.Price__c:'+invoice.Price__c);
        
        //Calculate the Percentage
        if(percentage != null && invoice.Price__c != null){
            System.debug('Inside');
            percentage = percentage/100.0;
            Decimal discPrice = invoice.Price__c * percentage;
        	discountPrice = invoice.Price__c - discPrice; 
        }
        System.debug('discountPrice:'+discountPrice);
        
        return discountPrice;
    }
}
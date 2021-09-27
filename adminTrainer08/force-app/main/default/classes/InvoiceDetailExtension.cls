public class InvoiceDetailExtension {
    //Model - with Getter and Setters
    public Customer_Invoice__c invoice {get; set;}
    public Decimal discountPrice {get; set;}
    public Integer percentage {get; set;} 
    
    //Controller
    public InvoiceDetailExtension(ApexPages.StandardController sc){
        percentage = 10;
        List<String> fields = new List<String>();
        fields.add('Name');
        fields.add('Price__c');
        sc.addFields(fields);
        invoice = (Customer_Invoice__c)sc.getRecord();
        calculatePercentage();
    }
    //Action - to calculate the percentage
    public void calculatePercentage(){
        System.debug('percentage:'+percentage);
        System.debug('invoice.Price__c:'+invoice.Price__c);
        if(percentage != null){
            System.debug('Inside');
            Double percentage = percentage/100.0;
            Decimal discPrice = invoice.Price__c * percentage;
        	discountPrice = invoice.Price__c - discPrice; 
        }
        System.debug('discountPrice:'+discountPrice);
    }
}
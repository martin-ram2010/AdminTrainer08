@isTest
public class AllInvoiceControllerTest {
    
    @isTest
    static void getAllInvoiceTest(){

    /***********************If no Customer_Invoice__c records are exist then return 0 records***********/
        //Invoke the controller method to test the scenario
        List<Customer_Invoice__c> invoiceList = AllInvoiceController.getAllInvoice();
        System.assertEquals(0, invoiceList.size(), 'Failed Scenario : If no Customer_Invoice__c records are exist then return 0 records');


    /***********************If there's one Customer_Invoice__c records are exist then return 1 records***********/
        //Get Customer_Invoice__c India Invoice Record Type
        Id invoiceInvoiceRTId = Schema.SObjectType.Customer_Invoice__c.getRecordTypeInfosByName().get('India Invoice').getRecordTypeId(); 

        //Insert a Sample Invoice Record - Creating Test Data
        Customer_Invoice__c invoiceRecord = new Customer_Invoice__c();
        invoiceRecord.Name = 'Test Customer';
        invoiceRecord.RecordTypeId = invoiceInvoiceRTId;
        insert invoiceRecord;

        //Invoke the controller method to test the scenario
        invoiceList = AllInvoiceController.getAllInvoice();
        System.assertEquals(1, invoiceList.size(), 'Failed Scenario : If there\'s one Customer_Invoice__c records are exist then return 1 records');


        /***********************If there's more than one Customer_Invoice__c records are exist then return more than one records***********/

        //Insert a Sample Invoice Record - Creating Test Data for multiple invoice records
        Customer_Invoice__c invoiceRecord2 = new Customer_Invoice__c();
        invoiceRecord2.Name = 'Test Customer';
        invoiceRecord2.RecordTypeId = invoiceInvoiceRTId;
        insert invoiceRecord2;

        //Invoke the controller method to test the scenario
        invoiceList = AllInvoiceController.getAllInvoice();
        System.assertEquals(2, invoiceList.size(), 'If there\'s more than one Customer_Invoice__c records are exist then return more than one records');
    }

    @isTest
    static void getInvoiceLineItemsTest(){
        /*********************** If no Invoice Id passed then it should return no records ***********/
        List<Invoice_Line_Item__c> invls = AllInvoiceController.getInvoiceLineItems(null);
        System.assertEquals(0, invls.size(), 'If no Invoice Id passed then it should return no records');

        /*********************** If INVL record available and associated with Invoice ***********/
        //Get Customer_Invoice__c India Invoice Record Type
        Id invoiceInvoiceRTId = Schema.SObjectType.Customer_Invoice__c.getRecordTypeInfosByName().get('India Invoice').getRecordTypeId(); 

        //Insert a Sample Invoice Record - Creating Test Data
        Customer_Invoice__c invoiceRecord = new Customer_Invoice__c();
        invoiceRecord.Name = 'Test Customer';
        invoiceRecord.RecordTypeId = invoiceInvoiceRTId;
        insert invoiceRecord;

        //Insert a Sample INVL record for above Invoice Record
        Invoice_Line_Item__c invl = new Invoice_Line_Item__c();
        invl.Product_Name__c = 'Laptop';
        invl.Price__c = 600;
        invl.Customer_Invoice__c = invoiceRecord.Id;
        insert invl;

        //Invoke the main functionality
        invls = AllInvoiceController.getInvoiceLineItems(invoiceRecord.Id);

        //Check the test result
        System.assertEquals(1, invls.size(), 'If INVL record available and associated with Invoice');
    }

    @isTest
    static void getInvoiceRecordTest(){
        /*********************** If No Customer Invoice record exist and passing null cause error ***********/
        try{
            //Invoke the main functionality
            Customer_Invoice__c invoiceRecord = AllInvoiceController.getInvoiceRecord(null);
        }catch(System.QueryException ex){//Check the test result
            System.assertEquals('List has no rows for assignment to SObject', ex.getMessage(),'Getting different error message.');
        }

        /*********************** If Customer Invoice record exist and passing invoice Id get us Customer Invoice Record ***********/
        //Get Customer_Invoice__c India Invoice Record Type
        Id invoiceInvoiceRTId = Schema.SObjectType.Customer_Invoice__c.getRecordTypeInfosByName().get('India Invoice').getRecordTypeId(); 

        //Insert a Sample Invoice Record - Creating Test Data
        Customer_Invoice__c invoiceRecord = new Customer_Invoice__c();
        invoiceRecord.Name = 'Test Customer';
        invoiceRecord.RecordTypeId = invoiceInvoiceRTId;
        insert invoiceRecord;

        //Invoke the main functionality
        Customer_Invoice__c invRecord = AllInvoiceController.getInvoiceRecord(invoiceRecord.Id);

        //Check the test result
        System.assert(invRecord != null, 'Failed : If Customer Invoice record exist and passing invoice Id get us Customer Invoice Record');
    }
}
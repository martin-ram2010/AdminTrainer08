//Endpoint URL formed : https://2021com-dev-ed.my.salesforce.com/services/apexrest/invoice/v1/
@RestResource(urlMapping='/invoice/v1/*')
global class RESTWebServiceSample {
	@HttpGet
    global static Response getInvoiceRecord(){
		Response res = new Response();
        //URL
        //Id 
        //SOQL query based on recod Id
        //convert the soql result into wrapper class - response format
        
        //Get the Client Request
        RestRequest req = RestContext.request;
        System.debug('URI:'+req.requestURI);
        
        //Extract the external ID from the RequestURI
        String externalId = req.requestURI.substringAfterLast('/');
        System.debug('extracted external ID: '+externalID);
        
		//Query the Invoice records based on external id
        List<Invoice__c> invoiceRecords =[SELECT Id, Name, Street__c, Status__c, Max_INVL_Price__c, Min_INVL_Price__c, Country__c, Invoice_External_Id__c, Price__c, Billing_Date__c FROM Invoice__c WHERE Invoice_External_Id__c =:externalId];
        
		//If invoice record not exists with the provided external Id then prepare error response
        if(invoiceRecords.isEmpty()){
            res.isSuccess = false;
			res.errorMessage = 'Record is not found.';
        }else{ //otherwise prepare the success response with invoice data
			Invoice__c invoiceRecord = invoiceRecords[0];
			
            InvoiceData invData = new InvoiceData();
			invData.name	= invoiceRecord.Name;
			invData.status	= invoiceRecord.Status__c;
			invData.country	= invoiceRecord.Country__c;
			invData.invoiceExternalId	= invoiceRecord.Invoice_External_Id__c;
			invData.maxInvlPrice	= invoiceRecord.Max_INVL_Price__c;
			invData.minInvlPrice	= invoiceRecord.Min_INVL_Price__c;
			invData.price	= invoiceRecord.Price__c;
			invData.billingDate	= invoiceRecord.Billing_Date__c;
			invData.street	= invoiceRecord.Street__c;
			
			res.invoice = invData;
			res.isSuccess = true;
        }
        return res;
    }
	
	@HttpPost
	global static InvoiceResponse createUpdateInvoice(){
		InvoiceResponse res = new InvoiceResponse();
        
        //Fetch the current client request
        RestRequest req = RestContext.request;
        
        //Get the request body and covert into an object using JSON deserialize method
        InvoiceData data = (InvoiceData)JSON.deserialize(req.requestBody.toString(), InvoiceData.class);
		
        //Initialize the Invoice__c record with request payload data
		Invoice__c invoiceRecord = new Invoice__c();
		invoiceRecord.Name = data.name;
		invoiceRecord.Invoice_External_Id__c = data.invoiceExternalId;
		invoiceRecord.Status__c = data.status;
		invoiceRecord.Country__c = data.country;
		invoiceRecord.Billing_Date__c = data.billingDate;
		invoiceRecord.Street__c = data.street;
		
		Database.UpsertResult result = Database.upsert(invoiceRecord, Invoice__c.Invoice_External_Id__c, false);
		
		//If upsert DML is successful then prepare success message response payload
		if(result.isSuccess()){
			res.isCreated = result.isCreated();
			res.isUpdated = !result.isCreated();
			res.isSuccess = true;
		}else{//Otherwise the upsert failed, prepare errormessage response payload
			res.isSuccess = false;
			res.errorMessage = ''+result.getErrors();
		}
		
		return res;
	}
	
	global class InvoiceData{
		global String status;
		global String country;
		global String street;
		global String name;
		global String invoiceExternalId;
		global Decimal maxInvlPrice;
		global Decimal minInvlPrice;
		global Decimal price;
		global Date billingDate;
	}
	
	//Return as a Response for GET request
	global class Response{
		global InvoiceData invoice;
		global String errorMessage;
		global Boolean isSuccess;
	}
	
	//Return as a Response for POST request
	global class InvoiceResponse{
		global Boolean isCreated;
		global Boolean isUpdated;
		global String errorMessage;
		global Boolean isSuccess;
	}
}
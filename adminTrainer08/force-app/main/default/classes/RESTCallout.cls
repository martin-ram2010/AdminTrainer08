public class RESTCallout {

    //Credential Constants
    public static final String USER_NAME = '*******';
    public static final String PASSWORD = '*******';
    public static final String SECURTY_TOKEN = '*******';
    public static final String CLIENT_ID = '3MVG9fe4g9fhX0E6CPostqgMrBwiTzKrJuF27BRRF4a9l3RD5.FsIHr55PfNvTCZl7wA1G8.79uRxLkyDwB2Y';
    public static final String CLIENT_SECRET = 'A9843790A0EDEB489FC1CB3A3602A586DE4D9AF236A1EB531EB60CF4FDE5346B';
    public static final String LOGIN_END_POINT = 'https://login.salesforce.com/services/oauth2/token';
    
    public static String instanceUrl;
    public static String accessToken;
    
    //Login into external system and get the access token
    public static void login(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(LOGIN_END_POINT);
        req.setMethod('POST');
        req.setBody('grant_type=password'+
                   '&client_id='+CLIENT_ID+
                   '&client_secret='+CLIENT_SECRET+
                   '&username='+USER_NAME+
                   '&password='+PASSWORD+SECURTY_TOKEN);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
      
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody()); //{"access_token":"SESSION_ID_REMOVED","instance_url":"https://2021com-dev-ed.my.salesforce.com","id":"https://login.salesforce.com/id/00D5g000002uw7ZEAQ/0055g000001wVQlAAM","token_type":"Bearer","issued_at":"1633488611252","signature":"QPQRFkHiD2Lo8ylivWRiLvo5MwGhgDAzViszbuGjQyU="}
    	
        //Deserialize the response and assign the instance url and access token to static vairables
        AccessTokenClass token = (AccessTokenClass) JSON.deserialize(res.getBody(), AccessTokenClass.class);
        instanceUrl = token.instance_url;
        accessToken = token.access_token;
    }
    
    //Get the Invoice Record from Server and update on the current org
    public static void getInvoiceRecord(String externalId){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(instanceUrl+'/services/apexrest/invoice/v1/'+externalId);
        req.setMethod('GET');
        req.setHeader('Authorization','OAuth ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
      
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('getInvoiceRecord: '+res.getBody());
        
        if(res.getStatusCode() == 200){
            //Deserialize the response 
            Response invoiceResponse = (Response) JSON.deserialize(res.getBody(), Response.class);
            
            //Update current invoice record based on external id
            if(invoiceResponse.isSuccess){
                Customer_Invoice__c invoice = new Customer_Invoice__c();
                invoice.SOA_External_ID__c = invoiceResponse.invoice.invoiceExternalId ;
                invoice.Name = invoiceResponse.invoice.name;
                invoice.Status__c = invoiceResponse.invoice.status;
                
                upsert invoice Customer_Invoice__c.SOA_External_ID__c;
            }
        }else{
            System.debug('Got status : '+res.getStatusCode());
        }
        
    }
    
    //Get the Invoice Record from Server and update on the current org
    public static void createInvoiceRecord(String externalId){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(instanceUrl+'/services/apexrest/invoice/v1/');
        req.setMethod('POST');
        req.setHeader('Authorization','OAuth ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        
        //Fetch current record data and load it into InvoiceData object
        Customer_Invoice__c invoice = [SELECT Id, Name, Status__c, Street__c, SOA_External_ID__c, Billing_Date__c, Country__c FROM Customer_Invoice__c WHERE SOA_External_ID__c=:externalId];
        InvoiceData data = new InvoiceData();
        data.name = invoice.Name;
        data.status = invoice.Status__c;
        data.country = invoice.Country__c;
        data.street = invoice.Street__c;
        data.billingDate = invoice.Billing_Date__c;
        data.invoiceExternalId = invoice.SOA_External_ID__c;
        
        //Convert form object to JSON String and set it as request body
        String dataJsonString = JSON.serialize(data);
        req.setBody(dataJsonString);
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
      
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('createInvoiceRecord: '+res.getBody());
        
        if(res.getStatusCode() == 200){
            //Deserialize the response 
            InvoiceResponse invoiceResponse = (InvoiceResponse) JSON.deserialize(res.getBody(), InvoiceResponse.class);
            if(invoiceResponse.isSuccess){
                String operation = invoiceResponse.isCreated ? 'Created' : 'Updated';
                System.debug('Invoice record '+operation+' successfully.');
            }else{
                System.debug('Error received : '+invoiceResponse.errorMessage);
            }
        }else{
            System.debug('Got status : '+res.getStatusCode());
        }
    }
    
    //Wrapper class to extract/deserialize the login response
    public class AccessTokenClass{
        public String access_token;
        public String instance_url;
    }
    
    public class InvoiceData{
		public String status;
		public String country;
		public String street;
		public String name;
		public String invoiceExternalId;
		public Decimal maxInvlPrice;
		public Decimal minInvlPrice;
		public Decimal price;
		public Date billingDate;
	}
	
	//Deserialize the Response for GET request
	public class Response{
		public InvoiceData invoice;
		public String errorMessage;
		public Boolean isSuccess;
	}
    
    //Deserialize the  Response for POST request
	public class InvoiceResponse{
		public Boolean isCreated;
		public Boolean isUpdated;
		public String errorMessage;
		public Boolean isSuccess;
	}
    
}
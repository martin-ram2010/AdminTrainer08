global class SOAPWebServiceSample {
    webservice static Response getMessage(String message){
        Response res = new Response();
        res.response = 'You have sent message : "'+message+'" at time:'+DateTime.now();
        return res;
    }
    //Wrapper class - returned as webservice response
    global class Response{
        webservice String response;
    }
}
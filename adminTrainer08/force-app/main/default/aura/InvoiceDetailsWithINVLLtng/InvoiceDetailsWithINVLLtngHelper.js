({
    getInvoiceDetails : function(cmp) {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = cmp.get("c.getInvoiceData");
        action.setParams({ invoiceId : cmp.get("v.recordId")});
                          
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                console.log("From server InvoiceDetailsWithINVLLtng: " + JSON.stringify(response.getReturnValue()));
                let data = response.getReturnValue();
				cmp.set("v.invoiceRecord", data.invoiceRecord);
				cmp.set("v.invls", data.invls);

                if(data.invls.length === 0){
                    cmp.set("v.isInvlsAvailable", false); 
                }else{
                    cmp.set("v.isInvlsAvailable", true); 
                }
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    }
})

({
    handleApplicationEvent : function(cmp, event, helper) {
        var invoiceId = event.getParam("selectedInvoiceId");
        //If invoice Id is available then fetch Invoice record by calling helper function
        if(invoiceId){
            console.log('CompleteInvoiceDetailComponent Invoice Id: '+invoiceId);
            helper.getInvoiceId(cmp, invoiceId);
        }
    }
})

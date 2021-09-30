({
    loadInvoiceDetails : function(component, event, helper) {
        // Initialize the columns attribute
        component.set('v.columns', [
            {label: 'Product Name', fieldName: 'Product_Name__c', type: 'text'},
            {label: 'Status', fieldName: 'Status__c', type: 'text'},
            {label: 'Price', fieldName: 'Price__c', type: 'currency', typeAttributes: { currencyCode: 'USD', maximumSignificantDigits: 5}}
        ]);
        // Call to Apex class to get Invoice record and INVL records
        helper.getInvoiceDetails(component);
    }
})

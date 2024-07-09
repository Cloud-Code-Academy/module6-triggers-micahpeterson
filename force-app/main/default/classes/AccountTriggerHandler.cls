public with sharing class AccountTriggerHandler {
    
    public static void beforeInsert(List<Account> beforeInsertedAccounts) {
        for(Account acc : beforeInsertedAccounts){
        //Question 1
            if(String.isBlank(acc.Type)){
                acc.Type = 'Prospect';
            }
        //Question 2
            if (!String.isBlank(acc.ShippingStreet) || 
                !String.isBlank(acc.ShippingCity) || 
                !String.isBlank(acc.ShippingState) || 
                !String.isBlank(acc.ShippingPostalCode) || 
                !String.isBlank(acc.ShippingCountry)) {
                        acc.BillingStreet = acc.ShippingStreet;
                        acc.BillingCity = acc.ShippingCity;
                        acc.BillingState = acc.ShippingState;
                        acc.BillingPostalCode = acc.ShippingPostalCode;
                        acc.BillingCountry = acc.ShippingCountry;
                    }
            

        //Question 3
            if(acc.Phone != null && acc.Fax != null && acc.Website != null){
                acc.Rating = 'Hot';
            }
    }
    }

    public static void afterInsert(List<Account> afterInsertedAccounts){
        //Question 4
        List<Contact> contactsToCreate = new List<Contact>();
        for(Account a2 : afterInsertedAccounts){
            Contact newContact = new Contact();
            newContact.LastName = 'DefaultContact';
            newContact.Email = 'default@email.com';
            newContact.AccountId = a2.Id;
            contactsToCreate.add(newContact);
        }
        insert contactsToCreate;
    }
}

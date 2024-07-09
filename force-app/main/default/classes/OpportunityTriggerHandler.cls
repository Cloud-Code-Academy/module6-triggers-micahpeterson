public with sharing class OpportunityTriggerHandler {
//Question 6
    public static void beforeDelete(List<Opportunity> beforeDeletedOpportunities){
        Set<Id> accountIds = new Set<Id>();
        
        for (Opportunity opp : beforeDeletedOpportunities) {
            accountIds.add(opp.AccountId);
        }
        
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN :accountIds]);
        
        for (Opportunity opp : beforeDeletedOpportunities) {
            Account acc = accountMap.get(opp.AccountId);
            if (opp.StageName == 'Closed Won' && acc.Industry == 'Banking') {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }


//Question 5
    public static void beforeUpdate(List<Opportunity> beforeUpdatedOpportunities){
        Set<Id> accountIds = new Set<Id>();
        
        for(Opportunity oppbeforeupdate:beforeUpdatedOpportunities){
            if(oppbeforeupdate.Amount <= 5000 ){
                oppbeforeupdate.addError('Opportunity amount must be greater than 5000');
            }

//Question 7            
            if (oppbeforeupdate.AccountId != null) {
                accountIds.add(oppbeforeupdate.AccountId);
            }
        }
        // Map to store the Account ID to CEO Contact
        Map<Id, Contact> accountToCeoMap = new Map<Id, Contact>();

        // Query for Contacts with the title 'CEO' for the collected Account IDs
        for (Contact ceo : [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds AND Title = 'CEO'
        ]) {
            // Add to map if there isn't already a CEO for the account
            if (!accountToCeoMap.containsKey(ceo.AccountId)) {
                accountToCeoMap.put(ceo.AccountId, ceo);
            }
        }

        // Loop through all updated opportunities again
        for (Opportunity opp : beforeUpdatedOpportunities) {
            if (opp.AccountId != null && accountToCeoMap.containsKey(opp.AccountId)) {
                // Get the CEO contact for the account
                Contact ceo = accountToCeoMap.get(opp.AccountId);
                // Set the Primary Contact to the CEO
                opp.Primary_Contact__c = ceo.Id;
            }
        }
    }

}
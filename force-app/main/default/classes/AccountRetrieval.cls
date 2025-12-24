public with sharing class AccountRetrieval {
    /**
     * Retrieves an Account by Id
     * @param accountId The Id of the Account to retrieve
     * @return Account object or null if not found
     */
    @AuraEnabled(cacheable=true)
    public static Account getAccountById(String accountId) {
        try {
            return [SELECT Id, Name, Phone, Email__c, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account WHERE Id = :accountId LIMIT 1];
        } catch (QueryException e) {
            throw new AuraHandledException('Account not found: ' + e.getMessage());
        }
    }

    /**
     * Retrieves multiple Accounts by Name (contains search)
     * @param accountName The name to search for (case-insensitive)
     * @return List of matching Account records
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsByName(String accountName) {
        try {
            String searchTerm = '%' + accountName + '%';
            return [SELECT Id, Name, Phone, Email__c, BillingCity, BillingState FROM Account WHERE Name LIKE :searchTerm LIMIT 10];
        } catch (QueryException e) {
            throw new AuraHandledException('Error retrieving accounts: ' + e.getMessage());
        }
    }

    /**
     * Retrieves all Accounts with pagination
     * @param limitSize The number of records to retrieve
     * @param offsetSize The offset for pagination
     * @return List of Account records
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAllAccounts(Integer limitSize, Integer offsetSize) {
        try {
            return [SELECT Id, Name, Phone, Email__c, BillingCity, BillingState FROM Account ORDER BY Name LIMIT :limitSize OFFSET :offsetSize];
        } catch (QueryException e) {
            throw new AuraHandledException('Error retrieving accounts: ' + e.getMessage());
        }
    }

    /**
     * Retrieves Accounts by Phone number
     * @param phoneNumber The phone number to search for
     * @return List of matching Account records
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsByPhone(String phoneNumber) {
        try {
            return [SELECT Id, Name, Phone, Email__c, BillingCity FROM Account WHERE Phone = :phoneNumber LIMIT 10];
        } catch (QueryException e) {
            throw new AuraHandledException('Error retrieving accounts: ' + e.getMessage());
        }
    }

    /**
     * Retrieves account count
     * @return Total number of Account records
     */
    @AuraEnabled(cacheable=true)
    public static Integer getAccountCount() {
        try {
            return [SELECT COUNT() FROM Account];
        } catch (QueryException e) {
            throw new AuraHandledException('Error counting accounts: ' + e.getMessage());
        }
    }
}

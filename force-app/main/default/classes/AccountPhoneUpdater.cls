public with sharing class AccountPhoneUpdater {
    /**
     * Updates the phone number of an Account if the phone number already exists on another Account.
     * @param accountId The Id of the Account to update.
     * @param newPhone The new phone number to set.
     * @return Boolean True if updated, False if not (no duplicate found).
     */
    @AuraEnabled
    public static Boolean updatePhoneIfDuplicate(String accountId, String newPhone) {
        // Check if the phone number exists on another Account
        List<Account> duplicates = [
            SELECT Id FROM Account 
            WHERE Phone = :newPhone AND Id != :accountId
            LIMIT 1
        ];
        if (!duplicates.isEmpty()) {
            Account accToUpdate = [SELECT Id, Phone FROM Account WHERE Id = :accountId LIMIT 1];
            accToUpdate.Phone = newPhone;
            update accToUpdate;
            return true;
        }
        return false;
    }
}
@isTest
public class AccountPhoneUpdaterTest {
    @isTest
    static void testUpdatePhoneIfDuplicate() {
        // Create two accounts with different phone numbers
        Account acc1 = new Account(Name = 'Account One', Phone = '1234567890');
        Account acc2 = new Account(Name = 'Account Two', Phone = '0987654321');
        insert new List<Account>{acc1, acc2};

        // Try to update acc2's phone to acc1's phone (should succeed)
        Test.startTest();
        Boolean result = AccountPhoneUpdater.updatePhoneIfDuplicate(acc2.Id, '1234567890');
        Test.stopTest();

        // Reload acc2 and check if phone was updated
        Account updatedAcc2 = [SELECT Phone FROM Account WHERE Id = :acc2.Id];
        System.assertEquals(true, result, 'Should return true when duplicate found');
        System.assertEquals('1234567890', updatedAcc2.Phone, 'Phone should be updated to duplicate value');
    }

    @isTest
    static void testUpdatePhoneIfNoDuplicate() {
        // Create an account
        Account acc = new Account(Name = 'Account Three', Phone = '5555555555');
        insert acc;

        // Try to update to a phone number not present on any other account (should fail)
        Test.startTest();
        Boolean result = AccountPhoneUpdater.updatePhoneIfDuplicate(acc.Id, '6666666666');
        Test.stopTest();

        // Reload acc and check if phone was not updated
        Account updatedAcc = [SELECT Phone FROM Account WHERE Id = :acc.Id];
        System.assertEquals(false, result, 'Should return false when no duplicate found');
        System.assertEquals('5555555555', updatedAcc.Phone, 'Phone should not be updated');
    }
}
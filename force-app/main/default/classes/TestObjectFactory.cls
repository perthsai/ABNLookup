/* ---------------------------------------------------
    Author:    Sai Natarajan
    Company:   Simplus
    Description: 
        TestObectFactory is used as a central repository where records, required for testing,
		can be created easily. In case newly required fields are added to objects, this class
		should be one single place where the field can be added, instead of adjusting all 
		test classes creating this record by itself.

    Test Class: N.A.		
    Pages: N.A.
    History: Initial creation 2020/01/16

*/
@isTest
public class TestObjectFactory {

    private static Map<String, Map<String, String>> recordTypes = null;

    /*public static Picklist__c CreatePicklist(String name) {
        return new Picklist__c(
            Name = name != null ? name : 'Food',
            Field__c = 'INDUSTRY_CODE',
            External_Reference__c = 'FOOD',
            Active__c = true);
    }*/

    public static Product2 CreateProduct(String name) {
        return new Product2(
            Name = name != null ? name : 'Spot Test', 
            IsActive = true, 
            Family = 'Spot', 
            ProductCode = 'p01');
    }

    public static Lead CreateLead(String firstName, String lastName, String company) {
        return new Lead( 
            FirstName = firstName != null ? firstName : 'FirstName' , 
            LastName = lastName != null ? lastName : 'LastName', 
            Company = company != null ? company : 'Sqware Peg');
    }
            
    public static Account CreateAccount(String name) {
        return new Account(
            Name = name != null ? name : 'Test Account',
            ABN__C='12312312312');
    }
            
    public static Account CreateAccount(String name, string recordTypeName) {
        return new Account(
            Name = name != null ? name : 'Test Account',
            RecordTypeId = getRecordTypeId('Account', recordTypeName),
             ABN__C='12312312312'
            
            );
    }

    public static Account CreateAccount(String name, boolean abnValid, string abn) {
        Account newAccount = CreateAccount(name);
        newAccount.ABN__c = abn;
        newAccount.ABN_Type__c = 'Business Name';       
        newAccount.ABN_Validated__c = abnValid;
        newAccount.BillingStreet = '16 Test St';
        newAccount.BillingPostalCode = '2000';
        newAccount.BillingState = 'New South Wales';
        newAccount.BillingCity = 'Sydney';
        newAccount.BillingCountry = 'Australia';

        return newAccount;        
    }
        
    public static PriceBook2 CreatePricebook(string name) {
        return new Pricebook2(
            Name = name != null ? name : 'SCA Pricebook', 
            isActive = true);
    }

    public static Opportunity CreateOpportunity(string name, Id accountId) {
        return new Opportunity(
            Name = 'Test Oppportunity',
            StageName = 'Qualification',
            CloseDate = system.today().addMonths(6),
            AccountId = accountId);        
    }
    
    public static Id getRecordTypeId(String objectName, String recordTypeName) {
        if (recordTypes == null) {
            recordTypes = new Map<String, Map<String, String>>();
            List<RecordType> types = [
                SELECT Id, Name, SObjectType
                FROM RecordType];

            for (RecordType item :types) {
                if (!recordTypes.containsKey(item.SObjectType))
                    recordTypes.put(item.SObjectType, new Map<String, String>());
                recordTypes.get(item.SObjectType).put(item.Name, item.Id);
            }
        }

        return recordTypes.get(objectName).get(recordTypeName);
    }

    public static List<PricebookEntry> createPricebookEntries(List<Product2> products, Id pricebookId) {
        List<PricebookEntry> result = new List<PricebookEntry>();

        for (Product2 item :products) {
            result.add(new PricebookEntry(
                Pricebook2Id = pricebookId,
                Product2Id = item.Id,
                UseStandardPrice = false,
                UnitPrice = 12000, 
                IsActive = true));
        }

        return result;
    }

    public static ABN_Service_Settings__c CreateABNSetting() {
        ABN_Service_Settings__c result = new ABN_Service_Settings__c(
            ABNToken__c = 'FAKE ABN TOKEN', 
            MaxResults__c = 20);

        return result;
    }
}
@isTest
public class ABNDialogControllerTest {

	private static string abnParentAccount = 'eyJBQk4iOlt7ImlkZW50aWZpZXJWYWx1ZSI6Ijc3MDAwMDExMzE2In1dLCJBYm5OdW1iZXIiOiI3NyAwMDAgMDExIDMxNiIsIkFTSUNOdW1iZXIiOiIwMDAwMTEzMTYiLCJtYWluQnVzaW5lc3NQaHlzaWNhbEFkZHJlc3MiOnsiY291bnRyeSI6IkF1c3RyYWxpYSIsInBvc3Rjb2RlIjoiMjEzOCIsInN0YXRlQ29kZSI6Ik5TVyJ9LCJtYWluTmFtZSI6eyJlZmZlY3RpdmVGcm9tIjoiMjAwMC0wMi0yOCIsIm5hbWUiOiJOZXN0bGUgQXVzdHJhbGlhIEx0ZCIsIm9yZ2FuaXNhdGlvbk5hbWUiOiJORVNUTEUgQVVTVFJBTElBIExURCJ9fQ==';

	static ABN_Service_Settings__c settings = null;
	static Account account = null;
	//static Picklist__c picklist = null;

	static void SetUp(){
	    Test.setMock(HttpCalloutMock.class, new ABNSearchTest_Mock());

	    //picklist = TestObjectFactory.CreatePicklist('Food');
       // insert picklist;
	
		account = TestObjectFactory.CreateAccount('Test Account');
		settings = TestObjectFactory.CreateABNSetting();

		insert new SObject[] { account, settings };	
	}


	// Test Method: UpdateAccount
	public static testmethod void Test_UpdateAccount(){
        SetUp();
                
        String jsonData = '';
        Map<String,Object> data = new Map<String,Object> {
			'Id' => account.Id,
			'Name' => 'Test Account',
			'ABN_Type__c' => 'Entity Name'
	    };
		
		// TODO : Add extra code to validate the method call
		ABNDialogController.UpdateAccount(data);
	}
	
    // Test Method: UpdateABN
	public static testmethod void Test_UpdateABN(){
        SetUp();

        Lead lead = TestObjectFactory.CreateLead('first', 'last', 'company');
        insert lead;

		Map<string, string> abnrec = new Map<string,string>();

    	abnRec.put('abn', '42 432 966 554 ');
        // in case you'd like to sync other fields as well: //
        abnRec.put('name', 'Subway');
        abnRec.put('postcode', '2067');
        abnRec.put('state', 'New South Wales');
		abnRec.put('type', 'Entity Name');

		// TODO : Add extra code to validate the method call
		ABNDialogController.UpdateABN(account.Id, abnrec);
		ABNDialogController.UpdateABN(lead.Id, abnrec);
	}

    // Test Method: SearchABR
	public static testmethod void Test_SearchABR(){
        SetUp();

		Integer requestid = 0;
		string abn = '42 432 966 554';
		string name = 'Subway';
		string state = 'NSW';
		string zip = '2000';
		// TODO : Change following Assert Statement

		test.startTest(); 
		ABNDialogController.SearchABR(requestid, abn, name, state, zip);

		Account newAccount = TestObjectFactory.CreateAccount('test Account');
		newAccount.ABN__c = '';
		newAccount.ABN_Validated__c = false;
		newAccount.Name = 'Andronicus';
		newAccount.BillingStreet = '16 Test St';
		newAccount.BillingPostalCode = '2000';
		newAccount.BillingState = 'New South Wales';
		newAccount.BillingCity = 'Sydney';
		newAccount.BillingCountry = 'Australia';
		
		insert newAccount;

		Map<String,Object> accountData = new Map<String,Object>{
			'Id' => newAccount.Id,
			'Name' => 'Andronicus',
			'ABN__c' =>'77 000 011 316',
			'ABN_Type__c' => 'Business Name',
			'ShippingCountry' => 'Australia',
			'BillingCountry' => 'Australia',
			'ABN_Parent_Account__c' => abnParentAccount
		};

		ABNDialogController.UpdateAccount(accountData);		
	}

	public static testmethod void TestSearchExistingABNByAbn() {
        SetUp();
        
        string abn = ABNUtils.formatAbn('77000011316');

		Account newAccount = TestObjectFactory.CreateAccount('Andronicus Inc', true, abn);		
		newAccount.ABN_Parent_Account__c = abnParentAccount;        
	

		insert newAccount;

		test.startTest(); 

		ABNDialogController.SearchABR(1, abn, '', '', '');
	}

    // Test Method: SearchABR
	public static testmethod void Test_SearchABRByName(){
        SetUp();
		
		string state = 'NSW';
		string zip = '2000';

		test.startTest();

		ABNDialogController.SearchABR(0, null, 'Andronicus', state, zip);
	}
}
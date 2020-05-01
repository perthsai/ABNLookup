@isTest//(SeeAllData=true)
public class ABNUtilsTest {
	//Initial Test Data
	//Add Logic to Create data required
	static void SetUp(){
		test.StartTest();
	}
	//Tear Down 
	//Add Logic to delete data that has been created
	static void TearDown(){
		test.StopTest();
	}
	
	// Test Method: AbnUpdateParentAccounts
	public static testmethod void Test_AbnUpdateParentAccounts(){
		SetUp();
		Id accRecTypeId = [
			SELECT Id, Name
			 FROM RecordType
			WHERE SObjectType = 'Account'
			ORDER BY Name
			LIMIT 1][0].Id;

		List<Account> accounts =new List<Account>();
         Account a1 = TestObjectFactory.CreateAccount('Test Account2',true,'12312312012');
         Account a2 = TestObjectFactory.CreateAccount('Test Account1',true,'12312312312');
         accounts.add(a1);
         accounts.add(a2); 
        //accounts = 
		ABNUtils.ABREntity abrEntity = new ABNUtils.ABREntity();
		abrEntity.isCurrentIndicator = 'Y';
		abrEntity.score  = '100';
		abrEntity.organisationName = 'Andronicus';
        abrEntity.effectiveFrom = '00-00-0000' ; 
		abrEntity.fullName ='Simplus Australias';
		abrEntity.familyName ='IT ';
        abrEntity.relatedAccount = New Account(name='New Org'); 
        
		ABNUtils.ABNRecord abnRec = new ABNUtils.ABNRecord();
        abnRec.identifierStatus = 'Y';
        abnRec.identifierValue = '77000011316';
        abnRec.isCurrentIndicator = 'Y';
        abnRec.replacedFrom = '';

		ABNUtils.SearchResultsRecord resRec = new ABNUtils.SearchResultsRecord(); 
		resRec.ABN = abnRec;
		resRec.mainName = abrEntity;
		resRec.legalName = abrEntity;
		resRec.mainTradingName = abrEntity;
		resRec.businessName = abrEntity;
		resRec.tradingName = abrEntity;
		resRec.otherName = abrEntity;
		resRec.otherTradingName = abrEntity;
		resRec.ASICNumber='12312321212';
		resRec.mainBusinessPhysicalAddress = new ABNUtils.PhysicalAddress();
		resRec.result.relatedAccount= New Account (Name='');
        
        
    
        ABNUtils.ABRAbnSearchResult ABRNameSearchR = new  ABNUtils.ABRAbnSearchResult ();
        ABRNameSearchR.businessEntity201205 = new ABNUtils.ABNEntityResult();
        

		ABNUtils.ABRNameSearchResult resultset = new ABNUtils.ABRNameSearchResult();
		resultset.searchResultsList = new ABNUtils.SearchResultsList();
		resultset.searchResultsList.exceedsMaximum='10';
		resultset.searchResultsList.numberOfRecords='9';
		resultset.searchResultsList.searchResultsRecord = new List<ABNUtils.SearchResultsRecord> { resRec };

		ABNUtils.AddLocalAccounts(resultset);

		ABNUtils.PhysicalAddress phAddress = new ABNUtils.PhysicalAddress();
		
		phAddress.isCurrentIndicator = 'Y';
        phAddress.postcode = '2000';
        phAddress.stateCode = 'NSW';
        phAddress.effectiveFrom = '01-01-2000';
        phAddress.effectiveTo = '00-00-0000';
		
		


		System.Assert(ABNUtils.AbnUpdateParentAccounts(accounts) != null);
		ABNUtils.ABNEntityResult data = new ABNUtils.ABNEntityResult();
		data.businessName = new List<ABNUtils.ABREntity> { abrEntity };
        data.otherTradingName = new List<ABNUtils.ABREntity> { abrEntity };
        data.mainName = abrEntity;
        data.mainTradingName = abrEntity;
        data.mainBusinessPhysicalAddress = phAddress;
        data.ASICNumber = '1234566';
        data.ABN = new ABNUtils.ABNRecord[] { abnRec };

		ABNUtils.GenerateParentAccount(data, accRecTypeId);
        
		// TODO : Change following Assert Statement
		System.AssertEquals(ABNUtils.formatAbn('  7 7 0 0001 1 316'), '77 000 011 316');
		System.Assert(ABNUtils.Capitalize('tHIs iS a Test') == 'This Is A Test');

		abrEntity.familyName = 'Test 1';
		abrEntity.familyName = 'Test 2';

		TearDown();
	}
}
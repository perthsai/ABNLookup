public class ABNDialogController {
    public static string  Endpoint='https://abr.business.gov.au';  
    public String RecordTypename;
    private static ABN_Service_Settings__c setting = null;
	public static string testInput =  
        '<?xml version="1.0" encoding="utf-8"?> <ABRPayloadSearchResults xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://abr.business.gov.au/ABRXMLSearch/">     <request>         <identifierSearchRequest>             <authenticationGUID>e86fa079-8178-402d-bc80-9d47ab289216</authenticationGUID>             <identifierType>ABN</identifierType>             <identifierValue>77000011316</identifierValue>             <history>N</history>         </identifierSearchRequest>     </request>     <response>         <usageStatement>The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.</usageStatement>         <dateRegisterLastUpdated>2018-06-16</dateRegisterLastUpdated>         <dateTimeRetrieved>2018-06-16T13:44:39.8314988+10:00</dateTimeRetrieved>         <businessEntity201408>             <recordLastUpdatedDate>2018-02-14</recordLastUpdatedDate>             <ABN>                 <identifierValue>77000011316</identifierValue>                 <isCurrentIndicator>Y</isCurrentIndicator>                 <replacedFrom>0001-01-01</replacedFrom>             </ABN>             <entityStatus>                 <entityStatusCode>Active</entityStatusCode>                 <effectiveFrom>2000-02-28</effectiveFrom>                 <effectiveTo>0001-01-01</effectiveTo>             </entityStatus>             <ASICNumber>000011316</ASICNumber>             <entityType>                 <entityTypeCode>PUB</entityTypeCode>                 <entityDescription>Australian Public Company</entityDescription>             </entityType>             <goodsAndServicesTax>                 <effectiveFrom>2000-07-01</effectiveFrom>                 <effectiveTo>0001-01-01</effectiveTo>             </goodsAndServicesTax>             <mainName>                 <organisationName>NESTLE AUSTRALIA LTD</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </mainName>             <otherTradingName>                 <organisationName>ANDRONICUS</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>ANDRONICUS COFFEE</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>AUSTRALIAN UNITED FOODS</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>CAFE NESCAFE</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>CHALET PATISSERIE</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>INTERNATIONAL COFFEE COMPANY</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>KRAMAR PETCARE</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>MORNING SUN NATURAL FOOD COMPANY</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>MOVENPICK ICE CREAM</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>MUSASHI</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESPRESSO AUSTRALIA</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESPRESSO CLUB</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE BEVERAGES</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE BUSINESS EXCELLENCE SOLUTIONS</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE BUSINESS SERVICES</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE CONFECTIONERY AND SNACKS</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE FOODS</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE NUTRITION</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE PROFESSIONAL</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE PURINA PETCARE</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>POWERBAR AUSTRALIA</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>POWERBAR OCEANIA</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>PURINA HEALTH FOODS COMPANY</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>THE GLOBE CENTRE AOA</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>THE UNCLE TOBYS COMPANY</organisationName>                 <effectiveFrom>2010-07-07</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE HEALTHCARE NUTRITION</organisationName>                 <effectiveFrom>2007-07-01</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE PETERS ICE CREAM</organisationName>                 <effectiveFrom>2003-10-24</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>CDS GOURMET FOODS</organisationName>                 <effectiveFrom>2002-02-05</effectiveFrom>             </otherTradingName>             <otherTradingName>                 <organisationName>NESTLE PACIFIC ISLANDS</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </otherTradingName>             <mainBusinessPhysicalAddress>                 <stateCode>NSW</stateCode>                 <postcode>2138</postcode>                 <effectiveFrom>2018-01-01</effectiveFrom>                 <effectiveTo>0001-01-01</effectiveTo>             </mainBusinessPhysicalAddress>             <businessName>                 <organisationName>MERRICK PET CARE</organisationName>                 <effectiveFrom>2017-07-26</effectiveFrom>             </businessName>             <businessName>                 <organisationName>WHOLE EARTH FARMS</organisationName>                 <effectiveFrom>2016-12-15</effectiveFrom>             </businessName>             <businessName>                 <organisationName>KITKAT CHOCOLATORY</organisationName>                 <effectiveFrom>2016-10-25</effectiveFrom>             </businessName>             <businessName>                 <organisationName>COOK &amp; CO. ONLINE</organisationName>                 <effectiveFrom>2016-09-03</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE SNACKS</organisationName>                 <effectiveFrom>2015-11-11</effectiveFrom>             </businessName>             <businessName>                 <organisationName>Zukes Australia</organisationName>                 <effectiveFrom>2015-09-29</effectiveFrom>             </businessName>             <businessName>                 <organisationName>Movenpick Ice Cream Bondi Beach</organisationName>                 <effectiveFrom>2014-10-08</effectiveFrom>             </businessName>             <businessName>                 <organisationName>Nespresso Professional</organisationName>                 <effectiveFrom>2014-08-06</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESCAFE DOLCE GUSTO</organisationName>                 <effectiveFrom>2012-08-23</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NRG CEREALS</organisationName>                 <effectiveFrom>2012-01-20</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE HEALTH SCIENCE</organisationName>                 <effectiveFrom>2011-12-14</effectiveFrom>             </businessName>             <businessName>                 <organisationName>REGIONAL GLOBE OFFICE AOA</organisationName>                 <effectiveFrom>2010-12-24</effectiveFrom>             </businessName>             <businessName>                 <organisationName>KRAMAR PETCARE</organisationName>                 <effectiveFrom>2010-04-29</effectiveFrom>             </businessName>             <businessName>                 <organisationName>KRAMAR PETCARE</organisationName>                 <effectiveFrom>2010-04-29</effectiveFrom>             </businessName>             <businessName>                 <organisationName>KRAMAR PETCARE</organisationName>                 <effectiveFrom>2010-04-23</effectiveFrom>             </businessName>             <businessName>                 <organisationName>KRAMAR PETCARE</organisationName>                 <effectiveFrom>2010-04-21</effectiveFrom>             </businessName>             <businessName>                 <organisationName>MORNING SUN NATURAL FOOD COMPANY</organisationName>                 <effectiveFrom>2008-08-07</effectiveFrom>             </businessName>             <businessName>                 <organisationName>MORNING SUN NATURAL FOOD COMPANY</organisationName>                 <effectiveFrom>2008-08-07</effectiveFrom>             </businessName>             <businessName>                 <organisationName>MORNING SUN NATURAL FOOD COMPANY</organisationName>                 <effectiveFrom>2008-07-09</effectiveFrom>             </businessName>             <businessName>                 <organisationName>MOVENPICK ICE CREAM</organisationName>                 <effectiveFrom>2008-06-18</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE PROFESSIONAL</organisationName>                 <effectiveFrom>2008-06-18</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE BUSINESS SERVICES</organisationName>                 <effectiveFrom>2008-06-17</effectiveFrom>             </businessName>             <businessName>                 <organisationName>MOVENPICK ICE CREAM</organisationName>                 <effectiveFrom>2008-06-05</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE PROFESSIONAL</organisationName>                 <effectiveFrom>2008-05-29</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE PROFESSIONAL</organisationName>                 <effectiveFrom>2008-05-27</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE HEALTHCARE NUTRITION</organisationName>                 <effectiveFrom>2007-05-29</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE HEALTHCARE NUTRITION</organisationName>                 <effectiveFrom>2007-05-24</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE HEALTHCARE NUTRITION</organisationName>                 <effectiveFrom>2007-05-18</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE HEALTHCARE NUTRITION</organisationName>                 <effectiveFrom>2007-05-09</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE HEALTHCARE NUTRITION</organisationName>                 <effectiveFrom>2007-05-09</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE NUTRITION</organisationName>                 <effectiveFrom>2006-10-16</effectiveFrom>             </businessName>             <businessName>                 <organisationName>MUSASHI</organisationName>                 <effectiveFrom>2006-02-17</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE BEVERAGES</organisationName>                 <effectiveFrom>2005-08-01</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE BEVERAGES</organisationName>                 <effectiveFrom>2005-08-01</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE FOODS</organisationName>                 <effectiveFrom>2005-08-01</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE FOODS</organisationName>                 <effectiveFrom>2005-08-01</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE PURINA PETCARE</organisationName>                 <effectiveFrom>2005-07-08</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE PURINA PETCARE</organisationName>                 <effectiveFrom>2005-07-07</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE PURINA PETCARE AUSTRALIA</organisationName>                 <effectiveFrom>2005-07-06</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE CONFECTIONERY &amp; SNACKS</organisationName>                 <effectiveFrom>2005-02-22</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS COFFEE</organisationName>                 <effectiveFrom>2005-01-17</effectiveFrom>             </businessName>             <businessName>                 <organisationName>CHALET PATISSERIE</organisationName>                 <effectiveFrom>2004-06-07</effectiveFrom>             </businessName>             <businessName>                 <organisationName>CHALET PATISSERIE</organisationName>                 <effectiveFrom>2004-05-24</effectiveFrom>             </businessName>             <businessName>                 <organisationName>CHALET PATISSERIE</organisationName>                 <effectiveFrom>2004-04-12</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS</organisationName>                 <effectiveFrom>2004-03-26</effectiveFrom>             </businessName>             <businessName>                 <organisationName>CPW AUSTRALIA</organisationName>                 <effectiveFrom>2003-10-13</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE PETERS ICE CREAM</organisationName>                 <effectiveFrom>2003-09-29</effectiveFrom>             </businessName>             <businessName>                 <organisationName>POWERBAR AUSTRALIA</organisationName>                 <effectiveFrom>2003-06-03</effectiveFrom>             </businessName>             <businessName>                 <organisationName>POWERBAR OCEANIA</organisationName>                 <effectiveFrom>2003-01-16</effectiveFrom>             </businessName>             <businessName>                 <organisationName>CDS GOURMET FOODS</organisationName>                 <effectiveFrom>2002-02-01</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE PURINA PETCARE ASIA, OCEANIA, AND AFRICA</organisationName>                 <effectiveFrom>2002-01-29</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE PURINA PETCARE OCEANIA</organisationName>                 <effectiveFrom>2002-01-29</effectiveFrom>             </businessName>             <businessName>                 <organisationName>THE GLOBE CENTER AOA</organisationName>                 <effectiveFrom>2001-12-12</effectiveFrom>             </businessName>             <businessName>                 <organisationName>THE UNCLE TOBYS COMPANY</organisationName>                 <effectiveFrom>2001-07-23</effectiveFrom>             </businessName>             <businessName>                 <organisationName>THE UNCLE TOBYS COMPANY</organisationName>                 <effectiveFrom>2001-07-13</effectiveFrom>             </businessName>             <businessName>                 <organisationName>THE UNCLE TOBYS COMPANY</organisationName>                 <effectiveFrom>2001-07-11</effectiveFrom>             </businessName>             <businessName>                 <organisationName>THE UNCLE TOBYS COMPANY</organisationName>                 <effectiveFrom>2001-07-11</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE FOODSERVICES</organisationName>                 <effectiveFrom>2000-12-01</effectiveFrom>             </businessName>             <businessName>                 <organisationName>MAXIBON</organisationName>                 <effectiveFrom>2000-06-06</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS COFFEE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS COFFEE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS COFFEE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS COFFEE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS COFFEE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS COFFEE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>ANDRONICUS COFFEE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>CDS GOURMET FOODS</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>CHALET PATISSERIE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>INTERNATIONAL COFFEE COMPANY</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>INTERNATIONAL COFFEE COMPANY</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>INTERNATIONAL COFFEE COMPANY</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>INTERNATIONAL COFFEE COMPANY</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESPRESSO AUSTRALIA</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESPRESSO AUSTRALIA</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESPRESSO CLUB</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE CONFECTIONERY</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE CONFECTIONERY</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE ICE CREAM</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE PACIFIC ISLANDS</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>             <businessName>                 <organisationName>NESTLE.</organisationName>                 <effectiveFrom>2000-02-28</effectiveFrom>             </businessName>         </businessEntity201408>     </response> </ABRPayloadSearchResults>';

    @AuraEnabled 
    public static void UpdateAccount(Map<String,Object> account) {
        boolean allClear =true;
        system.debug(account);
        String ABN = (String)account.get('ABN__c');
        system.debug('The selected ABN is' +ABN);
        Account acct = new Account(ABN__c =ABN);
        List<Account>  acctList = new List<Account> ();
        acctList.add(acct);
        Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(acctList);
         
	      for (Datacloud.FindDuplicatesResult findDupeResult : results) {
             for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
    			for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
      				for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                    allClear = false;
                    String Duprecord=(String)matchRecord.getRecord().get('id');    
        		    System.debug('Duplicate Record: ' + matchRecord.getRecord());
                    apexpages.addMessage(new apexpages.Message(Apexpages.Severity.ERROR,'Duplicate Detected with these id(s): '+ Duprecord ));     
     		 }
   			}
           } 
         }  
        
        
        String jsonData = JSON.serialize(account);

        Account updateAcc = (Account)JSON.deserialize(jsonData, Account.class);
        system.debug(updateAcc);

        updateAcc.ABN_Validated__c = true;  
        
        if (GetRecordsAccess(updateAcc.Id).HasEditAccess) {
            update updateAcc;
        }
    }
    @AuraEnabled
    public static String SelecteRecordType(String recordTypeid) {
    	system.debug(recordTypeid); 
        return Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(recordTypeid).getName();
    }  

    @AuraEnabled
    public static void UpdateABN(String recordId, Map<String,String> abnRec) {
    	system.debug(abnRec);

    	String abn = (String)abnRec.get('abn');
        // in case you'd like to sync other fields as well: //
        String name = (String)abnRec.get('name');
        String zip = (String)abnRec.get('postcode');
        String postcode = (String)abnRec.get('postcode');
        String state = (String)abnRec.get('state');
		String abnType = (String)abnRec.get('type');
        
        if (GetRecordsAccess(recordId).HasEditAccess) {
	        if (recordId.startsWith('001')) { // Account
	            Account acc = [
	            	SELECT Id, Name FROM Account 
	            	WHERE Id = :recordId];
	            acc.Name = name;
	            acc.ABN__c = abn;
	            acc.ABN_Type__c = abnType; 
	            acc.ABN_Validated__c = true;
	            update acc;
	        } else if (recordId.startsWith('00Q')) { // Lead
	            Lead lead = [
	            	SELECT Id, Name, Company FROM Lead 
	            	WHERE Id = :recordId];
	            lead.ABN__c = abn;
	            // lead.ABN_Type__c = abnType;
	            lead.Company = name;
	            // lead.ABN_Validated__c = true;
	            update lead;
	        }
	    } else throw new NoAccessException();
    }

    private static UserRecordAccess GetRecordsAccess(Id recordId) {
		return [
			SELECT RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess, HasTransferAccess, HasAllAccess, MaxAccessLevel
			FROM UserRecordAccess 
			WHERE UserId = :userinfo.getUserId()
			  AND RecordId = :recordId];
	}

    @AuraEnabled 
    public static Object SearchABR(Integer requestId, String abn, String name, String state, string zip) {
    	//try {
	        if (abn != null) 
	            return SearchABRByABN(requestId, abn);
	        else if (name != null) 
	            return SearchABRByName(requestId, name, state, zip);
	        else throw new ABNException('Invalid Request');
	    //} catch(Exception e) {
	    //	throw new AuraHandledException('Something went wrong, might be an issue with the ABN Service!');
	    //}
    }
        
    private static Object SearchABRByABN(Integer requestId, String abn) {
        if (setting == null) GetSettings();
        abn = abn.replace(' ', '');

        String 
            webApp = 'SearchByABNv201205',
            url = Endpoint + '/abrxmlsearch/AbrXmlSearch.asmx/' + webApp 
                + '?searchString=' + abn.replace(' ', '+')
                + '&includeHistoricalDetails=N'
                + '&authenticationGuid=' + setting.ABNToken__c,        
            body = ExecuteWebRequest(url, setting.ABNToken__c),
            result = ParseResponse(body, new List<String> { 'response' , 'businessEntity201205' });

        system.debug('body');
        system.debug(body);
        ABNUtils.ABRAbnSearchResult parsedResult = 
            (ABNUtils.ABRAbnSearchResult)JSON.deserialize(result, ABNUtils.ABRAbnSearchResult.class);

        system.debug('parsedResult:'); 
        system.debug(parsedResult);
        ABNUtils.AddLocalAccounts(parsedResult);

        //return JSON.serialize(parsedResult, true);
        return new Map<String, Object>{
            //'request' => search,
            'requestId' => requestId,
            'response' => parsedResult.businessEntity201205
        };
    }

    private static Object SearchABRByName(Integer requestId, String name, String state, string zip) {
        if (setting == null) GetSettings();        
        Set<String> states = new Set<String> { 'NSW', 'SA', 'ACT', 'VIC', 'WA', 'NT', 'QLD', 'TAS' };

        List<String> selectedStates = new List<String>();
        for (String iState :states) {
            boolean included = iState == state || String.isEmpty(state);
            selectedStates.add(iState + '=' + (included ? 'Y' : 'N'));
        }
        
        String 
            resultCount = String.valueOf(setting.MaxResults__c),
            webApp = 'ABRSearchByNameAdvancedSimpleProtocol2017',
            url = 
                'https://abr.business.gov.au/abrxmlsearch/AbrXmlSearch.asmx/' + webApp
            	+ '?name=' + name.replace(' ', '+')
                + '&postcode=' + (String.isEmpty(zip) ? '' : zip)
                + '&legalName=Y&tradingName=Y&businessName=Y&activeABNsOnly=Y&' + String.join(selectedStates, '&') 
                + '&authenticationGuid=' + setting.ABNToken__c
                + '&searchWidth=narrow&minimumScore=60'
                + '&maxSearchResults=' + String.valueOf(setting.MaxResults__c),
            body = ExecuteWebRequest(url, setting.ABNToken__c),
            result = ParseResponse(body, new List<String> { 'response' , 'searchResultsList' });  
        
        system.debug(body);
        system.debug(result);        
        ABNUtils.ABRNameSearchResult parsedResult = 
            (ABNUtils.ABRNameSearchResult)JSON.deserialize(result, ABNUtils.ABRNameSearchResult.class);

        system.debug(parsedResult);
        ABNUtils.AddLocalAccounts(parsedResult);
        
        return new Map<String, Object>{
            //'request' => search,
            'requestId' => requestId,
            'response' => parsedResult.searchResultsList
        };
    }

    private static String ExecuteWebRequest(String url, String token) {
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        Http http = new Http();

        // url that returns the XML in the response body
        req.setEndpoint(url);
        req.setMethod('GET');

        try {
            res = http.send(req); 
        } catch(System.CalloutException e) {
            System.debug('Callout error: ' + e);
            if (req != null) {
            	System.debug('request');           
            	System.debug(req.toString().replace(token, 'ABN_TOKEN'));
            }
            
            if (res != null) {
            	System.debug('response');
            	System.debug(res.toString().replace(token, 'ABN_TOKEN'));
            }

            throw new AuraHandledException('ABN Service (temporarily) unavailable: ' + e);
            //throw new ABNException('ABN Service (temporarily) unavailable: ' + e);
        }

        return res.getBody().replace(token, 'ABN_TOKEN');
    }

    private static string ParseResponse(string response, List<String> nodeNames) {
        string ns = 'http://abr.business.gov.au/ABRXMLSearch/';

        Dom.Document doc = new Dom.Document();
        doc.load(response);
        
        Dom.XmlNode node = doc.getRootElement();
        for (String childName :nodeNames)
            node = node.getChildElement(childName, ns);

        Map<String, Object> jsonParent = new Map<String, Object>();
        Map<String, Set<String>> arrayMap = new Map<String, Set<String>>{
            // for the Search on Name functionality
            'searchResultsList' => new Set<String> { 'searchResultsRecord' },

            // for the Search on ABN functionality
            'businessEntity201205' => new Set<String> { 'otherTradingName', 'businessName', 'ABN' }
		};
            
        ConvertXML(jsonParent, null, node, arrayMap);
        return JSON.serialize(jsonParent);
    }

    private static void ConvertXML(Map<string, Object> jsonParent, String parentName, Dom.XmlNode node,
    	Map<String, Set<String>> arrayMap) {
        if (node == null) return;

        string 
            nodeName = node.getName(),
            nodeText =  node.getText().trim();

        if (nodeText != '') {
            jsonParent.put(nodeName, nodeText);
            return;
        }

        Map<string, Object> jsonChild = new Map<string, Object>();        
        for (Integer index = 0; index < node.getAttributeCount(); index++) {
        	string 
                attribName = node.getAttributeKeyAt(index),
            	attribNs = node.getAttributeKeyNsAt(index);
            
            Object value = node.getAttribute(attribName, attribNs);             
            jsonChild.put(attribName, value);
        }
        
        List<Dom.XmlNode> children = node.getChildren();
        for (Dom.XmlNode child :children) 
            ConvertXML(jsonChild, nodeName, child, arrayMap);
                    
        if (nodeName != null) {
        	Boolean targetArray = false;

        	if (arrayMap.containsKey(parentName)) 
        		targetArray = arrayMap.get(parentName).contains(nodeName);

        	if (!targetArray && jsonParent.containsKey(nodeName)) {        		
        		// Getting second instance with same name
        		// This should not occur!!
        		// 		converting to array
        		Object existingNode = jsonParent.get(nodeName);
        		List<Object> nodeList = null;
        		if (!(existingNode instanceof List<Object>)) {	        			
        			system.debug(new object[] {
        				'WARNING: Possible inconsequent data structure!\r\n'+
        				'Add to arrayMap (parent => [child]): \r\n', +
                        '\''+ parentName +'\' => new Set<String> { \'' + nodeName +'\' }' });
        			nodeList = new List<Object> { existingNode };
        		} else nodeList = (List<Object>)existingNode;        		
        		jsonParent.put(nodeName, nodeList);
        		targetArray = true;
        	}
        	        	
        	if (targetArray) {
        		List<Object> nodeList = jsonParent.containsKey(nodeName)
        			? (List<Object>)jsonParent.get(nodeName)
        			: new List<Object>();
        		nodeList.add(jsonChild);
        		jsonParent.put(nodeName, nodeList);
        	} else if (jsonChild.size() > 0) 
                jsonParent.put(nodeName, jsonChild);
        } 
    }

    private static void GetSettings() {
        if (setting != null) return;
        List<ABN_Service_Settings__c> settings = [
            SELECT Id, ABNToken__c, MaxResults__c 
            FROM ABN_Service_Settings__c
            LIMIT 1];
        
        if (settings.size() == 0) 
            throw new ABNException('Error: Custom Setting missing!');
        
        setting = settings[0];
    }
    
    public class ABNException extends Exception {}
}
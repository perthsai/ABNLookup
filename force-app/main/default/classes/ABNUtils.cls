public class ABNUtils {
    
    /*@future
    public static void AsyncAbnUpdateParentAccounts(Set<Id> accountIds) {
        List<Account> accounts = [
            SELECT ID, ABN__c, ABN_Type__c, ABN_Validated__c, ABN_Parent_Account__c, ParentId, RecordTypeId
            FROM Account
            WHERE Id IN :accountIds];

        update AbnUpdateParentAccounts(accounts);
    }*/

    public static List<Account> AbnUpdateParentAccounts(List<Account> accounts) {
        Set<String> abnList = new Set<String>();
        Map<String, List<Account>> accByParent = new Map<String, List<Account>>();

        Map<String, ABNEntityResult> accDefinitionByAbn = new Map<String, ABNEntityResult>();
        
        for (Account acc :accounts) {        
           
                try {
                    system.debug(new object[] { 'Base64 Data', acc.ABN_Parent_Account__c });
                    String jsonData = EncodingUtil.base64Decode(acc.ABN_Parent_Account__c).tostring(); 
                    
                    system.debug(new object[] { 'JSON Data', jsonData });
                    ABNEntityResult parsedResult = 
                        (ABNEntityResult)JSON.deserialize(jsonData, ABNEntityResult.class);                    
                    
                    system.debug(new Object[] { 'Parsed Data', parsedResult });                    
                    String abn = parsedResult.AbnNumber;
                                        
                    if (!accByParent.containsKey(abn))
                        accByParent.put(abn, new List<Account>{ acc });
                    else accByParent.get(abn).add(acc);
                    accDefinitionByAbn.put(abn, parsedResult);
                } catch(Exception e) {
                    system.debug(new Object[] { 'Error: Skipping line', e });
                }
           
        } 
 
       
            List<Account> existingAccounts = [
                SELECT Id, Name, ABN__c
                FROM Account
                WHERE ABN__c IN :accByParent.keySet()
                  AND ABN_Type__c = 'Entity Name'];

            Map<String, Account> accByAbn = new Map<String, Account>();
            for (Account acc :existingAccounts)
                accByAbn.put(acc.Abn__c, acc);

            List<Account> newAccounts = new List<Account>();
            for (String abn :accByParent.keySet()) {
                if (!accByAbn.containsKey(abn)) {    
                    List<Account> children = accByParent.get(abn); 
                    Account newAcc = GenerateParentAccount(
                        accDefinitionByAbn.get(abn), 
                        children != null && children.size() > 0 
                        ? children[0].RecordTypeId 
                        : null);
                    if (newAcc != null) newAccounts.add(newAcc);
                }
            }

            if (newAccounts.size() > 0) insert newAccounts;
            for (Account acc :newAccounts)
                accByAbn.put(acc.Abn__c, acc);

            for (String abn :accByAbn.keySet()) {
                Account parent = accByAbn.get(abn);
                for (Account child :accByParent.get(abn)) {
                    child.ParentId = parent.Id;
                    child.ABN_Parent_Account__c = null;
                }
            }
       
        
        return accounts;
    }

    public static Account GenerateParentAccount(ABNEntityResult data, String parentRecordTypeId) {
        system.debug(new object[]{ 'Account Data', data});
        system.debug(data.AbnNumber);

        // Find user default record type
        Schema.DescribeSObjectResult dsr = Account.SObjectType.getDescribe();
        Schema.RecordTypeInfo targetRecordTypeId;
        for (Schema.RecordTypeInfo rti :dsr.getRecordTypeInfos()) {
            if ((rti.isDefaultRecordTypeMapping() && parentRecordTypeId == null)
                || rti.getRecordTypeId() == parentRecordTypeId) {
                targetRecordTypeId = rti;
            }
        }
        
        // Create new record with all default values
        SObjectType accountType = Account.sObjectType;
        Account result = (Account)accountType.newSObject(targetRecordTypeId.getRecordTypeId(), true);
        result.Name = data.mainName.name;
        result.ABN__c = data.AbnNumber;
        result.ABN_Type__c = 'Entity Name';
        result.ABN_Validated__c = true;
        //ShippingState = data.mainBusinessPhysicalAddress.stateCode;
        //ShippingPostcode = data.mainBusinessPhysicalAddress.postcode;
        result.ShippingCountry = 'Australia';
        //BillingState = data.mainBusinessPhysicalAddress.stateCode;
        //BillingPostcode = data.mainBusinessPhysicalAddress.postcode;
        result.BillingCountry = 'Australia';
        result.ASIC_ACN__c = data.ASICNumber != null ? data.ASICNumber : '';  
        result.Sync_Required__c = true;
        system.debug(new object[]{ 'New Account', result}); 
        
        return result;
    }

    public static void AddLocalAccounts(ABRNameSearchResult resultSet) {
        SearchResultsList result = resultSet.searchResultsList;
        if (result == null) return;
        Set<String> allABNs = new Set<String>();
        for (SearchResultsRecord rec :result.searchResultsRecord)
            allAbns.add(formatAbn(rec.ABN.identifierValue));
        
        List<Account> allAccounts = [
            SELECT Id, ABN__c, ABN_Type__c, Name
            FROM Account
            WHERE ABN__c IN :allAbns];
        
        //system.debug(new object[] { 'Related Acc', allAccounts });

        Map<String, Map<String, Map<String, Account>>> accByAbnByTypeByName = 
            new Map<String, Map<String, Map<String, Account>>>();
        for (Account acc :allAccounts) {
            if (!accByAbnByTypeByName.containsKey(acc.ABN__c)) 
                accByAbnByTypeByName.put(acc.ABN__c, new Map<String, Map<String, Account>>());
            
            Map<String, Map<String, Account>> accByTypeByName = accByAbnByTypeByName.get(acc.ABN__c);
            if (!accByTypeByName.containsKey(acc.ABN_Type__c))
                accByTypeByName.put(acc.ABN_Type__c, new Map<String,Account>());
            
            Map<String, Account> accByName = accByTypeByName.get(acc.ABN_Type__c);
            accByName.put(acc.Name.toLowerCase(), acc);            
        }

        system.debug(new object[] { 'Acc Map', accByAbnByTypeByName });

        for (SearchResultsRecord rec :result.searchResultsRecord)
            if (accByAbnByTypeByName.containsKey(rec.ABN.formatted)) {
                Map<String,Map<String,Account>> accByType = accByAbnByTypeByName.get(rec.ABN.formatted);
                //system.debug(new object[] { 'Found ABN:', rec.ABN.formatted, 'ABNType:', rec.ABNType });
                if (accByType.containsKey(rec.ABNType)) {
                    Map<String, Account> accountByName = accByType.get(rec.ABNType);
                    //system.debug(new object[] { 'Found ABN Type:', rec.ABNType, 'Names', accountByName });
                    ABREntity entity = null;

                    switch on rec.ABNType {
                        when 'Entity Name', 'Main Name' {
                            entity = rec.mainName;
                        } when 'Business Name' {
                            entity = rec.businessName;
                        } when 'Other Name' { 
                            entity = rec.otherName;
                        } when 'Trading Name' {
                            entity = rec.tradingName;
                        }
                    }

                    system.debug(new object[] { 'Entity', entity });

                    if (entity != null) 
                        if (accountByName.containsKey(entity.organisationName.toLowerCase())) {
                            Account acc = accountByName.get(entity.organisationName.toLowerCase());
                            entity.relatedAccount = new Account(Id = acc.Id, Name = acc.Name);
                        }

                    system.debug(new object[] { 'Entity', entity });
                }
            }              
    }

    public static void AddLocalAccounts(ABRAbnSearchResult resultSet) {
        ABNEntityResult result = resultSet.businessEntity201205;
        string abn = formatAbn(resultSet.businessEntity201205.ABN[0].formatted);
        Set<String> abnNames = new Set<String>();

        system.debug(new object[] {'AddLocal Accounts: resultSet', resultSet });
        if (result.mainName == null) {
            if (result.mainTradingName != null) result.mainName = result.mainTradingName;
            // else if ()
        }
                

        Map<String, List<ABREntity>> entitiesByAbnType = new Map<String, List<ABREntity>>{
            'Main Name' => new List<ABREntity> { result.mainName },
            'Business Name' => result.businessName,
            'Trading Name' => result.otherTradingName
        };

        for (List<ABREntity> entities :entitiesByAbnType.values()) 
            if (entities != null)
                for (ABREntity entity :entities)
                    if (entity == null) system.debug(new object[] { null , entities });
                    else abnNames.add(entity.organisationName);            

        List<Account> accounts = [
            SELECT Id, Name, ABN__c, ABN_Type__c
            FROM Account 
            WHERE ABN__c = :abn 
              AND Name IN :abnNames
              AND ABN_Type__c IN ('Main Name','Trading Name','Business Name')];

        Map<String, Map<String,Account>> accountByNameByType = new Map<String, Map<String,Account>>();
        for (Account acc :accounts) {
            if (!accountByNameByType.containsKey(acc.Name.toLowerCase())) 
                accountByNameByType.put(acc.Name.toLowerCase(), new Map<String, Account>());

            Map<String,Account> accountByType = accountByNameByType.get(acc.Name.toLowerCase());
            accountByType.put(acc.ABN_Type__c, acc);
        }

        system.debug(new object[] { 'Names', accountByNameByType });

        for (String abnType :entitiesByAbnType.keySet()) {
            List<ABREntity> abnEntities = entitiesByAbnType.get(abnType);
            if (abnEntities != null)
                for (ABREntity entity :abnEntities) 
                    if (entity != null && accountByNameByType.containsKey(entity.organisationName.toLowerCase())) {
                        Map<String,Account> accountByType = accountByNameByType.get(entity.organisationName.toLowerCase()); 
                        if (accountByType.containsKey(abnType)) {
                            Account acc = accountByType.get(abnType);
                            entity.relatedAccount = new Account(Id = acc.Id, Name = acc.Name, ABN_Type__c = abnType);
                        }
                    }            
        }
    }

    public static String formatAbn(string abn) {
        String pIn = abn.replace(' ', '');
        if (pIn.length() == 11)
            return 
                pIn.substring(0, 2) + ' ' +
                pIn.substring(2, 5) + ' ' +
                pIn.substring(5, 8) + ' ' +
                pIn.substring(8, 11);        

        return abn;
    }   

    public static String Capitalize(String input) {
        List<String> elements = input.split(' ');
        String result = '';
        for (String word :elements) {
            result += word.substring(0,1).toUpperCase();
            if (word.length() > 1) 
                result += word.substring(1, word.length()).toLowerCase();

            result += ' ';
        }

        return result.trim();
    }

    public class ABRAbnSearchResult {
        @AuraEnabled 
        public ABNEntityResult businessEntity201205  {get;set;}
    }

    public class ABNEntityResult {
        @AuraEnabled 
        public List<ABREntity> businessName {get;set;}
        @AuraEnabled 
        public List<ABREntity> otherTradingName {get;set;}
        @AuraEnabled 
        public ABREntity mainName {get;set;}
        @AuraEnabled 
        public ABREntity mainTradingName {get;set;}
        @AuraEnabled 
        public PhysicalAddress mainBusinessPhysicalAddress {get;set;}
        @AuraEnabled 
        public string ASICNumber {get;set;}
        @AuraEnabled
        public ABNRecord[] ABN {get;set;}
        @AuraEnabled 
        public string AbnNumber {
            get{
                return (this.ABN != null) 
                    ? this.ABN[0].formatted
                    : null;
            }
        }

        @AuraEnabled 
        public List<SearchResultsRecord> searchResultsRecord {
            get{
                List<SearchResultsRecord> result = new List<SearchResultsRecord>();
                Map<String,List<ABREntity>> entities = new Map<String,List<ABREntity>> {
                    'Main Name' => new List<ABREntity> { mainName }
                };
                
                if (businessName != null)
                    entities.put('Business Name', businessName);
                if (otherTradingName != null)
                    entities.put('Trading Name', otherTradingName);

                for (string abnType :entities.keySet()) {
                    if (entities.containsKey(abnType))
                        for (ABREntity entity :entities.get(abnType)) {
                            SearchResultsRecord item = new SearchResultsRecord();
                            
                            if (abnType == 'Main Name') {
                                item.mainName = entity;
                                item.ASICNumber = ASICNumber;
                            } 
                            else if (abnType == 'Business Name') item.businessName = entity;
                            else if (abnType == 'Trading Name') item.otherTradingName = entity;
                            else continue;

                            item.ABN = ABN[0];
                            item.mainBusinessPhysicalAddress = mainBusinessPhysicalAddress; 
                            result.add(item);                       
                        }
                }

                return result;
            }
        }
    }

    public class ABRNameSearchResult {
        @AuraEnabled 
        public SearchResultsList searchResultsList {get;set;}
    }

    public class SearchResultsList {
        @AuraEnabled 
        public List<SearchResultsRecord> searchResultsRecord {get;set;}
        @AuraEnabled 
        public string exceedsMaximum {get;set;}
        @AuraEnabled 
        public string numberOfRecords {get;set;}
    }

    public class SearchResultsRecord {
        public PhysicalAddress mainBusinessPhysicalAddress {get;set;}
        @AuraEnabled
        public ABNRecord ABN {get;set;} 
        @AuraEnabled
        public ABREntity mainName {get;set;}
        @AuraEnabled
        public ABREntity legalName {get;set;}        
        @AuraEnabled
        public ABREntity mainTradingName {get;set;}
        @AuraEnabled
        public ABREntity businessName {get;set;}
        @AuraEnabled
        public ABREntity tradingName {get;set;}
        @AuraEnabled
        public ABREntity otherName {get;set;}
        @AuraEnabled
        public ABREntity otherTradingName {get;set;}     
        
        @AuraEnabled 
        public string ASICNumber {get;set;}
        @AuraEnabled 
        public string AbnNumber {
            get{
                return this.ABN.formatted;
            }
        }
        @AuraEnabled 
        public ABREntity result {
            get{
                if (mainName != null) return mainName;
                else if (businessName != null) return businessName;
                else if (tradingName != null) return tradingName;
                else if (mainTradingName != null) return mainTradingName;
                else if (otherName != null) return otherName;
                else if (otherTradingName != null) return otherTradingName;
                else if (legalName != null) return legalName;

                else return null;
            }
        }
        @AuraEnabled 
        public PhysicalAddress address {
            get{
                return mainBusinessPhysicalAddress;
            }
        }
        @AuraEnabled 
        public String ABNType { 
            get {
                if (mainName != null) return 'Entity Name';
                else if (businessName != null) return 'Business Name';
                else if (tradingName != null) return 'Trading Name';
                else if (mainTradingName != null) return 'Trading Name';
                else if (otherTradingName != null) return 'Trading Name';
                else if (otherName != null || legalName != null) return 'Other Name';
                else return null;
            }
        }
    }

    public class ABNRecord {
        public string identifierStatus {get;set;}
        @AuraEnabled
        public string identifierValue {get;set;}
        public string isCurrentIndicator {get;set;}
        public string replacedFrom {get;set;}
        public string formatted {
            get {
                return formatAbn(identifierValue);
            }
        }
    }

    public class PhysicalAddress {
        public string isCurrentIndicator {get;set;}
        @AuraEnabled 
        public string postcode {get;set;}
        @AuraEnabled 
        public string stateCode {get;set;}
        public string effectiveFrom {get;set;}
        public string effectiveTo {get;set;}
        @AuraEnabled 
        public string country {
            get {
                return 'Australia';
            }
        }
    }

    public class ABREntity {
        public string isCurrentIndicator {get;set;}
        @AuraEnabled 
        public string score {get;set;}
        @AuraEnabled
        public string organisationName {get;set;}
        @AuraEnabled
        public string effectiveFrom {get;set;}

        public string fullName {
            set{
                if (value != null)
                    this.organisationName = value;
            }
        }
        
        public string familyName {
            set{
                if (value != null)
                    this.organisationName = value;
            }
        }
        
        @AuraEnabled 
        public Account relatedAccount {get;set;}
        @AuraEnabled 
        public string name {
            get{
                return organisationName != null ? Capitalize(organisationName) : null;
            }
        }
    }    
}
public class ABNUtilsmini {
public class ABRAbnSearchResult {
        @AuraEnabled 
        public ABNEntityResult businessEntity201205  {get;set;}
    }
public class ABRNameSearchResult {
        @AuraEnabled 
        public SearchResultsList searchResultsList {get;set;}
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
}
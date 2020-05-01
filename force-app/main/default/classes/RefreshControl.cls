public class RefreshControl {
public Blob csvFileBody{get;set;}
public string csvAsString{get;set;}
public String[] csvFileLines{get;set;}
public List<account> acclist{get;set;}
    @AuraEnabled
  public static void  getData1(ID accountId){
      
     ID acctID = accountId;
     
try {
    // Update Contact.
    
     Contact con = new Contact(
        FirstName='Joe',
        LastName='Smith',
        Phone='4155551212',
        AccountId=acctID);
    insert con;
} catch(DmlException e) {
    System.debug('An unexpected error has occurred: ' + e.getMessage());
   }

  }
  
}
public class LookupByUrlParamController {

    String accountName;
    String accountNumber;
    String phone;
    
    public LookupByUrlParamController () { }

    public String redirectToAccount() {
        
        Account account;
        
        Map<String,String> params = ApexPages.currentPage().getParameters();
        if(params.size() > 0) {
            accountName = params.get('account_name');
            accountNumber = params.get('account_number');
            phone = params.get('phone');    
        }
        
        if(accountName != null) {
            account = [select ID from Account where name = :accountName limit 1];   
        } else if(accountNumber != null) {
            account = [select ID from Account where AccountNumber = :accountNumber limit 1];   
        } else if(phone != null) {
            account = [select ID from Account where phone = :phone limit 1]; 
        } 
        
        String accountUrl;
        if(account != null) {
            accountUrl = '/' + account.Id;
        } else {
            accountUrl = '/';
        }
        
        return accountUrl;
    }   

    public static testMethod void testLookupByUrlParamAccount() {
        LookupByUrlParamController controller = new LookupByUrlParamController();
        controller.accountName = 'Mid size StarCard';
        String redirectUrl = controller.redirectToAccount();
        System.assertEquals(redirectUrl,'/0012000000lgm3YAAQ');
    }
    
    public static testMethod void testLookupByUrlParamPhone() {
        LookupByUrlParamController controller = new LookupByUrlParamController();
        controller.phone = '1234';
        String redirectUrl = controller.redirectToAccount();
        System.assertEquals(redirectUrl,'/0012000000lgm3YAAQ'); 
    }
    
    public static testMethod void testLookupByUrlParamAccountNumber() {    
        LookupByUrlParamController controller = new LookupByUrlParamController();
        String redirectUrl = controller.redirectToAccount();
        System.assertEquals(redirectUrl,'/');   
    }
    
    public static testMethod void testLookupByUrlParam() {
        LookupByUrlParamController controller = new LookupByUrlParamController();
        String redirectUrl = controller.redirectToAccount();
        System.assertEquals(redirectUrl, '/');
    }
    
}
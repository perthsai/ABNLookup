public class ext_CaseEditRedirect {
    
    public ID CaseId {get;set;}

    public ext_CaseEditRedirect(ApexPages.StandardController controller) {
        CaseId = controller.getRecord().id;
    }
    
    public PageReference Redirect() {
        if(CaseId != NULL) {
            Case cs = [SELECT InEditMode__c FROM Case WHERE id = :CaseId];
            cs.InEditMode__c = true;
            
            try {
            
            update cs;
            }
            catch(System.Exception ex) {
            
            }
            PageReference Pg = new PageReference('/' + CaseId + '/e?retURL=' + CaseId);
        
            return Pg;
        }
        else {
            PageReference Pg = new PageReference('/500/o');
            return Pg;
        }
    }
}
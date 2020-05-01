global class CaseAgeCalculation implements Database.Batchable<sObject>
{
    global final String Query;

    global CaseAgeCalculation(){
        // Batch Constructor
        Query = 'SELECT InEditMode__c, businesshoursId, LastViewedDate, LastModifiedDate, Case_Age_In_Lapsed_Minutes__c, isClosed, CreatedDate, ClosedDate, Case_Age_In_Business_Hours__c FROM Case WHERE isClosed = false AND InEditMode__c = false';
    }
   
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
   
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Case> scope){
        // Logic to be Executed batch wise      
        for(Case s : scope){
            Double CaseAge = BusinessHours.diff(s.BusinessHoursId, s.CreatedDate, System.now())/3600000.0;
            s.Case_Age_In_Business_Hours__c = CaseAge.round();
            s.Case_Age_In_Lapsed_Minutes__c = (BusinessHours.diff(s.BusinessHoursId, s.CreatedDate, System.now())/60000.0).round();
        }
        
        update scope;
    }
   
    global void finish(Database.BatchableContext BC){
    }   
}
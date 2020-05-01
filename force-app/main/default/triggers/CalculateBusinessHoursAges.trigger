trigger CalculateBusinessHoursAges on Case (before insert, before update) {
    if (Trigger.isInsert) {
        
        String CaseAgeCalendar = Label.CaseAgeCalendar;
        List<BusinessHours> defaultHours = new List<BusinessHours>();
        
        try {
            //Get the business hours as per given caltex business hours calendar
            defaultHours = [select Id from BusinessHours where id= :CaseAgeCalendar];
            
            if(defaultHours.size() < 1) {
                //Get the default business hours (we might need it)
                defaultHours = [select Id from BusinessHours where IsDefault=true];
            }
        }
        catch(System.Exception ex) {
            //Get the default business hours (we might need it)
            defaultHours = [select Id from BusinessHours where IsDefault=true];
        }
        
        for (Case updatedCase:System.Trigger.new) {
            updatedCase.businesshoursId = defaultHours[0].id;
        }
    } 
    else {
        for (Case updatedCase : System.Trigger.new) {
            if((updatedCase.isClosed == true || updatedCase.Status == 'Closed') && (Trigger.OldMap.get(updatedCase.id).isClosed != true || Trigger.OldMap.get(updatedCase.id).Status != 'Closed')) {
                Double CaseAgeInHours;
                CaseAgeInHours = BusinessHours.diff(updatedCase.BusinessHoursId, updatedCase.CreatedDate, system.datetime.now())/3600000.0;
                updatedCase.Case_Age_In_Business_Hours__c = CaseAgeInHours.round();
                updatedCase.Case_Age_In_Lapsed_Minutes__c = (BusinessHours.diff(updatedCase.BusinessHoursId, updatedCase.CreatedDate, System.datetime.now())/60000.0).round();
            }
        }
    }
}
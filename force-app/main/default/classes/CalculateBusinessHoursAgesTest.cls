@isTest
public class CalculateBusinessHoursAgesTest {
    
    public static String CRON_EXP = '0 0 0 15 12 ? 2022';
    public static testMethod void testBusinessHoursBucketer() {
        
        Test.startTest();
        
        Case c = new Case();
        c.Status = 'New';
        insert c;

        CaseAgeCalculation BatchableClass = new CaseAgeCalculation();

        Database.executeBatch(BatchableClass);
        
        
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new CaseAgescheduledBatchable());
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
       // Verify the next time the job will run
       System.assertEquals('2022-12-15 00:00:00', String.valueOf(ct.NextFireTime));
       
       PageReference Pg = Page.vfp_CaseEditRedirect;
       Test.setCurrentPage(Pg);
       
       ApexPages.StandardController sc1 = new ApexPages.StandardController(new Case());
       ext_CaseEditRedirect redirectcontroller1 = new ext_CaseEditRedirect(sc1);
       Redirectcontroller1.Redirect();
       
       ApexPages.CurrentPage().getParameters().put('id',c.id);
       
       ApexPages.StandardController sc = new ApexPages.StandardController(c);
       ext_CaseEditRedirect redirectcontroller = new ext_CaseEditRedirect(sc);
       
       Redirectcontroller.Redirect();
       
       C.Status = 'Closed';
       Update c;
       
       Test.StopTest();
    }
}
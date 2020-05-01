Trigger UpdateDateToEnd on Task (before insert, before update)
{
   for(Task t: Trigger.new)
   {
     if(t.ActivityDate != null)
     {
       t.DUE_DATE_REF__c = t.ActivityDate;
     }
   }
   
}
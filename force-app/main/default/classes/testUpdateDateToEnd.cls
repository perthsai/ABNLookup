public class testUpdateDateToEnd
{
    static testMethod void testTaskTrigger()
    {
      Task t = new Task(ActivityDate = date.today(), Subject = 'test', Priority = 'Normal', Status = 'Not Started');
      insert t;
    }
}
global class CaseAgescheduledBatchable implements Schedulable {
    global void execute(SchedulableContext sc) {
        // We now call the batch class to be scheduled
        CaseAgeCalculation CaseAgeCalculationInstance = new CaseAgeCalculation(); 
        
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(CaseAgeCalculationInstance ,100);
    }
}


// Cron EXP for hourly schedule
// System.schedule('Case Age Schedule', '0 0 * * * ?', new CaseAgescheduledBatchable());
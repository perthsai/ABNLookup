trigger ProcessDivestmentRelinquishments on Divestment_Relinquishment__c (after insert, after update) {

	if (trigger.isInsert || trigger.isUpdate)
	{
			DivestmentTriggerHandler.processDivestments(trigger.new);
	}

}
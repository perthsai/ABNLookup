public with sharing class DivestmentTriggerHandler {
	
	public static void processDivestments(Divestment_Relinquishment__c[] divestments)
	{
		Set<Id> setDivestmentIds = new Set<Id>();
		for(Divestment_Relinquishment__c divestment:divestments)
		{
			if (divestment.Status__c == 'Completed')
				setDivestmentIds.add(divestment.Id);
		}
		
		if(setDivestmentIds.size()>0)
		{
			List<Provisioning__c> listProvisionings = [select Id, Provision_required_Y_N__c
													from Provisioning__c
													where Divestment_Relinquishment__c in :setDivestmentIds];			
			if (!listProvisionings.isEmpty()) 
			{
				for(Provisioning__c provisioning:listProvisionings)
					{
						provisioning.Provision_required_Y_N__c = 'Yes';
					}
				Update listProvisionings;
			}
		}
	}
}
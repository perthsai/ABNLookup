trigger HSSEModelUpdate on Provisioning__c (before insert, before update) {
    
    for(Provisioning__c PROV1 : trigger.new){
            PROV1.HSSE_Model__c = 'a0N20000000nR8m';
    }
}
trigger recordTypeCheck on Account (before insert,before update,after insert,after update) {
if (Trigger.isExecuting && Trigger.isBefore) {
      System.debug('Trigger Fired');
    } else {
        System.debug('Trigger Fired after');
    }
 
  String RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('B2B_Commercial').getRecordTypeId();
  System.debug(RecordTypeId);
 for(Account obj:Trigger.new) {
  
   if(obj.RecordTypeId ==  RecordTypeId){
      String Recordname='B2B_Commercial';
      System.debug(Recordname);
      ABNDialogController.RecordNamePicked(Recordname); 
   }
 } 
 
}
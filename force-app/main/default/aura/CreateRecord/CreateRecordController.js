({
   createRecord: function(component, event, helper) {
      var createRecordEvent = $A.get("e.force:createRecord");
      createRecordEvent.setParams({
         "entityApiName": "Account" // using account standard object for this sample
      });
      createRecordEvent.fire();
   }
})
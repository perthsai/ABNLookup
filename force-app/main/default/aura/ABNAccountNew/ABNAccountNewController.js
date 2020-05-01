({
	onInit : function(component, event, helper) {
		var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        component.set("v.selectedRecordTypeId", recordTypeId);
        
        var remoteMethod = component.get("c.SelecteRecordType")
        remoteMethod.setParams({ 'recordTypeid': recordTypeId });
        remoteMethod.setCallback(this, function(response) { 
        
          if (response.getState() == "SUCCESS")
            {
                var resBody = response.getReturnValue();
                component.set('v.selectedRecordTypeName',resBody);
                var recordname= component.get('v.selectedRecordTypeName');  
                recordname= recordname.substr(0,3);
                 if( recordname != 'B2B')
                    {
                     var createRecordEvent = $A.get("e.force:createRecord");
            		 var RecTypeID  = response.getReturnValue();
            		 createRecordEvent.setParams({
               			"entityApiName": 'Account',
               			 "recordTypeId": recordTypeId
                     });
                      createRecordEvent.fire();
                    }   
                    else
                    { 
                     component.set('v.OpenABN',true); 
                    }    
            }
          else
           { 
             var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
               "title": "Error!",
               "message": "Please contact your administrator"
            });
            toastEvent.fire();
          }  
         });
         	$A.enqueueAction(remoteMethod);     
      
       
	}
})
({
	getData: function(component) {
        

	 var action = component.get("c.getData1");
        action.setParams({
           "accountId": component.get("v.recordId") //how record id of account 
        }); 
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                
            }	 
	  });
     $A.enqueueAction(action);
    },
})
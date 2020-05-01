({
	onInit : function(component, event, helper) {
	  helper.getData(component);
        $A.get('e.force:refreshView').fire();
        window.setTimeout(
        $A.getCallback(function() {
            $A.get("e.force:closeQuickAction").fire();

        }),100
     );
     var toastReference = $A.get("e.force:showToast");
                 toastReference.setParams({
                        "type" : "Success",
                        "title" : "Success",
                        "message" : "Data loaded"
                       
                    });
                    toastReference.fire();
        }
})
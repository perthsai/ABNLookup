({
	searchResultsChange : function(component, event, helper) {
		var data = component.get('v.dataRows'),
			container = [];

		for (var item in data) 
			//if (data[item].Abn) container[data[item].Abn] = data[item];
			container.push(data[item]);
        
			//if (data[item].Abn) container[data[item].Abn] = data[item];
    
		component.set('v.data', container);		
 	},

	createNewAccount : function(component, event, helper) {
		console.log(['Create new Account']);
        var compEvents = component.getEvent('ABNResultClicked'),
            data = component.get('v.data'),
			abnId = event.srcElement ? event.srcElement.id : event.target.id, 
			selectedABNAccount = data[abnId];

        compEvents.setParams( {  
            name: 'clicked',
            record: JSON.parse(JSON.stringify(selectedABNAccount))
        });
	
        console.log(['SearchResult:Clicked', compEvents.getParams()]);
        compEvents.fire();          
	},

	openExistingAccount : function(component, event, helper) {
		console.log(['Open existing Account']);
	    var navigateEvent = $A.get("e.force:navigateToSObject"),
	    	recId = event.srcElement ? event.srcElement.id : event.target.id;

	    if (!navigateEvent) {
	    	console.log('Cannot navigate to record');
			return;
		}

	    navigateEvent.setParams({
	      "recordId": recId,
	      "slideDevName": "detail"
	    });
	    navigateEvent.fire();
	}
})
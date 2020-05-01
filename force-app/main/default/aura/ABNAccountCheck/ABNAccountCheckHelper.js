({
	CreateNewAccount : function(component, helper, abnRec,recordTypeId) {
        var createAcountEvent = $A.get("e.force:createRecord");

		if (!createAcountEvent || !abnRec) {
			console.log('Cannot create new record in app modus');
			return;
		}

		var abnData = component.get('v.cmpData.results'),
			data = JSON.parse(JSON.stringify(abnData));
		
		delete data.businessName;
		delete data.otherTradingName;
		delete data.searchResultsRecord;

		var abnParent = JSON.stringify(data);

		createAcountEvent.setParams({
		     "entityApiName": "Account",
             'recordTypeId':recordTypeId,
		      "defaultFieldValues": {
               
				'ABN__c' : helper.formatABN(abnRec.AbnNumber),
				'ABN_Type__c': abnRec.ABNType,
		        'Name' : helper.toTitleCase(abnRec.result.name),
		        //'ShippingState' : abnRec.State,		         
		        //'ShippingPostalCode' : abnRec.Postcode,
		        'ShippingCountry' : abnRec.address.country,
		        //'BillingState' : abnRec.State,
		        //'BillingPostalCode' : abnRec.Postcode,
				'BillingCountry' : abnRec.address.country,
				//'ABN_Parent_Account__c' : btoa(abnParent),
				'ABN_Validated__c': true, 
                 'RecordTypeId':recordTypeId
		    } 
             
		});
		
		component.set('v.visible', false);
		createAcountEvent.fire();
	}, 
	
	updateAccount : function(component, helper, account) {
		var remoteMethod = component.get('c.UpdateAccount');
        remoteMethod.setParams({ 'account': account });
        remoteMethod.setCallback(this, function(response) { 
            if (response.getState() == "SUCCESS") { 
            	component.set('v.errData', null);
				component.set('v.visible', false);
				$A.get('e.force:refreshView').fire();
            } else if (response.getState() == "ERROR") {
            	var error = response.getError()[0],
            		errMessage = helper.parseErrorMessage(error);            	

            	var errData = { messageType: 'error', message: errMessage, allowClose: false };
				
				component.set('v.errData', errData);
            }
        });
        
        $A.enqueueAction(remoteMethod);  
	},

	parseErrorMessage : function(error) {
		var pageErrors = error ? error.pageErrors : null,
    		fieldErrors = error ? error.fieldErrors : null,

    		errMessage = error.message ? error.message + '\r\n' : '';

    	if (pageErrors) {
    		for (var item in pageErrors)
    			errMessage += /*pageErrors[item].statusCode + ': ' +*/ pageErrors[item].message + '\r\n';
    	} 

    	if (fieldErrors) {
    		for (var field in fieldErrors) {
    			errMessage += field + ': \r\n';
    			for (var item in fieldErrors[field])
    				errMessage += /*fieldErrors[field][item].statusCode + ': ' +*/ fieldErrors[field][item].message + '\r\n';
    		}
    	}

    	if (!errMessage) errMessage = error ? JSON.stringify(error) : 'Unkown error';
    	return errMessage;
	},
    
    convertState : function(inputVal) {
        var states = {
            'ACT': 'Australian Capital Territory',
            'NSW': 'New South Wales',
            'NT': 'Northern Territory',
            'QLD': 'Queensland',
            'SA': 'South Australia',
            'TAS': 'Tasmania',
            'VIC': 'Victoria',
            'WA': 'Western Australia'
        };
        
        return states[inputVal];
	},
    
    formatABN : function(abnNumber) {
    	 var x = abnNumber.replace(' ', ''); 
        /*if (x.length == 9)
    		return x.substr(0,3) + ' ' + x.substr(3,3) + ' ' + x.substr(6,3)
    	else if (x.length == 11)
    		return x.substr(0,2) + ' ' + x.substr(2,3) + ' ' + x.substr(5,3) + ' ' + x.substr(8,3);*/
    
       if (x.length >= 5)
    		return x.replace(/\s/g,'');
        return abnNumber;
    }, 
    
    toTitleCase : function(str) {
		return str.toLowerCase().replace(/^(.)|\s(.)/g, ($1) => $1.toUpperCase());
	},

	NextRequestId : function(component) {
		var res = component.get('v.cmpData.requestId') + 1;
		component.set('v.cmpData.requestId', res);

		return res;
	}
})
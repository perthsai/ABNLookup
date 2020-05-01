/*
	Author: 	Paul Perry
	
	Description: 
		LC for ABN Lookup		
	
	Test Class: N.A.
	Pages: N.A.
	History: Initial creation 2018/02/24

*/

({
	Search : function(component, searchTxt, helper) {
		var tool = component.get('v._tools');

		if (!searchTxt || searchTxt.length <= 2) {
			component.set('v.searchStr', null);		
			component.set('v.searchResults', []);	
			
			// Hide progress spinner
			var cmpSpinner = component.find('ABNSearchProgress');
			$A.util.addClass(cmpSpinner, 'slds-hide');

			// prevent displaying results from prior request:
			helper.NextRequestId(component);
		} else {
			// verify if input is valid ABN
			var abn = searchTxt.split(' ').join('');
			if ((abn.length == 11 && /\d/.test(abn) && helper.IsValidABN(abn))
				|| (abn.length == 9 && /\d/.test(abn))) {
				component.set('v.searchStr', abn);
				helper.SearchAbn(component, helper, abn);
				var cmpSpinner = component.find('ABNSearchProgress');
				$A.util.removeClass(cmpSpinner, 'slds-hide');
				return;
			}
		}

		var cmpSpinner = component.find('ABNSearchProgress');
		$A.util.removeClass(cmpSpinner, 'slds-hide');		
		helper.SearchABNByString(component, helper, searchTxt);		
	},

	SearchABNByString : function(component, helper, searchTxt) {
		var remoteMethod = component.get('c.SearchABR'),
        	cmpSpinner = component.find('ABNSearchProgress'),
        	postcode = component.get('v.postcode'),
        	state = component.get('v.state'),
        	advancedSearch = component.get('v.advancedMode');

        //if (advancedSearch) remoteMethod = component.get("c.SearchAdv");
        //else remoteMethod = component.get("c.Search");
        
		remoteMethod.setParams({
			//"search": searchTxt,
			"name": searchTxt,
			"requestId" : helper.NextRequestId(component),
			"zip" : advancedSearch 
				? (postcode && postcode.length == 4 ? postcode : '')
				: '',
			"state" : advancedSearch 
				? (state ? state : '')
				: ''
		});

		component.set('v.searchStr', searchTxt);

		console.log(['Request Search', remoteMethod.getParams()]);
		remoteMethod.setCallback(this, function(response) {
			if (response.getState() == "ERROR")
				helper.IncomingError(component, response, helper);
			else if (response.getState() == "INCOMPLETE") 
				helper.IncompleteRequest(component, response, helper);
			else if (response.getState() == "SUCCESS") 
	        	helper.IncomingResults(component, response, helper);
	    });
      	$A.enqueueAction(remoteMethod); 
	},

	SearchAbn : function(component, helper, abn) {
		var //remoteMethod = component.get("c.SearchAbn"),
			remoteMethod = component.get('c.SearchABR'),
        	cmpSpinner = component.find('ABNSearchProgress');
        
		remoteMethod.setParams({
			"abn": abn,
			"requestId" : helper.NextRequestId(component)			
		});

		console.log(['Request Search ABN', remoteMethod.getParams()]);
		remoteMethod.setCallback(this, function(response) {
			if (response.getState() == "ERROR")
				helper.IncomingError(component, response, helper);
			else if (response.getState() == "INCOMPLETE") 
				helper.IncompleteRequest(component, response, helper);
			else if (response.getState() == "SUCCESS") 
	        	helper.IncomingResults(component, response, helper);
	    });
      	$A.enqueueAction(remoteMethod); 
	},

	IncomingResults : function(component, response, helper) { 
		var cmpSpinner = component.find('ABNSearchProgress');
		console.log(['Request Search OK', response.getReturnValue()]);
    	var resBody = response.getReturnValue();
    	if (resBody.requestId === component.get('v._tools.requestId')) {			
    		console.log(['Response:', resBody.response]);
            component.set('v.searchResults', resBody.response);	
             if(component.get('v.advancedSearchbyABNName')){
              var data = component.get('v.searchResults'), 
			  container = [],
              refinecontainer=[],
              inputABN=component.get('v.searchStr');
                for (var item in data.searchResultsRecord){     
		  	      //if (data[item].Abn) container[data[item].Abn] = data[item];
			     container.push(data.searchResultsRecord[item].result.name);
                  if(container[item].toUpperCase() === inputABN.toUpperCase())
                  {
                   refinecontainer.push(data.searchResultsRecord[item]);
                  } 
                }
                  console.log('The container value' ,container)   
    		      console.log('The refine containter' ,refinecontainer);
                  component.set('v.searchResults',refinecontainer); 
                  console.log('The value set in serachResults is' ,component.get('v.searchResults'));
             } 
             $A.util.addClass(cmpSpinner, 'slds-hide');	 
    	}
	},

	IncompleteRequest : function(component, response, helper) {
		var cmpSpinner = component.find('ABNSearchProgress'),
			toastEvent = $A.get("e.force:showToast");
		
		$A.util.addClass(cmpSpinner, 'slds-hide');			

        toastEvent.setParams({
        	mode: 'sticky',
            title: "Error",
            message: "Cannot complete search request. Please check your connection!"
        });

        toastEvent.fire();
	},

	IncomingError : function(component, response, helper) {
		var cmpSpinner = component.find('ABNSearchProgress'),
			toastEvent = $A.get("e.force:showToast"),

			errorMsg = helper.ParseErrorMessage(response.getError()[0]);

		$A.util.addClass(cmpSpinner, 'slds-hide');	

        toastEvent.setParams({
        	mode: 'sticky',
            title: "Error",
            message: errorMsg// "Cannot complete search request. ABN-Service might be temporarily unavailable!"
        });

        toastEvent.fire();		

		console.log(['Request Search ERROR:', response.getError()[0].message, response]);
	},

	ParseErrorMessage : function(error) {
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

	CurrentRequestId : function(component) {
		return component.get('v._tools.requestId');
	},

	NextRequestId : function(component) {
		var res = component.get('v._tools.requestId') + 1;
		component.set('v._tools.requestId', res);

		return res;
	},

	GetStateFromZip : function(zip) {
		var state = null;

		if (!zip || zip.length != 4) return null;

		// New South Wales => NSW
		if ((zip >= '1000' && zip <= '1999') //(LVRs and PO Boxes only)
			|| (zip >= '2000' && zip <= '2599')
			|| (zip >= '2619' && zip <= '2898')
			|| (zip >= '2921' && zip <= '2999')) 
			state = 'NSW';
		// Australian Capital Territory	=> ACT
		else if ((zip >= '0200' && zip <= '0299') // (LVRs and PO Boxes only)
				 || (zip >= '2600' && zip <='2618')
				 || (zip >= '2900' && zip <='2920'))
			state = 'ACT';
		// Victoria	=> VIC	
		else if ((zip >= '3000' && zip <= '3999')
				 || (zip >= '8000' && zip <= '8999')) // (LVRs and PO Boxes only)
			state = 'VIC';
		//Queensland => QLD	
		else if ((zip >= '4000' && zip <= '4999')
			|| (zip >=  '9000' && zip <= '9999')) //(LVRs and PO Boxes only)
			state = 'QLD';
		//South Australia => SA	
		else if ((zip >= '5000' && zip <= '5799')
				 || (zip >= '5800' && zip <= '5999')) // (LVRs and PO Boxes only)
			state = 'SA';
		//Western Australia => WA	
		else if ((zip >= '6000' && zip <= '6797')
				 || (zip >= '6800' && zip <= '6999')) // (LVRs and PO Boxes only)
			state = 'WA';
		//Tasmania => TAS	
		else if ((zip >= '7000' && zip <= '7799')
				 || (zip >= '7800' && zip <= '7999')) // (LVRs and PO Boxes only)
			state = 'TAS';
		//Northern Territory => NT	
		else if ((zip >= '0800' && zip <= '0899')
				 || (zip >= '0900' && zip <= '0999')) // (LVRs and PO Boxes only)
			state = 'NT';

		return state;
	},

	IsValidABN : function(abn) {
		if (abn.length != 11) 
			throw "Error, the Australian Business Number should contain exactly 11 characters !";

		var total = 0,
			weights = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19];

		for (var item in abn) {
			var digit = parseInt(abn.charAt(item));

			if (item == 0) digit--;
			total += digit * weights[item];
		}
		
		return (total != 0 && total % 89 == 0);
	},
    
    CreateNewAccount : function(component, helper, abnRec) {
        var createAcountEvent = $A.get("e.force:createRecord");

		if (!createAcountEvent || !abnRec) {
			console.log('Cannot create new record in app modus');
			return;
		}

		if (abnRec.ABNType != 'Other Name') {
			component.set('v.abnRec', abnRec);	        		
			component.set('v.showDialog', false);
			component.set('v.showDialog', true);
			return;
		}

		createAcountEvent.setParams({
		    "entityApiName": "Account",
		    "defaultFieldValues": {
				'perry__ABN__c' : helper.formatABN(abnRec.AbnNumber),
				'perry__ABN_Type__c': abnRec.ABNType,
		        'Name' : helper.toTitleCase(abnRec.result.name),
		        //'ShippingState' : abnRec.State,		         
		        //'ShippingPostalCode' : abnRec.Postcode,
		        'ShippingCountry' : abnRec.address.country,
		        //'BillingState' : abnRec.State,
		        //'BillingPostalCode' : abnRec.Postcode,
		    	'BillingCountry' : abnRec.address.country
		    }
		});
		createAcountEvent.fire();
	},
    
    toTitleCase : function(str) {
		return str.toLowerCase().replace(
			/^(.)|\s(.)/g, ($1) => $1.toUpperCase());
	},
    
    updateABN : function(component, helper, abn) {
        var remoteMethod = component.get("c.UpdateABN"),
        	abnRec = {
        		abn : abn.AbnNumber,
        		name : abn.mainName.name,
        		country : abn.address.country ,
        		psotcode : abn.address.postcode ,
        		state: abn.address.stateCode,
        		type : abn.ABNType
        	};
        
		remoteMethod.setParams({
            "recordId" : component.get('v.recordId'),
			"abnRec": abnRec	
		});

		console.log(['Request Update ABN', remoteMethod.getParams()]);
		remoteMethod.setCallback(this, function(response) {
			if (response.getState() == "ERROR")
				helper.IncomingError(component, response, helper);
			else if (response.getState() == "INCOMPLETE") 
				helper.IncompleteRequest(component, response, helper);
			else if (response.getState() == "SUCCESS") 
	        	$A.get('e.force:refreshView').fire();
	    });
      	$A.enqueueAction(remoteMethod); 
    },
    
    formatABN : function(abnNumber) {
    	var x = abnNumber.replace(' ', '');
    	if (x.length == 9)
    		return x.substr(0,3) + ' ' + x.substr(3,3) + ' ' + x.substr(6,3)
    	else if (x.length == 11)
    		return x.substr(0,2) + ' ' + x.substr(2,3) + ' ' + x.substr(5,3) + ' ' + x.substr(8,3);

    	return abnNumber;
    } 
})
({
	onInit : function(component, event, helper) {
		var cmpData = {
				activePageIndex: 0,
				results: null,
				cache: {},
				reqestId: 0
			}

		component.set('v.cmpData', cmpData);        	
	}, 

	getData: function(component, event, helper) {
		var remoteMethod = component.get('c.SearchABR'),
			abn = component.get('v.abnRec');

        remoteMethod.setParams({ 
			'abn': abn.AbnNumber,
			'requestId' : helper.NextRequestId(component)});
        remoteMethod.setCallback(this, function(response) { 
            if (response.getState() == "SUCCESS") { 				
            	var retVal = response.getReturnValue();
                console.log(['Reponse', retVal]);
                component.set('v.cmpData.results', retVal.response);
            } else if (response.getState() == "ERROR") {
            	var errors = response.getError();
            	console.log(['Reponse Error', errors]);
            	if (errors[0] && errors[0].message)
            		component.set(
            			'v.cmpData.errMgs', 
            			'Something went wrong! Error message for your administrator:\r\n' + JSON.stringify(errors[0].message));
            }
        });
        
        $A.enqueueAction(remoteMethod);  
	},

	parseResults : function(component, event, helper) {
		console.log('ParseResults');
		var data = component.get('v.cmpData.results');
		if (data && data.MainEntity) {
			component.set('v.parentData', data.MainEntity);
		} else if (data && data.AbnNumber) {
			component.set('v.parentId', null);

			var abnState = helper.convertState(
				data.mainBusinessPhysicalAddress.stateCode),
				abnPostcode = data.mainBusinessPhysicalAddress.postcode,
				parentData = {
					'Name' : data.mainName.name,
					'ABN__c' : data.AbnNumber,
					'ABN_Type__c' : 'Entity Name',
					'ASIC_ACN__c' : data.ASICNumber,
					'ABN_Validated__c' : true,
			        'ShippingState' : abnState,
			        'BillingState' : abnState,
			        'ShippingPostalCode' : abnPostcode,
			        'BillingPostalCode' : abnPostcode,
			    	'ShippingCountry' : 'Australia',
			        'BillingCountry' : 'Australia'
				};

			component.set('v.parentData', parentData);
		}
	},

	closeDlg : function(component, event, helper) {
		component.set('v.visible', false);
		component.set('v.errData', null);
	},

	nextPage : function(component, event, helper) {
		console.log('next');
		var activePageIndex = component.get('v.cmpData.activePageIndex');		
		component.set('v.cmpData.activePageIndex', activePageIndex + 1);
	},

	prevPage : function(component, event, helper) {
		var activePageIndex = component.get('v.cmpData.activePageIndex');		
		component.set('v.cmpData.activePageIndex', activePageIndex - 1);
	},

	preSubmit : function(component, event, helper) {
		console.log('PreSubmit');
		return false;
	},

	submitBtn : function(component, event, helper) {
		console.log('Submit');
		var abnRec = component.get('v.abnRec'),
			recordId = component.get('v.recordId'),
            recordTypeId=component.get('v.recordTypeId'); 
		
		if (!recordId)
			helper.CreateNewAccount(component, helper, abnRec,recordTypeId);        
		else {
			var abnData = component.get('v.cmpData.results'),
				data = JSON.parse(JSON.stringify(abnData));		

			delete data.businessName;
			delete data.otherTradingName;
			delete data.searchResultsRecord;
			var abnParent = JSON.stringify(data),
				updateAccount = {
					'Id' : recordId,
					'Name' : helper.toTitleCase(abnRec.result.name),
					'ABN__c' : helper.formatABN(abnRec.AbnNumber),
					'ABN_Type__c': abnRec.ABNType,
					//'perry__ABN_IsValid__c': true,
					//'ShippingState' : abnRec.State,		         
					//'ShippingPostalCode' : abnRec.Postcode,
					//'ShippingCountry' : abnRec.address.country,
					//'BillingState' : abnRec.State,
					//'BillingPostalCode' : abnRec.Postcode,
					//'BillingCountry' : abnRec.address.country,
					//'ABN_Parent_Account__c' : btoa(abnParent)
                    
				}

			helper.updateAccount(component, helper, updateAccount);			
		}
	},

	handleSuccess  : function(component, event, helper) {
		console.log('Success');	
		component.set('v.errData', null);
	},

	handleLoadComplete : function(component, event, helper) {
		console.log('Load Complete!');
		var payload = event.getParams().recordUi,
			fields = payload.fields || payload.record.fields,
			record = { Id : payload.id || payload.record.id },
			priorRecId = component.get('v.recordId');

		for (var field in fields) 
			record[field] = fields[field].value;
		
		if (priorRecId != record.Id)
			component.set('v.recordId', record.Id);

		component.set('v.recordData', record);
		component.set('v.errData', null);
	}
})
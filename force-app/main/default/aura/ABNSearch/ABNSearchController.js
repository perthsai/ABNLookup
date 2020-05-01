({
	onInit : function(component, event, helper) {
		var tool = {
		 	requestId : 0,
		  	delayFunc : (
			  	function() {
				  	var timer = 0;
				  	return function(callback, ms){
				    	clearTimeout (timer);
				    	if (ms) timer = setTimeout(callback, ms);
				  	}
				})() 
		};

		var search = component.get('v.searchStr');
            
        component.set('v._tools', tool);
		component.set('v.searchStr', null);	
        //console.log(recId);
        if (search) component.find('inputSearch').set('v.value', search);
  },
    
    recordUpdated : function(component, event, helper) {
        var data = component.get('v.recordData'),
            companyName;
        
        if (data && data.Id) companyName = data.Id.startsWith('001') ? data.Name : data.Company;
        else return;
        
        if (companyName) {
            console.log(data);
            //component.find('inputSearch').set('v.value', companyName);
            helper.SearchABNByString(component, helper, companyName);
        }
    },

	onSearchChange : function(component, event, helper) {
		var tool = component.get('v._tools'),
			timeOutMsec = 240,
			searchTxt = event.getSource().get('v.value');

		if (!searchTxt || searchTxt.length <= 2) {
			component.set('v.searchStr', null);		
			component.set('v.searchResults', []);	
			// Hide progress spinner
			var cmpSpinner = component.find('ABNSearchProgress');
			$A.util.addClass(cmpSpinner, 'slds-hide');

			// prevent displaying results from prior request:
			helper.NextRequestId(component);	
			
			// Cancel existing timer
			timeOutMsec = null;
		}

		tool.delayFunc(function() {
			if(component.isValid()) {
				// perform search action
				if (searchTxt && searchTxt.length > 2) 
					helper.Search(component, searchTxt, helper);
			}
		}, timeOutMsec);
	},

	onPostcodeChange : function(component, event, helper) {
		var zip = event.getSource().get('v.value'),
			state = helper.GetStateFromZip(zip),
			actualState = component.get('v.state');

		if (state && state != actualState) {
			component.set('v.state', state);
			var el = component.find("stateSelect");
			$A.util.removeClass(el, "slds-has-error"); // remove red border
			$A.util.addClass(el, "hide-error-message"); // hide error message
		}

		if ((zip == '' || zip && zip.length == 4) && state != '') 
			helper.Search(component, component.get('v.searchStr'), helper);
	},

	onSateChange : function(component, event, helper) {
		var state = event.getSource().get('v.value'),
			zip = component.get('v.postcode'),
			relatedState = helper.GetStateFromZip(zip);

		if (state && state != relatedState) {
			component.set('v.postcode', '');
			helper.Search(component, component.get('v.searchStr'), helper);
		} else if (state != '') 
			helper.Search(component, component.get('v.searchStr'), helper);
	},
    onCheck : function(component, event, helper) {
        let SrchString= component.get('v.searchStr');
        if(component.get('v.advancedSearchbyABNName')){ 
            component.set('v.advancedSearchbyABNName',false);
            if(SrchString){ var newText ='Enter ABN or keywords(3 characters min)';
                            component.set('v.searchLabelText', newText); 
                            helper.Search(component, component.get('v.searchStr'), helper);
                          }
            }else {
              component.set('v.advancedSearchbyABNName',true); 
                if(SrchString){ var newText ='Enter ABN Company Name :';
                               component.set('v.searchLabelText', newText); 
                               helper.Search(component, component.get('v.searchStr'), helper);
                              }  
            }      
     },
	searchTextChange : function(component, event, helper) {
		var newText = 'Enter ABN or keywords (3 characters min.):',
			searchText = component.get('v.searchStr'),
			abn = searchText ? searchText.split(' ').join('') : '',
			advnsearch=component.get('v.advancedSearchbyABNName'),
            newtxt=advnsearch ? 'Enter Exact ABN Company Name':'Enter ABN or keywords (3 characters min.):',
            advancedSearch = component.get('v.advancedMode');
           
		
		// ABN
		if (abn.length == 11 && /\d/.test(abn) && helper.IsValidABN(abn)) {
			newText = 'Searching for ABN: ' + helper.formatABN(searchText);
		// ACN
		} else if (abn.length == 9 && /\d/.test(abn)) {
			newText = 'Searching for ACN: ' + helper.formatABN(searchText);
		} else if (searchText && searchText.length > 5) {
			if (!advancedSearch) newText = 'Searching for "' + searchText + '"';
			else newText = 'Searching for "' + searchText + '" within ' + component.get('v.state') + ' ' + component.get('v.postcode');			
		}

		component.set('v.searchLabelText', newtxt); 
	},

    btnToggleAdvanced : function (component, event, helper) {
    	var advancedMode = !component.get('v.advancedMode')
        component.set('v.advancedMode', advancedMode);
        if (advancedMode) {
        	component.set('v.state', '');
        	component.set('v.postcode', '');
        } else helper.Search(component, component.get('v.searchStr'), helper);
    },
        
    searchResultClicked : function(component, event, helper) {
        var abnRec = event.getParam('record'),
            data = component.get('v.recordData');
        
        console.log(['Clicked: ', JSON.parse(JSON.stringify(abnRec))]);    
        if (!data) {
        	helper.CreateNewAccount(component, helper, abnRec);        
        } else if (data && data.Id && abnRec && abnRec.AbnNumber) {
			if (abnRec.ABNType != 'Entity Name') {
				//var dlg = component.find('AbnDialog');
				//dlg.set('v.recordData', data);	  
				component.set('v.abnRec', abnRec);	  
				component.set('v.showDialog', false);
				component.set('v.showDialog', true);
			} else {
				var objPref, companyName;
				if (data.Id.startsWith('001')) {
					objPref = 'Account';
					companyName = data.Name;
				} else if (data.Id.startsWith('00Q')) {
					objPref = 'Lead with Company';
					companyName = data.Company;
				} else return;
				
				var dlgData = {
					visible: true,
					companyName: companyName,
					abnRec: abnRec,
					objectTitle: objPref
				};

				component.set('v.confirmation', dlgData);				
			}			
        }
	},
	
	closeDlg : function(component, event, helper) {
		component.set('v.confirmation.visible', false);
	},

	submitDlg : function(component, event, helper) {
		component.set('v.confirmation.visible', false);
		var abnRec = component.get('v.confirmation.abnRec');
		//var msg = objPref + ' "' + companyName + '" will be assigned ABN "' + helper.formatABN(abnRec.AbnNumber) + '". Continue?';
		helper.updateABN(component, helper, abnRec);
	}
})
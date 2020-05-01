({
	onInit : function(component, event, helper) {
		var msgType =  component.get('v.messageType'),
            msgTypeMap = {
                'info': { 
                    'theme': 'slds-theme_info', 
                    'span': 'slds-icon-utility-user',
                    'icon': 'user'},
                'warning': { 
                    'theme': 'slds-theme_warning', 
                    'span': 'slds-icon-utility-warning', 
                    'icon': 'warning'},
                'error': { 
                    'theme': 'slds-theme_error', 
                    'span': 'slds-icon-utility-error',
                    'icon': 'error'},
                'offline': { 
                    'theme': 'slds-theme_offline', 
                    'span': 'slds-icon-utility-offline',           
                    'icon': 'offline'}
            };
        
        component.set('v.ui', msgTypeMap[msgType]);
        component.set('v.showDlg', true);
    },
    
    closeDlg : function(component, event, helper) {
        component.set('v.showDlg', false);
	}
})
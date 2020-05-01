({
	toTitleCase : function(str) {
		return str.toLowerCase().replace(/^(.)|\s(.)/g, ($1) => $1.toUpperCase());
	}
})
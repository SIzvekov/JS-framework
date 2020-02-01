function initPage(html){
$.when(setPageAccessLevel({

	level: "root"

})).then(function(isAccess){if(isAccess){

	// actions when has access to the page
	$(appConfig.bodyContentIdentifyer).html(mustache(html)).show();

}else{

	// actions when no access to the page
	locationHref('login', {'return': appConfig.currentUrl})
}
$(".bodyLoadSpinner").remove();
})}
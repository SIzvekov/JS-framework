function initPage(html){
	$(appConfig.bodyContentIdentifyer).html(mustache(html)).show();
	$(".bodyLoadSpinner").remove();
	setPageAccessLevel('');
}
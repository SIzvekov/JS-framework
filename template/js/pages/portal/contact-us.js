function initPage(html){
	
	$(appConfig.bodyContentIdentifyer).html(mustache(html, {})).show();		
	renderAjaxLinks();
	setPageAccessLevel('');
}
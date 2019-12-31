function initPage(html){
	var leagues = API_query('/leagues');

	$.when(leagues).then(
		function(leaguesResponse) {
			var leaguesInfo = leaguesResponse['response']
			
			$(appConfig.bodyContentIdentifyer).html(mustache(html, leaguesInfo)).show();
			
			renderAjaxLinks();
		})

	setPageAccessLevel('');
}
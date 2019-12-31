function initPage(html){
	var teamInfoData = API_query('/'+appConfig.sectionType+'/'+appConfig.sectionConfig.id+'/seasons/'+appConfig.sectionConfig.currentSeason.id+'/teams');

	$.when(teamInfoData).then(
	function(teamInfoDataResponse) {
		var teamInfo = teamInfoDataResponse.response
		console.log(teamInfo)
		$(appConfig.bodyContentIdentifyer).html(mustache(html, {'teamInfo': teamInfo})).show();
		renderAjaxLinks();
	})
}
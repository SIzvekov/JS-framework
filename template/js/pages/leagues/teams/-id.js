/* one team */
function initPage(html){
	var teamId = pathElement(3, true);
	var teamInfoData = API_query('/teams/'+teamId);

	$.when(teamInfoData).then(
		function(teamInfoDataResponse) {
			if(teamInfoDataResponse.code == 200) {
				var teamInfo = teamInfoDataResponse.response
				$(appConfig.bodyContentIdentifyer).html(mustache(html, teamInfo)).show();
			}else{
				error404();
			}
			
			renderAjaxLinks();
		})
}
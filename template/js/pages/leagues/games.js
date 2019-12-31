function initPage(html){
	var moduleMatches = loadHTMLModule('matches');
	var matchesData = API_query('/'+appConfig.sectionType+'/'+appConfig.sectionConfig.id+'/seasons/'+appConfig.sectionConfig.currentSeason.id+'/sportsdays',{"scheduledBefore": "now"})
	
	$.when(moduleMatches, matchesData).then(
		function(moduleMatchesResponse, matchesDataResponse) {
			var matchesHTML = moduleMatchesResponse[0]
			var sportsdays = matchesDataResponse['response']
			
			$.each(sportsdays, function(k,sportsday){
				$.each(sportsday.games, function(k1, game){
					sportsdays[k].games[k1].datetime = timestampToLocaleString(sportsdays[k].games[k1].datetime)
				})
			})
			var matches = mustache(matchesHTML, {'sportsdays': sportsdays});
			
			$(appConfig.bodyContentIdentifyer).html(mustache(html, {'matches': matches})).show();
			
			renderAjaxLinks();
		})

	setPageAccessLevel('');
}
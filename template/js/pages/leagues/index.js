function initPage(html){
	var moduleMatches = loadHTMLModule('matches');
	var moduleTable = loadHTMLModule('table');
	var matchesData = API_query('/'+appConfig.sectionType+'/'+appConfig.sectionConfig.id+'/seasons/'+appConfig.sectionConfig.currentSeason.id+'/sportsdays')
	var tableData = API_query('/'+appConfig.sectionType+'/'+appConfig.sectionConfig.id+'/seasons/'+appConfig.sectionConfig.currentSeason.id+'/table');
	
	$.when(moduleMatches, moduleTable, matchesData, tableData).then(
		function(moduleMatchesResponse, moduleTableResponse, matchesDataResponse, tableDataResponse) {
			var matchesHTML = moduleMatchesResponse[0]
			var tableHTML = moduleTableResponse[0]
			var sportsdays = matchesDataResponse['response']
			var tableInfo = tableDataResponse['response']
			
			$.each(sportsdays, function(k,sportsday){
				$.each(sportsday.games, function(k1, game){
					sportsdays[k].games[k1].datetime = timestampToLocaleString(sportsdays[k].games[k1].datetime)
				})
			})
			var matches = mustache(matchesHTML, {'sportsdays': sportsdays});
			var table = mustache(tableHTML, {'tableInfo': tableInfo});
			
			$(appConfig.bodyContentIdentifyer).html(mustache(html, {'table': table, 'matches': matches})).show();
			
			renderAjaxLinks();
		})

	setPageAccessLevel('');
}
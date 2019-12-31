$(function() {});

function on_page_load(){
	// execute after page loads
	include_once({
		filePath: appConfig.localAssetsHost+'template/html/include/loggedin/header.html',
		parentHtmlBlock: '#header',
		htmlBlockId: 'header',
		htmlBlockType: 'div',
		renderData: appConfig
	});
	include({
		filePath: appConfig.localAssetsHost+'template/html/include/loggedin/'+(appConfig.sectionType ? appConfig.sectionType+'/' : '')+'nav.html',
		parentHtmlBlock: '#topnav',
		htmlBlockId: 'nav',
		htmlBlockType: 'div',
		renderData: appConfig.sectionConfig.currentSeason
	});
	include_once({
		filePath: appConfig.localAssetsHost+'template/html/include/loggedin/footer.html',
		parentHtmlBlock: '#footer',
		htmlBlockId: 'footer',
		renderData: appConfig
	});
}

function changePasswordPopup () {
	if($("#changePassword").length) return;
	include({
		filePath: appConfig.localAssetsHost+'template/html/include/changePasswordPopup.html',
		parentHtmlBlock: 'body',
		htmlBlockId: 'changePassword'
	});
}
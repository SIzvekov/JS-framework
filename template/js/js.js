$(function() {});
function before_page_load(){}
function on_page_load(){
	// execute after page loads
	include_once({
		filePath: appConfig.localAssetsHost+'template/html/include/loggedin/header.html',
		parentHtmlBlock: '#header',
		htmlBlockId: 'header',
		htmlBlockType: 'div',
		renderData: appConfig
	});
	include_once({
		filePath: appConfig.localAssetsHost+'template/html/include/loggedin/footer.html',
		parentHtmlBlock: '#footer',
		htmlBlockId: 'footer',
		renderData: appConfig
	});
}
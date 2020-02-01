var overrideConfigVersion = '1.00';
var defaultAuthErrorMessage = '';
var appConfig = { 
	bodyContentIdentifyer: '#bodyContent',
	bodyLoadSpinnerType: 'spinner',
	appendLoadSpinnerTo: '#bodyContent',
	rvtHTMLVersion: '1.00',
	rvtJSVersion: '1.00', 
	rvtCSSVersion: '1.00',
	rvtJSONVersion: '1.00',
	cssFiles: ["css"],
	jsFiles: [],
	APIurl: '/api',
	BaseUrl: '/',
	localAssetsHost: '',
	checkAuthTimeout: 60000,
	checkUnAuthStatInterval: 3000,
	/* array of login types by default */
	defaultLoginGroup: [],
	/* array of labels for each login type */
	defaultLoginGroupLabels: {'root': 'Root Admin'},
	ajaxCache: true,
	currentUrl: '',
	currentUrlPath: '',
	staticContentHost: '/staticcontent'
};

$(function() {
	/*
	It is done thru requestiong HTML rather than JSON to protect the code from invalid JSON object in the app/overrideConfig.json.
	In case of invalid JSON (or if this file does not exist at all) the script inside of "success" does not evaluate at all (neither it does in .done)
	*/
	var overrideAppConfigData = loadFile({filePath: "app/overrideConfig--v"+overrideConfigVersion+".json"});
	
	$.when(overrideAppConfigData).then(function(overrideAppConfig){
		overrideAppConfig = overrideAppConfig[0]
		
		// override config
		$.ajaxSetup({
			cache: appConfig.ajaxCache
		}); 

		$.each(appConfig.cssFiles, function(k, v){
			loadCSS(v);
		});
		$.each(appConfig.jsFiles, function(k, v){
			loadJSscript(v)
		});

		$.getScript(appConfig.localAssetsHost+"template/js/js--v"+appConfig.rvtJSVersion+".js").complete(function(script, textStatus){
			if(textStatus=='success'){
				include({
					filePath: appConfig.localAssetsHost+'template/html/index--v'+appConfig.rvtHTMLVersion+'.html', 
					parentHtmlBlock: 'body', 
					htmlBlockId: 'body', 
					callbackFunction: function(){
						setInterval(function(){
							loadpage(getHashUrl());
						}, 100);
					},
					replaceContent: true
				});
			}
		});
		
	})

});

/*
	creates new HTML tag with type [htmlBlockType] (by default is <div>)
	assigns parameter ID to the created tage [htmlBlockId]
	loads content from url [filePath]
	adds loaded content in the end of block [parentHtmlBlock]
	afterwards calls function [callbackFunction]

	Possible params:
	params: {
		filePath: {url of the document},
		parentHtmlBlock: {html tag selector to append to},
		htmlBlockId: {new html tag id to apply},
		callbackFunction: {callback function to call once done loading content},
		htmlBlockType: {new html tag type},
		renderData: {data object to render mustache template}
		renderDataEnabled: [true|false]
	}
*/ 
function include(params){
	if(typeof params !== 'object') return false;

	if(!params.htmlBlockType) params.htmlBlockType = 'div';
	htmlBlock = '<'+params.htmlBlockType.replace('>', '').replace('<', '')+' id=\''+params.htmlBlockId+'\'>';
	
	if(typeof params.replaceContent != 'undefined' && params.replaceContent === true){
		$( params.parentHtmlBlock ).html( htmlBlock );
	}else{
		$( params.parentHtmlBlock ).append( htmlBlock );
	}

	if(typeof $("#"+params.htmlBlockId).html() == 'undefined') return false;

	loadFile({
		filePath: params.filePath,
		beforeSend: function(){
			var spinner = spinnerHTML();
			$("#"+params.htmlBlockId).html(spinner.html);
		},
		success: function(data){
			if(!(typeof params.renderDataEnabled !== 'undefined' && !params.renderDataEnabled)){
				data = mustache(data, {...params.renderData})
			}
			$("#"+params.htmlBlockId).html(data);
			renderAjaxLinks();
			if(typeof params.callbackFunction == 'function') params.callbackFunction();
		}
	});
}

function include_once(params){
	if(
		typeof $("#"+params.htmlBlockId).html() !== 'undefined' && 
		!$("#"+params.htmlBlockId).html().length
	) include(params)
}


/*
loads block of HTML which can be used later
make a request like this
	loadHTMLModule('{moduleName}', '{storeVariableName}');
Once the request is made and if file template/html/modules/{moduleName}.html exists then create new object
	htmlModuleBlocks.{storeVariableName}
with content of that HTML file.
If the HTML file does not exists then htmlModuleBlocks.{storeVariableName} will be empty
the request is AJAX async and does not block the screen
*/
var htmlModuleBlocks = {}
function loadHTMLModule(modeulTitle, returnVar, callBackFunction){
	filePath = appConfig.localAssetsHost+"template/html/modules/"+modeulTitle+"--v"+appConfig.rvtHTMLVersion+".html";
	return loadFile({
		filePath: filePath, 
		success: function( htmlContent ) {
			if(htmlContent.substring(0,2) == '<!'){
				htmlContent = '';
			}
			if(returnVar) htmlModuleBlocks[returnVar] = htmlContent;

			if(typeof callBackFunction == 'function'){
				callBackFunction();
			}
		}
	});
}

var allLoadedFiles = [];
var allLoadedFilesSuccess = [];
function loadFile(parameters){
	var promise = $.Deferred();
	// console.log(allLoadedFiles);
	// return false;
	if(typeof parameters != 'object'){
		console.log('loadFile runtime error');
		promise.reject( 'loadFile runtime error' );
		return false;
	}

	if(typeof parameters.queryMethod == 'undefined' || !parameters.queryMethod){
		parameters.queryMethod = 'GET';
	}

	if(typeof parameters.params != 'object'){
		parameters.params = {};
	}

	if(typeof parameters.dataType == 'undefined' || !parameters.dataType){
		parameters.dataType = null;
	}

	if(typeof allLoadedFiles[parameters.filePath] != 'undefined'){
		// console.log('file: '+parameters.filePath+'; fromCache');
		if(typeof parameters.beforeSend == 'function'){
			parameters.beforeSend();
		}

		gotContent = allLoadedFiles[parameters.filePath];
		if (parameters.dataType == 'script') {
			$.globalEval(gotContent);
		}
		isSuccess = allLoadedFilesSuccess[parameters.filePath];

		if(isSuccess){
			if(typeof parameters.success == 'function'){
				parameters.success(gotContent, 'success');
			}	
			promise.resolve( [gotContent, 'success'] );
		}else{
			if(typeof parameters.error == 'function'){
				parameters.error(gotContent, 'error');
			}
			promise.reject( [gotContent, 'error'] );
		}

		if(typeof parameters.complete == 'function'){
			parameters.complete(gotContent, (isSuccess ? 'success' : 'error'));
		}
	}else{
		//console.log('file: '+parameters.filePath+'; load; '+parameters.dataType);

		$.ajax({
			url: parameters.filePath,
			data: parameters.params,
			type: parameters.queryMethod,
			// dataType: parameters.dataType,
			success: function(gotContent, textStatus){
				allLoadedFilesSuccess[parameters.filePath] = true;
				if(typeof parameters.success == 'function'){
					parameters.success(gotContent, textStatus);
				}
				promise.resolve( [gotContent, textStatus] );
			},
			beforeSend: function(){
				if(typeof parameters.beforeSend == 'function'){
					parameters.beforeSend();
				}
			},
			complete: function(gotContent, textStatus){
				if(gotContent.responseJSON) allLoadedFiles[parameters.filePath] = gotContent.responseJSON;
				else allLoadedFiles[parameters.filePath] = gotContent.responseText;
				if(parameters.dataType == 'script'){
					// eval(gotContent.responseText);
				}

				if(typeof parameters.complete == 'function'){
					parameters.complete(gotContent, textStatus);
				}
			},
			error: function(gotContent, textStatus){
				allLoadedFilesSuccess[parameters.filePath] = false;
				if(typeof parameters.error == 'function'){
					parameters.error(gotContent, textStatus);
				}
				promise.reject( [gotContent, textStatus] );
			}
		});
	}

	return promise.promise();
}

/*
load Additional JS script from folder template/js/addons/ and fire a callBack function if one is provided
*/
function loadJSscript(scriptName, callBackFunction){
	$.getScript(appConfig.localAssetsHost+"template/js/addons/"+scriptName+"--v"+appConfig.rvtJSVersion+".js").complete(function(script, textStatus){
		if(textStatus=='success' && typeof callBackFunction == 'function'){
			callBackFunction();
		}
	});
}
function loadExternalJSscript(scriptName, callBackFunction){
	$.getScript(scriptName).complete(function(script, textStatus){
		if(textStatus=='success' && typeof callBackFunction == 'function'){
			callBackFunction();
		}
	});
}

/*
load CSS file
*/
function loadCSS(fileName){
	$('head').append( $('<link rel="stylesheet" type="text/css" />').attr('href', appConfig.localAssetsHost+'template/css/'+fileName+'--v'+appConfig.rvtCSSVersion+'.css') );
}

/*
 remove content in [parentHtmlBlock] and call function include with the same parameters
 */
function replace(filePath, parentHtmlBlock, htmlBlockId, callbackFunction, htmlBlockType){
	$( parentHtmlBlock ).html('');
	include({
		filePath: filePath,
		parentHtmlBlock: parentHtmlBlock,
		htmlBlockId: htmlBlockId,
		callbackFunction: callbackFunction,
		htmlBlockType: htmlBlockType
	});
}

function getHashUrl() {
	var url = '';
	isHashUrlMarker = window.location.hash.substr(1,1);
	if(isHashUrlMarker == '!'){
		url = window.location.hash.substr(2);
		url = url.split('?');
		url = url[0];
	}
	return url;
}

var lastUrl = '';
var lastParams = '';
function loadpage(url, params, queryMethod){
	// if URL was not passed to the function, define URL from path string
	if(!url)
		var url = window.location.pathname; // Returns path only

	if(!params)
		var params = getUrlParameterString(); // Returns path only

	// delete symbol '/' in the beginning and in the end of the url string
	url = trimChar(url, '/');
	url = url.replace('.html', '');
	
	var TrimmedBaseUrl = trimChar(appConfig.BaseUrl, '/');
	var re = new RegExp(""+TrimmedBaseUrl+""); 
	url = url.replace(re, "");

	if(appConfig.sectionCode){
		var TrimmedSectionCodeUrl = trimChar(appConfig.sectionCode, '/');
		var re = new RegExp("/"+TrimmedSectionCodeUrl+""); 
		url = url.replace(re, "");
	}

	// if URL is still empty, define it as index
	// console.log(url);
	if(!url)
		var url = 'index';
	
	// if last loaded url is equal to the one which we're trying to load now and the set of parameters is the same then stop it
	if(lastUrl == url && lastParams == params){
		return false;
	}else{
		// define "last loaded url" as the current url
		lastUrl = url;
		lastParams = getUrlParameterString();
	}

	// if query method is empty then it's GET
	if(!queryMethod){
		queryMethod = 'GET';
	}

	urlAr = url.split('/');
	appConfig.currentUrlPath = urlAr.join('/');
	var newUrlAr = [];
	$.each(urlAr, function(k,v){
		if(!v.match(/^-.*/)){
			newUrlAr[newUrlAr.length] = urlAr[k];
		}else{
			newUrlAr[newUrlAr.length] = '-id';
		}
	})
	urlAr = newUrlAr;
	url = urlAr.join('/');
	appConfig.currentUrl = url;

	loadFile({
		filePath: appConfig.localAssetsHost+'template/html/pages/'+url+'--v'+appConfig.rvtHTMLVersion+'.html',
		type: queryMethod,
		data: params,
		beforeSend: function(){
			if(typeof before_page_load == 'function') before_page_load();

			document.title = '';
			// $(appConfig.bodyContentIdentifyer).html('');
			if ($("#loginForm").length){
				$("#loginForm").remove();
			}
			$(appConfig.bodyContentIdentifyer).html('<div class="bodyLoadSpinner">'+spinnerHTML().html+'</div>');
		},
		success: function(res){
			lines = res.split("\n");
			if(lines[0]=="<!DOCTYPE html>"){ // means that page was not found
				error404();
			}else{

				loadFile({
					filePath: appConfig.localAssetsHost+"template/js/pages/"+url+"--v"+appConfig.rvtJSVersion+".js",
					dataType: 'script',
					complete: function(script, textStatus){
						if(textStatus=='success' && typeof initPage == 'function'){
							initPage(res);
						}else{
							console.log(appConfig.bodyContentIdentifyer)
							$(appConfig.bodyContentIdentifyer).html(mustache(res));
							$(".bodyLoadSpinner").remove();
						}
					}
				});
				// $.getScript("template/js/pages/"+url+"--v"+appConfig.rvtJSVersion+".js").complete(function(script, textStatus){
				// 	if(textStatus=='success' && typeof initPage == 'function'){
				// 		initPage(res);
				// 	}else{
				// 		$(appConfig.bodyContentIdentifyer).html(res);
				// 		$(".bodyLoadSpinner").remove();
				// 	}
				// });
			}
			window.scrollTo(0, 0);

			if(typeof on_page_load == 'function') on_page_load();
		},
		complete: function(){
			renderAjaxLinks();
		},
		error: function(res){
			include({
				filePath: appConfig.localAssetsHost+'template/html/html-errors/'+res.status+'.html',
				parentHtmlBlock: appConfig.bodyContentIdentifyer,
				htmlBlockId: 'bodyContent',
				callbackFunction: function(){
					$(".bodyLoadSpinner").remove();
				}
			});
		}

	});
}

function pathElement(index, clean){
	if(typeof index == 'undefined') return null;
	index = parseInt(index);
	pathname = window.location.pathname;
	pathname = trimChar(pathname, '/');
	pathname = pathname.split('/');

	if(typeof clean == 'boolean' && clean)
		element = pathname[index].replace(/\.html$/,'').replace(/^-/,'');
	else 
		element = pathname[index];
	return element;
}

/*
	if level is given then check if the user is authorised and start checking it periodically
*/
var auth_check_timer;

function setPageAccessLevel(params){
	/*
	params = {
		level: level,
		defaultMessage: defaultMessage,
		forceToLogOut: forceToLogOut
	}
	*/

	var promise = $.Deferred();

	if(typeof params != 'object'){
		promise.resolve( true );
		// return true;
	}

	if(typeof params.level == 'undefined') level = null;
	else level = params.level;

	if(typeof params.defaultMessage == 'undefined') defaultMessage = null;
	else defaultMessage = params.defaultMessage;

	if(typeof params.forceToLogOut == 'undefined') forceToLogOut = null;
	else forceToLogOut = params.forceToLogOut;

	if(forceToLogOut) level = '-';
	if(!level) {
		promise.resolve( true );
		// return true;
	}
	currentUserType = userType();
	level = level.split(',');
	var userDontHasAccess = (currentUserType != 'root' && $.inArray( currentUserType, level ) == -1);
	
	if(!currentUserType || userDontHasAccess){
		if(!forceToLogOut) {
			$.cookie('loginUserTypeRequired',level);
		}
		
		if(!defaultMessage && userDontHasAccess){
			defaultMessage = 'You don\t have permission to access this page';
		}
		if(typeof params.onNoAccess == "function"){
			params.onNoAccess(params);
		}
		if(typeof window['authNoAccessAction'] == "function"){
			window['authNoAccessAction'](params);
		}
		promise.resolve( false );
		// promise.reject(false);
		// return false;
	}else{
		checkAuth();
		// if(auth_check_timer) clearInterval(auth_check_timer);
		// auth_check_timer = setInterval(checkAuth, appConfig.checkAuthTimeout);

		// requestSessionExtension();
	}

	return promise.promise();
}

/*
	cehck if the user is authorised
*/
function userAuth(userData, callbackFunction){
	if(typeof userData != 'object') userData = [];

	API_query('auth', userData, 'POST', function(res){
		if(res.code==200){
			if(
				typeof res != "undefined" && 
				typeof res.response != "undefined" && 
				typeof res.response.sessionTTE != "undefined" && 
				parseInt(res.response.sessionTTE)
			){
				saveUserToken(res.response.token);
				setCheckAuthTimeout(parseInt(res.response.sessionTTE));
			}
			// saveAuthUserInfo(res);
		}
		if(typeof callbackFunction == 'function') callbackFunction(res);
	});
}

function checkAuth(callbackFunction){
	var token = userToken();
	if(!token) {
		res = {
			code: 498, 
			status: "Token expired/invalid", 
			response: null
		}
		if(typeof callbackFunction == 'function') callbackFunction(res);
		return false;
	}

	data = {
		_token: token,
		_method: 'put',
		_: getNocacheIndex()
	};
	API_query('auth', data, 'GET', function(res){
		if(res.code==200){
			setCheckAuthTimeout(res.response.sessionTTE);
		}else{
			saveUserToken('');
		}
		if(typeof callbackFunction == 'function') callbackFunction(res);
	});
}

function setCheckAuthTimeout(seconds){
	extendedSeconds = parseInt(seconds);
	if(extendedSeconds){
		/*
		Calculating timeout for requestion the next extension in milliseconds.
		Where the 666 does come from? 
		First of all extendedSeconds is in seconds and we need milliseconds: multiply by 1000
		I don't want to make the request right at the end of the session, I want to make it at 2/3 of extendedSeconds
		then: 1000 * 2/3 = ~666
		*/
		timeOutMiliseconds = extendedSeconds * 666;
		setTimeout(checkAuth, timeOutMiliseconds);
	}
}

/*
Check if the user was logged in in different window. If yes - reload current window
*/
function checkUnAuthStat(oldToken){
	if(typeof checkUnAuthStatTimer != 'undefined' && checkUnAuthStatTimer){
		clearInterval(checkUnAuthStatTimer)
	}
	
	var currentToken = userToken();
	if(oldToken && currentToken != oldToken){
		window.location.reload();
	}else{
		checkUnAuthStatTimer = setTimeout(function(){
			checkUnAuthStat(oldToken);
		}, appConfig.checkUnAuthStatInterval);
	}
}

/*
Request Extension for session expiration time
*/
function requestSessionExtension(){
	var token = userToken();
	data = {
		_token: token,
		_: getNocacheIndex(),
		_method: 'put'
	};
	API_query('auth', data, 'GET', function(res){
		if(res.code==200){
			extendedSeconds = parseInt(res.response.sessionTTE);
			if(extendedSeconds){
				/*
				Calculating timeout for requestion the next extension in milliseconds.
				Where the 666 does come from? 
				First of all extendedSeconds is in seconds and we need milliseconds: multiply by 1000
				I don't want to make the request right at the end of the session, I want to make it at 2/3 of extendedSeconds
				then: 1000 * 2/3 = ~666
				*/
				timeOutMiliseconds = extendedSeconds * 666;
				setTimeout(requestSessionExtension, timeOutMiliseconds);
			}
		}
	});
}

function userToken(){
	if(isLocalStorage()){
		return localStorage.getItem('userToken');
	}else{
		return $.cookie('userToken');
	}
}
function userType(){
	if(isLocalStorage()){
		return localStorage.getItem('userType');
	}else{
		return $.cookie('userType');
	}
}
function authUserInfo(){
	if(isLocalStorage()){
		var info = localStorage.getItem("authUserInfo");
	}else{
		var info = $.cookie('authUserInfo');
	}
	info = JSON.parse(info);
	return info;
}

function setUserParam(param, val){
	if(isLocalStorage()){
		localStorage.setItem(param, val);
	}else{
		$.cookie(param, val);
	}
	return true;
}

function getUserParam(param){
	if(isLocalStorage()){
		return localStorage.getItem(param);
	}else{
		return $.cookie(param);
	}
}


function saveUserToken(val){
	if(isLocalStorage()){
		localStorage.setItem("userToken", val);
	}else{
		$.cookie('userToken',val);
	}
	return val;
}
function saveUserType(val){
	if(isLocalStorage()){
		localStorage.setItem("userType", val);
	}else{
		$.cookie('userType',val);
	}
	return val;
}
function saveAuthUserInfo(val){
	val = JSON.stringify(val);
	if(isLocalStorage()){
		localStorage.setItem("authUserInfo", val);
	}else{
		$.cookie('authUserInfo',val);
	}
	return true;
}


function trimChar(string, charToRemove) {
    while(string.charAt(0)==charToRemove) {
        string = string.substring(1);
    }

    while(string.charAt(string.length-1)==charToRemove) {
        string = string.substring(0,string.length-1);
    }

    return string;
}

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = decodeURI(value);
    });
    return vars;
}

function getUrlParam(parameter, defaultvalue){
    var urlparameter = defaultvalue;
    if(window.location.href.indexOf(parameter) > -1){
        urlparameter = getUrlVars()[parameter];
        }
    return urlparameter;
}

function getUrlParameterString(){
    var sPageURL = '';
    isHashUrlMarker = window.location.hash.substr(1,1);
    if(isHashUrlMarker == '!'){
        url = window.location.hash.substr(2);
        if(url){
            url = url.split('?');
            if(url[1]){
                sPageURL = url[1] += '&';
            }
        }
    }
    sPageURL += window.location.search.substring(1);
    return sPageURL;
}

function getUrlParameter(sParam)
{
    var urlParametersArray = getUrlParametersArray()
    if(typeof urlParametersArray[sParam] !== 'undefined')
        return urlParametersArray[sParam]
    else
        return null
}

function getUrlParametersArray(){
    var urlParametersArray = {}
    sPageURL = getUrlParameterString();
    var sURLVariables = sPageURL.split('&');

    for (var i = 0; i < sURLVariables.length; i++)
    {
        var sParameterName = sURLVariables[i].split('=');
        urlParametersArray[decodeURI(sParameterName[0])] = decodeURI(sParameterName[1]);
    }
    return urlParametersArray;
}

function buildUrlParameterString(urlParametersArray){
    var buildUrlParametersArray = []
    $.each(urlParametersArray, function(k, v){
        if(k)
            buildUrlParametersArray[buildUrlParametersArray.length] = encodeURI(k)+'='+encodeURI(v)
    })
    return buildUrlParametersArray.join('&')
}

function mustacheRender(view, blockId){
	if(!blockId) blockId = appConfig.bodyContentIdentifyer;
	$(blockId).html(mustache($(blockId).html(), view))
}

function mustache(template, params){
	if(typeof params !== 'object')
		params = {}

	if(typeof params.config == 'undefined')
		params.config = appConfig;
	
	return Mustache.render(
		template, 
		params
	)
}

function renderContentIntoBlock(template, data, blockSelector){
	$(blockSelector).html(mustache(template, data));
	return $(blockSelector);
}

function locationHref(url){
	if(typeof url == 'undefined') return false;

	url = url.replace('.html', '');
	url = trimChar(url, '/');
	if (history.pushState) {
		url = url + '.html';
		history.pushState(null, null, url);
	}else{
		location.href = '#!'+url;
	}
	 
	
}


function renderAjaxLinks () {
	if (history.pushState) {
		$("a.ajax-link").off('click');
		$("a.ajax-link").on('click', function(event){
			event.preventDefault();
			currentHref = $(this).attr('href');
			if(currentHref){
				currentHref = currentHref.replace('.html', '');
				history.pushState(null, null, currentHref+'.html');
			}
		});
	}else{
		$.each($("a.ajax-link"), function(k, v){
			currentHref = $(this).attr('href');
			if(currentHref.substr(0,2) != '#!'){
				currentHref = trimChar(currentHref, '/');
				currentHref = currentHref.replace('.html', '');
				$(this).attr('href', '#!'+currentHref);
			}
		});
	}
}

function getNocacheIndex()
{
	return Math.random().toString().replace('0.', '');
}

function userLogOut(callbackFunction){
	var token = userToken();
	
	data = {
		_token: token,
		_method: 'delete',
		_: getNocacheIndex()
	};
	API_query('auth', data, 'GET', function(res){
		if(res.code==200){
			saveUserToken('');
			saveUserType('');
			saveAuthUserInfo('');
			setPageAccessLevel({level: '', defaultMessage: '', forceToLogOut: true});
		}
		if(typeof callbackFunction == 'function') callbackFunction(res);
	});
}

function API_query(resource, data, method, callback, params){
	var promise = $.Deferred();

	resource = trimChar(resource, '/');
	if(!method) method = 'GET';
	if(!resource) return false;
	if(!data) data = [];
	if(typeof params != 'object') params = {};

	var urlToken = '';
	if(!data._token && userToken()) urlToken = '?_token='+userToken();

	if(method == 'GET' || method == 'POST')
		var queryMethod = method;
	else{
		data._method = method;
		var queryMethod = 'POST';
	}
	
	$.ajax({
		type: queryMethod,
		url: appConfig.APIurl+'/'+resource+'/'+urlToken,
		data: data,
		dataType: 'JSON',
		async: (typeof params.async ? params.async : true),
		beforeSend: function(){},
		complete: function(res){
			res = JSON.parse(res.responseText);
			
			if(res.code == 498){
				saveUserType('');
				setPageAccessLevel({level: '', defaultMessage: 'Session timeout', forceToLogOut: true});
			}

			// fire callback function
			if(callback){
				callback(res);
			}
			promise.resolve( res );
		}
	});
	return promise.promise();
}

function show_message(params) {
	message = params.message;
	type = params.type;
	ico = params.ico;
	hide = parseInt(params.hide);

	if(typeof type == 'undefined'){
		type = 'success';
	}
	if(typeof ico == 'undefined'){
		ico = 'exclamation-sign';
	}

	$("#sysMessage").html('');
	$("#sysMessage").html('<div class="alert alert-'+type+' hidden" role="alert" id="sysMessageBlock"><span class="glyphicon glyphicon-'+ico+'" aria-hidden="true"></span><span id="sysMessageText"></span></div>');

	$("#sysMessageText").html(message);
	$("#sysMessageBlock").removeClass("hidden").hide();
	$("#sysMessageBlock").fadeIn();

	if(hide > 0){
		setInterval(function(){
			$("#sysMessageBlock").fadeOut('slow', function(){
				$("#sysMessage").html('');
			});
		}, hide);
	}
}

function isLocalStorage(){
	if (typeof(Storage) !== "undefined") {
	    return true;
	} else {
	    return false;
	}
}

function error404(){
	include({
		filePath: appConfig.localAssetsHost+'template/html/html-errors/404--v'+appConfig.rvtHTMLVersion+'.html',
		parentHtmlBlock: appConfig.bodyContentIdentifyer,
		htmlBlockId: 'bodyContent',
		callbackFunction: function(){
			$(".bodyLoadSpinner").remove();
		}
	});
}

function spinnerHTML(){
	var id = 'spiner-'+getNocacheIndex();
	return {
		html: '<i class="fa fa-'+appConfig.bodyLoadSpinnerType+' fa-spin" id="'+id+'"></i>',
		id: id
	}
}

function timestampToLocaleString(timestamp){
	timestamp = new Date(timestamp * 1000);
	return timestamp.toLocaleString()	
}

// From Github Gist:  varemenos / getparam.js
// Given a query string "?to=email&why=because&first=John&Last=smith"
// getUrlVar("to")  will return "email"
// getUrlVar("last") will return "smith"
 
// Slightly more concise and improved version based on http://www.jquery4u.com/snippets/url-parameters-jquery/
function getUrlVar(key){
	var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.search); 
	return result && unescape(result[1]) || ""; 
}
 
// To convert it to a jQuery plug-in, you could try something like this:
(function($){
	$.getUrlVar = function(key){
		var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.search); 
		return result && unescape(result[1]) || ""; 
	};
})(jQuery);
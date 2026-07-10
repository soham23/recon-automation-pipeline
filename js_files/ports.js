// https://developer.mozilla.org/en-US/docs/Web/API/Node/childNodes
// https://stackoverflow.com/questions/195951/how-can-i-change-an-elements-class-with-javascript
// https://www.freecodecamp.org/news/how-to-loop-through-an-array-in-javascript-js-iterate-tutorial/
// https://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
// https://datatables.net/forums/discussion/32575/uncaught-typeerror-cannot-set-property-dt-cellindex-of-undefined

header_id = "my-header-123";
function from_url_params(key){
	urlParams = new URLSearchParams(window.location.search);
	if(urlParams.size==1){
		return urlParams.get(key);
	}
	return -1;
}

subdomain = from_url_params("sub")
let i=0;
if (subdomain !== -1){
	trs = document.getElementsByTagName("tr");
	while (i<trs.length)
	{
		if(trs[i].childNodes[1].innerText!==subdomain) {
			if (trs[i].id != header_id)
			{trs[i].classList.add("d-none");}
		}
		i++;
	}
}

$(document).ready(function() {
  $("#example").DataTable({"pageLength": 100});
});
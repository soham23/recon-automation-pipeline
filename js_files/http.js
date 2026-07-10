// https://datatables.net/forums/discussion/69141/set-default-page-length-option-to-100-show-entries
// https://codepen.io/agdg/pen/zpydmd

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
	http_url = "http://"+subdomain+"/"
	https_url = "https://"+subdomain+"/"
	trs = document.getElementsByTagName("tr");
	while (i<trs.length)
	{
		if(trs[i].childNodes[1].innerText!=http_url && trs[i].childNodes[1].innerText!=https_url) {
			if (trs[i].id != header_id)
			{trs[i].classList.add("d-none");}
		}
		i++;
	}
}

$(document).ready(function() {
  $("#example").DataTable({"pageLength": 100});
});
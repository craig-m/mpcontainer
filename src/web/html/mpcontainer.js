/*!
  *
  * MPContainer JS
  * 
  */


/* get stats */
var xmlhttp = new XMLHttpRequest();
xmlhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
        myObj = JSON.parse(this.responseText);
        document.getElementById("info-stats").innerHTML = "<p><b>artists:</b> " + myObj.artists + "</p><p><b>albums:</b> " + myObj.albums  + "</p><p><b>songs:</b> " + myObj.songs + "</p>";
    }
};
xmlhttp.open("GET", "/pyapp/mpd/stat.json", true);
xmlhttp.send();

/* footer */
$(document).ready(function(){
  $("#mpcpyip").load("/pyapp/host/date/");
});

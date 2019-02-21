function setTab(e) {
var tabContainer = document.getElementById("tabs");   
var tabs = tabContainer.getElementsByTagName("a");

for (var i = 0; i < tabs.length; i++) {   
	 var rel = tabs[i].getAttribute("rel");
	 tabs[i].setAttribute('onClick','setTab(rel);');
     if ( rel == e ) {
	 tabs[i].className='selected';
     document.getElementById(rel).style.display='block';
     }
	 else {
	 tabs[i].className='';
	//alert(rel);
	 document.getElementById(rel).style.display='none';
	 }
 }
}

function startTabs(e) {
var tabContainer = document.getElementById("tabs");   
var tabs = tabContainer.getElementsByTagName("a");
for (var i = 0; i < tabs.length; i++) {   
tabs[i].setAttribute('onClick','setTab(rel);');
}
setTab(e);
}

function calcHeight(f)
{
//find the height of the internal page
var the_height=document.getElementById('tabwindow').scrollHeight-12;

//change the height of the iframe
document.getElementById(f).height=the_height;
}

function checkIframes(){
var frames=document.getElementsByTagName('iframe');
for(i=0;i<frames.length;i++) {
 calcHeight(frames[i].id);
 }
}

window.onChange=checkIframes();
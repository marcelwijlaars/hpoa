/*
		 Copyright 2006-2014 Hewlett-Packard Development Company, L.P. 
*/

function ListManager() {
	
}

ListManager.prototype.init = function() {
	var divs = document.getElementsByTagName("DIV");
	for (var i=0;i<divs.length;i++) {
		if (divs[i].className=="navigationControlSet") {
			var navigationControls = divs[i].getElementsByTagName("DIV");
			
			for (var j=0;j<navigationControls.length;j++) {
				var elem = navigationControls[j].childNodes[0];
				if (elem && elem.nodeType==1){
					/* preserve existing click handlers */
					if (elem.onclick) {
							eval("elem.onclick = function(mozEvent) {var hardCodedFunction = "+elem.onclick+";ourListManager.highlightItem(this);hardCodedFunction();};");
					}else{
							eval("elem.onclick = function(mozEvent) {ourListManager.highlightItem(this);};");
					}	
			  }	
			}
		}
	}
}

ListManager.prototype.highlightItem = function(obj) {
	var lookingForWrapper = obj
	while ((lookingForWrapper) && (lookingForWrapper.className!="navigationControlSet")) {
		lookingForWrapper = lookingForWrapper.parentNode;
	}
	if (lookingForWrapper) {
		var navigationControls = lookingForWrapper.getElementsByTagName("DIV");
		for (var i=0;i<navigationControls.length;i++) {
			if (navigationControls[i]==obj.parentNode) {
				navigationControls[i].className = "navigationControlOn";
			}
			else {			
				navigationControls[i].className ="navigationControlOff";
			}
		}
	}
}


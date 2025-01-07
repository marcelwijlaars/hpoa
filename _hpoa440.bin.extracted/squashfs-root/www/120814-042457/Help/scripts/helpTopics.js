//_____________________________________________________________________________
//
//	HP Onboard Administrator Help System 
//	?Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
//	
//	@purpose	: help topic scripts
//	@author		: michael.slama@hp.com | michael.slama@ptk.org
//	@created	: 09-14-2005
//	@requires : helpTools.js
//	
//	@mods			:
//	
//_____________________________________________________________________________
var thePopup = null;
var xOffset = 10;
var yOffset = 20;
//_____________________________________________________________________________
//	@purpose	: capture and return mouse coordinates
//	@params		:	e - the event
//	
//	@notes		:	supports IE and Mozilla
//_____________________________________________________________________________
function getCoords(e){
	var coords = new Object();
	coords.x = 0;
	coords.y = 0;
	
	if (!e){
		var e = window.event;
	}
	/* Mozilla */	
	if (e.pageX || e.pageY){
		coords.x = e.pageX;
		coords.y = e.pageY;
	}
	/* IE */
  else if (e.clientX || e.clientY){
	  coords.x = e.clientX + (document.documentElement.scrollLeft ?
      document.documentElement.scrollLeft :
      document.body.scrollLeft);
	  coords.y = e.clientY + (document.documentElement.scrollTop ?
      document.documentElement.scrollTop :
      document.body.scrollTop);
  }
	return coords;
}
//_____________________________________________________________________________
//	@purpose	: display popup help @ mouse pointer
//	@params		:	event - the calling event
//							elem - the html element (anchor)
//							show - true to show, false to hide
//							width - (optional) a percentage or fixed width
//	
//	@notes		:	popup text is stored in a hidden DIV
//							with a munged id: elem.id + "div"
//							
//	@dev			: popup window supports html formatting
//							as defined in the xsl transform. 
//_____________________________________________________________________________
function showPopup(event,elem,show,width){
	if (!thePopup){
		thePopup = document.getElementById("popup");
	}
	thePopup.innerHTML = document.getElementById(elem.id + "div").innerHTML; 

	if (show){
		var coords = getCoords(event);
		var winWidth = (document.all ? elem.document.body.clientWidth : elem.ownerDocument.width);
		var popupWidth = (winWidth * .9);
		var x = 0;

    /* width defaults to "90%"; overrideable here */
    if (width){
      if (width.indexOf("%") != -1){
        popupWidth = (winWidth * (parseInt(width) / 100));
      }else{
        popupWidth = parseInt(width);
      }
    }
		if (popupWidth >= winWidth){
      popupWidth = (winWidth * .9);          
    }
    x = ((winWidth - popupWidth) / 2);
		if (x > coords.x){
		  x = coords.x - xOffset;
		}
		thePopup.style.width = popupWidth + "px";
		thePopup.style.left = (x < xOffset ? xOffset : x) + "px";
		thePopup.style.top = (coords.y + yOffset) + "px";
		thePopup.style.visibility = "visible";
	}else{
		thePopup.style.visibility = "hidden";
	}
}

/* end of file */
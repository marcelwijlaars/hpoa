//_____________________________________________________________________________
//
//	Help Tools 
//	Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
//	
//	@created  : 8-20-2005
//	@author   : michael.slama@hp.com | michael.slama@ptk.org
//	
//	@purpose  : general purpose methods for use with the help system.
//
//	@notes    : some of the methods contained here could be moved 
//	            to a global javascript file if useful for other systems.
//
//	@mods     : 09-17-2005 - mds: reworked getXmlActiveX() method to use
//              Http "GET" instead of [DOMDocument].load() because the
//              latter did not return the correct url when using apache's
//              content negotiation map.
//							
//              10-03-2005 - mds: added generic method for instantiating
//              the XMLHttpRequest object so support (native or activex)
//              is decided on functionality rather than browser detection. 
//							
//              10-13-205 - mds: added sortNodes() method for sorting
//              DOM nodes using their innerHTML text.
//							
//              10-18-2005 - mds: added cookie support for user-defined
//              language preferences.
//              
//              11-01-2005 - mds: added two additional try/catches for
//              instantiating different versions of activex xmlhttprequest.
//
//              10-30-2006 - mds: changed getXmlHttpObject to use msxml6
//              instead of msxml5.
//_____________________________________________________________________________  
/* constants */
var DEV_DEBUG_ON = false;
var MOZ_WIDTH_FIX = 0;
var MOZ_HEIGHT_FIX = 0;	
//_____________________________________________________________________________
//  @purpose	: simple alert method for debugging.
//  @params   : obj - the class object.
//              msg - string to display.
//  @notes		:	set debug property of obj to false 
//              to stop messages.
//_____________________________________________________________________________
function debugMsg(obj,msg){
  if (obj.debug == true){
	  alert(msg);
  }
};
//_____________________________________________________________________________
//  @purpose  : extract key value from url
//  @params   : qrystring - the 'document.location.search' string.
//              key - the key to be matched in the query string.
//              raw - set to true to prevent unescaping the value.
//              
//  @notes    : this method provides functionality similar to
//              the ASP "Response.QueryString('key')" method.
//_____________________________________________________________________________ 
function getKeyValue(qrystring, key, raw) { 	 
  var qry = qrystring.split("?")[1];
  var value = "";

  if (qry){ 
    var pairs = qry.split('&'); 
  
    for (i=0;i<pairs.length;i++) { 
      var keyval = pairs[i].split('=');
  
      if (keyval[0].toLowerCase() == key.toLowerCase()){ 
        value = (raw ? keyval[1] : unescape(keyval[1])); 
        break; 
      } 
    } 
  }
  return value;
};
//_____________________________________________________________________________
//  @purpose  : extract key value from cookie string
//  @params   : cookie - the 'document.cookie' string.
//              key - the key to be matched in the cookie.     
//  @notes    : used for user-defined language preference.
//_____________________________________________________________________________ 
function getHelpCookieValue(cookie,key){
	try{
		var cookieCrumbs = cookie.split("; ");
		
		for (var i = 0; i < cookieCrumbs.length; i++){
			var aCrumb = cookieCrumbs[i].split("=");
			
			if (aCrumb[0].toLowerCase() == key.toLowerCase()){
				return unescape(aCrumb[1]);
			}
		}
	}catch(err){
		return "";
	}
	return "";
};
//_____________________________________________________________________________
//  @purpose  : set a cookie/key value.
//  @params   : doc - the active document.
//							keyName - the retrieval key.
//							keyValue - the actual value of the key.
//  @notes    : used for user-defined language preference.
//_____________________________________________________________________________
function setHelpCookieValue(doc, keyName, keyValue, sessionOnly){
	try{
		doc.cookie = keyName + "=nothing; expires=Fri, 31 Dec 1999 23:59:59 GMT;";

		if (keyValue != null){
			if (sessionOnly){
				doc.cookie = keyName + "=" + escape(keyValue);
			}else{
				doc.cookie = keyName + "=" + escape(keyValue) + "; expires=Thu, 31 Dec 2099 23:59:59 GMT;";
			}
		}
	}catch(err){
		alert(err.message);
	}
};
//_____________________________________________________________________________
//  @purpose  : used for adjusting frame size after a window resize event
//  @params   : win - the document's window object.
//              ctlName - the name of the frame to resize.
//              leftBorder - the pixels to subtract from width.
//              bottomBorder - the pixels to subtract from height.    
//_____________________________________________________________________________  
function setNewSize(win,ctlName,leftBorder,bottomBorder){
  getNewWidth(win,ctlName,leftBorder);    
  getNewHeight(win,ctlName,bottomBorder);  
};
//_____________________________________________________________________________
//  @purpose  : used for adjusting frame height after a window resize event
//  @params   : win - the document's window object.
//              ctlName - the name of the frame to resize.
//              border - the pixels to subtract from height. 
//_____________________________________________________________________________ 
function getNewHeight(win,ctlName,border){
  if (typeof win != "undefined" && typeof ctlName == "string"){
    var windowHeight = getWindowHeight(win);
    var ctl = win.document.getElementById(ctlName);
    var ctlTop = parseInt(ctl.offsetTop);
    var borderHeight = getBorderHeight(win,border);
    
    if (windowHeight > (ctlTop + borderHeight)){
      ctl.style.height = (windowHeight - (ctlTop + borderHeight)) + "px";
    }
  }
};
//_____________________________________________________________________________
//  @purpose  : used for adjusting frame width after a window resize event
//  @params   : win - the document's window object.
//              ctlName - the name of the frame to resize.
//              border - the pixels to subtract from width. 
//_____________________________________________________________________________ 
function getNewWidth(win,ctlName,border){
  if (typeof win != "undefined" && typeof ctlName == "string"){
    var windowWidth = getWindowWidth(win);
    var ctl = win.document.getElementById(ctlName);
    var ctlLeft = parseInt(ctl.offsetLeft);
    var borderWidth = getBorderWidth(win,border);
    
    if (windowWidth > (ctlLeft + borderWidth)){
      ctl.style.width = (windowWidth - (ctlLeft + borderWidth)) + "px";
    }
  }
};
//_____________________________________________________________________________
//  @purpose  : use this to compensate for differences between IE and Mozilla
//  @params   : win - the document's window object.
//              border - the pixels to subtract from height.  
//_____________________________________________________________________________ 
function getBorderHeight(win,border){
  if (isNaN(parseInt(border))){
    return 0;
  }else{
    return (win.document.all ? border : border + MOZ_HEIGHT_FIX);
  }
};
//_____________________________________________________________________________
//  @purpose  : use this to compensate for differences between IE and Mozilla
//  @params   : win - the document's window object.
//              border - the pixels to subtract from width.   
//_____________________________________________________________________________
function getBorderWidth(win,border){
  if (isNaN(parseInt(border))){
    return 0;
  }else{
    return (win.document.all ? border : border + MOZ_WIDTH_FIX);
  }
};
//_____________________________________________________________________________
//  @purpose  : find the inner height of a window
//  @params   : win - the document's window object.
//_____________________________________________________________________________
function getWindowHeight(win){
  var theHeight = 0;
  
  if (win.innerHeight){
    theHeight = win.innerHeight;
  }else if (win.document.documentElement && win.document.documentElement.clientHeight){
    theHeight = win.document.documentElement.clientHeight;
  }else if (win.document.body){
    theHeight = win.document.body.clientHeight;
  }
  return theHeight;
};
//_____________________________________________________________________________
//  @purpose  : find the inner width of a window
//  @params   : win - the document's window object.
//_____________________________________________________________________________
function getWindowWidth(win){
  var theWidth = 0;
  
  if (win.innerWidth){
    theWidth = win.innerWidth;
  }else if (win.document.documentElement && win.document.documentElement.clientWidth){
    theWidth = win.document.documentElement.clientWidth;
  }else if (win.document.body){
    theWidth = win.document.body.clientWidth;
  }
  return theWidth;
};
//_____________________________________________________________________________
//  @purpose  : creates a generic xml-http request object
//  @returns  : struct containing object instance	and type of object:
//							 1. native - supported by browser
//							 2. activex - supported via activeX
//							returns null if not available.	
//	@notes		: Since IE7 will support native, we check for the activex first
//              because it has already been proven. This may change later. 
//_____________________________________________________________________________
function getXmlHttpObject(){		
	var httpRequest = new Object();
		
	if (window.ActiveXObject !== undefined){
	  try{			
      httpRequest.object = new ActiveXObject("MSXML2.XMLHTTP.6.0");
      httpRequest.type = "activex";
    }catch(errOcx1){
		  try{
			  httpRequest.object = new ActiveXObject("MSXML2.XMLHTTP");
			  httpRequest.type = "activex";
      }catch(errOcx2){
			  try{
				  httpRequest.object = new ActiveXObject("Microsoft.XMLHTTP");
				  httpRequest.type = "activex";
        }catch(errOcx3){
				  return null;
			  }
			}
	  }    
  }else if (window.XMLHttpRequest){
  	try{
		  httpRequest.object = new XMLHttpRequest();
		  httpRequest.type = "native";	
	  }catch(errNative){
      return null;
    }
  }else{
    return null;
  }   		
	return httpRequest;
};
//_____________________________________________________________________________
//  @purpose  : generic xml document loader.
//  @params   : xmlDocUrl - the url of the xml document.
//              lang - the accept-language to include in the Http request header.
//  @notes    : returns null on total failure.
//_____________________________________________________________________________
function getXmlDoc(xmlDocUrl,lang){
	var httpRequest = getXmlHttpObject();
	
	try{
	  /* since the GET method works the same for mozilla and ie, 
	     we don't need to check	the type of object here; only that it exists. */		
	  if (httpRequest){
		  httpRequest.object.open("GET", xmlDocUrl, false); 			
		  if (lang && (!(lang=="" || lang=="none"))){
			  httpRequest.object.setRequestHeader("Accept-Language", lang);
		  }	
		  httpRequest.object.send(null);

		  return httpRequest.object.responseXML;
	  }else{
		  return null;
	  }
	}catch(err){
	  return null;
	}
};
//_____________________________________________________________________________
//  @purpose  : forwards params to appropriate method based on 
//							result of external method (see @calls).
//  @params		: xmlDocUrl - the path to the source data.
//							xslStylesheetUrl - the path to the stylesheet.
//							doc - the active document.
//							paramArray - array of name/value pairs to be used
//							as stylesheet parameters.
//	@calls		:	getXmlHttpObject()
//	@returns	: -result of transformation on success.
//							-null on failure.
//  @notes    : if a fully developed xml-processing class is made 
//							available before release, the xml methods used here
//							can be supplanted by class methods.
//_____________________________________________________________________________
function transformXml(xmlDocUrl,xslStylesheetUrl,doc,paramArray,lang){
	var httpRequest = getXmlHttpObject();
	
	switch (httpRequest.type){
		case "native":
				return getXmlNative(httpRequest.object,xmlDocUrl,xslStylesheetUrl,doc,paramArray,lang);
			break;
		case "activex":
				return getXmlActiveX(httpRequest.object,xmlDocUrl,xslStylesheetUrl,paramArray,lang);
			break;
		default:
		  return null;
	}
};
//_____________________________________________________________________________
//  @purpose  : transform an XML document using native processor.
//  @params   : xmlHttp - an instance of a natively supported
//							XMLHttpRequest object
//							xmlDocUrl - the path to the source data.
//							xslStylesheetUrl - the path to the stylesheet.
//							doc - the active document object.   
//							paramArray - array of name/value pairs to add to stylesheet.  
//							lang - the accept-language to set in the header.  
//  @notes    : this method might work on IE7 if its native xml support meets
//							the standards.
//_____________________________________________________________________________
function getXmlNative(xmlHttp,xmlDocUrl,xslStylesheetUrl,doc,paramArray,lang){
	var xmlDoc;
	var xslStylesheet;		
	var xsltProcessor; 
	var fragment;
	var tempDiv;
	var strHtml = "";
	
	try{
	
		xsltProcessor = new XSLTProcessor();
		
		/* use parameters if provided */
		if (paramArray){
			for (var loop=0;loop<paramArray.length-1;loop+=2){
				xsltProcessor.setParameter(null,paramArray[loop],paramArray[loop+1]);
			}
		}	

		/* load the XML document - use language if provided */
		xmlHttp.open("GET", xmlDocUrl, false);
		if (lang && (!(lang=="" || lang=="none"))){
			xmlHttp.setRequestHeader("Accept-Language", lang);
		}	
		xmlHttp.send(null);

		xmlDoc = xmlHttp.responseXML;

		/* load the XSL stylesheet */
		xmlHttp.open("GET", xslStylesheetUrl, false);	
		xmlHttp.send(null);

		xslStylesheet = xmlHttp.responseXML;
		xsltProcessor.importStylesheet(xslStylesheet);

		/* transform  */
		fragment = xsltProcessor.transformToFragment(xmlDoc, doc);
		
    /* workaround used to get xml as string */
		tempDiv = doc.createElement("DIV");
		tempDiv.appendChild(fragment);
		strHtml = tempDiv.innerHTML;
	
	}catch(err){
	  if (DEV_DEBUG_ON){
		  alert("Unable to transform "+xmlDocUrl+" using getXmlNative()\n\n"+err.toString());
		}
	}		
	return strHtml;
};
//_____________________________________________________________________________
//  @purpose  : transform an XML document using IE activeX.
//  @params   : xmlHttp - instance of an activeX XmlHttp object.
//							xmlDocUrl - the path to the source data.
//							xslStylesheetUrl - the path to the stylesheet.      
//							paramArray - array of name/value pairs to add to stylesheet. 
//							lang - the accept-language to set in the header.
//_____________________________________________________________________________
function getXmlActiveX(xmlHttp,xmlDocUrl,xslStylesheetUrl,paramArray,lang){
	var strHtml = "";
	
	try{	
		/* Get source document */				
		xmlHttp.open("GET",xmlDocUrl,false);
		if (lang && (!(lang=="" || lang=="none"))){
			xmlHttp.setRequestHeader("Accept-Language", lang);
		}	
		xmlHttp.send(null);
	  
		oXml = xmlHttp.responseXML;          
		
		/* Get stylesheet document */
		var oXslt = new ActiveXObject("MSXML2.FreeThreadedDOMDocument");
		oXslt.async = false;
		oXslt.validateOnParse = false;
		
		oXslt.load(xslStylesheetUrl);			

		var oTemplate = new ActiveXObject("MSXML2.XslTemplate");
		oTemplate.stylesheet = oXslt;
		var oProcessor = oTemplate.createProcessor();
		oProcessor.input = oXml;
		
		/* use parameters if provided */
		if (paramArray){
			for(var loop=0;loop<paramArray.length-1;loop+=2){
				oProcessor.addParameter(paramArray[loop],paramArray[loop+1]);
			}
		}			
							
		/* transform */
		oProcessor.transform();		    
		strHtml = oProcessor.output;

	}catch(err){
	  if (DEV_DEBUG_ON){
		  alert("Unable to transform "+xmlDocUrl+" using getXmlActiveX()\n\n"+err.message);
		}
	}
	return strHtml;		
};
//_____________________________________________________________________________
//  @purpose  : perform sort on DOM nodes using innerHTML text.
//  @params   : nodeArray - an array of nodes that have
//							parentNode and innerHTML properties.
//  @notes    : must be at least 2 nodes in the nodeArray or 
//							nothing is changed.
//							referencing errors are skipped silently. 
//_____________________________________________________________________________
function sortNodes(nodeArray){
	/* not interested in sorting less than 2 items */		
	if (nodeArray && nodeArray.length > 1){
		var parentElements = new Array(nodeArray.length-1);
		var sortedNodes = new Array(nodeArray.length-1);
		var i;
		
		for (i=0;i<nodeArray.length;i++){
			try{
				var thisNode = new Array();
				thisNode[0] = nodeArray[i].innerHTML;
				thisNode[1] = nodeArray[i];
				sortedNodes[i] = thisNode;
				parentElements[i] = nodeArray[i].parentNode;
			}catch(errInit){/* resume */}
		}
		
		/* nodes are loaded, now sort by innerHTML */
		sortedNodes.sort();
		
		/* swap node positions */
		for (i=0;i<parentElements.length;i++){		
			try{
				parentElements[i].appendChild(sortedNodes[i][1]);	
			}catch(errAppend){/* resume */}		
		}
	}
};

/* end of file */
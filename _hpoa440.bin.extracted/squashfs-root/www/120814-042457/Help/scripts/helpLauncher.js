/* host pages */
HelpLauncher.FullHelpPage = "/120814-042457/Help/emHelp.html";
HelpLauncher.ProcedureHelpPage = "/120814-042457/Help/emHelpMini.html";
HelpLauncher.ReferenceHelpPage = "/120814-042457/Help/emHelpMini.html";
HelpLauncher.ContextHelpPage = "/120814-042457/Help/emHelp-Context.html";
HelpLauncher.AboutPage = "/120814-042457/Help/AboutPage.html";

/* localized xml documents */
HelpLauncher.ContextSource = "/120814-042457/Help/help-context.var";

/* switches */
HelpLauncher.LanguageKey = "UserPref-Language";
//_____________________________________________________________________________
//
//	Help Launcher Class  
//	Copyright 2006-2014 Hewlett-Packard Development Company, L.P. 
//	
//	@created  : 09-25-2005
//	@author   : michael.slama@hp.com
//	
//	@purpose  : lightweight class for launching help windows
//
//	@notes    : This class should be loaded at the top-level of
//	            the application and a getter for exposing it
//	            should be provided:
//	            
//	            var ourHelpLauncher = null;
//	            
//	            function getHelpLauncher(){
//	              if (typeof(HelpLauncher) != "undefined" && ourHelpLauncher == null){
//	                ourHelpLauncher = new HelpLauncher();
//	              }
//	              return ourHelpLauncher;
//	            };
//	            
//  @examples  : When a page loads or a control receives focus,
//               its context id needs to be set so the correct topic
//               can be loaded when the user clicks the context help
//               button. The onload() or onfocus() event could be:
//                
//                top.getHelpLauncher().setCurrentTopic("FORM_SVB_SUMMARY");
//                
//               Then, the context help button's onclick() event will be
//               as simple as:
//               
//                top.getHelpLauncher().openContextHelp();
//	
//	@mods				: 10-18-2005 - mds: added cookie support for detecting
//								user-defined language preference, and passing to 
//								popup windows as search-string key/value pair.
//                03-27-2006 - mds: forced focus to popup windows so open
//                windows would be brought to the front if "re-opened."
//
//                02-23-2007 - mds: allowed about dialog to be resizable for
//                rqm issue 312724.
//_____________________________________________________________________________
function HelpLauncher(){
  this.acceptLanguage = "";
  this.contextKey = "";
  this.currentTopicId = 0;
  this.embeddedTopicId = 0;
  this.contextNodes = this.loadContextNodes();
  this.contextNodesEmbedded = this.loadContextNodes(true);
  this.debug = false; /* make sure this is false for release! */
};
//_____________________________________________________________________________
//  @purpose  : store localized context-id key values.
//  @notes    : allows each language to use different
//							topic-id values for context-sensitive
//							help if necessary.
//
//  @fixes    : added language argument so cookie-based setting works (bug).
//_____________________________________________________________________________
function _loadContextNodes(embedded){
  var xmlDoc = null;

  if (embedded == true && this.acceptLanguage != "en"){
    xmlDoc = getXmlDoc(HelpLauncher.ContextSource.replace("help-context.var", "en/help-context.xml"));
  }else{
	  xmlDoc = getXmlDoc(HelpLauncher.ContextSource, this.getLanguage());
    if (xmlDoc){
      this.acceptLanguage = xmlDoc.documentElement.getAttribute("xml:lang");
    }
  }
	if (xmlDoc){
		return xmlDoc.getElementsByTagName("context");
	}
  return null;
}
//_____________________________________________________________________________
//  @purpose  : getter for context-id values matching
//							"key" constant. See HelpLauncher.ContextSource.
//  @params		: key = the xml key to match.
//              embedded (boolean) true to use the embedded context nodes.
//  @notes    : if a localized context-id isn't found,
//							the original key is returned.
//	@dev			: if the app uses lookup keys for each 
//							context, the actual context-id's can 
//							change without changing the code.							 
//_____________________________________________________________________________
function _getContextIdFromKey(key, embedded){
  this.contextKey = key;
  var contextNodes = null;

  if (embedded == true && this.contextNodesEmbedded){
    contextNodes = this.contextNodesEmbedded;
  }else{
    contextNodes = this.contextNodes;
  }
  if (contextNodes){
		for (var i=0;i<this.contextNodes.length;i++){
			if (contextNodes[i].getAttribute("key") == key){
				return contextNodes[i].firstChild.nodeValue;
			}
		}		
	}
	return key;	
}
//_____________________________________________________________________________
//	@purpose	: assign currently valid context topic
//	@params		: contextId - numeric id of help topic
//_____________________________________________________________________________
function _setCurrentTopic(contextId){
  this.currentTopicId = this.getContextIdFromKey(contextId);

  if (this.acceptLanguage != "en"){
    this.embeddedTopicId = this.getContextIdFromKey(contextId, true);
  }
  debugMsg(this, "Context set to: "+this.currentTopicId+" derived from: "+contextId);
};
//_____________________________________________________________________________
//	@purpose	: sets a cookie for user-defined language preference
//	@params		: doc - (Optional) the active document.
//							lang - the localized language id ("en-us","fr","es",etc.)
//_____________________________________________________________________________
function _setLanguageCookie(doc,lang){
	setHelpCookieValue((doc ? doc : document),HelpLauncher.LanguageKey,lang,false);
};
//_____________________________________________________________________________
//	@purpose	: removes the language preference cookie
//	@params		: doc - (Optional) the active document.
//_____________________________________________________________________________
function _removeLanguageCookie(doc){
	setHelpCookieValue((doc ? doc : document),HelpLauncher.LanguageKey,null);
};
//_____________________________________________________________________________
//	@purpose	: retrieves user-defined language preference
//	@params		: doc - (Optional) the active document.
//	@notes		:	if we're in a popup window, we might not be able
//							to read the cookie, so we'll get the language from 
//							the location.search string instead.
//_____________________________________________________________________________
function _getLanguage(doc){
	var lang = getHelpCookieValue((doc ? doc.cookie : document.cookie),HelpLauncher.LanguageKey);
	if (lang == ""){
		lang = getKeyValue(location.search, "lang");
	}
	return lang;
};
//_____________________________________________________________________________
//	@purpose	: open simple context help window
//	@params		:	contextId - (optional) the topic id currently in scope.
//              useMoreLink (optional) true to add "More Help" link.
//	@notes		:	the setCurrentTopic() method will normally be called before this
//	            method is called. If needed, the contextId can be passed here
//	            instead
//_____________________________________________________________________________
function _openContextHelp(contextId,useMoreLink){
  var w = 585;
  var h = 600;
  var useMoreArg = '';
  var embeddedId = '';
  
  var coords = getCenteredOffset(w,h);
  
  /* create options list */
  var optionsList = "top="+coords.y+",left="+coords.x+",width="+w+",height="+h+
      ",status=no,resizable=yes,scrollbars=yes";

  if (!contextId){
    contextId = this.currentTopicId;
    embeddedId = this.embeddedTopicId;
  }else{
    contextId = this.getContextIdFromKey(contextId);
    embeddedId = this.getContextIdFromKey(contextId, true);
  }
  
  if (useMoreLink == true){
    useMoreArg = "&morelink=true";
  }
  
  if (this.debug){
    alert('opening context help with id: '+contextId);
  }

  /* launch the popup window and return reference */
  var win = window.open(HelpLauncher.ContextHelpPage+"?context-id="+contextId+
    "&embedded-id="+embeddedId+"&lang="+this.getLanguage()+
    useMoreArg,'_helpContext', optionsList);	  
	win.focus();
	return win;
};
//_____________________________________________________________________________
//	@purpose	: open procedural topic using mini help window
//	@params		: procedureId - numeric or string id associated with
//	            a prodecural help topic.
//_____________________________________________________________________________
function _openProcedureHelp(procedureId){
  var w = 975;
  var h = 600;
  
  var coords = getCenteredOffset(w,h);
  
  /* create options list */
  var optionsList = "top="+coords.y+",left="+coords.x+",width="+w+",height="+h+
      ",status=yes,resizable=yes,scrollbars=yes";

	/* launch the popup window and return reference */
	var win = window.open(HelpLauncher.ProcedureHelpPage+"?procedure-id="+procedureId+
									"&lang="+this.getLanguage(),'_helpProc'+procedureId, optionsList);									
	win.focus();
	return win;
};
//_____________________________________________________________________________
//	@purpose	: open reference topic using mini help window
//	@params		: referenceId - numeric or string id associated with
//	            a reference help topic.
//_____________________________________________________________________________
function _openReferenceHelp(referenceId){
  var w = 975;
  var h = 600;
  
  var coords = getCenteredOffset(w,h);
  
  /* create options list */
  var optionsList = "top="+coords.y+",left="+coords.x+",width="+w+",height="+h+
      ",status=yes,resizable=yes,scrollbars=yes";
  
  /* launch the popup window and return reference */
  var win = window.open(HelpLauncher.ReferenceHelpPage+"?reference-id="+referenceId+
										"&lang="+this.getLanguage(),'_helpRef'+referenceId, optionsList);	
	win.focus();
	return win;
};
//_____________________________________________________________________________
//	@purpose	: launch the full 3-tabbed help window
//	@params		: 
//	@notes		:	open using querystring where: ?type=contents | index | search
//_____________________________________________________________________________
function _openFullHelp(type){
  var w = 1000;
  var h = 650;
  
  var coords = getCenteredOffset(w,h);
  
  /* create options list */
  var optionsList = "top="+coords.y+",left="+coords.x+",width="+w+",height="+h+
      ",status=yes,resizable=yes,scrollbars=yes";
  
  if (!type){
    type = "contents";
  }
  
  /* launch the popup window and return reference */
  var win = window.open(HelpLauncher.FullHelpPage+"?type="+type+
										"&lang="+this.getLanguage(),'_helpMain', optionsList);	
	win.focus();
	return win;
};
//_____________________________________________________________________________
//	@purpose	: launch the about window as a centered popup
//_____________________________________________________________________________
function _openAbout(useDOM){
  /* fixed dimensions */
	var w = (document.all ? 500 : 504);
	var h = 380;
	var win;
	
  var coords = getCenteredOffset(w,h,useDOM);
  
  /* create options list */
  var optionsList = "top="+coords.y+",left="+coords.x+",width="+w+",height="+h+
      ",location=no,menubar=no,status=no,resizable=yes,scrollbars=no";
      
  if (useDOM == true){
    win = document.createElement("iframe");
    win.setAttribute("src", HelpLauncher.AboutPage);
    win.id = "iframeAbout";    
    win.className = "about";
    win.style.width = w+"px";
    win.style.height = h+"px";
    win.scrolling = "no";
    win.style.top = coords.y;
    win.style.left = coords.x;
    document.body.appendChild(win);   
  }else{      
    /* launch the popup window and return reference */
    win = window.open(HelpLauncher.AboutPage+"?lang="+this.getLanguage(),"_about_", optionsList);  
    win.focus();
  }
  return win;
};

/* HelpLauncher Prototypes */
HelpLauncher.prototype.setLanguageCookie = _setLanguageCookie;
HelpLauncher.prototype.removeLanguageCookie = _removeLanguageCookie;
HelpLauncher.prototype.getLanguage = _getLanguage;
HelpLauncher.prototype.loadContextNodes = _loadContextNodes;
HelpLauncher.prototype.getContextIdFromKey = _getContextIdFromKey;
HelpLauncher.prototype.setCurrentTopic = _setCurrentTopic;
HelpLauncher.prototype.openContextHelp = _openContextHelp;
HelpLauncher.prototype.openProcedureHelp = _openProcedureHelp;
HelpLauncher.prototype.openReferenceHelp = _openReferenceHelp;
HelpLauncher.prototype.openFullHelp = _openFullHelp;
HelpLauncher.prototype.openAbout = _openAbout;

/* Helper Methods */
//_____________________________________________________________________________
//	@purpose	: calculate the top and left edge of a centered window
//	@params   : w - the width of the window
//	            h - the height of the window
//              useDOM - boolean, true to measure app window instead of the screen.
//	@returns  : coords - object with x and y properties.
//_____________________________________________________________________________
function getCenteredOffset(w,h,useDOM){
  var coords = new Object();
  
  /* set defaults */
  coords.x = 50;
  coords.y = 50;
  
  w = parseInt(w);
  h = parseInt(h);

  if (!isNaN(w)){ 
    if (useDOM && top.mainPage){
      coords.x = (top.mainPage.document.body.offsetWidth / 2) - (w / 2);
    }else if (screen.availWidth){
      coords.x = (screen.availWidth / 2) - (w / 2);
    }   
  }  
  if (!isNaN(h)){  
    if (useDOM && top.mainPage){
      coords.y = (top.mainPage.document.body.offsetHeight / 2) - (h / 2);
    }else if (screen.availHeight){
      coords.y = (screen.availHeight / 2) - (h / 2);
    }
  }
  return coords;
};
//_____________________________________________________________________________
//	@purpose	: attach leading zeros to a number
//	@params   : aNumber - valid integer.
//	            length - the total length of the formatted number.
//	@returns  : number formatted as: "00001"
//_____________________________________________________________________________
function padNumber(aNumber,length){
  var paddedNumber = aNumber + "";
  
  while (paddedNumber.length < length){
    paddedNumber = "0" + paddedNumber;
  }
  return paddedNumber;
};

/* end of file */

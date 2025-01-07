/* language-independent core pages */
HelpManager.HelpContents = "/120814-042457/Help/emHelp-Tree.html";
HelpManager.HelpIndex = "/120814-042457/Help/emHelp-Index.html";
HelpManager.HelpSearch = "/120814-042457/Help/emHelp-Search.html";
HelpManager.HelpProcedure = "/120814-042457/Help/emHelpMini-Tree.html";
HelpManager.HelpReference = "/120814-042457/Help/emHelpMini-Tree.html";
HelpManager.HelpContext = "/120814-042457/Help/emHelp-Context.html";
HelpManager.Error404Page = "/120814-042457/Help/error404.html";

/* language-independent templates or stylesheets */
HelpManager.TocTemplate = "/120814-042457/Help/stylesheets/help-contents.xsl";
HelpManager.IndexTemplate = "/120814-042457/Help/stylesheets/help-index.xsl";
HelpManager.SearchTemplate = "/120814-042457/Help/stylesheets/help-search.xsl";
HelpManager.ProcTemplate = "/120814-042457/Help/stylesheets/help-procedure.xsl";
HelpManager.RefTemplate = "/120814-042457/Help/stylesheets/help-reference.xsl";
HelpManager.ContextTemplate = "/120814-042457/Help/stylesheets/help-context.xsl";

/* localized xml documents */
HelpManager.HomePage = "/120814-042457/Help/home-page.var"; 
HelpManager.TocSource = "/120814-042457/Help/help-contents.var"; 
HelpManager.IndexSource = "/120814-042457/Help/help-index.var";
HelpManager.ProcSource = "/120814-042457/Help/help-procedures.var";
HelpManager.RefSource = "/120814-042457/Help/help-references.var";
HelpManager.StringsSource = "/120814-042457/Help/help-strings.var";

/* switches */
HistoryManager.PreviousButton = 1;
HistoryManager.NextButton = 2;
HistoryManager.Ignore = 3;
//_____________________________________________________________________________
//
// Help Manager Class
//	?Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
//	
//	@created  : 8-27-2005
//	@author   : michael.slama@hp.com
//	
//	@purpose  : Client-Side XML/XSLT Help System
//
//	@notes    : This class should be loaded at the top-level of a
//	            frameset-based page so each of the framed documents
//	            can share its resources.
//	@mods     :	
//
//  @depends	: helpTools.js
//
//  @dev      : 
//
//_____________________________________________________________________________
function HelpManager(variableName,queryString){
  this.acceptLanguage = "";
  this.instanceName = variableName;
  this.queryString = queryString;
  this.language = this.getLanguage();  
  this.searchManager = new SearchManager();
  this.searchString = "";
  this.directoryFrame = null;
  this.directoryContainer = null; 
  this.contentFrame = null;   
  this.contentContainer = null;
  this.titleContainer = null;  
  this.headingContainer = null;
  this.openTreeMethod = null;
  this.closeTreeMethod = null; 
  this.synchDirectoryMethod = null;  
  this.stringNodes = this.loadStrings();
  this.debug = false;  /* set to false for release */
};

/* Expose Inner Class */
function _getSearchManager(){
  return this.searchManager;
};

/* HelpManager Methods */

//_____________________________________________________________________________
//  @purpose  : store localized string doc for GUI use.
//  @notes    : core pages will need localized strings
//							for fixed captions on buttons, etc.
//_____________________________________________________________________________
function _loadStrings(){
	var xmlDoc = getXmlDoc(HelpManager.StringsSource,this.language);
	if (xmlDoc){
    if (this.acceptLanguage == ""){
      this.acceptLanguage = xmlDoc.documentElement.getAttribute("xml:lang");
    }
		return xmlDoc.getElementsByTagName("value");
	}
};
//_____________________________________________________________________________
//  @purpose  : getter for localized strings.
//  @params		: key - the xml key to match.
//_____________________________________________________________________________
function _getString(key){
	if (this.stringNodes){
		for (var i=0;i<this.stringNodes.length;i++){
			if (this.stringNodes[i].getAttribute("key") == key){
				return this.stringNodes[i].firstChild.nodeValue;
			}
		}		
	}
	return "[not found]";
};
//_____________________________________________________________________________
//  @purpose  : localizes text for loaded elements
//  @params		: elements - array of elements having "langId"
//							custom attribute.
//  @notes    : -span elements are good placeholders for inline text.
//							-the id attribute isn't necessary if using 
//							getElementsByTagName("SPAN") to capture elements.
//							-only elements with the "langId" attribute are 
//							processed here.
//_____________________________________________________________________________
function _localizeStrings(elements){
	for (var i=0;i<elements.length;i++){
		if (elements[i].getAttribute("langId") != null){
			elements[i].innerHTML = this.getString(elements[i].getAttribute("langId"));
		}
	}
};
//_____________________________________________________________________________
//  @purpose  : retrieves key value matching "lang"
//  @notes    : only available if a user sets the
//							language preference from the Web gui.
//_____________________________________________________________________________
function _getLanguageFromQueryString(){
	return getKeyValue(this.getQueryString(),"lang");
};
//_____________________________________________________________________________
//  @purpose  : assign frame for help directory documents.
//  @params   : ctl - frame element.
//  @notes    : this frame's location is replaced for each
//              of the directory types: contents,index,search.
//_____________________________________________________________________________
function _setDirectoryFrame(ctl){
  if (isFrame(ctl)){
    this.directoryFrame = ctl;
  }
};
//_____________________________________________________________________________
//  @purpose  : assign container for xsl result links.
//  @params   : ctl - iframe element.
//_____________________________________________________________________________
function _setDirectoryContainer(ctl){
	if (typeof ctl != "undefined"){
		this.directoryContainer = ctl;
	}
};
//_____________________________________________________________________________
//  @purpose  : assign frame for topic document.
//  @params   : ctl - frame element.
//  @notes    : this frame's src property doesn't need to change.
//_____________________________________________________________________________
function _setContentFrame(ctl){
  if (isFrame(ctl)){
    this.contentFrame = ctl;
  }
};
//_____________________________________________________________________________
//  @purpose  : assign container for help output.
//  @params   : ctl - iframe element.
//_____________________________________________________________________________
function _setContentContainer(ctl){
  if (isFrame(ctl)){
    this.contentContainer = ctl;
  }
};
//_____________________________________________________________________________
//  @purpose  : assign a container for header text (procedure or reference help).
//  @params   : ctl - an html element that supports the innerHTML property.
//_____________________________________________________________________________
function _setHeadingContainer(ctl){
  if (typeof ctl != "undefined"){
    this.headingContainer = ctl;
  }
};
//_____________________________________________________________________________
//  @purpose  : assign a container for each help topic's title.
//  @params   : ctl - an html element that supports the innerHTML property.
//_____________________________________________________________________________
function _setTitleContainer(ctl){
  if (typeof ctl != "undefined"){
    this.titleContainer = ctl;
  }
};
//_____________________________________________________________________________
//  @purpose  : access to the main doucument's url search string.
//  @returns  : entire search string including the "?" 
//  
//  @notes    : the class supports these key/value arguments:
//              key: type
//              values: contents | index | search | procedure | reference
//              key: context-id
//              values: unique topic-id
//              key: procedure-id
//              values: unique procedure-d
//              key: reference-id
//              values: unique reference-id
//              key: lang
//              values: "en" | "es" | "fr" [...]
//_____________________________________________________________________________
function _getQueryString(){
  if (this.queryString == undefined || this.queryString == null){
    return "";
  }else{
    return this.queryString;
  }
};
//_____________________________________________________________________________
//  @purpose  : determine which document to load in left link pane.
//  @params		: helpType - see initDirectory() notes.
//  @returns  : pre-defined document url for content | index | search.
//							could be used for procedure and reference as well.  
//  @notes    : decision is based on search string first, or defaults
//              to the contents document if no type is requested.
//  @dev			: This may be updated to support a "toc" argument
//							so specific TOC documents can be requested.
//_____________________________________________________________________________
function _getDirectoryDocument(helpType){
  if (!helpType){
    helpType = getKeyValue(this.queryString,"type");
  }
  
  switch(helpType){
		case "reference":
			return HelpManager.HelpReference;
			break;
		case "procedure":
			return HelpManager.HelpProcedure;
			break;
    case "index":
      return HelpManager.HelpIndex;
      break;
    case "search":
      return HelpManager.HelpSearch;
      break;
    case "contents":
    default:
      return HelpManager.HelpContents; 
  }
};
//_____________________________________________________________________________
//  @purpose  : assigns appropriate source to directory frame 
//  @params		: type - one of the supported directory types (see notes).
//  @notes    : call this method using these arguments:
//              1. "index" - force the index page to load.
//              2. "search" - force the search page to load.
//              3. "contents" - force the contents page to load.
//              4. null - allow the class to use the location search
//                 string to decide which page to load.
//_____________________________________________________________________________
function _initDirectory(type){
  if (this.directoryFrame){
		/* use replace so this frame doesn't get added to history */
    this.directoryFrame.contentWindow.location.replace(this.getDirectoryDocument(type));
  }
};
//_____________________________________________________________________________
//  @purpose  : update the title above the scrolling content iframe  
//  @params		: title - string value.
//  @notes    : the titleContainer must be assigned first.
//_____________________________________________________________________________
function _setTitle(title){
  if (this.titleContainer && title){
    this.titleContainer.innerHTML = title;
  }
};
//_____________________________________________________________________________
//  @purpose  : update the masthead text  
//  @params		: heading - string value.
//  @notes    : the headingContainer must be assigned first.
//_____________________________________________________________________________
function _setMastheadText(heading){
  if (this.headingContainer && heading){
		this.headingContainer.innerHTML = heading;
  }
};
//_____________________________________________________________________________
//  @purpose  : load the first topic in the directory.  
//  @notes    : the contentContainer must be assigned first.
//							the topic file will call "loadTopic" after
//							it is loaded to add itself to history.
//_____________________________________________________________________________
function _initTopic(doc){
	if (this.contentContainer){
		/* try to get first topic in directory */
		var anchors = doc.getElementsByTagName("A");
		if (anchors.length > 0){
			url = anchors[0].getAttribute("href");
			this.contentContainer.src = anchors[0].getAttribute("href");
		}else{
			/* didn't find a topic in the directory, load default page */
			this.initHomePage();
		}	
	}
};
//_____________________________________________________________________________
//  @purpose  : load the localized home help page  
//  @notes    : the contentContainer must be assigned first.
//							the topic file will call "loadTopic" after
//							it is loaded to add itself to history.
//_____________________________________________________________________________
function _initHomePage(){
	if (this.contentContainer){
		var homePage = getXmlDoc(HelpManager.HomePage,this.language);
		if (homePage){
			var src = homePage.getElementsByTagName("source");			
			if (src.length > 0){
				this.contentContainer.src = 
					(src[0].text == null ? src[0].textContent : src[0].text);
			}
		}
	}
};
//_____________________________________________________________________________
//  @purpose  : set title and add topic to managed history.  
//  @params		: url - xml file with attached stylesheet.
//							id - unique topic id.
//  @notes    : 
//_____________________________________________________________________________
function _loadTopic(url,title,id){  
  if (isValidString(url)){
		var historyMgr = this.searchManager.getHistoryManager();
		
		if (historyMgr.history.length == 0){
		  this.synchDirectory(id, false); 
		}		
		if ((historyMgr.addTopic(url,title,id)) != HistoryManager.Ignore){
	    if (url.indexOf("#") != -1){
        this.loadHashUrl(url,title);
	    }else{
	      this.setTitle(title);
	    }
		}
  }
};
//_____________________________________________________________________________
//  @purpose  : print the active content page.  
//  @notes    : the contentFrame and contentContainer must be assigned first.
//_____________________________________________________________________________
function _printContent(){
  if (this.contentFrame && this.contentContainer){   
    top.frames[this.contentFrame.id].frames[this.contentContainer.id].focus(); //needed for IE
    top.frames[this.contentFrame.id].frames[this.contentContainer.id].print();
  }
};
//_____________________________________________________________________________
//  @purpose  : wrapper for a method pointer.  
//  @notes    : openTreeMethod pointer must be set first.
//_____________________________________________________________________________
function _openTree(){
	if (this.openTreeMethod != null){
		this.openTreeMethod();
	}
};
//_____________________________________________________________________________
//  @purpose  : wrapper for a method pointer.
//  @notes    : closeTreeMethod pointer must be set first.
//_____________________________________________________________________________
function _closeTree(){
	if (this.closeTreeMethod != null){
		this.closeTreeMethod();
	}
};
//_____________________________________________________________________________
//  @purpose  : wrapper for a method pointer.
//  @params		: id - unique id of anchor element in tree.
//							hightLightOnly - dont expand tree if true.
//  @notes    : synchTreeMethod pointer must be set first.
//_____________________________________________________________________________
function _synchDirectory(id,highLightOnly){
	if (this.synchDirectoryMethod != null){
		this.synchDirectoryMethod(id,highLightOnly);

    // scroll the link into view
		var doc = (this.directoryContainer.document ? 
		  this.directoryContainer.document : 
		  this.directoryContainer.ownerDocument);
		  
		var win = (doc.parentWindow ? doc.parentWindow : 
		  (doc.defaultView ? doc.defaultView : doc.contentWindow));
		
	  if (win){
		  win.location.hash = id;
		}
	}
}
//_____________________________________________________________________________
//  @purpose  : assigns xml output from transformation to directory container.  
//              output controlled by HelpManager.TocTemplate.
//  @params   : activeDocument - container's document object.
//  @notes    : directoryContainer must be assigned first.
//_____________________________________________________________________________
function _loadContentsTree(activeDocument){
	if (this.directoryContainer){	
		this.directoryContainer.innerHTML = 
			transformXml(HelpManager.TocSource,HelpManager.TocTemplate,activeDocument,null,this.language);
	}
};
//_____________________________________________________________________________/
//  @purpose  : determines if a procedure-id or reference-id exists in the query string,
//              then passes the params to the proper method.  
//  @params   : activeDocument - container's document object.
//  @notes    : if no key value found in query string, a full TOC is loaded.
//_____________________________________________________________________________
function _loadFilteredTree(activeDocument){
  var procId = getKeyValue(this.getQueryString(),"procedure-id");
  var refId = getKeyValue(this.getQueryString(),"reference-id");
  
  if (procId != ""){
    this.loadProcedureTree(activeDocument, procId);
  }else if (refId != ""){
    this.loadReferenceTree(activeDocument, refId);
  }else{
    this.loadContentsTree(activeDocument);
  }
};
//_____________________________________________________________________________
//  @purpose  : assigns xml output from transformation to directory container.  
//              output controlled by HelpManager.ProcTemplate.
//  @params   : activeDocument - container's document object.
//              procId - the procedure-id of the topic.
//  @notes    : directoryContainer must be assigned first.
//							the TOC will contain only those topics with
//							the specified procedure-id.
//_____________________________________________________________________________
function _loadProcedureTree(activeDocument, procId){
	if (this.directoryContainer){
		var strOutput = "";
		/* create parameter argument */
		var procInfo = new Array();
		procInfo[0] = "procedure-id";
		procInfo[1] = procId;

		strOutput = transformXml(HelpManager.ProcSource,
					HelpManager.ProcTemplate,activeDocument,procInfo,this.language);
	  
		this.directoryContainer.innerHTML = 
				(strOutput.indexOf("treeSelectableLink") == -1 ? "&nbsp;Procedure "+procId+" not found" : strOutput);
	}
};
//_____________________________________________________________________________
//  @purpose  : assigns xml output from transformation to directory container.  
//              output controlled by HelpManager.RefTemplate.
//  @params   : activeDocument - container's document object.
//              refId - the reference-id of the topic.
//  @notes    : directoryContainer must be assigned first.
//							the TOC will contain only those topics with
//							the specified reference-id.
//_____________________________________________________________________________
function _loadReferenceTree(activeDocument, refId){
	if (this.directoryContainer){
		var strOutput = "";
		/* create parameter argument */
		var refInfo = new Array();
		refInfo[0] = "reference-id";
		refInfo[1] = refId;

		strOutput = transformXml(HelpManager.RefSource,
					HelpManager.RefTemplate,activeDocument,refInfo,this.language);
		this.directoryContainer.innerHTML = 
				(strOutput.indexOf("treeSelectableLink") == -1 ? "&nbsp;Reference "+refId+" not found" : strOutput);
	}
};
//_____________________________________________________________________________
//  @purpose  : assigns xml output from transformation to directory container.
//              output controlled by HelpManager.IndexTemplate
//  @params   : activeDocument - container's document object.
//  @notes    : directoryContainer must be assigned first.
//_____________________________________________________________________________
function _loadIndexList(activeDocument){
	if (this.directoryContainer){		
		this.directoryContainer.innerHTML = 
			transformXml(HelpManager.IndexSource,HelpManager.IndexTemplate,activeDocument,null,this.language);
	}
};
//_____________________________________________________________________________
//  @purpose  : assigns xml output from transformation to directory container.
//              output controlled by HelpManager.SearchTemplate
//  @params   : activeDocument - container's document object.
//  @calls		: helpTools.sortNodes()
//  @notes    : directoryContainer and searchString must be assigned first.
//              the searchString is passed to the xslt processor as a parameter.
//  @dev			: the xsl stylesheet performs a case-insensitive comparison using
//							the translate() method, which was used because the current xslt
//							processors still don't support lower-case() or upper-case() methods.
//							
//							the english alphabet was included in the translate() call, but
//							localized versions of the application may want/need to include
//							other characters. This is only applicable to case-insensitive
//							searches, since exact matches will still work regardless of 
//							the localized text.	See the "HelpManager.SearchTemplate" file
//							to determine which characters are currently supported.
//_____________________________________________________________________________
function _loadSearchResults(activeDocument){
	if (this.directoryContainer){
		if (this.searchString != ""){
		  var strOutput = "";
		  /* create search parameter argument */
		  var searchString = new Array();
		  searchString[0] = "searchString";
		  searchString[1] = this.searchString;
		  
		  strOutput = transformXml(HelpManager.TocSource,
					 HelpManager.SearchTemplate,activeDocument,searchString,this.language)
		  this.directoryContainer.innerHTML = 
					(strOutput.indexOf("href=") == -1 ? "&nbsp;No matches found" : strOutput);
			
			/* xsl isn't capable of easily sorting nested attributes. attempt
			   a client-side sort here by calling an external sort routine */				 
			sortNodes(activeDocument.getElementsByTagName("A"));
		}
	}
};
//_____________________________________________________________________________
//  @purpose  : assigns xml output from transformation to context page container.
//              output controlled by HelpManager.ContextTemplate
//  @params   : activeDocument - the document containing the contentContainer.
//  @notes    : contentContainer and queryString must be assigned first.
//              the topicId is passed to the xslt processor as a parameter.
//_____________________________________________________________________________
function _loadContextTopic(activeDocument){
  var EMBED_LANGUAGE = "en";
  var EMBED_CONTENTS = "en/help-contents.xml";
	var errMsg = "";

	if (this.contentContainer){
		if (this.getQueryString() != ""){
		  var theXmlDoc = "";
		  /* create topicId parameter argument */
		  var topicId = new Array();
		  topicId[0] = "topicId";
		  topicId[1] = getKeyValue(this.getQueryString(),"context-id");
		  
		  if (this.debug == true){
        alert("Loading topic-id of: "+topicId[1]);
      }      
			if (topicId[1] != ""){
				theXmlDoc = transformXml(HelpManager.TocSource,
						 HelpManager.ContextTemplate,activeDocument,topicId,this.language);
			}
      /* if we didn't get a topic in an installed language, try the embedded language */
			if (theXmlDoc == "" && (this.acceptLanguage != EMBED_LANGUAGE)){
        topicId[1] = getKeyValue(this.getQueryString(), "embedded-id");

        theXmlDoc = transformXml(HelpManager.TocSource.replace("help-contents.var", EMBED_CONTENTS),
						 HelpManager.ContextTemplate,activeDocument,topicId,EMBED_LANGUAGE);
      }
      if (theXmlDoc == ""){
        errMsg = this.getString("topic")+" "+topicId[1]+" "+
								  this.getString("notfound")+", "+
								  this.getString("tryAgain")+".";
			  if (this.debug == true){
			    this.contentContainer.src = HelpManager.Error404Page+"?error="+
															escape(errMsg)+"&type=error";
		    }else{
		      this.initHomePage();
		    }				
			}else{
			  this.contentContainer.src = theXmlDoc;
			}
		}
	}
};
//_____________________________________________________________________________
//  @purpose  : apply a hash link to a page (if loaded) or just apply the url. 
//  @params   : url - full href
//              title - the topic title
//              id - unique topic id
//_____________________________________________________________________________
function _loadHashUrl(url,title){
  this.setTitle(title);
  if (this.contentContainer){
    var loc = url.split("#")
    var path = loc[0];
    var hash = loc[1];
    if (this.contentContainer.contentWindow.location.href.indexOf(path) == -1){
      this.contentContainer.contentWindow.location.href = url;
    }else{    
      var anchor = this.contentContainer.contentWindow.document.getElementById(hash);
      if (anchor){ 
        this.contentContainer.contentWindow.scrollTo(0,anchor.offsetTop);
      }		      
    }	
  }
};
//_____________________________________________________________________________
//  @purpose  : change content window to its previous url, if any. 
//  @notes    : this feature only used in full help window.
//_____________________________________________________________________________
function _goBack(){
  if (this.contentContainer){
    //this.contentContainer.contentWindow.history.back();  <-- use built-in history
    var prevTopic = this.searchManager.getHistoryManager().getPrevious();
    
    if (prevTopic.url.length > 0){    
      if (prevTopic.url.indexOf("#") != -1){     
        this.loadHashUrl(prevTopic.url, prevTopic.title); 			   
      }else{
        this.contentContainer.contentWindow.location.href = prevTopic.url;
      }
      this.synchDirectory(prevTopic.id, false);
    } 
  }
};
//_____________________________________________________________________________
//  @purpose  : change content window to its next url, if any.
//  @notes    : this feature only used on full help window.
//_____________________________________________________________________________
function _goNext(){
  if (this.contentContainer){
    //this.contentContainer.contentWindow.history.forward(); <-- use built-in history
    var nextTopic = this.searchManager.getHistoryManager().getNext();

    if (nextTopic.url.length > 0){
      if (nextTopic.url.indexOf("#") != -1){ 
        this.loadHashUrl(nextTopic.url, nextTopic.title);		   
      }else{
        this.contentContainer.contentWindow.location.href = nextTopic.url;
      }
      this.synchDirectory(nextTopic.id, false);
    }
  }
};
/* SearchManager Class */
function SearchManager(){
  this.historyManager = new HistoryManager();
  this.phrases = new Array();
  this.searchSelect = null;
};

/* Expose Inner Class */
function _getHistoryManager(){
  return this.historyManager;
};

/* SearchManager methods */

//_____________________________________________________________________________
//  @purpose  : assigns a select control for use as a search phrase selector  
//  @params   : ctl - html select element.
//  @notes    : 
//_____________________________________________________________________________
function _setSearchSelect(ctl){
  if (isSelect(ctl)){
    this.searchSelect = ctl; 
  }
};
//_____________________________________________________________________________
//  @purpose  : adds a text string to the search history list.
//  @params   : text - the string to add.  
//  @notes    : calls loadSearchSelect()
//_____________________________________________________________________________
function _addPhrase(text){
  if (isValidString(text)){
    this.phrases[this.phrases.length] = text;
    this.loadSearchSelect();
  }
};
//_____________________________________________________________________________
//  @purpose  : removes all text strings from search history.
//  @notes    : calls clearSearchSelect()
//_____________________________________________________________________________
function _clearPhrases(){
  this.phrases.length = 0;
  this.clearSearchSelect();
};
//_____________________________________________________________________________
//  @purpose  : removes all option elements from the select control. 
//  @notes    : 
//_____________________________________________________________________________
function _clearSearchSelect(){
  if (this.searchSelect){
    this.searchSelect.length = 0;
  }
};
//_____________________________________________________________________________
//  @purpose  : adds all search history text strings to the select control. 
//  @notes    : 
//_____________________________________________________________________________
function _loadSearchSelect(){
  if (this.searchSelect){
    this.clearSearchSelect();
  
    /* add list of saved phrases to the list */
    for (var loop=0; loop<this.phrases.length; loop++){
      this.searchSelect.length++;
      this.searchSelect.options[loop].text = this.phrases[loop];
    }
    this.searchSelect.selectedIndex = -1;
  }
};
/* History Manager Class */
function HistoryManager(){
  this.history = new Array();
  this.currentIndex = -1;
  this.buttonManager = null;
  this.previousButton = null;
  this.nextButton = null;
};
//_____________________________________________________________________________
//  @purpose  : assigns manager object for buttons 
//  @params   : mgr - instance of ButtonManager class
//  @notes    : 
//_____________________________________________________________________________
function _setButtonManager(mgr){
	if (typeof(mgr) != "undefined"){
		this.buttonManager = mgr;
	}
};
//_____________________________________________________________________________
//  @purpose  : assigns buttons to class by type.
//  @params   : ctl - the button to add
//              type - one of the defined types, see below. 
//  @notes    : 
//_____________________________________________________________________________
function _setButton(ctl,type){
  if (typeof(ctl) != "undefined"){
    switch (type){
      case HistoryManager.PreviousButton:
        this.previousButton = ctl;
        break;
      case HistoryManager.NextButton:
        this.nextButton = ctl;
        break;
      default:
        return;
    }
    this.updateButtonSet();
  }
};
//_____________________________________________________________________________
//  @purpose  : adds a location to the history list (see notes). 
//  @params   : url - the location url.
//							id - the unique topic id.
//  @notes    : existing topics (duplicate id's) are not re-added to 
//							the collection.
//_____________________________________________________________________________
function _addTopic(url,title,id){
	var exists = false;
  if (isValidString(url)){ 
  
		/* topic may be summoned by a hash link, don't add if so */
		if ((url.indexOf("#") != -1) && (id.indexOf("_HASH_") == -1)){
      return HistoryManager.Ignore;
		}
  
		for (var index=0;index<this.history.length;index++){
			if (this.history[index].id == id){
				/* topic already exists; update current position */				
				exists = true;
				this.currentIndex = index;
				break;
			}
		} 
		if (!exists){
			/* url not found; add to collection */
			var newTopic = new Object();
						
			newTopic.url = url;
			newTopic.title = title;
			newTopic.id = id;	
					
			this.history[this.history.length] = newTopic;
			this.currentIndex = this.history.length - 1;
		}
		/* current position has changed, adjust buttons */
    this.updateButtonSet();
  }
};
//_____________________________________________________________________________
//  @purpose  : removes all topics from history list.  
//  @notes    : 
//_____________________________________________________________________________
function _clearTopics(){
  this.history.length = 0;
};
//_____________________________________________________________________________
//  @purpose  : retrieves the current topic;  
//  @notes    : 
//_____________________________________________________________________________
function _getCurrentTopic(){
	var current = null;
	
	if (this.history.length > 0){
		current = this.history[this.currentIndex];
	}
	return current;
}
//_____________________________________________________________________________
//  @purpose  : retrieves the previous topic from the history list, if any.  
//  @notes    : calls updateButtonSet()
//_____________________________________________________________________________
function _getPrevious(){
  var prevTopic = null;
  
  if (this.history.length > 0){
    if (this.currentIndex > 0){      
      prevTopic = this.history[--this.currentIndex];
    }
  }
  this.updateButtonSet();
  return prevTopic;
};
//_____________________________________________________________________________
//  @purpose  : retrieves the next topic in the history list, if any. 
//  @notes    : calls updateButtonSet()
//_____________________________________________________________________________
function _getNext(){
  var nextTopic = null;
  
  if (this.history.length > 0){
    if (this.currentIndex < this.history.length - 1){
      nextTopic = this.history[++this.currentIndex];
    }
  }
  this.updateButtonSet();
  return nextTopic;
};
//_____________________________________________________________________________
//  @purpose  : sets enabled state of buttons based on the position
//              of the currently displayed content within the history list.  
//  @notes    : 
//_____________________________________________________________________________
function _updateButtonSet(){
  var last = this.history.length - 1;
  var curr = (this.currentIndex == -1 ? 0 : this.currentIndex);
  if (this.nextButton){
    if (this.buttonManager){
			this.setButtonState(this.buttonManager,this.nextButton,(curr < last));
    }
  }
  if (this.previousButton){
    if (this.buttonManager){
			this.setButtonState(this.buttonManager,this.previousButton,(curr > 0));
    }
  }
};
//_____________________________________________________________________________
//  @purpose  : calls button manager to change div wrapper colors
//							based on state.
//  @params		: mgr - an instance of the button manager class.
//							button - an html button object.  
//							state - true to enable, false to disable.
//  @notes    : 
//_____________________________________________________________________________
function _setButtonState(mgr,button,state){
	if (state == false){
		mgr.disableButton(button);
	}else{
		mgr.enableButton(button);
	}
};
/* HelpManager Prototypes */
HelpManager.prototype.loadStrings = _loadStrings;
HelpManager.prototype.getString = _getString;
HelpManager.prototype.localizeStrings = _localizeStrings;
HelpManager.prototype.getQueryString = _getQueryString;
HelpManager.prototype.getLanguage = _getLanguageFromQueryString;
HelpManager.prototype.getDirectoryDocument = _getDirectoryDocument;
HelpManager.prototype.getSearchManager = _getSearchManager;
HelpManager.prototype.setTitleContainer = _setTitleContainer;
HelpManager.prototype.setTitle = _setTitle;
HelpManager.prototype.setHeadingContainer = _setHeadingContainer;
HelpManager.prototype.setMastheadText	= _setMastheadText;
HelpManager.prototype.setDirectoryFrame = _setDirectoryFrame;
HelpManager.prototype.setDirectoryContainer = _setDirectoryContainer;
HelpManager.prototype.setContentFrame = _setContentFrame;
HelpManager.prototype.setContentContainer = _setContentContainer;
HelpManager.prototype.initDirectory = _initDirectory;
HelpManager.prototype.printContent = _printContent;
HelpManager.prototype.loadContentsTree = _loadContentsTree;
HelpManager.prototype.loadFilteredTree = _loadFilteredTree;
HelpManager.prototype.loadProcedureTree = _loadProcedureTree;
HelpManager.prototype.loadReferenceTree = _loadReferenceTree;
HelpManager.prototype.loadIndexList = _loadIndexList;
HelpManager.prototype.loadSearchResults = _loadSearchResults;
HelpManager.prototype.loadContextTopic = _loadContextTopic;
HelpManager.prototype.loadHashUrl = _loadHashUrl;
HelpManager.prototype.initTopic = _initTopic;
HelpManager.prototype.initHomePage = _initHomePage;
HelpManager.prototype.loadTopic = _loadTopic;
HelpManager.prototype.openTree = _openTree;
HelpManager.prototype.closeTree = _closeTree;
HelpManager.prototype.synchDirectory = _synchDirectory;
HelpManager.prototype.goBack = _goBack;
HelpManager.prototype.goNext = _goNext;

/* SearchManager Prototypes */
SearchManager.prototype.getHistoryManager = _getHistoryManager;
SearchManager.prototype.setSearchSelect = _setSearchSelect;
SearchManager.prototype.loadSearchSelect = _loadSearchSelect;
SearchManager.prototype.clearSearchSelect = _clearSearchSelect;
SearchManager.prototype.addPhrase = _addPhrase;
SearchManager.prototype.clearPhrases = _clearPhrases;

/* History Manager Prototypes */
HistoryManager.prototype.setButton = _setButton;
HistoryManager.prototype.setButtonManager = _setButtonManager;
HistoryManager.prototype.setButtonState = _setButtonState;
HistoryManager.prototype.updateButtonSet = _updateButtonSet;
HistoryManager.prototype.addTopic = _addTopic;
HistoryManager.prototype.clearTopics = _clearTopics;
HistoryManager.prototype.getCurrentTopic = _getCurrentTopic;
HistoryManager.prototype.getPrevious = _getPrevious;
HistoryManager.prototype.getNext = _getNext;

/* Helper Methods */
function isSelect(ctl){
  return (ctl.type.indexOf("select") != -1);
};

function isFrame(ctl){
  try{
    return (ctl.tagName.toLowerCase().indexOf("frame") != -1);
  }catch(err){return false;}
};

function isValidString(obj){
  return (typeof(obj) == "string" && obj.length > 0);
};

function trimString(sourceString){  
	var nonPrints = ["\t","\f","\n","\v"," "]
	var newString = "";
	var charFound;

  for (var i=0;i<sourceString.length;i++){
		var temp = sourceString.substr(i,1);
		charFound = true;
		for (var j=0;j<nonPrints.length;j++){
			if (temp == nonPrints[j]){
				charFound = false;
			}
		}
		if (charFound){
			newString += temp;
		}
	}
	return newString;
}

/* end of file */ 
//_____________________________________________________________________________
//
//	HelpTreeManager class 
//	?Copyright 2006-2014 Hewlett-Packard Development Company, L.P.
//	
//	@reworked   : 8-20-2005
//	@developer  : michael.slama@hp.com | michael.slama@ptk.org
//	
//	@purpose    : manages table of contents tree for help system
//
//	@mods       : 09-11-2005 - mds: 
//                -removed all unused code elements. 
//	              -corrected re-declaration of j variable in init() 
//	              
//_____________________________________________________________________________
function HelpTreeManager(){}

HelpTreeManager.prototype.init = function(){
  var i,j;
	var divs = document.getElementsByTagName("DIV");

	for (i=0;i<divs.length;i++){ 
		if (divs[i].className.indexOf("treeWrapper")!=-1){ 
			var linkNodes = divs[i].getElementsByTagName("A");
			for (j=0; j<linkNodes.length; j++){			
				if (linkNodes[j].className=="treeSelectableLink"){
				  if (linkNodes[j].onclick){
					  eval("linkNodes[j].onclick = function(mozEvent) {var hardCodedFunction = "+linkNodes[j].onclick+";ourHelpTreeManager.makeTreeNodeHighlighted(this);return hardCodedFunction();}");
					}else{
						linkNodes[j].onclick = function(mozEvent) {ourHelpTreeManager.makeTreeNodeHighlighted(this);}
          }
				}
			}			
		}else if((divs[i].className == "treeOpen") || (divs[i].className == "treeClosed") ||
				(divs[i].className == "treeOpenSelected") || (divs[i].className == "treeClosedSelected")) {
			var tree = divs[i]; 
			var treeDisclosure = null;
			
			for (j=0;j<tree.childNodes.length;j++) {
				if ((tree.childNodes[j].nodeType==1) && (tree.childNodes[j].className=="treeControl")) {
					treeDisclosure = tree.childNodes[j];
				}
			}
			
			for (j=0;j<treeDisclosure.childNodes.length;j++) {
				if ((treeDisclosure.childNodes[j].nodeType==1) && (treeDisclosure.childNodes[j].className=="treeDisclosure")) {
					treeDisclosure = treeDisclosure.childNodes[j];
				}
			}		

			if (treeDisclosure.onclick) {
				eval("treeDisclosure.onclick = function(mozEvent) {var hardCodedFunction = "+treeDisclosure.onclick+" ;ourHelpTreeManager.toggleTree(mozEvent,this);hardCodedFunction();};");
			}
			else {
				eval("treeDisclosure.onclick = function(mozEvent) {ourHelpTreeManager.toggleTree(mozEvent,this);};");
			}	
		}
	}	
}

HelpTreeManager.prototype.toggleTree = function(mozEvent,treeControl) {	
	var treeObject = treeControl.parentNode;

	if (treeControl.className == "treeDisclosure") {
		treeObject = treeControl.parentNode.parentNode;
	}
	if (treeObject.className == "treeClosed") {
		treeObject.className = "treeOpen";
	}
	else if (treeObject.className == "treeClosedSelected") {
		treeObject.className = "treeOpenSelected";
	}
	else if (treeObject.className == "treeOpenSelected") {
		treeObject.className = "treeClosedSelected";
	}
	else {	
		treeObject.className = "treeClosed"
	}
}

HelpTreeManager.prototype.openSpecificTreeNode = function(id) {
	var walkingNode = document.getElementById(id); 
	
	if (walkingNode){
	  while( walkingNode.parentNode) {	
		  if (walkingNode.className== "treeClosed"){
			  walkingNode.className = "treeOpen";
		  }
		  walkingNode = walkingNode.parentNode;
	  }
  }
}

HelpTreeManager.prototype.makeSpecificTreeNodeHighlighted = function(id,highlightOnly) {
	if (!highlightOnly){
		this.openSpecificTreeNode(id);
	}
	var treeNode = document.getElementById(id);
  if (treeNode){
	  var linkNode = (treeNode.childNodes[0].tagName=="B") ? 
		  treeNode.childNodes[0].childNodes[0] : treeNode.childNodes[0]; 
  	 
	  this.makeTreeNodeHighlighted(linkNode);
	}
}

HelpTreeManager.prototype.makeTreeNodeHighlighted = function(treeLink) {	
	if (treeLink.parentNode.tagName=="B") treeLink = treeLink.parentNode;
	
	var parentClassName = treeLink.parentNode.className;
	var grandparentClassName = treeLink.parentNode.parentNode.className;
	
	if ((grandparentClassName == "treeOpen")  || (grandparentClassName == "treeClosed") ) {
		this.unHighlightAllTreesExceptOne(treeLink.parentNode.parentNode);
	}else if (parentClassName == "leaf") {
		this.unHighlightAllTreesExceptOne(treeLink.parentNode);
	}
}

HelpTreeManager.prototype.openAllTrees = function(wrapperId) {
	var wrapperDiv = document.getElementById(wrapperId);
	var childDivs = wrapperDiv.getElementsByTagName("div");
	for (var i=0;i<childDivs.length;i++) {
		if (childDivs[i].className == "treeClosed"){
			childDivs[i].className = "treeOpen";
		}
		else if (childDivs[i].className == "treeClosedSelected"){
			childDivs[i].className = "treeOpenSelected";
		}
	}
}

HelpTreeManager.prototype.closeAllTrees = function(wrapperId) {
	var wrapperDiv = document.getElementById(wrapperId);
	var childDivs = wrapperDiv.getElementsByTagName("div");
	for (var i=0;i<childDivs.length;i++) {
		if (childDivs[i].className == "treeOpen"){
			childDivs[i].className = "treeClosed";
		}
		else if (childDivs[i].className == "treeOpenSelected"){
			childDivs[i].className = "treeClosedSelected";
		}
	}
}

HelpTreeManager.prototype.unHighlightAllTreesExceptOne = function(highlightedTree) {
	var walkingNode = highlightedTree;
	while((walkingNode.className !=  "treeWrapper") && 
		(walkingNode.className !=  "treeHasOneIconSpacing") && 
		(walkingNode.className !=  "treeHasTwoIconSpacing") && 
		( walkingNode.parentNode)) {
		walkingNode = walkingNode.parentNode;
	}
	var divNodes = walkingNode.getElementsByTagName("DIV");
	for (var i=0; i<divNodes.length; i++) {	
		if (divNodes[i] ==  highlightedTree) {
			if (divNodes[i].className == "leaf")  divNodes[i].className = "leafSelected";
			else if (divNodes[i].className == "treeOpen")  divNodes[i].className = "treeOpenSelected";
			else if (divNodes[i].className == "treeClosed")  divNodes[i].className = "treeClosedSelected";
			else if (divNodes[i].className == "leafWrapper")  {
				divNodes[i].className = "leafWrapperSelected";
			}
		}
		else {
			if (divNodes[i].className == "leafSelected")  divNodes[i].className = "leaf";
			else if (divNodes[i].className == "treeOpenSelected")  divNodes[i].className = "treeOpen";
			else if (divNodes[i].className == "treeClosedSelected")  divNodes[i].className = "treeClosed";
			else if (divNodes[i].className == "leafWrapperSelected")  divNodes[i].className = "leafWrapper";
		}
	}
}

/** (C) Copyright 2006-2014 Hewlett-Packard Development Company, L.P. */
function TransferBoxManager(){
this.usesCategoryFiltering=false;
}
TransferBoxManager.prototype.init=function(){
var formNodes=document.forms;
for(var i=0;i<formNodes.length;i++){
if(formNodes[i].className=="transferBox"){
this.checkButtons(formNodes[i]);
formNodes[i].available_items.onchange=function(){ourTransferBoxManager.checkButtons(this.form)};
formNodes[i].chosen_items.onchange=function(){ourTransferBoxManager.checkButtons(this.form)};
formNodes[i].addButton.onclick=function(){ourTransferBoxManager.addToChosenList(this.form)};
formNodes[i].removeButton.onclick=function(){ourTransferBoxManager.removeFromChosenList(this.form)};
if(formNodes[i].sortUpButton){
formNodes[i].sortUpButton.onclick=function(){ourTransferBoxManager.moveSelectedChosenItems(this.form,true);}
formNodes[i].sortDownButton.onclick=function(){ourTransferBoxManager.moveSelectedChosenItems(this.form,false);}
}
if(formNodes[i].itemCategory){
eval("formNodes[i].itemCategory.onchange= function() {ourTransferBoxManager.getNewAvailableItemsList(document.getElementById('"+formNodes[i].id+"'))}");
this.usesCategoryFiltering=true;
}
}
}
}
TransferBoxManager.prototype.resetAvailableItems=function(id,availableItemsString){
var transferBoxForm=document.getElementById(id);
var availableBox=transferBoxForm.available_items;
var chosenBox=transferBoxForm.chosen_items;
while(availableBox.length>0){
availableBox.options[0]=null;
}
var availableItems=availableItemsString.split("*");
for(var i=0;i<availableItems.length;i++){
var inToolBox=false;
var itemPair=availableItems[i];
var itemPairArray=itemPair.split("|");
var itemName=itemPairArray[0];
var itemIdAndNamePair=itemPairArray[1];
var itemIdAndNameArray=itemIdAndNamePair.split(":");
var itemId=itemIdAndNameArray[0];
for(var j=0;j<chosenBox.length;j++){
var chosenItemValue=chosenBox.options[j].value;
var chosenItemValueArray=chosenItemValue.split(":");
if(chosenItemValueArray[0]==itemId){
inToolBox=true;
}
}
if(!inToolBox)availableBox.options[availableBox.length]=new Option(itemName,itemIdAndNamePair);
}
}
TransferBoxManager.prototype.getNewAvailableItemsList=function(formObj){
var formId=formObj.getAttribute("id");
if(this.usesCategoryFiltering){
var categoryIndex=formObj.itemCategory.selectedIndex;
var category=formObj.itemCategory.options[categoryIndex].text;
document.getElementById(formId+"DataSource").src=formObj.pathToGetNewItems.value+"?category="+category;
}
else{
document.getElementById(formId+"DataSource").src=formObj.pathToGetNewItems.value;
}
}
TransferBoxManager.prototype.addToChosenList=function(formObj){
var availableBox=formObj.available_items;
var chosenBox=formObj.chosen_items;
for(var i=0;i<availableBox.length;i++){
if(availableBox.options[i].selected==true){
var newToolOption=new Option((availableBox.options[i].text),(availableBox.options[i].value));
chosenBox.options[chosenBox.length]=newToolOption;
}
}
var availableBoxLength=availableBox.length;
for(i=0;i<availableBoxLength;i++){
if(availableBox.options[i].selected){
availableBox.options[i]=null;
i--;
availableBoxLength--;
}
}
this.checkButtons(formObj);
}
TransferBoxManager.prototype.removeFromChosenList=function(formObj){
var availableBox=formObj.available_items;
var categoryName=(this.usesCategoryFiltering)?formObj.itemCategory.options[formObj.itemCategory.value].text:"";
var chosenBox=formObj.chosen_items;
var chosenBoxLength=chosenBox.length;
for(var i=0;i<chosenBoxLength;i++){
var itemIdAndNamePair=chosenBox.options[i].value;
var itemIdAndNameArray=itemIdAndNamePair.split(":");
if(chosenBox.options[i].selected&&((!this.usesCategoryFiltering)||((this.usesCategoryFiltering)&&(itemIdAndNameArray[1]==categoryName)))){
var newToolOption=new Option((chosenBox.options[i].text),itemIdAndNamePair);
availableBox.options[availableBox.length]=newToolOption;
}
}
for(var i=0;i<chosenBoxLength;i++){
if(chosenBox.options[i].selected){
chosenBox.options[i]=null;
i--;
chosenBoxLength--;
}
}
this.checkButtons(formObj);
}
TransferBoxManager.prototype.postChosenItemsList=function(formObj){
var chosenBox=formObj.chosen_items;
var toolList="";
for(var i=0;i<chosenBox.length;i++){
var seperator=(i==0)?"":"*";
toolList+=seperator+chosenBox.options[i].text+"|"+chosenBox.options[i].value;
}
formObj.chosenItemsAddList.value=toolList;
return true;
}
TransferBoxManager.prototype.checkButtons=function(formObj){
var availableBox=formObj.available_items;
var chosenBox=formObj.chosen_items;
someAvailableSelected=false;
someChosenSelected=false;
for(var i=0;i<availableBox.length;i++){
if(availableBox.options[i].selected)someAvailableSelected=true;
}
for(i=0;i<chosenBox.length;i++){
if(chosenBox.options[i].selected)someChosenSelected=true;
}
if(someAvailableSelected){
ourButtonManager.enableButton(formObj.addButton)
if(formObj.sortUpButton){
ourButtonManager.enableButton(formObj.sortUpButton);
ourButtonManager.enableButton(formObj.sortDownButton);
}
}
else{
ourButtonManager.disableButton(formObj.addButton);
if(formObj.sortUpButton){
ourButtonManager.disableButton(formObj.sortUpButton);
ourButtonManager.disableButton(formObj.sortDownButton);
}
}
if(someChosenSelected){
ourButtonManager.enableButton(formObj.removeButton);
if(formObj.sortUpButton){
ourButtonManager.enableButton(formObj.sortUpButton);
ourButtonManager.enableButton(formObj.sortDownButton);
}
}
else{
ourButtonManager.disableButton(formObj.removeButton);
if(formObj.sortUpButton){
ourButtonManager.disableButton(formObj.sortUpButton);
ourButtonManager.disableButton(formObj.sortDownButton);
}
}
}
TransferBoxManager.prototype.swapChosenItems=function(chosenBox,selectedItemIndex,unselectedItemIndex){
var selectedItem=chosenBox.options[selectedItemIndex];
var unselectedItem=chosenBox.options[unselectedItemIndex];
var tempLabel=selectedItem.innerHTML;
var tempValue=selectedItem.value;
selectedItem.innerHTML=unselectedItem.innerHTML;
selectedItem.value=unselectedItem.value;
unselectedItem.innerHTML=tempLabel;
unselectedItem.value=tempValue;
selectedItem.selected=false;
unselectedItem.selected=true;
}
TransferBoxManager.prototype.moveSelectedChosenItems=function(formObj,moveUp){
var chosenBox=formObj.chosen_items;
var listOfSelectedIndices=[];
var selectedIndexHash=[];
for(var i=0;i<chosenBox.length;i++){
selectedIndexHash[i]=false;
if(chosenBox.options[i].selected){
listOfSelectedIndices[listOfSelectedIndices.length]=i;
selectedIndexHash[i]=true;
}
}
if(moveUp){
for(var i=0;i<listOfSelectedIndices.length;i++){
if(listOfSelectedIndices[i]!=0){
if(selectedIndexHash[listOfSelectedIndices[i]-1]!=true){
this.swapChosenItems(chosenBox,listOfSelectedIndices[i],listOfSelectedIndices[i]-1);
selectedIndexHash[listOfSelectedIndices[i]]=false;
selectedIndexHash[listOfSelectedIndices[i]-1]=true;
}
}
}
}
else{
for(var i=listOfSelectedIndices.length-1;i>=0;i--){
if(listOfSelectedIndices[i]!=selectedIndexHash.length-1){
if(selectedIndexHash[listOfSelectedIndices[i]+1]!=true){
this.swapChosenItems(chosenBox,listOfSelectedIndices[i],listOfSelectedIndices[i]+1);
selectedIndexHash[listOfSelectedIndices[i]]=false;
selectedIndexHash[listOfSelectedIndices[i]+1]=true;
}
}
}
}
}
function transferBox_resetAvailableItems(id,availableItems){
if(ourTransferBoxManager)ourTransferBoxManager.resetAvailableItems(id,availableItems);
}

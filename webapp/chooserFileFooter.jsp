<%-- $Header$ --%>

Select
  <a href="javascript:ToggleAll(true)" title="Select all files">all</a> 
| <a href="javascript:ToggleAll(false)" title="Select no file">none</a> 
| <a href="javascript:ToggleInvertAll()" title="Invert selection">invert</a> 
| <a href="javascript:ToggleRegexp()" title="Toggle files matching a regular expression">RegExp</a>: <input type="text" value=".*\.jsp" name="filemask" size="7" onkeypress="return !(window.event && window.event.keyCode == 13);" >


<script language="JavaScript">
<!--
//those are taken from web-based email client, then modified 

function AnySelected() {
	len = document.files.elements.length;
	var i;
	for (i = 0; i < len; i++) {
		if (document.files.elements[i].checked)
			return true;
	}
	return false;
}

function Transfer(actID, form) {
	if (!AnySelected()) {
		window.alert('You must select at least one message first.');
	} else {
		if (form == 1) {
			document.messages.targetMbox.value = document.copymove1.targetMailbox.options[document.copymove1.targetMailbox.selectedIndex].value;
		}
		else {
			document.messages.targetMbox.value = document.copymove2.targetMailbox.options[document.copymove2.targetMailbox.selectedIndex].value;
		}
    
		// check for a mailbox actually being selected
		if (document.messages.targetMbox.value == '') {
			window.alert('You must a select a target mailbox first.');
		} else {
			document.messages.actionID.value = actID;
			document.messages.submit();
		}
	}
}

function Submit(actID) {
				  if (AnySelected()) {
				  document.files.actionID.value = actID;
				  document.files.submit();
			  } else
				  window.alert('You must select at least one file first.');
			  }

function ToggleAll(checked) {
    len = document.files.elements.length;
    var i = 0;
    for(i = 0; i < len; i++) {
        document.files.elements[i].checked = checked;
    }
}


function ToggleInvertAll() {
    len = document.files.elements.length;
    var i = 0;
    for(i = 0; i < len; i++) {
        if (document.files.elements[i].checked==true) {
		   document.files.elements[i].checked = false;
		} else {
		   document.files.elements[i].checked = true;
		}

    }
}

function ToggleRegexp() {
    len = document.files.elements.length;
    var i = 0;
    var rex=new RegExp(document.files.filemask.value,"gi");
    for(i = 0; i < len; i++) {
      var name=document.files.elements[i].name;
      var val=document.files.elements[i].value;
      if(name=='files[]' && val.match(rex))
      {
        //alert(name+": "+val+"\n"+val.match(rex));
        if (document.files.elements[i].checked==true) {
		   document.files.elements[i].checked = false;
		} else {
		   document.files.elements[i].checked = true;
		}
      }
    }
}


//-->
</script>
var potato;
jq111 = jQuery.noConflict(true);

// must be on load unfortunately....
jq111(window).load(function(){
  // use mouseover because fires more when child goes to parent
  jq111('*:not(body, script, style)').on("mouseover", function(event){
    jq111(potato).removeClass('chicken');
    var text = jq111(this).text();
    contents = jq111(this).contents();

    // make sure that at least the children have text
    if (text.trim() != '') {
      var hasText = false;
      // making sure this thing actually does contain text
      for (var i = 0; i < contents.length; i++)
      {
        // is it a text node?  and also not just whitespace?
        if (contents[i].nodeType == 3 && contents[i].nodeValue.trim() != ''){
          hasText = true;
          break;
        }
      }
      if (hasText)
      {
        potato = this;
        jq111(this).addClass('chicken');
        event.stopPropagation()
      }
    }
  });
  // use mouseover because fires more when child goes to parent
  jq111('*:not(body, script, style)').on("click", function(event){
    event.preventDefault();
    jq111(potato).removeClass('chicken');
    var text = jq111(this).text();
    contents = jq111(this).contents();

    // make sure that at least the children have text
    if (text.trim() != '') {
      var hasText = false;
      // making sure this thing actually does contain text
      for (var i = 0; i < contents.length; i++)
      {
        // is it a text node?  and also not just whitespace?
        if (contents[i].nodeType == 3 && contents[i].nodeValue.trim() != ''){
          hasText = true;
          break;
        }
      }
      // validates whether it is a price
      if (hasText && text.replace(/\s/g, "").search(/^\$?\d+(,\d{3})*(\.\d*)?$/) != -1)
      {
        console.log(createXPathFromElement(this));
        potato = this;
        jq111(this).addClass('chicken');
        jq111(this).addClass('sandwich');
        event.stopPropagation()
      }
    }
  });

  // from http://stackoverflow.com/questions/2661818/javascript-get-xpath-of-a-node
  function createXPathFromElement(elm) { 
    var allNodes = document.getElementsByTagName('*'); 
    var segs = []
    for (; elm && elm.nodeType == 1; elm = elm.parentNode) 
    { 
        if (elm.hasAttribute('id')) { 
                var uniqueIdCount = 0; 
                for (var n=0;n < allNodes.length;n++) { 
                    if (allNodes[n].hasAttribute('id') && allNodes[n].id == elm.id) uniqueIdCount++; 
                    if (uniqueIdCount > 1) break; 
                }; 
                if ( uniqueIdCount == 1) { 
                    segs.unshift('id("' + elm.getAttribute('id') + '")'); 
                    return segs.join('/'); 
                } else { 
                    segs.unshift(elm.localName.toLowerCase() + '[@id="' + elm.getAttribute('id') + '"]'); 
                } 
        } else if (elm.hasAttribute('class')) { 
            segs.unshift(elm.localName.toLowerCase() + '[@class="' + elm.getAttribute('class') + '"]'); 
        } else { 
            for (i = 1, sib = elm.previousSibling; sib; sib = sib.previousSibling) { 
                if (sib.localName == elm.localName)  i++; }; 
                segs.unshift(elm.localName.toLowerCase() + '[' + i + ']'); 
        }; 
    }; 
    return segs.length ? '/' + segs.join('/') : null; 
  }; 

  function lookupElementByXPath(path) { 
      var evaluator = new XPathEvaluator(); 
      var result = evaluator.evaluate(path, document.documentElement, null,XPathResult.FIRST_ORDERED_NODE_TYPE, null); 
      return  result.singleNodeValue; 
  };
});
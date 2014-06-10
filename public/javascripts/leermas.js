function truncate(){
  var len = 470;






  var allHTMLTags=document.getElementsByTagName("*");
    // Las recorremos
    for (i=0; i<allHTMLTags.length; i++) {
        // Y comprobamos que la clase sea la adecuada
        
        if (allHTMLTags[i].className=="truncateMe") {


            // Aqui ejecutamos lo que queramos a los elementos
            // que coincidan con la clase.
            //
            // En este caso aplicamos display:none
            //allHTMLTags[i].style.display='none';
            //var p = allHTMLTags[i].
            var p = allHTMLTags[i];
            //document.write(p);
            


             if (p) {
    var trunc = p.innerHTML;
    //var trunc = p.getElementsByTagName('p');
    //document.write(trunc);
    if (trunc.length > len) {

      /* Truncate the content of the P, then go back to the end of the
         previous word to ensure that we don't truncate in the middle of
         a word */
      trunc = trunc.substring(0, len);
      trunc = trunc.replace(/\w+$/, '');

      /* Add an ellipses to the end and make it a link that expands
         the paragraph back to its original size */
      trunc += '<a href="#" ' +
        'onclick="this.parentNode.innerHTML=' +
        'unescape(\''+escape(p.innerHTML)+'\');return false;">' +
        '<span style="font-size: 16px;">[Leer mas...]</span></a>';
      p.innerHTML = trunc;
    }
  }






        }
    }












 
}

function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      if (oldonload) {
        oldonload();
      }
      func();
    }
  }
}

addLoadEvent(function() {
  truncate();
});
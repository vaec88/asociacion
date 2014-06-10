$(document).ready(function(){

	/* SCROLL PHOTOS */

	$(window).scroll(function(){

	    var scrollTop = $(window).scrollTop();

	    /* Header */
	    
	    if(scrollTop >= 40){
	    	$('body').addClass('header-fixed');
	    }else{
	    	$('body').removeClass('header-fixed');
	    }

	});

	 /* MENU - SELECT */
	
	$('<div id="menu-mobile">').appendTo("#header .main");

	$("<select />").appendTo("#menu-mobile");
	
	$("<option />", {
		"selected": "selected",
		"value"   : "",
		"text"    : "Menu"
	}).appendTo("#menu select");
	
	$("#menu a").each(function() {
		var el = $(this);
		$("<option />", {
			"value"   : el.attr("href"),
			"text"    : el.text()
		}).appendTo("#header .main select");
	});

	$("#header .main select").change(function() {
		window.location = $(this).find("option:selected").val();
	});
		 
});

/* CARGO JS DE FORMA ASINCRONA */

$(window).load(function () {

	(function(doc, script) {
        var js, 
            fjs = doc.getElementsByTagName(script)[0],
            frag = doc.createDocumentFragment(),
            add = function(url, id) {
                if (doc.getElementById(id)) {return;}
                js = doc.createElement(script);
                js.src = url;
                id && (js.id = id);
                frag.appendChild( js );
            };
        
        // Google Analytics
	    //add(('https:' == location.protocol ? '//ssl' : '//www') + '.google-analytics.com/ga.js', 'ga');
	    // Google+ button
	    add('https://apis.google.com/js/plusone.js');
	    // Facebook SDK
	    add('//connect.facebook.net/es_LA/all.js#xfbml=1');
	    // Twitter SDK
	    add('//platform.twitter.com/widgets.js', 'twitter-wjs');       
    
        fjs.parentNode.insertBefore(frag, fjs);
    }(document, 'script'));

});
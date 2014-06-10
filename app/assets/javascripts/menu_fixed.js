$(document).ready(function(){
    var top,bottom, y, page;
 
    var left = $('.tofix').offset().left;
    tofixwidth();
 
    $(window).scroll(function (event) {
 
        // what the y position of the scroll is
        controlArticlePositions();         
 
        // whether that's below the form
        if (y >= top && y<=bottom && y > page) {
            $('.tofix').addClass('fixed');
 
            //control horizontal scroll
            tofixl =  left-x;
            $('.tofix').css('left', tofixl);
 
        } else {
            $('.tofix').removeClass('fixed');
        }
    });
 
    $(window).resize(function() {
        tofixwidth();
    });
 
    function controlArticlePositions(){
        page = $('.page').offset().top;
        pageb = $('.tofix').height();
 
        top = $('.tofix').offset().top;
 
        bottom = page + $('.page').height() - pageb;
 
        y = $(window).scrollTop();
        x = $(window).scrollLeft();
    }
 
    function tofixwidth(){
        $('.tofix').css('width', '');          
        var sidebarW = $('.tofix').closest('.sidebar').css('width');
        $('.tofix').css('width', sidebarW);
    }
 
});
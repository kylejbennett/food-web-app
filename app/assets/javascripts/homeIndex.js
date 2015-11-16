$(document).ready(function(){
	$(window).scroll(function (event) {
        var sc = $(window).scrollTop();
        console.log(sc);
        // 655
        if (sc < 300){
        	$(".info").hide('fast');
        } else {
        	$(".info").show('fast');
        }

        if (sc < 650){
        	$(".look").hide("slow");	
        } else if (sc > 1100){
        	$(".look").hide("slow");
        } else {
        	$(".look").show("slow");
        }

        if (sc < 900){
        	$(".blurb").hide('fast');
        } else {
        	$(".blurb").show('fast');
        }

        if (sc < 1100){
        	$(".box").hide('slow');
        } else {
        	$(".box").show('slow');
        }
    });
});
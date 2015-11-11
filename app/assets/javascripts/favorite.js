$(document).ready(function(){

	$(".added").hide();

	$(".new_fav").on("ajax:complete", function(event){   
		$(event.currentTarget).parent().hide();
		$(event.currentTarget).parent().next().show(); 
	});

	$(".delete-fav").on("ajax:complete", function(event){   
		$(event.currentTarget).parent().parent().slideUp(1000) 
	});

});

$(document).on('page:load', function(event) {

	$(".added").hide();

	$(".new_fav").on("ajax:complete", function(event){   
		$(event.currentTarget).parent().hide();
		$(event.currentTarget).parent().next().show(); 
	});

	$(".delete-fav").on("ajax:complete", function(event){   
		$(event.currentTarget).parent().parent().slideUp(1000) 
	});

});
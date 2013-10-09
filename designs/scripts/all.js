
jQuery(function($){

	$('nav.messages-toggle').on('click', 'a', function(){
		$('.messages').toggleClass('hide');
	});

});
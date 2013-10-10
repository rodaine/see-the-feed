
jQuery(function($){

	$('nav.view').on('click', 'a', function(){
		$(this).siblings('a').removeClass('selected');
		$(this).addClass('selected');
	});
	$('nav.messages-toggle').on('click', 'a', function(){
		$('.messages').toggleClass('hide');
		$(this).toggleClass('selected');
	});

});
$(document).ready(function(){
	$("#search-trackers").click(function(){
		var array = $('.media');
		var arrayNames = $('.media-wrapper-heading');
		var str = '';
		var searchText = $('#search-tracker').val().toLowerCase();
		for (var i = 0; i < arrayNames.length; i++)
		{
			str = '' + $(arrayNames[i]).text().toLowerCase();
			if (str.indexOf(searchText) != -1) {
				$(array[i]).show(); }
			else
				$(array[i]).hide();

		};
	});	
});
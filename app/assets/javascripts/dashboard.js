$(document).ready(function(){
	$("#search-trackers").click(function(){
		alert('clicked');
		var array = $('.media-heading');
		var searchText = $('#search-tracker');
		alert(searchText.html());
		var $currentElement;
		for (var i in array)
		{
			if (array[i].text() == searchText)
				array[i].show();
			else
				array[i].hide();
		};
	});	
});
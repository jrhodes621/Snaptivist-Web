$(document).ready(function() {

	var api_root_url = "http://localhost:3000/api";
	var petition_id;
	var phonecampaign_id;
	var poll_id;

	Handlebars.registerPartial("selectTarget", $("#select-target-template").html());

	$("#start-petition").click(function() {

        var source   = $("#create-petition-template").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#start-petition-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    	$('#start-petition-panel').animate({
    			left:windowWidth/2-$('#start-petition-panel').width()/2
		});
    });
	$("#wrap").on("submit", "#create-petition-form", function(e) {
		e.preventDefault();

		var target_id = $("#target_id").val();
		var title = $("#title").val();
		var summary = $("#summary").val();

		var url = api_root_url + '/petitions';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'target_id': target_id,
				'title': title,
				'summary': summary 
			}),
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {

				 petition_id = result.result.petition_id;

				 var source   = $("#launch-petition-template").html();
        		 var template = Handlebars.compile(source);

    			 var windowWidth = $(window).width();
        		 var context = result.result;
        		 var html = template(context);

        		$("#wrap").append(html);

        		$("#launch-petition-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    			$('#start-petition-panel').animate({
    				left: -($("#create-petition").width() + windowWidth/2)
    			}, 400, function() {
    			
    			$('#launch-petition-panel').animate({
    				left:windowWidth/2-$("#create-petition").width()/2
    			});
    			});
			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});
	});
    $("#wrap").on("click", "#launch-petition", function(e) {
    	e.preventDefault();

    	var url = api_root_url + '/petitions/' + petition_id;

		$.ajax({
			type: "GET",
			url: url,
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {

    		var source   = $("#share-petition-template").html();
        	var template = Handlebars.compile(source);

    		var windowWidth = $(window).width();

        	var context = result.result;
        	var html = template(context);

        	$("#wrap").append(html);

    		$("#share-petition-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
			$('#launch-petition-panel').animate({
    			left: -($('#launch-petition-panel').width() + windowWidth/2)
    		}, 400, function() {
    			
    			$('#share-petition-panel').animate({
    				left:windowWidth/2-$('#share-petition-panel').width()/2
    			});
    			});

			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});


    });
    $("#wrap").on("click", "#share-petition", function(e) {
    	e.preventDefault();

    		var windowWidth = $(window).width();

    		$('#share-petition-panel').animate({
    			left: -($(this).width() + windowWidth/2)
    		}, 400, function() {
    			$("#start-petition-panel").remove();
				$("#launch-petition-panel").remove();
				$("#share-petition-panel").remove();
    		});
    });
    $("#start-phone-campaign").click(function() {

        var source   = $("#create-phone-campaign-template").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#start-phone-campaign-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    	$('#start-phone-campaign-panel').animate({
    			left:windowWidth/2-$('#start-phone-campaign-panel').width()/2
		});
    });
    $("#wrap").on("submit", "#create-phone-campaign-form", function(e) {
		e.preventDefault();

		var target_id = $("#target_id").val();
		var title = $("#title").val();
		var summary = $("#summary").val();

		var url = api_root_url + '/phonecampaigns';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'target_id': target_id,
				'title': title,
				'summary': summary 
			}),
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {
		
				phonecampaign_id = result.result.phonecampaign_id;

				 var source   = $("#launch-phone-campaign-template").html();
        		 var template = Handlebars.compile(source);

    			 var windowWidth = $(window).width();
        		 var context = result.result;
        		 var html = template(context);

        		$("#wrap").append(html);

        		$("#launch-phone-campaign-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    			$('#start-phone-campaign-panel').animate({
    				left: -($("#start-phone-campaign-panel").width() + windowWidth/2)
    			}, 400, function() {
    			
    			$('#launch-phone-campaign-panel').animate({
    				left:windowWidth/2-$("#launch-phone-campaign-panel").width()/2
    			});
    		});
    		},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});
			
	});
	$("#wrap").on("click", "#launch-phone-campaign", function(e) {
    	e.preventDefault();

    	var url = api_root_url + '/phonecampaigns/' + phonecampaign_id;

		$.ajax({
			type: "GET",
			url: url,
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {
    		var source   = $("#share-phone-campaign-template").html();
        	var template = Handlebars.compile(source);

    		var windowWidth = $(window).width();

        	var context = result.result;
        	var html = template(context);

        	$("#wrap").append(html);

    		$("#share-phone-campaign-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
			$('#launch-phone-campaign-panel').animate({
    			left: -($('#launch-phone-campaign-panel').width() + windowWidth/2)
    		}, 400, function() {
    			
    			$('#share-phone-campaign-panel').animate({
    				left:windowWidth/2-$('#share-phone-campaign-panel').width()/2
    			});
    		});

			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});

    });
    $("#wrap").on("click", "#share-phone-campaign", function(e) {
    	e.preventDefault();

    		var windowWidth = $(window).width();

    		$('#share-phone-campaign-panel').animate({
    			left: -($(this).width() + windowWidth/2)
    		}, 400, function() {
    			$("#start-phone-campaign-panel").remove();
				$("#launch-phone-campaign-panel").remove();
				$("#share-phone-campaign-panel").remove();
    		});
    });
    $("#start-poll").click(function() {

        var source   = $("#create-poll-template").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#start-poll-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    	$('#start-poll-panel').animate({
    			left:windowWidth/2-$('#start-poll-panel').width()/2
		});
    });
    $("#wrap").on("submit", "#create-poll-form", function(e) {
		e.preventDefault();

		var question = $("#question").val();
		var choices = [];

		var choice = {};
		choice = {
			choice: $("#choice1").val()
		}
		choices.push(choice);

		choice = {
			choice: $("#choice2").val()
		}
		choices.push(choice);
		var url = api_root_url + '/polls';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'poll': {
					'question': question,
					'choices': choices
				}
			}),
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {

				poll_id = result.result.poll_id;

				 var source   = $("#launch-poll-template").html();
        		 var template = Handlebars.compile(source);

    			 var windowWidth = $(window).width();
        		 var context = result.result;
        		 var html = template(context);

        		$("#wrap").append(html);

        		$("#launch-poll-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    			$('#start-poll-panel').animate({
    				left: -($("#start-poll-panel").width() + windowWidth/2)
    			}, 400, function() {
    			
    			$('#launch-poll-panel').animate({
    				left:windowWidth/2-$("#launch-poll-panel").width()/2
    			});
    		});
    		},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});
			
	});
    $("#wrap").on("click", "#launch-poll", function(e) {
    	e.preventDefault();

    	//var url = api_root_url + '/phonecampaings/' + petition_id;

    		var source   = $("#share-poll-template").html();
        	var template = Handlebars.compile(source);

    		var windowWidth = $(window).width();

        	var context = {}; //result.result;
        	var html = template(context);

        	$("#wrap").append(html);

    		$("#share-poll-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
			$('#launch-poll-panel').animate({
    			left: -($('#launch-poll-panel').width() + windowWidth/2)
    		}, 400, function() {
    			
    			$('#share-poll-panel').animate({
    				left:windowWidth/2-$('#share-poll-panel').width()/2
    			});
    		});
    });
    $("#wrap").on("click", "#share-poll", function(e) {
    	e.preventDefault();

    		var windowWidth = $(window).width();

    		$('#share-poll-panel').animate({
    			left: -($(this).width() + windowWidth/2)
    		}, 400, function() {
    			$("#start-poll-panel").remove();
				$("#launch-poll-panel").remove();
				$("#share-poll-panel").remove();
    		});
    });
	$("#wrap").on("click", "#sign-petition-user-name", function(e) {
		e.preventDefault();

		var first_name = 'James';
		var last_name = 'Rhodes';
		var email = 'james@somehero.com';
		var zip_code = '23221';
		var comment = $('#comment').val();
		var petition_id = $('#petition_id').val()

		var url = api_root_url + '/signatures';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'petition_id': petition_id,
				'first_name': first_name,
				'last_name': last_name,
				'email': email,
				'zip_code': zip_code,
				'comment': comment
			}),
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {

				var signature = result.result.signature;

	    		$('#sign-petition-thanks').modal();
			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});
	});
 
	$("#wrap").on("click", "#sign-petition-fb", function(e) {
		var FB = window.FB || '';
		if(FB){
	    	FB.login(function(response) {
	    		console.log('fb login success');
	    		console.log(response);

	    var authentication_mechanism = 'facebook';
	    var external_id = response.authResponse.userId;
	    var access_token = response.authResponse.accessToken;
		var comment = $('#comment').val();
		var petition_id = $('#petition_id').val();

		var url = api_root_url +  '/signatures';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'petition_id': petition_id,
				'authentication_mechanism': authentication_mechanism,
				'external_id': external_id,
				'access_token': access_token,
				'comment': comment
			}),
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {

				var signature = result.result.signature;

					$('#sign-petition-thanks').modal();
			
			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});
	    	},{scope: 'email'});
		}else{
	 	console.log('fb login failed');
	 	};
	});
$("#wrap").on("click", "#target-group-the-white-house", function() {

	var elem = $("#" + $(this).attr("id") + "-items");
	var source   = $("#target-template").html();
	var template = Handlebars.compile(source);

	var url = api_root_url +  '/targets?targetgroup_id=1'
		$.ajax({
			type: "GET",
			url: url,
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(results) {

				var context = results;
				var html    = template(context);

				elem.empty().append(html);
				elem.toggle();
			
			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});


});
$("#wrap").on("click", "#target-group-congress", function() {

	var elem = $("#" + $(this).attr("id") + "-items");
	elem.toggle();

});
$("#wrap").on("click", "#target-group-state", function() {

	var elem = $("#" + $(this).attr("id") + "-items");
	elem.toggle();

});
$("#wrap").on("click", "#target-group-other", function() {

	var elem = $("#" + $(this).attr("id") + "-items");
	elem.toggle();

});
$("#wrap").on("click", ".target", function() {

	$("#target_id").val($(this).val())

});
$("#wrap").on("click", ".state-select", function() {
	$("#" + $(this).attr("id") + "-items").toggle();
});
$("#wrap").on("change", "#congress_state_code", function() {
	var elem = $("#" + $(this).attr("id") + "-items");
	var state = $(this).val();
	var source   = $("#target-template").html();
	var template = Handlebars.compile(source);

	var url = api_root_url +  '/targets?state='+ state +'&targetgroup_id=2'
		$.ajax({
			type: "GET",
			url: url,
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(results) {

				var context = results;
				var html    = template(context);

				elem.empty().append(html);
				elem.show();
			
			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		})
});
$("#wrap").on("click", ".target-group-other", function() {
	$("#" + $(this).attr("id") + "-items").toggle();
});

});
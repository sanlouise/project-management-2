//Get params from URL to determine whether the plan is premium or basic
function GetURLParameter(sParam) {
  var sPageURL = window.location.search.substring(1);
  var sURLVariables = sPageURL.split('&');
  for (var i = 0; i < sURLVariables.length; i++) {
    var sParameterName = sURLVariables[i].split('=');
    if (sParameterName[0] == sParam) {
        return sParameterName[1];
    }
  }
};

//Handle submission of form and intercept default
$(document).ready(function () {
  var show_error, stripeResponseHandler, submitHandler;

  submitHandler = function (event) {
    var $form = $(event.target);
    //Ensure that submit button cannot be clicked multiple times
    $form.find("input[type=submit]").prop("disabled", true);
    //Stripe returns a token (from documentation)
    if(Stripe) {
      Stripe.card.createToken($form, stripeResponseHandler);
    } else {
      show_error("Failed to process your credit card information. Please reload the page")
    }
    //Prevent default from submitting
    return false;
  };

  //Submit handler listener for form
  $(".cc_form").on('submit', submitHandler);
  
  //Change plan event listener
  var handlePlanChange = function(plan_type, form) {
    var $form = $(form);
    
    if(plan_type == undefined) {
      plan_type = $('#tenant_plan :selected').val();
    }
    //When premium plan is selected, show credit card fields
    if( plan_type === 'premium') {
      $('[data-stripe]').prop('required', true);
      $form.off('submit');
      $form.on('submit', submitHandler);
      $('[data-stripe]').show();
    } else {
      $('[data-stripe]').hide();
      $form.off('submit');
      $('[data-stripe]').removeProp('required');
    }
  }

  $("#tenant_plan").on('change', function(event) {
    handlePlanChange($('#tenant_plan :selected').val(), ".cc_form");
  });

  handlePlanChange(GetURLParameter('plan'), ".cc_form");

  stripeResponseHandler = function (status, response) {
    var token, $form;
    $form = $('.cc_form');
    
    if (response.error) {
      console.log(response.error.message)
      show_error(response.error.message);
      //Enable signup button again
      $form.find("input[type=submit]").prop("disabled", false);
    } else {
      // Removing data from fields after submission, from Stripe ducumentation
      token = response.id;
      $form.append($("<input type=\"hidden\" name=\"payment[token]\" />").val(token));
      $("[data-stripe=number]").remove();
      $("[data-stripe=cvv]").remove();
      $("[data-stripe=exp-year]").remove();
      $("[data-stripe=exp-month]").remove();
      $("[data-stripe=label]").remove();
      $form.get(0).submit();
    }
    //Stops default
    return false;
  };

  // Errors when Stripe returns an error
  show_error = function (message) {
    if($("#flash-messages").size() < 1){
      $('div.container.main div:first').prepend("<div id='flash-messages'></div>")
    }
    $("#flash-messages").html('<div class="alert alert-warning"><a class="close" data-dismiss="alert">×</a><div id="flash_alert">' + message + '</div></div>');
    $('.alert').delay(5000).fadeOut(3000);
    return false;
  };
});
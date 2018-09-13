
	$("#journal_post_top input").keydown(function(key){
		debitCreditField();
	});

	$("#journal_post_top input").keyup(function(key){
		debitCreditField();
	});


	$("#journal_post_top").click(function(key){
		
		
		if($.trim($("#journal_post_top select[name=company_id]").val().length) > 0 && $.trim($("#journal_post_top input[name=journal_date]").val().length) > 0){
			var date = $("#journal_post_top input[name=journal_date]").val().replace('-', '');
			date = date.replace('-', '');
			date = date.replace('20', '');
			
			var com = jQuery.trim($("#journal_post_top select[name=company_id]").find(':selected').text()).substring(0, 3);
			
			$("#journal_post_top input[name=voucher_num]").val(com.toUpperCase()+date);
		}
	});


function debitCreditField(){

		if($.trim($('#journal_post_top input[name=credit]').val().length) > 0){
			$("#journal_post_top input[name=debit]").attr('disabled', true);
			$("#journal_post_bottom input[name=credit]").attr('disabled', true);
		}else{
			$("#journal_post_top input[name=debit]").attr('disabled', false);
			$("#journal_post_bottom input[name=credit]").attr('disabled', false);
		}

		if($.trim($('#journal_post_top input[name=debit]').val().length) > 0){
			$("#journal_post_top input[name=credit]").attr('disabled', true);
			$("#journal_post_bottom input[name=debit]").attr('disabled', true);
		}else{
			$("#journal_post_top input[name=credit]").attr('disabled', false);
			$("#journal_post_bottom input[name=debit]").attr('disabled', false);
		}
}


$("#journal_post_top select[name=company_id]").change(function(){
	// $.ajax({
 //      url:"get_user_by_com_id",
 //      type:"GET",
 //      success:function(result)
 //      {
 //       	alert(result);
 //      },
 //      error: function(er) {
 //           alert("ERROR "+er);
 //       }
 //     });

	$.ajax({
	      url:"/get_user_by_com_id/"+$("#journal_post_top select[name=company_id]").val(),
	      type:"GET",
	      cache: false,
	      async: false,
	      success:function(result){
	      	 var myObj = JSON.parse(result);

	        $('#journal_post_top select[name=user_role]').append($('<option>', {
	            value: "",
	            text : "Select Role"
	        }));

	        for(i in myObj){
	              $('#journal_post_top select[name=user_role]').append($('<option>', {
	                  value: myObj[i].id,
	                  text : myObj[i].first_name
	              }));
	        }



	        $('#journal_post_top select[name=user_role]').removeAttr("disabled");



	      },
	      error:function(result){
	        alert("Error");
	      }
	  });
});
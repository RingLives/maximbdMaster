$(document).ready(function(){
	$('#buyerChange').on('change',function(){
		var selectedValue = $.trim($("#buyerChange").find(":selected").val());

		$.ajax({
          type: "GET",
          url: "/get/buyer/company",
          data: "buyerName="+selectedValue,
          datatype: 'json',
          cache: false,
          async: false,
          success: function(result) {
          	var data = JSON.parse(result);

          	if(data.length === 0)
              {
              	$('#companyName').attr("disabled","true");
              	$('#companyName').html($('<option>', {
                      value: '',
                      text : ''
                  }));

              }else{
              	$('.buyer_company').removeClass('hidden');
              	$('#companyName').html($('<option>', {
                    value: "",
                    text : "Select Company"
                }));
              	for(ik in data){
                  $('#companyName').append($('<option>', {
                      value: data[ik].name,
                      text : data[ik].name
                  }));
                }
              }
          	$('#companyName').removeAttr("disabled","false");
          },
          error:function(result){
            alert("Error");
          }
          });
	});
});
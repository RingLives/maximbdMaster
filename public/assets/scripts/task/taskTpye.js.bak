$(document).ready(function(){
	$('#taskType').on('change',function(){
		var selectedValue = $.trim($("#taskType").find(":selected").val());
		if(selectedValue === 'booking'){

			$('#companyName').attr("disabled","true");
			$('#piFormat').attr("disabled","true");
			$('#bookingId').attr("disabled","true");
			$('#ipoIncrease').attr("disabled","true");
			$('#ipoIncrease').val('');
			$('#buyerChange').removeAttr("disabled","false");

			$('#piFormat').val('');
			$('#bookingId').val('');

			$('.buyer_company').addClass('hidden');
			$('.ipo_increase').addClass('hidden');
			$('.buyerChange').removeClass('hidden');
		}else if(selectedValue === 'PI'){

			$('#buyerChange').attr("disabled","true");
			$('#buyerChange').val('');
			$('#companyName').attr("disabled","true");
			$('#companyName').val('');
			$('#ipoIncrease').attr("disabled","true");
			$('#ipoIncrease').val('');
			$('#piFormat').removeAttr("disabled","false");
			$('#bookingId').removeAttr("disabled","false");

			$('.buyer_company').addClass('hidden');
			$('.ipo_increase').addClass('hidden');
			$('.piFormatH').removeClass('hidden');

		}else if(selectedValue === 'IPO'){

			$('#companyName').attr("disabled","true");
			$('#piFormat').attr("disabled","true");
			$('#bookingId').removeAttr("disabled","false");
			$('#ipoIncrease').removeAttr("disabled","false");

			$('.buyer_company').addClass('hidden');
			$('.buyerChange').addClass('hidden');
			$('.piFormatH').addClass('hidden');
			$('.ipo_increase').removeClass('hidden');

		}else if(selectedValue === 'MRF'){

			$('#piFormat').attr("disabled","true");
			$('#ipoIncrease').attr("disabled","true");
			$('#bookingId').removeAttr("disabled","false");

			$('.buyer_company').addClass('hidden');
			$('.ipo_increase').addClass('hidden');
			$('.buyerChange').addClass('hidden');
			$('.piFormatH').addClass('hidden');

		}else if(selectedValue === 'challan'){

			$('#piFormat').attr("disabled","true");
			$('#piFormat').val('');
			$('#bookingId').removeAttr("disabled","false");
			
			$('.buyer_company').addClass('hidden');
			$('.ipo_increase').addClass('hidden');
			$('.buyerChange').addClass('hidden');

		}else{

			$('#buyerChange').attr("disabled","true");
			$('#buyerChange').val("Choose buyer name");
			$('#companyName').attr("disabled","true");
			$('#piFormat').attr("disabled","true");
			$('#bookingId').attr("disabled","true");

			$('.buyer_company').addClass('hidden');
		}
		
	});
});
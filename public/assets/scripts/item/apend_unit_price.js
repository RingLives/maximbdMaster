$(document).ready(function () {
    $('.p_unit_price').on('keyup',function(){

    	var price = $('.p_unit_price').val();
    	$('.v_com_price').val(price);
    	var abc = $('.supplier_price').val();
    	if(abc == ''){
    		$('.supplier_price').val(price);
    	}
    });
});
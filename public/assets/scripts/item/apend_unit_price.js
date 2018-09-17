$(document).ready(function () {
    $('.p_unit_price').on('keyup',function(){

    	var price = $('.p_unit_price').val();
    	$('.v_com_price').val(price);
    	$('.supplier_price').val(price);
    });
});
$(document).ready(function(){
    ipoIncPercentageInput();
});

$('select[name=product_type]').change(function (e){
    ipoIncPercentageInput();
});

function ipoIncPercentageInput(){
    if($('select[name=product_type]').val() == 'IPO'){
        $('.ipo_increase_percentage').show();
    }else{
        $('.ipo_increase_percentage').hide();
    }
}
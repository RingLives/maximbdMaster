$('#booking_advanc_search').on('click',function (ev)
{
    displaySetup("#booking_simple_search_form", "#advance_search_form");
});

$('#booking_simple_search_btn').on('click',function (ev)
{
    displaySetup("#advance_search_form", "#booking_simple_search_form");
});

$("#booking_simple_search").click(function ()
{
    var booking_id = $('#booking_id_search').val();

    if(booking_id == ''){
        alert("The search field cannot be empty");
        return;
    }
    else
    {
        var results = ajaxFunc("/booking_list_by_booking_id/", "GET", "booking_id="+booking_id);
        addRow(results.responseJSON, 0);
    }
});

$('#advance_search_form').on('submit',function (ev)
{
    ev.preventDefault();
    var  data = $('#advance_search_form').serialize();
    var results = ajaxFunc("/booking_list_by_search/", "POST", data);

    if((results.responseJSON != '') && (results.responseJSON != null))
        addRow(results.responseJSON, 0);
    else {
        alert("No data  found");
    }
});

$('#booking_reset_btn').on('click',function () {
    location.reload();
    // resetAllInputs('#booking_id_search','#advance_search_form');
})

function ajaxFunc(url, type, data)
{
    return $.ajax({
        url:url,
        type:type,
        data:data,
        cache: false,
        async: false,
    });
}

function displaySetup(disNone, disBlock)
{
    $(disNone).css('display','none');
    $(disBlock).css('display','block');
}

function resetAllInputs(searchFld, form)
{
    $(searchFld).val('');
    $(form).each(function(){
        $(this).find(':input:text').val('');
        $("input[type='date']").val('');
    });
}

function setPagination(results, position) {
    // if(results.length > end)
    // {
    var pageNum = Math.ceil(results.length/15);
    var previous = (position-1);
    var next = (position+1);
    if(position == 1)
        previous = 1;
    if(position == pageNum)
        next = pageNum;
    $('.pagination').append('<li data-page="'+ previous +'"><span>&laquo;<span class="sr-only">(current)</span></span></li>').show();
    for (i = 1; i <= pageNum;)
    {
        $('.pagination').append('<li data-page="'+i+'">\<span>'+ i++ +'<span class="sr-only">(current)</span></span>\</li>').show();
    }
    $('.pagination').append('<li data-page="'+ next +'"><span>&raquo;<span class="sr-only">(current)</span></span></li>').show();
    // $('.pagination').append('<li><a href="http://127.0.0.1:8000/view/challan/list?page=2" rel="next">&raquo;</a></li>').show();

    $('.pagination li:nth-child('+ (position+1) +')').addClass('active');

    if(position == 1)
        $('.pagination li:first-child').addClass('disabled');
    if(position == pageNum)
        $('.pagination li:last-child').addClass('disabled');
    // }
}

function addRow(results, start)
{
    $('.pagination').empty();
    $('#booking_list_tbody').empty();
    $("#booking_list_pagination").css('display','none');

    var sl = 1;

    var position = start+1;
    start = start*15;

    if(results.length <start+15)
        end = results.length;
    else
        end = start+15;

    var rows = $.map(results, function(value, index) {
        return [value];
    });

    for (var i = start; i < end; i++)
    {
        $('#booking_list_tbody').append('<tr class="booking_list_table"><td>'+sl+
            '</td><td>'+rows[i].buyer_name+
            '</td><td>'+rows[i].Company_name+
            '</td><td>'+rows[i].attention_invoice+
            '</td><td>'+rows[i].booking_order_id+
            '</td><td>'+rows[i].created_at+
            '</td><td>'+
            '</td><td>'+
            '</td><td><a href="./createIpo/'+rows[i].booking_order_id+
            '" class="btn btn-info">IPO</a><a href="./createMrf/'+rows[i].booking_order_id+
            '" class="btn btn-warning">MRF</a><form action="./view/" target="_blank"><input type="hidden" name="bid" value="'+ rows[i].booking_order_id+
            '"><button class="btn btn-success">View</button></form></td></tr>');
        sl++;
    }

    setPagination(results, position);

    $('.pagination li').on('click',(function () {

        var begin = $(this).attr("data-page");
        addRow(results, begin-1);
    }));
}

// challan list Search option

$('#challan_advanc_search').on('click',function (ev)
{
    displaySetup("#challan_simple_search_form", "#challan_advance_search_form");
});

$('#challan_simple_search_btn').on('click',function (ev)
{
    displaySetup("#challan_advance_search_form", "#challan_simple_search_form");
});

$("#challan_simple_search").click(function ()
{
    var challan_id = $('#challan_id_search').val();

    if(challan_id == ''){
        alert("The search field cannot be empty");
        return;
    }
    else
    {
        var results = ajaxFunc("/challan_list_by_challan_id/", "GET", "challan_id="+challan_id);
        addRowInChallanList(results.responseJSON, 0);
    }
});

$('#challan_advance_search_form').on('submit',function (ev)
{
    ev.preventDefault();
    var  data = $('#challan_advance_search_form').serialize();
    var results = ajaxFunc("/challan_list_by_search/", "POST", data);

    if((results.responseJSON != '') && (results.responseJSON != null))
        addRowInChallanList(results.responseJSON, 0);
    else {
        alert("No data  found");
    }
});

function addRowInChallanList(results, start)
{
    $('.pagination').empty();
    $('#challan_list_tbody').empty();
    $("#challan_list_pagination").css('display','none');

    var getUrl = document.URL;
    var setUrl = getUrl.replace("view/challan/list","challan/list/action/task")

    var sl = 1;

    var position = start+1;
    start = start*15;

    if(results.length <start+15)
        end = results.length;
    else
        end = start+15;

    var rows = $.map(results, function(value, index) {
        return [value];
    });

    for (var i = start; i < end; i++)
    {
        $('#challan_list_tbody').append('<tr class="challan_list_table"><td>'+sl+
                '</td><td>'+rows[i].checking_id+
                '</td><td>'+rows[i].challan_id+
                '</td><td>'+rows[i].created_at+
                '</td><td><form action='+setUrl+' target="_blank"><input type="hidden" name="cid" value="'+ rows[i].challan_id+
                '"><input type="hidden" name="bid" value="'+ rows[i].checking_id+
                '"><button class="btn btn-success">View</button></form></td></tr>');
            sl++;
    }

    setPagination(results, position);

    $('.pagination li').on('click',(function () {

        var begin = $(this).attr("data-page");
        addRowInChallanList(results, begin-1);

    }));
}

$('#challan_reset_btn').on('click',function () {
    location.reload();
    // resetAllInputs('#challan_id_search','#challan_advance_search_form');
})

// MRF search List

$('#mrf_advanc_search').on('click',function (ev)
{
    displaySetup("#mrf_simple_search_form", "#mrf_advance_search_form");
});

$('#mrf_simple_search_btn').on('click',function (ev)
{
    displaySetup("#mrf_advance_search_form", "#mrf_simple_search_form");
});

$("#mrf_simple_search").click(function ()
{
    var mrf_id = $('#mrf_id_search').val();

    if(mrf_id == ''){
        alert("The search field cannot be empty");
        return;
    }
    else
    {
        var results = ajaxFunc("/mrf_list_by_mrf_id/", "GET", "mrf_id="+mrf_id);
        addRowInMrfanList(results.responseJSON, 0);
    }
});

$('#mrf_advance_search_form').on('submit',function (ev)
{
    ev.preventDefault();
    var  data = $('#mrf_advance_search_form').serialize();
    var results = ajaxFunc("/mrf_list_by_search/", "POST", data);

    if((results.responseJSON != '') && (results.responseJSON != null))
        addRowInMrfanList(results.responseJSON, 0);
    else {
        alert("No data  found");
    }
});

function addRowInMrfanList(results, start)
{
    $('.pagination').empty();
    $('#mrf_list_tbody').empty();
    $('.mrf_list_table').remove();
    $("#mrf_list_pagination").css('display','none');

    var getUrl = document.URL;
    var setUrl = getUrl.replace("mrf/list/list","task/mrf/task/list")
    var sl = 1;

    var position = start+1;
    start = start*15;

    if(results.length <start+15)
        end = results.length;
    else
        end = start+15;

    var rows = $.map(results, function(value, index) {
        return [value];
    });

    for (var i = start; i < end; i++)
    {
        $('#mrf_list_tbody').append('<tr class="mrf_list_table"><td>'+sl+
            '</td><td>'+rows[i].booking_order_id+
            '</td><td>'+rows[i].mrf_id+
            '</td><td>'+rows[i].created_at+
            '</td><td>'+rows[i].shipmentDate+
            '</td><td><form action='+setUrl+' target="_blank"><input type="hidden" name="mid" value="'+ rows[i].mrf_id+
            '"><input type="hidden" name="bid" value="'+ rows[i].booking_order_id+
            '"><button class="btn btn-success">View</button></form></td></tr>');
        sl++;
    }

    setPagination(results, position);

    $('.pagination li').on('click',(function () {

        // $('.pagination li').removeClass('active');
        // $(this).addClass('active');
        var begin = $(this).attr("data-page");
        addRowInMrfanList(results, begin-1);

    }));
}

$('#mrf_reset_btn').on('click',function () {
    location.reload();
})

$('#purchase_order_list_search_form').on('submit', function (ev) {

    ev.preventDefault();
    var  data = $('#purchase_order_list_search_form').serialize();
    var supplier_id = $('#supplier_id').val();
    if (supplier_id != '')
    {
        var results = ajaxFunc("/po_list_by_search/", "POST", data);

        if((results.responseJSON != '') && (results.responseJSON != null))
        {
            addRowInPOList(results.responseJSON[1]/*, 0*/);
            $('.polistResetBtnAndNo').css('display','block');
            $('.poTableList').css('display','block');
            $('.PONoInList').text(' PO no: '+results.responseJSON[0]);
        }
        else {
            $('.polistResetBtnAndNo').css('display','none');
            $('.poTableList').css('display','none');
            alert("No data  found");
        }
    }
    else {
        alert("Please Select any Supplier");
    }
});

function addRowInPOList(results/*, start*/)
{
    $('.pagination').empty();
    $('#po_list_tbody').empty();
    $('.po_list_table').remove();

    var getUrl = document.URL;
    var setUrl = getUrl.replace("mrf/list/list","task/mrf/task/list")
    var sl = 1;

    var rows = $.map(results, function(value, index) {
        return [value];
    });

    var finalTotalQnty = 0;
    var finalTotalAmnt = 0;

    for (var i = 0; i < rows.length; i++)
    {
        if(rows[i].item_size != null)
            var sizes = rows[i].item_size.split(',');
        else
            var sizes = [];

        if(rows[i].gmts_color != null)
            var colors = rows[i].gmts_color.split(',');
        else
            var colors = [];

        if(rows[i].item_quantity != null)
            var quantities = rows[i].item_quantity.split(',');
        else
            var quantities = [];

        if(rows[i].supplier_price != null)
            var unit_price = rows[i].supplier_price;
        else
            var unit_price = rows[i].unit_price;

        var spanLength = quantities.length;

        $('#po_list_tbody').append('<tr class="po_list_table"><td>'+sl+
            '</b></td><td rowspan="'+spanLength+'" style="vertical-align: middle; horiz-align: middle;" class="booking_order_id_'+i+'_0"><b>'+rows[i].booking_order_id+
            '</b></td><td rowspan="'+spanLength+'" style="vertical-align: middle; horiz-align: middle;" class="shipmentDate_'+i+'_0"><b>'+rows[i].shipmentDate+
            '</td><td rowspan="'+spanLength+'" style="vertical-align: middle; horiz-align: middle;" class="erp_code_'+i+'_0">'+rows[i].erp_code+
            '</td><td rowspan="'+spanLength+'" style="vertical-align: middle; horiz-align: middle;" class="item_code_'+i+'_0">'+rows[i].item_code+
            '</td><td class="sizes_'+i+'_0">'+sizes[0]+
            '</td><td class="matarial_'+i+'_0">'+rows[i].matarial+
            '</td><td class="gmts_color_'+i+'_0">'+colors[0]+
            '</td><td class="unit_'+i+'_0">'+''+
            '</td><td class="quantities_'+i+'_0">'+quantities[0]+
            '</td><td class="unitPrice_'+i+'_0">'+unit_price+
            '</td><td class="totalPrice_'+i+'_0">'+(quantities[0]*unit_price).toFixed(2)+
            '</td></tr>');
        sl++;

        var totalQnty = parseFloat(quantities[0]);
        var totalAmount = parseFloat(quantities[0]*unit_price);

        for (var j = 1; j < spanLength; j++)
        {
            totalQnty += parseFloat(quantities[j]);
            totalAmount += parseFloat(quantities[j]*unit_price);

            $('#po_list_tbody').append('<tr class="po_list_table"><td>'+sl+
                '</td><td class="sizes_'+i+'_'+j+'">'+sizes[j]+
                '</td><td class="matarial_'+i+'_'+j+'">'+rows[i].matarial+
                '</td><td class="gmts_color_'+i+'_'+j+'">'+colors[j]+
                '</td><td class="unit_'+i+'_'+j+'">'+''+
                '</td><td class="quantities_'+i+'_'+j+'">'+quantities[j]+
                '</td><td class="unitPrice_'+i+'_'+j+'">'+unit_price+
                '</td><td class="totalPrice_'+i+'_'+j+'">'+(quantities[j]*unit_price).toFixed(2)+
                '</td></tr>');
            sl++;
        }
        $('#po_list_tbody').append('<tr class="po_list_table"><td colspan="9" style="vertical-align: middle;"><b>Total</b></td><td class="totalQnty_'+i+'_l"><b>'+totalQnty.toFixed(2)+
            '</b></td><td class="totalUnitPirce_'+i+'_l"><b>'+''+
            '</b></td><td class="totalAmount_'+i+'_l"><b>'+totalAmount.toFixed(2)+
            '</b></td></tr>');

        finalTotalQnty += totalQnty;
        finalTotalAmnt += totalAmount;
    }

    $('#po_list_tbody').append('<tr class="po_list_table"><td colspan="9" style="vertical-align: middle;"><b> Final Total</b></td><td class="totalQnty_'+i+'_l"><b>'+finalTotalQnty.toFixed(2)+
        '</b></td><td class="totalUnitPirce_'+i+'_l"><b>'+''+
        '</b></td><td class="totalAmount_'+i+'_l"><b>'+finalTotalAmnt.toFixed(2)+
        '</b></td></tr>');
}

$('.save_purcahe_order').on('click', function (ev) {
    var it1 = 0;
    var po_no = $('.PONoInList').html().replace('PO no: ','');
    var datas = [['po_no','booking_order_no', 'shipment_date', 'erp_code', 'item_code', 'size', 'material', 'color', 'unit', 'qnty', 'unit_price', 'total_amnt']];
    while (true)
    {
        if($('.quantities_'+it1+'_0').length > 0)
        {
            var it2 = 0;
            var booking_order_id = $('.booking_order_id_'+it1+'_0').html().replace('<b>','').replace('</b>','');
            var shipmentDate = $('.shipmentDate_'+it1+'_0').html().replace('<b>','').replace('</b>','');
            var erp_code = $('.erp_code_'+it1+'_0').html();
            var item_code = $('.item_code_'+it1+'_0').html();

            while (true)
            {
                if ($('.quantities_'+it1+'_'+it2).length > 0)
                {
                    datas.push([po_no,
                        booking_order_id,
                        shipmentDate,
                        erp_code,
                        item_code,
                        $('.sizes_'+it1+'_'+it2).html(),
                        $('.matarial_'+it1+'_'+it2).html(),
                        $('.gmts_color_'+it1+'_'+it2).html(),
                        $('.unit_'+it1+'_'+it2).html(),
                        $('.quantities_'+it1+'_'+it2).html(),
                        $('.unitPrice_'+it1+'_'+it2).html(),
                        $('.totalPrice_'+it1+'_'+it2).html()]);
                    it2++;
                }
                else
                    break;
            }
            it1++;
        }
        else
            break;
    }
    var poDatajs = JSON.stringify(datas);
    // var saveData = ajaxFunc("/save_purcahse_order/", "GET", "data="+poDatajs);

    // alert(saveData.responseText);
    var getUrl = document.URL;
    var setUrl = getUrl.replace("/list","/report?data="+poDatajs);
    // console.log(results);
    window.location.assign(setUrl);
});

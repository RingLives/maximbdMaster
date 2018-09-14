$(document).ready(function(){

  $(".input_required").after(' <span class="req_star">*<span>');

  $('#languageSwitcher').change(function(){
      var locale = $(this).val();
      var _token = $("input[name = _token]").val();
      // alert(_token);

      $.ajax({
          type: "GET",
          url: "/language",
          data: {locale: locale, _token: _token},
          datatype: 'json',
          cache: false,
          async: false,
          success: function(result) {

              window.location.reload(true);

          },
          error: function(data) {
          },

      });
      $("#languageSwitcher").html(locale);
  });
});

$(document).ready(function(){

 function load_data(query)
 {
  $.ajax({
   url:"/search_trans_key",
   type:"GET",
   data:"value="+query,
   success:function(data)
   {
    if(query == ''){
      $("#hide_me").css('display', 'block');
      $('#result').html('');
    }
    else{
      $("#hide_me").css('display', 'none');
      // alert(data);
      $('#result').html(data);
    }
   },
   error: function(er) {
        alert("error");
    }
  });
}

 $('#searchFld').keyup(function(){
    var search = $(this).val();
    load_data(search);

  });
});

function getPermission(role_id){

  $('input:checkbox').removeAttr('checked');
  $(this).val('check all');

  var roleId =role_id.value;

  $.ajax({
      url:"/super-admin/permissions",
      type:"GET",
      data:"roleId="+roleId,
      cache: false,
      async: false,
      success:function(result){

        for (i = 0; i < result.length; i++) {
            document.getElementById(""+result[i]+"").checked = true;
        }

        $(".all_checkbox").css("display", "block");
        $('.single_check_box').removeAttr("disabled");

      },
      error:function(result){
        alert("Error");
      }
  });
}


$('.delete_id').click(function() {
  var href = "/_translation/manage";
  var check=confirm('Are you sure to delete the item ?');
  if(check==true){
   window.location.href = href;
  }else{
    return false;
  }
});

// $('.pagination').click(function() {
//   var href = $('.pagination').attr('href');
//   alert(href);
//   window.location.href = href;
//   // var check=confirm('The item will be deleted parmanently \n\n Are you sure ?');
//   // if(check==true){
//   //  window.location.href = href;
//   // }else{
//   //   return false;
//   // }
// });


var $rows = $('#tblSearch tr');
$('#user_search').on('keyup', function(){
    var string = $(this).val().toLowerCase();

    // var val = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase();


    $rows.show().filter(function() {
        var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
        return !~text.indexOf(string);
    }).hide();

     $rows.first().show();
});


$('#companyId').change(function(){
    var comId = $(this).find(':selected').val();
    var _token = $("input[name = _token]").val()

    $("#roleId option").remove();

  $.ajax({
      url:"/super-admin/getrolelist",
      type:"GET",
      data: {comId: comId, _token: _token},
      datatype: 'json',
      cache: false,
      async: false,
      success:function(result){

        var myObj = JSON.parse(result);

        $('#roleId').append($('<option>', {
            value: "",
            text : "Select Role"
        }));

        for(i in myObj){
              $('#roleId').append($('<option>', {
                  value: myObj[i].id,
                  text : myObj[i].name
              }));
        }



        $('#roleId').removeAttr("disabled");

      },
      error:function(result){
        alert("Error");
      }
  });

});

$('#selectAllcheckBox').click(function(){
    $(".single_check_box").prop('checked', true);
});

$('#unselectAllcheckBox').click(function(){
  $(".single_check_box").prop('checked', false);
});


$('#new_purchase_table_row').click(function(){
    $('.purchase_table tbody>tr:last').clone(true).insertAfter('.purchase_table tbody>tr:last');
});

$('#new_purchase_row_delete').click(function(){
    // alert("delete");
    $(this).closest("tr").remove();
});

$(document).ready(function(){

 function load_data(query)
 {
  // alert(query);
  $.ajax({
   url:"/search_purchased_client",
   type:"GET",
   data:"value="+query,
   success:function(data)
   {
    // alert(data);
    if(query == ''){
      // $("#hide_me").css('display', 'block');
      $('#clientSearchDiv').html('');
    }
    else{
      // $("#hide_me").css('display', 'none');
      $('#clientSearchDiv').html(data);
    }
   },
   error: function(er) {
        alert("error");
    }
  });
}

 $('#clientSearchFld').keyup(function(){
    var search = $(this).val();
    load_data(search);
      
  });
});

$(document).ready(function(){

 function load_data(query)
 {
  $.ajax({
   url:"/search_purchased_invoice",
   type:"GET",
   data:"value="+query,
   success:function(data)
   {
    // alert(data);
    if(query == ''){
      $('#invoiceSearchDiv').html('');
    }
    else{
      $('#invoiceSearchDiv').html(data);
    }
   },
   error: function(er) {
        alert("error");
    }
  });
}

 $('#invoiceSearchFld').keyup(function(){
    var search = $(this).val();
    load_data(search);
      
  });
});

function pressClick(client_name, client_id){
  $("#clientSearchFld").val(client_name);
  $("#clientSearchHiden").val(client_id);
  $('#clientSearchDiv').html('');
}

function invoicePressClick(invoice_code){
  $("#invoiceSearchFld").val(invoice_code);
  $('#invoiceSearchDiv').html('');
}



$('#product_group').change(function(){
    var product_group_id = $('select[name=product_group]').val();

    $("#product option").remove();

    $.ajax({
        url:"/product/get_product_group",
        type:"GET",
        data:'product_group_id='+product_group_id,
        datatype: 'string',
        cache: false,
        async: false,
        success:function(result){
          var myObj = JSON.parse(result);

          $('#product').append($('<option>', {
              value: "",
              text : "Select Product"
          }));

          for(i in myObj){
                $('#product').append($('<option>', {
                    value: myObj[i].id+","+myObj[i].product_code,
                    text : myObj[i].pro_name+" - "+myObj[i].pac_name+"("+myObj[i].quantity+") "+myObj[i].unit_name+"("+myObj[i].unit_quantity+")"
                }));
          }
          $('#product').removeAttr("disabled");
          

        },
        error:function(result){
          alert("ERROR > "+result);
        }
    });
});



var j=0;
var total = 0;
var vat = [0,0,0,0,0,0,0,0,0,0,0,0,0];
var final = 0;
$('.purchase_data_add').click(function(){

      var product_group = $('select[name=product_group]').find(":selected").text();
      // $('input[name=product_group_input]').val(product_group);
      var product_group_id = $('select[name=product_group]').val();
      // $('input[name=product_group_id_input]').val(product_group_id);        
      var date = $('#date').val();
      var client_name = $('select[name=client]').find(":selected").text();
      var client_id = $('select[name=client]').val();   
      var product_name = $('select[name=product]').find(":selected").text();      
      var product_code = $('select[name=product_code]').val();        
      var product_id = $('select[name=product]').find(":selected").val();
      var invoice = $('input[name=invoice]').val();  
      var quantity = $('input[name=quantity]').val();
      var price = $('input[name=price]').val();        
      var bonus = $('input[name=bonus]').val();    

      if(product_group != '' && product_group_id != '' && date != '' && client_name != '' && client_id != '' && product_name != '' && product_code != '' && product_id != '' && invoice != '' && quantity != '' && price != ''){
        
        $('.save_btn').removeAttr("disabled");
        
        var pro_id_code = product_id.split(",");
        var pro_id = pro_id_code[0];
        var pro_code = pro_id_code[1];


        $('.product_group_th').append('<input type="hidden" name="product_group['+j+']" value="'+product_group+'"  />');
        $('.product_group_th').append('<input type="hidden" name="product_group_id['+j+']" value="'+product_group_id+'"  />');
        $('.date_th').append('<input type="hidden" name="date['+j+']" value="'+date+'"  />');
        $('.client_th').append('<input type="hidden" name="client['+j+']" value="'+client_name+'"  />');
        $('.client_th').append('<input type="hidden" name="client_id['+j+']" value="'+client_id+'"  />');
        $('.product_th').append('<input type="text" name="product['+j+']" value="'+product_name+'"  />');
        $('.product_code_th').append('<input type="text" name="product_code['+j+']" value="'+pro_code+'"  />');
        $('.product_th').append('<input type="hidden" name="product_id['+j+']" value="'+pro_id+'"  />');
        $('.invoice_th').append('<input type="hidden" name="invoice['+j+']" value="'+invoice+'"  />');
        $('.quantity_th').append('<input type="text" name="quantity['+j+']" value="'+quantity+'"  />');
        $('.price_th').append('<input type="text" name="price['+j+']" value="'+price+'"  />');
        $('.bonus_th').append('<input type="hidden" name="bonus['+j+']" value="'+bonus+'"  />');

        var row_total_price = quantity*price; 
        $('.total_price_th').append('<input type="text" name="total_price['+j+']" value="'+row_total_price+'"  />');

        total += row_total_price;
        $('#cal_amount').text(total);

        final = total;

        var i=0;
        $('input[name^="vattax_percentage"]').each(function() {
              var vat_tax = $(this).val();
              $('.vat_tax_th_'+i+'').append('<input type="text" name="vat_tax['+j+']['+i+']" value="'+vat_tax+'"  />');

              vat[i] += (vat_tax*row_total_price)/100;
              $('#cal_vat_tax_'+i+'').text(vat[i]);

              final += vat[i];

            i++;
        });

        $('#cal_final').text(final);

        j++;

        $('.purchase_table_input input').val('');
        $(".purchase_table_input option:selected").prop("selected", false);
      }else{
        var varName = "";
        // if(product_group == ""){ varName += "Product Group\n" }
        if(product_group_id == ""){ varName += "Product Group\n" }
        if(date == ""){ varName += "Date\n" }
        if(product_id == ""){ varName += "Product Name\n" }
        if(client_id == ""){ varName += "Client \n" }
        if(invoice == ""){ varName += "Invoice\n" }
        if(quantity == ""){ varName += "Quantity\n" }
        if(price== ""){ varName += "Price\n" }
        alert(varName+ " \nFill these box.");
      }
});




$('#product_group_sale').change(function(){
    var product_group_id = $('select[name=product_group]').val();
    $("#product option").remove();


    $.ajax({
        url:"/product/get_product_group_sale",
        type:"GET",
        data:'product_group_id='+product_group_id,
        datatype: 'string',
        cache: false,
        async: false,
        success:function(result){
          var myObj = JSON.parse(result);
          $('#product').append($('<option>', {
              value: "",
              text : "Select Product"
          }));

          for(i in myObj){
                $('#product').append($('<option>', {
                    value: myObj[i].pro_id+","+myObj[i].product_code,
                    text : myObj[i].product_name+" - "+myObj[i].packet_name+"("+myObj[i].packet_quantity+") "+myObj[i].unit_name+"("+myObj[i].unit_quantity+")"
                }));
          }
          $('#product').removeAttr("disabled");
          

        },
        error:function(result){
          alert("ERROR > "+result);
        }
    });
});

var total_bonus = 0;
var invoice_gen_inc = 0;

$('.sale_data_add').click(function(){

      
      var order_no = $('input[name=order_no]').val();
      var transport_no = $('input[name=transport_no]').val();

      var product_group = $('select[name=product_group]').find(":selected").text();
      var product_group_id = $('select[name=product_group]').val();
      var product = $('select[name=product]').find(":selected").text();
      var product_details = $('select[name=product]').val();

      var sales_date = $('input[name=sales_date]').val();
      
      var transport_name = $('input[name=transport_name]').val();
      var transport_date = $('input[name=transport_date]').val();
      var invoice_no = $('input[name=invoice]').val();

      var client = $('select[name=client]').find(":selected").text();
      var client_id = $('select[name=client]').val();

      var quantity = $('input[name=quantity]').val();
      var sales_price = $('input[name=sales_price]').val();
      var bonus = $('input[name=bonus]').val();

      // alert(order_no+'-'+transport_no+'-'+product_group+'-'+sales_date+'-'+product_details+'-'+transport_name+'-'+transport_date+'-'+invoice_no+'-'+client_id+'-'+quantity+'-'+sales_price+'-'+bonus);

      if(product_group != "" &&
        product_group_id != "" &&
        product != "" &&
        product_details != "" &&
        sales_date != "" &&
        transport_name != "" &&
        transport_date != "" &&
        invoice_no != "" &&
        client != "" &&
        client_id != "" &&
        quantity != "" &&
        sales_price != ""){
          
          $('.save_btn').removeAttr("disabled");
          var pro_id_code = product_details.split(",");
          var pro_id = pro_id_code[0];
          var pro_code = pro_id_code[1];


          $('.order_no_th').append('<input type="text" name="order_no['+j+']" value="'+order_no+'"  />');
          $('.transport_no_th').append('<input type="text" name="transport_no['+j+']" value="'+transport_no+'"  />');
          
          $('.product_group_th').append('<input type="text" name="product_group['+j+']" value="'+product_group+'"  />');
          $('.product_group_th').append('<input type="hidden" name="product_group_id['+j+']" value="'+product_group_id+'"  />');
          
          $('.product_th').append('<input type="text" name="product_id['+j+']" value="'+product+'"  />');
          $('.product_th').append('<input type="hidden" name="product_code['+j+']" value="'+pro_code+'"  />');
          $('.product_th').append('<input type="hidden" name="product_id['+j+']" value="'+pro_id+'"  />');

          $('.sales_date_th').append('<input type="text" name="sales_date['+j+']" value="'+sales_date+'"  />');

          $('.transport_name_th').append('<input type="text" name="transport_name['+j+']" value="'+transport_name+'"  />');
          $('.transport_date_th').append('<input type="text" name="transport_date['+j+']" value="'+transport_date+'"  />');

          $('.invoice_th').append('<input type="text" name="invoice_no['+j+']" value="'+invoice_no+'"  />');
          
          $('.client_th').append('<input type="text" name="client['+j+']" value="'+client+'"  />');
          $('.client_th').append('<input type="hidden" name="client_id['+j+']" value="'+client_id+'"  />');
          
          $('.quantity_th').append('<input type="text" name="quantity['+j+']" value="'+quantity+'"  />');

          $('.sales_price_th').append('<input type="text" name="sales_price['+j+']" value="'+sales_price+'"  />');

          $('.bonus_th').append('<input type="text" name="bonus['+j+']" value="'+bonus+'"  />');



          //sajib quantity will be not deduct from db until sale submit
           $.ajax({
              url:"/pro_deduction",
              type:"GET",
              data:"product_id="+pro_id+"&product_quantity="+quantity+"&bonus="+bonus,
              datatype: 'string',
              cache: false,
              async: false,
              success:function(result){
                // alert(result);
              },
              error:function(result){
                alert("ERROR > "+result);
              }
          });



          var row_total_price = quantity*sales_price;

          total += row_total_price;
          $('#cal_amount').text(total);

          if(total_bonus > 0){

          }else{
            total_bonus = 0;
          }

          if(bonus > 0){

          }else{
            bonus = 0;
          }

          total_bonus = parseInt(total_bonus);
          bonus = parseInt(bonus);

          total_bonus = total_bonus+bonus;
          $('#bonus_amount').text(total_bonus);

          var i=0;
          $('input[name^="vattax_percentage"]').each(function() {
                var vat_tax = $(this).val();
                $('.vat_tax_th_'+i+'').append('<input type="text" name="vat_tax['+j+']['+i+']" value="'+vat_tax+'"  />');

                vat[i] += (vat_tax*row_total_price)/100;
                $('#cal_vat_tax_'+i+'').text(vat[i]);

                total += vat[i];

              i++;
          });

          $('#cal_final').text(total);


          j++;

          // Invoice Gererator increment
          invoice_gen_inc++;

          
      }else{
          var varName = "";

          if(order_no == ""){ varName += "Order No\n" }
          if(transport_no == ""){ varName += "Transport No\n" }

          if(product_group_id == ""){ varName += "Product Group\n" }
          if(product_details == ""){ varName += "Product Name\n" }
          if(client_id == ""){ varName += "Client Name\n" }
          if(invoice_no == ""){ varName += "Invoice No\n" }
          if(quantity == ""){ varName += "Quantity\n" }
          if(sales_date == ""){ varName += "Sale Date\n" }
          if(sales_price== ""){ varName += "Sales Price\n" }
          
          if(product_group== ""){ varName += "Product Group\n" }
          if(transport_name== ""){ varName += "Transport Name\n" }
          if(transport_date== ""){ varName += "Transport Date\n" }
        alert(varName+ " \nFill these box.");
      }

});



$("#generate_invoice_btn").click(function(){
    var product_group_invo = $('select[name=product_group]').find(":selected").text();
    var client_invo = $('select[name=client]').find(":selected").text(); 
    var client_invo_tmp = client_invo.split("",4);
    var invo_prefix =  client_invo_tmp['1']+""+client_invo_tmp['2']+""+client_invo_tmp['3'];
    invo_prefix = invo_prefix.toUpperCase();

    var fullDate = new Date();
    var twoDigitMonth = ((fullDate.getMonth().length+1) === 1)? (fullDate.getMonth()+1) : '0' + (fullDate.getMonth()+1);
    
    var year_tmp  = fullDate.getFullYear();

    var year_tmp2 = year_tmp.toString().substring(2, 4);

    var currentDate = year_tmp2 + "" + twoDigitMonth + "" + fullDate.getDate();
    
    var last_sale_id = 0;
    $.ajax({
        url:"/product/get_last_sale_id",
        type:"GET",
        datatype: 'string',
        cache: false,
        async: false,
        success:function(result){
          
          var myObj2 = JSON.parse(result);

            last_sale_id = myObj2.id+invoice_gen_inc;
          
        },
        error:function(result){
          alert("ERROR > "+result);
        }
    });
    $("#invoice").val(invo_prefix+currentDate+last_sale_id);
});



function checkAvailability(){

  var quantity = $('input[name=quantity]').val();
  
if(quantity==""){
  alert(quantity);
 $('input[name=bonus]').val("");
 $('input[name=bonus]').prop("disabled","true");
}else{
  $('input[name=bonus]').removeAttr("disabled");
}

  var product_details = $('select[name=product]').val();
  var pro_id_code = product_details.split(",");
  var pro_id = pro_id_code[0];
  var bonus = $('input[name=bonus]').val();
if(bonus==""){
  bonus=0;
}
  $.ajax({
        url:"/product/check_amount",
        type:"GET",
        data:"pro_id="+pro_id,
        datatype: 'string',
        cache: false,
        async: false,
        success:function(result){
          var myObj3 = JSON.parse(result);
          var last_quantity = myObj3.available_quantity;


          var left1  = last_quantity-quantity;
          var left   =left1-bonus;
            
          $("#available_q").val(left);

          if(left>-1){
            $('.sale_data_add').removeAttr("disabled");
            $('#available_q').css("border","0px solid transparent");
            
          }else{
            $('.sale_data_add').prop("disabled", true);
            $('#available_q').css("border","1px solid red");
          }

          
          
        },
        error:function(result){
          alert("ERROR > "+result);
        }
    });
}


var $rows = $('#tblSearch tr');
$('.search_available_q').click( function(){
    var string = $('select[name=a_q_s]').val().toLowerCase();

    $rows.show().filter(function() {
        // var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
        var text = $(this).text().toLowerCase();
        return !~text.indexOf(string);
    }).hide();

     $rows.first().show();
});

// $(document).ready(function(){
  $('#client').change(function(){
     var client_id = $(this).val();
     if (client_id == -1) {
       $('#myModal').css("display", "block");
       $('#myModal').modal("show");
     }/*else{
      $('#myModal').css("display", "none");
       $('#myModal').modal("hide");
     }*/
   });

   $('#create_urgent_client_post').submit(function(e){

     $('#contact_name').on('input', function() {
       var input=$(this);
       var is_name=input.val();
       if(is_name){input.removeClass("invalid").addClass("valid");}
       else{input.removeClass("valid").addClass("invalid");}
     });

     var formDatas = $("#create_urgent_client_post").serializeArray();

     var allInputFilled = true;

     jQuery.each( formDatas, function( key, field ) {
       if(!field.value){
         allInputFilled = false;
       }
     });

     if(!allInputFilled){
       alert("All Input field need to be filled....");
     }
     else{
       $.ajax({
          url:"/create_urgent_client_action",
          type:"POST",
          data: $("#create_urgent_client_post").serialize(),
          success:function(clients)
          {
           $('#myModal').modal("hide");
           $('#client').css('display', 'none');
           $('#divForSelectingClient').html(clients);
          },
          error: function(er) {
               alert("ERROR "+er);
           }
         });
     }
     e.preventDefault();
   });
// });

$("a[name=lc_purchase_summary_btn]").on("click", function (ev) {
    ev.preventDefault();
    var lc_purchase_product_id = $(this).attr("data-index");
    $.ajax({
      url:"purchase/summary",
      type:"GET",
      data:"lc_purchase_product_id="+lc_purchase_product_id,
      success:function(result)
      {
       $('.lc_purchase_product_view_modal').html(result);
       $('#myModal').css("display", "block");
       $('#myModal').modal("show");
      },
      error: function(er) {
           alert("ERROR "+er);
       }
     });
});

var acStatus = 0;
$("a[name=lc_purchase_table_update_btn]").on("click", function (ev) {
    ev.preventDefault();
    var lc_purchase_product_id = $(this).attr("data-index");
    $.ajax({
      url:"purchase/table_update",
      type:"GET",
      data:"lc_purchase_product_id="+lc_purchase_product_id,
      success:function(result)
      {
       // $(".lc_purchase_product_view_modal" ).empty();
       $('.lc_purchase_product_view_modal').html(result);
       $('#myModal').css("display", "block");
       $('#myModal').modal("show");
       acStatus = 1;
      },
      error: function(er) {
           alert("ERROR "+er);
       }
     });
    acStatus =1;
});

// $(".close").click(function() {
//     $( ".lc_purchase_product_view_modal" ).remove();
// });

$(window).click(function() {
    // if(acStatus == 1){
    //   alert(acStatus);
    //   $( ".lc_purchase_product_view_modal" ).remove();
    //   acStatus =0;
    // }
});

$('.modal-content').click(function(event){
  // alert("modal-content");
    event.stopPropagation();
});

$(document).ready(function(){
$('#client').change(function(){
   var client_id = $(this).val();
   if (client_id == -1) {
     $('#myModal').css("display", "block");
     $('#myModal').modal("show");
   }else{
    $('#myModal').css("display", "none");
     $('#myModal').modal("hide");
   }
 });
 });
function printDiv() 
{

  var divToPrint=document.getElementById('DivIdToPrint');

  var newWin=window.open('','Print-Window');

  newWin.document.open();

  newWin.document.write('<html><body onload="window.print()">'+divToPrint.innerHTML+'</body></html>');

  newWin.document.close();

  setTimeout(function(){newWin.close();},10);

}

$('#lc_search_with_others_field').click(function(ev) {
    $('#lc_others_seach_field_box').css("display", "block");
    $('#lc_search_with_others_field_close').css("display", "block");
     ev.preventDefault();
})

$('#lc_search_with_others_field_close').click(function(ev) {
    $('#lc_others_seach_field_box').css("display", "none");
    $('#lc_search_with_others_field_close').css("display", "none");
     ev.preventDefault();
})

$('#close_lc_purchase_update_modal').click(function(ev) {
    $('#myModal').css("display", "none");
    $('#myModal').modal("hide");
})


// $('#update_lc_product_btn').click(function(ev) {
//     ev.preventDefault();
//     $('#myModal').css("display", "none");
//     $('#myModal').modal("hide");
// })

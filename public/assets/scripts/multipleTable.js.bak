
$(document).ready(function(){
  var parentLii = '';
    // $('#page-wrapper').on('keyup', '.idclone .tr_clone .item_code', function(){

    //   var parentLi = $('.idclone').find(this).parent().parent().parent().prop('className');
    //     console.log('parentLi');
    //     console.log(parentLi);
    //     // $('#page-wrapper').on('keyup','.idclone .'+parentLi+' .item_code', function(){
    //     //   parentLii = $('.idclone').find(this).parent().parent().parent().prop('className');
        
    //     // });

    // });

    if(parentLii == ''){
      parentLii = 'tr_clone';
    }


    var incre = 0;
    $("#add").on('click',function(e) {
      e.preventDefault();
        var itemoption = {

          url: function(phrase) {
            return "/get/itemcode";
          },

          getValue: function(element) {
            return element.name;
          },

          list: {
              match: {
                  enabled: true
              },
              onChooseEvent: function(t){
                // console.log($("#page-wrapper .booking_item_code").val());
                console.log(t.val());

              }
          },

          ajaxSettings: {
            dataType: "json",
            method: "GET",
            data: {
              dataType: "json"
            }
          },

          requestDelay: 400
        };
          
        var clone = '';
        if(parentLii == 'tr_clone'){
            clone = $('.idclone .'+parentLii+':last').clone(true).append('<div class="btn"><i class="fa fa-minus-circle" style="font-size:20px"></i></div>');                
          }else{
            clone = $('.idclone .'+parentLii+':last').clone(true);             
          }      

          clone.addClass('tr_clone_'+incre).removeClass(parentLii).appendTo(".idclone");
          var itmelmvl = $(".tr_clone_"+incre+" .item_code").val();
          $(".tr_clone_"+incre+" .item_code").removeAttr('id');
          $(".tr_clone_"+incre+" .item_code").parents('.easy-autocomplete').remove();
          $(".tr_clone_"+incre+" .easy-autocomplete-container").remove();
          $(".tr_clone_"+incre+" .item_code").attr('id', 'item_codemxp_'+incre);
          $(".tr_clone_"+incre+" .item_code").attr('data-parent', 'tr_clone_'+incre);
          var itmelm = '<input class="booking_item_code item_code easyitemautocomplete" data-parent="tr_clone_'+incre+'" value="'+itmelmvl+'" type="text" name="item_code[]"  id="item_codemxp_'+incre+'">';
          $(".tr_clone_"+incre+" .item_codemxp_parent").append(itmelm);
          $('#item_codemxp_'+incre).easyAutocomplete(itemoption);

          incre++;

      return false;
    });
    $("#order_copy").on('click',function(e) {
      e.preventDefault();
        var copyitemoption = {
          url: function(phrase) {
            return "/get/itemcode";
          },
          getValue: function(element) {
            return element.name;
          },
          list: {
              match: {
                  enabled: true
              },
          },
          ajaxSettings: {
            dataType: "json",
            method: "GET",
            data: {
              dataType: "json"
            }
          },
          requestDelay: 400
        };
        var clone = '';
        if(parentLii == 'tr_clone'){
            clone = $('.idclone .'+parentLii+':last').clone(true).append('<div class="btn"><i class="fa fa-minus-circle" style="font-size:20px"></i></div>');                
          }else{
            clone = $('.idclone .'+parentLii+':last').clone(true);             
          }      
          clone.addClass('tr_clone_'+incre).removeClass(parentLii).appendTo(".idclone");
          var itmelmvl = $(".tr_clone_"+incre+" .item_code").val();
          $(".tr_clone_"+incre+" .item_code").removeAttr('id');
          $(".tr_clone_"+incre+" .item_code").parents('.easy-autocomplete').remove();
          $(".tr_clone_"+incre+" .easy-autocomplete-container").remove();
          $(".tr_clone_"+incre+" .item_code").attr('id', 'item_codemxp_'+incre);
          $(".tr_clone_"+incre+" .item_code").attr('data-parent', 'tr_clone_'+incre);
          var itmelm = '<input class="booking_item_code item_code easyitemautocomplete" data-parent="tr_clone_'+incre+'" value="'+itmelmvl+'" type="text" name="item_code[]"  id="item_codemxp_'+incre+'">';
          $(".tr_clone_"+incre+" .item_codemxp_parent").append(itmelm);
          $(".tr_clone_"+incre+" .booking_item_code").val('');
          $(".tr_clone_"+incre+" .item_sku").val('');
          $(".tr_clone_"+incre+" .item_qty").val('');
          $(".tr_clone_"+incre+" .item_price").val('');

          $(".tr_clone_"+incre+" .erpNo").find("option").remove();
          $(".tr_clone_"+incre+" .itemGmtsColor").find("option").remove();
          $(".tr_clone_"+incre+" .itemSize").find("option").remove();
          $('#item_codemxp_'+incre).easyAutocomplete(copyitemoption);
          incre++;

      return false;
    });
    $('.idclone').on('click', '.btn', function () {
     $(this).closest('tr').remove();
    });




  $('#page-wrapper').on('change','.item_code', function(){
      // console.log(parentLii);
      var item_code = $.trim($(this).val());
      var item_parent_class = $(this).data('parent');

      $.ajax({
          type: "GET",
          url: "/get/product/details/booking",
          data: "item="+item_code,
          datatype: 'json',
          cache: true,
          async: true,
          success: function(result) {
              var myObj = JSON.parse(result);
              if(myObj.length === 0)
              {
                $('.'+item_parent_class+' .erpNo').attr("disabled","true");
                $('.'+item_parent_class+' .itemSize').attr("disabled","true");
                $('.'+item_parent_class+' .itemGmtsColor').attr("readonly","true");

                $('.'+item_parent_class+' .erpNo').html($('<option>', {
                      value: "",
                      text : ""
                  }));
                $('.'+item_parent_class+' .itemSize').html($('<option>', {
                      value: "",
                      text : ""
                  }));

                $('.'+item_parent_class+' .itemGmtsColor').html($('<option>', {
                      value: "",
                      text : ""
                  }));

                  $('.'+item_parent_class+' .item_price').eq(incre).val('');                
                  $('.'+item_parent_class+' .item_price').eq(0).val('');                
                  $('.'+item_parent_class+' .item_qty').eq(0).val('');                

                
              }else{

                for(ik in myObj){
                  $('.'+item_parent_class+' .erpNo').html($('<option>', {
                      value: myObj[ik].erp_code,
                      text : myObj[ik].erp_code
                  }));
                }

                

                for(i in myObj){
                  if (myObj[i].size === null) {

                      $('.'+item_parent_class+' .itemSize').html($('<option>', {
                      value: "",
                      text : "empty Size"
                      }));

                  }else{

                    $('.'+item_parent_class+' .itemSize').html($('<option>', {
                    value: "",
                    text : "Select Size"
                    }));

                    var sizes = myObj[i].size.split(',');
                        sizes = $.unique(sizes);
                    for(j in sizes){
                      $('.'+item_parent_class+' .itemSize').append($('<option>', {
                        value: sizes[j],
                        text : sizes[j]
                    }));
                  }
                  }             
                }

                for(s in myObj){
                  if(myObj[s].color === null){
                    $('.'+item_parent_class+' .itemGmtsColor').html($('<option>', {
                    value: "",
                    text : "Empty Colors"
                    }));
                  }else{

                    $('.'+item_parent_class+' .itemGmtsColor').html($('<option>', {
                    value: "",
                    text : "Select colors"
                    }));

                    var colors = myObj[s].color.split(',');
                    var colors = $.unique(colors);
                    for(h in colors){
                      $('.'+item_parent_class+' .itemGmtsColor').append($('<option>', {
                        value: colors[h],
                        text : colors[h]
                    }));
                    }

                    $('.'+item_parent_class+' .itemGmtsColor').removeAttr("readonly","false");
                  }     
                }

                var increI = 0;
                for(ij in myObj){
                  $('.'+item_parent_class+' .others_color').eq(increI).val(myObj[ij].others_color);
                  $('.'+item_parent_class+' .item_description').eq(increI).val(myObj[ij].product_description);
                  $('.'+item_parent_class+' .item_price').eq(increI).val(myObj[ij].unit_price);
                  increI++;
                }

              $('.'+item_parent_class+' .erpNo').removeAttr("disabled","false");
              $('.'+item_parent_class+' .itemSize').removeAttr("disabled","false");

            }
          },
          error:function(result){
            alert("Error");
          }

      });
      // });
  });
});


$(document).ready(function(){
  
  var itemoptions = {

    url: function(phrase) {
      return "/get/itemcode";
    },

    getValue: function(element) {
      return element.name;
    },

    list: {
        match: {
            enabled: true
        },
        onChooseEvent: function(t){
          console.log(t.val());
        }
    },

    ajaxSettings: {
      dataType: "json",
      method: "GET",
      data: {
        dataType: "json"
      }
    },

    requestDelay: 400
  };
  
  var bookingoptions = {

    url: function(phrase) {
      return "/get/ordercode";
    },

    getValue: function(element) {
      return element.name;
    },

    list: {
        match: {
            enabled: true
        },
    },

    ajaxSettings: {
      dataType: "json",
      method: "GET",
      data: {
        dataType: "json"
      }
    },

    requestDelay: 400
  };

  $("#item_codemxp").easyAutocomplete(itemoptions);
  $("#bookingId").easyAutocomplete(bookingoptions);

});
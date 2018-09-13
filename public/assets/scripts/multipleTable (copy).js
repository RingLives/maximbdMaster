// $(document).ready(function() {
//   $("#add").click(function () {
//      var $clone = $('#filed_increment tbody>tr:last').clone();
//      console.log($clone);
//      // console.log($clone.$('input[name="erp"]').addClass('erp1'));
//      $clone.append("<td><div class='btn rmv' ><i class='fa fa-minus-circle'></i></div></td>");
//      $('#idclone').append($clone);

//      return false;
//   });

//   $('#filed_increment').on('click', '.rmv', function () {
//      // alert("wee");
//      $(this).closest('tr').remove();
//   });
// });

$(document).ready(function() {
    $("#add").on('click',function() {
    var clone = $('#filed_increment tbody>tr:last').clone(true);
    clone.insertAfter('#filed_increment tbody>tr:last');
    
    return false;
    });

  $('#abcde').change(function(){

      // var item_code = $(".item_code").val();

      var item_code = '';
      $('input[name^="item_code"]').each(function() {
        item_code = $(this).val();
      
      $.ajax({
          type: "GET",
          url: "/get/product/details",
          data: "item="+item_code,
          datatype: 'json',
          cache: false,
          async: false,
          success: function(result) {
              var myObj = JSON.parse(result);
              console.log(myObj);

              if(myObj === 'NULL')
              {
                alert("sssss");
                $('.erpNo').html($('<option>', {
                      value: " d",
                      text : " d"
                  }));
                   
              }else{
                // alert("shohi");

                for(ik in myObj){
                  $('.erpNo').html($('<option>', {
                      value: myObj[ik].erp_code,
                      text : myObj[ik].erp_code
                  }));
                }

                $('.itemSize').html($('<option>', {
                    value: "",
                    text : "Select Size"
                }));

                for(i in myObj){
                  var sizes = myObj[i].size.split(',');
                  for(j in sizes){
                    $('.itemSize').append($('<option>', {
                      value: sizes[j],
                      text : sizes[j]
                  }));
                  }
                }

                // for(ij in myObj){
                //   $('.item_price').html($('<option>', {
                //       value: myObj[ij].erp_code,
                //       text : myObj[ij].erp_code
                //   }));
                // }

              $('.erpNo').removeAttr("disabled");
              $('.itemSize').removeAttr("disabled");
            }
          },
          error:function(result){
            alert("Error");
          }

      });
      });
  });
});

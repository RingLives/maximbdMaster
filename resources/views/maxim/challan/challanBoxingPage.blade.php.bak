@extends('maxim.layouts.layouts')
@section('title','Challan Maxim')
@section('print-body')

	<center>
		<a href="#" onclick="myFunction()"  class="print">Print & Preview</a>
	</center>

	@php($i=0)
	@foreach($headerValue as $value)
	@for($i;$i <= 0;$i++)
	<div class="row">
		<div class="col-md-2 col-sm-2 col-xs-2">
			@if($value->logo_allignment == "left")
				@if(!empty($value->logo))
					<div class="pull-left">
						<img src="/upload/{{$value->logo}}" height="100px" width="150px" />
					</div>
				@endif
			@endif
		</div>
		<div class="col-md-8 col-sm-8 col-xs-8" style="padding-left: 40px;">
			<h2 align="center">{{ $value->header_title}}</h2>
			<div align="center">
					<p>FACTORY ADDRESS :  {{$value->address1}} {{$value->address2}} {{$value->address3}}</p>
			</div>
		</div>
		<div class="col-md-2 col-sm-2 col-xs-2">
			@if($value->logo_allignment == "right")
				@if(!empty($value->logo))
					<div class="pull-right">
						<img src="/upload/{{$value->logo}}" height="100px" width="150px" />
					</div>
				@endif
			@endif
		</div>
	</div>
	@endfor
	@endforeach
	<div class="row header-bottom">
		<div class="col-md-12 header-bottom-b">
			<span>Challan / Packing List</span>
		</div>
	</div>

	<div class="row body-top">
		<div class="col-md-8 col-sm-8 col-xs-7 body-list">
					@php($i=0)
					@foreach($buyerDetails as $Details)
					@for($i;$i <= 0;$i++)
						<ul>
							<li>Buyer : {{$Details->buyer_name}}</li>
							<li>Sold To : {{$Details->Company_name}}</li>
							<li>{{$Details->address_part1_invoice}}
						{{$Details->address_part2_invoice}}</li>
							<li>Atten : {{$Details->attention_invoice}}</li>
							<li>Cell : {{$Details->mobile_invoice}}</li>
						</ul>
					@endfor
					@endforeach
		</div>
		
		<div class="col-md-4 col-sm-4 col-xs-5 valueGenarate">
			@php ($i=0)
			@foreach ($multipleChallan as $billdata)
				@for($i;$i <= 0;$i++)
				<table class="tables table-bordered" style="width: 100%;">
					<tr >
						
						<td colspan="2">
							<div style="text-align: right;">
								<p style="padding-left :5px;"> Date : {{Carbon\Carbon::now()->format('Y-m-d')}}</p>
							</div>
						</td>
					</tr>
					<tr>
						
						<td colspan="2">
							<div style="text-align: right;">
								<p style="padding-left :5px;"> Challan no :{{$billdata->challan_id}}</p>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div style="text-align: right;">
								<p style="padding-left :5px;">Checking No :{{$billdata->checking_id}}  </p>

								<!-- {{Carbon\Carbon::parse($billdata->created_at)->format('dmY')}}: -->
							</div>
						</td>
					</tr>
					</div>
				</table>
			@endfor
			@endforeach
			
		</div>
	</div>

<div class="row">
	<div class="col-md-12">
		<h4>Dear Sir</h4>
		<p>We take the Plasure in issuing PROFORM INVOICE for the following article (s) on the terms and conditions set forth here under</p>
	</div>
</div>


<table class="table table-bordered">
    <thead>
        <tr>
        	<th width="5%">SI No</th>
        	<th width="15%">Description</th>
        	<th width="10%">Item code</th>
        	<th width="10%">OSS</th>
            <th width="10%">Style</th>
            <th width="14%">Size</th>
            <th width="6%">Quantity</th>
            <th width="10%">Weight</th>
            <th width="10%">Box</th>
        </tr>
    </thead>
    <tbody>
    	<?php
    		$j = 1;
    		$i = 0;    		
    		$totalAllQty = 0;
    		$totalUsdAmount = 0;
    		$BDTandUSDavarage = 80;
    		// print_r("<pre>");
    		// print_r($sentBillId);die();
    	 ?>
    		@foreach ($multipleChallan as $key => $item)

    			<?php
    				$totalQty =0;
    				$itemsize = explode(',', $item->item_size);  				
    				$qty = explode(',', $item->quantity);
    				$itemlength = 0;
    				foreach ($itemsize as $itemlengths) {
    					$itemlength = sizeof($itemlengths);
    				}
    				$itemQtyValue = array_combine($itemsize, $qty);   				
    			?>
	    			<tr>
	    				<td>{{$j++}}</td>
	    				<td rowspan="{{$itemlength}}">{{$item->erp_code}}</td>
	    				<td rowspan="{{$itemlength}}">{{$item->item_code}}</td>
	    				<td rowspan="{{$itemlength}}">{{$item->oss}}</td>
			    		<td rowspan="{{$itemlength}}">{{$item->style}}</td> 
			    		
			    			@if ($itemlength >= 1 )
				    			<td colspan="2" class="colspan-td">  				
				    				<table>
				    					@foreach ($itemQtyValue as $size => $Qty)
				    					<?php 
				    						$i++;
				    						$totalQty += $Qty; 
				    					?>
				    					<tr>
				    						<td width="70%">{{$size}}</td>
							    			<td width="30%">{{$Qty}}</td>
				    					</tr>
				    					@endforeach

				    					@if( $i > 1 )
				    					<tr>
				    						<td width="70%"></td>
				    						<td width="30%">{{$totalQty}}</td>
				    					</tr>
				    					@endif
				    				</table>
				    			</td>
				    		@endif			    		   
			    		<td rowspan="{{$itemlength}}"></td>
			    		
			    		<?php 
    						$totalAllQty += $totalQty;
    					?>
    					<td></td>
	    			</tr>
    		@endforeach
    	
    	<tr>
			<td colspan="6"><div style="text-align: center; font-weight: bold;font-size: ;"><span>Total Qty </span></div></td>
			<td>{{$totalAllQty}}</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="7"><div style="text-align: center;font-weight: bold;font-size: ;"><span> Total weight & Box : </span></div></td>
			<td></td>
			<td></td>
		</tr>
    		
    </tbody>
</table>

<h5><strong>REMARK</strong></h5>
<p>If the quantity of goods you recevied is not in confirmity as in packing irst or the qualify, packing problem incurred, please
inform us in 3days. After this period, you concern about this goods shall not be our responsibility.</p>
<h5>Please confirm receipt with your signature: </h5><br><br>




@foreach ($footerData as $value)
@if(!empty($value->siginingPerson_1))
<div class="row">
	<div class="col-md-12 col-xs-12" style="padding-bottom: 20px;">
		
		
		<div class="col-md-8 col-xs-8" style="padding: 5px; padding-left: 50px;">
			@if(!empty($value->siginingPersonSeal_1))
				<img src="/upload/{{$value->siginingPersonSeal_1}}" height="100px" width="150px" />
			@endif
		</div>
		
		<div class="col-md-4 col-xs-4"  style="">
			<div align="center">
				@if(!empty($value->siginingSignature_1))
				<img src="/upload/{{$value->siginingSignature_1}}" height="100px" width="150px" />
				@endif
			</div>
			<div align="center" style="margin:auto;
		    	border: 2px solid black;
		    	padding: 5px;margin-top:30px;">
				{{$value->siginingPerson_1}}
			</div>
		</div>
		
	</div>
</div>
@endif
@endforeach

@foreach ($footerData as $value)
@if(!empty($value->siginingPerson_2))
<div class="row">
	<div class="col-md-12 col-xs-12" style="padding-bottom: 20px;">
		
		
		<div class="col-md-8 col-xs-8" style="padding: 5px; padding-left: 50px;">
			@if(!empty($value->siginingPersonSeal_2))
				<img src="/upload/{{$value->siginingPersonSeal_2}}" height="100px" width="150px" />
			@endif
		</div>
		
		<div class="col-md-4 col-xs-4"  style="">
			<div align="center">
				@if(!empty($value->siginingSignature_2))
					<img src="/upload/{{$value->siginingSignature_2}}" height="100px" width="150px" />
				@endif
			</div>
			<div align="center" style="margin:auto;
		    	border: 2px solid black;
		    	padding: 5px;margin-top:30px;">
				{{$value->siginingPerson_2}}
			</div>
		</div>
	</div>
</div>
@endif
@endforeach


<script type="text/javascript">
		function myFunction() {
	    window.print();
	}
</script>
@endsection

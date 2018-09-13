@extends('print_file.layouts.layouts')
@section('print-body')

<center>
	<a href="#" onclick="myFunction()" class="print">Print & Preview</a>
</center>



	@foreach($headerValue as $value)
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
		<div class="col-md-8 col-sm-8 col-xs-7" style="padding-left: 40px;">
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
	@endforeach
	<div class="row header-bottom">
		<div class="col-md-12 header-bottom-b">
			<span>BILL COPY</span>
		</div>
	</div>

	<div class="row body-top">
		<div class="col-md-8 col-sm-8 col-xs-7 body-list">
					@php($i=0)
					@foreach($sentBillId as $Datils)
					@for($i;$i <= 0;$i++)
						<ul>
							<li>Buyer : {{$Datils->name_buyer}}</li>
							<li>Sold To : {{$Datils->name}}</li>
							<li>{{$Datils->address}}</li>
							<li>Atten : {{$Datils->attention_invoice}}</li>
							<li>Cell : {{$Datils->mobile_invoice}}</li>
						</ul>
					@endfor
					@endforeach
		</div>
		
		<div class="col-md-4 col-sm-4 col-xs-5">
			@php ($i=0)
			@foreach ($sentBillId as $billdata)
				@for($i;$i <= 0;$i++)
				<table class="tables table-bordered" style="width: 100%;">
					<tr>
						<td colspan="2">
							<div style="text-align: right;">
								<p style="padding-left :5px;"> Invo no : {{$billdata->bill_id}}</p>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div style="text-align: right;">
							<p style="padding-left :5px;"> Date : {{Carbon\Carbon::parse($billdata->created_at)->format('Y-m-d')}}</p>
						</div>
						</td>
					</tr>
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
        	<th width="15%">Item no/ERP</th>
        	<th width="15%">Item code</th>
        	<th width="10%">OSS</th>
            <th width="10%">Style</th>
            <th width="14%">Size</th>
            <th width="6%">Qty/ Pcs</th>
            <th width="10%">Unit Price/ Pcs</th>
            <th width="10%">USD Amount</th>
        </tr>
    </thead>
    <tbody>
    	<?php
    		$i = 0;    		
    		$ik = 0;    		
    		$totalAllQty = 0;
    		$totalUsdAmount = 0;
    		$BDTandUSDavarage = 80;
    		$rowspanValue = 0;
    	 ?>
    	 	@foreach ($sentBillId as $counts)
    	 		<?php
    	 			$count = 1;
    	 			$rowspanValue += $count ; 
    	 		 ?>
    	 	@endforeach
    		@foreach ($sentBillId as $key => $item)

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
	    				<td rowspan="{{$itemlength}}">{{$item->erp_code}}</td>
	    				<td rowspan="{{$itemlength}}">{{$item->item_code}}</td>
	    				<!-- @for($ik; $ik<=0; $ik++) -->
	    				<!-- @endfor -->
	    				<td rowspan="">{{$item->oss}}</td>
	    				
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
			    		<td rowspan="{{$itemlength}}">${{$item->unit_price}}</td>
			    		
			    		<?php 
    						$totalAllQty += $totalQty;
    						$UsdAmount = $totalQty * $item->unit_price;

    						$totalUsdAmount += $UsdAmount;
    						$totalUsdAmount = floor($totalUsdAmount * 100) / 100;
    						
    						$BDTandUSD = $BDTandUSDavarage * $totalUsdAmount;
    						$BDTandUSD = floor($BDTandUSD * 100) / 100;
    					?>
    					<td>${{$UsdAmount}}</td>
	    			</tr>
    		@endforeach
    	<?php 
    		// $BDTandUSD = $BDTandUSDavarage * $totalUsdAmount;
    		// $totalAllQty = str_replace(",","",$totalAllQty);
    		// $totalUsdAmount = number_format($totalAllQty, 2, '.', '');
    		// $BDTandUSD = number_format($BDTandUSD, 2, '.', '');
    	?>
    	<tr>
			<td colspan="5"><div style="text-align: center; font-weight: bold;font-size: ;"><span>Total Qty </span></div></td>
			<td>{{$totalAllQty}}</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="7"><div style="text-align: center;font-weight: bold;font-size: ;"><span> Total Amount USD </span></div></td>
			<td>${{$totalUsdAmount}}</td>
		</tr>
		<tr>
			<td colspan="6"><div style="text-align: center;font-weight: bold;font-size: ;"><span> Total Amount BDT </span></div></td>
			<td>{{$BDTandUSDavarage}}</td>
			<td>{{$BDTandUSD}}</td>
		</tr>
    		
    </tbody>
    <tfoot>
    	<tr>
    		<!-- <td width="">Total Amount USD</td> -->
    	</tr>
    </tfoot>
</table>

<div class="row">
	<div class="col-md-12">
		<table  border="5px solid #DBDBDB" class="table table-bordered">
			<tr>
				<td>
					<?php 
						function convertNumberToWord($num = false) { 
							$num = str_replace(array(',', ' '), '' , trim($num));
							 if(! $num) {
							  return false; 
							} 
							$num = (int) $num;
							 $words = array(); 
							 $list1 = array('', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen' );
							  $list2 = array('', 'Ten', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety', 'Hundred');
							   $list3 = array('', 'Thousand', 'Million', 'Billion', 'Trillion', 'Quadrillion', 'Quintillion', 'sextillion', 'septillion', 'octillion', 'nonillion', 'decillion', 'undecillion', 'duodecillion', 'tredecillion', 'quattuordecillion', 'quindecillion', 'sexdecillion', 'septendecillion', 'octodecillion', 'novemdecillion', 'vigintillion' );
							    $num_length = strlen($num);
							    $levels = (int) (($num_length + 2) / 3);
							    $max_length = $levels * 3; 
							    $num = substr('00' . $num, -$max_length); 
							    $num_levels = str_split($num, 3); 
							    for ($i = 0; $i < count($num_levels); $i++) 
							    	{ 
							    		$levels--; 
							    		$hundreds = (int) ($num_levels[$i] / 100); 
							    		$hundreds = ($hundreds ? ' ' . $list1[$hundreds] . ' hundred' . ' ' : ''); 
							    		$tens = (int) ($num_levels[$i] % 100); 
							    		$singles = ''; if ( $tens < 20 ) { 
							    			$tens = ($tens ? ' ' . $list1[$tens] . ' ' : '' ); 
							    		} else { 
							    			$tens = (int)($tens / 10); $tens = ' ' . $list2[$tens] . ' '; 
							    			$singles = (int) ($num_levels[$i] % 10); 
							    			$singles = ' ' . $list1[$singles] . ' '; 
							    		} 
							    		$words[] = $hundreds . $tens . $singles . ( ( $levels && ( int ) ( $num_levels[$i] ) ) ? ' ' . $list3[$levels] . ' ' : '' ); 
							    	} 

						$commas = count($words); if ($commas > 1) { $commas = $commas - 1; }

						 return implode(' ', $words); }

						 $fractionUSD = explode('.', $totalUsdAmount);
						 $amountInWordUsd = convertNumberToWord($fractionUSD[0]);
						 if(sizeof($fractionUSD) > 1){
						 	$fractionInWordUSD = convertNumberToWord($fractionUSD[1]);
						 }
						 

						 $fractionBD = explode('.', $BDTandUSD);
						 $amountInWordBD = convertNumberToWord($fractionBD[0]);
						 if(sizeof($fractionBD) > 1){
						 	$fractionInWordBD = convertNumberToWord($fractionBD[1]);
						 }
					?>
					<div style="text-align:;font-weight: bold;">
						<?php if(sizeof($fractionUSD) == 1){ ?>
						<span>1. TOTAL AMOUNT : USD : {{$amountInWordUsd}} Only</span>
						<?php }else{?>
						<span>1. TOTAL AMOUNT : USD : {{$amountInWordUsd}} And {{$fractionInWordUSD}} Cents Only</span>
						<?php }?>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div style="text-align:;font-weight: bold;">
						<?php if(sizeof($fractionBD) == 1){?>
						<span>1. TOTAL AMOUNT : BDT : {{$amountInWordBD}} Only</span>
						<?php }else{?>
						<span>1. TOTAL AMOUNT : BDT : {{$amountInWordBD}} And {{$fractionInWordBD}} Cents Only</span>
						<?php }?>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>

<div class="row">
	<div class="col-md-12">
		<table class="table table-bordered">
			<tr>
				<td>2.Payment Terms : TT/FDD/CHAQUE/CASH BEFORENSHIPMENT</td>
			</tr>
			<tr>
				<td>3.Shipment : By COURIER/ CARGO</td>
			</tr>
			<tr>
				<td>
					4. Packing : MAXIM STANDARD PACKING
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	function myFunction() {
	    window.print();
	}
</script>
@endsection

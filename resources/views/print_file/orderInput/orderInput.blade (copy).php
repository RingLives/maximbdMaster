@extends('layouts.dashboard')
@section('page_heading',
trans('others.mxp_menu_bill_copy'))
@section('section')
<div class="col-md-12">
	@if ($errors->any())
	    <div class="alert alert-danger">
	        <ul>
	            @foreach ($errors->all() as $error)
	               <li>{{ $error }}</li>
	            @endforeach
	        </ul>
	    </div>
	@endif
	@if(Session::has('error_code'))
    	@include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('error_code') ))
	@endif

		<form class="" action="{{ Route('input_order_action') }}" role="form" method="POST" >
            <input type="hidden" name="_token" value="{{ csrf_token() }}">

			<table class="table-striped" id="filed_increment">
				<thead>
					<tr>
						<th width="20%">ERP Code</th>
						<th>Item Code</th>
						<th>Item Size</th>
						<th>Item Qty</th>
						<th>Item price</th>
					</tr>
				</thead>
				<tbody id="idclone" >
					<tr class="tr_clone">
						<td width="20%">
							<div class="form-group">
								<!-- <input type="text" name="erp[]" class="form-control"> -->

								<select name="erp[]" class="form-control erpNo" style="width: 100%" id="erpNo" disabled>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group" id="abcde">
								<input type="text" name="item_code[]" class="form-control item_code">
							</div>
						</td>
						<td width="20%">
							<div class="form-group">
								<!-- <input type="text" name="item_size[]" class="form-control"> -->

								<select name="item_size[]" class="form-control itemSize" id="itemSize" disabled>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="item_qty[]" class="form-control">
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="item_price[]" class="form-control item_price">
							</div>
						</td>
					</tr>
				</tbody>		
			</table>
			<div class="form-group button_add">
				<button type="submit" class="btn btn-success" id="add"><i class="fa fa-plus" style="padding-right: 5px;"></i>Add Filed</button>
			</div>
			<div class="form-group">
				<button type="submit" class="btn btn-primary">Submit</button>
			</div>
		</form>

</div>
@endsection
<?php

namespace App\Http\Controllers\Production;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Supplier;
use App\Model\MxpMrf;
use App\Model\MxpPurchaseOrder;
use DB;

class PurchaseOrderController extends Controller
{
    const WaitngForGoodsMRF = "Waiting_for_Goods";
    public function index(Request $request)
    {
        $suppliers = Supplier::where('status', 1)
            ->where('is_delete', 0)
            ->get();

        return view('production.purchaseOrder.purchase_order_list', compact('suppliers'));
    }

    public function getPOListBySearch(Request $request)
    {
//        $new_date = date_create_from_format('Y-m-d H:i', $request->from_oder_date_search);
//        $new_date->getTimestamp();
//        $new_date = date('Y-m-d H:i', $request->from_oder_date_search);

//        $from_date = $this->getDateTImeInFormate($request->from_oder_date_search);
//        $to_date = $this->getDateTImeInFormate($request->to_oder_date_search);
//        return $from_date.' and '.$to_date;
        $cc = MxpPurchaseOrder::distinct('po_no')->count('po_no');
        $count = str_pad($cc + 1, 4, 0, STR_PAD_LEFT);
        $id = "PO" . "-";
        $date = date('dmY');
        $poUniqueId = $id . $date . "-" . $count;

        $query = 'SELECT mrf.booking_order_id, mrf.shipmentDate, group_concat(mrf.erp_code) as erp_code, 
          group_concat(mrf.item_code) as item_code, group_concat(mrf.mrf_id) as mrf_id, group_concat(mrf.item_size) as item_size, 
          group_concat(mrf.matarial) as matarial, group_concat(mrf.item_price) as item_price, 
          group_concat(mrf.gmts_color) as gmts_color, group_concat(mrf.mrf_quantity) as item_quantity, 
          group_concat(msp.supplier_price) as supplier_price, group_concat(mp.unit_price) as unit_price, 
          group_concat(mp.product_id) as product_id FROM mxp_MRF_table mrf LEFT JOIN mxp_product mp 
          ON(mrf.item_code = mp.product_code AND mrf.erp_code = mp.erp_code) LEFT JOIN 
          mxp_supplier_prices msp ON(mp.product_id = msp.product_id AND msp.supplier_id = ';

        $checkValidation = false;

        if($request->supplier_id != ''){
            $checkValidation = true;
            $query .= ($request->supplier_id.' ) WHERE  mrf.supplier_id = '.$request->supplier_id.' AND');
        }

        if($request->purchase_order_no_search != ''){
            $checkValidation = true;
            $query .= (' mrf.booking_order_id = "'.$request->purchase_order_no_search.'" AND');
        }

        if($request->from_oder_date_search != '' && $request->to_oder_date_search != '')
        {
            $from_date = $this->getDateTImeInFormate($request->from_oder_date_search);
            $to_date = $this->getDateTImeInFormate($request->to_oder_date_search);

            $checkValidation = true;
            if($from_date == $to_date)
                $query .= (' mrf.created_at = "'.$from_date.'" AND');

            else
                $query .= (' mrf.created_at >= "'.$from_date.'" AND mrf.created_at <= "'.$to_date.'" AND');
        }
        if($checkValidation)
        {
            $mainQuery = rtrim($query," AND ");
            $POList = DB::select($mainQuery.' group by booking_order_id ORDER BY id DESC');
// print '<pre>';
// print_r(array($poUniqueId, $POList));
// die();
            return array($poUniqueId, $POList);
        }
        else
            return '';
    }

    public function savePurchaseOrder(Request $request)
    {
        $setPurchaseOrders = json_decode($request->data, true);

        for($i = 1; $i < count($setPurchaseOrders); $i++) {
            $po = new MxpPurchaseOrder();

            $po->po_no = $setPurchaseOrders[$i][0];
            $po->booking_order_id = $setPurchaseOrders[$i][1];
            $po->shipment_date = $setPurchaseOrders[$i][2];
            $po->erp_code = $setPurchaseOrders[$i][3];
            $po->item_code = $setPurchaseOrders[$i][4];
            $po->item_size = $setPurchaseOrders[$i][5];
            $po->material = $setPurchaseOrders[$i][6];
            $po->gmts_color = $setPurchaseOrders[$i][7];
            $po->unit = str_replace('$', '', $setPurchaseOrders[$i][8]);
            $po->item_quantity = $setPurchaseOrders[$i][9];
            $po->unit_price = str_replace('$', '', $setPurchaseOrders[$i][10]);
            $po->total_amount = str_replace('$', '', $setPurchaseOrders[$i][11]);
            $po->save();

            $mrf = MxpMrf::where('mrf_id', $setPurchaseOrders[$i][12])->first();
            $mrf->mrf_status = self::WaitngForGoodsMRF;
            $mrf->save();
        }

        return $setPurchaseOrders[1][0];

    }

    public function getReport(Request $request)
    {
        $datas = explode(',',$request->data);

        $getPurchaseOrders = DB::select('select po_no, shipment_date, booking_order_id, 
              group_concat(erp_code) as erp_code, 
              group_concat(item_code) as item_code, 
              group_concat(item_size) as item_sizes , 
              group_concat(material) as materials, 
              group_concat(gmts_color) as gmts_colors, 
              group_concat(unit) as units, 
              group_concat(item_quantity) as item_quantitys, 
              group_concat(unit_price) as unit_prices, 
              group_concat(total_amount) as total_amounts from mxp_purchase_orders where po_no = " '.
            $datas[0].'" group by booking_order_id');
        $headerValue = DB::table("mxp_header")->where('header_type',11)->get();
        $footerData = DB::select("select * from mxp_reportFooter");

        $purchaseOrders[] = $getPurchaseOrders;

        $suplier = Supplier::find($datas[1]);



        return view('print_file.purchase_order.purchase_order_report', ['purchaseOrders' => $getPurchaseOrders, 'headerValue' => $headerValue, 'footerData' => $footerData, 'supplier'=> $suplier]);
    }

    private function getDateTImeInFormate($dateTIme){
        $elements = explode(' ', $dateTIme);
        $dates = explode('/', $elements[0]);
        $times = explode(':', $elements[1]);
        if($times[0] == 12)
            $times[0] == 00;

        if($elements[2] == 'AM'){
            if ($times[0] < 6)
                $format = $dates[2].'-'.$dates[0].'-'.($dates[1]-1).' '.($times[0]+18).':'.$times[1].':00';
            else
                $format = $dates[2].'-'.$dates[0].'-'.($dates[1]).' '.($times[0]-6).':'.$times[1].':00';
        }
        else
            $format = $dates[2].'-'.$dates[0].'-'.($dates[1]).' '.($times[0]+6).':'.$times[1].':00';

        return $format;
    }
}

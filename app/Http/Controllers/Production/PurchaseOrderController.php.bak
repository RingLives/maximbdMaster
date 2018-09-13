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
    public function index(Request $request)
    {
        $suppliers = Supplier::where('status', 1)
            ->where('is_delete', 0)
            ->get();

        return view('production.purchaseOrder.purchase_order_list', compact('suppliers'));
    }

    public function getPOListBySearch(Request $request)
    {
//        $validator = Validator::make($request->all(), [
//            'bookingIdList' => 'required',
//            'supplier_id' => 'required',
//        ]);
//
//        if ($validator->fails()) {
//            return '';
//        }
//        $bookedId = rtrim($request->bookingIdList,", ");

//        $bookingIds = explode(",",$bookedId);
        $bookingIdList = [];
        $companyName = '';
        $iteration = 0;

        $cc = MxpPurchaseOrder::distinct('po_no')->count('po_no');
        $count = str_pad($cc + 1, 4, 0, STR_PAD_LEFT);
        $id = "PO" . "-";
        $date = date('dmY');
        $poUniqueId = $id . $date . "-" . $count;

        $query = 'SELECT mrf.*, msp.supplier_price, mp.unit_price, mp.product_id FROM mxp_MRF_table mrf LEFT JOIN mxp_product mp ON(mrf.item_code = mp.product_code AND mrf.erp_code = mp.erp_code) LEFT JOIN mxp_supplier_prices msp ON(mp.product_id = msp.product_id AND msp.supplier_id = ';
        $checkValidation = false;

        if($request->supplier_id != ''){
            $checkValidation = true;
            $query .= ($request->supplier_id.' ) WHERE  mrf.supplier_id = '.$request->supplier_id.' AND');
        }
//
        if($request->purchase_order_no_search != ''){
            $checkValidation = true;
            $query .= (' mrf.booking_order_id = "'.$request->purchase_order_no_search.'" AND');
        }

        if($request->from_oder_date_search != '' && $request->to_oder_date_search != '')
        {
            $checkValidation = true;
            if($request->from_oder_date_search == $request->to_oder_date_search)
                $query .= (' mrf.shipmentDate = "'.$request->from_oder_date_search.'" AND');

            else
                $query .= (' mrf.shipmentDate >= "'.$request->from_oder_date_search.'" AND mrf.shipmentDate <= "'.$request->to_oder_date_search.'" AND');
        }

        if($checkValidation)
        {
            $mainQuery = rtrim($query," AND ");
            $POList = DB::select($mainQuery.' ORDER BY id DESC');
//            return $POList;
            return array($poUniqueId, $POList);
        }
        else
            return '';
    }

    public function getReport(Request $request)
    {
        $setPurchaseOrders = json_decode($request->data, true);

        for($i = 1; $i < count($setPurchaseOrders); $i++)
        {
            $po = new MxpPurchaseOrder();

            $po->po_no = $setPurchaseOrders[$i][0];
            $po->booking_order_id = $setPurchaseOrders[$i][1];
            $po->shipment_date = $setPurchaseOrders[$i][2];
            $po->erp_code = $setPurchaseOrders[$i][3];
            $po->item_code = $setPurchaseOrders[$i][4];
            $po->item_size = $setPurchaseOrders[$i][5];
            $po->material = $setPurchaseOrders[$i][6];
            $po->gmts_color = $setPurchaseOrders[$i][7];
            $po->unit = $setPurchaseOrders[$i][8];
            $po->item_quantity = $setPurchaseOrders[$i][9];
            $po->unit_price = $setPurchaseOrders[$i][10];
            $po->total_amount = $setPurchaseOrders[$i][11];
            $po->save();
        }

        $getPurchaseOrders = DB::select('select po_no, booking_order_id, shipment_date, erp_code, item_code, group_concat(item_size) as item_sizes , group_concat(material) as materials, group_concat(gmts_color) as gmts_colors, group_concat(unit) as units, group_concat(item_quantity) as item_quantitys, group_concat(unit_price) as unit_prices, group_concat(total_amount) as total_amounts from mxp_purchase_orders where po_no = "'.
            $setPurchaseOrders[1][0].'" group by booking_order_id');
        $headerValue = DB::table("mxp_header")->where('header_type',11)->get();
        $footerData = DB::select("select * from mxp_reportFooter");

        $purchaseOrders[] = $getPurchaseOrders;

//        $this->print_me($getPurchaseOrders);

//        return $getPurchaseOrders;
        return view('print_file.purchase_order.purchase_order_report', ['purchaseOrders' => $getPurchaseOrders, 'headerValue' => $headerValue, 'footerData' => $footerData]);

    }
}

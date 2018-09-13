<?php

namespace App\Http\Controllers\Source;

use App\Http\Controllers\Controller;

class ConverterText extends Controller
{
	public function convertNumberToWord($num = false) {
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

	 return implode(' ', $words); 
	}		 
}
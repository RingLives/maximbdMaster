<?php

namespace App\Http\Interfaces;

use Illuminate\Http\Request;

interface SubModuleInterface {

	// To create the blade(view) file of related list
	public function listView(Request $request);

	// To create the form to create or added new data
	public function formView(Request $request);

	// To upload the data of form view
	public function dataUpload(Request $request);

	// To update the existing data
	public function update(Request $request);

	// To delete data
	public function delete(Request $request);

}
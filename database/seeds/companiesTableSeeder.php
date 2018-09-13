<?php

use Illuminate\Database\Seeder;

class companiesTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('mxp_companies')->insert([
            'group_id' => 1,
            'name' => 'MaxPro It Solutions',
            'description' => 'It is a software company',
            'address' => 'SegunBagicha, Dhaka',
            'phone' => '01785263985',
            'is_active' => 1,
        ]);

        DB::table('mxp_companies')->insert([
            'group_id' => 1,
            'name' => 'MaxPro School and College',
            'description' => 'Both school and college',
            'address' => 'Gulshan, Dhaka',
            'phone' => '01785895623',
            'is_active' => 1,
        ]);

        DB::table('mxp_companies')->insert([
            'group_id' => 1,
            'name' => 'MaxPro Food Corners',
            'description' => 'It is a food company',
            'address' => 'Mohakhali, Dhaka',
            'phone' => '01785785412',
            'is_active' => 1,
        ]);
    }
}

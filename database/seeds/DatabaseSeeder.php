<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // $this->call(UsersTableSeeder::class);

        /* <<<<<< dataseeding for language table >>>>>> */

        DB::table('mxp_languages')->insert([
            'lan_name' => 'English',
            'lan_code' => 'en',
        ]);

        DB::table('mxp_languages')->insert([
            'lan_name' => 'Bangla',
            'lan_code' => 'bn',
        ]);

    }
}

<?php

#       #       #       #
#
# ck_connect.inc
#
# Connect to the database.
# Customize this file to your environment!
#
# Copyright (C) 2003 John Gorman <jgorman@webbysoft.com>
# http://www.webbysoft.com/babelkit
#

function ck_connect() {

    # Customize this connection for your database:

    $lib_type = 'pear';     # pear | phplib

    if ($lib_type == 'pear') {

        require_once('DB.php');

        $dbh = DB::connect("mysql://webbysoft:124c41@localhost/webbysoft");

        if (DB::iserror($dbh)) die($dbh->getMessage());

    }
    elseif ($lib_type == 'phplib') {

        require_once('/usr/lib/phplib/db_mysql.inc');
        $dbh            = new DB_Sql;

        $dbh->Host      = 'localhost';
        $dbh->Database  = 'webbysoft';
        $dbh->User      = 'webbysoft';
        $dbh->Password  = '124c41';

    }

    return $dbh;
}

?>

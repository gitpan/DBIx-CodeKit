#!/usr/bin/php4 -q
<?php

# You must configure ck_connect.pl to connect with
# your database.
#
# You must also set up the ck_code table schema.

print "1..21\n";

function ok($got, $expect = 'NO SECOND ARG') {
    global $counter;
    $counter++;
    if ($expect === 'NO SECOND ARG') {
        if ($expect) {
            print "ok $counter\n";
        } else {
            print "not ok $counter\n";
        }
    } else {
        if ( $got == $expect ) {
            print "ok $counter\n";
        } else {
            print "not ok $counter\n";
            print "# Test $counter got: '$got'\n";
            print "#   Expected: '$expect'\n";
        }
    }
}

require_once('../ck_connect.inc');
require_once("../CodeKit.php");
ok(1);

$dbh = ck_connect();
ok(1);

$ckh = new CodeKit($dbh);
ok(1);

# Clean up old data.
$ckh->remove('regression',  1);
$ckh->remove('regression', '2');
$ckh->put('regression', 3, NULL);
ok(1);

# Test basic puts.
$ckh->put('regression',  1,  'Monday');
$ckh->put('regression', '2', 'Tuesday', NULL);
ok(1);

# And gets.

list( $desc, $order, $flag ) = $ckh->get('regression', '1');
ok( "$desc,$order,$flag", 'Monday,1,' );

list( $desc, $order, $flag ) = $ckh->get('regression',  2 );
ok( "$desc,$order,$flag", 'Tuesday,2,' );

# Simple select.
$expect = '<select name="regression">
<option value="" selected>Coffee Date?
<option value="1">Monday
<option value="2">Tuesday
</select>
';
ok( $ckh->select('regression', array(
                 'select_prompt' => 'Coffee Date?'
                 )), $expect );

# Slave & desc methods.
$ckh->put('regression', '3', 'wednes day');

list( $desc, $order, $flag ) = $ckh->get('regression', 3);
ok( "$desc,$order,$flag", 'wednes day,3,' );

ok( $ckh->desc('regression', 3),           'wednes day' );
ok( $ckh->ucfirst('regression', 3),        'Wednes day' );
ok( $ckh->ucwords('regression', 3),        'Wednes Day' );
ok( $ckh->data('regression', 3),           'wednes day' );
ok( $ckh->data('regression', 4),           '' );
$ckh->put('regression', '3', 'Wednesday', 3);

list( $desc, $order, $flag ) = $ckh->get('regression', 3);
ok( "$desc,$order,$flag", 'Wednesday,3,' );


# Select options.
$expect = '<select name="regression_test" onchange="submit()">
<option value="">(None)
<option value="1">Monday
<option value="2" selected>Tuesday
</select>
';
ok( $ckh->select('regression', array(
                'var_name'     => 'regression_test',
                'value'        => '2',
                'subset'       => array( 1, '2' ),
                'options'  => 'onchange="submit()"',
                'blank_prompt' => '(None)'
                )), $expect );

# Radiobox options.
$expect = '<input type="radio" name="rt" onchange="submit()" value="">(None)<br>
<input type="radio" name="rt" onchange="submit()" value="1">Monday<br>
<input type="radio" name="rt" onchange="submit()" value="2" checked>Tuesday';
ok( $ckh->radio('regression', array(
                'var_name'     => 'rt',
                'default'      => '2',
                'subset'       => array( 1, '2' ),
                'options'  => 'onchange="submit()"',
                'blank_prompt' => '(None)'
                )), $expect);

# Select multiple options.
$expect= '<select multiple name="reg_test[]" onchange="submit()" size="10">
<option value="1">Monday
<option value="2" selected>Tuesday
<option value="3" selected>Wednesday
</select>
';
ok( $ckh->multiple('regression', array(
                'var_name' => 'reg_test',
                'value'    => array( '2', 3 ),
                'subset'   => array( 1, '2', 3 ),
                'options'  => 'onchange="submit()"',
                'size'     => 10
                )), $expect);

# Checkbox options.
$expect = '<input type="checkbox" name="checkbox_test[]" onchange="submit()" value="1" checked>Monday<br>
<input type="checkbox" name="checkbox_test[]" onchange="submit()" value="2">Tuesday<br>
<input type="checkbox" name="checkbox_test[]" onchange="submit()" value="3" checked>Wednesday';
ok( $ckh->checkbox('regression', array(
                'var_name' => 'checkbox_test',
                'value'    => array( '1', 3 ),
                'subset'   => array( 1, '2', 3 ),
                'options'  => 'onchange="submit()"'
                )), $expect);

# Clean up old data.
$ckh->remove('regression',  1);
$ckh->remove('regression', '2');
$ckh->put('regression', 3, '');
ok(1);

$rows = $ckh->code_set('regression');
ok(count($rows), 0);

?>

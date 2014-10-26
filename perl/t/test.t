#!/usr/bin/env perl

# You must configure ck_connect.pl to connect with
# your database.
#
# You must also set up the ck_code table schema.

use Test;
BEGIN { plan tests => 21 };

use strict;
use warnings;
use lib '..';
use DBI;
use DBIx::CodeKit;
require("ck_connect.pl");
ok(1);

my $dbh = ck_connect();
ok(1);

my $ckh = DBIx::CodeKit->new($dbh);
ok(1);

# Clean up old data.
$ckh->remove('regression',  1);
$ckh->remove('regression', '2');
$ckh->put('regression', 3, undef);
ok(1);

# Test basic puts.
$ckh->put('regression',  1,  'Monday');
$ckh->put('regression', '2', 'Tuesday', '');
ok(1);

# And gets.

ok( join(',', $ckh->get('regression', '1')), 'Monday,1,' );
ok( join(',', $ckh->get('regression',  2 )), 'Tuesday,2,' );

# Simple select.
my $expect;
$expect = '<select name="regression">
<option value="" selected>Coffee Date?
<option value="1">Monday
<option value="2">Tuesday
</select>
';
ok( $ckh->select('regression',
                 select_prompt => 'Coffee Date?'
                 ), $expect );

# Slave & desc methods.
$ckh->put('regression', '3', 'wednes day');
ok( join(',', $ckh->get('regression', 3)), 'wednes day,3,' );
ok( $ckh->desc('regression', 3),           'wednes day' );
ok( $ckh->ucfirst('regression', 3),        'Wednes day' );
ok( $ckh->ucwords('regression', 3),        'Wednes Day' );
ok( $ckh->data('regression', 3),           'wednes day' );
ok( $ckh->data('regression', 4),           '' );
$ckh->put('regression', '3', 'Wednesday', 3);
ok( join(',', $ckh->get('regression', 3)), 'Wednesday,3,' );


# Select options.
$expect = '<select name="regression_test">
<option value="">(None)
<option value="1">Monday
<option value="2" selected>Tuesday
</select>
';
ok( $ckh->select('regression',
                var_name     => 'regression_test',
                subset       => [ 1, '2' ],
                value        => '2',
                blank_prompt => '(None)'
                ), $expect );

# Radiobox options.
$expect = '<input type="radio" name="rt" value="">(None)<br>
<input type="radio" name="rt" value="1">Monday<br>
<input type="radio" name="rt" value="2" checked>Tuesday';
ok( $ckh->radio('regression',
                var_name     => 'rt',
                subset       => [ 1, '2' ],
                default      => '2',
                blank_prompt => '(None)'
                ), $expect);

# Select multiple options.
$expect= '<select multiple name="reg_test[]" size="10">
<option value="1">Monday
<option value="2" selected>Tuesday
<option value="3" selected>Wednesday
</select>
';
ok( $ckh->multiple('regression',
                var_name => 'reg_test',
                subset   => [ 1, '2', 3 ],
                value    => [ '2', 3 ],
                size     => 10
                ), $expect);

# Checkbox options.
$expect = '<input type="checkbox" name="checkbox_test[]" value="1" checked>Monday<br>
<input type="checkbox" name="checkbox_test[]" value="2">Tuesday<br>
<input type="checkbox" name="checkbox_test[]" value="3" checked>Wednesday';
ok( $ckh->checkbox('regression',
                var_name => 'checkbox_test',
                subset   => [ 1, '2', 3 ],
                value    => [ '1', 3 ],
                ), $expect);

# Clean up old data.
$ckh->remove('regression',  1);
$ckh->remove('regression', '2');
$ckh->put('regression', 3, '');
ok(1);

my $rows = $ckh->code_set('regression');
ok(@$rows, 0);


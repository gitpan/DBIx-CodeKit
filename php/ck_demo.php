<?php

#       #       #       #
#
# ck_demo.php
#
# CodeKit Universal Code HTML select function PHP demo page.
#
# Copyright (C) 2003 John Gorman <jgorman@webbysoft.com>
# http://www.webbysoft.com/codekit
#

ck_demo();

function ck_demo() {

    require_once('ck_connect.inc');
    $dbh = ck_connect();

    require_once('CodeKit.php');
    $codekit = new CodeKit($dbh);

    $title = "CodeKit Code Select PHP Demo";
    print "
    <html>
    <head>
    <title>$title</title>
    </head>

    <body text=\"#000044\" bgcolor=\"#f0ffff\"
    link=\"#0000cc\" vlink=\"#0066ff\" alink=\"#ffcc00\">

    <center>
    <table border=\"1\" width=\"600\" cellpadding=\"20\">
    <tr>
    <td>

    <h2 style=\"color:#873852\">$title</h2>

    <a href=\"http://www.webbysoft.com/codekit\">CodeKit</a> -
    Interface to a universal code table.

    <p>
    Code sets are often used to present user data entry
    choices rather than hardcode specific values in application
    source code.  Web pages and other documents often need
    to display codefied database values as human readable
    descriptions.

    <p>
    CodeKit makes this a snap to program.  You can see
    the PHP method calls to CodeKit that produce these
    HTML select elements from database code sets.

    <p>
    This page shows off the CodeKit code select functions.
    Select various combinations of countries and months then
    click [Test CodeKit] at the bottom.

    <p>
    Have fun!

    </td></tr><tr><td>
    <form action=\"" . $_SERVER['PHP_SELF'] . "\" method=\"post\">
    ";

    #
    # Currency Dropdown.
    #

    $mycurrency = $_POST['currency'];
    print "
    <b>Select a currency.</b>
    <p>Pass in a specific code value.
    <pre>
print \$codekit->select('currency', array(
                         value =&gt; \$mycurrency
));
    </pre>
    \$mycurrency is '$mycurrency':
    <p>
    ";
    print $codekit->select('currency', array(
                            value => $mycurrency
    ));

    #
    # Day Radiobox.
    #

    $day = $_POST['day'];
    print "</td></tr><tr><td>
    <b>Radiobox for days of the week.</b>
    <p>Constrain choices to the weekdays (1-5).
    <br>A blank separator displays them all on one line.
    <pre>
print \$codekit->radio('day', array(
                        subset =&gt; array(1, 2, 3, 4, 5),
                        sep    =&gt; ''
));
    </pre>
    'day' is '$day'.
    <p>
    ";
    print $codekit->radio('day', array(
                           subset => array(1, 2, 3, 4, 5),
                           sep    => ''
    ));

    #
    # Country Select Multiple.
    #

    $country = $_POST['country'];
    if (!is_array($country)) $country = array();
    $countrystr = join(',', $country);
    print "</td></tr><tr><td>
    <b>Select multiple countries</b>.
    <p>Specify a window scrolling size of 10.
    <p>Experiment with Ctrl-click and Shift-click.
    <br>to select multiple countries.
    <pre>
print \$codekit->multiple('country', array(
                           size =&gt; 10
));
    </pre>
    'country' contains [$countrystr]:
    <p>
    ";
    print $codekit->multiple('country', array(
                              size => 10
    ));

    #
    # Month Checkbox.
    #

    $month = $_POST['month'];
    if (!is_array($month)) $month = array();
    $monthstr = join(',', $month);
    print "</td></tr><tr><td>
    <b>Checkbox for multiple month selections.</b>
    <p>Simple no frills method call.
    <pre>
print \$codekit->checkbox('month');
    </pre>
    'month' contains [$monthstr]:
    <p>
    ";
    print $codekit->checkbox('month');

    print "
    </td></tr><tr><td>
    <input type=submit value=\"Test CodeKit\">
    </form>
    </td>
    </tr>
    </table>
    </center>
    </body>
    </html>
    ";
}

?>

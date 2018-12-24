<html>
    <head>
        <link rel="stylesheet" type="text/css" href="../styles.css">
    </head>
    <body>
        <form id="inputform" method="get">
            <input type="form" name="text" size="40" value="[% domain_string %]">
            <input type="submit" value="Отправить">
            <input type="hidden" value="[% backend %]">
        </form>
        <div id="output">
            [% FOREACH n IN whois %]
                [% IF n.text %]
                    <li> [% n.id %] : [% n.text %] </li>
                [% END %]
            [% END %]
        </div>
    </body>
</html>


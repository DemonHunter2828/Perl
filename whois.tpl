<html>
    <head>
        <link rel="stylesheet" type="text/css" href="../styles.css">
    </head>
    <body>
        <form id="inputform" method="get">
            <input type="form" name="text" size="40">
            <input type="submit" value="Отправить">
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


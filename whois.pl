#!/usr/bin/perl -w
use strict;
use URI::Escape;
use warnings;
use CGI::Cookie;
use lib "../../";
use VR::Lib::RPC;
use LWP::Protocol::https;
use Template;

if($ENV{HTTP_COOKIE})
{
    # nothing. we already have cookie
}
else
{
    my $idstr = uri_unescape($ENV{REMOTE_ADDR});
    my $random = int(rand(1000000000));
    my $cookieStr = "$random.$idstr";
    my $c = new CGI::Cookie(-name => 'usrId',
    -value => $cookieStr);
    
    print "Set-Cookie: $c\n";
}
print "Content-Type: text/html; charset=utf-8\n\n";
my $usrId = uri_unescape(substr $ENV{HTTP_COOKIE}, 6);
my $domain_string = uri_unescape( substr $ENV{QUERY_STRING}, 5);
my $server = "https://vrdemo.virtreg.ru/vr-api";
my $login = "demo";
my $password = "demo";
my $rpc = VR::Lib::RPC->new($server, $login, $password);
my %whois_hash = %{$rpc->call("whois",{auth=>{login=>$login, password=>$password}, name=>$domain_string, userCookie=>$usrId})};
my $whois = $whois_hash{"result"}{"whois"};
my $vars = {
    whois => $whois,
};

my $tt = Template->new({
    RELATIVE => 1,
}) || die "$Template::ERROR\n";

$tt->process('whois.tpl', $vars) || die $tt->error(), "\n";

#print "cookie:$ENV{HTTP_COOKIE}<br>";

#foreach my $hkey (sort {$a cmp $b} keys %ENV)
#{
#    print "$hkey:$ENV{$hkey}<br>";
#}


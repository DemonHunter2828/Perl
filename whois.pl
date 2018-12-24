#!/usr/bin/perl -w
use strict;
use URI::Escape;
use warnings;
use CGI;
use CGI::Cookie;
use lib "../../";
use VR::Lib::RPC;
use LWP::Protocol::https;
use Template;
use JSON;

if($ENV{HTTP_COOKIE})
{
    # nothing. we already have cookie
}
else
{
    my $ipstr = uri_unescape($ENV{REMOTE_ADDR});
    my $random = int(rand(1000000000));
    my $cookieStr = "$random.$ipstr";
    my $c = new CGI::Cookie(-name => 'usrId',
    -value => $cookieStr);
    
    print "Set-Cookie: $c\n";
}
print "Content-Type: text/html; charset=utf-8\n\n";
my $cgi = new CGI;
open my $file, '<', 'whois.cfg' or die "No opening";
my $config = "";
while(<$file>)
{
    chomp;
    $config = $config . $_;
}
close $file;
my $decoded_config = decode_json($config);
my $backend = $cgi->param('back');
if(!$backend)
{
    $backend = "demo";
}
my $server = $decoded_config->{$backend}->{url};
my $login = $decoded_config->{$backend}->{login};
my $password = $decoded_config->{$backend}->{password};
my $usrId = uri_unescape(substr $ENV{HTTP_COOKIE}, 6);
my $domain_string = $cgi->param('text');
my $rpc = VR::Lib::RPC->new($server, $login, $password);
my %whois_hash = %{$rpc->call("whois",{auth=>{login=>$login, password=>$password}, name=>$domain_string, userCookie=>$usrId})};
my $whois = $whois_hash{"result"}{"whois"};
my $vars = {
    whois => $whois,
    domain_string => $domain_string,
    backend => $backend,
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


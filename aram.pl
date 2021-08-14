use strict;
use warnings;
use JSON;
use Data::Dumper;
use Switch;
use MIME::Base64;
use LWP::Simple;
use LWP::UserAgent;

my $json = "";
open(FH, '<', "version.txt") or die $!;
while(<FH>){ print "$_\n";}
close(FH);
open(FH, '<', "habyss.json") or die $!;
while(<FH>){ $json = $json.$_;}
close(FH);

my $dcdjson = decode_json($json);
my $xamp = 17;
#lwp
my ($auth,$port) = @{auth()};
my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
my $header = ['Accept' => 'application/json','Content-Type' => 'application/json','Authorization' => "Basic $auth"];
my $uri = "https://127.0.0.1";

#start
my $summoner = decode_json(clientget('lol-summoner/v1/current-summoner','summoner: '));
my $acid = $summoner->{'accountId'};
my $lobby = decode_json(clientget('lol-lobby-team-builder/champ-select/v1/session','session: '));
foreach my $cat ( @{ $lobby->{'myTeam'} } ){
    if ($cat->{'summonerId'} == $acid){
        $xamp = $cat->{'championId'};
        last;
    }
}  
my $runepage = clientget('lol-perks/v1/currentpage','cur page: ');
clientdel('lol-perks/v1/pages/','del page: ');
while( my( $idx, $elem ) = each( @{$dcdjson} ) ){
    if( $elem->{'id'} eq $xamp ){
        $runepage = encode_json($elem);
        last;
    }
} 
clientset('lol-perks/v1/pages','add page: ');
sleep(3);
#end

sub true () { JSON::true }
sub false () { JSON::false }
sub clientdel{
    my $robdec = decode_json($runepage);
    if( $robdec->{'isDeletable'} eq true && $robdec->{'isEditable'} eq true ){
        my $runeid =  $robdec->{'id'};               
        my $req = HTTP::Request->new('DELETE', "$uri:$port/$_[0]", $header, $runeid);
        my $response = $ua->request($req);
        print $_[1];
        if ($response->is_success) { print $response->code, "\n";
        } else { print STDERR $response->status_line, "\n"; }       
    }
}
sub clientget{   
    my $req = HTTP::Request->new('GET', "$uri:$port/$_[0]", $header ); 
    my $response = $ua->request($req);
    my $json = $response->content; 
    print $_[1];
    if ($response->is_success) { print $response->code, "\n";
    } else {
        print STDERR $response->status_line, "\n";
        print $json;
    }      
    return $json;
}
sub clientset{    
    my $req = HTTP::Request->new('POST', "$uri:$port/$_[0]", $header, $runepage);
    my $response = $ua->request($req);
    print $_[1];
    if ($response->is_success) { print $response->code, "\n";
    } else { print STDERR $response->status_line, "\n"; }
}
sub auth{
    my $proc = `WMIC path win32_process get Caption,Commandline | find "--remoting-auth-token="`;
    if ($proc =~ /--remoting-auth-token=(\S+)".*?--app-port=(\d+)/) {
        return [ encode_base64(qq(\x72\x69\x6f\x74:$1)), $2 ]
    }
} 
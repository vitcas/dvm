use strict;
use warnings;
use JSON;
use Data::Dumper;
use Switch;
use MIME::Base64;
use LWP::Simple;
use LWP::UserAgent;
use Clipboard;

my $json2 = "";
open(FH, '<', "runemap.json") or die $!;
while(<FH>){ $json2 = $json2.$_;}
close(FH);

my $text2 = decode_json($json2);
my @hexa = (0,0,0,0,0,0,0,0,0,0,0);
my @mods =  (0, 5008, 5005, 5007, 5002, 5003, 5001);
my @styles = (0, 8000, 8100, 8200, 8400, 8300);
my @sums = (0, 0, 13, 27, 39, 51);
my @mock = (8400,8439,8401,8473,8242,8345,8347,5007,5002,5003,8300);
my $xamp;
my $xname;
my $result = 'invalid';
my $runepage;

remock();
print "\nPress key to exit";
<STDIN>;

sub remock{
    my $id = 711;
    my $rex = '216ab357215';
    $xname = 'vex';
    @hexa = split //, $rex;
    my $mod = $sums[$hexa[0]];
    my $mod2 = $sums[$hexa[5]];
    $mock[0] = $styles[$hexa[0]];
    $mock[1] = getriot($hexa[1],$mod);
    $mock[2] = getriot($hexa[2],$mod);
    $mock[3] = getriot(hex $hexa[3],$mod);
    $mock[4] = getriot(hex $hexa[4],$mod);
    $mock[5] = getriot(hex $hexa[6],$mod2);
    if ($mock[5] eq 'invalid'){ $mock[5] = getriot(hex $hexa[6],$mod2); } #force each loop to reset
    $mock[6] = getriot(hex $hexa[7],$mod2);
    $mock[7] = $mods[$hexa[8]];
    $mock[8] = $mods[$hexa[9]];
    $mock[9] = $mods[$hexa[10]];
    $mock[10] = $styles[$hexa[5]];
    $runepage = "{\"autoModifiedSelections\": [],\"current\": true,\"id\": $id,\"isActive\": false,\"isDeletable\": true,\"isEditable\": true,\"isValid\": true,\"lastModified\": 1628301854132,\"name\": \"abyss $xname\",\"order\": 1,\"primaryStyleId\": ".$mock[0].",\"selectedPerkIds\": [".$mock[1].",".$mock[2].",".$mock[3].",".$mock[4].",".$mock[5].",".$mock[6].",".$mock[7].",".$mock[8].",".$mock[9]."],\"subStyleId\": ".$mock[10]."},";    
    print $runepage;
    Clipboard->copy($runepage);
}
sub getriot{
    my $param = $_[0] + $_[1];  
    while( my ( $key, $obj ) = each( @{$text2} ) ){
        if( $key eq $param-1){
            $result =  $obj->{'riotid'};
        }
    }
    return $result;
} 
# generate a random number in perl with the rand function
use strict;
use warnings;

my @array;
my $count = 0;
my $file = 'waifu.txt';
my $random_number = int(rand(9999));
my $string;

open(FH, '<', $file) or die $!;
while(<FH>){
	$count++;
	chomp($_);
    push(@array, $_);    
}
close (FH);

my $r2 = int(rand($count));
#print "r2: ".$r2."\n";
print $array[$r2-1].$random_number;
print "\nPress key to exit";
<STDIN>;
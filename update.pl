use strict;
use warnings;
use LWP::Simple;

my $runes = get 'https://pastebin.com/raw/Mz7mBDt4'; #runes
my $version = get 'https://pastebin.com/raw/qJdwthAK'; #version

# Put the file name in a string variable
# so we can use it both to open the file
# and to refer to in an error message
# if needed.
my $file1 = "version.txt";
my $file2 = "runes.json";

# Use the open() function to create the file.
unless(open FILE, '>'.$file1) {
    # Die with error message 
    # if we can't open it.
    die "\nUnable to create $file1\n";
}
print FILE $version;
close FILE;

# Use the open() function to create the file.
unless(open FILE, '>'.$file2) {
    # Die with error message 
    # if we can't open it.
    die "\nUnable to create $file2\n";
}
print FILE $runes;
close FILE;
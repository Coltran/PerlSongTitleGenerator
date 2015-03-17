######################################### 	
#    CSCI 305 - Programming Lab #1		
#										
#  Coltran Hophan-Nichols			
#  coltran@me.com
#										
#########################################

# Author info
my $name = "Coltran";
my $partner = "No Partner";
print "CSCI 305 Lab 1 submitted by $name and $partner.\n\n";

# Checks for the argument, fail if none given
if($#ARGV != 0) {
    print STDERR "You must specify the file name as the argument.\n";
    exit 4;
}

# Opens the file and assign it to handle INFILE
open(INFILE, $ARGV[0]) or die "Cannot open $ARGV[0]: $!.\n";


# VARIABLE DEFINITIONS
my @title = (); #holds an array of all titles
my $count = 0; #incrementing variable and counts total songs
my $count2 = 0; #incrementing variable and counts songs not filtered
my $count3 = 0; #incrementing variable
my %bigram; #my bigram hash of hashes
my $temp = 0; #temporary variable used to hold a word count
my $thisHash; #points to the current word in title durring analysis
my $nextHash; #pints to the next word in title durring analysis
my %tempHash; #points to a subhash from bigram
my $value; #holds a single element from the hash of hashes

# This loops through each line of the file
while($line = <INFILE>) {
$count2++; #increment
	my $thisLine = $line;
	
	# select portion after the first three ">"s
	if($thisLine =~ m/>.*?>.*?>(.*)/) {
		my $title = $1;
		# remove everything after special characters
		if($title =~ m/(.*?)\(|\[|\{|\\|\/|_|\-|:|\"|`|\+|\=|\*|feat.|\$/) {
			$title = $1;
		}
		#remove punctuation
		$title =~ s/[\?|¿|!|¡|\.|;|&|\$|\@|%|#|\|]//g;
		#make lowecase
		$title = lc($title);
		#remove stop words
		$title =~ s/\b(a|an|and|by|for|from|in|of|on|or|out|the|to|with)\b//g;
		#remove titles with special characters
		if($title =~ m/\A(\w|\s|')*\Z/) {
			push(@title,$title); #push title onto array
			$count++;#increment
		}
	}
}
# build the hash of hashes
while($count3 < scalar(@title)) { #while in the array
	my $thisTitle = @title[$count3]; # select current element
	my @aTitle = (); #array to temporarily hold each word of title
	#add words to array
	#while ($thisTitle =~ m/([\w|'])*/g) {
	#	push(@aTitle,$1);
	#}
	@aTitle = split(/\s+/ , $thisTitle);
	my $count4 = 0; #incrementing variable
	while ($count4 < (scalar(@aTitle)-1)) { #while in array
		$thisHash = @aTitle[$count4]; #hash index for current word
		$nextHash = @aTitle[$count4+1]; #hash index for next word
		if ($bigram{$thisHash}{$nextHash} eq undef) { #if no value for current word pair
			$bigram{$thisHash}{$nextHash} = 1; #make current word pair 1
		}
		else {
			$temp = $bigram{$thisHash}{$nextHash}; #get current value for current word pair
			$temp++; #add one to current value for current word pair
			$bigram{$thisHash}{$nextHash} = $temp; #put back
		}
		#$temp = $bigram{$thisHash}{$nextHash}; #Used for debugging can be printed
		$count4++; #increment
	}
	$count3++; #increment
}


# Close the file handle
close INFILE; 

#  finished processing the song title file and have populated data structure of bigram counts.
print "\nMatched $count of $count2 titles.\n";
print "File parsed. Bigram model built.\n\n";


# User control loop
my $input = "hi"; #something not "q"
while ($input ne 'q'){
	print "Enter a word [Enter 'q' to quit]: ";
	$input = <STDIN>;
	chomp($input);
	print "\n";
	if($input ne 'q') #if not quitting
	{
		print $input; #print first word of title
		print " ";
		$count3 = 0; #reset incrementing variable
		while ($count3 < 20 && $bigram{$input} != undef){ #until we reach 20 or don't have a match
			%tempHash = %{ $bigram{$input} }; #set to appropriate subhash
			$value = (reverse sort { $tempHash{$a} <=> $tempHash{$b} } keys %tempHash)[0]; #sort and return greatest, will be random between equal values based on memory state
			print $value;#print it
			#print "\nsize of hash:  " . keys( %tempHash ) . ".\n"; #for lab question 3
			#print $bigram{$input}{$value}; #for lab question 5
			print " ";
			$count3++;#increment
			$input = $value; #setup to find next word
		}
		print "\n\n";
	}
}


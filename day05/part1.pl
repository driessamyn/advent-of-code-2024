use Data::Dumper;
use File::Slurp;
use File::Basename;
my $dirname = dirname(__FILE__);

require "$dirname/test-data.pl";

my @successes = ();
my @fails = ();

sub calculateMiddle {
    my $order = shift;
    my $pages = shift;
    my %orderMap = ();
    for my $o (split(/\n/, $order)) {
        my ($k, $v) = split(/\|/, $o);
        if ($orderMap{$k}) {
            $orderMap{$k} .= ",$v";
        }
        else {
            $orderMap{$k} = $v;
        }
    }
    # print Dumper(\%orderMap);

    my $sumOfmiddle = 0;
    for my $l (split(/\n/, $pages)) {
        my @pageList = (split(/,/, $l));
        # keep track of all the "comes before" requirements of pages that came before in the list
        my $hasComeBefore = shift(@pageList);
        my $isFailed = 0;
        foreach my $p (@pageList) {
            if (isAnyIn($hasComeBefore, $orderMap{$p})) {
                print "[$l FAILED] Elements of $hasComeBefore should not be in $orderMap{$p}\n";
                $isFailed = 1;
                push(@fails, $l);
                last;
            }
            $hasComeBefore .= ",$p";
        }
        if ($isFailed == 0) {
            # Damn that shift/unshift wasted me an hour :(
            unshift(@pageList,$hasComeBefore);
            my $middle = findMiddle(@pageList);
            $sumOfmiddle += $middle;
            push(@successes, $l);
            print "[$l SUCCESS]\n";
        }
    }

    # print "SUCCESSES:\n";
    # for my $s (@successes){
    #     print "$s\n";
    # }
    # print "\n";
    # print "FAILS:\n";
    # for my $f (@fails){
    #     print "$f\n";
    # }
    # print "\n";
    return $sumOfmiddle;
}

sub isAnyIn {
    my $one = shift;
    my $two = shift;

    # there must be a more efficient way of doing this
    my @all = split /,/, $one;
    for my $i (split(/,/, $two)) {
        if(grep { $_ == $i } @all) {
            # print "$i is in $one\n";
            return 1;
        }
    }
    return 0;
}

sub findMiddle {
    my @all = @_;
    my $middleIndex = int((scalar @all)/2);
    print "@all - $middleIndex\n";
    return @all[$middleIndex];
}

# isAnyIn("1,2,3", "2,33,4");
# my @values = (1,234,3);
# print findMiddle( @values );
# my %m = createOrderMap($test_data_order);
# print Dumper(\%m);
# my $orderedList = orderCorrectly("97,13,75,29,47", \%m);
# print "NEW ORDER: $orderedList\n";

my $test_result = calculateMiddle($test_data_order, $test_data_pages);
print "SUM OF MIDDLE: $test_result\n";

my $data_order = read_file("$dirname/data-order.txt");
my $data_pages = read_file("$dirname/data-pages.txt");

my $result = calculateMiddle($data_order, $data_pages);
print "SUM OF MIDDLE: $result\n";

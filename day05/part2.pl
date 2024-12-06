use Data::Dumper;
use File::Slurp;
use File::Basename;
my $dirname = dirname(__FILE__);

require "$dirname/test-data.pl";

my @successes = ();
my @fails = ();

sub calculateMiddle2 {
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
    print Dumper(\%orderMap);

    my $sumOfmiddle = 0;
    my $sumOfmiddleFailed = 0;
    for my $l (split(/\n/, $pages)) {
        my $orderedLine = orderCorrectly($l, \%orderMap);
        my $middle = findMiddle((split(/,/, $orderedLine)));
        print "[",($l == $orderedLine),"] $l | $orderedLine (middle: $middle)\n";
        if($l eq $orderedLine) {
            $sumOfmiddle += $middle;
            push(@successes, $l);
            # print "[$l SUCCESS]\n";
        } else {
            $sumOfmiddleFailed += $middle;
            push(@fails, $l);
            # print "[$l FAILED, became $orderedLine]\n";
        }
    }

    print "SUCCESSES:\n";
    for my $s (@successes){
        print "$s\n";
    }
    print "\n";
    print "FAILS:\n";
    for my $f (@fails){
        print "$f\n";
    }
    print "\n";
    return ($sumOfmiddle, $sumOfmiddleFailed);
}

sub findMiddle {
    my @all = @_;
    my $middleIndex = int((scalar @all)/2);
    print "@all - $middleIndex\n";
    return @all[$middleIndex];
}

sub createOrderMap {
    my $str = shift;
    my %orderMap = ();
    for my $o (split(/\n/, $str)) {
        my ($k, $v) = split(/\|/, $o);
        if ($orderMap{$k}) {
            $orderMap{$k} .= ",$v";
        }
        else {
            $orderMap{$k} = $v;
        }
    }
    return %orderMap;
 }

sub orderCorrectly {
    my $line = shift;
    my %order = %{shift()};

    my @pageList = (split(/,/, $line));
    my %hasComeBefore = ($pageList[0] => 0);
    for(my $i=1;$i<scalar @pageList;$i++) {
        my @orderOfPages = (split(/,/, $order{$pageList[$i]}));
        for(my $j=0; $j<scalar @orderOfPages; $j++){
            if( exists($hasComeBefore{$orderOfPages[$j]} ) ) {
                # swapping them around
                my $current = $pageList[$i];
                my $swapWith = $orderOfPages[$j];
                my $swapWithIndex = $hasComeBefore{$orderOfPages[$j]};
                # print "$pageList[$i] must be before $orderOfPages[$j], swapping $i and $swapWithIndex\n";
                $pageList[$i] = $swapWith;
                $pageList[$swapWithIndex] = $current;
                # print "New list: @pageList\n";
                return orderCorrectly(join(',', @pageList), \%order);
            }
        }
        $hasComeBefore{$pageList[$i]} = $i;
        # print Dumper(\%hasComeBefore);
    }
    return $line;
}

my @results = calculateMiddle2($test_data_order, $test_data_pages);
print "SUM OF MIDDLES: @results\n";

my $data_order = read_file("$dirname/data-order.txt");
my $data_pages = regit ad_file("$dirname/data-pages.txt");

my @results = calculateMiddle2($data_order, $data_pages);
print "SUM OF MIDDLE: @results\n";
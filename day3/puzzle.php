<?php
$test_data = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))";
$read_data = "";
?>

<?php
include 'data.php';

function multiply($exp) {
    $sum = 0;
    $mult = array();
    foreach (str_split($exp) as $char) {
        $mult = parseChar($char, $mult);

        if(count($mult) == 5) {
            $result = (int) $mult[1] * (int) $mult[3];
            echo "$mult[1] * $mult[3] = $result\n";
            $sum += $result;

            $mult = array();
        }
    }
    return $sum;
}

function parseChar(string $char, array $mult): array {
    $m_count = count($mult);
    // NOTE: not clear from the reqs if floating point numbers are allowed
    //  assuming not
    if(ctype_digit($char) 
        && $m_count >= 1 && $m_count <= 4 && $mult[0] == "mul(") {
        if($m_count == 1) {
            $mult[1] = $char;
        } else if ($m_count == 2) {
            $mult[1] = "$mult[1]$char";
        } else if ($m_count == 3) {
            $mult[3] = $char;
        } else if ($m_count == 4) {
            $mult[3] = "$mult[3]$char";
        }
        return $mult;
    }
    if('m' == $char) { $mult[] = "m"; return $mult; }
    if('u' == $char && $m_count == 1 && $mult[0] == "m") {
        $mult[0] = "mu";
        return $mult;
    }
    if('l' == $char && $m_count == 1 && $mult[0] == "mu") {
        $mult[0] = "mul";
        return $mult;
    }
    if('(' == $char && $m_count == 1 && $mult[0] == "mul") {
        $mult[0] = "mul(";
        return $mult;
    }
    if(',' == $char && $m_count == 2) {
        $mult[2] = ",";
        return $mult;
    }
    if(')' == $char && $m_count == 4) {
        $mult[4] = ")";
        return $mult;
    }
    return array();
}


function multiply2($exp) {
    $sections = explode("don't()", $exp);
    $sum = multiply($sections[0]);
    for($i=1;$i < count($sections); $i++) {
        $do_pos = strpos($sections[$i], "do()");
        $do_section = substr($sections[$i],$do_pos + 4);
        echo "do-section: $do_section\n";
        $sum += multiply($do_section);
    }
    return $sum;
}
echo multiply($data);
echo multiply2($data);
?>

<?php
function testParse($exp) {
    $m = array();
    foreach (str_split($exp) as $char) {
        $m = parseChar($char, $m);
        $a = implode("|", $m);
        echo "## $char - $a \n";
    }
}

// $tst2 = "mult&mul(10,02)xymul(10,03)m(1,03)";
// $tst = "mul(20,3)";
// testParse($test_data);
// echo multiply($test_data)
?>
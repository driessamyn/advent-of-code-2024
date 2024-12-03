<?php
include 'data.php';

function multiply($exp) {
    $sum = 0;
    $mult = array();
    foreach (str_split($exp) as $char) {
        $mult = parseChar($char, $mult);

        if(count($mult) == 5) {
            $result = (int) $mult[1] * (int) $mult[3];
            // echo "$mult[1] * $mult[3] = $result\n";
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
            if(strlen($mult[1]) == 4) {
                // abort
                return array();
            }
        } else if ($m_count == 3) {
            $mult[3] = $char;
        } else if ($m_count == 4) {
            $mult[3] = "$mult[3]$char";
            if(strlen($mult[1]) == 4) {
                // abort
                return array();
            }
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
        if($do_pos) {
            $do_section = substr($sections[$i],$do_pos + 4);
            // echo "do-section (pos $do_pos): $do_section\n";
            $sum += multiply($do_section);
        }
    }
    return $sum;
}
echo "\n'\n**************************";
echo "\npart 1: ".multiply($data);
echo "\n'\n**************************";
echo "\npart 2: ".multiply2($data);
echo "\n**************************";
?>
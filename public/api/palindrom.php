<?php
//header("Access-Control-Allow-Origin: *");

// Алгоритм Манакера
// https://neerc.ifmo.ru/wiki/index.php?title=%D0%90%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC_%D0%9C%D0%B0%D0%BD%D0%B0%D0%BA%D0%B5%D1%80%D0%B0
function findPalindroms(&$str) {
    $length = strlen($str);
    $result = [];
    {
        $d = [];
        $l = 0; $r = -1;
        for ($i = 0; $i < $length; ++$i) {
            $k = ($i > $r) ? 0 : min($r - $i, $d[$l + $r - $i]);

            for (; (($i + $k + 1 < $length) && ($i - $k - 1 >= 0) && $str[$i + $k + 1] == $str[$i - $k - 1]); ++$k);

            $d[$i] = $k;

            if ($i + $k > $r) {
                $l = $i - $k;
                $r = $i + $k;
            }
            if ($k) {
                $result[] = substr($str, $i - $k, 2 * $k + 1);
            }
        }
    }
    {
        $d = [];
        $l = 0; $r = -1;
        for ($i = 0; $i < $length; ++$i) {
            $k = ($i > $r) ? 0 : min($r - $i + 1, $d[$l + $r - $i + 1]);

            for (; ($i + $k < $length) && ($i - $k - 1 >= 0) && ($str[$i + $k] == $str[$i - $k - 1]); ++$k);

            $d[$i] = $k;

            if ($i + $k - 1 > $r) {
                $l = $i - $k;
                $r = $i + $k - 1;
            }
            if ($k) {
                $result[] = substr($str, $i - $k, 2 * $k);
            }
        }
    }
    return $result;
}

echo json_encode(findPalindroms($_GET['str']));


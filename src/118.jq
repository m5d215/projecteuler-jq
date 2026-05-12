def mulmod($a; $b; $n):
    ($a / 131072 | floor) as $ah
    | ($a % 131072) as $al
    | (($ah * $b) % $n * 131072 + $al * $b) % $n
;

def powmod($base; $e; $n):
    if $n <= 1 then 0
    else
        {b: ($base % $n), e: $e, r: 1}
        | until(.e == 0;
            (if .e % 2 == 1 then mulmod(.r; .b; $n) else .r end) as $nr
            | {b: mulmod(.b; .b; $n), e: (.e / 2 | floor), r: $nr}
          )
        | .r
    end
;

def is_prime($n):
    if $n < 2 then false
    elif $n == 2 or $n == 3 or $n == 5 or $n == 7 or $n == 11 then true
    elif $n % 2 == 0 then false
    else
        ({s: 0, d: ($n - 1)}
         | until(.d % 2 == 1; {s: (.s + 1), d: (.d / 2 | floor)})) as $sd
        | $sd.s as $s
        | $sd.d as $d
        | reduce [2, 3, 5, 7, 11][] as $a (true;
            . and (
              if $a >= $n then true
              else
                powmod($a; $d; $n) as $x
                | if $x == 1 or $x == $n - 1 then true
                  else
                    ({x: $x, found: false}
                     | reduce range(0; $s - 1) as $_ (.;
                         if .found then .
                         else
                             mulmod(.x; .x; $n) as $nx
                             | if $nx == $n - 1 then {x: $nx, found: true}
                               else {x: $nx, found: false}
                               end
                         end
                       ))
                    | .found
                  end
              end))
    end
;

def permutations:
    if length <= 1 then [.]
    else
        . as $arr
        | [range(0; length)]
        | map(. as $i
              | ($arr[:$i] + $arr[$i + 1:] | permutations)
                | map([$arr[$i]] + .))
        | add
    end
;

def digits_to_num:
    reduce .[] as $d (0; . * 10 + $d)
;

def digits_of_mask($mask):
    [range(0; 9) | select(($mask / pow(2; .) | floor) % 2 == 1) | . + 1]
;

def all_submasks($mask):
    if $mask == 0 then [0]
    else
        [range(0; 9) | select(($mask / pow(2; .) | floor) % 2 == 1)][0] as $b
        | pow(2; $b) as $bm
        | (all_submasks($mask - $bm)) as $rest_subs
        | $rest_subs + ($rest_subs | map(. + $bm))
    end
;

def compute_p($m):
    digits_of_mask($m) as $digs
    | ($digs | length) as $sz
    | if $sz == 0 then 0
      elif $sz == 1 then
          $digs[0] as $d
          | if [2, 3, 5, 7] | index($d) then 1 else 0 end
      elif (($digs | add) % 3 == 0) then 0
      else
          $digs
          | permutations
          | map(digits_to_num)
          | map(select(is_prime(.)))
          | length
      end
;

[range(0; 512) | compute_p(.)] as $p
| [range(0; 512) | if . == 0 then 1 else 0 end] as $f_init
| reduce range(1; 512) as $T ($f_init;
    . as $f
    | [range(0; 9) | select(($T / pow(2; .) | floor) % 2 == 1)][0] as $b
    | pow(2; $b) as $bm
    | ($T - $bm) as $rest
    | (reduce (all_submasks($rest))[] as $extra (0;
        ($bm + $extra) as $S
        | . + $p[$S] * $f[$T - $S]
      )) as $fT
    | $f | .[$T] = $fT
  )
| .[511]

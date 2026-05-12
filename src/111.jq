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

def gen($d; $M_left; $non_d_left; $pos; $current; $N):
    if $pos == $N then
        if $M_left == 0 and $non_d_left == 0 then $current else empty end
    else
        range(0; 10) as $dig
        | select($pos != 0 or $dig != 0)
        | if $dig == $d then
              if $M_left > 0 then
                  gen($d; $M_left - 1; $non_d_left; $pos + 1; $current * 10 + $dig; $N)
              else empty end
          else
              if $non_d_left > 0 then
                  gen($d; $M_left; $non_d_left - 1; $pos + 1; $current * 10 + $dig; $N)
              else empty end
          end
    end
;

def find_S($d):
    first(
        range(9; 0; -1) as $M
        | [gen($d; $M; 10 - $M; 0; 0; 10) | select(is_prime(.))] as $primes
        | select(($primes | length) > 0)
        | $primes | add
    )
;

[range(0; 10) | find_S(.)] | add

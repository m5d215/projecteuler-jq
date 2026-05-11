10000 as $LIMIT

| ([range(0; $LIMIT + 1) | true]
   | .[0] = false | .[1] = false
   | reduce range(2; ($LIMIT | sqrt | floor) + 1) as $p (.;
       if .[$p] then
           reduce range($p * $p; $LIMIT + 1; $p) as $m (.; .[$m] = false)
       else . end
     )
   | . as $sv
   | [range(2; $LIMIT + 1) | select($sv[.])]) as $primes

| ($primes - [2, 5]) as $cand

| def mulmod($a; $b; $n):
    ($a / 16384 | floor) as $ah
    | ($a % 16384) as $al
    | (($ah * $b) % $n * 16384 + $al * $b) % $n
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
    elif $n == 2 or $n == 3 then true
    elif $n % 2 == 0 then false
    else
        ({s: 0, d: ($n - 1)}
         | until(.d % 2 == 1; {s: (.s + 1), d: (.d / 2 | floor)})) as $sd
        | $sd.s as $s
        | $sd.d as $d
        | reduce [2, 7, 61][] as $a (true;
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

  def concat($a; $b):
    $a * pow(10; ($b | tostring | length)) + $b
;

  def compat($p; $q):
    is_prime(concat($p; $q)) and is_prime(concat($q; $p))
;

  def dfs($chosen; $sum; $startIdx; $best):
    if ($chosen | length) == 5 then
        if $best == null or $sum < $best then $sum else $best end
    else
        ($chosen | length) as $L
        | reduce range($startIdx; $cand | length) as $i ($best;
            . as $cur
            | $cand[$i] as $p
            | if $cur != null and ($sum + $p * (5 - $L)) >= $cur then $cur
              elif ($chosen | reduce .[] as $c (true; . and compat($c; $p)))
                then dfs($chosen + [$p]; $sum + $p; $i + 1; $cur)
              else $cur
              end
          )
    end
;

dfs([]; 0; 0; null)

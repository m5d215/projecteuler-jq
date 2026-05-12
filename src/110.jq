import "./lib" as L;

def target: 8000001;
def primes: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59];

def explore($k; $last; $prod; $log_n; $exps; $best):
    (if $prod >= target and $log_n < $best.log
     then {log: $log_n, exps: $exps}
     else $best
     end) as $cur
    | if $k >= (primes | length) or $log_n >= $cur.log then $cur
      else
          reduce range(1; $last + 1) as $a ($cur;
              . as $cur_best
              | ($prod * (2 * $a + 1)) as $new_prod
              | ($log_n + $a * (primes[$k] | log)) as $new_log
              | if $new_log >= $cur_best.log then $cur_best
                else explore($k + 1; $a; $new_prod; $new_log; $exps + [$a]; $cur_best)
                end
          )
      end
;

def factor_to_n($exps):
    reduce range(0; $exps | length) as $i ([1];
        . as $cur
        | reduce range(0; $exps[$i]) as $_ ($cur; L::mp_mul_int(primes[$i]))
    )
;

explore(0; 50; 1; 0; []; {log: 1e308, exps: []})
| .exps as $exps
| factor_to_n($exps)
| reverse
| map(tostring)
| add

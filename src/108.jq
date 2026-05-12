def target: 2001;
def primes: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29];

def explore($k; $last; $prod; $n; $best):
    (if $prod >= target and $n < $best then $n else $best end) as $cur
    | if $k >= 10 or $n >= $cur then $cur
      else
          reduce range(1; $last + 1) as $a ($cur;
              . as $cur_best
              | ($prod * (2 * $a + 1)) as $new_prod
              | ($n * pow(primes[$k]; $a)) as $new_n
              | if $new_n >= $cur_best then $cur_best
                else explore($k + 1; $a; $new_prod; $new_n; $cur_best)
                end
          )
      end
;

explore(0; 20; 1; 1; 1e15)

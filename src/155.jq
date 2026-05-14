# Capacitor circuit values up to n=18.
# V(1) = {1}. V(n) = union over k=1..floor(n/2) of {a+b, a*b/(a+b) :
# a in V(k), b in V(n-k)}. Answer = |union V(1)..V(18)|.
#
# Each V[n] is a sorted, deduped array of [num, den] pairs in lowest terms.
# We stream pairs through a generator and dedupe with jq's built-in `unique`
# (C-level sort + dedupe), which is far faster than per-key object inserts.

def gcd_iter($a; $b):
    [$a, $b] | until(.[1] == 0; [.[1], (.[0] % .[1])]) | .[0]
;

def add_frac($p; $q):
    ($p[0] * $q[1] + $q[0] * $p[1]) as $n
    | ($p[1] * $q[1]) as $d
    | gcd_iter($n; $d) as $g
    | [$n / $g | floor, $d / $g | floor]
;

def par_frac($p; $q):
    ($p[0] * $q[0]) as $n
    | ($p[0] * $q[1] + $q[0] * $p[1]) as $d
    | gcd_iter($n; $d) as $g
    | [$n / $g | floor, $d / $g | floor]
;

def build_Vn($V; $n):
    [ range(1; ($n / 2 | floor) + 1) as $k
      | $V[$k] as $A | $V[$n - $k] as $B
      | $A[] as $pa | $B[] as $pb
      | add_frac($pa; $pb), par_frac($pa; $pb)
    ]
    | unique
;

reduce range(2; 19) as $n ([null, [[1, 1]]];
    . as $V | . + [build_Vn($V; $n)]
)
| . as $V_all
| [ range(1; 19) as $i | $V_all[$i][] ] | unique | length

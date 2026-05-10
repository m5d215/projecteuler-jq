def cycle_len($d):
    {r: 1, pos: 0, seen: {}, done: null}
    | until(.done != null;
        if .r == 0 then
            .done = 0
        else
            (.r | tostring) as $key
            | if .seen | has($key) then
                .done = (.pos - .seen[$key])
              else
                .pos as $p | .r as $r
                | {
                    r: ((10 * $r) % $d),
                    pos: ($p + 1),
                    seen: (.seen + {($key): $p}),
                    done: null
                  }
              end
        end
      )
    | .done
;

[range(2; 1000) | {d: ., len: cycle_len(.)}] | max_by(.len) | .d

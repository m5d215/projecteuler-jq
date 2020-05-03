[range(1000) | select(. % 3 == 0 or . % 5 == 0)]
| add

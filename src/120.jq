[range(3; 1001)
 | if . % 2 == 1 then . * (. - 1) else . * (. - 2) end
]
| add

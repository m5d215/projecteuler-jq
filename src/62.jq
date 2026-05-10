[range(1; 10000) | . * . * .]
| group_by(tostring | explode | sort)
| map(select(length == 5))
| min_by(.[0])
| .[0]

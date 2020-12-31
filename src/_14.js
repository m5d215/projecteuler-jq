const memo = new Map([[1, 1]])

function collatz(n) {
    if (n % 2 == 0) {
        return n / 2
    } else {
        return 3 * n + 1
    }
}

function discover(n) {
    const via = []

    let m = n
    while (m != 1 && !memo.has(m)) {
        via.push(m)
        m = collatz(m)
    }

    const length = memo.get(m)
    via.reverse().forEach((m, i) => {
        memo.set(m, length + i + 1)
    })
}

for (let n = 1; n < 3000; ++n) {
    discover(n)
}

let maximum = [0, 0]
memo.forEach((length, n) => {
    if (maximum[1] < length) {
        maximum = [n, length]
    }
})

console.log(maximum)

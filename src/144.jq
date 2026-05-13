# Laser bouncing inside 4 x^2 + y^2 = 100. At hit (x, y) the normal direction
# is (4 x, y); the reflected direction r = d - 2 (d.n / n.n) n. Substituting
# (x + t r_x, y + t r_y) into the ellipse equation gives
#   t = -(8 x r_x + 2 y r_y) / (4 r_x^2 + r_y^2)
# for the next intersection. Count bounces until the next hit falls inside
# the |x| <= 0.01, y > 0 exit gap.

def step:
    .pos[0] as $x
    | .pos[1] as $y
    | .dir[0] as $dx
    | .dir[1] as $dy
    | (4 * $x) as $nx
    | $y as $ny
    | ($dx * $nx + $dy * $ny) as $dn
    | ($nx * $nx + $ny * $ny) as $nn
    | (2 * $dn / $nn) as $factor
    | ($dx - $factor * $nx) as $rx
    | ($dy - $factor * $ny) as $ry
    | (-(8 * $x * $rx + 2 * $y * $ry) / (4 * $rx * $rx + $ry * $ry)) as $t
    | {pos: [$x + $t * $rx, $y + $t * $ry], dir: [$rx, $ry], count: (.count + 1)}
;

{pos: [1.4, -9.6], dir: [1.4, -19.7], count: 0}
| until(
    (.pos[0] | fabs) <= 0.01 and .pos[1] > 0;
    step
  )
| .count

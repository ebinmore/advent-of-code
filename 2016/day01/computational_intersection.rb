Matrix

class Matrix
  self.def determinant(m)
    raise error unless square? && row_count == 2
    # detA = | a  b | = ad - bc
    #        | c  d |
    m[0][0] * m[1][1] - m[0][1] * m[1][0]
  end
end

def IntersectionAlgorithm

  # line segments a & b defined by two points as [[x1, y1], [x2, y2]]
  def self.intersect?(a, b)
    # a = [[x1, y1], [x2, y2]]
    # b = [[x3, y3], [x4, y4]]
    intersection_point = [pX(a,b), pY(a,b)]

    puts "line segements #{a} & #{b} intersect at #{intersection_point}"
  end

  def self.pX(a, b)
    # a = [[x1, y1], [x2, y2]]
    # b = [[x3, y3], [x4, y4]]

    # pX = | | x1  y1 |  | x1  1 | | == | a  b |
    #      | | x2  y2 |  | x2  1 | |    | c  d |
    #      |                       |    --------
    #      | | x3  y3 |  | x3  1 | |    | e  f |
    #      | | x4  y4 |  | x4  1 | |    | g  h |
    #      -------------------------
    #      | | x1  1  |  | y1  1 | |
    #      | | x2  1  |  | y2  1 | |
    #      |                       |
    #      | | x3  1  |  | y3  1 | |
    #      | | x4  1  |  | y4  1 | |

    a = Matrix[[ a[0][0], a[0][1] ], [ a[1][0], a[1][1] ]]
    b = Matrix[[ a[0][0],   1     ], [ a[1][0],   1     ]]
    c = Matrix[[ b[0][0], b[0][1] ], [ b[1][0], b[1][1] ]]
    d = Matrix[[ b[0][0],   1     ], [ b[1][0],   1     ]]
    e = Matrix[[ a[0][0],   1     ], [ a[1][0],   1     ]]
    f = Matrix[[ a[0][1],   1     ], [ a[1][1],   1     ]]
    g = Matrix[[ b[0][0],   1     ], [ a[1][0],   1     ]]
    h = Matrix[[ b[1][0],   1     ], [ a[1][1],   1     ]]

    pX_top = Matrix[ [a.determinant, b.determinant], [c.determinant, d.determinant]]
    pX_bottom = Matrix[ [e.determinant, f.determinant], [g.determinant, h.determinant]]

    pX_top.determinant / pX_bottom.determinant
  end

  def self.pY(a, b)
    # a = [[x1, y1], [x2, y2]]
    # b = [[x3, y3], [x4, y4]]

    # pY = | | x1  y1 |  | y1  1 | | == | a  b |
    #      | | x2  y2 |  | y2  1 | |    | c  d |
    #      |                       |    --------
    #      | | x3  y3 |  | y3  1 | |    | e  f |
    #      | | x4  y4 |  | y4  1 | |    | g  h |
    #      -------------------------
    #      | | x1  1  |  | y1  1 | |
    #      | | x2  1  |  | y2  1 | |
    #      |                       |
    #      | | x3  1  |  | y3  1 | |
    #      | | x4  1  |  | y4  1 | |

    a = Matrix[[ a[0][0], a[0][1] ], [ a[1][0], a[1][1] ]]
    b = Matrix[[ a[0][1],   1     ], [ a[1][1],   1     ]]
    c = Matrix[[ b[0][0], b[0][1] ], [ b[1][0], b[1][1] ]]
    d = Matrix[[ b[0][1],   1     ], [ b[1][1],   1     ]]
    e = Matrix[[ a[0][0],   1     ], [ a[1][0],   1     ]]
    f = Matrix[[ a[0][1],   1     ], [ a[1][1],   1     ]]
    g = Matrix[[ b[0][0],   1     ], [ a[1][0],   1     ]]
    h = Matrix[[ b[1][0],   1     ], [ a[1][1],   1     ]]

    pY_top = Matrix[ [a.determinant, b.determinant], [c.determinant, d.determinant]]
    pY_bottom = Matrix[ [e.determinant, f.determinant], [g.determinant, h.determinant]]

    pY_top.determinant / pY_bottom.determinant
  end


end

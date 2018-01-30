import Graphics.Implicit

out = union [
    rect3R 0 (0,0,0) (20,20,20),
    translate (20,20,20) (sphere 15) ]

main = writeSTL 1 "test.stl" out

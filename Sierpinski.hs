module Basica.Sierpinski where

import Dibujo
import Interp

data Sierpinski = Algo | Nada

interpBas :: Output Sierpinski
interpBas Algo = trianD
interpBas Nada = vacio

sierpinski :: (Eq a, Num a) => a -> Sierpinski -> Dibujo Sierpinski
sierpinski 0 p =
  Juntar 3 1 (Basica Nada) (Juntar 1 2 (Basica p) (Basica Nada))
    .-. (Basica p /// Basica p)
sierpinski n p =
  Juntar 3 1 (Basica Nada) (Juntar 1 2 (sierpinski (n -1) p) (Basica Nada))
    .-. (sierpinski (n -1) p /// sierpinski (n -1) p)
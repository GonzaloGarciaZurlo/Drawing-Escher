module Basica.Escher where

import Dibujo
import Interp

data Escher = Algo | Nada

ejemplo :: Dibujo Escher
ejemplo = escher 1 Algo

interpBas :: Output Escher
interpBas Algo = fShape
interpBas Nada = vacio

p2 :: Dibujo Escher -> Dibujo Escher
p2 p = Espejar (Rot45 p)

p3 :: Dibujo Escher -> Dibujo Escher
p3 p = r270 $ p2 p

-- El dibujo t.
hacerT :: Dibujo Escher -> Dibujo Escher
hacerT p = p ^^^ (p2 p ^^^ p3 p)

-- El dibujoU.
hacerU :: Dibujo Escher -> Dibujo Escher
hacerU p = encimar4 $ p2 p

-- Lado con nivel de detalle.
lado :: Int -> Dibujo Escher -> Dibujo Escher
lado 0 p = cuarteto (Basica Nada) (Basica Nada) 
                    (Rotar $ hacerT p) (hacerT p)
lado n p = cuarteto (lado (n -1) p) (lado (n -1) p) 
                    (Rotar $ hacerT p) (hacerT p)

-- Esquina con nivel de detalle en base a la figura p.
esquina :: Int -> Dibujo Escher -> Dibujo Escher
esquina 0 p = cuarteto (Basica Nada) (Basica Nada) 
                       (Basica Nada) (hacerU p)
esquina n p = cuarteto (esquina (n -1) p) (lado (n-1) p) 
                       (Rotar $ lado (n-1) p) (hacerU p)

hacerFila a b c = Juntar 1 2 (a /// b) c

noneto p q r 
       s t u 
       v w x = Apilar 1 2 (hacerFila p q r .-. hacerFila s t u) (hacerFila v w x)

escher :: Int -> Escher -> Dibujo Escher
escher n d = noneto p         q                    (r270 p)
                    (Rotar q) (hacerU $ Basica d)  (r270 q)
                    (Rotar p) (r180 q)             (r180 p)
  where
    p = esquina n (Basica d)
    q = lado n (Basica d)

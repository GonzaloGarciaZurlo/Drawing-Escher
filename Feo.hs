module Basica.Feo where
import Graphics.Gloss
import Graphics.Gloss.Data.Vector
import Graphics.Gloss.Data.Color
import Graphics.Gloss.Geometry.Angle
import qualified Graphics.Gloss.Data.Point.Arithmetic as V
import Dibujo
import Interp

-- Pongan acá el nombre de sus tipos de datos, si es que son diferentes
-- type Dibujo a = ...

-- les ponemos coloritos para que no sea _tan_ feo
data Colores = Azul | Rojo
    deriving Show

data Basica = Rectangulo Colores | Cruz Colores | Triangulo Colores
    deriving Show

colorear Azul = color blue
colorear Rojo = color red

-- Las coordenadas que usamos son:
--
--  x + w
--  |
--  x --- x + y
--
interpBas (Rectangulo c) x y w = colorear c $ line [x, x V.+ w, x V.+ w V.+ y, x V.+ y, x]
interpBas (Cruz c) x y w = colorear c $ pictures [line [x, x V.+ w V.+ y], line [x V.+ w, x V.+ y]]
interpBas (Triangulo c) x y w = colorear c $ line $ map (x V.+) [(0,0), w V.+ half y, y, (0,0)]

-- Diferentes tests para ver que estén bien las operaciones
figRoja f = Basica (f Rojo)
figAzul f = Basica (f Azul)

-- Debería mostrar un rectángulo azul arriba de otro rojo, conteniendo toda la grilla dentro
apilados f = Apilar 1 1 (figAzul f) (figRoja f)

-- Debería mostrar un rectángulo azul arriba de otro rojo, conteniendo toda la grilla dentro
-- el primero ocupando 3/4 de la grilla
apilados2 f = Apilar 1 3 (figAzul f) (figRoja f)

-- Debería mostrar un rectángulo azul a derecha de otro rojo, conteniendo toda la grilla dentro
juntados f = Juntar 1 1 (figAzul f) (figRoja f)

-- Debería mostrar un rectángulo azul a derecha de otro rojo, conteniendo toda la grilla dentro
-- el primero ocupando 3/4 de la grilla
juntados2 f = Juntar 1 3 (figAzul f) (figRoja f)

-- Igual al anterior, pero invertido
flipante1 f = Espejar $ juntados2 f

-- Igual al anterior, pero invertido
flipante2 f = Espejar $ apilados2 f

row :: [Dibujo Basica] -> Dibujo Basica
row [dib1, dib2] = Juntar 1 1 dib1 dib2
row dibs | length dibs > 3 = Juntar 1 1 (row $ take (length dibs `div` 2) dibs) (row $ drop (length dibs `div` 2) dibs)
row _ = error "la cantidad de cuadrantes debe ser potencia de dos"

grilla :: [[Dibujo Basica]] -> Dibujo Basica
grilla [row1, row2] = Apilar 1 1 (row row1) (row row2)
grilla rows | length rows > 3 = Apilar 1 1 (grilla $ take (length rows `div` 2) rows) (grilla $ drop (length rows `div` 2) rows)
grilla _ = error "la cantidad de cuadrantes debe ser potencia de dos"

testAll = grilla
    [
    [figRoja Rectangulo, Rot45 $ figRoja Triangulo, Rot45 $ figAzul Rectangulo, Rot45 $ figAzul Cruz],
    [apilados Rectangulo, apilados2 Rectangulo, juntados Rectangulo, juntados2 Rectangulo],
    [flipante1 Rectangulo, flipante2 Rectangulo, figRoja Triangulo, Rotar $ figAzul Triangulo],
    [apilados Cruz, apilados2 Cruz, juntados Cruz, juntados2 Cruz]
    ]

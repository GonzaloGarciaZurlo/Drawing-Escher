module Interp where
import Graphics.Gloss
import Graphics.Gloss.Data.Vector
import Graphics.Gloss.Geometry.Angle
import qualified Graphics.Gloss.Data.Point.Arithmetic as V

import qualified Graphics.Gloss.Data.Picture as P

import Dibujo
type FloatingPic = Vector -> Vector -> Vector -> Picture
type Output a = a -> FloatingPic

-- el vector nulo
zero :: Vector
zero = (0,0)

half :: Vector -> Vector
half = (0.5 V.*)

-- comprender esta función es un buen ejericio.
hlines :: Vector -> Float -> Float -> [Picture]
hlines (x,y) mag sep = map (hline . (*sep)) [0..]
  where hline h = line [(x,y+h),(x+mag,y+h)] 

-- Una grilla de n líneas, comenzando en v con una separación de sep y
-- una longitud de l (usamos composición para no aplicar este
-- argumento)
grid :: Int -> Vector -> Float -> Float -> Picture
grid n v sep l = pictures [ls,translate 0 (l*toEnum n) (rotate 90 ls)]
  where ls = pictures $ take (n+1) $ hlines v sep l

-- figuras adaptables comunes
trian1 :: FloatingPic
trian1 a b c = line $ map (a V.+) [zero, half b V.+ c , b , zero]

trian2 :: FloatingPic
trian2 a b c = line $ map (a V.+) [zero, c, b,zero]

trianD :: FloatingPic
trianD a b c = line $ map (a V.+) [c, half b , b V.+ c , c]

rectan :: FloatingPic
rectan a b c = line [a, a V.+ b, a V.+ b V.+ c, a V.+ c,a]

simple :: Picture -> FloatingPic
simple p _ _ _ = p

fShape :: FloatingPic
fShape a b c = line . map (a V.+) $ [ zero,uX, p13, p33, p33 V.+ uY , p13 V.+ uY 
                 , uX V.+ 4 V.* uY ,uX V.+ 5 V.* uY, x4 V.+ y5
                 , x4 V.+ 6 V.* uY, 6 V.* uY, zero]    
  where p33 = 3 V.* (uX V.+ uY)
        p13 = uX V.+ 3 V.* uY
        x4 = 4 V.* uX
        y5 = 5 V.* uY
        uX = (1/6) V.* b
        uY = (1/6) V.* c

-- Dada una función que produce una figura a partir de un a y un vector
-- producimos una figura flotante aplicando las transformaciones
-- necesarias. Útil si queremos usar figuras que vienen de archivos bmp.
transf :: (a -> Vector -> Picture) -> a -> Vector -> FloatingPic
transf f d (xs,ys) a b c  = translate (fst a') (snd a') .
                             scale (magV b/xs) (magV c/ys) .
                             rotate ang $ f d (xs,ys)
  where ang = radToDeg $ argV b
        a' = a V.+ half (b V.+ c)

vacio :: FloatingPic
vacio = simple Blank

-- Las coordenadas que usamos son:
--
--  x + h
--  |
--  x --- x + w
--  x:root, w:width, h:hight
rotar :: FloatingPic -> FloatingPic
rotar f x w h = f (x V.+ w) h (V.negate w)

rot45 :: FloatingPic -> FloatingPic
rot45 f x w h = f (x V.+ half (w V.+ h)) (half (w V.+ h)) (half (h V.- w))

espejar :: FloatingPic -> FloatingPic
espejar f x w h = f (x V.+ w) (V.negate w) h

encimar :: FloatingPic -> FloatingPic -> FloatingPic
encimar f g x w h = P.Pictures [f x w h, g x w h]

juntar :: Int  -> Int -> FloatingPic -> FloatingPic -> FloatingPic
juntar n m f g x w h = P.Pictures [f x w' h, g (x V.+ w') (r' V.* w) h]
    where w' = r V.* w
          r = m'/(m'+n')
          r' = n'/(m'+n')
          m' = fromIntegral m :: Float
          n' = fromIntegral n :: Float

apilar :: Int  -> Int -> FloatingPic -> FloatingPic -> FloatingPic
apilar n m f g x w h = P.Pictures [f (x V.+ h') w (r V.* h), g x w h']
    where h' = r' V.* h
          r = m'/(m'+n')
          r' = n'/(m'+n')
          m' = fromIntegral m :: Float
          n' = fromIntegral n :: Float

-- Claramente esto sólo funciona para el ejemplo!
interp :: (a -> FloatingPic) -> Dibujo a -> FloatingPic
interp output = sem output rotar rot45 espejar apilar juntar encimar
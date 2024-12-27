module Main where
import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Display
import Graphics.UI.GLUT.Begin
import Dibujo
import Interp
import qualified Basica.Ejemplo
import qualified Basica.Escher
import qualified Basica.Feo as E
import Basica.Sierpinski

data Conf a = Conf {
    basic :: Output a
  , fig  :: Dibujo a
  , width :: Float
  , height :: Float
  }

ej x y = Conf {
                basic = Basica.Ejemplo.interpBas
              , fig = Basica.Ejemplo.ejemplo
              , width = x
              , height = y
              }

escher x y = Conf {
                basic = Basica.Escher.interpBas
              , fig = Basica.Escher.ejemplo
              , width = x
              , height = y
              }

feo x y = Conf {
                basic = E.interpBas
              , fig = E.testAll
              , width = x
              , height = y
              }

cSierpinski x y = Conf {
                basic = Basica.Sierpinski.interpBas
              , fig = Basica.Sierpinski.sierpinski 5 Algo
              , width = x
              , height = y
              }

-- Dada una computación que construye una configuración, mostramos por
-- pantalla la figura de la misma de acuerdo a la interpretación para
-- las figuras básicas. Permitimos una computación para poder leer
-- archivos, tomar argumentos, etc.
initial :: IO (Conf Basica.Sierpinski.Sierpinski) -> IO ()
initial cf = cf >>= \cfg ->
                  let x  = width cfg
                      y  = height cfg
                  in display win white . withGrid $ interp (basic cfg) (fig cfg) (0,0) (x,0) (0,y)
  where withGrid p = pictures [p, color grey $ grid 10 (0,0) 100 10]
        grey = makeColorI 120 120 120 120

win = InWindow "Nice Window" (200, 200) (0, 0)
main = initial $ return (cSierpinski 100 100)

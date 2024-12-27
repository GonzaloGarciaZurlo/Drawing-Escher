module Basica.Ejemplo where
import Dibujo
import Interp

type Basica = ()
ejemplo :: Dibujo Basica
ejemplo = Basica ()

interpBas :: Output Basica
interpBas () = trian1

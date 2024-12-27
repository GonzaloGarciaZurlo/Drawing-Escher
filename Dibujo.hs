module Dibujo where

-- Definir el lenguaje (reemplazar `()` con lo que corresponda).
data Dibujo a
  = Basica a
  | Rotar (Dibujo a)
  | Espejar (Dibujo a)
  | Rot45 (Dibujo a)
  | Apilar Int Int (Dibujo a) (Dibujo a)
  | Juntar Int Int (Dibujo a) (Dibujo a)
  | Encimar (Dibujo a) (Dibujo a)

-- Composición n-veces de una función con sí misma.
comp :: (a -> a) -> Int -> a -> a
comp f 1 x = f x
comp f n x = f (comp f (n-1) x)

-- Rotaciones de múltiplos de 90.
r180 :: Dibujo a -> Dibujo a
r180 = comp Rotar 2

r270 :: Dibujo a -> Dibujo a
r270 = comp Rotar 3

-- Pone una figura sobre la otra, ambas ocupan el mismo espacio.
(.-.) :: Dibujo a -> Dibujo a -> Dibujo a
(.-.) = Apilar 1 1

-- Pone una figura al lado de la otra, ambas ocupan el mismo espacio.
(///) :: Dibujo a -> Dibujo a -> Dibujo a
(///) = Juntar 1 1

-- Superpone una figura con otra.
(^^^) :: Dibujo a -> Dibujo a -> Dibujo a
(^^^) = Encimar

-- Dadas cuatro figuras las ubica en los cuatro cuadrantes.
cuarteto :: Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
cuarteto x y z w = (x .-. z) /// (y .-. w)

-- Una figura repetida con las cuatro rotaciones, superpuestas.
encimar4 :: Dibujo a -> Dibujo a
encimar4 x = x ^^^ Rotar x ^^^ r180 x ^^^ r270 x

-- Cuadrado con la misma figura rotada i * 90, para i ∈ {0, ..., 3}.
-- No confundir con encimar4!
ciclar :: Dibujo a -> Dibujo a
ciclar x = cuarteto x (Rotar x) (r180 x) (r270 x)

-- Ver un a como una figura.
pureDib :: a -> Dibujo a
pureDib = Basica

-- map para nuestro lenguaje.
mapDib :: (a -> b) -> Dibujo a -> Dibujo b
-- Verificar que las operaciones satisfagan:
-- 1. mapDib id = id, donde id es la función identidad.
-- 2. mapDib (g ∘ f) = (mapDib g) ∘ (mapDib f).
mapDib f (Basica a) = Basica (f a)
mapDib f (Rotar x) = Rotar (mapDib f x)
mapDib f (Espejar x) = Espejar (mapDib f x)
mapDib f (Rot45 x) = Rot45 (mapDib f x)
mapDib f (Apilar a b x y) = Apilar a b (mapDib f x) (mapDib f y)
mapDib f (Juntar a b x y) = Juntar a b (mapDib f x) (mapDib f y)
mapDib f (Encimar x y) = Encimar (mapDib f x) (mapDib f y)

sem :: (a -> b) -> (b -> b) -> (b -> b) -> (b -> b) ->
       (Int -> Int -> b -> b -> b) -> 
       (Int -> Int -> b -> b -> b) -> 
       (b -> b -> b) ->
       Dibujo a -> b
       
sem basica _ _ _ _ _ _ (Basica a) = 
  basica a

sem basica rotar rot45 espejar apilar juntar encimar (Rotar a) = 
  rotar (sem basica rotar rot45 espejar apilar juntar encimar a)

sem basica rotar rot45 espejar apilar juntar encimar (Rot45 a) = 
  rot45 (sem basica rotar rot45 espejar apilar juntar encimar a)

sem basica rotar rot45 espejar apilar juntar encimar (Espejar a) = 
  espejar (sem basica rotar rot45 espejar apilar juntar encimar a)

sem basica rotar rot45 espejar apilar juntar encimar (Apilar x y a b) = 
  apilar x y (sem basica rotar rot45 espejar apilar juntar encimar a) (sem basica rotar rot45 espejar apilar juntar encimar b)

sem basica rotar rot45 espejar apilar juntar encimar (Juntar x y a b) = 
  juntar x y (sem basica rotar rot45 espejar apilar juntar encimar a) (sem basica rotar rot45 espejar apilar juntar encimar b)

sem basica rotar rot45 espejar apilar juntar encimar (Encimar a b) = 
  encimar (sem basica rotar rot45 espejar apilar juntar encimar a) (sem basica rotar rot45 espejar apilar juntar encimar b)

type Pred a = a -> Bool

-- Dado un predicado sobre básicas, cambiar todas las que satisfacen
-- el predicado por la figura básica indicada por el segundo argumento.
cambiar :: Pred a -> a -> Dibujo a -> Dibujo a
cambiar p a = mapDib cambiar' 
  where cambiar' x | p x = a
                   | otherwise = x

-- Alguna básica satisface el predicado.
anyDib :: Pred a -> Dibujo a -> Bool
anyDib p = sem p id id id orDib orDib (||)
  where orDib _ _ a b = a || b

-- Todas las básicas satisfacen el predicado.
allDib :: Pred a -> Dibujo a -> Bool
allDib p = sem p id id id andDib andDib (&&)
  where andDib _ _ a b = a && b

-- Los dos predicados se cumplen para el elemento recibido.
andP :: Pred a -> Pred a -> Pred a
andP p q b = p b && q b
-- Algún predicado se cumple para el elemento recibido.
orP :: Pred a -> Pred a -> Pred a
orP p q b = p b || q b

-- Describe la figura. Ejemplos: 
--   desc (const "b") (Basica b) = "b"
--   desc (const "b") (Rotar (Basica b)) = "rot (b)"
--   desc (const "b") (Apilar n m (Basica b) (Basica b)) = "api n m (b) (b)"
-- La descripción de cada constructor son sus tres primeros
-- símbolos en minúscula, excepto `Rot45` al que se le agrega el `45`.
desc :: (a -> String) -> Dibujo a -> String
desc toString = sem toString rotarS rot45S espejarS apilarS juntarS encimarS
  where rotarS x = "rot(" ++  x ++ ")"
        rot45S x = "rot45(" ++  x ++ ")"
        espejarS x = "esp(" ++  x ++ ")"
        apilarS n m x y = "api " ++ show n ++ " " ++ show m ++ " (" ++  x ++") (" ++ y ++ ")"
        juntarS n m x y = "jun " ++ show n ++ " " ++ show m ++ " (" ++  x ++") (" ++ y ++ ")"
        encimarS x y = "enc(" ++  x ++") (" ++  y ++ ")"

-- Junta todas las figuras básicas de un dibujo.
basicas :: Dibujo a -> [a]
basicas = sem (:[]) id id id joinWithoutNumber joinWithoutNumber (++)
  where joinWithoutNumber _ _ x y = x ++ y 


-- Hay 4 rotaciones seguidas.
esRot360 :: Pred (Dibujo a)
esRot360 (Basica _) = False
esRot360 (Rotar (Rotar (Rotar (Rotar _)))) = True
esRot360 (Rotar x) = esRot360 x
esRot360 (Espejar x) =  esRot360 x
esRot360 (Rot45 x) =  esRot360 x
esRot360 (Apilar _ _ x y) = esRot360 x || esRot360 y
esRot360 (Juntar _ _ x y) = esRot360 x || esRot360 y
esRot360 (Encimar x y) = esRot360 x || esRot360 y

-- Hay 2 espejados seguidos.
esFlip2 :: Pred (Dibujo a)
esFlip2 (Basica _) = False
esFlip2 (Espejar (Espejar  _)) = True
esFlip2 (Rotar x) = esFlip2 x
esFlip2 (Espejar x) =  esFlip2 x
esFlip2 (Rot45 x) =  esFlip2 x
esFlip2 (Apilar _ _ x y) = esFlip2 x || esFlip2 y
esFlip2 (Juntar _ _ x y) = esFlip2 x || esFlip2 y
esFlip2 (Encimar x y) = esFlip2 x || esFlip2 y

data Superfluo = RotacionSuperflua | FlipSuperfluo

-- Aplica todos los chequeos y acumula todos los errores, y
-- sólo devuelve la figura si no hubo ningún error.
check :: Dibujo a -> Either [Superfluo] (Dibujo a)
check d | andP esRot360 esFlip2 d = Left [RotacionSuperflua, FlipSuperfluo]
        | esRot360 d = Left [RotacionSuperflua]
        | esFlip2 d = Left [FlipSuperfluo]
        | otherwise = Right d

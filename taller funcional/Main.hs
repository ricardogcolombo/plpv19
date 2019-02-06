import Util
import Data.List

-- Ejercicio 1
vacio :: [b] -> MEN a b
vacio b = AM b (\x s -> [])

agregarTransicion :: (Eq a, Eq b) => MEN a b -> a -> b -> a -> MEN a b
agregarTransicion (AM ss f) q0 s1 q1 = AM ss faux
    where faux q s |q == q0 && s==s1 = [q1] ++ (f q s)
                   |otherwise = f q s

t1 = agregarTransicion (vacio [1,2]) 'a' 1 'b'
t2 = agregarTransicion t1 'a' 1 'c'
t3 = aislarEstado t2 'a'

aislarEstado :: Eq a => MEN a b -> a -> MEN a b
aislarEstado (AM ss f) q1 = AM ss faux
    where faux q s | q==q1 = []
                   | otherwise = foldr (\x xs -> if x == q1 then xs else x:xs ) [] (f q s)

-- Ejercicio 2
trampaUniversal :: a -> [b] -> MEN a b
trampaUniversal q ss = AM ss (const $ const [q])

completo :: Eq a => MEN a b ->  a  ->  MEN a b
completo (AM ss f) q1 = AM ss faux
    where faux q s = [q1] ++ (f q s)

t4 = completo t2 'a'
-- Ejercicio 3
consumir :: Eq a => MEN a b -> a -> [b] -> [a]
consumir (AM ss f) q1 ys = foldl (\rec x -> concat ( map (\q -> f q x ) rec ) ) [q1] ys


-- Ejercicio 4
acepta :: Eq a => MEN a b -> a -> [b] -> [a] -> Bool
acepta = undefined

lenguaje :: Eq a => MEN a b -> a ->  [a] -> [[b]]
lenguaje = undefined

-- Sugerencia (opcional)
kleene :: [b] -> [[b]]
kleene = undefined

-- Ejercicio 5
trazas :: MEN a b -> a -> [[b]]
trazas = undefined

--Ejercicio 6

deltaS :: Eq a => MEN a b -> [a] -> [a]
deltaS = undefined

fixWhile :: (a -> a) -> (a -> Bool) -> a -> a
fixWhile = undefined

fixWhileF :: (a -> a) -> (a -> Bool) -> a -> a
fixWhileF = undefined

alcanzables :: Eq a => MEN a b -> a -> [a]
alcanzables = undefined

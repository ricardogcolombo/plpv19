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
acepta a1 q1 ys qs = estanTodos qs (consumir a1 q1 ys)

estanTodos:: Eq a => [a] -> [a] -> Bool
estanTodos [] _ = True
estanTodos xs ys = foldr (\x z-> (elem x ys) && z) True xs

lenguaje :: Eq a => MEN a b -> a ->  [a] -> [[b]]
lenguaje aut q0 qs = foldr (\s rec -> if acepta aut q0 s qs then s:rec else rec) [] (kleene (sigma aut))

-- Sugerencia (opcional)
kleene :: [b] -> [[b]]
kleene bs = [x | k<-[0..], x<-(foldNat [[]] (\r -> concat (map (\c -> map (\s -> c++[s]) bs ) r)) k)]

-- Ejercicio 5
trazas ::  Eq a => MEN a b -> a -> [[b]]
trazas aut q0 = filter (\t-> ((length $ consumir aut q0 t)>0 )) (todasLasTrazas aut)

--Todas las trazas son cada tamaño de traza, de 0 al infinito
todasLasTrazas ::Eq a => MEN a b -> [[b]]
todasLasTrazas aut = [ x | k <-[0..], x <- trazasDeTamanio aut k]


--Lista de trazas de tamaño k
trazasDeTamanio :: Eq a =>MEN a b -> Integer -> [[b]]
trazasDeTamanio aut n = foldNat [[]] (\t -> agregarSimboloATrazas (sigma aut) t) n

-------DE ACA PARA ABAJO FUNCIONA, ARREGLAR LAS FUNCIONES DE ARRIBA QUE NO TIPAN Y CREO QUE VA----

--A cada traza de tamaño k, le agrego atras los simbolos del automata 
-- agregarSimboloATrazas :: Eq a =>[b] -> [[b]] -> [[b]]
agregarSimboloATrazas ss t = concat(map (\traza->  agregarSimbolos traza ss ) t)

--agregarSimboloATrazas ['a','b'] ["ab", "ba"]
-- >["aba","abb","baa","bab"]

-- agregarSimbolos :: [b] -> [[b]] - >[[b]]
agregarSimbolos traza ss = [traza++[ss!!i] | i <- [0..length(ss)-1]]
--agregarSimbolos "ab" ['a','b']
-- >["aba","abb"]

--Ejercicio 6

deltaS :: Eq a => MEN a b -> [a] -> [a]
deltaS = undefined

fixWhile :: (a -> a) -> (a -> Bool) -> a -> a
fixWhile = undefined

fixWhileF :: (a -> a) -> (a -> Bool) -> a -> a
fixWhileF = undefined

alcanzables :: Eq a => MEN a b -> a -> [a]
alcanzables = undefined

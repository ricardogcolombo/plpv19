:- [paradas, esquinas].
:- multifile parada/3.

% ------------------------------------------------------------------------------
% Ejercicios

% 1. Dar consultas para obtener:
% a. Dada una calle, todas los números donde hay una parada de colectivos y
%    la lista de las líneas que paran allí.

% ?-


% b. Dada una lista de líneas, todos los pares (calle, número) donde paran
%    exactamente esas líneas.

% ?-


% 2. compartenParada(+Linea1, +Linea2, ?Calle, ?Numero).


% 3. viaje(?Linea, ?CalleOrig, ?NumOrig, ?CalleDest, ?NumDest)


% 4. a. lineasQueParan(+Calle, -Lineas).


% 4. b. lineasQueParan(+Calle, +Numero, -Lineas)


% 5. Extender parada/3


% 6. paradaCercana(+Calle, +Numero, +Distancia, ?Parada)


% 7. pasaPor(+Recorrido, ?Calle, ?Numero)


% 8. recorrido(+CalleOrig, +NumOrig, +CalleDest, +NumDest, +Dist,
%              +CantTrasbordos, -Recorrido)


% ------------------------------------------------------------------------------
% Predicado auxiliar

% diferentes(+Calle1, +Numero1, +Calle2, +Numero2)
diferentes(Calle1, _, Calle2, _) :- Calle1 \= Calle2, !.
diferentes(_, Numero1, _, Numero2) :- Numero1 \= Numero2.

:- [paradas, esquinas].
:- multifile parada/3.

% ------------------------------------------------------------------------------
% Ejercicios

% 1. Dar consultas para obtener:
% a. Dada una calle, todas los números donde hay una parada de colectivos y
%    la lista de las líneas que paran allí.

paradasYLineas(C,N,L):- parada(C,N,L).


% b. Dada una lista de líneas, todos los pares (calle, número) donde paran
%    exactamente esas líneas.

callesYParadas(L,(C,N)):- parada(C,N,L3), member(L1,L3), member(L1,L).


% 2. compartenParada(+Linea1, +Linea2, ?Calle, ?Numero).
compartenParada(L1,L2,C,N):- parada(C,N,L), member(L2,L), member(L1,L).
compartenParada(L1,L2,C,N):- parada(C,N,P1), parada(C,N,P2), P1\=P2, member(L2,P2), member(L1,P1).

% 3. viaje(?Linea, ?CalleOrig, ?NumOrig, ?CalleDest, ?NumDest)
viaje(L,CO,NO, CD,ND):- parada(CO,NO,L2), parada(CD,ND, L3), diferentes(CO,NO,CD,ND), member(L,L3),member(L,L2).


% 4. a. lineasQueParan(+Calle, -Lineas).

lineasQuePara(C,LS) :- setof(X,tieneParada(C,X), LS).

tieneParada(C,X):- parada(C,_,L3), member(X,L3).


% 4. b. lineasQueParan(+Calle, +Numero, -Lineas)
lineasQuePara(C,N,LS) :- setof(X,tieneParada(C,N,X), LS).

tieneParada(C,N,X):- parada(C,N,L3), member(X,L3).


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

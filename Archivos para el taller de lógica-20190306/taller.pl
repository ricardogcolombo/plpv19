:- [paradas,esquinas].
:- multifile parada/3.

% ------------------------------------------------------------------------------
% Ejercicios

% 1. Dar consultas para obtener:
% a. Dada una calle, todas los números donde hay una parada de colectivos y
%    la lista de las líneas que paran allí.

paradasYLineas(C,N,L):- parada(C,N,L).

paradasYLineas(C,N,L):- paradaEsquina(C,_,L).
paradasYLineas(C,N,L):- paradaEsquina(_,C,L).

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
lineasQueParan(C,N,LS) :- setof(X,tieneParada(C,N,X), LS).

tieneParada(C,N,X):- parada(C,N,L3), member(X,L3).


% 5. Extender parada/3
parada(C,N,LS):- esquina(C,N,C2,N2),paradaEsquina(C,C2,LS).
parada(C,N,LS):- esquina(C2,N2,C,N),paradaEsquina(C2,C,LS).

% 6. paradaCercana(+Calle, +Numero, +Distancia, ?Parada)

enRango(M,N,D):- N-D =< M, M =< N+D.

% sobre la misma cuadra dame todas las paradas
paradaCercana(C, N, D, P) :-  P = parada(C,M,L),P, enRango(M,N,D).

%en cada esquina recorrer la distancia que falta, devolve las paradas
paradaCercana(C, N, D,P) :- esquina(C,N1,C2,N2), enRango(N1,N,D), P = parada(C2,M,L),P,D1 is D-(N1-N),enRango(M,N2,D1).
paradaCercana(C, N, D,P) :- esquina(C2,N2,C,N1), enRango(N1,N,D), P = parada(C2,M,L),P,D1 is D-(N1-N),enRango(M,N2,D1).


% 7. pasaPor(+Recorrido, ?Calle, ?Numero)
pasaPor(LS,C,N):- member(V,LS), V = viaje(_,C,N, _,_).
pasaPor(LS,C,N):- member(V,LS), V = viaje(_,_,_, C,N).
pasaPor(LS,C,N):- member(V,LS), V = viaje(_,C,N1,C,N2),V,S1 is N1+1,S2 is N2-1, between(S1,S2,N).


% 8. recorrido(+CalleOrig, +NumOrig, +CalleDest, +NumDest, +Dist,
%              +CantTrasbordos, -Recorrido)

recorridoSimple(CO,NO,D,viaje(L,C,N,CD,ND)):- paradaCercana(CO,NO,D,parada(C,N,LS)),
												member(L,LS),
												parada(CD,ND,LS2),
												member(L,LS2),
												diferentes(C,N,CD,ND).

recorrido(CO,NO,CD,ND,D,CT,[V]):- recorridoSimple(CO,NO,D,viaje(L,C,N,CD2,ND2)), V =  viaje(L,C,N,CD2,ND2), 
								paradaCercana(CD,ND,D, parada(CD2,ND2,LS)), member(L,LS).

recorrido(CO,NO,CD,ND,D,CT,[V|VS]):- CT>=1,
									recorridoSimple(CO,NO,D, viaje(L,C,N,CD2,ND2)),
									V =  viaje(L,C,N,CD2,ND2), 
									CT2 is CT-1,
									recorrido(CD2,ND2,CD,ND,D,CT2,VS),
									not(member(viaje(L,_,_,_,_),VS)),
									not(pasaPor(VS,C,N)).
									

% Predicado auxiliar

% diferentes(+Calle1, +Numero1, +Calle2, +Numero2)
diferentes(Calle1, _, Calle2, _) :- Calle1 \= Calle2, !.
diferentes(_, Numero1, _, Numero2) :- Numero1 \= Numero2.

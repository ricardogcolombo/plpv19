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

%---------PENSADO EN LA CLASE-----------------------------------------------------------

%recorrido(CO,NO,CD,ND,D,CT,R):- V= viaje(LI,CO,NO,CD,ND),V, parada(CO,NO,L),parada(CD,ND,L2),member(LI,L),member(LI,L2),R = [V].

%recorrido(CO,NO,CD,ND,D,CT,R):- paradaCercana(CO,NO,D,P),P = parada(C,N,L),parada(C,N,L),

%---------------------------------------------------------------------------------------

%Voy a generar todos los recorridos desde origen y destino y despues filtrar con lo que falta (generate and test)

%recorrido(CO, NO, CD,ND,D,0,R):- [].
%recorrido(CO,NO,CD,ND,D,CT,R):- todosLosRecorridos(CO,NO,CD,ND,D R), length(R,N), N =< CT, noPasaPorSiMismo.

lineasDeParada(parada(C,N,LS),LS).
calleDeParada(parada(C,_,_),C).
numeroDeParada(parada(_,N,_),N).

calleOrigenDeViaje(viaje(_,CO,_,_,_),CO).
calleDestinoDeViaje(viaje(_,_,_,CD,_),CD).
numeroOrigenDeViaje(viaje(_,_,NO,_,_),NO).
numeroDestinoDeViaje(viaje(_,_,_,_,ND),ND).
lineaDeViaje(viaje(L,_,_,_,_),L).

%tomo un solo bondi, el viaje debe comenzar, terminar con misma linea, las direcciones (ORIGEN  - DESTINO)coincidir con las paradas cercanas de las direcciones

todosLosRecorridos(CO,NO,CD,ND,D,[viaje(L,C,N,CF,NF)]):- 
														paradaCercana(CO,NO,D,P), 
														lineasDeParada(P,LS),
														calleDeParada(P,C),
														numeroDeParada(P,N),
														member(L,LS), 
														paradaCercana(CD,ND,D,PD),
														calleDeParada(P,CF),
														numeroDeParada(PD, NF),
														lineasDeParada(PD,LSD), 
														member(L,LSD).

 
 
 %Tomo mas de uno, el primero debe ser mi ORIGEN.
todosLosRecorridos(CO,NO,_,_,D,[viaje(L,C,N,CD2,ND2),V2|VS]):- 
																paradaCercana(CO,NO,D,PO),
																calleDeParada(PO,C),
																numeroDeParada(PO,N),
																lineasQueParan(C,N,LS),
																member(L,LS),
																tieneParada(CD2,ND2,L),
																ND2\=N,
																paradaCercana(CD2,ND2,D,P2),
																calleDeParada(P2,C2),
																numeroDeParada(P2,N2),
																calleOrigenDeViaje(V2,C2),
																numeroOrigenDeViaje(V2,N2),
																lineasQueParan(C2,N2,LS2),
																sinL(LS2,L,LS2),
																member(L2,LS2),
																lineaDeViaje(V2,L2),
																todosLosRecorridos(CD2,ND2,CD,ND,D,[V2|VS]).

paradaDeViaje(viaje(L,CO,NO,_,_),D,P):- paradaCercana(CO, NO,D,P), lineasDeParada(P,LS),member(L, LS).

paradaCercanaDeViaje(viaje(_,CO,NO,_,_),D,P):- paradaCercana(CO, NO,D,P).

sinL([],_,[]).
sinL([L|LS],L, LSS):- sinL(LS,L,LSS).
sinL([L1| XS ], L, [L1 | YS]) :- L \= L1,sinL(XS, L, YS).

%----------------------------------------------------------------------------------------
%CREO QUE NO VA A HACER FALTA ESTE, ADEMAS DE QUE LAS LISTAS ESCRITAS ASI NO TIPAN
%tomo mas de uno, el ultimo es el destino.														
%todosLosRecorridos(_,_,CD,ND,D,[VS|V1,(viaje(L,CO2,NO2,CD,ND))]):- 
%																paradaDeViaje(V1,D,P1),
%																calleDestino(V1,CO2),
%																numeroDestino(V1, NO2), 
%																paradaCercana(CO2,NO2,D,P),
%																lineasDeParada(P,LS),
%																member(L,LS),
%																paradaCercana(CD,ND,PD),
%																lineasDeParada(PD,LSD),
%																member(L,LSD).
% ------------------------------------------------------------------------------
% Predicado auxiliar

% diferentes(+Calle1, +Numero1, +Calle2, +Numero2)
diferentes(Calle1, _, Calle2, _) :- Calle1 \= Calle2, !.
diferentes(_, Numero1, _, Numero2) :- Numero1 \= Numero2.

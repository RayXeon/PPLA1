mhead([Head|_],Head).	

dis([X|XS],Rlist,Dlist,Total):-
	mhead(XS,Y),
	print('X is '),print(X),print(', '),
	print(' Y is '),print(Y),nl,
	bigt(X,Y,Rlist,Dlist,Dis),
	K is Dis,
	print('K is '),print(K),nl,	
	dis(XS,Rlist,Dlist,NTotal),
	Total is K + NTotal.
dis([X,Y],Rlist,Dlist,T):-
	bigt(X,Y,Rlist,Dlist,Dis),
	T is Dis.
	
	
addelement([], 0).
addelement([Head | Tail], Total) :-
    addelement(Tail, Sum1),
    Total is Head + Sum1.
	
addli([Head|Tail],Final):-
	addelement(Head, K),
	addli(Tail,NewF),
	Final is K + NewF.
addli([],0).		

round(R0,R1,K,X):-
				R0 \= R1,
				R0 < R1,
				X is pi * K * (R1-R0) / 360;
				R0 \= R1,
				R0 > R1,
				X is pi * K * (360-abs(R0-R1)) / 360;
				X is pi * K.


tablefinder(X,Y,List,Dlist,Dis):-
	nth(1,List,A),
	nth(2,List,B),
	X == A,
	Y == B,
	nth(3,List,C),
	nth(4,List,D),
	nth(5,List,E),
	nth(Y,Dlist,F),
	round(D,E,F,G),
	Dis is C + G.


bigt(L,M,[X|XS],Y,Dis):-
		tablefinder(L,M,X,Y,Dis);
		bigt(L,M,XS,Y,Dis).
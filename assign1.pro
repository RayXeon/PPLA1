trip(1,7).
diameters([1000,1000,1000,1000,400,1000,1000]).
roads([[1,2,500,225,45], [1,3,500,315,135],
	  [2,4,500,315,135],[3,4,500,224,45],
	  [4,5,500,225,45], [4,6,500,315,135],
	  [5,7,500,315,135],[6,7,500,225,45]]).

edge(A,B,[X|XS]):-
				nth(1,X,K1),
				nth(2,X,K2),
				A is K1,
				B is K2;
				edge(A,B,XS).
			
getroute( From, To, Route ,L) :- 
	hop( [From], To, RevRoute ,L),
	reverse( RevRoute, Route ).
hop( [To|Before], To, [To|Before] ,_). % We are there.
hop( [At|Before], To, FinalRoute ,L) :-
	edge( At, NewCity ,L),
	\+ member( NewCity, [At|Before] ),
	hop( [NewCity,At|Before], To, FinalRoute ,L).

all_v2( From, To, AllRoutes ,L) :- 
	allroutes( From, To, [], AllRoutes ,L),
	pprint( AllRoutes ).
	
allroutes( Start, Finish, Sofar, New ,L) :-
	getroute( Start, Finish, TheRoute ,L),
	\+ member( TheRoute, Sofar ),
	allroutes( Start, Finish, [TheRoute|Sofar], New ,L).
allroutes( _, _, AllRoutes, AllRoutes ,_).

pprint([]) :- nl.
pprint( [F|R] ) :- 
%	calulate(F,X),
	print('Distance= 0'),
%	print(X),print(' '),
	print( 'Route= ' ), print(F), nl, pprint(R),nl.	

			

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
	
%base on start point L, and end point, find data from road map. 
%and also calulate this part of distance.
bigt(L,M,[X|XS],Dlist,Dis):-
		tablefinder(L,M,X,Dlist,Dis);
		bigt(L,M,XS,Dlist,Dis).	

mhead([X|_],X).	
mtail([_|XS],XS).
lookahead([_|XS],Y):-
	mhead(XS,K),
	Y is K.

%base Route calulate first part distance, then recursively calulate the rest route.			
%distance(routeList,roadmap,diameterList,totalDistance)
%dis(RouteList,Rlist,Dlist,TDis):-
%	mhead(RouteList,X),
%	lookahead(RouteList,Z),	
%	print(X),nl,
%	print(Z).
%	bigt(X,Y,Rlist,Dlist,Dis),
%	NewTDis is TDis + Dis,
%	dis(XS,Rlist,Dlist,NewTDis).		

go :-
	trip(Start,Stop),
	roads(RList),
%	diameters(Dlist),
%	print('Dlist is '),
%	print(Dlist),nl,
	%edge(_,_,RList).
	all_v2(Start,Stop,_,RList),
	print('My program currently can find Route'),nl,
	print('we desired, and could calulate partial distance'), nl,
	print('but fail to calulate a total distance of route').


	


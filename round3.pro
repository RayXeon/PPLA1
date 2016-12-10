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

all_v2( From, To, AllRoutes,L) :- 
	allroutes( From, To, [], AllRoutes ,L).
	
allroutes( Start, Finish, Sofar, New ,L) :-
	getroute( Start, Finish, TheRoute ,L),
	\+ member( TheRoute, Sofar ),
	allroutes( Start, Finish, [TheRoute|Sofar], New ,L).
allroutes( _, _, AllRoutes, AllRoutes ,_).

addRoutewithDistance([],[],[]).
addRoutewithDistance([X,Y],X,Y).

calculateDistance([],_,_,_):- nl.
%last one
calculateDistance([X|[]],Rlist,Dlist,RoadMap):-
	dis(X,Rlist,Dlist,Total),
	addRoutewithDistance(RoadMap1, Total, X),
	append([RoadMap1],[],RoadMap).
%general case		
calculateDistance([F|R],Rlist,Dlist,RoadMap) :-
	dis(F,Rlist,Dlist,Total),
	calculateDistance(R,Rlist,Dlist,RoadMap2),
	addRoutewithDistance(RoadMap1, Total, F),
	append([RoadMap1],RoadMap2,RoadMap).
		
printmylist([]):- nl.
printmylist([Head|Tail]) :-
	nth(1,Head,Item1),
	nth(2,Head,Item2),
	print('Distance = '),
	print(Item1),
	print('  Route = '),
	print(Item2),nl,
	printmylist(Tail).	
	
% roundabout path calculate	
round(R0,R1,K,X):-
				R0 \= R1,
				R0 < R1,
				X is 3.14159265359 * K * (R1-R0) / 360;
				R0 \= R1,
				R0 > R1,
				X is 3.14159265359 * K * (360-abs(R0-R1)) / 360;
				X is 3.14159265359 * K.

% route information match
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

% one point to anther distance calculate
bigt(L,M,[X|XS],Y,Dis):-
		tablefinder(L,M,X,Y,Dis);
		bigt(L,M,XS,Y,Dis).

mhead([Head|_],Head).	


% this function calculate distance that through whole
% recursively, calculate piece by piece 
dis([X|XS],Rlist,Dlist,Total):-
	mhead(XS,Y),
	bigt(X,Y,Rlist,Dlist,Dis),
	K is Dis,
	dis(XS,Rlist,Dlist,NTotal),
	Total is K + NTotal.

dis([X,Y],Rlist,Dlist,T):-
	bigt(X,Y,Rlist,Dlist,Dis),
	T is Dis.

go :-
	trip(Start,Stop),
	roads(Rlist),
	diameters(Dlist),
	all_v2(Start,Stop,AllRoutes,Rlist),
	calculateDistance(AllRoutes,Rlist,Dlist,RoadMap),
	sort(RoadMap),nl,nl,
	print('Routes In increasing order: '), nl,
	printmylist(RoadMap).
	



	


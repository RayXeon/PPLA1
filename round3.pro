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

mHead([Head|_],Head).
mTail([_|Tail],Tail).


% Roundabout path calculation.	
% For precision deal pi later. currently assume pi is 1
round(EnterAngle,LeaveAngle,Diameters,RoundPathDistance):-
				EnterAngle \= LeaveAngle,
				EnterAngle < LeaveAngle,
				RoundPathDistance is 1 * Diameters * (LeaveAngle-EnterAngle) / 360;
				EnterAngle \= LeaveAngle,
				EnterAngle > LeaveAngle,
				RoundPathDistance is 1 * Diameters * (360-(EnterAngle-LeaveAngle)) / 360;
				RoundPathDistance is 1 * Diameters.

% Route information Extraction
routeInfoExtractor(Start,End,Route,DiameterList,Diameter,EnterAngleOfEndPoint,LeaveAngleOfStartPoint,P2PDistance):-
	nth(1,Route,A),
	nth(2,Route,B),
	Start == A,
	End == B,
	nth(3,Route,C),
	P2PDistance is C,
	nth(4,Route,D),
	LeaveAngleOfStartPoint is D,
	nth(5,Route,E),
	EnterAngleOfEndPoint is E,
	nth(End,DiameterList,G),
	Diameter is G.

% Route match.
matchRoute(Start,End,[X|XS],DiametersList,Diameter,EA,LA,PPD):-
	routeInfoExtractor(Start,End,X,DiametersList,Diameter,EA,LA,PPD);
	matchRoute(Start,End,XS,DiametersList,Diameter,EA,LA,PPD).

% One complete route distance calculation. 
% General Case:
disCal([X|XXS],Rlist,Dlist,Total):-
	mHead(XXS,Y),
	mTail(XXS,XS),
	mHead(XS,Z),
	matchRoute(X,Y,Rlist,Dlist,D2,EA2,_,PPD12),
	matchRoute(Y,Z,Rlist,Dlist,_,_,LA2,_),
	round(EA2,LA2,D2,RoundPathDistance),
	DistanceSoFar is PPD12 + RoundPathDistance * 3.14159265359,
	disCal(XXS,Rlist,Dlist,NTotal),
	Total is DistanceSoFar + NTotal.
% End of the route.
disCal([X,Y],Rlist,Dlist,Total):-
	matchRoute(X,Y,Rlist,Dlist,_,_,_,Dis),
	Total is Dis.

%% Result appending.
addRoutewithDistance([],[],[]).
addRoutewithDistance([X,Y],X,Y).

calculateDistance([],_,_,_):- nl.
calculateDistance([X|[]],Rlist,Dlist,RoadMap):-
	disCal(X,Rlist,Dlist,Total),
	addRoutewithDistance(RoadMap1, Total, X),
	append([RoadMap1],[],RoadMap).

%% General Case
calculateDistance([F|R],Rlist,Dlist,RoadMap) :-
	disCal(F,Rlist,Dlist,Total),
	calculateDistance(R,Rlist,Dlist,RoadMap2),
	addRoutewithDistance(RoadMap1, Total, F),
	append([RoadMap1],RoadMap2,RoadMap).

%% Result representing		
printmylist([]):- nl.
printmylist([Head|Tail]) :-
	nth(1,Head,Item1),
	nth(2,Head,Item2),
	print('Distance = '),
	print(Item1),
	print('  Route = '),
	print(Item2),nl,
	printmylist(Tail).	
	

go :-
	trip(Start,Stop),
	roads(Rlist),
	diameters(Dlist),
	all_v2(Start,Stop,AllRoutes,Rlist),
	calculateDistance(AllRoutes,Rlist,Dlist,RoadMap),
	sort(RoadMap),nl,nl,
	print('Routes In increasing order: '), nl,
	printmylist(RoadMap).
	



	


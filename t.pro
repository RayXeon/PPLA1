li([[1,2,3],[2,3,4],[3,4,5],[4,5,6]]).



addelement([], 0).
addelement([Head | Tail], Total) :-
    addelement(Tail, Sum1),
    Total is Head + Sum1.
	
addli([Head|Tail],Final):-
	addelement(Head, K),
	addli(Tail,NewF),
	Final is K + NewF.
addli([],0).		

mhead([X|_],X).	

dis([X|XS]):-
	mhead(XS,Y),
	print('X is '),print(X),print(', '),
	print(' Y is '),print(Y),nl,
	dis(XS).
	
	
addtest :-
	li(List),
	addli(List,Total),
	print('Total is '),
	print(Total).
		
		
		
%%[[1,2,500,225,45],[1,3,500,315,135],[2,4,500,315,135],[3,4,500,224,45],[4,5,500,225,45],[4,6,500,315,135],[5,7,500,315,135],[6,7,500,225,45]]

%%[1000,1000,1000,1000,400,1000,1000]
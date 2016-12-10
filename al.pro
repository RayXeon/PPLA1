addRoutewithDistance([],[],[]).
addRoutewithDistance([X,Y],X,Y).


mysort(X):-
	sort(X),
	print(X).
	
printmylist([]).	
printmylist([X|XS]) :-
	nth(1,X,Item1),
	nth(2,X,Item2),
	print('Distance is: '),
	print(Item1),
	print('  Route= '),
	print(Item2),nl,
	printlastlist(XS).
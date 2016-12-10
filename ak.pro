
insert(X, [], [X]).
insert(X, [Y|Rest], [X,Y|Rest]) :-
    X @< Y, !.
insert(X, [Y|Rest0], [Y|Rest]) :-
    insert(X, Rest0, Rest).

%arrange([],_,_,_) :- nl.
%arrange( [F|R],TempList,TempBiggestDis,Rlist,Dlist) :- 
%	dis(F,Rlist,Dlist,Total),
%	print('Distance = '),
%	print(Total),print(' '),
%	print( 'Route= ' ), print(F), nl, arrange(R,Rlist,Dlist),nl.
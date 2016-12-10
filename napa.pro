%
% How can we get to Napa from Omaha? This is an important question!
% We show here how to do problems like maze solving, remembering the
% routes along the way.
%
% Bill Mahoney
% For 4220 class

% All flights. Note that trying to shortcut the data by
% saying "flight(X,Y):-flight(Y,X)." will create an infinite loop.

% And yes, I know that Chicago is not "chi" it is "ord" or "mdw".
% For that matter, Houston could be "hou" or "iah".

flight( oma, den ). 
flight( den, oma ).
flight( den, sea ). 
flight( sea, den ).
flight( oma, chi ). 
flight( chi, oma ).
flight( chi, den ). 
flight( den, chi ).
flight( den, sfo ). 
flight( sfo, den ).
flight( sea, sfo ). 
flight( sfo, sea ).
flight( chi, sfo ). 
flight( sfo, chi ).
flight( sfo, nap ). 
flight( nap, sfo ).
flight( oma, hou ). 
flight( hou, oma ).
flight( hou, chi ). 
flight( chi, hou ).
flight( chi, sea ). 
flight( sea, chi ).

% Can we get there in one stop? (no!)

one_stop( From, To ) :-
	flight( From, Stop ),
	flight( Stop, To ),
	print( 'Got to ' ), print( To ), print( ' via ' ), print( Stop ), nl.

% Can we get there in two stops?

two_stop( From, To ) :-
	flight( From, Stop1 ),
	flight( Stop1, Stop2 ),
	flight( Stop2, To ),
	print( 'Got to ' ), print( To ), 
	print( ' via ' ), print( Stop1 ),
	print( ' and ' ), print( Stop2 ), nl.

% Can we get there in N stops? This is an infinite loop if flights
% from A to B also go from B to A (as in the above data) because there
% is no check for this. To try this, comment out all of the "return
% flights" and you will see how it works.

n_stop( From, To ) :- 
	n_stop( From, _, To ),
	nl, print( 'Where I started, which is ' ), print( From ).
n_stop( Dest, _, Dest ). % Made it.
n_stop( From, Temp, To ) :- 
	flight( From, Temp ),
	n_stop( Temp, _, To ),
	nl, print( 'I made it to ' ), print( Temp ), print( ' by coming from...' ).

% Can we get there, but generate the list of waypoints as we go?
% This list is created when we RETURN from the recursion. Note that
% because of this, we may have loops in our path, and as such they
% may be infinitely long paths. Just remember to get up and move
% about the cabin from time to time. Seriously, this version will
% work UNLESS (we we have above) we allow flights from A to B to
% also go from B to A. Stack overflow is the result, same as the
% previous example.

n_stop_trace( From, To, Route ) :- 
	n_stop_trace( From, _, To, Route ),
	print( 'Made it! Route was: ' ), print( Route ).
n_stop_trace( Dest, _, Dest, [Dest] ). % Made it.
n_stop_trace( From, Temp, To, [From|Rest] ) :- 
	flight( From, Temp ),
	n_stop_trace( Temp, _, To, Rest ).

% Can we get there, and save a route as we go? This  one will avoid 
% any infinite loops. Also, let's print the route in the right order 
% as well. This is the best solution. Let's call it getroute.

getroute( From, To, Route ) :- 
	hop( [From], To, RevRoute ),
	reverse( RevRoute, Route ).
hop( [To|Before], To, [To|Before] ). % We are there.
hop( [At|Before], To, FinalRoute ) :-
	flight( At, NewCity ),
	\+ member( NewCity, [At|Before] ),
	hop( [NewCity,At|Before], To, FinalRoute ).

% Finally, let's make this one that will print ALL possible routes.
% I do this by making the rule explicitly FAIL after the route is
% printed, so Prolog will try again and again...

all_v1( From, To ) :-
	getroute( From, To, Route ),
	print( 'Made it! Route was: ' ), print( Route ), nl, fail.

% But a better way is to actually collect a list of the routes.
% Here is where we can show that... I will add a pretty-printer
% as well, so as to show off my super Prolog skills.

all_v2( From, To, AllRoutes ) :- 
	allroutes( From, To, [], AllRoutes ),
	pprint( AllRoutes ).
allroutes( Start, Finish, Sofar, New ) :-
	getroute( Start, Finish, TheRoute ),
	\+ member( TheRoute, Sofar ),
	allroutes( Start, Finish, [TheRoute|Sofar], New ).
allroutes( _, _, AllRoutes, AllRoutes ).

pprint([]) :- nl.
pprint( [F|R] ) :- 
	print( 'Made it! Route was: ' ), print(F), nl, pprint(R).

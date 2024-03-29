% How to make change for a dollar, in half's, quarters,
% dimes, nickles, and pennies. Load into gprolog, and then 
% "change(X)" gives all possible combinations of change 
% for a dollar.

% Bill Mahoney
% CS4220

change( [ H, Q, D, N, P ] ) :-
    member( H, [ 0, 1, 2 ] ),
    member( Q, [ 0, 1, 2, 3, 4 ] ),
    member( D, [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ] ),
    member( N, [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 ] ),
    S is 50 * H + 25 * Q + 10 * D + 5 * N,
    S =< 100,
    P is 100 - S.


% This is the second project of COMP90048, Author: JUNWEI XING, Student ID: 745568.

% makes sure the puzzle solution should be (1) square matrix. (2) the elements in diagobal should be same. (3) verify for more rules. 
puzzle_solution(X):-
	same_size(X),
	diagonal(X),
	verify(X).

% without first row for verifying diagonal, and 1 as the first in index.
diagonal([_|Rest]):-
	diagonal0(1, Rest).

% a recursion is to check the elements in the diagonal. 
diagonal0(_,[]).
diagonal0(_,[[]]).
diagonal0(_,[[_|_]]).
diagonal0(Index, [Row1,Row2|Rest]):-
	Index0 is Index + 1,
    nth0(Index, Row1, Get1),
	nth0(Index0, Row2, Get2),
	Get1 = Get2,
	diagonal0(Index0, [Row2|Rest]).

% square matrix - make sure same length in every row and column.
same_size(X):-
    equal_lengths(X),
	ensure_loaded(library(clpfd)),
	transpose(X, Result),
	equal_lengths(Result).

% a recursion is to check the length of rows and columns. 
equal_lengths([]).
equal_lengths([[]]).
equal_lengths([[_|_]]).
equal_lengths([X,Y|Rest]) :- 
  length(X, Len), 
  length(Y, Len), 
  equal_lengths([Y|Rest]).
  
% verify aims to make sure (1) each element is differet in the own row or column. (2) columns are concerted with the heads by plus or times together.
% (3) rows are concerted with the heads by plus or times together.
verify([]).
verify([[]]).
verify([Head|X]):-
	verifyRows(X),
	verifyColumns([Head|X]).

% This code block aims to verify column heads.

verifyColumns(X):-
	 ensure_loaded(library(clpfd)),
	 transpose(X, Result),
	 before_convert(Result).
	 
before_convert([Head|Tail]):-
	verifyRows(Tail).

% This code block aims to verify row heads.
verifyRows([]).
verifyRows([[]]).	
verifyRows([[Target|Head]|Tail]):-
	verify_row(Target,Head),
	verifyRows(Tail).

verify_row(Target,X):-
	sum_row(X,Result),
	Result = Target,
	different(X).

verify_row(Target,X):-
	product_row(X,Result),
	Result = Target,
	different(X).

% selecting a element should be within the scope 1-9.
sum_row([], 0).
sum_row([H|T], Sum) :-
   sum_row(T, Rest),
   member(H,[1,2,3,4,5,6,7,8,9]),
   Sum is H + Rest.
  
product_row([], 1).
product_row([H|T], Product) :-
   product_row(T, Rest),
   member(H,[1,2,3,4,5,6,7,8,9]),
   Product is H * Rest.

% a element is distinctive in a target list.
different([]).
different([H|T]):-
    \+member(H,T),
    different(T).
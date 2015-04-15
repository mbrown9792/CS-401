room(kitchen).
room(office).
room(hall).
room('dining room').
room(cellar).

location(desk, office).
location(apple, kitchen).
location(flashlight, desk).
location('washing machine', cellar).
location(nani, 'washing machine').
location(broccoli, kitchen).
location(crackers, kitchen).
location(computer, office).

door(office, hall).
door(kitchen, office).
door(hall, 'dining room').
door(kitchen, cellar).
door('dining room', kitchen).

connect(X,Y) :- door(X,Y).
connect(X,Y) :- door(Y,X).

edible(apple).
edible(crackers).

tastes_yucky(broccoli).

turned_off(flashlight).

here(kitchen).

where_food(X,Y) :-
	location(X,Y),
	edible(X).
where_food(X,Y) :-
	location(X,Y),
	tastes_yucky(X).

list_things(Place) :-
	location(X, Place),
	tab(2),
	write(X),
	nl,
	fail.
list_things(AnyPlace).

list_connections(Place) :-
  connect(Place, X),
  tab(2),
  write(X),
  nl,
  fail.
list_connections(_).

look :-
  here(Place),
  write('You are in the '), write(Place), nl,
  write('You can see:'), nl,
  list_things(Place),
  write('You can go to:'), nl,
  list_connections(Place).

look_in(Thing):-
  location(_,Thing),
  write('The '),write(Thing),write(' contains:'),nl,
  list_things(Thing).
look_in(Thing):-
  respond(['There is nothing in the ',Thing]).

start :-
	write('-Hello! What is your problem today?'), nl,
	take_input.

take_input :-
	read_line_to_codes(user_input, InputWord),
	atom_codes(InputString, InputWord),
	atomic_list_concat(List, ' ', InputString),
	(InputString == 'stop' -> nl, abort ; pattern_match(List)).

pattern_match(List) :- take_input.

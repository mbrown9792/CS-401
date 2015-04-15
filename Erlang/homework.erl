-module(homework).
-export([start_server/0, create_userlist/4, return_user/2, end_server/1]).

-record(user, {username, status, message}).

start_server() -> spawn_link(fun init/0).

return_user(Pid, User = #user{}) ->
    Pid ! {return, User},
    ok.

create_userlist(Pid, Username, Status, Message) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, {create, Username, Status, Message}},
    receive
        {Ref, User} ->
            erlang:demonitor(Ref, [flush]),
            User;
        {'DOWN', Ref, process, Pid, Reason} ->
            erlang:error(Reason)
    after 5000 ->
	erlang:error(timeout)
    end.

end_server(Pid) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, end_user},
    receive
        {Ref, ok} ->
            erlang:demonitor(Ref, [flush]),
            ok;
        {'DOWN', Ref, process, Pid, Reason} ->
            erlang:error(Reason)
    after 5000 ->    
        erlang:error(timeout)
    end.
    
init() -> loop([]).

loop(Users) ->
    receive
        {Pid, Ref, {create, Username, Status, Message}} ->
            if Users =:= [] ->
                Pid ! {Ref, make_user(Username, Status, Message)},
                loop(Users); 
               Users =/= [] ->
                Pid ! {Ref, hd(Users)},
                loop(tl(Users))
            end;
        {return, User = #user{}} ->
            loop([User|Users]);
        {Pid, Ref, terminate} ->
            Pid ! {Ref, ok},
            end_user(Users);
        Unknown ->
            io:format("Unknown message: ~p~n", [Unknown]),
            loop(Users)
    end.

make_user(Username, Status, Message) ->
    #user{username=Username, status=Status, message=Message}.

end_user(Users) ->
    [io:format("~p is offline.~n",[C#user.username]) || C <- Users],
    ok.

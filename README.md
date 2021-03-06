erpcgen
=======

Erlang [external data representation](https://en.wikipedia.org/wiki/External_Data_Representation) ([XDR](https://tools.ietf.org/html/rfc4506)) protocol compiler

Build
-----

    $ rebar3 compile

Examples
--------

~~~ example.x
struct example_int {
  int n;
};

struct example_nested {
  example_int n;
  int x;
};

enum example_enum {
  one = 1,
  two = 2,
  three = 3
};
~~~

To convert the XDR file:

~~~ erlang
% NOTE: the filename is an atom without the ".x" extension
erpcgen:file('example', [xdrlib]).
~~~

The result:

~~~ erlang
%%
%% example_xdr was generated by erpcgen (do not edit)
%% date: Nov 9 10:28:28 2017
%%
-module(example_xdr).
-export([enc_example_int/1, dec_example_int/2]).
-export([enc_example_nested/1, dec_example_nested/2]).
-export([enc_example_enum/1, dec_example_enum/2]).

enc_example_int(_1) ->
    case _1 of
        {_2} ->
            [<<_2:32>>]
    end.

dec_example_int(_1, _2) ->
    begin
        begin
            <<_:_2/binary,_3:32/signed,_/binary>> = _1,
            _4 = _2 + 4
        end,
        {{_3},_4}
    end.

enc_example_nested(_1) ->
    case _1 of
        {_3,_2} ->
            [enc_example_int(_3),<<_2:32>>]
    end.

dec_example_nested(_1, _2) ->
    begin
        {_3,_4} = dec_example_int(_1, _2),
        begin
            <<_:_4/binary,_5:32/signed,_/binary>> = _1,
            _6 = _4 + 4
        end,
        {{_3,_5},_6}
    end.

enc_example_enum(_1) ->
    case _1 of
        one ->
            <<1:32>>;
        two ->
            <<2:32>>;
        three ->
            <<3:32>>
    end.

dec_example_enum(_1, _2) ->
    begin
        <<_:_2/binary,_3:32,_/binary>> = _1,
        case _3 of
            1 ->
                {one,_2 + 4};
            2 ->
                {two,_2 + 4};
            3 ->
                {three,_2 + 4}
        end
    end.

dec_example_enum_i2a(_4) ->
    case _4 of
        1 ->
            one;
        2 ->
            two;
        3 ->
            three
    end.
~~~

A longer example used for decoding the [libvirtd remote protocol](https://github.com/msantos/verx/blob/master/bin/mk_remote_protocol.escript).

History
-------

This version of erpcgen is a fork from [jungerl](https://github.com/gebi/jungerl/tree/master/lib/rpc) for use with [verx](https://github.com/msantos/verx).

The history of _erpcgen_ was discussed in [this thread](http://erlang.org/pipermail/erlang-questions/2012-December/071012.html). [Tony Rogvall](http://erlang.org/pipermail/erlang-questions/2012-December/071013.html) is the original author:

    This code was initially written by me (Tony Rogvall). With improvements
    by Martin Björklund, Luke Gorrie wrote the NFS  examples. Later the
    code was "stolen" by Sendmail.

Handling char/short
-------------------

If the XDR file contains `char` or `short` integers, conversion will
fail. These units can be replaced by `int`: the XDR wire protocol uses
a minimum size of 4 bytes.

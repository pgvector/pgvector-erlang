-module(epgsql_codec_vector).
-behaviour(epgsql_codec).

-export([init/2, names/0, encode/3, decode/3, decode_text/3]).

-export_type([data/0]).

-type data() :: list().

init(_, _) -> [].

names() -> [vector, halfvec].

encode(Vec, vector, _) ->
    Dim = length(Vec),
    Data = << <<V:1/big-float-unit:32>> || V <- Vec >>,
    <<Dim:1/big-signed-unit:16, 0:1/big-signed-unit:16, Data/binary>>;
encode(Vec, halfvec, _) ->
    Dim = length(Vec),
    Data = << <<V:1/big-float-unit:16>> || V <- Vec >>,
    <<Dim:1/big-signed-unit:16, 0:1/big-signed-unit:16, Data/binary>>.

decode(Bin, vector, _) ->
    <<Dim:1/big-signed-unit:16, _Unused:1/big-signed-unit:16, Rest:(Dim * 4)/binary>> = Bin,
    [V || <<V:1/big-float-unit:32>> <= Rest];
decode(Bin, halfvec, _) ->
    <<Dim:1/big-signed-unit:16, _Unused:1/big-signed-unit:16, Rest:(Dim * 2)/binary>> = Bin,
    [V || <<V:1/big-float-unit:16>> <= Rest].

decode_text(V, _, _) -> V.

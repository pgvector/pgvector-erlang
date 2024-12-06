-module(example).
-export([main/1]).

main(_Args) ->
    {ok, C} = epgsql:connect(#{
        host => "localhost",
        username => os:getenv("USER"),
        database => "pgvector_erlang_test"
    }),
    {ok, _, _} = epgsql:equery(C, "CREATE EXTENSION IF NOT EXISTS vector"),
    {ok, _, _} = epgsql:equery(C, "DROP TABLE IF EXISTS items"),
    {ok, _, _} = epgsql:equery(C, "CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3))"),
    {ok, _} = epgsql:equery(C, "INSERT INTO items (embedding) VALUES ($1), ($2), ($3)", ["[1,1,1]", "[2,2,2]", "[1,1,2]"]),
    {ok, _Count, Rows} = epgsql:equery(C, "SELECT id FROM items ORDER BY embedding <-> $1 LIMIT 5", ["[1,1,1]"]),
    io:format("~p~n", [Rows]),
    {ok, _, _} = epgsql:equery(C, "CREATE INDEX ON items USING hnsw (embedding vector_l2_ops)"),
    ok = epgsql:close(C),
    erlang:halt(0).

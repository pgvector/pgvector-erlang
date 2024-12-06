# pgvector-erlang

[pgvector](https://github.com/pgvector/pgvector) examples for Erlang

Supports [epgsql](https://github.com/epgsql/epgsql)

[![Build Status](https://github.com/pgvector/pgvector-erlang/actions/workflows/build.yml/badge.svg)](https://github.com/pgvector/pgvector-erlang/actions)

## Getting Started

Follow the instructions for your database library:

- [epgsql](#epgsql)

## epgsql

Enable the extension

```erlang
epgsql:equery(C, "CREATE EXTENSION IF NOT EXISTS vector"),
```

Create a table

```erlang
epgsql:equery(C, "CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3))"),
```

Insert vectors

```erlang
epgsql:equery(C, "INSERT INTO items (embedding) VALUES ($1), ($2)", ["[1,2,3]", "[4,5,6]"]),
```

Get the nearest neighbors

```erlang
epgsql:equery(C, "SELECT id FROM items ORDER BY embedding <-> $1 LIMIT 5", ["[3,1,2]"]),
```

Add an approximate index

```erlang
epgsql:equery(C, "CREATE INDEX ON items USING hnsw (embedding vector_l2_ops)"),
% or
epgsql:equery(C, "CREATE INDEX ON items USING ivfflat (embedding vector_l2_ops) WITH (lists = 100)"),
```

Use `vector_ip_ops` for inner product and `vector_cosine_ops` for cosine distance

See a [full example](src/example.erl)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/pgvector/pgvector-erlang/issues)
- Fix bugs and [submit pull requests](https://github.com/pgvector/pgvector-erlang/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/pgvector/pgvector-erlang.git
cd pgvector-erlang
createdb pgvector_erlang_test
rebar3 escriptize
_build/default/bin/example
```

<!-- codebase-memory-mcp:start -->

# Codebase Knowledge Graph (codebase-memory-mcp)

This project uses codebase-memory-mcp to maintain a knowledge graph of the codebase.
ALWAYS prefer MCP graph tools over grep/glob/file-search for code discovery.

## Priority Order
1. `search_graph` — find functions, classes, routes, variables by pattern
2. `trace_path` — trace who calls a function or what it calls
3. `get_code_snippet` — read specific function/class source code
4. `query_graph` — run Cypher queries for complex patterns
5. `get_architecture` — high-level project summary

## When to fall back to grep/glob
- Searching for string literals, error messages, config values
- Searching non-code files (Dockerfiles, shell scripts, configs)
- When MCP tools return insufficient results

## Examples
- Find a handler: `search_graph(name_pattern=".*OrderHandler.*")`
- Who calls it: `trace_path(function_name="OrderHandler", direction="inbound")`
- Read source: `get_code_snippet(qualified_name="pkg/orders.OrderHandler")`
<!-- codebase-memory-mcp:end -->

<!-- postgres-mcp:start -->

# PostgreSQL Database Access

This project uses Postgres MCP Pro to inspect the live PostgreSQL database.
Prefer MCP tools over guessing schema details from code or migrations.

## Priority Order
1. `list_schemas`
2. `list_objects`
3. `get_object_details`
4. `execute_sql`
5. `explain_query`
6. `analyze_query_indexes`
7. `get_top_queries`
8. `analyze_workload_indexes`
9. `analyze_db_health`

## Rules
- Treat the live database as the source of truth for the current schema.
- Inspect tables, columns, constraints, and indexes before writing SQL.
- Prefer read-only queries and use `LIMIT` for sample data.
- Do not modify schema or data unless explicitly requested.
- Do not expose secrets or sensitive data.
- Use `explain_query` before recommending performance changes.
- Check existing indexes before proposing new ones.
- Use Codebase Memory to trace which application code uses the inspected tables or queries.

## Examples
- Inspect tables: `list_objects(schema_name="public", object_type="table")`
- Inspect table details: `get_object_details(schema_name="public", object_name="orders", object_type="table")`
- Sample data: `execute_sql(sql="SELECT id, status FROM public.orders LIMIT 20")`
- Analyze query: `explain_query(sql="SELECT * FROM public.orders WHERE customer_id = $1")`
<!-- postgres-mcp:end -->

<!-- project-validation:start -->

# Change Validation

After making changes:

1. Run the narrowest relevant test.
2. Run typecheck.
3. Run lint for affected files.
4. Inspect `git diff`.
5. Run the full suite only when the change has broad impact.

Do not consider the task complete until the relevant validation steps have been performed.
Report any commands that could not be run and explain why.

<!-- project-validation:end -->

<!-- latex-validation:start-->

# LaTeX Validation

After modifying LaTeX files:

1. Inspect LSP diagnostics.
2. Run `latexmk -pdf -interaction=nonstopmode thesis.tex`.
3. Check for undefined references and citations.
4. Do not modify citation keys, labels, paths, or command names unless required.
5. Inspect `git diff` before completing the task.

<!-- latex-validation:end -->


# Architecture

- src/core/ - engine-independent domain logic
- src/scene/ - Three.js scene construction
- src/rendering/ - renderer, postprocessing, shaders
- src/ui/ - application UI
- src/state/ - application state

# Rules

- TypeScript strict mode.
- Do not use `any`.
- Keep Three.js objects out of domain state.
- Dispose geometries, materials and textures when removing objects.
- Prefer existing abstractions before creating new ones.
- Before modifying architecture, inspect related modules and call sites.
- Do not introduce dependencies without asking.

# Three.js

- Three.js version is defined in package.json.
- Do not assume APIs from another Three.js version.
- Reuse the existing renderer/camera/scene lifecycle.

# AGENTS.md — ticket-handling

A standalone analytics artifact: SQL analysis + a Power BI dashboard over a customer-support
dataset (1,000 tickets · 50 agents · 300 customers). Not part of the Python extraction
pipeline — it's portfolio BI work. MySQL · Power BI · DAX.

Part of the **ml-lab** system. Within the lab, the root `AGENTS.md` holds the lab-wide
mandate (collaborator not executor, human review gate, integrity, lean/anti-sprawl, no AI
attribution in commit messages). Follow it; the essentials are restated below so this repo
also stands alone.

## Working here
- **Run SQL:** execute `queries/analysis.sql` against a MySQL instance loaded with the dataset.
- **Dashboard:** open `dashboard/helpdesk_dashboard.pbix` in Power BI Desktop (connects to MySQL).
- **Conventions:** SQL (window functions, CTEs, subqueries, JOINs); DAX for measures. `data/` is
  gitignored.
- **Structure:** `queries/analysis.sql` · `dashboard/helpdesk_dashboard.pbix` · `data/` (gitignored).

## Core mandate (from the lab)
- Propose changes as reviewable diffs; the human decides. Never fabricate; flag uncertainty.
- Lean over clever; edit over create; match existing style.
- Commit messages carry no AI/agent attribution.

## Session close
Before ending a session, update **STATUS.md**: what changed + the suggested next action.

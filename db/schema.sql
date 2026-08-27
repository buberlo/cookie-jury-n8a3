PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS cookies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  domain TEXT NOT NULL,
  name TEXT NOT NULL,
  value TEXT,
  path TEXT NOT NULL DEFAULT '/',
  expires_at TEXT,
  secure INTEGER NOT NULL DEFAULT 0,
  http_only INTEGER NOT NULL DEFAULT 0,
  same_site TEXT,
  source TEXT,
  imported_at TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE (domain, name, path)
);

CREATE INDEX IF NOT EXISTS idx_cookies_domain ON cookies(domain);

CREATE TABLE IF NOT EXISTS trackers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  domain TEXT NOT NULL UNIQUE,
  label TEXT,
  category TEXT,
  cookie_count INTEGER NOT NULL DEFAULT 0,
  first_seen TEXT,
  last_seen TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS defendants (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tracker_id INTEGER NOT NULL UNIQUE REFERENCES trackers(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  alias TEXT,
  motive TEXT,
  description TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS evidence (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  defendant_id INTEGER NOT NULL REFERENCES defendants(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  detail TEXT,
  weight REAL NOT NULL DEFAULT 0.5 CHECK (weight BETWEEN 0 AND 1),
  source TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_evidence_defendant ON evidence(defendant_id);

CREATE TABLE IF NOT EXISTS verdicts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  defendant_id INTEGER NOT NULL REFERENCES defendants(id) ON DELETE CASCADE,
  verdict TEXT NOT NULL CHECK (verdict IN ('guilty', 'not_guilty', 'mistrial')),
  confidence REAL NOT NULL DEFAULT 0 CHECK (confidence BETWEEN 0 AND 1),
  summary TEXT,
  simulated_at TEXT NOT NULL DEFAULT (datetime('now')),
  duration_seconds INTEGER NOT NULL DEFAULT 60
);

CREATE INDEX IF NOT EXISTS idx_verdicts_defendant_time ON verdicts(defendant_id, simulated_at DESC);

CREATE TABLE IF NOT EXISTS decisions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  defendant_id INTEGER NOT NULL UNIQUE REFERENCES defendants(id) ON DELETE CASCADE,
  verdict_id INTEGER REFERENCES verdicts(id) ON DELETE SET NULL,
  decision TEXT NOT NULL CHECK (decision IN ('block', 'whitelist', 'flag')),
  reason TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_decisions_defendant ON decisions(defendant_id);
# gray-send-message

Drop outside messages into the next agent turn — a gray sidecar. Port of
pi's `send-user-message` (gray has no mid-turn user injection, so messages
queue on disk and ride the next `agent/before_start`).

## What it does

- `/tell <text>` appends `{"ts","text"}` to `~/.gray/send-message/queue.jsonl`
  and confirms via `host/say "queued: <text>"`. A failed say never loses the
  queued message.
- Any line appended to the plain-text drop file `~/.gray/send-message/inbox`
  (e.g. `echo "look at this" >> ~/.gray/send-message/inbox`) is delivered on
  the next turn.
- `agent/before_start` drains both files (rename-then-read, so a writer
  mid-drain lands in a fresh queue) and returns them as one user message,
  each line prefixed `[queued message]`.

## Wire methods

- `plugin/manifest`, `plugin/shutdown`
- `agent/before_start` — `{text}` appended as a user message, or `{}`
- `command/run` — `/tell <text>`
- sidecar→host `host/say` — capability `host.say`

## Install / consent

```sh
gray plugin install send-message
gray plugin capabilities send-message --all   # grants host.say
```

## Develop

```sh
cargo test
gray account check      # entry point + manifest handshake
gray account publish    # check → build → release → publish to the gray registry
```

Bump `version` in `Cargo.toml` before each `publish`; the registry refuses to
republish a version.

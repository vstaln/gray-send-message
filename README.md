<p align="center">
  <img src="assets/gray-logo.svg" alt="gray" width="96">
</p>
<h1 align="center">gray-send-message</h1>
<p align="center">Queue external messages into the next agent turn.</p>
<p align="center">
  <a href="https://github.com/vstaln/gray-send-message/blob/main/LICENSE"><img alt="MIT License" src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
  <img alt="gray plugin" src="https://img.shields.io/badge/gray-plugin-7aa2f7.svg">
  <img alt="rust" src="https://img.shields.io/badge/built%20with-rust-orange.svg">
</p>

Let outside processes leave messages that arrive as user input on the next
agent turn.

## What it does

- `/tell <text>` appends `{"ts","text"}` to
  `~/.gray/send-message/queue.jsonl` and confirms with `host/say
  "queued: <text>"`. A failed confirmation never loses the queued message.
- Any line appended to the plain-text inbox
  `~/.gray/send-message/inbox` is delivered on the next turn — for example,
  `echo "look at this" >> ~/.gray/send-message/inbox`.
- `agent/before_start` drains both files using rename-then-read, so a writer
  mid-drain lands in a fresh queue. Pending lines are returned as one user
  message, each prefixed `[queued message]`.

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

---
Part of the [gray](https://github.com/vstaln/gray) plugin ecosystem —
the open-source AI agent harness. <https://gray.alignment.id>

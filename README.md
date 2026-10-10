<div align="center">
  <img alt="gray-send-message" src="assets/icon.svg" width="120" height="120" />
  <h1>gray-send-message</h1>
  <p><strong>Let outside processes queue messages that arrive on the next agent turn.</strong></p>
  <p>
    <a href="https://gray.alignment.id">Website</a> ·
    <a href="https://gray.alignment.id/plugins/gray-send-message">Store</a> ·
    <a href="https://github.com/vstaln/gray-send-message">Source</a> ·
    <a href="https://github.com/vstaln/gray">gray</a>
  </p>
  <p>
    <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-1c1c20?style=flat-square&labelColor=0a0a0b" /></a>
    <a href="https://www.rust-lang.org"><img alt="Built with Rust" src="https://img.shields.io/badge/built%20with-rust-1c1c20?style=flat-square&labelColor=0a0a0b&logo=rust&logoColor=d4a373" /></a>
    <a href="https://gray.alignment.id/plugins/gray-send-message"><img alt="gray plugin" src="https://img.shields.io/badge/gray-plugin-1c1c20?style=flat-square&labelColor=0a0a0b&color=7aa2f7" /></a>
  </p>
</div>

<br/>

```bash
gray plugin install gray-send-message
```

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

## Tags

`gray` `plugin` `send-message` `rust`

---
Part of the [gray](https://github.com/vstaln/gray) plugin ecosystem —
the open-source AI agent harness. <https://gray.alignment.id>

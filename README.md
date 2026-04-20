# CLI-Anything

> Making ALL Software Agent-Native — Universal CLI wrappers for 70+ applications.

CLI-Hub: [clianything.cc](https://clianything.cc/)

## Overview

CLI-Anything creates CLI wrappers for virtually any desktop, server, or cloud application — making them accessible to AI agents. If an agent can run a CLI command, it can now control Blender, GIMP, OBS Studio, Audacity, and 60+ other apps.

## Supported Applications (70+)

**Creative:** Blender, GIMP, Inkscape, Krita, KDEnlive, Shotcut, Audacity, OBS Studio, MuseScore, ComfyUI
**Dev/DevOps:** PM2, n8n, Dify, Ollama, ChromaDB, WireMock, CloudAnalyzer
**Productivity:** Obsidian, Zotero, LibreOffice, NotebookLM, Mubu
**Communication:** Feishu/Lark, WeCom, Zoom
**Browsers:** Browser automation, Safari, iTerm2
**Design/CAD:** FreeCAD, DrawIO, Sketch, Mermaid
**Security/Infra:** AdGuard Home, RenderDoc, IntelWatch, Eth2

## Public Registry

50+ third-party CLIs installable via npm/brew in `public_registry.json`.

## How Agents Use It

```bash
cli-anything blender --render scene.blend
cli-anything gimp --apply-filter gaussian-blur --input photo.jpg
cli-anything obs --start-recording
cli-anything n8n --trigger-workflow "daily-report"
```

## Integration Points

- **OH-MY-ClaudeCode / OMX** — Agents invoke CLI-Anything as skills
- **Compound Engineering Plugin** — CLI commands as plugin actions
- **Polsio** — Task queue dispatches CLI-Anything jobs
- **ThePopeBot** — Cron jobs trigger CLI-Anything automations
- **Mission Control** — CLI health visible on dashboard

---
*Part of the InsightProfit Enterprise AI Infrastructure*
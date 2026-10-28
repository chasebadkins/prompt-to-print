# Prompt-to-Print

A project for going from a plain-language prompt to a printed part. You describe a part to [Claude Code](https://claude.com/claude-code), it models the part in [SolidCraft](https://github.com/bherbruck/solidcraft) through SolidCraft's MCP server, then slices the model and sends it to the printer.

As this is an experiment, it is build using the following applications and workflow:   ClaudeCode -> SolidCraft -> SuperSlice -> Klipper

## Features

- **Design by prompt.** Claude Code drives the SolidCraft app through its MCP server: sketches, features, fillets, patterns, assemblies, joints and motion studies. You watch the model build in the SolidCraft viewport and can step in at any point. Claude checks its work with SolidCraft's measure, inspect and screenshot tools.
- **SolidCraft skills.** The project skills in `.claude/skills/` explain to Claude how to use SolidCraft well (they come from the SolidCraft project; see [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md)):
  - `solidcraft-modeling`: building parts.
  - `solidcraft-mechanisms`: assemblies, joints and motion.
  - `solidcraft-checking`: checks SolidCraft doesn't do itself, regression tests, and porting from OpenSCAD, CadQuery or STEP.
  - `solidcraft-editing`: changing existing designs.
- **Slicing and printing.** The `slice-and-print` skill slices an STL with SuperSlicer and uploads the G-code to a Klipper printer through Moonraker. It can also start the print right away.
  - **Material:** say PLA or ABS, and the skill slices with `superslicerconfig-PLA.ini` or `superslicerconfig-ABS.ini`. If you don't say which, Claude asks.  (These are profiles from my environment.  Please replace with your own - or add others.)
  - **Printer:** say which printer by its host name, mine are `voron-v24.local` or `voron-v01.local` - configure as necessary for your environment. If you don't say which, Claude asks.
  - **Upload or print:** it only starts the print when you explicitly ask it to. Otherwise it uploads the G-code and asks you.
- **One folder per design.** Each design gets its own folder under `designs/` for its source, exports, G-code and previews, so one job is easy to clean up before starting the next.  This also allows you to reprint a previous design.  

## Starting a session

Claude drives the SolidCraft window you have open, so start SolidCraft with its control port before (or alongside) Claude Code. From the project folder, in PowerShell:

```powershell
Start-Process solidcraft.exe -ArgumentList '--control', '7878'; claude
```

Or from a Command Prompt:

```bat
start "" solidcraft.exe --control 7878 & claude
```

This opens the SolidCraft window, then starts Claude Code in the terminal. Arrange the two side by side so you can watch the model being built while you chat and make edits to your design before slicing and printing. The MCP server connects to SolidCraft on port 7878. If SolidCraft wasn't running yet, Claude's SolidCraft tools report that it isn't running until you start it; you don't need to restart Claude Code.

To check the connection, ask Claude "Is SolidCraft running?".

## Typical workflow

1. Start SolidCraft and Claude Code as shown above.
2. In Claude Code, describe the part, for example: "Design a 40 mm cable clip for a 6 mm cable, 3 mm thick."
3. Review the model in the viewport and ask for changes.
4. Ask Claude to export an STL and slice it, for example: "Slice it in PLA and print it on voron-v24."

## Setup

| Requirement | Notes |
|---|---|
| SolidCraft | `solidcraft.exe` and `solidcraft-cli.exe` on `PATH` |
| SolidCraft MCP server | Register it with Claude Code: `claude mcp add solidcraft -- solidcraft-cli.exe mcp --connect 127.0.0.1:7878` |
| SuperSlicer | `superslicer_console.exe` on `PATH` |
| Printers | Klipper with Moonraker, reachable as `voron-v24.local` or `voron-v01.local`. Other host names are rejected; to add one, edit the host check in `.claude/skills/slice-and-print/slice-and-print.cmd` |
| curl | Used to upload the G-code |

The SolidCraft MCP server only reads and writes files in its own temporary folder, so Claude copies files in and out of that folder to save designs into `designs/`.

## Repository layout

```
designs/<design-name>/   one folder per design (local only)
.claude/skills/          project skills: SolidCraft and slice-and-print
```

The `designs/` folder is local storage and is git-ignored, so designs aren't in the repo. Exports (`.stl`, `.3mf`, `.step`) and slicer output (`.gcode`) are git-ignored wherever they are.

## License

[MIT](LICENSE). The SolidCraft skills keep their own MIT/Apache-2.0 license; see [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

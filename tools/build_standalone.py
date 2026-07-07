from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[1]

MODULES = [
    "src/Utility.lua",
    "src/Theme.lua",
    "src/Animation.lua",
    "src/Config.lua",
    "src/Notification.lua",
    "src/Components/Button.lua",
    "src/Components/Toggle.lua",
    "src/Components/Slider.lua",
    "src/Components/Label.lua",
    "src/Components/Paragraph.lua",
    "src/Components/Divider.lua",
    "src/Components/Textbox.lua",
    "src/Components/Dropdown.lua",
    "src/Components/Keybind.lua",
    "src/Components/ColorPicker.lua",
    "src/Components/Section.lua",
    "src/Components/Tab.lua",
    "src/Window.lua",
    "src/init.lua",
]

REQUIRE_LINE = re.compile(r"^local\s+\w+\s*=\s*require\(script\.Parent")
RETURN_LINE = re.compile(r"^return\s+\w+\s*$")


def transform(path: Path) -> str:
    lines = []
    for line in path.read_text().splitlines():
        if REQUIRE_LINE.match(line):
            continue
        if RETURN_LINE.match(line):
            continue
        lines.append(line)
    return "\n".join(lines).rstrip()


def main() -> None:
    chunks = [
        "-- LocitoUI Standalone Bundle",
        "-- Version 0.2.0",
        "-- Generated from src modules by tools/build_standalone.py.",
        "-- Use this file with loadstring/game:HttpGet when a ModuleScript tree is not available.",
        "",
        "if typeof(game) ~= \"Instance\" then",
        "\terror(\"LocitoUI must run inside Roblox\")",
        "end",
        "",
    ]

    for module in MODULES:
        path = ROOT / module
        chunks.append(f"-- {module}")
        chunks.append(transform(path))
        chunks.append("")

    chunks.append("return LocitoUI")
    chunks.append("")

    output_dir = ROOT / "dist"
    output_dir.mkdir(exist_ok=True)
    (output_dir / "LocitoUI.lua").write_text("\n".join(chunks))


if __name__ == "__main__":
    main()

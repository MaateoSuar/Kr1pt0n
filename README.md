# Kr1pt0n

Linux Enumeration & Learning Tool

Kr1pt0n is a modular Bash-based Linux enumeration and privilege review framework designed for CTF players, beginners in offensive security, and educational lab environments.

## Features

- Enumeration modules
- Educational explanations
- Quick mode
- Modular architecture
- Markdown reports
- JSON reports
- Risk scoring summary
- Bilingual interface support (English and Spanish)

## Installation

```bash
git clone https://github.com/MaateoSuar/Kr1pt0n.git
cd Kr1pt0n
chmod +x kr1pt0n.sh modules/*.sh utils/*.sh core/*.sh lang/*.sh
```

## Usage

```bash
./kr1pt0n.sh
./kr1pt0n.sh --quick
./kr1pt0n.sh --module cron
./kr1pt0n.sh --module perms --quick
./kr1pt0n.sh --auto
```

## Modules

- enum
- cron
- perms
- privesc
- services
- reverse
- upgrade
- auto

## Architecture

- `kr1pt0n.sh` - main CLI router
- `modules/` - audit and helper modules
- `core/` - centralized findings, output, and reporting
- `utils/` - shared runtime and banner utilities
- `lang/` - language packs
- `reports/` - generated Markdown and JSON reports
- `logs/` - runtime logs and session artifacts

## Reports

Kr1pt0n generates reports from a centralized reporting layer.

Current outputs:

- Markdown report
- JSON report
- Risk score summary

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Roadmap

- JSON export improvements
- richer risk scoring
- plugin system
- scan profiles
- expanded educational content

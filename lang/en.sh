#!/bin/bash

LANG_CODE="en"
TOOL_INTRO_TITLE="Kr1pt0n Ethical Hacking Toolkit"
TOOL_INTRO_SUBTITLE="For educational and authorized penetration testing only."
BANNER_TITLE="Kr1pt0n - Ethical Hacking Toolkit"
BANNER_WARNING="Use only on systems you own or have explicit permission to test."
BANNER_SESSION_LOG="Session log:"
MENU_OPTION_1="System Enumeration"
MENU_OPTION_2="Privilege Escalation Analysis"
MENU_OPTION_3="Cron Review"
MENU_OPTION_4="Permission Review"
MENU_OPTION_5="Services Review"
MENU_OPTION_6="Reverse Shell Generator"
MENU_OPTION_7="Upgrade Shell"
MENU_OPTION_8="Auto Recon"
MENU_OPTION_9="Final Report"
MENU_OPTION_0="Exit"
MENU_PROMPT="Select an option: "
MENU_INVALID="Invalid option. Please choose a number from the menu."
MENU_GOODBYE="Goodbye."
PROMPT_CONTINUE="Press Enter to continue..."
LANGUAGE_SELECT_TITLE="Select language / Seleccione idioma"
LANGUAGE_OPTION_EN="1) English"
LANGUAGE_OPTION_ES="2) Español"
LANGUAGE_PROMPT="Choice / Opción: "
LANGUAGE_SAVED_EN="Language saved: English"
LANGUAGE_SAVED_ES="Idioma guardado: Español"
LANGUAGE_INVALID="Invalid selection. Defaulting to English."
LANGUAGE_CHANGED_PREFIX="Language changed to"
LANGUAGE_UNSUPPORTED="Unsupported language. Use: en or es."
HELP_UNAVAILABLE="Supported help topics: enum, privesc, cron, perms, reverse, upgrade, auto, creds, transfer"
LEARN_UNSUPPORTED="Supported topics: suid, sudo, reverse-shell, tty, container"
HINT_UNSUPPORTED="Supported hint topics: suid, sudo, path"
MODULE_NOT_FOUND="Module not found:"
MODULE_NOT_AVAILABLE="Module not available in this build:"
MODULE_EXEC_FAILED="Module execution failed:"
CREDS_RESERVED="The credential review module is reserved for a future release."
TRANSFER_RESERVED="The transfer reference module is reserved for a future release."
TXT_REVERSE_HEADER="Reverse Shell Generator"
TXT_REVERSE_IP_PROMPT="Attacker IP: "
TXT_REVERSE_PORT_PROMPT="Port: "
TXT_REVERSE_REQUIRED="IP and port are required."
TXT_REVERSE_REPORT="Reverse shell payloads generated for"
TXT_UPGRADE_HEADER="Upgrade Shell / TTY Stabilization"
TXT_UPGRADE_COMMAND_LABEL="Command:"
TXT_UPGRADE_WHAT_IT_DOES="What it does:"
TXT_UPGRADE_REPORT="TTY stabilization guidance was displayed."
TXT_AUTO_HEADER="Auto Recon"
TXT_AUTO_WARNING="Auto Recon runs safe auditing checks only."
TXT_AUTO_RUN_ENUM="Running system enumeration module..."
TXT_AUTO_RUN_PRIVESC="Running privilege escalation review module..."
TXT_AUTO_RUN_CRON="Running cron review module..."
TXT_AUTO_RUN_PERMS="Running permission review module..."
TXT_AUTO_RUN_SERVICES="Running services review module..."
TXT_AUTO_FAIL_ENUM="System enumeration failed during Auto Recon."
TXT_AUTO_FAIL_PRIVESC="Privilege escalation review failed during Auto Recon."
TXT_AUTO_FAIL_CRON="Cron review failed during Auto Recon."
TXT_AUTO_FAIL_PERMS="Permission review failed during Auto Recon."
TXT_AUTO_FAIL_SERVICES="Services review failed during Auto Recon."
TXT_AUTO_SUMMARY_HEADER="Auto Recon Summary"
TXT_AUTO_SUMMARY_DONE="Completed safe enumeration, privilege review, cron review, permission review, and services review."
TXT_AUTO_SUMMARY_REPORT="Use the Final Report option from the main menu to review consolidated findings."
TXT_AUTO_REPORT="Auto Recon completed. Review the final report for summarized findings."
TXT_UPGRADE_PYTHON_TITLE="Python PTY spawn"
TXT_UPGRADE_PYTHON_EXPLAIN="Spawns a more interactive pseudo-terminal so shell behavior improves and programs like su or ssh may work better."
TXT_UPGRADE_TERM_TITLE="Set terminal type"
TXT_UPGRADE_TERM_EXPLAIN="Sets a common terminal definition so interactive programs can use colors, clear the screen, and behave more normally."
TXT_UPGRADE_STTY_TITLE="Fix local terminal mode"
TXT_UPGRADE_STTY_EXPLAIN="Puts your local terminal in raw mode and disables local echo, which helps after backgrounding a shell to make it fully interactive."
TXT_UPGRADE_FG_TITLE="Foreground the shell"
TXT_UPGRADE_FG_EXPLAIN="Brings the suspended reverse shell back to the foreground after using Ctrl+Z during stabilization."
TXT_UPGRADE_RESIZE_TITLE="Resize terminal"
TXT_UPGRADE_RESIZE_EXPLAIN="Sets the remote shell size so full-screen tools like vim, nano, or less render correctly."
TXT_ENUM_HEADER="System Enumeration"
TXT_ENUM_STEP_USER="Checking current user..."
TXT_ENUM_USER_LABEL="Current user"
TXT_ENUM_STEP_DETAILS="Checking user and group details..."
TXT_ENUM_DETAILS_LABEL="User and group details"
TXT_ENUM_STEP_OS="Checking OS version..."
TXT_ENUM_OS_LABEL="OS version"
TXT_ENUM_STEP_KERNEL="Checking kernel version..."
TXT_ENUM_KERNEL_LABEL="Kernel version"
TXT_ENUM_STEP_CONTAINER="Checking container context..."
TXT_ENUM_CONTAINER_LABEL="Container detection"
TXT_ENUM_STEP_KERNEL_WARN="Checking kernel advisory warning..."
TXT_ENUM_KERNEL_WARN_LABEL="Kernel review warning"
TXT_ENUM_STEP_SUDO="Checking sudo permissions..."
TXT_ENUM_SUDO_LABEL="Sudo permissions"
TXT_ENUM_STEP_SUID="Searching for SUID binaries..."
TXT_ENUM_SUID_LABEL="SUID binaries"
TXT_ENUM_STEP_CAPS="Checking file capabilities..."
TXT_ENUM_CAPS_LABEL="File capabilities"
TXT_ENUM_DONE="Enumeration completed."
TXT_ENUM_SUDO_REVIEW="Sudo permissions require review."
TXT_ENUM_SUID_REVIEW="SUID binaries were found and should be reviewed."
TXT_ENUM_CAPS_REVIEW="File capabilities were found and should be reviewed."
TXT_PRIVESC_HEADER="Privilege Escalation Analysis"
TXT_PRIVESC_STEP_SUDO="Reviewing sudo policy exposure..."
TXT_PRIVESC_STEP_SUID="Reviewing SUID surface..."
TXT_PRIVESC_STEP_PATH="Reviewing writable directories in PATH..."
TXT_PRIVESC_WHY="Why this matters:"
TXT_PRIVESC_GUIDANCE="Review guidance:"
TXT_PRIVESC_NO_SUDO="sudo is not installed"
TXT_PRIVESC_NO_SUDO_WHY="Without sudo, sudo policy review is not applicable on this host."
TXT_PRIVESC_SUDO_DENIED="sudo -l requires a password or access is denied"
TXT_PRIVESC_SUDO_DENIED_WHY="You cannot inspect delegated sudo permissions from the current session without further authorized access."
TXT_PRIVESC_SUDO_DENIED_GUIDANCE="Review sudo policy with an authorized shell."
TXT_PRIVESC_SUDO_FOUND="sudo permissions detected"
TXT_PRIVESC_SUDO_FOUND_WHY="Delegated sudo commands deserve review because they may expand what an authenticated user is allowed to do."
TXT_PRIVESC_SUDO_FOUND_GUIDANCE="Review the allowed command list and validate least privilege."
TXT_PRIVESC_SUDO_REPORT="Sudo permissions were detected and should be reviewed."
TXT_PRIVESC_SUID_FOUND="SUID binary found"
TXT_PRIVESC_SUID_WHY_A="SUID binaries run with the owner's privileges and should be reviewed carefully when present."
TXT_PRIVESC_SUID_WHY_B="SUID binaries are noteworthy because they expand privilege boundaries and deserve validation."
TXT_PRIVESC_SUID_REF="Reference available in GTFOBins data"
TXT_PRIVESC_SUID_SEARCH="Search public defensive references for"
TXT_PRIVESC_NO_SUID="No SUID binaries found"
TXT_PRIVESC_NO_SUID_WHY="That removes one very common Linux privilege escalation path."
TXT_PRIVESC_PATH_FOUND="Writable directory in PATH"
TXT_PRIVESC_PATH_WHY="A writable directory in PATH can weaken trust boundaries if privileged automation resolves commands from that location."
TXT_PRIVESC_PATH_GUIDANCE="Review PATH order and restrict write permissions."
TXT_PRIVESC_NO_PATH="No writable directories found in PATH"
TXT_PRIVESC_NO_PATH_WHY="That reduces the chance of simple PATH hijacking attacks."
HELP_GENERAL=$(cat <<'EOF'
Kr1pt0n - Ethical Hacking Toolkit

Kr1pt0n is a Linux enumeration and privilege escalation helper
designed for beginner penetration testers and CTF players.

The tool automates common tasks but also explains why findings
may require security review.

USAGE:

./kr1pt0n.sh [OPTION]

OPTIONS:

--menu
Start interactive mode.

--enum
Run system enumeration. This scans the system for useful
information such as OS version, kernel version, user privileges,
SUID binaries, sudo permissions and possible attack vectors.

--privesc
Analyze privilege escalation opportunities. The tool checks
misconfigurations such as sudo rules, SUID binaries and writable
directories. It explains why each finding matters.

--reverse
Generate reverse shell payloads. The user provides an IP address
and port and the tool generates common payloads used during
penetration testing.

--upgrade
Display commands used to upgrade a basic reverse shell to a fully
interactive TTY shell.

--creds
Reserved for a future credential review module.

--transfer
Reserved for a future file transfer reference module.

--auto
Run automatic reconnaissance mode. This performs enumeration and
privilege review, cron review, and permission review automatically.

--module [name]
Run a specific module through the CLI router.

Examples:

./kr1pt0n.sh --module cron
./kr1pt0n.sh --module perms --quick

--quick
Enable compact output mode and display only the most relevant findings.

--no-animation
Disable the animated banner and show the static banner only.

--lang [en|es]
Change the interface language.

--learn [topic]
Learning mode. Explains important penetration testing concepts.

Examples:

./kr1pt0n.sh --learn suid
./kr1pt0n.sh --learn sudo
./kr1pt0n.sh --learn reverse-shell

--hint [topic]
Show CTF-style hints without revealing full solutions.

--help
Display this help message.

--help [module]
Display detailed help for a specific module.

LEARNING TOPICS:

suid
Explains what SUID binaries are and why they may affect privilege boundaries.

sudo
Explains how misconfigured sudo permissions can allow unsafe delegated actions.

reverse-shell
Explains what reverse shells are and why they are commonly discussed in labs.

tty
Explains why shells may need to be upgraded to interactive TTY sessions.
EOF
)
HELP_ENUM=$(cat <<'EOF'
Enumeration Module

This module gathers system information useful for privilege review.

Checks performed:

- OS version
- Kernel version
- Current user
- Sudo permissions
- SUID binaries
- Capabilities
- Container detection

The goal is to identify possible attack vectors and defensive review points.
EOF
)
HELP_PRIVESC=$(cat <<'EOF'
Privilege Escalation Analysis Module

This module reviews common local privilege escalation indicators.

Checks performed:

- sudo policy exposure
- SUID binaries
- Writable directories in PATH

The goal is to explain why a finding matters and what should be reviewed.
EOF
)
HELP_CRON=$(cat <<'EOF'
Cron Review Module

This module reviews scheduled tasks that may expose local privilege escalation vectors.

Checks performed:

- /etc/crontab
- /etc/cron.d
- /var/spool/cron
- writable referenced scripts
- writable directories in cron paths

The goal is to highlight scheduled-task findings that deserve manual review.
EOF
)
HELP_PERMS=$(cat <<'EOF'
Permission Review Module

This module searches for insecure filesystem permissions that may weaken local security boundaries.

Checks performed:

- world-writable files
- world-writable directories
- writable files owned by root
- suspicious writable scripts

The goal is to surface permission findings that may support local privilege escalation.
EOF
)
HELP_SERVICES=$(cat <<'EOF'
Services Review Module

This module reviews listening ports and active services that may deserve local security review.

Checks performed:

- listening TCP and UDP ports
- active services through ss or netstat
- exposed local service surface

The goal is to highlight service exposure that may change attack paths or local review priorities.
EOF
)
HELP_REVERSE=$(cat <<'EOF'
Reverse Shell Generator Module

This module generates common payload strings after you provide an IP address
and port.

Current payload families:

- bash
- python
- netcat

The goal is to provide quick operator reference output.
EOF
)
HELP_UPGRADE=$(cat <<'EOF'
Upgrade Shell Module

This module shows common commands used to stabilize a basic shell.

Topics covered:

- Python PTY spawn
- TERM setup
- stty raw -echo
- fg
- terminal resize

The goal is to explain how interactive shell quality can be improved.
EOF
)
HELP_AUTO=$(cat <<'EOF'
Auto Recon Module

This module runs the safe audit workflow automatically.

It currently runs:

- system enumeration
- privilege review
- cron review
- permission review
- services review

The goal is to quickly produce a consolidated report of findings.
EOF
)
HELP_CREDS=$(cat <<'EOF'
Credential Review Module

This module is reserved for a future release.

It is not implemented in the current build.
EOF
)
HELP_TRANSFER=$(cat <<'EOF'
Transfer Reference Module

This module is reserved for a future release.

It is not implemented in the current build.
EOF
)

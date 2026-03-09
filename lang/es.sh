#!/bin/bash

LANG_CODE="es"
TOOL_INTRO_TITLE="Kr1pt0n Herramienta de Hacking Ético"
TOOL_INTRO_SUBTITLE="Solo para educación y pruebas autorizadas de seguridad."
BANNER_TITLE="Kr1pt0n - Herramienta de Hacking Ético"
BANNER_WARNING="Usa esta herramienta solo en sistemas tuyos o con permiso explícito."
BANNER_SESSION_LOG="Log de sesión:"
MENU_OPTION_1="Enumeración del sistema"
MENU_OPTION_2="Análisis de escalada de privilegios"
MENU_OPTION_3="Revisión de cron"
MENU_OPTION_4="Revisión de permisos"
MENU_OPTION_5="Revisión de servicios"
MENU_OPTION_6="Generador de Reverse Shell"
MENU_OPTION_7="Mejorar Shell"
MENU_OPTION_8="Auto Recon"
MENU_OPTION_9="Reporte final"
MENU_OPTION_0="Salir"
MENU_PROMPT="Selecciona una opción: "
MENU_INVALID="Opción inválida. Elegí un número del menú."
MENU_GOODBYE="Hasta luego."
PROMPT_CONTINUE="Presiona Enter para continuar..."
LANGUAGE_SELECT_TITLE="Select language / Seleccione idioma"
LANGUAGE_OPTION_EN="1) English"
LANGUAGE_OPTION_ES="2) Español"
LANGUAGE_PROMPT="Choice / Opción: "
LANGUAGE_SAVED_EN="Language saved: English"
LANGUAGE_SAVED_ES="Idioma guardado: Español"
LANGUAGE_INVALID="Selección inválida. Se usará inglés por defecto."
LANGUAGE_CHANGED_PREFIX="Idioma cambiado a"
LANGUAGE_UNSUPPORTED="Idioma no soportado. Usa: en o es."
HELP_UNAVAILABLE="Temas de ayuda soportados: enum, privesc, cron, perms, reverse, upgrade, auto, creds, transfer"
LEARN_UNSUPPORTED="Temas soportados: suid, sudo, reverse-shell, tty, container"
HINT_UNSUPPORTED="Temas de hint soportados: suid, sudo, path"
MODULE_NOT_FOUND="Módulo no encontrado:"
MODULE_NOT_AVAILABLE="Módulo no disponible en esta versión:"
MODULE_EXEC_FAILED="Falló la ejecución del módulo:"
CREDS_RESERVED="El módulo de credenciales queda reservado para una versión futura."
TRANSFER_RESERVED="El módulo de transferencia queda reservado para una versión futura."
TXT_REVERSE_HEADER="Generador de Reverse Shell"
TXT_REVERSE_IP_PROMPT="IP atacante: "
TXT_REVERSE_PORT_PROMPT="Puerto: "
TXT_REVERSE_REQUIRED="La IP y el puerto son obligatorios."
TXT_REVERSE_REPORT="Payloads de reverse shell generados para"
TXT_UPGRADE_HEADER="Mejorar Shell / Estabilización TTY"
TXT_UPGRADE_COMMAND_LABEL="Comando:"
TXT_UPGRADE_WHAT_IT_DOES="Qué hace:"
TXT_UPGRADE_REPORT="Se mostró la guía de estabilización TTY."
TXT_AUTO_HEADER="Auto Recon"
TXT_AUTO_WARNING="Auto Recon ejecuta solo comprobaciones seguras de auditoría."
TXT_AUTO_RUN_ENUM="Ejecutando módulo de enumeración del sistema..."
TXT_AUTO_RUN_PRIVESC="Ejecutando módulo de revisión de escalada de privilegios..."
TXT_AUTO_RUN_CRON="Ejecutando módulo de revisión de cron..."
TXT_AUTO_RUN_PERMS="Ejecutando módulo de revisión de permisos..."
TXT_AUTO_RUN_SERVICES="Ejecutando módulo de revisión de servicios..."
TXT_AUTO_FAIL_ENUM="La enumeración del sistema falló durante Auto Recon."
TXT_AUTO_FAIL_PRIVESC="La revisión de privilegios falló durante Auto Recon."
TXT_AUTO_FAIL_CRON="La revisión de cron falló durante Auto Recon."
TXT_AUTO_FAIL_PERMS="La revisión de permisos falló durante Auto Recon."
TXT_AUTO_FAIL_SERVICES="La revisión de servicios falló durante Auto Recon."
TXT_AUTO_SUMMARY_HEADER="Resumen de Auto Recon"
TXT_AUTO_SUMMARY_DONE="Se completaron la enumeración segura, la revisión de privilegios, la revisión de cron, la revisión de permisos y la revisión de servicios."
TXT_AUTO_SUMMARY_REPORT="Usa la opción Final Report del menú principal para revisar los hallazgos consolidados."
TXT_AUTO_REPORT="Auto Recon finalizado. Revisa el reporte final para ver el resumen de hallazgos."
TXT_UPGRADE_PYTHON_TITLE="Python PTY spawn"
TXT_UPGRADE_PYTHON_EXPLAIN="Genera un pseudo-terminal más interactivo para mejorar el comportamiento de la shell y permitir que programas como su o ssh funcionen mejor."
TXT_UPGRADE_TERM_TITLE="Configurar tipo de terminal"
TXT_UPGRADE_TERM_EXPLAIN="Define un terminal común para que los programas interactivos puedan usar colores, limpiar la pantalla y comportarse de forma más normal."
TXT_UPGRADE_STTY_TITLE="Corregir modo del terminal local"
TXT_UPGRADE_STTY_EXPLAIN="Pone tu terminal local en modo raw y desactiva el eco local, lo que ayuda a hacer totalmente interactiva la shell después de enviarla al background."
TXT_UPGRADE_FG_TITLE="Traer la shell al foreground"
TXT_UPGRADE_FG_EXPLAIN="Devuelve la reverse shell suspendida al primer plano después de usar Ctrl+Z durante la estabilización."
TXT_UPGRADE_RESIZE_TITLE="Redimensionar terminal"
TXT_UPGRADE_RESIZE_EXPLAIN="Ajusta el tamaño de la shell remota para que herramientas de pantalla completa como vim, nano o less se rendericen correctamente."
TXT_ENUM_HEADER="Enumeración del sistema"
TXT_ENUM_STEP_USER="Comprobando usuario actual..."
TXT_ENUM_USER_LABEL="Usuario actual"
TXT_ENUM_STEP_DETAILS="Comprobando usuario y grupos..."
TXT_ENUM_DETAILS_LABEL="Detalles de usuario y grupos"
TXT_ENUM_STEP_OS="Comprobando versión del sistema operativo..."
TXT_ENUM_OS_LABEL="Versión del sistema operativo"
TXT_ENUM_STEP_KERNEL="Comprobando versión del kernel..."
TXT_ENUM_KERNEL_LABEL="Versión del kernel"
TXT_ENUM_STEP_CONTAINER="Comprobando contexto de contenedor..."
TXT_ENUM_CONTAINER_LABEL="Detección de contenedor"
TXT_ENUM_STEP_KERNEL_WARN="Comprobando advertencias del kernel..."
TXT_ENUM_KERNEL_WARN_LABEL="Advertencia de revisión del kernel"
TXT_ENUM_STEP_SUDO="Comprobando permisos sudo..."
TXT_ENUM_SUDO_LABEL="Permisos sudo"
TXT_ENUM_STEP_SUID="Buscando binarios SUID..."
TXT_ENUM_SUID_LABEL="Binarios SUID"
TXT_ENUM_STEP_CAPS="Comprobando capabilities de archivos..."
TXT_ENUM_CAPS_LABEL="Capabilities de archivos"
TXT_ENUM_DONE="Enumeración completada."
TXT_ENUM_SUDO_REVIEW="Los permisos sudo requieren revisión."
TXT_ENUM_SUID_REVIEW="Se encontraron binarios SUID que deberían revisarse."
TXT_ENUM_CAPS_REVIEW="Se encontraron capabilities de archivos que deberían revisarse."
TXT_PRIVESC_HEADER="Análisis de Escalada de Privilegios"
TXT_PRIVESC_STEP_SUDO="Revisando exposición de políticas sudo..."
TXT_PRIVESC_STEP_SUID="Revisando superficie SUID..."
TXT_PRIVESC_STEP_PATH="Revisando directorios escribibles en PATH..."
TXT_PRIVESC_WHY="Por qué importa:"
TXT_PRIVESC_GUIDANCE="Guía de revisión:"
TXT_PRIVESC_NO_SUDO="sudo no está instalado"
TXT_PRIVESC_NO_SUDO_WHY="Sin sudo, la revisión de políticas sudo no aplica en este host."
TXT_PRIVESC_SUDO_DENIED="sudo -l requiere contraseña o el acceso fue denegado"
TXT_PRIVESC_SUDO_DENIED_WHY="No puedes inspeccionar permisos delegados de sudo desde la sesión actual sin acceso autorizado adicional."
TXT_PRIVESC_SUDO_DENIED_GUIDANCE="Revisa la política sudo con una shell autorizada."
TXT_PRIVESC_SUDO_FOUND="se detectaron permisos sudo"
TXT_PRIVESC_SUDO_FOUND_WHY="Los comandos delegados por sudo merecen revisión porque pueden ampliar lo que un usuario autenticado puede hacer."
TXT_PRIVESC_SUDO_FOUND_GUIDANCE="Revisa la lista de comandos permitidos y valida mínimo privilegio."
TXT_PRIVESC_SUDO_REPORT="Se detectaron permisos sudo y deberían revisarse."
TXT_PRIVESC_SUID_FOUND="Binario SUID encontrado"
TXT_PRIVESC_SUID_WHY_A="Los binarios SUID se ejecutan con los privilegios del propietario y deben revisarse cuidadosamente cuando están presentes."
TXT_PRIVESC_SUID_WHY_B="Los binarios SUID son relevantes porque amplían límites de privilegio y merecen validación."
TXT_PRIVESC_SUID_REF="Referencia disponible en los datos de GTFOBins"
TXT_PRIVESC_SUID_SEARCH="Busca referencias defensivas públicas para"
TXT_PRIVESC_NO_SUID="No se encontraron binarios SUID"
TXT_PRIVESC_NO_SUID_WHY="Eso elimina una vía muy común de escalada local de privilegios."
TXT_PRIVESC_PATH_FOUND="Directorio escribible en PATH"
TXT_PRIVESC_PATH_WHY="Un directorio escribible en PATH puede debilitar los límites de confianza si automatizaciones privilegiadas resuelven comandos desde esa ubicación."
TXT_PRIVESC_PATH_GUIDANCE="Revisa el orden de PATH y restringe permisos de escritura."
TXT_PRIVESC_NO_PATH="No se encontraron directorios escribibles en PATH"
TXT_PRIVESC_NO_PATH_WHY="Eso reduce la posibilidad de ataques simples de PATH hijacking."
HELP_GENERAL=$(cat <<'EOF'
Kr1pt0n - Herramienta de Hacking Ético

Kr1pt0n es una utilidad de enumeración Linux y apoyo para revisión de
escalada de privilegios, pensada para principiantes en pentesting y CTF.

La herramienta automatiza tareas comunes y también explica por qué los
hallazgos pueden requerir revisión de seguridad.

USO:

./kr1pt0n.sh [OPCIÓN]

OPCIONES:

--menu
Inicia el modo interactivo.

--enum
Ejecuta la enumeración del sistema. Escanea información útil como versión
 del sistema operativo, kernel, privilegios del usuario, binarios SUID,
 permisos sudo y posibles vectores de ataque.

--privesc
Analiza oportunidades de escalada de privilegios. La herramienta revisa
 configuraciones riesgosas como reglas sudo, binarios SUID y directorios
 escribibles en PATH. Explica por qué importa cada hallazgo.

--reverse
Genera payloads de reverse shell. El usuario indica IP y puerto y la
 herramienta genera payloads comunes usados en pentesting.

--upgrade
Muestra comandos usados para mejorar una shell básica a una TTY
 interactiva.

--creds
Reservado para un futuro módulo de revisión de credenciales.

--transfer
Reservado para un futuro módulo de referencia de transferencia de archivos.

--auto
Ejecuta el modo automático de reconocimiento. Realiza enumeración y
revisión de privilegios, revisión de cron y revisión de permisos automáticamente.

--module [nombre]
Ejecuta un módulo específico desde el router CLI.

Ejemplos:

./kr1pt0n.sh --module cron
./kr1pt0n.sh --module perms --quick

--quick
Activa salida compacta y muestra solo los hallazgos más relevantes.

--no-animation
Desactiva el banner animado y muestra solo el banner estático.

--lang [en|es]
Cambia el idioma de la interfaz.

--learn [tema]
Modo aprendizaje. Explica conceptos importantes de pentesting.

Ejemplos:

./kr1pt0n.sh --learn suid
./kr1pt0n.sh --learn sudo
./kr1pt0n.sh --learn reverse-shell

--hint [tema]
Muestra pistas estilo CTF sin revelar soluciones completas.

--help
Muestra esta ayuda.

--help [módulo]
Muestra ayuda detallada para un módulo específico.

TEMAS DE APRENDIZAJE:

suid
Explica qué son los binarios SUID y por qué pueden afectar los límites de privilegio.

sudo
Explica cómo permisos sudo mal configurados pueden permitir acciones delegadas inseguras.

reverse-shell
Explica qué es una reverse shell y por qué se estudia en labs.

tty
Explica por qué algunas shells necesitan mejorarse a sesiones TTY interactivas.
EOF
)
HELP_ENUM=$(cat <<'EOF'
Módulo de Enumeración

Este módulo recopila información del sistema útil para revisión de privilegios.

Comprobaciones realizadas:

- Versión del sistema operativo
- Versión del kernel
- Usuario actual
- Permisos sudo
- Binarios SUID
- Capabilities
- Detección de contenedores

El objetivo es identificar posibles vectores y puntos de revisión defensiva.
EOF
)
HELP_PRIVESC=$(cat <<'EOF'
Módulo de Análisis de Escalada de Privilegios

Este módulo revisa indicadores comunes de escalada local de privilegios.

Comprobaciones realizadas:

- Exposición de políticas sudo
- Binarios SUID
- Directorios escribibles en PATH

El objetivo es explicar por qué importa cada hallazgo y qué debería revisarse.
EOF
)
HELP_CRON=$(cat <<'EOF'
Módulo de Revisión de Cron

Este módulo revisa tareas programadas que pueden exponer vectores de escalada local de privilegios.

Comprobaciones realizadas:

- /etc/crontab
- /etc/cron.d
- /var/spool/cron
- scripts referenciados y escribibles
- directorios escribibles en rutas de cron

El objetivo es resaltar hallazgos de tareas programadas que requieren revisión manual.
EOF
)
HELP_PERMS=$(cat <<'EOF'
Módulo de Revisión de Permisos

Este módulo busca permisos inseguros en el sistema de archivos que pueden debilitar los límites de seguridad locales.

Comprobaciones realizadas:

- archivos world-writable
- directorios world-writable
- archivos escribibles propiedad de root
- scripts escribibles sospechosos

El objetivo es mostrar hallazgos de permisos que podrían apoyar escalada local de privilegios.
EOF
)
HELP_SERVICES=$(cat <<'EOF'
Módulo de Revisión de Servicios

Este módulo revisa puertos en escucha y servicios activos que pueden merecer revisión de seguridad local.

Comprobaciones realizadas:

- puertos TCP y UDP en escucha
- servicios activos a través de ss o netstat
- superficie local expuesta por servicios

El objetivo es resaltar exposición de servicios que puede cambiar vectores o prioridades de revisión local.
EOF
)
HELP_REVERSE=$(cat <<'EOF'
Módulo Generador de Reverse Shell

Este módulo genera cadenas de payload después de indicar una IP y un puerto.

Familias de payload actuales:

- bash
- python
- netcat

El objetivo es ofrecer una referencia rápida para el operador.
EOF
)
HELP_UPGRADE=$(cat <<'EOF'
Módulo de Mejora de Shell

Este módulo muestra comandos comunes para estabilizar una shell básica.

Temas cubiertos:

- Python PTY spawn
- Configuración de TERM
- stty raw -echo
- fg
- cambio de tamaño del terminal

El objetivo es explicar cómo mejorar la calidad interactiva de una shell.
EOF
)
HELP_AUTO=$(cat <<'EOF'
Módulo Auto Recon

Este módulo ejecuta automáticamente el flujo seguro de auditoría.

Actualmente ejecuta:

- enumeración del sistema
- revisión de privilegios
- revisión de cron
- revisión de permisos
- revisión de servicios

El objetivo es producir rápidamente un reporte consolidado de hallazgos.
EOF
)
HELP_CREDS=$(cat <<'EOF'
Módulo de Revisión de Credenciales

Este módulo queda reservado para una futura versión.

No está implementado en la build actual.
EOF
)
HELP_TRANSFER=$(cat <<'EOF'
Módulo de Referencia de Transferencia

Este módulo queda reservado para una futura versión.

No está implementado en la build actual.
EOF
)

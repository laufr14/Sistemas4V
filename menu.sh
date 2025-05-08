#!/bin/bash
# Redirige stderr a /dev/null para ocultar los errores de MESA
exec 2>/dev/null

while true; do
    opcion=$(zenity --list --title="👤 Administración de Usuarios" \
        --column="Opción" --column="Descripción" \
        1 "Crear usuario" \
        2 "Dar de baja a un usuario" \
        3 "Enviar informe por correo" \
        4 "Salir" \
        --width=500 --height=300)

# Si se cancela, se guarda un estado de salida distinto
if [[ $? -ne 0 ]]; then
    opcion=4
fi

 case $opcion in
        1) ./crear_usuario.sh ;;
        2) ./baja_usuario.sh ;;
        3) ./enviar_correo.sh ;;
        4) exit 0 ;;
        *) zenity --error --text="❌ Opción no válida." ;;
    esac
done


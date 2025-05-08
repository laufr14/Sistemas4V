#!/bin/bash

# Pedir el correo destino con Zenity
EMAIL_DESTINO=$(zenity --entry --title="Enviar Informe" --text="Introduce el correo destinatario:" --entry-text="sergio4vientos@gmail.com")

# Si el usuario cancela, salir del script
if [[ -z "$EMAIL_DESTINO" ]]; then
    zenity --error --title="Error" --text="No se ingresó un correo. Saliendo..."
    exit 1
fi

# Obtener el usuario desde una lista de usuarios disponibles en el sistema
USUARIO=$(zenity --list --title="Seleccionar Usuario" --column="Usuarios" $(awk -F':' '{ print $1 }' /etc/passwd))

# Si el usuario cancela, salir
if [[ -z "$USUARIO" ]]; then
    zenity --error --title="Error" --text="No se seleccionó ningún usuario. Saliendo..."
    exit 1
fi

# Obtener datos del usuario seleccionado
ULTIMO_LOGIN=$(last -n 1 $USUARIO | head -n 1)
USO_DISCO=$(du -sh /home/$USUARIO 2>/dev/null | awk '{print $1}')
PROCESOS=$(ps -u $USUARIO --no-headers | wc -l)

# Crear el informe
INFORME="/tmp/informe_usuario_$USUARIO.txt"

echo "Informe de Usuario: $USUARIO" > $INFORME
echo "---------------------------------" >> $INFORME
echo "Último inicio de sesión: $ULTIMO_LOGIN" >> $INFORME
echo "Uso de disco en /home/$USUARIO: $USO_DISCO" >> $INFORME
echo "Número de procesos activos: $PROCESOS" >> $INFORME

# Confirmación antes de enviar
zenity --question --title="Confirmar Envío" --text="¿Enviar el informe de $USUARIO a $EMAIL_DESTINO?" --ok-label="Sí" --cancel-label="No"

if [[ $? -ne 0 ]]; then
    zenity --info --title="Cancelado" --text="El informe no fue enviado."
    rm -f $INFORME
    exit 1
fi

# Enviar el informe por correo
mail -s "Informe de usuario: $USUARIO" $EMAIL_DESTINO < $INFORME

# Limpiar archivo temporal
rm -f $INFORME

# Mostrar mensaje de éxito
zenity --info --title="Informe Enviado" --text="El informe de $USUARIO ha sido enviado a $EMAIL_DESTINO."
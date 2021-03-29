#! /bin/bash
# Programa usado para conectar automaticamente dispositivo bluetooth

address="DC:2C:26:E8:56:EF"

while (sleep 1)
do
  # Lista dispositivo pareado
  connected = `bluetoothctl paired-devices` > /dev/null
  # Se o dispositivo nao estiver conectado
if [[ ! $connected =~ .*${address}.* ]] ; then
  # Conecta o Dispositivo
  bluetoothctl connect ${address} > /dev/null 2>&1
fi
done

# Auto-conectar dispositivos bluetooth

Um tutorial/script para automaticamente conectar dispositivos ao iniciar o sistema.

Primeiro podemos procurar pelo o endereço bluetooth nas configurações * Configurações > Bluetooth* e quando clicar no dispositivo, aparecerá a seguinte janela:

<p align="center">
  <img width="300" src=" https://raw.githubusercontent.com/Arthurcn96/Bluetooth-Auto-Connect/master/data/Bluetooth.png ">
</p>

*No exemplo um teclado bluetooth*

E entao podemos copiar o endereço do dispositivo. Mas teremos outras oportunidades pra fazer isso depois.


## Primeiro Vamos Instalar Todos os Pacotes Necessários
Instalar esses pacotes vai prevenir qualquer erro que venha acontecer. Possibilitando a conexão de um dispositivo Bluetooth pela linha de comando:

  **Debian/Ubuntu**

    `sudo apt-get -y install bluetooth bluez bluez-tools rfkill`

## Desconecte Todos os Dispositivos Bluetooth
Para isso simplesmente abra o terminal e digiteÇ

    `killall bluetooth-applet
    sudo /etc/init.d/bluetooth restart
    sudo hcitool dev
    `

Agora vamos para a parte da conexão automatica do dispositivo.

O ultimo comando deve retornar uma mensagem do tipoÇ

    `Devices:
        hci0    AA:BB:CC:DD:FF`

Esse deve ser o mesmo código da janela no primeiro passo desse tutorial, é o código do dispositivo, e o que será usado para fazer a conexão automática.

## Pareando, confiando e Conectando ao dispositivo

Agora você deve usar o endereço MAC copiado nos últimos passos para essa próxima etapa, e tem que mantar o dispositivo em modo de parear/conectar e então seguir o comando mostrado abaixo

    `hictool scan`

Se o seu dispositivo estiver aparecendo na rede bluetooth, o terminal deve retornar algo como:

    `Scanning . . .
        AA:BB:CC:DD:FF Nome do dispositivo`

Então você deve seguir substituindo o AA:BB:CC:DD:FF com que foi retornado no seu terminal:

     `bluetoothctl pair AA:BB:CC:DD:FF
      bluetoothctl trust AA:BB:CC:DD:FF
      bluetoothctl connect AA:BB:CC:DD:FF
      `
Agora seu dispositivo já deve estar conectado. Agora para automatizar esse processo, seguimos para o próximo passo.

## Automatizando o processo

Agora precisamos criar um arquivo de inicialização, um arquivo que sempre roda quando seu computador é iniciado, e então ele irá conectar automaticamente seu dispositivo.
No terminal:

    `gedit ~/.keyboard.sh`
*gedit é um editor de texto. Caso desejar pode mudar o comando para outro editor*

Lembrando que pode mudar o nome **keyboard** por qualquer dispositivo que esteja conectando

Agora digite o código seguinte no seu editor, mas sem esquecer de substituir o AA:BB:CC:DD:FF pelo ID que digitou a alguns passo atrás. E por fim salve o arquivo:

  ```
      #! /bin/bash
      # This program is used to auto connect a bluetooth device

      address="AA:BB:CC:DD:EE:FF"

      while (sleep 1)
      do
       connected=`bluetoothctl paired-devices` > /dev/null
      if [[ ! $connected =~ .*${address}.* ]] ; then
       bluetoothctl connect ${address} > /dev/null 2>&1
      fi
      done
  ```

Agora para criar um arquivo de inicialização rodar o seguinte código

    `sudo gedit /etc/init.d/keyboard`

Aqui também **podemos mudar o nome do arquivo** pelo dispositivo que estamos conectando ao computador. Dentro deste arquivo, devemos digitar o seguinte código. Lembrando mais uma vez de usar o mesmo nome que usamos no primeiro comando com o arquivo *.sh*

      ```
        #!/bin/sh
        /home/username/.keyboard.sh &

        exit 0
      ```
## Dando as permissões necessárias aos scripts

Podemos dar a ambos as permissões executando o seguinte comando no terminal:

      ```
        sudo chmod +x /etc/init.d/keyboard
        chmod +x ~/.keyboard.sh
        sudo update-rc.d keyboard defaults
      ```

Reinicie o seu computador e ele deve conectar o seu dispositivo bluetooth automaticamente sem que seja necessário fazer nada.


Fonte: [Aqui](https://ubuntuforums.org/showthread.php?t=1643386&highlight=bluetooth) e [aqui](https://askubuntu.com/questions/17504/how-can-i-have-a-bluetooth-keyboard-auto-connect-at-startup)

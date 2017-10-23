BAIXAR ARQUIVO
    wget  https://downloads.sourceforge.net/project/pentaho/Data%20Integration/7.0/pdi-ce-7.0.0.0-25.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fpentaho%2Ffiles%2FData%2520Integration%2F7.0%2F&ts=1502382494&use_mirror=ufpr

DESCOMPACTAR
    unzip pdi-ce-7.0.0.0-25.zip

RENOMEAR PASTA
    mv pdi-ce-7.0.0.0-25 pdi

CRIAR DIRETORIO
    /opt/pentaho

MOVER PDI
    mv pdi /opt/pentaho

SE DESEJADO, ALTERAR PERMISSÕES DE PASTAS E ARQUIVOS

INSERIR UMA VARIAVEL GERAL DE SISTEMA (vi /etc/environment)
    INSERIR LINHA ABAIXO
        KETTLE_HOME=/opt/pentaho/pdi

CARREGUE VARIAVEL
    export KETTLE_HOME=/opt/pentaho/pdi

EXECUTE UM TESTE PARA QUE SEJA CRIADO DIRETORIO /opt/pentaho/pdi/.kettle/
        /opt/pentaho/pdi/data-integration/kitchen.sh -listrep

CRIE O DIRETORIO /datacenter/www/longevo.com.br/pentaho
    mkdir /datacenter/www/longevo.com.br/pentaho

CARREGUE O REPOSITORIO EM /datacenter/www/longevo.com.br/pentaho
    /datacenter/www/longevo.com.br/pentaho/current/dev

COPIE CONFIGURAÇÕES DO REPOSITORIO
    cp /datacenter/www/longevo.com.br/pentaho/current/dev/kettle/*.* /opt/pentaho/pdi/.kettle/

CONECTE NO BANCO DE DADOS DE CONTROLE E DE LOG E EXECUTE O SCRIPT
    /datacenter/www/longevo.com.br/pentaho/current/dev/sql/script_servidor_pentaho_log_controle.sql

SUBA O CARTE COM O COMANDO ABAIXO OU SCRIPT
     /opt/pentaho/pdi/data-integration/carte.sh 172.31.37.163 8081

CASO QUEIRA ALTERAR A SENHA DO CARTE, AJUSTE NO ARQUIVO /opt/pentaho/pdi/data-integration/pwd/kettle.pwd (necessário restart)
    recomento alteração de usuario e senha pois fica exposto (padrão usuario=carte e senha=carte)

OBS.: MAIS INFORMAÇOES DE CONFIGURAÇÕES DO CARTE EM https://help.pentaho.com/Documentation/7.0/0L0/0Y0/060/060
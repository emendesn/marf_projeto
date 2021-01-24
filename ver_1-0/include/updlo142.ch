#ifdef SPANISH
	#define STR0001 "ACTUALIZACION DE DICCIONARIOS Y TABLAS"
	#define STR0002 "Esta rutina tiene como funcion actualizar los diccionarios del Sistema ( SX?/SIX )"
	#define STR0003 "Este proceso debe ejecutarse en modo EXCLUSIVO, es decir no pueden haber otros"
	#define STR0004 "usuarios o jobs utilizando el sistema. ES EXTREMADAMENTE recomendable que se haga un"
	#define STR0005 "COPIA DE SEGURIDAD de los DICCIONARIOS y de la BASE DE DATOS antes de esta actualizacion, para que si "
	#define STR0006 "ocurren eventuales fallas, esta copia de seguridad pueda restaurarse."
	#define STR0007 "Confirma actualizacion de los diccionarios"
	#define STR0008 "Actualizando"
	#define STR0009 "Espere, actualizando ..."
	#define STR0010 "Actualizacion realizada."
	#define STR0011 "Actualizacion no realizada."
	#define STR0012 "Archivos texto"
	#define STR0013 "Actualizacion de la empresa "
	#define STR0014 " no realizada."
	#define STR0015 "LOG DE LA ACTUALIZACION DE LOS DICCIONARIOS"
	#define STR0016 " Datos de entorno"
	#define STR0017 " Empresa / Sucursal...: "
	#define STR0018 " Nombre de empresa.......: "
	#define STR0019 " Nombre de sucursal........: "
	#define STR0020 " Fecha de base......: "
	#define STR0021 " Fecha / Hora inicial: "
	#define STR0022 " Version.............: "
	#define STR0023 " Usuario TOTVS .....: "
	#define STR0024 " Datos Thread"
	#define STR0025 " Usuario de red....: "
	#define STR0026 " Estacion............: "
	#define STR0027 " Programa inicial...: "
	#define STR0028 " Conexion............: "
	#define STR0029 "Empresa: "
	#define STR0030 "Diccionario de parametros"
	#define STR0031 " Fecha/Hora final.: "
	#define STR0032 "Actualizacion concluida."
	#define STR0033 "Inicio de la actualizacion"
	#define STR0034 "Se incluyo el parametro "
	#define STR0035 " Contenido ["
	#define STR0036 "Actualizando archivos (SX6)..."
	#define STR0037 "Final de la actualizacion"
	#define STR0038 "Pantalla para multiple seleccion de Empresas/Sucursales"
	#define STR0039 "Seleccione la(s) empresa(s) para actualizacion"
	#define STR0040 "Empresa"
	#define STR0041 "Todos"
	#define STR0042 "Marca/Desmarca"
	#define STR0043 "Mascara empresa ( ? )"
	#define STR0044 "&Invertir"
	#define STR0045 "Invertir seleccion"
	#define STR0046 "&Marcar"
	#define STR0047 "Marcar usando"
	#define STR0048 "mascara ( ?? )"
	#define STR0049 "&Desmarcar"
	#define STR0050 "Desmarcar usando"
	#define STR0051 "Procesar"
	#define STR0052 "Confirma la seleccion y realiza"
	#define STR0053 "el procesamiento"
	#define STR0054 "Anular"
	#define STR0055 "Anula el procesamiento"
	#define STR0056 "y abandona la inversion"
	#define STR0057 "No fue posible abrir la tabla "
	#define STR0058 "de empresas (SM0)."
	#define STR0059 "de empresas (SM0) de forma exclusiva."
	#define STR0060 "ATENCION"
	#define STR0061 "Tamano maximo de exhibicion del LOG alcanzado."
	#define STR0062 "LOG Completo en el archivo "
#else
	#ifdef ENGLISH
		#define STR0001 "TABLE AND DICTIONARY UPDATE"
		#define STR0002 "Does this routine update system dictionaries ( SX?/SIX )"
		#define STR0003 "This process must be run in EXCLUSIVE mode, that is, other"
		#define STR0004 "users or jobs using the system.  It is STRONGLY advisable to make"
		#define STR0005 "BACKUP of DICTIONARIES and DATABASE before this update "
		#define STR0006 "in order to restore this backup in case of failures."
		#define STR0007 "Confirm dictionary update?"
		#define STR0008 "Updating"
		#define STR0009 "Wait, updating ..."
		#define STR0010 "Update Completed."
		#define STR0011 "Update not Performed."
		#define STR0012 "Text Files"
		#define STR0013 "Company Update "
		#define STR0014 " not made."
		#define STR0015 "DICTIONARY UPDATE LOG"
		#define STR0016 " Environment Data"
		#define STR0017 " Company/Branch...: "
		#define STR0018 " Company Name.......: "
		#define STR0019 " Branch Name........: "
		#define STR0020 " DataBase...........: "
		#define STR0021 " Start Date/Time: "
		#define STR0022 " Version.............: "
		#define STR0023 " TOTVS User .......: "
		#define STR0024 " Thread Data"
		#define STR0025 " Network User....: "
		#define STR0026 " Station............: "
		#define STR0027 " Initial Program...: "
		#define STR0028 " Connection............: "
		#define STR0029 "Company: "
		#define STR0030 "Dictionary of parameters"
		#define STR0031 " End Date/Time: "
		#define STR0032 "Update completed."
		#define STR0033 "Start of Update"
		#define STR0034 "Parameter was added "
		#define STR0035 " Content ["
		#define STR0036 "Updating Files (SX6)..."
		#define STR0037 "End of Update"
		#define STR0038 "Screen for Multiple Selections of Companies/Branches"
		#define STR0039 "Select Companies for Update"
		#define STR0040 "Company"
		#define STR0041 "All"
		#define STR0042 "Select / Clear"
		#define STR0043 "Company Mask (?? )"
		#define STR0044 "&Invert"
		#define STR0045 "Invert Selection"
		#define STR0046 "&Select"
		#define STR0047 "Select using"
		#define STR0048 "mask(?? )"
		#define STR0049 "&Clear"
		#define STR0050 "Clear using"
		#define STR0051 "Process"
		#define STR0052 "Check the selection and make"
		#define STR0053 "the processing"
		#define STR0054 "Cancel"
		#define STR0055 "Cancel processing"
		#define STR0056 "and abandon application"
		#define STR0057 "Table could not be opened "
		#define STR0058 "of companies (SM0)."
		#define STR0059 "of companies (SM0) exclusively."
		#define STR0060 "ATTENTION"
		#define STR0061 "Maximum exhibition size LOG."
		#define STR0062 "Complete LOG on file "
	#else
		#define STR0001 "ATUALIZA��O DE DICION�RIOS E TABELAS"
		#define STR0002 "Esta rotina tem como fun��o fazer  a atualiza��o  dos dicion�rios do Sistema ( SX?/SIX )"
		#define STR0003 "Este processo deve ser executado em modo EXCLUSIVO, ou seja n�o podem haver outros"
		#define STR0004 "usu�rios  ou  jobs utilizando  o sistema.  � EXTREMAMENTE recomendav�l  que  se  fa�a um"
		#define STR0005 "BACKUP  dos DICION�RIOS  e da  BASE DE DADOS antes desta atualiza��o, para que caso "
		#define STR0006 "ocorram eventuais falhas, esse backup possa ser restaurado."
		#define STR0007 "Confirma a atualiza��o dos dicion�rios ?"
		#define STR0008 "Atualizando"
		#define STR0009 "Aguarde, atualizando ..."
		#define STR0010 "Atualiza��o Realizada."
		#define STR0011 "Atualiza��o n�o Realizada."
		#define STR0012 "Arquivos Texto"
		#define STR0013 "Atualiza��o da empresa "
		#define STR0014 " n�o efetuada."
		#define STR0015 "LOG DA ATUALIZA��O DOS DICION�RIOS"
		#define STR0016 " Dados Ambiente"
		#define STR0017 " Empresa / Filial...: "
		#define STR0018 " Nome Empresa.......: "
		#define STR0019 " Nome Filial........: "
		#define STR0020 " DataBase...........: "
		#define STR0021 " Data / Hora �nicio.: "
		#define STR0022 " Vers�o.............: "
		#define STR0023 " Usu�rio TOTVS .....: "
		#define STR0024 " Dados Thread"
		#define STR0025 " Usu�rio da Rede....: "
		#define STR0026 " Esta��o............: "
		#define STR0027 " Programa Inicial...: "
		#define STR0028 " Conex�o............: "
		#define STR0029 "Empresa : "
		#define STR0030 "Dicion�rio de par�metros"
		#define STR0031 " Data / Hora Final.: "
		#define STR0032 "Atualiza��o concluida."
		#define STR0033 "�nicio da Atualiza��o"
		#define STR0034 "Foi inclu�do o par�metro "
		#define STR0035 " Conte�do ["
		#define STR0036 "Atualizando Arquivos (SX6)..."
		#define STR0037 "Final da Atualiza��o"
		#define STR0038 "Tela para M�ltiplas Sele��es de Empresas/Filiais"
		#define STR0039 "Selecione a(s) Empresa(s) para Atualiza��o"
		#define STR0040 "Empresa"
		#define STR0041 "Todos"
		#define STR0042 "Marca / Desmarca"
		#define STR0043 "M�scara Empresa ( ?? )"
		#define STR0044 "&Inverter"
		#define STR0045 "Inverter Sele��o"
		#define STR0046 "&Marcar"
		#define STR0047 "Marcar usando"
		#define STR0048 "m�scara ( ?? )"
		#define STR0049 "&Desmarcar"
		#define STR0050 "Desmarcar usando"
		#define STR0051 "Processar"
		#define STR0052 "Confirma a sele��o e efetua"
		#define STR0053 "o processamento"
		#define STR0054 "Cancelar"
		#define STR0055 "Cancela o processamento"
		#define STR0056 "e abandona a aplica��o"
		#define STR0057 "N�o foi poss�vel a abertura da tabela "
		#define STR0058 "de empresas (SM0)."
		#define STR0059 "de empresas (SM0) de forma exclusiva."
		#define STR0060 "ATEN��O"
		#define STR0061 "Tamanho de exibi��o maxima do LOG alcan�ado."
		#define STR0062 "LOG Completo no arquivo "
	#endif
#endif

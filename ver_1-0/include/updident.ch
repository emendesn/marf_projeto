#ifdef SPANISH
	#define STR0001 "ACTUALIZACI�N DEL TAMA�O DE LOS CAMPOS MSIDENT"
	#define STR0002 "La funci�n de esta rutina es efectuar cambios en el tama�o de los campos Ident.Registro"
	#define STR0003 "(xx_MSIDENT/xxx_MSIDEN), de 8 caracteres a 12."
	#define STR0004 "Las tablas que posean este campo tendr�n su tama�o cambiado."
	#define STR0005 "Efect�e un BACKUP de los DICCIONARIOS y de la BASE DE DATOS antes de esta actualizaci�n, "
	#define STR0006 "por si hubiera alg�n eventual fallo, se podr� recuperar el backup."
	#define STR0007 "Confirma la actualizaci�n de los diccionarios ?"
	#define STR0008 "Actualizando"
	#define STR0009 "Espere, actualizando ..."
	#define STR0010 "Actualizaci�n concluida."
	#define STR0011 "Actualizaci�n no efectuada."
	#define STR0012 "Archivos Texto"
	#define STR0013 "Actualizaci�n de la empresa "
	#define STR0014 " no efectuada."
	#define STR0015 "Empresa : "
	#define STR0016 "Diccionario de par�metros - "
	#define STR0017 "Diccionario de datos - "
	#define STR0018 "Hubo un error desconocido al actualizar la tabla : "
	#define STR0019 ". Aseg�rese de la integridad del diccionario y de la tabla."
	#define STR0020 "ATENCI�N"
	#define STR0021 "Hubo un error desconocido al actualizar la estructura de la tabla : "
	#define STR0022 "LOG DE LA ACTUALIZACI�N DE LOS DICCIONARIOS"
	#define STR0023 " Datos del Entorno"
	#define STR0024 " Empresa / Filial...: "
	#define STR0025 " Nombre Empresa.....: "
	#define STR0027 " Nombre Filial......: "
	#define STR0028 " FechaBase..........: "
	#define STR0029 " Fecha/ Hora Inicio.: "
	#define STR0030 " Versi�n............: "
	#define STR0031 " Usuario TOTVS .....: "
	#define STR0032 " Datos Thread"
	#define STR0033 " Usuario de la Red..: "
	#define STR0034 " Estacion............: "
	#define STR0035 " Programa inicial...: "
	#define STR0036 " Conexion............: "
	#define STR0037 " Fecha / Hora Final.: "
	#define STR0038 "Actualizacion concluida"
	#define STR0039 "Inicio de la actualizacion"
	#define STR0040 "Analizando tablas por modificar"
	#define STR0041 "Actualizando diccionario de campos ..."
	#define STR0042 "Creado el campo "
	#define STR0043 "Se modifico el campo "
	#define STR0044 "Actualizando campos de tablas (SX3)..."
	#define STR0045 "Final de la actualizacion"
	#define STR0046 "Pantalla para multiple seleccion de Empresas/Sucursales"
	#define STR0047 "Seleccione la(s) Empresa(s) para Actualizacion"
	#define STR0048 "Empresa"
	#define STR0049 "Todos"
	#define STR0050 "&Invertir"
	#define STR0051 "Invertir seleccion"
	#define STR0052 "Mascara empresa ( ?? )"
	#define STR0053 "&Marcar"
	#define STR0054 "Marcar usando mascara ( ?? )"
	#define STR0055 "&Desmarcar"
	#define STR0056 "Marcar usando mascara ( ?? )"
	#define STR0057 "Confirma la seleccion"
	#define STR0058 "Salir de la Seleccion"
	#define STR0059 "No fue posible abrir la tabla "
	#define STR0060 "de empresas (SM0)."
	#define STR0061 "de empresas (SM0) de forma exclusiva."
	#define STR0062 "Actualizando Archivos (SX6)..."
	#define STR0063 "Se modifico el parametro MV_MSIDENT"
	#define STR0064 "Se creo el parametro MV_MSIDENT"
#else
	#ifdef ENGLISH
		#define STR0001 "UPDATE OF MSIDENT FIELDS' SIZE"
		#define STR0002 "This routine purports to change the size of Record Ident. fields"
		#define STR0003 "(xx_MSIDENT/xxx_MSIDEN), from 8 characters to 12."
		#define STR0004 "The size of Tables which have this field will be changed."
		#define STR0005 "BACKUP the DATABASE and DICTIONARIES prior to this update, to "
		#define STR0006 "so in case accidental failures occur, this backup may be restored."
		#define STR0007 "Confirm update of dictionaries ?"
		#define STR0008 "Updating"
		#define STR0009 "Wait. Updating ..."
		#define STR0010 "Update Finished."
		#define STR0011 "Update Not Executed."
		#define STR0012 "Text Files"
		#define STR0013 "Update of company "
		#define STR0014 " not executed."
		#define STR0015 "Company : "
		#define STR0016 "Parameter dictionary - "
		#define STR0017 "Data dictionary - "
		#define STR0018 "Unknown error during update of table : "
		#define STR0019 ". Check integrity of dictionary and table."
		#define STR0020 "ATTENTION"
		#define STR0021 "An unknown error has occurred during structure update of table : "
		#define STR0022 "DICTIONARY UPDATE LOG"
		#define STR0023 " Environment Data"
		#define STR0024 " Company / Branch...: "
		#define STR0025 " Company Name.......: "
		#define STR0027 " Branch Name........: "
		#define STR0028 " BaseDate...........: "
		#define STR0029 " Starting Date / Time.: "
		#define STR0030 " Version............: "
		#define STR0031 " TOTVS User ........: "
		#define STR0032 " Thread Data"
		#define STR0033 " Network User.......: "
		#define STR0034 " Station.............: "
		#define STR0035 " Initial Program....: "
		#define STR0036 " Connection..........: "
		#define STR0037 " Ending Date / Time.: "
		#define STR0038 "Update finished."
		#define STR0039 "Starting Update"
		#define STR0040 "Analyzing tables to be changed"
		#define STR0041 "Updating dictionary of fields ..."
		#define STR0042 "Field created "
		#define STR0043 "Changes to field "
		#define STR0044 "Updating Table Fields (SX3)..."
		#define STR0045 "End of Update"
		#define STR0046 "Screen for Multiple Company/Branch Selections"
		#define STR0047 "Select the Company(ies) for Updating"
		#define STR0048 "Company"
		#define STR0049 "All"
		#define STR0050 "&Invert"
		#define STR0051 "Invert Selection"
		#define STR0052 "Company mask ( ?? )"
		#define STR0053 "&Mark"
		#define STR0054 "Mark using mask ( ?? )"
		#define STR0055 "&Unmark"
		#define STR0056 "Unmark using mask ( ?? )"
		#define STR0057 "Confirm the Selection"
		#define STR0058 "Leave Selection"
		#define STR0059 "Could not open table "
		#define STR0060 "of companies (SM0)."
		#define STR0061 "exclusively companies (SM0)."
		#define STR0062 "Updating Files (SX6)..."
		#define STR0063 "Parameter MV_MSIDENT has been changed"
		#define STR0064 "Parameter MV-MSIDENT has been created"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "ACTUALIZA��O DO TAMANHO DOS CAMPOS MSIDENT", "ATUALIZA��O DO TAMANHO DOS CAMPOS MSIDENT" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este procedimento tem como fun��o fazer a altera��o do tamanho dos campos Ident. Registo", "Esta rotina tem como fun��o fazer  a altera��o do tamanho dos campos Ident. Registro" )
		#define STR0003 "(xx_MSIDENT/xxx_MSIDEN), de 8 caracteres para 12."
		#define STR0004 "As tabelas que possuirem este campo ter�o seu tamanho alterado."
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Fa�a um BACKUP  dos DICION�RIOS e da  BASE DE DADOS antes desta actualiza��o, para ", "Fa�a um BACKUP  dos DICION�RIOS  e da  BASE DE DADOS antes desta atualiza��o, para " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "que caso ocorram eventuais falhas, esse backup possa ser restaurado.", "que caso ocorram eventuais falhas, esse backup seja ser restaurado." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Confirma a actualiza��o dos dicion�rios ?", "Confirma a atualiza��o dos dicion�rios ?" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "A actualizar", "Atualizando" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Aguarde, a actualizar ...", "Aguarde, atualizando ..." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Actualiza��o conclu�da.", "Atualiza��o Conclu�da." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Actualiza��o n�o realizada.", "Atualiza��o n�o Realizada." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Ficheiros Texto", "Arquivos Texto" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Actualiza��o da empresa ", "Atualiza��o da empresa " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", " n�o efectuada.", " n�o efetuada." )
		#define STR0015 "Empresa : "
		#define STR0016 "Dicion�rio de par�metros - "
		#define STR0017 "Dicion�rio de dados - "
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Ocorreu um erro desconhecido durante a actualiza��o da tabela : ", "Ocorreu um erro desconhecido durante a atualiza��o da tabela : " )
		#define STR0019 ". Verifique a integridade do dicion�rio e da tabela."
		#define STR0020 "ATEN��O"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Ocorreu um erro desconhecido durante a actualiza��o da estrutura da tabela : ", "Ocorreu um erro desconhecido durante a atualiza��o da estrutura da tabela : " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "LOG DA ACTUALIZA��O DOS DICION�RIOS", "LOG DA ATUALIZACAO DOS DICION�RIOS" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", " Dados do ambiente", " Dados Ambiente" )
		#define STR0024 " Empresa / Filial...: "
		#define STR0025 " Nome Empresa.......: "
		#define STR0027 " Nome Filial........: "
		#define STR0028 " DataBase...........: "
		#define STR0029 If( cPaisLoc $ "ANG|PTG", " Data / Hora In�cio.: ", " Data / Hora Inicio.: " )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", " Vers�o.............: ", " Versao.............: " )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", " Utilizador TOTVS .....: ", " Usuario TOTVS .....: " )
		#define STR0032 " Dados Thread"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", " Utilizador da Rede....: ", " Usuario da Rede....: " )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", " Esta��o............: ", " Estacao............: " )
		#define STR0035 " Programa Inicial...: "
		#define STR0036 If( cPaisLoc $ "ANG|PTG", " Conex�o............: ", " Conexao............: " )
		#define STR0037 " Data / Hora Final.: "
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Actualiza��o conclu�da.", "Atualizacao concluida." )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "In�cio da actualiza��o", "Inicio da Atualizacao" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "A analisar tabelas a alterar", "Analisando tabelas a alterar" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "A actualizar dicion�rio de campos ...", "Atualizando dicionario de campos ..." )
		#define STR0042 "Criado o campo "
		#define STR0043 "Alterado o campo "
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "A actualizar campos de tabelas (SX3)...", "Atualizando Campos de Tabelas (SX3)..." )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Final da actualiza��o", "Final da Atualizacao" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Ecr� para m�ltiplas selec��es de empresas/filiais", "Tela para M�ltiplas Sele��es de Empresas/Filiais" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Seleccione a(s) empresa(s) para actualiza��o", "Selecione a(s) Empresa(s) para Atualiza��o" )
		#define STR0048 "Empresa"
		#define STR0049 "Todos"
		#define STR0050 "&Inverter"
		#define STR0051 If( cPaisLoc $ "ANG|PTG", "Inverter selec��o", "Inverter Sele��o" )
		#define STR0052 If( cPaisLoc $ "ANG|PTG", "M�scara empresa ( ?? )", "M�scara Empresa ( ?? )" )
		#define STR0053 "&Marcar"
		#define STR0054 "Marcar usando m�scara ( ?? )"
		#define STR0055 "&Desmarcar"
		#define STR0056 "Desmarcar usando m�scara ( ?? )"
		#define STR0057 If( cPaisLoc $ "ANG|PTG", "Confirma a selec��o", "Confirma a Sele��o" )
		#define STR0058 If( cPaisLoc $ "ANG|PTG", "Abandona a selec��o", "Abandona a Sele��o" )
		#define STR0059 "N�o foi poss�vel a abertura da tabela "
		#define STR0060 "de empresas (SM0)."
		#define STR0061 "de empresas (SM0) de forma exclusiva."
		#define STR0062 If( cPaisLoc $ "ANG|PTG", "A actualizar ficheiros (SX6)...", "Atualizando Arquivos (SX6)..." )
		#define STR0063 If( cPaisLoc $ "ANG|PTG", "Alterou-se o par�metro MV_MSIDENT", "Alterado parametro MV_MSIDENT" )
		#define STR0064 If( cPaisLoc $ "ANG|PTG", "Criou-se o par�metro MV_MSIDENT", "Criado parametro MV_MSIDENT" )
	#endif
#endif

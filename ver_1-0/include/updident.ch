#ifdef SPANISH
	#define STR0001 "ACTUALIZACIÓN DEL TAMAÑO DE LOS CAMPOS MSIDENT"
	#define STR0002 "La función de esta rutina es efectuar cambios en el tamaño de los campos Ident.Registro"
	#define STR0003 "(xx_MSIDENT/xxx_MSIDEN), de 8 caracteres a 12."
	#define STR0004 "Las tablas que posean este campo tendrán su tamaño cambiado."
	#define STR0005 "Efectúe un BACKUP de los DICCIONARIOS y de la BASE DE DATOS antes de esta actualización, "
	#define STR0006 "por si hubiera algún eventual fallo, se podrá recuperar el backup."
	#define STR0007 "Confirma la actualización de los diccionarios ?"
	#define STR0008 "Actualizando"
	#define STR0009 "Espere, actualizando ..."
	#define STR0010 "Actualización concluida."
	#define STR0011 "Actualización no efectuada."
	#define STR0012 "Archivos Texto"
	#define STR0013 "Actualización de la empresa "
	#define STR0014 " no efectuada."
	#define STR0015 "Empresa : "
	#define STR0016 "Diccionario de parámetros - "
	#define STR0017 "Diccionario de datos - "
	#define STR0018 "Hubo un error desconocido al actualizar la tabla : "
	#define STR0019 ". Asegúrese de la integridad del diccionario y de la tabla."
	#define STR0020 "ATENCIÓN"
	#define STR0021 "Hubo un error desconocido al actualizar la estructura de la tabla : "
	#define STR0022 "LOG DE LA ACTUALIZACIÓN DE LOS DICCIONARIOS"
	#define STR0023 " Datos del Entorno"
	#define STR0024 " Empresa / Filial...: "
	#define STR0025 " Nombre Empresa.....: "
	#define STR0027 " Nombre Filial......: "
	#define STR0028 " FechaBase..........: "
	#define STR0029 " Fecha/ Hora Inicio.: "
	#define STR0030 " Versión............: "
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
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "ACTUALIZAÇÃO DO TAMANHO DOS CAMPOS MSIDENT", "ATUALIZAÇÃO DO TAMANHO DOS CAMPOS MSIDENT" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este procedimento tem como função fazer a alteração do tamanho dos campos Ident. Registo", "Esta rotina tem como função fazer  a alteração do tamanho dos campos Ident. Registro" )
		#define STR0003 "(xx_MSIDENT/xxx_MSIDEN), de 8 caracteres para 12."
		#define STR0004 "As tabelas que possuirem este campo terão seu tamanho alterado."
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Faça um BACKUP  dos DICIONÁRIOS e da  BASE DE DADOS antes desta actualização, para ", "Faça um BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização, para " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "que caso ocorram eventuais falhas, esse backup possa ser restaurado.", "que caso ocorram eventuais falhas, esse backup seja ser restaurado." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Confirma a actualização dos dicionários ?", "Confirma a atualização dos dicionários ?" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "A actualizar", "Atualizando" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Aguarde, a actualizar ...", "Aguarde, atualizando ..." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Actualização concluída.", "Atualização Concluída." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Actualização não realizada.", "Atualização não Realizada." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Ficheiros Texto", "Arquivos Texto" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Actualização da empresa ", "Atualização da empresa " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", " não efectuada.", " não efetuada." )
		#define STR0015 "Empresa : "
		#define STR0016 "Dicionário de parâmetros - "
		#define STR0017 "Dicionário de dados - "
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Ocorreu um erro desconhecido durante a actualização da tabela : ", "Ocorreu um erro desconhecido durante a atualização da tabela : " )
		#define STR0019 ". Verifique a integridade do dicionário e da tabela."
		#define STR0020 "ATENÇÃO"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Ocorreu um erro desconhecido durante a actualização da estrutura da tabela : ", "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "LOG DA ACTUALIZAÇÃO DOS DICIONÁRIOS", "LOG DA ATUALIZACAO DOS DICIONÁRIOS" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", " Dados do ambiente", " Dados Ambiente" )
		#define STR0024 " Empresa / Filial...: "
		#define STR0025 " Nome Empresa.......: "
		#define STR0027 " Nome Filial........: "
		#define STR0028 " DataBase...........: "
		#define STR0029 If( cPaisLoc $ "ANG|PTG", " Data / Hora Início.: ", " Data / Hora Inicio.: " )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", " Versão.............: ", " Versao.............: " )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", " Utilizador TOTVS .....: ", " Usuario TOTVS .....: " )
		#define STR0032 " Dados Thread"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", " Utilizador da Rede....: ", " Usuario da Rede....: " )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", " Estação............: ", " Estacao............: " )
		#define STR0035 " Programa Inicial...: "
		#define STR0036 If( cPaisLoc $ "ANG|PTG", " Conexão............: ", " Conexao............: " )
		#define STR0037 " Data / Hora Final.: "
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Actualização concluída.", "Atualizacao concluida." )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Início da actualização", "Inicio da Atualizacao" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "A analisar tabelas a alterar", "Analisando tabelas a alterar" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "A actualizar dicionário de campos ...", "Atualizando dicionario de campos ..." )
		#define STR0042 "Criado o campo "
		#define STR0043 "Alterado o campo "
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "A actualizar campos de tabelas (SX3)...", "Atualizando Campos de Tabelas (SX3)..." )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Final da actualização", "Final da Atualizacao" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Ecrã para múltiplas selecções de empresas/filiais", "Tela para Múltiplas Seleções de Empresas/Filiais" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Seleccione a(s) empresa(s) para actualização", "Selecione a(s) Empresa(s) para Atualização" )
		#define STR0048 "Empresa"
		#define STR0049 "Todos"
		#define STR0050 "&Inverter"
		#define STR0051 If( cPaisLoc $ "ANG|PTG", "Inverter selecção", "Inverter Seleção" )
		#define STR0052 If( cPaisLoc $ "ANG|PTG", "Máscara empresa ( ?? )", "Máscara Empresa ( ?? )" )
		#define STR0053 "&Marcar"
		#define STR0054 "Marcar usando máscara ( ?? )"
		#define STR0055 "&Desmarcar"
		#define STR0056 "Desmarcar usando máscara ( ?? )"
		#define STR0057 If( cPaisLoc $ "ANG|PTG", "Confirma a selecção", "Confirma a Seleção" )
		#define STR0058 If( cPaisLoc $ "ANG|PTG", "Abandona a selecção", "Abandona a Seleção" )
		#define STR0059 "Não foi possível a abertura da tabela "
		#define STR0060 "de empresas (SM0)."
		#define STR0061 "de empresas (SM0) de forma exclusiva."
		#define STR0062 If( cPaisLoc $ "ANG|PTG", "A actualizar ficheiros (SX6)...", "Atualizando Arquivos (SX6)..." )
		#define STR0063 If( cPaisLoc $ "ANG|PTG", "Alterou-se o parâmetro MV_MSIDENT", "Alterado parametro MV_MSIDENT" )
		#define STR0064 If( cPaisLoc $ "ANG|PTG", "Criou-se o parâmetro MV_MSIDENT", "Criado parametro MV_MSIDENT" )
	#endif
#endif

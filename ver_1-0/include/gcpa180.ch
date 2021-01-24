#ifdef SPANISH
	#define STR0001 "Archivo de proveedores/Activaci�n"
	#define STR0002 "Incluir"
	#define STR0003 "Consulta de proveedores en el SICAF"
	#define STR0004 "Par�metros de Consulta de proveedores"
	#define STR0005 "Incluye proveedor/Participante"
	#define STR0006 "No existen campos rellenados para realizar esta b�squeda."
	#define STR0007 "Vac�os"
	#define STR0008 "Espere..."
	#define STR0009 "Cargando datos SICAF"
	#define STR0010 "�Contin�a consulta?"
	#define STR0011 "Problemas consultando datos b�sicos del proveedor"
	#define STR0012 " proveedores, "
	#define STR0013 "Se encontraron "
	#define STR0014 "solo se muestran los 990 primeros en la cuadr�cula."
	#define STR0015 "Informe filtro m�s espec�fico para restringir el resultado."
	#define STR0016 "Retorno del httpget() inconsistente no permite obtener datos de los proveedores."
	#define STR0017 "No existen l�neas de cuadr�cula seleccionadas para realizar inclusi�n."
	#define STR0018 "�Confirma inclusi�n de proveedores/participantes seleccionados?"
	#define STR0019 " ), no se har� su importaci�n."
	#define STR0020 "Ya existe proveedor con RFC semejante al "
	#define STR0021 " ), no se har� su importaci�n."
	#define STR0022 "Ya existe participante con RFC semejante al "
	#define STR0023 "�Atenci�n!"
	#define STR0024 "Los proveedores/participantes seleccionados no se procesar�n."
	#define STR0025 " Proveedores"
	#define STR0026 " Participantes"
	#define STR0027 "Se incluir�n "
	#define STR0028 "Proveedores"
	#define STR0029 "Problemas consultando datos b�sicos del proveedor"
	#define STR0030 "Retorno del httpget() inconsistente no permite obtener datos de los proveedores."
	#define STR0031 "Problemas consultando datos detallados del proveedor"
	#define STR0032 "Proveedor no encontrado en la consulta detallada"
	#define STR0033 "Problema con inclusi�n de proveedor "
	#define STR0034 "Problema con inclusi�n de participante "
#else
	#ifdef ENGLISH
		#define STR0001 "Suppliers/License Register"
		#define STR0002 "Add"
		#define STR0003 "Query of Suppliers on SICAF"
		#define STR0004 "Parameters of Supplier Query"
		#define STR0005 "Add Supplier/Participant"
		#define STR0006 "There are no fields completed to query."
		#define STR0007 "Blank"
		#define STR0008 "Wait..."
		#define STR0009 "Loading SICAF data"
		#define STR0010 "Continue query?"
		#define STR0011 "Problems consulting basic data of the supplier"
		#define STR0012 " suppliers, "
		#define STR0013 "Were found "
		#define STR0014 "will be displayed only the first 990 on the grid."
		#define STR0015 "Enter the most specific filter to restrict the result."
		#define STR0016 "Error receiving information via SICAF"
		#define STR0017 "There are no grid lines selected for inclusion."
		#define STR0018 "Confirms inclusion of selected suppliers/participants?"
		#define STR0019 " ), no import will be performed."
		#define STR0020 "There is already a CPF similar to "
		#define STR0021 " ), no import will be performed."
		#define STR0022 "There is already a participant with CPF similar to "
		#define STR0023 "Attention!"
		#define STR0024 "The selected suppliers/participants will not be processed."
		#define STR0025 " Suppliers"
		#define STR0026 " Participants"
		#define STR0027 "Will be included "
		#define STR0028 "Suppliers"
		#define STR0029 "Problems consulting basic data of the supplier"
		#define STR0030 "Inconsistent httpget() return does not allow to obtain data from suppliers."
		#define STR0031 "Problems consulting detailed data of the supplier"
		#define STR0032 "Supplier not found on detailed query"
		#define STR0033 "Problem with supplier addition "
		#define STR0034 "Problem with participant addition "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Cadastro de Fornecedores/Habilita��o" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Consulta de Fornecedores no SICAF" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Par�metros de Consulta de Fornecedores" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Inclui Fornecedor/Participante" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "N�o existem campos preenchidos para realizar esta busca." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Vazios" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Aguarde..." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Carregando Dados SICAF" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Continua consulta?" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Problemas consultando dados b�sicos do fornecedor" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , " fornecedores, " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Foram encontrados " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "ser�o exibidos apenas os 990 primeiros no grid." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Informe filtro mais espec�fico para restringir o resultado." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Erro no recebimento das informa��es pelo SICAF" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "N�o existem linhas do grid selecionadas para realizar inclus�o." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Confirma inclus�o dos fornecedores/participantes selecionados?" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , " ), n�o ser� feita importa��o do mesmo." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "J� existe fornecedor com CPF semelhante ao " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , " ), n�o ser� feita importa��o do mesmo." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "J� existe participante com CPF semelhante ao " )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Aten��o!" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Os fornecedores/participantes selecionados n�o ser�o processados." )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , " Fornecedores" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , " Participantes" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Ser�o inclu�dos " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Fornecedores" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Problemas consultando dados b�sicos do fornecedor" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Retorno do httpget() inconsistente n�o permite obter dados dos fornecedores." )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Problemas consultando dados detalhados do fornecedor" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Fornecedor n�o encontrado na consulta detalhada" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Problema com inclus�o do fornecedor " )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Problema com inclus�o do participante " )
	#endif
#endif

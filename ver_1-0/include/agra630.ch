#ifdef SPANISH
	#define STR0001 "Archivo de Lista de Embarque de Clasificacion"
	#define STR0002 "Visual Pendiente"
	#define STR0003 "Visual Parcial"
	#define STR0004 "Visual Clasificado"
	#define STR0005 "Clasificacion HVI"
	#define STR0006 "Visualizar"
	#define STR0007 "Incluir"
	#define STR0008 "Modificar"
	#define STR0009 "Borrar"
	#define STR0010 "Clasificar"
	#define STR0011 "Imprimir"
	#define STR0012 "Modelo de datos de la Lista de Embarque de Clasificacion"
	#define STR0013 "Datos de la Lista de Embarque"
	#define STR0014 "Datos de los Items de la lista de Embarque"
	#define STR0015 'Total Fardos'
	#define STR0016 'Total Clas. Visual'
	#define STR0017 'Total Neto'
	#define STR0018 "Incluir Fardos"
	#define STR0019 "Atencion"
	#define STR0020 "No se permitira borrar la linea, pues este fardo ya se bloqueo."
	#define STR0021 "¿A Fardo?"
	#define STR0022 "Parametros "
	#define STR0023 "Fardo"
	#define STR0024 "Etiqueta"
	#define STR0025 "Inclusion de Fardos en la Lista de Embarque"
	#define STR0026 "Fardos Sin Clasificacion"
	#define STR0027 "Fardos Seleccionados para Casificacion"
	#define STR0028 "Encuesta"
	#define STR0029 'Encuesta'
	#define STR0030 "Vincular Marcados"
	#define STR0031 "Desvincular Marcados"
	#define STR0032 "Cantidad"
	#define STR0033 "Peso Total"
	#define STR0034 "Espere"
	#define STR0035 "Acualizando tabla de datos de los items de la lista de embarque"
	#define STR0036 'Incluir Fardos'
	#define STR0037 "CLASIFICACION"
	#define STR0038 "Tipo"
	#define STR0039 "Tipo de Clasificacion en Blanco"
	#define STR0040 "¡La etiqueta leida no fue ubicada en los items de la lista de embarque!"
	#define STR0041 "No se permitira modificar la clasificacion, pue este fardo pertenece a un bloque."
	#define STR0042 "¿De Fardo?"
	#define STR0043 "Prensa"
	#define STR0044 "Limite de fardos mostrados"
	#define STR0045 "Excedio el limite de 10.000 fardos que se mostraran, se mostraran solamente 10.000. ¿Desea continuar?"
	#define STR0046 "Usuario no posee Unidad de mejora registrada."
#else
	#ifdef ENGLISH
		#define STR0001 "Classification Bordereau File"
		#define STR0002 "Pending Visual"
		#define STR0003 "Partial Visual"
		#define STR0004 "Classified Visual"
		#define STR0005 "HVI Classification"
		#define STR0006 "View"
		#define STR0007 "Add"
		#define STR0008 "Edit"
		#define STR0009 "Delete"
		#define STR0010 "Sort"
		#define STR0011 "Print"
		#define STR0012 "Data Model of Classification Manifest"
		#define STR0013 "Manifest Data"
		#define STR0014 "Manifest Items Data"
		#define STR0015 'Bales Total'
		#define STR0016 'Visual Clas. Total'
		#define STR0017 'Net Total'
		#define STR0018 "Add Bales"
		#define STR0019 "Attention"
		#define STR0020 "Deleting a row is not allowed as this bale is blocked."
		#define STR0021 "Bale to?"
		#define STR0022 "Parameters "
		#define STR0023 "Bale"
		#define STR0024 "Label"
		#define STR0025 "Addition of manifest Bales"
		#define STR0026 "Bales without classification"
		#define STR0027 "Bales selected for classification"
		#define STR0028 "Search"
		#define STR0029 'Search'
		#define STR0030 "Associate the Selected ones"
		#define STR0031 "Dissociate the Selected ones"
		#define STR0032 "Amount"
		#define STR0033 "Total Weight"
		#define STR0034 "Wait"
		#define STR0035 "Updating data table of manifest items"
		#define STR0036 'Add Bales'
		#define STR0037 "CLASSIFICATION"
		#define STR0038 "Type"
		#define STR0039 "Blank Classification Type"
		#define STR0040 "The label read was not localized in the manifest items!"
		#define STR0041 "Editing the classification is not allowed as this bale belongs to a block."
		#define STR0042 "Bale To?"
		#define STR0043 "Press"
		#define STR0044 "Bale Limit Displayed"
		#define STR0045 "Exceeded the 10,000 bale limit to be displayed, only 10,000 will be displayed. Continue?"
		#define STR0046 "User has no Benefit Unit registered."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de romaneio de classificação", "Cadastro de Romaneio de Classificação" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Visual pendente", "Visual Pendente" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Visual parcial", "Visual Parcial" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Visual classificado", "Visual Classificado" )
		#define STR0005 "Classificação HVI"
		#define STR0006 "Visualizar"
		#define STR0007 "Incluir"
		#define STR0008 "Alterar"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0010 "Classificar"
		#define STR0011 "Imprimir"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Modelo de dados do Romaneio de classificação", "Modelo de dados do Romaneio de Classificação" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Dados do romaneio", "Dados do Romaneio" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Dados dos Itens romaneio", "Dados dos Itens Romaneio" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", 'Total fardos', 'Total Fardos' )
		#define STR0016 'Total Clas. Visual'
		#define STR0017 If( cPaisLoc $ "ANG|PTG", 'Total líquido', 'Total Líquido' )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Incluir fardos", "Incluir Fardos" )
		#define STR0019 "Atenção"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Não será permitido eliminar a linha, pois este fardo já foi blocado.", "Não será permitido excluir a linha, pois este fardo já foi blocado." )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Até fardo?", "Fardo Ate ?" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Parâmetros ", "Parametros " )
		#define STR0023 "Fardo"
		#define STR0024 "Etiqueta"
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Inclusão de fardos no romaneio", "Inclusão de Fardos no Romaneio" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Fardos sem classificação", "Fardos Sem Classificação" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Fardos seleccionados para classificação", "Fardos Selecionados para Cassificação" )
		#define STR0028 "Pesquisa"
		#define STR0029 'Pesquisa'
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Vincular marcados", "Vincular Marcados" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Desvincular marcados", "Desvincular Marcados" )
		#define STR0032 "Quantidade"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Peso total", "Peso Total" )
		#define STR0034 "Aguarde"
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "A actualizar tabela de dados dos itens do romaneio", "Atualizando tabela de dados dos itens do romaneio" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", 'Incluir fardos', 'Incluir Fardos' )
		#define STR0037 "CLASSIFICAÇÃO"
		#define STR0038 "Tipo"
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Tipo de classificação em branco", "Tipo de Classificação em Branco" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "A etiqueta lida não foi localizada nos itens do romaneio.", "A etiqueta lida não foi localizada nos itens do romaneio!" )
		#define STR0041 "Não será permitido alterar a classificação, pois este fardo pertence a um bloco."
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "De fardo?", "Fardo De ?" )
		#define STR0043 "Prensa"
		#define STR0044 "Limite de Fardos Exibidos"
		#define STR0045 "Excedeu o limite de 10.000 fardos a serem exibidos, serao exibidos apenas 10.000. Deseja continuar?"
		#define STR0046 "Usuário não possui Unidade de Beneficiamento cadastrado."
	#endif
#endif

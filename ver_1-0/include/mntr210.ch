#ifdef SPANISH
	#define STR0001 "Hist�rico dos Insumos Aplicados no Bem."
	#define STR0002 "O usu�rio pode selecionar quais os campos que dever�o ser mostrados,"
	#define STR0003 "bem como informar parametros de sele��o para a impress�o."
	#define STR0004 "A rayas"
	#define STR0005 "Administra��o"
	#define STR0006 "Insumos Aplicados no Per�odo"
	#define STR0007 "  Fch.Aplic.    O.S.   Insumo          Descripcion             Localiz.        CTD   Un    Contador 1   Contador 2"
	#define STR0008 "Bien             Descripcion"
	#define STR0009 "Procesando itemes de las O.S. "
	#define STR0010 " Normales..."
	#define STR0011 " Hist�rico..."
	#define STR0012 "Selecionando Registros..."
	#define STR0013 "Bien"
	#define STR0014 "Descripc."
	#define STR0015 "Fc.Aplic."
	#define STR0016 "O.S."
	#define STR0017 "Insumo"
	#define STR0018 "Ubicac."
	#define STR0019 "Cantidad"
	#define STR0020 "Un"
	#define STR0021 "Contador 1"
	#define STR0022 "Contador 2"
	#define STR0023 "Insumos aplicados"
	#define STR0024 "Ubicacion: "
	#define STR0025 "Estructura...:"
	#define STR0026 "No esta relacionado a una Estructura."
	#define STR0027 "Matriz Estruct. "
	#define STR0028 "Informe a partir de que Ubicacion debe constar en el informe. Pulse [F3]+[Enter] para seleccionar la Ubicacion."
	#define STR0029 "Informe hasta que Ubicacion debe constar en el informe. Pulse [F3]+[Enter] para seleccionar la Ubicacion."
	#define STR0030 "�De Ubicacion?"
	#define STR0031 "�A Ubicacion?"
	#define STR0032 "�Imprimir Localizacion ?"
	#define STR0033 "Si"
	#define STR0034 "No"
	#define STR0035 "Informe si debe imprimir la localizacion:"
	#define STR0036 "1-Si"
	#define STR0037 "2-No"
	#define STR0038 "Aplicado"
	#define STR0039 "Devolvido"
	#define STR0040 "Considera Devolu��o?"
	#define STR0041 "TERCEIROS"
	#define STR0042 "MANUTEN��O"
	#define STR0043 "  Data     O.S.     Insumo          "
	#define STR0044 "Descri��o               Localiz.        QTD   Un    Contador 1   Contador 2   Tipo"
	#define STR0045 "Deseja considerar devolu��o?"
#else
	#ifdef ENGLISH
		#define STR0001 "History of Inputs Applied in Asset."
		#define STR0002 "User can select which fields are displayed."
		#define STR0003 "as well as enter selection parameters for print."
		#define STR0004 "Z. Form"
		#define STR0005 "Administration"
		#define STR0006 "Inputs Applied in Period"
		#define STR0007 "  Appli.Dt.    S.O.   Input           Descript.               Localiz.        QTY   Un    Counter  1   Counter  2"
		#define STR0008 "Asset            Description"
		#define STR0009 "Processing S.O. Items "
		#define STR0010 " Normal..."
		#define STR0011 " History..."
		#define STR0012 "Selecting records ...  "
		#define STR0013 "Asset"
		#define STR0014 "Descript."
		#define STR0015 "Applic.Dt"
		#define STR0016 "S.O."
		#define STR0017 "Input "
		#define STR0018 "Localiz."
		#define STR0019 "Quantity  "
		#define STR0020 "Un"
		#define STR0021 "Counter 1 "
		#define STR0022 "Counter 2 "
		#define STR0023 "Input applied    "
		#define STR0024 "Location: "
		#define STR0025 "Structure...: "
		#define STR0026 "It is not related to a Structure."
		#define STR0027 "Structure Parent."
		#define STR0028 "Indicate from which Location must be in the Report. Press [F3]+[Enter] to select a Location."
		#define STR0029 "Indicate up to which Location must be in the Report. Press [F3]+[Enter] to select a Location."
		#define STR0030 "From Location?"
		#define STR0031 "To Location?"
		#define STR0032 "Print Location?"
		#define STR0033 "Yes"
		#define STR0034 "No"
		#define STR0035 "Inform if location must be printed:"
		#define STR0036 "1-Yes"
		#define STR0037 "2-No"
		#define STR0038 "Applied"
		#define STR0039 "Returned"
		#define STR0040 "Do you consider Return?"
		#define STR0041 "THIRD PARTIES"
		#define STR0042 "MAINTENANCE"
		#define STR0043 "  Date S.O. Input          "
		#define STR0044 "Location Description        QTY   Un    Counter 1   Counter 2   Type"
		#define STR0045 "Do you want to consider return?"
	#else
		#define STR0001 "Hist�rico dos Insumos Aplicados no Bem."
		#define STR0002 "O usu�rio pode selecionar quais os campos que dever�o ser mostrados,"
		#define STR0003 "bem como informar parametros de sele��o para a impress�o."
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0005 "Administra��o"
		#define STR0006 "Insumos Aplicados no Per�odo"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "  dt.aplic.    o.s.   insumo          descri��o               localiz.        qtd   un    contador 1   contador 2", "  Dt.Aplic.        O.S.   Insumo            Descricao             Localiz.        QTD   Un    Contador 1   Contador 2" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Bem              Descri��o", "Bem/Localizacao  Descricao" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Processando itens das o.s. ", "Processando Itens das O.S. " )
		#define STR0010 " Normais..."
		#define STR0011 " Hist�rico..."
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Bem", "Bem/Localiza��o" )
		#define STR0014 "Descri��o"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Dt.aplic.", "Dt.Aplic." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Ordem de servi�o", "O.S." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Recurso", "Insumo" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Localiz. ", "Localiz." )
		#define STR0019 "Quantidade"
		#define STR0020 "Un"
		#define STR0021 "Contador 1"
		#define STR0022 "Contador 2"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Recursos aplicados", "Insumos aplicados" )
		#define STR0024 "Localiza��o.: "
		#define STR0025 "Estrutura...: "
		#define STR0026 "N�o est� relacionado a uma Estrutura."
		#define STR0027 "Pai da Estrutura."
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Informe de qual Localiza��o deve constar no relat�rio. Pressione as teclas [F3]+[Enter] para seleccionar a Localiza��o.", "Informe de qual Localiza��o deve constar no relat�rio. Pressione as teclas [F3]+[Enter] para selecionar a Localiza��o." )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Informe at� qual Localiza��o deve constar no relat�rio. Pressione as teclas [F3]+[Enter] para seleccionar a Localiza��o.", "Informe at� qual Localiza��o deve constar no relat�rio. Pressione as teclas [F3]+[Enter] para selecionar a Localiza��o." )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "De Localiza��o?", "De Localizacao ?" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "At� Localiza��o?", "Ate Localizacao ?" )
		#define STR0032 "Imprimir Localiza��o ?"
		#define STR0033 "Sim"
		#define STR0034 "N�o"
		#define STR0035 "Informe se deve imprimir a localiza��o:"
		#define STR0036 "1-Sim"
		#define STR0037 "2-N�o"
		#define STR0038 "Aplicado"
		#define STR0039 "Devolvido"
		#define STR0040 "Considera Devolu��o?"
		#define STR0041 "TERCEIROS"
		#define STR0042 "MANUTEN��O"
		#define STR0043 "  Data     O.S.     Insumo          "
		#define STR0044 "Descri��o               Localiz.        QTD   Un    Contador 1   Contador 2   Tipo"
		#define STR0045 "Deseja considerar devolu��o?"
	#endif
#endif

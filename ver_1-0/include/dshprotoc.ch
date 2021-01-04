#ifdef SPANISH
	#define STR0001 "La conexion con la aplicacion externa devolvio el contenido invalido. Verifique la conexion con la aplicacion."
	#define STR0002 "Conexion no implementada: "
	#define STR0003 "Falla de conexion"
	#define STR0004 "Nodo "
	#define STR0005 " no informado"
	#define STR0006 "Validacion Dashboard manual. Archivo XML Schema no encontrado "
	#define STR0007 "No fue posible crear el Objeto XML. Verifique el XML: "
	#define STR0008 "Error ocurrido en la aplicacion externa: "
	#define STR0009 "Tipo de Vision informado equivocadamente: "
	#define STR0010 "No se permite EXPRESION DE Filtros sin NINGUN COMANDO"
	#define STR0011 "No se permite EXPRESION DE Alertas sin NINGUN COMANDO"
	#define STR0012 "No se permite Vision del Tipo Grafico sin NINGUN EJE"
	#define STR0013 "Elemento XML (PosicionamIento dEL EJE) informado equivocadamente: "
	#define STR0014 "En graficos del tipo Function debe necesariamente informarse la funcion que se utilizara en el Grafico. Informe la funcion por el nodo typeParm del XML"
	#define STR0015 "Elemento XML (Tipo de Grafico) informado equivocadamente: "
	#define STR0016 "Tipo de Comando equivocado: "
	#define STR0017 "Defina los titulos del gr�fico. Metodo defineTitles(..)"
	#define STR0018 "Defina los Enlaces del grafico. Metodo defineLinks(..)"
	#define STR0019 "Defina los Ejes del grafico"
#else
	#ifdef ENGLISH
		#define STR0001 "Connection with external application returned an invalid content. Check connection with application."
		#define STR0002 "Connection not implemented:"
		#define STR0003 "Failure in connection"
		#define STR0004 "Knot"
		#define STR0005 "not entered"
		#define STR0006 "Mannual Dashboard validation. XML Schema file not found"
		#define STR0007 "It was not possible to creat XML Object. Check XML:"
		#define STR0008 "Error in external application:"
		#define STR0009 "Type of view erroneously entered:"
		#define STR0010 "It is now allowed Filters EXPRESSION without ANY COMMAND"
		#define STR0011 "It is not allowed Alerts EXPRESSION without ANY COMMAND"
		#define STR0012 "It is not allowed View Type Chart withou ANY AXLE"
		#define STR0013 "XML Element (Axle Placing) erroneously entered:"
		#define STR0014 "Function must necessarily be entered in Function type chart. Enter the function via typeParm in the XML"
		#define STR0015 "XML Element (Type of Chart) erroneously entered:"
		#define STR0016 "Wrong type of command:"
		#define STR0017 "establishes bills of the chart. Method establishBills(..)"
		#define STR0018 "Establish links of the chart. Method establishLinks(..)"
		#define STR0019 "Establish axles of the chart"
	#else
		#define STR0001 "A conex�o com a aplica��o externa retornou conte�do inv�lido. Verifique a conex�o com a aplica��o."
		#define STR0002 "Conex�o n�o implementada: "
		#define STR0003 "Falha de conex�o"
		#define STR0004 "N� "
		#define STR0005 " n�o informado"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Valida��o Dashboard manual. Ficheiro XML Schema n�o encontrado ", "Valida��o Dashboard manual. Arquivo XML Schema n�o encontrado " )
		#define STR0007 "N�o foi poss�vel criar o Objeto XML. Verifique o XML: "
		#define STR0008 "Erro ocorrido na aplica��o externa: "
		#define STR0009 "Tipo de Vis�o informado erroneamente: "
		#define STR0010 "N�o � permitido EXPRESS�O DE Filtros sem NENHUM COMANDO"
		#define STR0011 "N�o � permitido EXPRESS�O DE Alertas sem NENHUM COMANDO"
		#define STR0012 "N�o � permitido Vis�o do Tipo Gr�fico sem NENHUM EIXO"
		#define STR0013 "Elemento XML (Posicionamento do Eixo) informado erroneamente: "
		#define STR0014 "Gr�ficos do tipo Function devem necess�riamente ser informada a fun��o que ser� utilizada no Gr�fico. Informe a fun��o via n� typeParm do XML"
		#define STR0015 "Elemento XML (Tipo de Gr�fico) informado erroneamente: "
		#define STR0016 "Tipo de Comando errado: "
		#define STR0017 "Defina os t�tulos do gr�fico. M�todo defineTitles(..)"
		#define STR0018 "Defina os Links do gr�fico. M�todo defineLinks(..)"
		#define STR0019 "Defina os Eixos do gr�fico"
	#endif
#endif

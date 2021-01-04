#ifdef SPANISH
	#define STR0001 "Generacion de Graficos en la Anamnesis"
	#define STR0002 " Dias"
	#define STR0003 " Mes"
	#define STR0004 " Ano"
	#define STR0005 "Generando grafico, espere..."
	#define STR0006 "Calculadora"
	#define STR0007 "Imprimir"
	#define STR0008 "Prontuario"
	#define STR0009 "Nombre."
	#define STR0010 "Fecha nacimiento: "
	#define STR0011 "Sexo"
	#define STR0012 "Edad "
	#define STR0013 "Masculino"
	#define STR0014 "Femenino"
	#define STR0015 "Para esta funcionalidade s� devem ser utilizadas perguntas do tipo numerico, caracter ou Data!"
	#define STR0016 "Grafico audiometria oido derecho"
	#define STR0017 "Grafico audiometria oido izquierdo"
	#define STR0018 "Fecha de atencion "
	#define STR0019 "Pagina: "
	#define STR0020 "Fch. Ref.: "
	#define STR0021 "Emision: "
	#define STR0022 "Para el Gr�fico de audiometr�a es necesaria la configuraci�n de los par�metros MV_RELAUDD y MV_RELAUDE "
#else
	#ifdef ENGLISH
		#define STR0001 "Issuing Graphs on Anamnesis"
		#define STR0002 " Days"
		#define STR0003 " Month"
		#define STR0004 " Year"
		#define STR0005 "Generating graph, please wait..."
		#define STR0006 "Calculator"
		#define STR0007 "Print"
		#define STR0008 "Medical Record"
		#define STR0009 "Name."
		#define STR0010 "Date of Birth: "
		#define STR0011 "Gender"
		#define STR0012 "Age "
		#define STR0013 "Male"
		#define STR0014 "Female"
		#define STR0015 "For this functionality only numeric, date or character questions must be used!"
		#define STR0016 "Audiometry Right Ear Chart"
		#define STR0017 "Audiometry Left Ear Chart"
		#define STR0018 "Service Date "
		#define STR0019 "Page: "
		#define STR0020 "Ref. Dt.: "
		#define STR0021 "Issue: "
		#define STR0022 "For Audiometry Chart, configure the following parameters: MV_RELAUDD and MV_RELAUDE "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Gera��o de Graficos na Anamnese" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , " Dias" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , " M�s" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , " Ano" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Gerando gr�fico, aguarde..." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Calculadora" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Imprimir" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Prontu�rio" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Nome." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Data Nascimento: " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Sexo" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Idade " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Masculino" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Feminino" )
		#define STR0015 "Para esta funcionalidade s� devem ser utilizadas perguntas do tipo numerico, caracter ou Data!"
		#define STR0016 "Grafico Audiometria Ouvido Direito"
		#define STR0017 "Grafico Audiometria Ouvido Esquerdo"
		#define STR0018 "Data Atendimento "
		#define STR0019 "P�gina: "
		#define STR0020 "Dt. Ref.: "
		#define STR0021 "Emiss�o: "
		#define STR0022 "Para o Grafico de Audiometria � necess�rio a configura��o dos Parametros MV_RELAUDD e MV_RELAUDE "
	#endif
#endif

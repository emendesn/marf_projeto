#ifdef SPANISH
	#define STR0001 "Evaluacion de Requisitos"
	#define STR0002 "Pesquisar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Alterar"
	#define STR0006 "Excluir"
	#define STR0007 "Demanda"
	#define STR0008 "Tema"
	#define STR0009 "Fecha de emision"
	#define STR0010 "Tipo Requisito"
	#define STR0011 "Fecha Evaluacion"
	#define STR0012 "Evaluaciones"
	#define STR0013 "Evaluacion"
	#define STR0014 "Descripcion"
	#define STR0015 "Peso"
	#define STR0016 "Resultado"
	#define STR0017 "Total"
	#define STR0018 "Opciones"
	#define STR0019 "FEDERAL"
	#define STR0020 "ESTADUAL"
	#define STR0021 "MUNICIPAL"
	#define STR0022 "ACIONISTA"
	#define STR0023 "COMUNIDADE"
	#define STR0024 "OUTROS"
	#define STR0025 "Codigo"
	#define STR0026 "Respostas"
	#define STR0027 "Peso %"
	#define STR0028 "No se respondio la evaluacion "
	#define STR0029 "No sera posible evaluar los requisitos sin Criterios de evaluacion"
	#define STR0030 "Requisito"
	#define STR0031 "Tipo Requisito"
	#define STR0032 "Ya existe una evaluacion registrada con el codigo: "
	#define STR0033 "No sera posible evaluar los Requisitos sin Criterios de Evaluacion"
#else
	#ifdef ENGLISH
		#define STR0001 "Requirements Evaluation"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Add"
		#define STR0005 "Edit"
		#define STR0006 "Delete"
		#define STR0007 "Demand"
		#define STR0008 "Theme"
		#define STR0009 "Issue date"
		#define STR0010 "Tp Requirement"
		#define STR0011 "Evaluation Date"
		#define STR0012 "Evaluations"
		#define STR0013 "Evaluation"
		#define STR0014 "Description"
		#define STR0015 "Weight"
		#define STR0016 "Result"
		#define STR0017 "Total"
		#define STR0018 "Options"
		#define STR0019 "FEDERAL"
		#define STR0020 "STATE"
		#define STR0021 "MUNICIPAL"
		#define STR0022 "SHAREHOLDER"
		#define STR0023 "COMMUNITY"
		#define STR0024 "OTHER"
		#define STR0025 "Code"
		#define STR0026 "Answers"
		#define STR0027 "Weight %"
		#define STR0028 "Evaluation was not answered "
		#define STR0029 "It is not possible to evaluate the Requirements without Evaluation Criteria"
		#define STR0030 "Requirement"
		#define STR0031 "Tp Requirement"
		#define STR0032 "There is an evaluation registered with the code: "
		#define STR0033 "It is not possible to evaluate the Requirements without Evaluation Criteria"
	#else
		#define STR0001 "Avalia��o de Requisitos"
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Procura", "Demanda" )
		#define STR0008 "Tema"
		#define STR0009 "Data Emiss�o"
		#define STR0010 "Tipo Requisito"
		#define STR0011 "Data Avalia��o"
		#define STR0012 "Avalia��es"
		#define STR0013 "Avalia��o"
		#define STR0014 "Descri��o"
		#define STR0015 "Peso"
		#define STR0016 "Resultado"
		#define STR0017 "Total"
		#define STR0018 "Opc�es"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Federal", "FEDERAL" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Estadual", "ESTADUAL" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Municipal", "MUNICIPAL" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Accionista", "ACIONISTA" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Comunidade", "COMUNIDADE" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Outros", "OUTROS" )
		#define STR0025 "C�digo"
		#define STR0026 "Respostas"
		#define STR0027 "Peso %"
		#define STR0028 "N�o foi respondido a avalia��o "
		#define STR0029 "N�o ser� poss�vel avaliar os requisitos sem Criterios de Avalia��o"
		#define STR0030 "Requisito"
		#define STR0031 "Tipo Requisito"
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "J� existe uma avalia��o registada com o c�digo: ", "J� existe uma avalia��o cadastrada com o c�digo: " )
		#define STR0033 "N�o ser� poss�vel avaliar os Requisitos sem Criterios de Avalia�ao"
	#endif
#endif
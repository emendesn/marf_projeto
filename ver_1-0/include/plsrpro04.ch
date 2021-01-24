#ifdef SPANISH
	#define STR0001 "Este informe tiene como objetivo imprimir la Informacion de los Pacientes del Programa de la Promocion de salud."
	#define STR0002 "Asegurado"
	#define STR0003 "Nombre"
	#define STR0004 "Edad"
	#define STR0005 "Fch.Elegibilidad"
	#define STR0006 "Fch.Inscripcion"
	#define STR0007 "Fch.Alta"
	#define STR0008 "Motivo Alta"
	#define STR0009 "Empresa"
	#define STR0010 "Descripcion"
	#define STR0011 "Plan"
	#define STR0012 "Descripcion"
	#define STR0013 " anos"
	#define STR0014 "Consulta(s) Realizada(s): "
	#define STR0015 "No se presento en consulta(s): "
	#define STR0016 "Procedimiento(s) realizado(s): "
	#define STR0017 "Inicio de planificacion el: "
	#define STR0018 "Final de planificacion el: "
	#define STR0019 "Grado de riesgo inicial: "
	#define STR0020 "Grado de riesgo final: "
	#define STR0021 "Motivo de elegibilidad: "
	#define STR0022 "Programa"
	#define STR0023 "Prof.Resp"
	#define STR0024 "Cod. Pregunta"
	#define STR0025 "ResCar Inicial"
	#define STR0026 "ResCar Final"
	#define STR0027 "ResNº Inicial"
	#define STR0028 "ResNº Final"
	#define STR0029 "ResFc Inicial"
	#define STR0030 "ResFc Final"
	#define STR0031 "Programa"
	#define STR0032 "Prof.Resp"
	#define STR0033 "Cod. Pregunta"
	#define STR0034 "ResMemo Inicial"
	#define STR0035 "ResMemo Final"
	#define STR0036 "¿De programa?                    "
	#define STR0037 "¿A programa?                    "
	#define STR0038 "Informe el programa inicial que"
	#define STR0039 " que se filtrara Generacion del informe"
	#define STR0040 "Informe el Programa final que"
	#define STR0041 " que se filtrara Generacion del informe"
#else
	#ifdef ENGLISH
		#define STR0001 "This report aims to print data on patients of the Health Promotion Program."
		#define STR0002 "Life"
		#define STR0003 "Name"
		#define STR0004 "Age"
		#define STR0005 "Eligibility Dt."
		#define STR0006 "Registration Dt."
		#define STR0007 "Discharge Dt."
		#define STR0008 "Discharge Reason"
		#define STR0009 "Company"
		#define STR0010 "Description"
		#define STR0011 "Plan"
		#define STR0012 "Description"
		#define STR0013 " years"
		#define STR0014 "Appointment(s) Attended: "
		#define STR0015 "Did not attend appointment(s): "
		#define STR0016 "Procedure(s) Performed: "
		#define STR0017 "Planning starts on: "
		#define STR0018 "Planning ends on: "
		#define STR0019 "Initial Risk Level: "
		#define STR0020 "Final Risk Level: "
		#define STR0021 "Elegibility Reason: "
		#define STR0022 "Program"
		#define STR0023 "Resp Prof."
		#define STR0024 "Question Code"
		#define STR0025 "Initial ResCar"
		#define STR0026 "Final ResCar"
		#define STR0027 "Initial ResNum"
		#define STR0028 "Final ResNum"
		#define STR0029 "Initial ResDt"
		#define STR0030 "Final ResDt"
		#define STR0031 "Program"
		#define STR0032 "Resp Prof."
		#define STR0033 "Question Code"
		#define STR0034 "Initial ResMemo"
		#define STR0035 "Final ResMemo"
		#define STR0036 "Program from?                    "
		#define STR0037 "Program to?                    "
		#define STR0038 "Enter the initial program"
		#define STR0039 " to be filtered Report Generation"
		#define STR0040 "Enter the final program"
		#define STR0041 " to be filtered Report Generation"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Este relatorio tem por objetivo a impressao das Informações dos Pacientes do Programa da Promoção da Saúde." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Vida" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Nome" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Idade" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Dt.Elegibilidade" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Dt.Inscrição" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Dt.Alta" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Motivo Alta" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Empresa" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Descrição" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Plano" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Descrição" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , " anos" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Consulta(s) Realizada(s): " )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Não Compareceu em Consulta(s): " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Procedimento(s) Realizado(s): " )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Inicio do Planejamento em: " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Fim do Planejamento em: " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Grau de Risco Inicial: " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Grau de Risco Final: " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Motivo da Elegibilidade: " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Programa" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Prof.Resp" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Cod. Pergunta" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "ResCar Inicial" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "ResCar Final" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "ResNum Inicial" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "ResNum Final" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "ResDt Inicial" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "ResDt Final" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Programa" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Prof.Resp" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Cod. Pergunta" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "ResMemo Inicial" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "ResMemo Final" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Programa de ?                    " )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Programa ate?                    " )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "Informe o Programa Inicial que" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , " que será filtrado Geração do Relatorio" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", , "Informe o Programa Final que" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", , " que será filtrado Geração do Relatorio" )
	#endif
#endif

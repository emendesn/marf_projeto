#ifdef SPANISH
	#define STR0001 "Error"
	#define STR0002 "Participante no encontrado"
	#define STR0003 "No existen preguntas registradas para la evaluacion actual."
	#define STR0004 "Evaluacion de desempeno"
	#define STR0005 "¡Respuestas grabadas con exito!"
	#define STR0006 "Falla en la grabacion"
	#define STR0007 "¡Respuestas grabadas y evaluacion finalizada con exito!"
	#define STR0008 " - Incompleta"
	#define STR0009 "¡Evaluacion grabada y no finalizada por existir preguntas sin respuesta!"
	#define STR0010 "Evaluacion de desempeno Web - Inclusion"
	#define STR0011 "No existen evaluaciones para el participante conectado"
	#define STR0012 "Inclusion - Error"
	#define STR0013 "El evaluador debe ser diferente del evaluado."
	#define STR0014 "Inclusion"
	#define STR0015 "Inclusion efectuada con exito."
	#define STR0016 "El período debe rellenarse antes de esta consulta."
	#define STR0017 "Informe el filtro para busqueda"
	#define STR0018 "Evaluacion de Desempeno en Proyecto"
	#define STR0019 "Pendencias"
	#define STR0020 "Consulta"
#else
	#ifdef ENGLISH
		#define STR0001 "Error"
		#define STR0002 "Participant not found  "
		#define STR0003 "No questions registered for current evaluation. "
		#define STR0004 "Evaluation of performance"
		#define STR0005 "Answers saved successfully"
		#define STR0006 "Failure saving "
		#define STR0007 "Answers saved and evaluation finished successfully! "
		#define STR0008 " - Incomplete"
		#define STR0009 "Evaluation saved but unfinished because there are questions without an answer!"
		#define STR0010 "Evaluation of performance web - addition"
		#define STR0011 "No evaluations for the participant logged in "
		#define STR0012 "Addition - Error"
		#define STR0013 "Evaluator must be different from the evaluated."
		#define STR0014 "Addition"
		#define STR0015 "Addition made successfuly. "
		#define STR0016 "The period must be completed before this consultation."
		#define STR0017 "Enter filter for search "
		#define STR0018 "Performance Evaluation in Project"
		#define STR0019 "Pending Issues"
		#define STR0020 "Query"
	#else
		#define STR0001 "Erro"
		#define STR0002 "Participante não encontrado"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Não existem questões registadas para a avaliação atual.", "Não existem questões cadastradas para a avaliação atual." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Avaliação de desempenho", "Avaliação de Desempenho" )
		#define STR0005 "Respostas gravadas com sucesso!"
		#define STR0006 "Falha na gravação"
		#define STR0007 "Respostas gravadas e avaliação finalizada com sucesso!"
		#define STR0008 " - Incompleta"
		#define STR0009 "Avaliação gravada e não finalizada por existirem questões sem resposta!"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Avaliação de performance web - inclusão", "Avaliação de Performance Web - Inclusão" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Não existem avaliações para o participante registado", "Não existem avaliações para o participante logado" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Inclusão - erro", "Inclusão - Erro" )
		#define STR0013 "O avaliador deve ser diferente do avaliado."
		#define STR0014 "Inclusão"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Inclusão efectuada com sucesso.", "Inclusão efetuada com sucesso." )
		#define STR0016 "O período deve ser preenchido antes desta consulta."
		#define STR0017 "Informe o filtro para pesquisa"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Avaliação de desempenho em projecto", "Avaliação de Desempenho em Projeto" )
		#define STR0019 "Pendências"
		#define STR0020 "Consulta"
	#endif
#endif

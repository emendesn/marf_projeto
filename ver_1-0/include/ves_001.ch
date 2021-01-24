#ifdef SPANISH
	#define STR0001 "Preenchimento Incompleto!"
	#define STR0002 "- Escolha o local/opção"
	#define STR0003 "Não existem opções para este local"
	#define STR0004 "Inscrição"
	#define STR0005 "Seleção de Cursos"
	#define STR0006 "Processo Seletivo"
	#define STR0007 "Selecione"
	#define STR0008 "Local da Prova"
	#define STR0009 "Local"
	#define STR0010 "opcao"
	#define STR0011 "Curso"
	#define STR0012 "Nenhum"
	#define STR0013 "continuar"
	#define STR0014 "Curso/Unidad donde se ofrece"
	#define STR0015 "No existe Proceso de Seleccion Disponible"
	#define STR0016 "Volver"
#else
	#ifdef ENGLISH
		#define STR0001 "Preenchimento Incompleto!"
		#define STR0002 "- Escolha o local/opção"
		#define STR0003 "Não existem opções para este local"
		#define STR0004 "Inscrição"
		#define STR0005 "Seleção de Cursos"
		#define STR0006 "Processo Seletivo"
		#define STR0007 "Selecione"
		#define STR0008 "Local da Prova"
		#define STR0009 "Local"
		#define STR0010 "opcao"
		#define STR0011 "Curso"
		#define STR0012 "Nenhum"
		#define STR0013 "continuar"
		#define STR0014 "Course/Unit where it is offered"
		#define STR0015 "No selection process available"
		#define STR0016 "Back"
	#else
		#define STR0001 "Preenchimento Incompleto!"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "- escolha o local/opção", "- Escolha o local/opção" )
		#define STR0003 "Não existem opções para este local"
		#define STR0004 "Inscrição"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Selecção De Cursos", "Seleção de Cursos" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Processo Selectivo", "Processo Seletivo" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Seleccionar", "Selecione" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Local Da Prova", "Local da Prova" )
		#define STR0009 "Local"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Opção", "opcao" )
		#define STR0011 "Curso"
		#define STR0012 "Nenhum"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Continuar", "continuar" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Curso/unidade em que é oferecido", "Curso/Unidade em que é oferecido" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Não Existe Processo Selectivo Disponível", "Não existe Processo Seletivo Disponível" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Voltar atrás", "Voltar" )
	#endif
#endif

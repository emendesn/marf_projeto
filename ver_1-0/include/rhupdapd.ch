#ifdef SPANISH
	#define STR0001 "Creacion del parametro MV_APDVDAT"
	#define STR0002 "Actualizacion de la tabla RD6"
	#define STR0003 "Ajuste de la tabla de items de la agenda de evaluaciones (RDP)"
	#define STR0004 "Creacion del parametro MV_SQODISS"
	#define STR0005 "Creacion del parametro MV_APDMULT"
	#define STR0006 "Creacion de nuevos campos 'Justificativa' y 'Descripcion de Competencia"
	#define STR0007 "Creacion del parametro MV_APDASSM"
	#define STR0008 "Creación del campo RD0_TPDEFF 'PCD - persona discapacitada' "
	#define STR0009 "Creación del campo RD0_PIS"
	#define STR0010 "Creación del campo Cod. Agenda de Schedule (RD6_AGDSCH) y Cód. Agenda de envío (RD6_AGDENV) en la tabla RD6"
#else
	#ifdef ENGLISH
		#define STR0001 "MV_APDVDAT parameter creation"
		#define STR0002 "RD6 table update"
		#define STR0003 "Evaluation Schedule Items Table Adjustment (RDP)"
		#define STR0004 "MV_SQODISS parameter creation"
		#define STR0005 "MV_APDVMULT parameter creation"
		#define STR0006 "Creation of new fields 'Justification' and 'Competence Description'"
		#define STR0007 "Creation of the parameter MV_APDASSM"
		#define STR0008 "Creation of field RD0_TPDEFF 'PCD - disable "
		#define STR0009 "Creation of field RD0_PIS"
		#define STR0010 "Creation of field Schedule Apppoint. Cod. (RD6_AGDSCH) and Submit Appoint. Cod. (RD6_AGDENV) on table RD6"
	#else
		#define STR0001 "Criação do parâmetro MV_APDVDAT"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Actualização da tabela RD6", "Atualização da tabela RD6" )
		#define STR0003 "Ajuste da Tabela Itens Agenda de Avaliações (RDP)"
		#define STR0004 "Criação do parâmetro MV_SQODISS"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Criação do parâmetro MV_APDMULT", "Criaçao do parâmetro MV_APDMULT" )
		#define STR0006 "Criação dos novos campos 'Justificativa' e 'Descrição de Competência"
		#define STR0007 "Criacao do parametro MV_APDASSM"
		#define STR0008 "Criacao do campo RD0_TPDEFF 'PCD - pessoa com deficiencia' "
		#define STR0009 "Criaçao do campo RD0_PIS"
		#define STR0010 "Criação do campo Cod. Agend de Schedule (RD6_AGDSCH) e Cod. Agend. De Envio (RD6_AGDENV) na tabela RD6"
	#endif
#endif

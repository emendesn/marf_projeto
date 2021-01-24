#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Alterar"
	#define STR0005 "Excluir"
	#define STR0006 "Turno de Beneficiaci�n"
	#define STR0007 "Imposible incluir este registro, pues superpone la Fecha y Hora de otro registro."
	#define STR0008 "Imposible alterar este registro, pues superpone la Fecha y Hora de otro registro."
	#define STR0009 "�Est� seguro que desea excluir el registro? "
	#define STR0010 "�Atenci�n! "
	#define STR0011 "Este registro tiene movimientos y no se podr� excluir."
	#define STR0012 "ATENCI�N"
	#define STR0013 "Fecha invalida. Fecha Final menor que fecha Inicial."
	#define STR0014 "Horario invalido. Hora Final menor que hora Inicial"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Modify"
		#define STR0005 "Delete"
		#define STR0006 "Improvement Turn"
		#define STR0007 "This record cannot be added, as it overrides another record's Date and Time."
		#define STR0008 "This record cannot be Modified, as it overrides another record's Date and Time."
		#define STR0009 "Are you sure you wish to delete the record"
		#define STR0010 "Attention! "
		#define STR0011 "This record is active and cannot be deleted."
		#define STR0012 "ATTENTION"
		#define STR0013 "Date not valid. Final date earlier than Initial date."
		#define STR0014 "Time not valid. Final time earlier than Initial time"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 "Turno de Beneficiamento"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Este registo n�o pode ser inclu�do, pois est� a sobrepor Data e Hora de outro registo.", "Este registro n�o pode ser incluido, pois est� sobrepondo Data e Hora de outro registro." )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Este registo n�o pode ser Alterado, pois est� a sobrepor Data e Hora de outro registo.", "Este registro n�o pode ser Alterado, pois est� sobrepondo Data e Hora de outro registro." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Tem certeza que deseja excluir o registo", "Tem certeza que deseja excluir o registro" )
		#define STR0010 "Aten��o! "
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Este registo possui movimenta��o e n�o pode ser exclu�do.", "Este registro possui movimentacao, e nao pode ser excluido." )
		#define STR0012 "ATEN��O"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Data inv�lida. Data final menor que a data inicial.", "Data invalida. Data Final � menor que a data Inicial." )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Hor�rio inv�lido. Hora final menor que hora inicial", "Horario invalido. Hora Final � menor que hora Inicial" )
	#endif
#endif

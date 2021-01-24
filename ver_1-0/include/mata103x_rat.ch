#ifdef SPANISH
	#define STR0001 "Seleccion de prorrateo preconfigurado"
	#define STR0002 "Atencion"
	#define STR0003 "Este item tiene prorrateo. �Desea borrar el prorrateo digitado?"
	#define STR0004 "No"
	#define STR0005 "Prorrateo por centro de costo"
	#define STR0006 "% Prorrateado: "
	#define STR0007 "% Por prorratear: "
	#define STR0008 "Atencion"
	#define STR0009 "No"
	#define STR0010 "�Copiar la informacion en los otros items del documento?"
	#define STR0011 "Todos"
	#define STR0012 "�El prorrateo externo esta con el registro bloqueado!"
	#define STR0013 "Verifique el prorrateo del item: "
#else
	#ifdef ENGLISH
		#define STR0001 "Pre-configured Apportionment Selection"
		#define STR0002 "Attention"
		#define STR0003 "This item has apportionment, delete the apportionment entered ?"
		#define STR0004 "No"
		#define STR0005 "Apportionment per Cost Center"
		#define STR0006 "% Apportioned: "
		#define STR0007 "% to be Apportioned: "
		#define STR0008 "Attention"
		#define STR0009 "No"
		#define STR0010 "Replicate information for the other document items?"
		#define STR0011 "All"
		#define STR0012 "External Apportionment with blocked record !"
		#define STR0013 "Check apportionment item: "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Escolha de Rateio Pre-Configurado" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Atencao" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Este item possue rateio, deseja excluir o rateio digitado ?" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Nao" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Rateio por Centro de Custo" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "% Rateada: " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "% A Ratear: " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Atencao" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "N�o" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Replicar informa��es para os demais itens do documento?" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Todos" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Rateio Externo est� com o registro bloqueado !" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Verifique o rateio do Item: " )
	#endif
#endif

#ifdef SPANISH
	#define STR0001 "Cierre de Seguro"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Cerrar"
	#define STR0005 "Modificar"
	#define STR0006 "Revertir"
	#define STR0007 "Confirmar"
	#define STR0008 "�Confirma el Procesamiento?"
	#define STR0009 "Atencion"
	#define STR0010 "Seleccionando Documentos ..."
	#define STR0011 "Prima Determinada"
	#define STR0012 "Leyenda"
	#define STR0013 "Estatus"
	#define STR0014 "Pendiente"
	#define STR0015 "Confirmado"
	#define STR0016 "TOTAL DE LA PRIMA"
	#define STR0017 'Declaracion'
	#define STR0018 'Declar.'
	#define STR0019 "Declaracion de seguro"
	#define STR0020 "Ctd. Doctos."
#else
	#ifdef ENGLISH
		#define STR0001 "Closing of insurance"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Close "
		#define STR0005 "Modify"
		#define STR0006 "Cancel"
		#define STR0007 "Confirm  "
		#define STR0008 "Confirm processing?       "
		#define STR0009 "Note"
		#define STR0010 "Selecting documents...     "
		#define STR0011 "Premium calc. "
		#define STR0012 "Legend"
		#define STR0013 "Status"
		#define STR0014 "Pending  "
		#define STR0015 "Confirmed "
		#define STR0016 "PREMIUM TOTAL  "
		#define STR0017 'Registration'
		#define STR0018 'Regist.'
		#define STR0019 "Insurance Registration"
		#define STR0020 "Document Qty."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Fechamento De Seguro", "Fechamento de Seguro" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Fechar"
		#define STR0005 "Alterar"
		#define STR0006 "Estornar"
		#define STR0007 "Confirmar"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Confirma o processamento ?", "Confirma o Processamento ?" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Atencao" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "A seleccionar documentos ...", "Selecionando Documentos ..." )
		#define STR0011 "Premio Apurado"
		#define STR0012 "Legenda"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Estado", "Status" )
		#define STR0014 "Em Aberto"
		#define STR0015 "Confirmado"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Total do premio", "TOTAL DO PR�MIO" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", 'Averbamento', 'Averbacao' )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", 'Averb.', 'Averb' )
		#define STR0019 "Averba��o de seguro"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Qtd. Doct.", "Qtd. Doctos." )
	#endif
#endif

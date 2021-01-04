#ifdef SPANISH
	#define STR0001 "Verificando ganadores..."
	#define STR0002 "Edital Revocado/Anulado. No se puede emitir el informe"
	#define STR0003 "En la etapa actual del Edital, no hay vencedores seleccionados "
	#define STR0004 "Lote "
#else
	#ifdef ENGLISH
		#define STR0001 "Checking Winners..."
		#define STR0002 "Public notice Canceled/Revoked. Report cannot be issued"
		#define STR0003 "There are no winners at this stage of the Public Bid Notification "
		#define STR0004 "Lot "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "A verificar ganhadores...", "Verificando ganhadores..." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Edital revogado/cancelado. N�o � poss�vel emitir o relat�rio", "Edital Revogado/Cancelado, n�o � poss�vel emitir o relat�rio" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Na etapa actual do Edital, n�o h� vencedores seleccionados ", "Na etapa atual do Edital, n�o h� vencedores selecionados " )
		#define STR0004 "Lote "
	#endif
#endif

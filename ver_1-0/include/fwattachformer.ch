#ifdef SPANISH
	#define STR0001 "Usted esta utilizando un periodo y una categoria. Utilice solamente una de las dos para este tipo de grafico."
	#define STR0002 "Usted esta utilizando mas de una serie para este grafico. Utilice solamente una."
	#define STR0003 "Tipos de graficos"
	#define STR0004 "Ene/"
	#define STR0005 "Feb/"
	#define STR0006 "Mar/"
	#define STR0007 "Abr/"
	#define STR0008 "May/"
	#define STR0009 "Jun/"
	#define STR0010 "Jul/"
	#define STR0011 "Ago/"
	#define STR0012 "Sept/"
	#define STR0013 "Oct/"
	#define STR0014 "Nov/"
	#define STR0015 "Dic/"
	#define STR0016 "Campos obligatorios no rellenados. Revise los datos antes de confirmar."
	#define STR0017 "Tipos de graficos"
	#define STR0018 "Configuracion"
	#define STR0019 "Mascara (Antes):"
	#define STR0020 "Mascara (Despues):"
	#define STR0021 "Confirmar"
	#define STR0022 "Anular"
#else
	#ifdef ENGLISH
		#define STR0001 "You are using a period and a category. Only use one of them for this type of chart."
		#define STR0002 "You are using more than one series for this chart. Use only one."
		#define STR0003 "Chart Types"
		#define STR0004 "Jan/"
		#define STR0005 "Feb/"
		#define STR0006 "Mar/"
		#define STR0007 "Apr/"
		#define STR0008 "May/"
		#define STR0009 "Jun/"
		#define STR0010 "Jul/"
		#define STR0011 "Aug/"
		#define STR0012 "Sept/"
		#define STR0013 "Oct/"
		#define STR0014 "Nov/"
		#define STR0015 "Dec/"
		#define STR0016 "Required fields not filled out. Check data before confirming them."
		#define STR0017 "Chart Types"
		#define STR0018 "Configuration"
		#define STR0019 "Mask(Before):"
		#define STR0020 "Mask(After):"
		#define STR0021 "Confirm"
		#define STR0022 "Cancel"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Você está utilizando um período e uma categoria. Utilize somente uma das duas para este tipo de gráfico." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Você está utilizando mais de uma série para este gráfico. Utilize somente uma." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Tipos de Gráficos" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Jan/" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Fev/" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Mar/" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Abr/" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Mai/" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Jun/" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Jul/" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Ago/" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Set/" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Out/" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Nov/" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Dez/" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Campos obrigatórios não preenchidos. Revise os dados antes de confirmar" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Tipos de Gráficos" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Configuração" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Mascara(Antes):" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Mascara(Depois):" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Confirmar" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Cancelar" )
	#endif
#endif

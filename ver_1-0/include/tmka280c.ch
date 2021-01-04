#ifdef SPANISH
	#define STR0001 " Titulos Negociados en la Ultima Atencion"
	#define STR0002 " Totales de la Negociacion"
	#define STR0003 "Deducciones"
	#define STR0004 "Corr. Monet."
	#define STR0005 "Intereses"
	#define STR0006 "Descuentos"
	#define STR0007 "Aumentos"
	#define STR0008 "Reducciones"
	#define STR0009 "Sld Mda Tit."
	#define STR0010 "Sld Mda Corr."
	#define STR0011 "Valor Original"
	#define STR0012 "Pago Parcial"
	#define STR0013 "Deud Mda Tit"
	#define STR0014 "Deud Mda Corr"
#else
	#ifdef ENGLISH
		#define STR0001 " Bills Negotiated Last Attendance"
		#define STR0002 " Negotiation Total"
		#define STR0003 "Deductions"
		#define STR0004 "Monet. Adj."
		#define STR0005 "Interests"
		#define STR0006 "Deductions"
		#define STR0007 "Increases"
		#define STR0008 "Decreases"
		#define STR0009 "Bal Mda Tit."
		#define STR0010 "Bal Mda Corr."
		#define STR0011 "Original Value"
		#define STR0012 "Partial Paymt"
		#define STR0013 "Debt Bill Ccy"
		#define STR0014 "Debt Curr Ccy"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", " Títulos Negociados No último Atendimento", " Títulos Negociados no Último Atendimento" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", " totais da negociação", " Totais da Negociação" )
		#define STR0003 "Abatimentos"
		#define STR0004 "Corr. Monet."
		#define STR0005 "Juros"
		#define STR0006 "Descontos"
		#define STR0007 "Acréscimos"
		#define STR0008 "Decréscimos"
		#define STR0009 "Sld Mda Tit."
		#define STR0010 "Sld Mda Corr."
		#define STR0011 "Valor Original"
		#define STR0012 "Pagto Parcial"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Div Mda Tit", "Dív Mda Tít" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Div Mda Corr", "Dív Mda Corr" )
	#endif
#endif

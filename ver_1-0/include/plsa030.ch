#ifdef SPANISH
	#define STR0001 "Visualizar"
	#define STR0002 "Complemento de Operadora de Salud"
	#define STR0003 "Complemento de Operadora de Salud - "
	#define STR0004 "Operadora de Salud"
	#define STR0005 "Intercambio Eventual Especifico"
	#define STR0006 "Parametros para Pago"
	#define STR0007 "Tablas de Pago y Cobranza"
	#define STR0008 "Parametros Pago"
	#define STR0009 "Parametros Pago vs. Procedimientos"
	#define STR0010 "Item no se podr� grabar porque no se rellenaron los parametros de la Operadora vs.Tp.Prest.vs.Pago(BMB)."
	#define STR0011 "Procedimento j� cadastrado"
#else
	#ifdef ENGLISH
		#define STR0001 "Visualizar"
		#define STR0002 "Complemento de Operadora de Saude"
		#define STR0003 "Complemento de Operadora de Saude - "
		#define STR0004 "Operadora de Saude"
		#define STR0005 "Intercambio Eventual Especifico"
		#define STR0006 "Parametros para Pagamento"
		#define STR0007 "Tabelas de Pagamento e Recebimento"
		#define STR0008 "Parametros Pagamento"
		#define STR0009 "Parametros Pagamento  X Procedimentos"
		#define STR0010 "Item can not be saved due to Operators parameters versus Tp Prov. versus Payment(BMB) are not filled out."
		#define STR0011 "Procedure already registered."
	#else
		#define STR0001 "Visualizar"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Complemento De Operadora De Sa�de", "Complemento de Operadora de Saude" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Complemento de operadora de sa�de - ", "Complemento de Operadora de Saude - " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Operadora De Sa�de", "Operadora de Saude" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Interc�mbio Eventual Espec�fico", "Intercambio Eventual Especifico" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Par�metros Para Pagamento", "Parametros para Pagamento" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Tabelas De Pagamento E Recebimento", "Tabelas de Pagamento e Recebimento" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Par�metros De Pagamento", "Parametros Pagamento" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Par�metros De Pagamento  X Procedimentos", "Parametros Pagamento  X Procedimentos" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "O item n�o poder� ser gravado porque os par�mentros da Operadora vs.Tp.Prest.vs.Pago(BMB) n�o est�o preenchidos.", "Item n�o poder� ser gravado devido os par�mentros da Operadora vs.Tp.Prest.vs.Pago(BMB) n�o estarem preenchidos." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Procedimento j� registado.", "Procedimento j� cadastrado" )
	#endif
#endif

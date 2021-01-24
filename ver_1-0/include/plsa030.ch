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
	#define STR0010 "Item no se podrá grabar porque no se rellenaron los parametros de la Operadora vs.Tp.Prest.vs.Pago(BMB)."
	#define STR0011 "Procedimento já cadastrado"
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
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Complemento De Operadora De Saúde", "Complemento de Operadora de Saude" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Complemento de operadora de saúde - ", "Complemento de Operadora de Saude - " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Operadora De Saúde", "Operadora de Saude" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Intercâmbio Eventual Específico", "Intercambio Eventual Especifico" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Parâmetros Para Pagamento", "Parametros para Pagamento" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Tabelas De Pagamento E Recebimento", "Tabelas de Pagamento e Recebimento" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Parâmetros De Pagamento", "Parametros Pagamento" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Parâmetros De Pagamento  X Procedimentos", "Parametros Pagamento  X Procedimentos" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "O item não poderá ser gravado porque os parâmentros da Operadora vs.Tp.Prest.vs.Pago(BMB) não estão preenchidos.", "Item não poderá ser gravado devido os parâmentros da Operadora vs.Tp.Prest.vs.Pago(BMB) não estarem preenchidos." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Procedimento já registado.", "Procedimento já cadastrado" )
	#endif
#endif

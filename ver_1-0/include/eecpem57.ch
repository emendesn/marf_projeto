#ifdef SPANISH
	#define STR0001 "Nº Cuota"
	#define STR0002 "Fch. Venc."
	#define STR0003 "Vlr. Cuota"
	#define STR0004 "DRAWN UNDER IRREVOCABLE L / C NO. "
	#define STR0005 " OF "
	#define STR0006 "OUR COMMERCIAL INVOICE Nº "
	#define STR0007 "AT "
	#define STR0008 " pay this First Bill of Exchange ( Second and Third Unpaid) to the order of "
	#define STR0009 " pay this Second Bill of Exchange ( First and Third Unpaid) to the order of "
	#define STR0010 " pay this Third Bill of Exchange (First and Second Unpaid) to the order of "
	#define STR0011 "Vencimiento"
	#define STR0012 "Retiro Pr. Fijo"
	#define STR0013 "Cond. Pago"
	#define STR0014 "Value"
	#define STR0015 "Fecha"
	#define STR0016 "Prov. / Banco"
	#define STR0017 "To"
	#define STR0018 "Exportador"
	#define STR0019 "At Sight"
#else
	#ifdef ENGLISH
		#define STR0001 "Installment Number"
		#define STR0002 "Due Date"
		#define STR0003 "Inst. Value"
		#define STR0004 "DRAWN UNDER IRREVOCABLE L/C NO. "
		#define STR0005 " OF "
		#define STR0006 "OUR COMMERCIAL INVOICE NR. "
		#define STR0007 "AT "
		#define STR0008 " pay this First Bill of Exchange (Second and Third Unpaid) to the order of "
		#define STR0009 " pay this Second Bill of Exchange ( First and Third Unpaid) to the order of "
		#define STR0010 " pay this Third Bill of Exchange (First and Second Unpaid) to the order of "
		#define STR0011 "Validity"
		#define STR0012 "Draft Fixed Pr"
		#define STR0013 "Paym. Term"
		#define STR0014 "Value"
		#define STR0015 "Date"
		#define STR0016 "Supp./Bank"
		#define STR0017 "To"
		#define STR0018 "Exporter"
		#define STR0019 "At Sight"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Nº. Parcela", "Nr. Parcela" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Dt. Venct.", "Dt. Vencto" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Valor Da Parcela", "Vlr. Parcela" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Delineado de acordo com o l/c inalterável núm. ", "DRAWN UNDER IRREVOCABLE L/C NO. " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", " of ", " OF " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "O nosso recibo comercial núm. ", "OUR COMMERCIAL INVOICE NR. " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "At ", "AT " )
		#define STR0008 " pay this First Bill of Exchange ( Second and Third Unpaid) to the order of "
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " pagar esta segunda letra de câmbio ( primeira e terceira não pagas) à ordem de ", " pay this Second Bill of Exchange ( First and Third Unpaid) to the order of " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", " pagar esta terceira letra de câmbio (primeira e segunda não pagas) à ordem de ", " pay this Third Bill of Exchange (First and Second Unpaid) to the order of " )
		#define STR0011 "Vencimento"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Levantamento Pr. Fixo", "Saque Pr. Fixo" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Condição De Pagamento", "Cond. Pagto" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Valor", "Value" )
		#define STR0015 "Data"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Forn./banco", "Forn./Banco" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Para", "To" )
		#define STR0018 "Exportador"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "à Vista", "At Sight" )
	#endif
#endif

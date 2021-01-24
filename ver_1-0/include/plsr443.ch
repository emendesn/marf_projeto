#ifdef SPANISH
	#define STR0001 "Registros de Comis. de Vendedores "
	#define STR0002 "Contratos por Titulos"
	#define STR0003 "Informe - Libro III - ANS"
	#define STR0004 "Nº Sec"
	#define STR0005 "Numero del Evento"
	#define STR0006 "Contrato"
	#define STR0007 "Mod"
	#define STR0008 "Cob"
	#define STR0009 "Emision"
	#define STR0010 "Pago"
	#define STR0011 "Nom del Agente"
	#define STR0012 "CNPJ/CGC"
	#define STR0013 "Pago"
	#define STR0014 "Evento"
	#define STR0015 " Vct Ctr."
	#define STR0016 "Valor Base"
	#define STR0017 "Val Comision"
	#define STR0018 "Titular/Depend."
	#define STR0019 "Valor"
	#define STR0020 "Int. "
	#define STR0021 "Costo"
	#define STR0022 "Val Total"
	#define STR0023 "Emitidos"
	#define STR0024 "LIBRO AUXILIAR Nº "
	#define STR0025 "Pagados"
	#define STR0026 "Anullados"
	#define STR0027 " "
	#define STR0028 "Total Anullado "
	#define STR0029 "Modalid.: 1 INDIVIDUAL                 Cobertura: 001 AMBULATORIA "
	#define STR0030 "          2 FAMILIAR                              002 HOSPITALARIA CON OBSTETR. "
	#define STR0031 "          4 COLECTIVO EMPRESARIAL                 004 ODONTOLOGICO"
	#define STR0032 "                                                  005 REFERENCIA"
	#define STR0033 "                                                  006 AMBULATORIA + HOSPITALARIA CON OBSTETRIC."
	#define STR0034 "                                                  007 AMBULATORIA + HOSPITALARIA SIN OBSTETRIC."
	#define STR0035 "                                                  008 AMBULATORIA + ODONTOLOGICO"
	#define STR0036 "                                                  010 AMBULATORIA CON OBSTETRICIA + ODONTOLOGICO"
	#define STR0037 "                                                  011 AMBULATORIA SIN OBSTETRICIA + ODONTOLOGICO"
	#define STR0038 "                                                  013 AMBULATORIA + HOSPITALARIA CON OBSTETRIC. + ODONTOLOGICO"
	#define STR0039 "                                                  014 AMBULATORIA + HOSPITALARIA SIN OBSTETRIC. + ODONTOLOGICO"
	#define STR0040 "Ocurrencias"
	#define STR0041 "Red Propia"
	#define STR0042 "Terceros"
	#define STR0043 "Total"
	#define STR0044 "Informe desarrollado en R4, verificar parametro TREPORT"
#else
	#ifdef ENGLISH
		#define STR0001 "Registration of Salesman Commissions"
		#define STR0002 "Bill Contracts"
		#define STR0003 "Report - Book III - ANS"
		#define STR0004 "Seq.Nr."
		#define STR0005 "Event Number"
		#define STR0006 "Agreement"
		#define STR0007 "Cov"
		#define STR0008 "Nat"
		#define STR0009 "Issue"
		#define STR0010 "Payment"
		#define STR0011 "Agent Name"
		#define STR0012 "CNPJ/CGC"
		#define STR0013 "Payment"
		#define STR0014 "Event"
		#define STR0015 " Ctr.Due"
		#define STR0016 "Base Value"
		#define STR0017 "Commis.Value"
		#define STR0018 "Holder/Dependent"
		#define STR0019 "Value"
		#define STR0020 "Interests"
		#define STR0021 "Cost"
		#define STR0022 "Total Value"
		#define STR0023 "Issued"
		#define STR0024 "SUBLEDGER NR. "
		#define STR0025 "Paid"
		#define STR0026 "Canceled"
		#define STR0027 " "
		#define STR0028 "Total Canceled "
		#define STR0029 "Nature: 1 INDIVIDUAL                 Coverage: 001 OUTPATIENT"
		#define STR0030 "          2 FAMILY                              002 HOSPITAL WITH OBSTETRICS"
		#define STR0031 "          4 BUSINESS COLLECTIVE                  004 ODONTOLOGY"
		#define STR0032 "                                                  005 REFERENCE"
		#define STR0033 "                                                  006 OUTPATIENT + HOSPITAL WITH OBSTETRICS"
		#define STR0034 "                                                  007 OUTPATIENT + HOSP.WITHOUT OBSTETRICS"
		#define STR0035 "                                                  008 OUTPATIENT + ODONTOLOGY"
		#define STR0036 "                                                  010 OUTPATIENT WITH OBSTETRICS + ODONTOLOGY"
		#define STR0037 "                                                  011 OUTPATIENT WITHOUT OBSTETR.+ ODONTOLOGY"
		#define STR0038 "                                                  013 OUTPATIENT + HOSPITAL WITH OBSTETRICS + ODONTOLOGY"
		#define STR0039 "                                                  014 OUTPATIENT + HOSP.WITHOUT OBSTETRICS + ODONTOLOGY"
		#define STR0040 "Occurrences"
		#define STR0041 "Own Network"
		#define STR0042 "Third Parties"
		#define STR0043 "Total"
		#define STR0044 "Report developed in R4, check the parameter TREPORT"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registos de Comissões de Vendedores", "Registros de Comissoes de Vendedores" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Contratos por Títulos", "Contratos por Titulos" )
		#define STR0003 "Relatório - Livro III - ANS"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Nr.Seq", "Nro Seq" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Número do Evento", "Numero do Evento" )
		#define STR0006 "Contrato"
		#define STR0007 "Nat"
		#define STR0008 "Cob"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Emissão", "Emissao" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Pagam.", "Pagamen." )
		#define STR0011 "Nome do Agente"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "NIF/CGC", "CNPJ/CGC" )
		#define STR0013 "Pagamento"
		#define STR0014 "Evento"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", " Venc.Ctr.", " Vct Ctr." )
		#define STR0016 "Valor Base"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Val.Comissão", "Vlr Comissao" )
		#define STR0018 "Titular/Dependente"
		#define STR0019 "Valor"
		#define STR0020 "Juros"
		#define STR0021 "Custo"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Val.Total", "Vlr Total" )
		#define STR0023 "Emitidos"
		#define STR0024 "LIVRO AUXILIAR NR. "
		#define STR0025 "Pagos"
		#define STR0026 "Cancelados"
		#define STR0027 " "
		#define STR0028 "Total Cancelado "
		#define STR0029 "Natureza: 1 INDIVIDUAL                 Cobertura: 001 AMBULATORIAL"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "          2 FAMILIAR                              002 HOSPITALAR COM OBSTETRÍCIA", "          2 FAMILIAR                              002 HOSPITALAR COM OBSTETRICIA" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "          4 COLECTIVO EMPRESARIAL                  004 ODONTOLÓGICO", "          4 COLETIVO EMPRESARIAL                  004 ODONTOLOGICO" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "                                                  005 REFERÊNCIA", "                                                  005 REFERENCIA" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "                                                  006 AMBULATORIAL + HOSPITALAR COM OBSTETRÍCIA", "                                                  006 AMBULATORIAL + HOSPITALAR COM OBSTETRICIA" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "                                                  007 AMBULATORIAL + HOSPITALAR SEM OBSTETRÍCIA", "                                                  007 AMBULATORIAL + HOSPITALAR SEM OBSTETRICIA" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "                                                  008 AMBULATORIAL + ODONTOLÓGICO", "                                                  008 AMBULATORIAL + ODONTOLOGICO" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "                                                  010 AMBULATORIAL COM OBSTETRÍCIA + ODONTOLÓGICO", "                                                  010 AMBULATORIAL COM OBSTETRICIA + ODONTOLOGICO" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "                                                  011 AMBULATORIAL SEM OBSTETRÍCIA + ODONTOLÓGICO", "                                                  011 AMBULATORIAL SEM OBSTETRICIA + ODONTOLOGICO" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "                                                  013 AMBULATORIAL + HOSPITALAR COM OBSTETRÍCIA + ODONTOLÓGICO", "                                                  013 AMBULATORIAL + HOSPITALAR COM OBSTETRICIA + ODONTOLOGICO" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "                                                  014 AMBULATORIAL + HOSPITALAR SEM OBSTETRÍCIA + ODONTOLÓGICO", "                                                  014 AMBULATORIAL + HOSPITALAR SEM OBSTETRICIA + ODONTOLOGICO" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Ocorrências", "Ococorrencias" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Rede Própria", "Rede Propria" )
		#define STR0042 "Terceiros"
		#define STR0043 "Total"
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Relatório desenvolvido em R4 verificar parâmetro TREPORT.", "Relatório desenvolvido em R4 verificar parametro TREPORT" )
	#endif
#endif

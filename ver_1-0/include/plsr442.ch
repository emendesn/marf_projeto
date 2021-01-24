#ifdef SPANISH
	#define STR0001 "Registro de Eventos y su Movimiento Financiero"
	#define STR0002 "Contratos por Titulos"
	#define STR0003 "Informe - Libro II - ANS"
	#define STR0004 "N� Sec"
	#define STR0005 "Numero del Evento"
	#define STR0006 "Contrato"
	#define STR0007 "Mod"
	#define STR0008 "Cob"
	#define STR0009 "Conoc."
	#define STR0010 "Pago"
	#define STR0011 "Nombre del Usuario Principal"
	#define STR0012 "CNPJ/CPF"
	#define STR0013 "Usuario del Evento"
	#define STR0014 "Evento"
	#define STR0015 " Vct Ctr."
	#define STR0016 "Valor"
	#define STR0017 "CPF Titular"
	#define STR0018 "Titular/Dependien."
	#define STR0019 "Valor"
	#define STR0020 "Inter"
	#define STR0021 "Costo"
	#define STR0022 "Val Total"
	#define STR0023 "Total Emitido"
	#define STR0024 "LIBRO AUXILIAR N� "
	#define STR0025 " "
	#define STR0026 " "
	#define STR0027 " "
	#define STR0028 "Total Cancelado "
	#define STR0029 "Modalid.: 1 INDIVIDUAL                 Cobertura: 001 AMBULATORIA"
	#define STR0030 "          2 FAMILIAR                              002 HOSPITALARIA CON OBSTETR. "
	#define STR0031 "          3 COLECTIVO EMPRESARIAL                  004 ODONTOLOGICO"
	#define STR0032 "                                                  005 REFERENCIA"
	#define STR0033 "                                                  006 AMBULATORIA + HOSPITALARIA CON OBSTETRIC."
	#define STR0034 "                                                  007 AMBULATORIA + HOSPITALARIA SIN OBSTETRIC."
	#define STR0035 "                                                  008 AMBULATORIA + ODONTOLOGICO"
	#define STR0036 "                                                  010 AMBULATORIA CON OBSTETRICIA + ODONTOLOGICO"
	#define STR0037 "                                                  011 AMBULATORIA SIN OBSTETRICIA + ODONTOLOGICO"
	#define STR0038 "                                                  013 AMBULATORIA + HOSPITALARIA CON OBSTETRIC. + ODONTOLOGICO"
	#define STR0039 "                                                  014 AMBULATORIA + HOSPITALARIA SIN OBSTETRICIA + ODONTOLOGICO"
	#define STR0040 "Ocurrencias"
	#define STR0041 "Red Propia"
	#define STR0042 "Terceros"
	#define STR0043 "Total"
	#define STR0044 "Informe desarrollado en modo grafico; verificar parametro TREPORT"
	#define STR0045 "Tipo Doc."
	#define STR0046 "Nr. Documento"
	#define STR0047 "Fc.Contable"
	#define STR0048 "Fch. Emision"
	#define STR0049 "Prestador"
	#define STR0050 "Glosa"
	#define STR0051 "Vl. Pagado"
	#define STR0052 "Registo de Eventos a Liquidar y su Movimiento Financiero"
	#define STR0053 "Registo de Eventos Pagos y su Movimiento Financiero"
#else
	#ifdef ENGLISH
		#define STR0001 "Registration of Events and its Financial Transaction"
		#define STR0002 "Bill Contracts"
		#define STR0003 "Report - Book II - ANS"
		#define STR0004 "Seq.Nr."
		#define STR0005 "Event Number"
		#define STR0006 "Agreement"
		#define STR0007 "Cov"
		#define STR0008 "Nat"
		#define STR0009 "Knowledge"
		#define STR0010 "Payment"
		#define STR0011 "Main User Name"
		#define STR0012 "CNPJ/CPF"
		#define STR0013 "Event User"
		#define STR0014 "Event"
		#define STR0015 " Ctr.Due"
		#define STR0016 "Value"
		#define STR0017 "Holder CPF"
		#define STR0018 "Holder/Dependent"
		#define STR0019 "Value"
		#define STR0020 "Interests"
		#define STR0021 "Cost"
		#define STR0022 "Total Value"
		#define STR0023 "Total Issued"
		#define STR0024 "SUBLEDGER NR. "
		#define STR0025 " "
		#define STR0026 " "
		#define STR0027 " "
		#define STR0028 "Total Canceled "
		#define STR0029 "Nature: 1 INDIVIDUAL                 Coverage: 001 OUTPATIENT"
		#define STR0030 "          2 FAMILY                              002 HOSPITAL WITH OBSTETRICS"
		#define STR0031 "          3 CORPORATE COLLECTIVE                  004 DENTAL"
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
		#define STR0044 "The report was developed in graphic mode; check the parameter TREPORT."
		#define STR0045 "Doc. Type"
		#define STR0046 "Document Nr."
		#define STR0047 "Accounting Dt."
		#define STR0048 "Issue Dt."
		#define STR0049 "Provider"
		#define STR0050 "Disallowance"
		#define STR0051 "Paid Vl."
		#define STR0052 "Register of Events to Settle and its Financial Transaction"
		#define STR0053 "Register of Paid Events and its Financial Transaction"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de Eventos e sua Movimenta��o Financeira", "Registro de Eventos e sua Movimentacao Financeira" )
		#define STR0002 "Contratos por Titulos"
		#define STR0003 "Relat�rio - Livro II - ANS"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Nr. Seq", "Nro Seq" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "N�mero do Evento", "Numero do Evento" )
		#define STR0006 "Contrato"
		#define STR0007 "Nat"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Cob.", "Cob" )
		#define STR0009 "Conhec."
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Pagam.", "Pagamen." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Nome do Utilizador Principal", "Nome do Usuario Principal" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "NIF", "CNPJ/CPF" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Utilizador do Evento", "Usuario do Evento" )
		#define STR0014 "Evento"
		#define STR0015 " Vct Ctr."
		#define STR0016 "Valor"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "NIF Titular", "CPF Titular" )
		#define STR0018 "Titular/Dependente"
		#define STR0019 "Valor"
		#define STR0020 "Juros"
		#define STR0021 "Custo"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Val.Total", "Vlr Total" )
		#define STR0023 "Total Emitido"
		#define STR0024 "LIVRO AUXILIAR NR. "
		#define STR0025 " "
		#define STR0026 " "
		#define STR0027 " "
		#define STR0028 "Total Cancelado "
		#define STR0029 "Natureza: 1 INDIVIDUAL                 Cobertura: 001 AMBULATORIAL"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "          2 FAMILIAR                              002 HOSPITALAR COM OBSTETR�CIA", "          2 FAMILIAR                              002 HOSPITALAR COM OBSTETRICIA" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "          3 COLECTIVO EMPRESARIAL                  004 ODONTOL�GICO", "          3 COLETIVO EMPRESARIAL                  004 ODONTOLOGICO" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "                                                  005 REFER�NCIA", "                                                  005 REFERENCIA" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "                                                  006 AMBULATORIAL + HOSPITALAR COM OBSTETR�CIA", "                                                  006 AMBULATORIAL + HOSPITALAR COM OBSTETRICIA" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "                                                  007 AMBULATORIAL + HOSPITALAR SEM OBSTETR�CIA", "                                                  007 AMBULATORIAL + HOSPITALAR SEM OBSTETRICIA" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "                                                  008 AMBULATORIAL + ODONTOL�GICO", "                                                  008 AMBULATORIAL + ODONTOLOGICO" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "                                                  010 AMBULATORIAL COM OBSTETRICIA + ODONTOL�GICO", "                                                  010 AMBULATORIAL COM OBSTETRICIA + ODONTOLOGICO" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "                                                  011 AMBULATORIAL SEM OBSTETRICIA + ODONTOL�GICO", "                                                  011 AMBULATORIAL SEM OBSTETRICIA + ODONTOLOGICO" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "                                                  013 AMBULATORIAL + HOSPITALAR COM OBSTETR�CIA + ODONTOL�GICO", "                                                  013 AMBULATORIAL + HOSPITALAR COM OBSTETRICIA + ODONTOLOGICO" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "                                                  014 AMBULATORIAL + HOSPITALAR SEM OBSTETR�CIA + ODONTOL�GICO", "                                                  014 AMBULATORIAL + HOSPITALAR SEM OBSTETRICIA + ODONTOLOGICO" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Ocorr�ncias", "Ococorrencias" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Rede Pr�pria", "Rede Propria" )
		#define STR0042 "Terceiros"
		#define STR0043 "Total"
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Relat�rio desenvolvido em modo gr�fico, verificar par�metro TREPORT", "Relatorio desenvolvido em modo gr�fico, verificar parametro TREPORT" )
		#define STR0045 "Tipo Doc."
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "No. Documento", "Nr. Documento" )
		#define STR0047 "Dt. Contabil."
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Dt. Emiss�o", "Dt. Emissao" )
		#define STR0049 "Prestador"
		#define STR0050 "Glosa"
		#define STR0051 If( cPaisLoc $ "ANG|PTG", "Vlr. Pago", "Vl. Pago" )
		#define STR0052 "Registo de Eventos a Liquidar e sua Movimenta��o Financeira"
		#define STR0053 "Registo de Eventos Pagos e sua Movimenta��o Financeira"
	#endif
#endif

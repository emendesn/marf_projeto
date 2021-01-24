#ifdef SPANISH
	#define STR0001 "Registro de Eventos Resarcidos o Recuperados"
	#define STR0002 "Contratos por Titulos"
	#define STR0003 "Informe - Libro IV - ANS"
	#define STR0004 "Nº Sec"
	#define STR0005 "Numero del Evento"
	#define STR0006 "Contrato"
	#define STR0007 "Mod"
	#define STR0008 "Cob"
	#define STR0009 "Conoc."
	#define STR0010 "Pago"
	#define STR0011 "Nombre del Usuario Princ."
	#define STR0012 "CNPJ/CPF"
	#define STR0013 "Usuario del Evento"
	#define STR0014 "Evento"
	#define STR0015 " Vct Ctr."
	#define STR0016 "Valor"
	#define STR0017 "CPF Titular"
	#define STR0018 "Titular/Dependien."
	#define STR0019 "Valor"
	#define STR0020 "Int. "
	#define STR0021 "Costo"
	#define STR0022 "Val Total"
	#define STR0023 "Total Recuperados"
	#define STR0024 "LIBRO AUXILIAR Nº "
	#define STR0025 " "
	#define STR0026 " "
	#define STR0027 " "
	#define STR0028 "Total Recesivo "
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
	#define STR0043 "Total Gral."
	#define STR0044 "Informe desarrollado con componente grafico, verificar parametro TREPORT"
	#define STR0045 "Fc. Resarc./Recup"
	#define STR0046 "Vl. Resarc./Recup"
	#define STR0047 "Registro de Eventos Resarcidos o Recuperados (glosa)"
	#define STR0048 "Registro de Eventos Resarcidos o Recuperados (coparticipados)"
#else
	#ifdef ENGLISH
		#define STR0001 "Registr.of Events Reimbursed or Recovered"
		#define STR0002 "Bill Contracts"
		#define STR0003 "Report - Book IV - ANS"
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
		#define STR0023 "Total Recovered"
		#define STR0024 "SUBLEDGER NR. "
		#define STR0025 " "
		#define STR0026 " "
		#define STR0027 " "
		#define STR0028 "Recessive Total "
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
		#define STR0043 "Grand Total"
		#define STR0044 "Report developed with graphical component, check the parameter TREPORT"
		#define STR0045 "Reimburs./Recov. Dt."
		#define STR0046 "Reimburs./Recov. Vl."
		#define STR0047 "Reimbursed or Recovered Event Register (disallowance)"
		#define STR0048 "Reimbursed or Recovered Event Register (coparticipation)"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de Eventos Ressarcidos ou Recuperados", "Registro de Eventos Ressarcidos ou Recuperados" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Contratos por Títulos", "Contratos por Titulos" )
		#define STR0003 "Relatório - Livro IV - ANS"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Nr. Seq", "Nro Seq" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Número do Evento", "Numero do Evento" )
		#define STR0006 "Contrato"
		#define STR0007 "Nat"
		#define STR0008 "Cob"
		#define STR0009 "Conhec."
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Pagam.", "Pagamen." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Nome do Utilizador Principal", "Nome do Usuario Principal" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "NIF", "CNPJ/CPF" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Utilizador do Evento", "Usuario do Evento" )
		#define STR0014 "Evento"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", " Venc. Ctr.", " Vct Ctr." )
		#define STR0016 "Valor"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "NIF Titular", "CPF Titular" )
		#define STR0018 "Titular/Dependente"
		#define STR0019 "Valor"
		#define STR0020 "Juros"
		#define STR0021 "Custo"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Val Total", "Vlr Total" )
		#define STR0023 "Total Recuperados"
		#define STR0024 "LIVRO AUXILIAR NR. "
		#define STR0025 " "
		#define STR0026 " "
		#define STR0027 " "
		#define STR0028 "Total Recessivo "
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
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Total Crial", "Total Geral" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Relatório desenvolvido com componente gráfico verificar parâmetro TREPORT.", "Relatório desenvolvido com componente grafico verificar parametro TREPORT" )
		#define STR0045 "Dt. Ressarc./Recup"
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Vlr. Ressarc./Recup", "Vl. Ressarc./Recup" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Registo de eventos ressarcidos ou recuperados (glosa)", "Registro de Eventos Resarcidos ou Recuperados (glosa)" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Registo de eventos ressarcidos ou recuperados (coparticipação)", "Registro de Eventos Resarcidos ou Recuperados (coparticipacao)" )
	#endif
#endif

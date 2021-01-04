#ifdef SPANISH
	#define STR0001 "Registro de Contratos y Contraprestaciones Emitidas/Recebidas/Anulladas"
	#define STR0002 "Contratos por Titulos"
	#define STR0003 "Informe - Libro I - ANS"
	#define STR0004 "Nº Sec"
	#define STR0005 "Titulo"
	#define STR0006 "Documento"
	#define STR0007 "Emision"
	#define STR0008 "Vencto"
	#define STR0009 "Contrato"
	#define STR0010 "Inicio"
	#define STR0011 "Termino"
	#define STR0012 "Anulac. "
	#define STR0013 "Mod"
	#define STR0014 "Cob"
	#define STR0015 "CNPJ/CPF"
	#define STR0016 "Us. Principal"
	#define STR0017 "CPF Titular"
	#define STR0018 "Titular/Dependien."
	#define STR0019 "Valor"
	#define STR0020 "Int. "
	#define STR0021 "Costo"
	#define STR0022 "Val Total"
	#define STR0023 "Total Emitido"
	#define STR0024 "LIbRO AUXILIAR Nº "
	#define STR0025 " "
	#define STR0026 " "
	#define STR0027 " "
	#define STR0028 "Total Anulado "
	#define STR0029 "Modalid.: 1 INDIVIDUAL                 Cobertura: 001 AMBULATORIA "
	#define STR0030 "          2 FAMILIAR                              002 HOSPITALARIA CON OBSTETRIC."
	#define STR0031 "          4 COLECTIVO EMPRESARIAL                 004 ODONTOLOGICO"
	#define STR0032 "                                                  005 REFERENCIA"
	#define STR0033 "                                                  006 AMBULATORIA + HOSPITALARIA CON OBSTETRIC."
	#define STR0034 "                                                  007 AMBULATORIA + HOSPITALARIA SIN OBSTETRIC."
	#define STR0035 "                                                  008 AMBULATORIA + ODONTOLOGICO "
	#define STR0036 "                                                  010 AMBULATORIA CON OBSTETRICIA + ODONTOLOGICO"
	#define STR0037 "                                                  011 AMBULATORIA SIN OBSTETRICIA + ODONTOLOGICO"
	#define STR0038 "                                                  013 AMBULATORIA + HOSPITALARIA CON OBSTETRIC. + ODONTOLOGICO"
	#define STR0039 "                                                  014 AMBULATORIA + HOSPITALARIA SIN OBSTETRIC. + ODONTOLOGICO"
	#define STR0040 "Ocurrencias"
	#define STR0041 "Informe desarrollado en R4, verificar parametro TREPORT"
	#define STR0042 "Debe determinarse el período."
	#define STR0043 "Debe informarse la operadora."
	#define STR0044 "Deben informarse los parámetros de la empresa."
	#define STR0045 "Debe informarse el parámetro de Motivo de baja."
	#define STR0046 "Atención"
#else
	#ifdef ENGLISH
		#define STR0001 "Registration of Contracts and Considerations Issued/Received/Canceled"
		#define STR0002 "Bill Contracts"
		#define STR0003 "Report - Book I - ANS"
		#define STR0004 "Seq.Nr."
		#define STR0005 "Bill"
		#define STR0006 "Document"
		#define STR0007 "Issue"
		#define STR0008 "Due Date"
		#define STR0009 "Agreement"
		#define STR0010 "Start"
		#define STR0011 "End"
		#define STR0012 "Cancelat."
		#define STR0013 "Cov"
		#define STR0014 "Nat"
		#define STR0015 "CNPJ/CPF"
		#define STR0016 "Main User"
		#define STR0017 "Holder CPF"
		#define STR0018 "Holder/Dependent"
		#define STR0019 "Value"
		#define STR0020 "Inter."
		#define STR0021 "Cost"
		#define STR0022 "Total Value"
		#define STR0023 "Total Issued"
		#define STR0024 "SUBLEDGER NR. "
		#define STR0025 " "
		#define STR0026 " "
		#define STR0027 " "
		#define STR0028 "Total Canceled "
		#define STR0029 "Nature: 1 INDIVIDUAL                 Coverage: 001 OUTPATIENT"
		#define STR0030 "          2 FAMILY                              002 HOSPITAL WITH OBSTETRICS "
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
		#define STR0041 "Report developed in R4, check the parameter TREPORT"
		#define STR0042 "Determine a period."
		#define STR0043 "Enter cooperative."
		#define STR0044 "Enter company parameters. "
		#define STR0045 "Enter Write-off Reason Parameter."
		#define STR0046 "Attention"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de Contratos e Contraprestações Emitidas/Recebidas/Canceladas", "Registro de Contratos e Contraprestacoes Emitidas/Recebidas/Canceladas" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Contratos por Títulos", "Contratos por Titulos" )
		#define STR0003 "Relatório - Livro I - ANS"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Nr.Seq", "Nrº Seq" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Título", "Titulo" )
		#define STR0006 "Documento"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Emissão", "Emissao" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Venc.", "Vencto" )
		#define STR0009 "Contrato"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Início", "Inicio" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Término", "Termino" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Cancelam.", "Cancelam" )
		#define STR0013 "Nat"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Cob.", "Cob" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Nºcontr.", "CNPJ/CPF" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Ut.Principal", "Usu Principal" )
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
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "          2 FAMILIAR                              002 HOSPITALAR COM OBSTETRÍCIA ", "          2 FAMILIAR                              002 HOSPITALAR COM OBSTETRICIA " )
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
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Relatório desenvolvido em R4 verificar parâmetro TREPORT.", "Relatório desenvolvido em R4 verificar parametro TREPORT" )
		#define STR0042 "O período deve ser determinado."
		#define STR0043 "Operadora deve ser informada."
		#define STR0044 "Parametros de Empresa devem ser informados."
		#define STR0045 "Parametro de Motivo de Baixa deve ser informado."
		#define STR0046 "Atenção"
	#endif
#endif

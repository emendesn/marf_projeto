#ifdef SPANISH
	#define STR0001 "Extracto Financiero"
	#define STR0002 "Emite el extracto financiero del alumno"
	#define STR0003 "A Rayas"
	#define STR0004 "Administracion"
	#define STR0005 "Espere..."
	#define STR0006 "Alumno Inicial"
	#define STR0007 "Alumno Final"
	#define STR0008 "Curso Inicial"
	#define STR0009 "Curso Final"
	#define STR0010 "Periodo Inicial"
	#define STR0011 "Periodo Final"
	#define STR0012 "A�o Lectivo Inicial"
	#define STR0013 "A�o Lectivo Inicial"
	#define STR0014 "�Cual Situacion ?"
	#define STR0015 "Alumno...: "
	#define STR0016 "Turno....: "
	#define STR0017 "Curso....: "
	#define STR0018 "Unidad...: "
	#define STR0019 "Grado....: "
	#define STR0020 "Grupo...: "
	#define STR0021 "Periodos.: "
	#define STR0022 "Todos"
	#define STR0023 "A  "
	#define STR0024 "De "
	#define STR0025 "De "
	#define STR0026 "A "
	#define STR0027 "Beca.....: "
	#define STR0028 "Descrip. "
	#define STR0029 "Porc..: "
	#define STR0030 "Inicio..: "
	#define STR0031 "Termino..: "
	#define STR0032 "*** No existen becas registradas para este alumno  ***"
	#define STR0033 "T I T U L O S"
	#define STR0034 "Cuotas "
	#define STR0035 "Vencto"
	#define STR0036 "     Valor"
	#define STR0037 "  Descuento"
	#define STR0038 "     Beca "
	#define STR0039 "     Multa"
	#define STR0040 "     Inter"
	#define STR0041 "Valor Pagado"
	#define STR0042 "Fc.Pago"
	#define STR0043 "Val por Pagar"
	#define STR0044 "Historial"
	#define STR0045 "Emitiendo extracto del alumno "
	#define STR0046 "*** No existen titulos para este alumno en el periodo solicitado ***"
	#define STR0047 "Continua en la proxima pagina..."
	#define STR0048 "...continuacion"
	#define STR0049 "Situacion: "
	#define STR0050 "Inactivo"
	#define STR0051 "Habilitac. : "
	#define STR0052 "Titulo"
	#define STR0053 "Total"
	#define STR0054 "Fies"
#else
	#ifdef ENGLISH
		#define STR0001 "Financial Statements"
		#define STR0002 "Issue the student�s financial statement"
		#define STR0003 "Z-Form"
		#define STR0004 "Administration"
		#define STR0005 "Wait..."
		#define STR0006 "Initial Student"
		#define STR0007 "Final Student"
		#define STR0008 "Initial Course"
		#define STR0009 "Final Course"
		#define STR0010 "Inicial Period"
		#define STR0011 "Final Period"
		#define STR0012 "Init.School Year  "
		#define STR0013 "Init.School Year  "
		#define STR0014 "What Status   ?"
		#define STR0015 "Student..: "
		#define STR0016 "Shift....: "
		#define STR0017 "Course...: "
		#define STR0018 "Branch...: "
		#define STR0019 "Grade....: "
		#define STR0020 "Divis.: "
		#define STR0021 "Periods..: "
		#define STR0022 "All"
		#define STR0023 "To "
		#define STR0024 "Since"
		#define STR0025 "From "
		#define STR0026 " to "
		#define STR0027 "Scholarship....: "
		#define STR0028 "Description"
		#define STR0029 "Perc..: "
		#define STR0030 "Beginning..: "
		#define STR0031 "End..: "
		#define STR0032 "*** There are no scholarships registered for this student ***"
		#define STR0033 "B I L L S"
		#define STR0034 "Installment"
		#define STR0035 "Due Date"
		#define STR0036 "     Value"
		#define STR0037 "  Discount"
		#define STR0038 "     Schol"
		#define STR0039 "     Fine "
		#define STR0040 "     Intrs"
		#define STR0041 "Value Paid"
		#define STR0042 "Dt. of Payment"
		#define STR0043 "Vl to be Paid"
		#define STR0044 "History"
		#define STR0045 "Issuing the student�s statement "
		#define STR0046 "*** During the period in question there are no bills for this student ***"
		#define STR0047 "It Continues on the next page..."
		#define STR0048 "...continuation"
		#define STR0049 "Status: "
		#define STR0050 "Inactive"
		#define STR0051 "Capacitation:"
		#define STR0052 "Bill  "
		#define STR0053 "Total"
		#define STR0054 "Fies"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Extracto Financeiro", "Extrato Financeiro" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Emite o extracto financeiro do aluno", "Emite o extrato financeiro do aluno" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0004 "Administra��o"
		#define STR0005 "Aguarde..."
		#define STR0006 "Aluno Inicial"
		#define STR0007 "Aluno Final"
		#define STR0008 "Curso Inicial"
		#define STR0009 "Curso Final"
		#define STR0010 "Per�odo Inicial"
		#define STR0011 "Per�odo Final"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Ano Lectivo Inicial", "Ano Letivo Inicial" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Ano Lectivo Inicial", "Ano Letivo Inicial" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Qual a situa��o ?", "Qual Situa��o ?" )
		#define STR0015 "Aluno....: "
		#define STR0016 "Turno....: "
		#define STR0017 "Curso....: "
		#define STR0018 "Unidade..: "
		#define STR0019 "S�rie....: "
		#define STR0020 "Turma.: "
		#define STR0021 "Per�odos.: "
		#define STR0022 "Todos"
		#define STR0023 "At� "
		#define STR0024 "Desde "
		#define STR0025 "De "
		#define STR0026 " at� "
		#define STR0027 "Bolsa....: "
		#define STR0028 "Descri��o"
		#define STR0029 "Perc..: "
		#define STR0030 "In�cio..: "
		#define STR0031 "T�rmino..: "
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "*** n�o existem bolsas registadas para este aluno ***", "*** N�o existem bolsas cadastradas para este aluno ***" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "T � T U L O S", "T I T U L O S" )
		#define STR0034 "Parcela"
		#define STR0035 "Vencto"
		#define STR0036 "     Valor"
		#define STR0037 "  Desconto"
		#define STR0038 "     Bolsa"
		#define STR0039 "     Multa"
		#define STR0040 "     Juros"
		#define STR0041 "Valor Pago"
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Dt.pagto", "Dt.Pagto" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Vl A Pagar", "Vl a Pagar" )
		#define STR0044 "Hist�rico"
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "A emitir extracto do aluno ", "Emitindo extrato do aluno " )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "*** n�o existem t�tulos para este aluno no per�odo solicitado ***", "*** N�o existem t�tulos para este aluno no periodo solicitado ***" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Continua na proxima p�gina...", "Continua na pr�xima p�gina..." )
		#define STR0048 "...continua��o"
		#define STR0049 "Situa��o: "
		#define STR0050 If( cPaisLoc $ "ANG|PTG", "Inactivo", "Inativo" )
		#define STR0051 "Habilita��o: "
		#define STR0052 If( cPaisLoc $ "ANG|PTG", "T�tulo", "Titulo" )
		#define STR0053 "Total"
		#define STR0054 "Fies"
	#endif
#endif

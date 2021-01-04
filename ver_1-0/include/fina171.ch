#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Actual.Inversion/Prestamo"
	#define STR0007 "Salir"
	#define STR0008 "Confirmar"
	#define STR0009 "¿Cuanto al borrado?"
	#define STR0010 "MODALIDAD PRESTAMOS"
	#define STR0011 "MODALIDAD INVERSIONES"
	#define STR0012 "MODALIDAD PAGO PRESTAMOS"
	#define STR0013 "MODALIDAD RETIR.INVERSIONES"
	#define STR0014 "Reversion inversion"
	#define STR0015 "Reversion prestamo"
	#define STR0016 "Inversion financiera"
	#define STR0017 "Prestamo financiero"
	#define STR0018 "Subtitulo"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert "
		#define STR0004 "Edit  "
		#define STR0005 "Delete"
		#define STR0006 "Investm/Loans Updating."
		#define STR0007 "Quit"
		#define STR0008 "OK"
		#define STR0009 "About Deleting?"
		#define STR0010 "LOAN CATEGORY"
		#define STR0011 "INVESTMENTS CLASS   "
		#define STR0012 "LOANS REPAYMENT CLASS "
		#define STR0013 "INVESTM. REDEMPT. CLASS"
		#define STR0014 "Investment Reversal"
		#define STR0015 "Loan Reversal"
		#define STR0016 "Financial Investment"
		#define STR0017 "Financial Loan"
		#define STR0018 "Caption"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Actual.aplicações/emprest.", "Atual.Aplicaçoes/Emprést." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0008 "Confirma"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Quanto à exclusão?", "Quanto à exclusäo?" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Natureza Empréstimos", "NATUREZA EMPRESTIMOS" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Natureza Aplicações", "NATUREZA APLICACOES" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Natureza Pgt.empréstimos", "NATUREZA PGT.EMPRESTIMOS" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Natureza Resg.aplicações", "NATUREZA RESG.APLICACOES" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Estorno De Aplicação", "Estorno de Aplicacao" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Estorno De Empréstimo", "Estorno de Emprestimo" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Aplicação Financeira", "Aplicacao Financeira" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Empréstimo Financeiro", "Emprestimo Financeiro" )
		#define STR0018 "Legenda"
	#endif
#endif

#ifdef SPANISH
	#define STR0001 "Mantenimiento de Asientos"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Revertir"
	#define STR0008 "Leyenda"
	#define STR0009 "Mantenimiento de asientos"
	#define STR0010 "Este lote contiene asiento(s) de reversion, por ello no puede revertirse."
	#define STR0011 "Asiento Aprobado"
	#define STR0012 "Asiento Invalido"
	#define STR0013 "Rastrear Origen de Asiento"
	#define STR0014 "Origen"
	#define STR0015 "Campo: "
	#define STR0016 "Linea: "
	#define STR0017 "Asiento Devuelto"
	#define STR0018 "� Configuracion de parametros reservado para simulaciones por inclusion/movimiento !"
	#define STR0019 "Atencion"
	#define STR0020 "Informe una cuenta presupuestaria analitica."
	#define STR0021 "Actualizando saldos..."
	#define STR0022 "Algunos de los siguientes entes esta con estatus de 'bloqueado': Centro de Costo, Clase de Valor o Item contable."
	#define STR0023 "Por favor, analizar e informar un registro que no este bloqueado."
	#define STR0024 "Este asiento ya se revirtio y no podra revertirse nuevamente."
	#define STR0025 "Este asiento ya se revirtio y no podra modificarse."
	#define STR0026 "Asiento extornado no permite rastrear el origen."
	#define STR0027 "Movimento com lote invalido n�o pode ser alterado por linha. Lote/Linha: "
#else
	#ifdef ENGLISH
		#define STR0001 "Entry maintenance"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Insert"
		#define STR0005 "Edit"
		#define STR0006 "Delete"
		#define STR0007 "Reverse"
		#define STR0008 "Caption"
		#define STR0009 "Entry Maintenance"
		#define STR0010 "Lot already holds reverse entry(ies), thus it cannot be reversed."
		#define STR0011 "Entry Approved"
		#define STR0012 "Invalid Entry"
		#define STR0013 "Trace Entry origin"
		#define STR0014 "Origin"
		#define STR0015 "Field: "
		#define STR0016 "Line: "
		#define STR0017 "Entry reversed"
		#define STR0018 " - View"
		#define STR0019 "Attention"
		#define STR0020 "Enter an analytical budgetary account. "
		#define STR0021 'Updating balances....'
		#define STR0022 "Some of the following entities have a blocked status: Cost Center, Value Class or Accounting Item."
		#define STR0023 "Analyze and enter a record that is not blocked."
		#define STR0024 "This entry is already reversed and cannot be reversed again."
		#define STR0025 "This entry is already reversed and cannot be modified."
		#define STR0026 "Transaction reversed, it is not possible to track origin."
		#define STR0027 "Transaction with invalid batch cannot be edited per line. Batch/Line: "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Manuten��o de lan�amentos", "Manuten��o de Lan�amentos" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 "Estornar"
		#define STR0008 "Legenda"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Manuten��o de lan�amentos", "Manuten��o de Lan�amentos" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Este lote j� cont�m lan�amento(s) de estorno, por isso n�o pode ser estornado.", "Este lote j� cont�m lan�amento(s) de estorno, porisso n�o pode ser estornado." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Lan�amento autorizado", "Lan�amento Aprovado" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Lan�amento inv�lido", "Lan�amento Invalido" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Rastrear Origem Do Lan�amento", "Rastrear Origem do Lancamento" )
		#define STR0014 "Origem"
		#define STR0015 "Campo: "
		#define STR0016 "Linha: "
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Lan�amento Estornado", "Lancamento Estornado" )
		#define STR0018 " - Visualizar"
		#define STR0019 "Aten��o"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Indicar uma conta or�ament�ria anal�tica.", "Informe uma conta orcament�ria anal�tica." )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", 'A actualizar saldos...', 'Atualizando saldos...' )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Alguma das entidades a seguir est� com estado de 'bloqueado': Centro de Custo, Classe de Valor ou Item Cont�bil.", "Alguma das entidades a seguir est� com status de 'bloqueado': Centro de Custo, Classe de Valor ou Item cont�bil." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Favor analisar e informar um registo que n�o esteja bloqueado.", "Favor analisar e informar um registro que n�o esteja bloqueado." )
		#define STR0024 "Este lan�amento j� foi estornado e n�o poder� ser estornado novamente."
		#define STR0025 "Este lan�amento j� foi estornado e n�o poder� ser alterado."
		#define STR0026 "Lan�amento estornado n�o � permitido rastrear origem."
		#define STR0027 "Movimento com lote invalido n�o pode ser alterado por linha. Lote/Linha: "
	#endif
#endif

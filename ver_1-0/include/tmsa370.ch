#ifdef SPANISH
	#define STR0001 "Registro de Indemnizaciones"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Registrar"
	#define STR0005 "Revertir"
	#define STR0006 "aUtoriza Pago"
	#define STR0007 "reVierte Pago"
	#define STR0008 "Estatus Financiero"
	#define STR0009 "Leyenda"
	#define STR0010 "Estatus"
	#define STR0011 "Pendiente"
	#define STR0012 "Pago Autorizado"
	#define STR0013 "finalizado - Indemnizado"
	#define STR0014 "Cliente : "
	#define STR0015 " Tienda : "
	#define STR0016 "Total Carga :"
	#define STR0017 "Total Indemnizacion :"
	#define STR0018 "Total Indemnizado :"
	#define STR0019 "Saldo por Indemnizar :"
	#define STR0020 "Totalizadores"
	#define STR0021 "Seleccionando Archivos..."
	#define STR0022 "Viaje Nº :"
	#define STR0023 "Modificar"
	#define STR0024 "Verificando Bajas..."
	#define STR0025 "Total Dado de Baja: "
	#define STR0026 "Viaje - <F4>"
	#define STR0027 "Viaje"
	#define STR0028 "Este programa tiene como finalidad actualizar el estatus de los registros de indemnizacion"
	#define STR0029 "Finalizar"
	#define STR0030 "Revertir Finaliz."
	#define STR0031 "Finalizado - No Indemnizado"
	#define STR0032 "Ctd. de registros de indemnizaciones actualizados"
	#define STR0033 "No hay registro de indemnizacion para actualizar"
#else
	#ifdef ENGLISH
		#define STR0001 "Compensation file       "
		#define STR0002 "Search   "
		#define STR0003 "View"
		#define STR0004 "Record   "
		#define STR0005 "Reverse "
		#define STR0006 "aUthorize pymt"
		#define STR0007 "reVerse payment"
		#define STR0008 "Financial status "
		#define STR0009 "Legend"
		#define STR0010 "Status"
		#define STR0011 "Pending  "
		#define STR0012 "Pymnt authorized"
		#define STR0013 "Finished - Indemnified"
		#define STR0014 "Client : "
		#define STR0015 " Unit : "
		#define STR0016 "Total Load  :"
		#define STR0017 "Total Compensation:"
		#define STR0018 "Total Compensated:"
		#define STR0019 "Balance to Compens."
		#define STR0020 "Totalizers   "
		#define STR0021 "Selecting records... "
		#define STR0022 "Trip number"
		#define STR0023 "Modify"
		#define STR0024 "Verifying postings..."
		#define STR0025 "already paid "
		#define STR0026 "Trip - <F4>"
		#define STR0027 "Trip"
		#define STR0028 "The program updates the Status of the Indemnification Records"
		#define STR0029 "Finish "
		#define STR0030 "Reverse finish "
		#define STR0031 "Finished - Not Indemnified"
		#define STR0032 "Number of updated compensation records"
		#define STR0033 "There is no compensation record to be updated"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo De Indenizacoes", "Registro de Indenizacoes" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Registar", "Registrar" )
		#define STR0005 "Estornar"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Autorização Pgt.", "aUtoriza Pagto" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Estornar Pgt", "esTornar Pagto" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Estado Financeiro", "Status Financeiro" )
		#define STR0009 "Legenda"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Estado", "Status" )
		#define STR0011 "Em Aberto"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Pgt Autorizado", "Pagto Autorizado" )
		#define STR0013 "Encerrado - Indenizado"
		#define STR0014 "Cliente : "
		#define STR0015 If( cPaisLoc $ "ANG|PTG", " loja : ", " Loja : " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Total carga :", "Total Carga :" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Total indemnização :", "Total Indenizacao :" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Total indenizado :", "Total Indenizado :" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Saldo a indenizar :", "Saldo a Indenizar :" )
		#define STR0020 "Totalizadores"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Viagem no :", "Viagem No :" )
		#define STR0023 "Alterar"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "A Verificar Baixas...", "Verificando Baixas..." )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Ja pagos ... ", "já Pagos ... " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Viagem - <f4>", "Viagem - <F4>" )
		#define STR0027 "Viagem"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Este Programa Tem Como Finalidade Actualizar O Estado Dos Registos De Indemnização", "Este programa tem como finalidade atualizar o Status dos Registros de Indenização" )
		#define STR0029 "Encerrar"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Devolução De Encerr.", "Estornar Encerr." )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Encerrado - Não Indemnizado", "Encerrado - Não Indenizado" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Qtd. de registos de indemnizações actualizados", "Qtd. de registros de indenizações atualizados" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Não há registo de indemnização a ser actualizado", "Não há registro de indenização a ser atualizado" )
	#endif
#endif

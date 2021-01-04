#ifdef SPANISH
	#define STR0001 "Visualiza"
	#define STR0002 "Inclui"
	#define STR0003 "Exclui"
	#define STR0004 "Retorno Desgaste Producao"
	#define STR0005 "Pesquisar"
	#define STR0006 "Altera"
	#define STR0007 "O bem informado nao possui contador proprio"
	#define STR0008 "Obrigatorio informar a quantidade de producao"
	#define STR0009 "Data Fim devera ser maior ou igual a Data Inicio "
	#define STR0010 "Hora fim devera ser maior que a hora inicio "
	#define STR0011 "Retorno de producao ja existe para os Contadores 1 e 2"
	#define STR0012 "Retorno de producao ja existe para o Contador 1"
	#define STR0013 "Retorno de producao ja existe para o Contador 2"
	#define STR0014 "NAO CONFORMIDADE"
	#define STR0015 "Ja existe Retorno de Producao entre o intervalo"
	#define STR0016 "de data e hora para o contador 1 e 2."
	#define STR0017 "de data e hora para o contador 1"
	#define STR0018 "de data e hora para o contador 2"
	#define STR0019 " Contador 1"
	#define STR0020 " Contador 2"
	#define STR0021 "Ja existe registro com mesma informacao no historico de contador"
	#define STR0022 "do bem. Para o bem + data fim + hora fim do"
	#define STR0023 "Retorno de producao nao pode ser efetuado. Nao existe registro"
	#define STR0024 "anterior a producao no historico de contador do bem para o"
	#define STR0025 "O retorno de producao nao pode ser efetuado. Nao existe registro"
	#define STR0026 "A data Inicio informada e maior que a data atual"
	#define STR0027 "A Hora Inicio informada e maior que a Hora atual"
	#define STR0028 "A data fim informada e maior que a data atual"
	#define STR0029 "A Hora Fim informada e maior que a Hora atual"
	#define STR0030 "O retorno de producao nao pode ser efetuado. Existe registro"
	#define STR0031 "no historico de contador do bem entre o intervalo de data"
	#define STR0032 "informada no retorno de producao para o"
	#define STR0033 "O retorno de producao nao pode ser efetuado. A data inicio"
	#define STR0034 "informada nao e posterior ou igual a data de ultimo"
	#define STR0035 "acompanhamento de contador do bem para o"
	#define STR0036 "O retorno de producao nao pode ser efetuado. Nao existe nenhum"
	#define STR0037 "registro no historico de contador do bem para o"
	#define STR0038 "No hay retorno de produccion para el "
	#define STR0039 " del bien en el periodo"
	#define STR0040 "que va de: "
	#define STR0041 " a "
	#define STR0042 "Fch.Ult.Reg.Historial...:  "
	#define STR0043 "Hr.Ult.Reg.Historial...:  "
	#define STR0044 "¿Confirma el regreso con bien parado ?"
	#define STR0045 "ATENCION"
	#define STR0046 "¿Desea que se compruebe la existencia de O.S. automatica por contador?"
	#define STR0047 "Confirma (Si/No)"
	#define STR0048 "Existen registros de historial de contador con costo apropiado posteriores a la fecha informada."
	#define STR0049 " No es posible incluir o borrar un registro."
	#define STR0050 "Atencion"
#else
	#ifdef ENGLISH
		#define STR0001 "View"
		#define STR0002 "Add"
		#define STR0003 "Delete"
		#define STR0004 "Production wear and tear return"
		#define STR0005 "Search"
		#define STR0006 "Edit"
		#define STR0007 "The asset entered does not have own counter"
		#define STR0008 "Entry of production quantity required"
		#define STR0009 "End date must be greater than or equal to start date"
		#define STR0010 "End time must be greater than start time "
		#define STR0011 "Return from production already exists for counters 1 and 2"
		#define STR0012 "Return from production already exists for counter 1"
		#define STR0013 "Return from production already exists for counter 2"
		#define STR0014 "NON-CONFORMANCE"
		#define STR0015 "There is already a return from production between the interval"
		#define STR0016 "of date and time for counters 1 and 2."
		#define STR0017 "of date and time for counter 1"
		#define STR0018 "of date and time for counter 2"
		#define STR0019 " Counter 1"
		#define STR0020 " Counter 2"
		#define STR0021 "There exists already a record with the same information in counter history"
		#define STR0022 "of the asset. For asset + end date + end time of"
		#define STR0023 "Return from production cannot be made. There is no record"
		#define STR0024 "prior to production in the asset counter history for"
		#define STR0025 "Return from production cannot be made. There is no record"
		#define STR0026 "Start date entered is greater than current date"
		#define STR0027 "Start time entered is greater than current time"
		#define STR0028 "End date entered is greater than current date"
		#define STR0029 "End time entered is greater than current date"
		#define STR0030 "Return from production cannot be made. There is record"
		#define STR0031 "in the asset counter history between the date interval"
		#define STR0032 "entered in return from production for"
		#define STR0033 "Return from production cannot be made. Start date"
		#define STR0034 "entered is not later than or equal to the date of the last"
		#define STR0035 "follow-up of the asset counter for"
		#define STR0036 "Return from production cannot be made. There is no "
		#define STR0037 "record in the asset counter history for"
		#define STR0038 "No return from production for "
		#define STR0039 " the good in period"
		#define STR0040 "from:       "
		#define STR0041 " to"
		#define STR0042 "Date Last History Entry:   "
		#define STR0043 "Time Last History Entry:   "
		#define STR0044 "Confirm return to the stopped good?"
		#define STR0045 "ATTENT."
		#define STR0046 "Will you check existence of automatic S.O. per counter? "
		#define STR0047 "Confirm (Yes/No)"
		#define STR0048 "There are registers of counter history with appropriated cost  later than the entered date."
		#define STR0049 " A register cannot be added or deleted."
		#define STR0050 "Attention"
	#else
		#define STR0001 "Visualiza"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Incluir", "Inclui" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Excluir", "Exclui" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Retorno Desgaste Produção", "Retorno Desgaste Producao" )
		#define STR0005 "Pesquisar"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Alterar", "Altera" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "O bem indicado não possui contabilista próprio", "O bem informado nao possui contador proprio" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Obrigatório indicar a quantidade de produção", "Obrigatorio informar a quantidade de producao" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Data de fim deverá ser maior ou igual à data de início ", "Data Fim devera ser maior ou igual a Data Inicio " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Hora de fim deverá ser maior que a hora de início ", "Hora fim devera ser maior que a hora inicio " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Retorno de produção já existe para os contabilistaes 1 e 2", "Retorno de producao ja existe para os Contadores 1 e 2" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Retorno de produção já existe para o contador 1", "Retorno de producao ja existe para o Contador 1" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Retorno de produção já existe para o contador 2", "Retorno de producao ja existe para o Contador 2" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Não Conformidade", "NAO CONFORMIDADE" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Já existe retorno de produção entre o intervalo", "Ja existe Retorno de Producao entre o intervalo" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "De data e hora para o contabilista 1 e 2.", "de data e hora para o contador 1 e 2." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "De data e hora para o contabilista 1", "de data e hora para o contador 1" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "De data e hora para o contabilista 2", "de data e hora para o contador 2" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", " contabilista 1", " Contador 1" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Contador 2", " Contador 2" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Já existe registo com a mesma informação no histórico de contador", "Ja existe registro com mesma informacao no historico de contador" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Do bem. para o bem + data fim + hora fim do", "do bem. Para o bem + data fim + hora fim do" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Retorno de produção não pode ser efectuado. não existe registo", "Retorno de producao nao pode ser efetuado. Nao existe registro" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Anterior à produção no histórico de contador do bem para o", "anterior a producao no historico de contador do bem para o" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "O retorno de produção não pode ser efectuado. não existe registo", "O retorno de producao nao pode ser efetuado. Nao existe registro" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "A data de início indicada é posterior à data actual", "A data Inicio informada e maior que a data atual" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "A hora de início indicada é posterior à hora actual", "A Hora Inicio informada e maior que a Hora atual" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "A data de fim indicada é posterior à data actual", "A data fim informada e maior que a data atual" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "A hora de fim indicada é posterior à hora actual", "A Hora Fim informada e maior que a Hora atual" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "O retorno de produção não pode ser efectuado. existe registo", "O retorno de producao nao pode ser efetuado. Existe registro" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "No histórico de contador do bem entre o intervalo de data", "no historico de contador do bem entre o intervalo de data" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Indicada no retorno de produção para o", "informada no retorno de producao para o" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "O retorno de produção não pode ser efectuado. a data de início", "O retorno de producao nao pode ser efetuado. A data inicio" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Indicado não é posterior ou igual à data do último", "informada nao e posterior ou igual a data de ultimo" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Acompanhamento de contabilista do bem para o", "acompanhamento de contador do bem para o" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "O retorno de produção não pode ser efectuado. não existe nenhum", "O retorno de producao nao pode ser efetuado. Nao existe nenhum" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Registo no histórico de contabilista do bem para o", "registro no historico de contador do bem para o" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Não há retorno de produção para o ", "Nao ha retorno de producao para o " )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", " de bem no período", " do bem no periodo" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Que vai de: ", "que vai de: " )
		#define STR0041 " a "
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Data do último lançamento histórico...:  ", "Dt.Ult.Lanc.Historico...:  " )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Hora do último lançamento histórico...:  ", "Hr.Ult.Lanc.Historico...:  " )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Confirma a devolução como resolvida?", "Confirma o retorno com bem parado ?" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Atenção", "ATENCAO" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Deseja que seja verificada a existência automática de ordens de serviço por contabilista?", "Deseja que seja verificado a existência de o.s automática por contador?" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Confirmar (sim/não)", "Confirma (Sim/Não)" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Existem registos de histórico de contador com custo apropriado posteriores à data informada.", "Existem registros de histórico de contador com custo apropriado posteriores à data informada." )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", " Não é possível incluir ou excluir um registo.", " Não é possível incluir ou excluir um registro." )
		#define STR0050 "Atenção"
	#endif
#endif

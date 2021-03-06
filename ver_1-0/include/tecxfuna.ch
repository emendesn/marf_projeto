#ifdef SPANISH
	#define STR0001 "Item de Programacion Invalido. El item programado debe corresponder a la entidad elegida."
	#define STR0002 "Atencion"
	#define STR0003 "El Total de Atenciones Generadas fueran :"
	#define STR0004 "OK"
	#define STR0005 "No hay registros para la atencion o hubo errores en el procesamiento de la atencion."
	#define STR0006 "Sucursal"
	#define STR0007 "O.S."
	#define STR0008 "Item"
	#define STR0009 "Producto"
	#define STR0010 "Id Unico"
	#define STR0011 "Cliente"
	#define STR0012 "Tienda"
	#define STR0013 "A"
	#define STR0014 "Items de la Orden de Servicio"
	#define STR0015 "Anular"
	#define STR0016 "Inclusion de Atencion de la OS"
	#define STR0017 "Inicio: "
	#define STR0018 "�Inclusion con exito! "
	#define STR0019 "�Error en la inclusion!"
	#define STR0020 "Fin  : "
	#define STR0021 "Inclusion Manual - Atencion de la O.S."
	#define STR0022 "No hay registros para realizar las atenciones."
	#define STR0023 "Los registros con las fechas siguientes fueron ignorados en el procesamiento del registro "
	#define STR0024 "Los Registros anteriores a "
	#define STR0025 " no se validaran."
	#define STR0026 "Inclusion del Registro"
	#define STR0027 "Registro Actualizado: "
	#define STR0028 " (Residencia)"
	#define STR0029 "Domingo"
	#define STR0030 "Lunes"
	#define STR0031 "Martes"
	#define STR0032 "Miercoles"
	#define STR0033 "Jueves"
	#define STR0034 "Viernes"
	#define STR0035 "Sabado"
	#define STR0036 "Si"
	#define STR0037 "No"
	#define STR0038 "�Disponible?"
	#define STR0039 "�Asignado?"
	#define STR0040 "Descripcion"
	#define STR0041 "OK"
	#define STR0042 "Es necesario Elegir un Ente de Programacion en agenda para utilizar la consulta estandar."
	#define STR0043 "�Disponible en el RRHH?"
	#define STR0044 "Id del formulario de origen:"
	#define STR0045 "Id del campo de origen: "
	#define STR0046 "Id del formulario de error: "
	#define STR0047 "Id del campo de error: "
	#define STR0048 "Id del error: "
	#define STR0049 "Mensaje de error: "
	#define STR0050 "Mensaje de solucion: "
	#define STR0051 "Valor atribuido: "
	#define STR0052 "Valor anterior: "
	#define STR0053 "Error en el Item: "
	#define STR0054 "Existe inconsistencia en la asignacion del operador"
	#define STR0055 "Ya existe asignacion para el operador en el periodo de '#1[diaEnt]# - #2[horaEnt]#' a '#3[diaSai]# - #4[horaSai]#'"
#else
	#ifdef ENGLISH
		#define STR0001 "Invalid scheduling item. The scheduled item must match with the selected entity."
		#define STR0002 "Attention"
		#define STR0003 "The total of services generated was:"
		#define STR0004 "OK"
		#define STR0005 "There are no registers for service or errors occurred in service processing."
		#define STR0006 "Branch"
		#define STR0007 "S.O."
		#define STR0008 "Item"
		#define STR0009 "Product"
		#define STR0010 "Single Id"
		#define STR0011 "Customer"
		#define STR0012 "Store"
		#define STR0013 "The"
		#define STR0014 "Service Order Items"
		#define STR0015 "Cancel"
		#define STR0016 "Inclusion of SO Service"
		#define STR0017 "Start: "
		#define STR0018 "Successfully added! "
		#define STR0019 "Error in inclusion!"
		#define STR0020 "End: "
		#define STR0021 "Manual Inclusion - S.O. Service"
		#define STR0022 "There are no records for service execution."
		#define STR0023 "The records with the following dates were ignored in the selection processing "
		#define STR0024 "The records before "
		#define STR0025 " will not be validated."
		#define STR0026 "Selection Inclusion"
		#define STR0027 "Updated Record: "
		#define STR0028 " (Residence)"
		#define STR0029 "Sunday"
		#define STR0030 "Monday"
		#define STR0031 "Tuesday"
		#define STR0032 "Wednesday"
		#define STR0033 "Thursday"
		#define STR0034 "Friday"
		#define STR0035 "Saturday"
		#define STR0036 "Yes"
		#define STR0037 "No"
		#define STR0038 "Available?"
		#define STR0039 "Allocated?"
		#define STR0040 "Description"
		#define STR0041 "OK"
		#define STR0042 "You must choose a Schedule Entity to use the standard query."
		#define STR0043 "Available in HR?"
		#define STR0044 "ID of the origin form:"
		#define STR0045 "ID of the origin field: "
		#define STR0046 "ID of error form: "
		#define STR0047 "ID of error field: "
		#define STR0048 "Error ID: "
		#define STR0049 "Error message: "
		#define STR0050 "Solution message: "
		#define STR0051 "Value given: "
		#define STR0052 "Previous Value: "
		#define STR0053 "Error in Item: "
		#define STR0054 "There is Inconsistency in the Operator allocation"
		#define STR0055 "There is an allocation for the attendant on the period from '#1[diaEnt]# - #2[horaEnt]#' to '#3[diaSai]# - #4[horaSai]#'"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Item de agendamento inv�lido. O item agendado deve ser correspondente � entidade escolhida.", "Item de Agendamento Inv�lido. O Item agendado deve ser correspondente � entidade escolhida." )
		#define STR0002 "Aten��o"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "O total de atendimentos gerados foram :", "O Total de Atendimentos Gerados foram :" )
		#define STR0004 "OK"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "N�o h� registos para atendimento ou houve erros no processamento do atendimento.", "N�o h� registros para atendimento ou houve erros no processamento do atendimento." )
		#define STR0006 "Filial"
		#define STR0007 "O.S"
		#define STR0008 "Item"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Artigo", "Produto" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Id �nico", "Id Unico" )
		#define STR0011 "Cliente"
		#define STR0012 "Loja"
		#define STR0013 "A"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Itens da ordem de servi�o", "Itens da Ordem de Servi�o" )
		#define STR0015 "Cancelar"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Inclus�o do atendimento da OS", "Inclusao do Atendimento da OS" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "In�cio: ", "Inicio: " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Inclus�o com sucesso. ", "Inclus�o com sucesso! " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Erro na inclus�o.", "Erro na inclus�o!" )
		#define STR0020 "Fim  : "
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Inclus�o manual - Atendimento da O.S.", "Inclus�o Manual - Atendimento da O.S." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "N�o h� registos para serem realizados atendimentos.", "N�o h� registros para serem realizados atendimentos." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Os resgistos com as datas a seguir foram ignorados no processamento da marca��o ", "Os resgistros com as data a seguir foram ignorados no processamento da marca��o " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Os registos anteriores a ", "Os Registros anteriores a " )
		#define STR0025 " n�o ser�o validados."
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Inclus�o da marca��o", "Inclus�o da Marcac�o" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Registo actualizado: ", "Registro Atualizado: " )
		#define STR0028 " (Resid�ncia)"
		#define STR0029 "Domingo"
		#define STR0030 "Segunda-feira"
		#define STR0031 "Ter�a-feira"
		#define STR0032 "Quarta-feira"
		#define STR0033 "Quinta-feira"
		#define STR0034 "Sexta-feira"
		#define STR0035 "S�bado"
		#define STR0036 "Sim"
		#define STR0037 "N�o"
		#define STR0038 "Dispon�vel?"
		#define STR0039 "Alocado?"
		#define STR0040 "Descri��o"
		#define STR0041 "OK"
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "� necess�rio escolher uma entidade de agendamento para utilizar a consulta padr�o.", "� necess�rio Escolher uma Entidade de Agendamento para utilizar a consulta padr�o." )
		#define STR0043 "Disponivel no RH?"
		#define STR0044 "Id do formul�rio de origem:"
		#define STR0045 "Id do campo de origem: "
		#define STR0046 "Id do formul�rio de erro: "
		#define STR0047 "Id do campo de erro: "
		#define STR0048 "Id do erro: "
		#define STR0049 "Mensagem do erro: "
		#define STR0050 "Mensagem da solu��o: "
		#define STR0051 "Valor atribu�do: "
		#define STR0052 "Valor anterior: "
		#define STR0053 "Erro no Item: "
		#define STR0054 "H� Inconsistencia na aloca��o do Atendente"
		#define STR0055 "J� existe aloca��o para o atendente no per�odo de '#1[diaEnt]# - #2[horaEnt]#' a '#3[diaSai]# - #4[horaSai]#'"
	#endif
#endif

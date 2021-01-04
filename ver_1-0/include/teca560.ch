#ifdef SPANISH
	#define STR0001 "Sustitucion de operadores"
	#define STR0002 "Detalles del operador | Filtro"
	#define STR0003 "Agregar"
	#define STR0004 "Eliminar"
	#define STR0005 "Limpiar carpeta"
	#define STR0006 "Limpiar filtro"
	#define STR0007 "Restaurar filtro"
	#define STR0008 "Ejecutar filtro"
	#define STR0009 "Ubicar por:"
	#define STR0010 "Banco de Apoyo"
	#define STR0011 "Reserva t�cnica"
	#define STR0012 "Bco. Apoyo / Res. T�cnica"
	#define STR0013 "Todos operadores"
	#define STR0014 "Ubicando los operadores..."
	#define STR0015 "Espere"
	#define STR0016 "El representante que sera sustituido no fue ubicado."
	#define STR0017 "Atencion"
	#define STR0018 "Operadores"
	#define STR0019 "Visualizar operador"
	#define STR0020 "Control de asignacion"
	#define STR0021 "Leyenda"
	#define STR0022 "Operador no disponible para sustitucion."
	#define STR0023 "No sera posible sustituir el mismo operador."
	#define STR0024 "Seleccione un operador para sustitucion"
	#define STR0025 "Si"
	#define STR0026 "Problemas para cargar las programaciones que se utilizaran en la sustitucion."
	#define STR0027 "Problemas para ubicar el contrato."
	#define STR0028 "Usuario no esta autorizado para limpiar el filtro"
	#define STR0029 "Usuario no esta autorizado para restaurar el filtro"
	#define STR0030 "El representante posee bloqueo en el RRHH."
	#define STR0031 "Detalles en el RRHH"
#else
	#ifdef ENGLISH
		#define STR0001 "Substitution of Operators"
		#define STR0002 "Operator Details l Filter"
		#define STR0003 "Add"
		#define STR0004 "Remove"
		#define STR0005 "Clear Folder"
		#define STR0006 "Clean Filter"
		#define STR0007 "Restore"
		#define STR0008 "Execute Filter"
		#define STR0009 "Search by:"
		#define STR0010 "Support Bank"
		#define STR0011 "Technical Reserve"
		#define STR0012 "Support Bk / Technical Resp."
		#define STR0013 "All Operators"
		#define STR0014 "Finding operators..."
		#define STR0015 "Wait"
		#define STR0016 "Operator to be replaced was not found."
		#define STR0017 "Attention"
		#define STR0018 "Operators"
		#define STR0019 "View Operator"
		#define STR0020 "Allocation Control"
		#define STR0021 "Caption"
		#define STR0022 "Operator not available for replacement."
		#define STR0023 "The same operator cannot be replaced."
		#define STR0024 "Select an operator for replacement"
		#define STR0025 "Yes"
		#define STR0026 "Problems to load the scheduling to be used in the replacement."
		#define STR0027 "Problems to localize the schedule."
		#define STR0028 "User is not allowed to clear the filter"
		#define STR0029 "User is not allowed to restore the filter"
		#define STR0030 "Operator has blocking in HR."
		#define STR0031 "Details in HR"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Substitui��o de atendentes", "Substitui��o de Atendentes" )
		#define STR0002 "Detalhes do Atendente | Filtro"
		#define STR0003 "Adicionar"
		#define STR0004 "Remover"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Limpar pasta", "Limpar Pasta" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Limpar filtro", "Limpar Filtro" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Restaurar filtro", "Restaurar Filtro" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Executar filtro", "Executar Filtro" )
		#define STR0009 "Localizar por:"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Banco de apoio", "Banco de Apoio" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Reserva t�cnica", "Reserva T�cnica" )
		#define STR0012 "Bco. Apoio / Res. T�cnica"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Todos atendentes", "Todos Atendentes" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "A localizar os atendentes...", "Localizando os atendentes..." )
		#define STR0015 "Aguarde"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "O atendente que ser� substituido n�o foi localizado.", "Atendente que ser� substituido n�o foi localizado." )
		#define STR0017 "Aten��o"
		#define STR0018 "Atendentes"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Visualizar atendente", "Visualizar Atendente" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Controlo de aloca��o", "Controle de Aloca��o" )
		#define STR0021 "Legenda"
		#define STR0022 "Atendente n�o dispon�vel para substitui��o."
		#define STR0023 "N�o ser� poss�vel substituir o mesmo atendente."
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Seleccione um atendente para substitui��o", "Selecione um atendente para substitui��o" )
		#define STR0025 "Sim"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Problemas para carregar os agendamentos que ser�o utilizados na substitui��o.", "Problemas para carregar os agendamentos que ser� utilizado na substitui��o." )
		#define STR0027 "Problemas para localizar o contrato."
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "O utilizador n�o tem permiss�o para limpar o filtro", "Usu�rio n�o tem permiss�o para limpar o filtro" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "O utilizador n�o tem permiss�o para restaurar o filtro", "Usu�rio n�o tem permiss�o para restaurar o filtro" )
		#define STR0030 "Atendente possui bloqueio no RH."
		#define STR0031 "Detalhes no RH"
	#endif
#endif

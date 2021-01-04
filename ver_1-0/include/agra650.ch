#ifdef SPANISH
	#define STR0001 If( cPaisLoc $ "ANG|PTG", "Mantenimiento de bloques", "Mantenimiento de Bloques" )
	#define STR0002 "Vacio"
	#define STR0003 "Iniciado"
	#define STR0004 "Finalizado"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
	#define STR0009 "Reclasificar"
	#define STR0010 If( cPaisLoc $ "ANG|PTG", "Incluir fardos", "Incluir Fardos" )
	#define STR0011 If( cPaisLoc $ "ANG|PTG", "Excluir fardos", "Excluir Fardos" )
	#define STR0012 If( cPaisLoc $ "ANG|PTG", "Modelo de datos de los bloques", "Modelo de datos de los Bloques" )
	#define STR0013 "Datos del bloque"
	#define STR0014 "Atencion"
	#define STR0015 If( cPaisLoc $ "ANG|PTG", "Existen fardos pertenecientes a este Bloque reservados para un contrato. Este Bloque no puede ser eliminado.", "Existen fardos pertenecientes a este Bloque reservados para un contrato, este Bloque no puede ser excluido!" )
	#define STR0016 If( cPaisLoc $ "ANG|PTG", "De variedad", "Variedad De" )
	#define STR0017 If( cPaisLoc $ "ANG|PTG", "Hasta variedad ", "Variedad Hasta " )
	#define STR0018 If( cPaisLoc $ "ANG|PTG", "Hasta variedad ", "Variedad Hasta " )
	#define STR0019 If( cPaisLoc $ "ANG|PTG", "No fueron encontratos fardos disponibles para ser desvinculados del bloque.", "No fueron encontratos fardos disponibles para desvincular del bloque!" )
	#define STR0020 If( cPaisLoc $ "ANG|PTG", "Bloqueo de fardos", "Bloqueo de Fardos" )
	#define STR0021 "Marque los items y confirme para agregar en el bloque"
	#define STR0022 "Marque los items y confirme para retirar del Bloque"
	#define STR0023 If( cPaisLoc $ "ANG|PTG", "Capacidad m�xima", "Capacidad M�xima" )
	#define STR0024 "La cantidad de fardos marcados supero la capacidad maxima del bloque"
	#define STR0025 If( cPaisLoc $ "ANG|PTG", "Este fardo est� reservado para un contrato y no puede ser eliminado del bloque", "Este Fardo est� reservado para un contrato y no puede ser excluido del Bloque" )
	#define STR0026 "Este bloque no puede reclasificarse pues existen fardos pertenecientes al bloque reservados para un contrato"
	#define STR0027 If( cPaisLoc $ "ANG|PTG", "Reclasifica��o de los fardos", "Reclasificaci�n de los Fardos" )
	#define STR0028 If( cPaisLoc $ "ANG|PTG", "Clasificaci�n actual: ", "Clasificaci�n Actual: " )
	#define STR0029 If( cPaisLoc $ "ANG|PTG", "Digite nueva clasificaci�n: ", "Digite Nueva Clasificaci�n: " )
	#define STR0030 "Confirmar"
	#define STR0031 "Anular"
	#define STR0032 If( cPaisLoc $ "ANG|PTG", " ] fardos han sido reclasificados ...", " ] fardos han sido Reclasificados ..." )
	#define STR0033 If( cPaisLoc $ "ANG|PTG", "Reclasificaci�n de fardos", "Reclasificaci�n de Fardos" )
	#define STR0034 "Imprimir"
	#define STR0035 If( cPaisLoc $ "ANG|PTG", "No fueron encontratos fardos disponibles para ser consulta del bloque.", "No fueron encontratos fardos disponibles para consulta del bloque!" )
	#define STR0036 "No hay fardos pendientes para bloques conforme los datos de clasificacion comercial, productor, tienda y hacienda informados en el bloque"
	#define STR0037 "Prensa"
#else
	#ifdef ENGLISH
		#define STR0001 If(cPaisLoc $ "ANG|PTG", "Block maintenance", "Block Maintenance" )
		#define STR0002 "Blank"
		#define STR0003 "Started"
		#define STR0004 "Finished"
		#define STR0005 "View"
		#define STR0006 "Add"
		#define STR0007 "Edit"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Eliminate", "Delete" )
		#define STR0009 "Reclassify"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Add burden", "Add burden" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Delete burden", "Delete burden" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Block data model", "Block data model" )
		#define STR0013 "Block data"
		#define STR0014 "Attention"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Burden belonging to this Block reserved for a contract. This block cannot be deleted.", "Burden belonging to this Block reserved to a contract,this block cannot be deleted!" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "From variety", "Variety from" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "To variety ", "Variety to " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "To variety ", "Variety to " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Available burden not found to clear lunk from block.", "Available burden notu found to cleark block!" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Burden block", "Burden block" )
		#define STR0021 "Select the items and confirm to add the block"
		#define STR0022 "Select the items and confirm to remove the block"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Max capacity", "Max capacity" )
		#define STR0024 "The amount of selected bales exceeded  the maximum capacity of the block"
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "This burden is reserved for a contract and cannot be eliminated from block", "This burden is reserved for a contract and cannot be deleted from block" )
		#define STR0026 "This block cannot be reclassified as there are bales belonging to the block reserved for a contract "
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Reclassification of burden", "Reclassification of burden" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Classifica��o actual: ", "Classifica��o Atual: " )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Enter new classification: ", "Enter New Classification: " )
		#define STR0030 "Confirm"
		#define STR0031 "Cancel"
		#define STR0032 If( cPaisLoc $ "ANG|PTG", " ] burden reclassified ...", " ] burden Reclassified ..." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Reclassification of burden", "Reclassification of burden" )
		#define STR0034 "Print"
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Available burden not found for block query.", "Available burden not found for block query!" )
		#define STR0036 "There is no bale pending block according to commercial classification data, producer, store and farm entered in the block"
		#define STR0037 "Press"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Manuten��o de blocos", "Manuten��o de Blocos" )
		#define STR0002 "Vazio"
		#define STR0003 "Iniciado"
		#define STR0004 "Finalizado"
		#define STR0005 "Visualizar"
		#define STR0006 "Incluir"
		#define STR0007 "Alterar"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0009 "Reclassificar"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Incluir fardos", "Incluir Fardos" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Excluir fardos", "Excluir Fardos" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Modelo de dados dos blocos", "Modelo de dados dos Blocos" )
		#define STR0013 "Dados do bloco"
		#define STR0014 "Aten��o"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Existem fardos pertencentes a este Bloco reservados para um contrato. Este Bloco n�o pode ser eliminado.", "Existem fardos pertencentes a este Bloco reservados para um contrato, este Bloco n�o pode ser excluido!" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "De variedade", "Variedade De" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "At� variedade ", "Variedade Ate " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "At� variedade ", "Variedade Ate " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "N�o foram encontratos fardos disponiveis para serem desvinculados do bloco.", "N�o foram encontratos fardos disponiveis para desvincular do bloco!" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Blocagem de fardos", "Blocagem de Fardos" )
		#define STR0021 "Marque os itens e confirme para adicionar no bloco"
		#define STR0022 "Marque os itens e confirme para retirar do Bloco"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Capacidade m�xima", "Capacidade M�xima" )
		#define STR0024 "A quantidade de fardos marcados superou a capacidade m�xima do bloco"
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Este fardo est� reservado para um contrato e n�o pode ser eliminado do bloco", "Este Fardo est� reservado para um contrato e n�o pode ser excluido do Bloco" )
		#define STR0026 "Este bloco n�o pode ser reclassificado pois existem fardos pertencentes ao bloco reservados para um contrato"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Reclassifica��o dos fardos", "Reclassifica��o dos Fardos" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Classifica��o actual: ", "Classifica��o Atual: " )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Digite nova classifica��o: ", "Digite Nova Classifica��o: " )
		#define STR0030 "Confirmar"
		#define STR0031 "Cancelar"
		#define STR0032 If( cPaisLoc $ "ANG|PTG", " ] fardos foram reclassificados ...", " ] fardos foram Recalssificados ..." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Reclassifica��o de fardos", "Reclassifica��o de Fardos" )
		#define STR0034 "Imprimir"
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "N�o foram encontratos fardos disponiveis para serem consulta do bloco.", "N�o foram encontratos fardos disponiveis para consulta do bloco!" )
		#define STR0036 "N�o existem fardos pendentes para blocagem conforme os dados de classifica��o comercial, produtor, loja e fazenda informados no bloco"
		#define STR0037 "Prensa"
	#endif
#endif

#ifdef SPANISH
	#define STR0001 "Asignación de vehículos"
	#define STR0002 "VISUALIZAR"
	#define STR0003 "INCLUIR"
	#define STR0004 "MODIFICAR"
	#define STR0005 "BORRAR"
	#define STR0006 "Asignación de vehículos"
	#define STR0007 "Vehículo"
	#define STR0008 "Escala"
	#define STR0009 "Detalle"
	#define STR0010 "Asignación de vehículos"
	#define STR0011 "Incluye vehículo"
	#define STR0012 "Vehículo"
	#define STR0013 "Escala"
	#define STR0014 "Detalles"
	#define STR0015 "Generar escala"
	#define STR0016 "Generar escala"
	#define STR0017 "Atención"
	#define STR0018 "Fecha inicial no compatible con los días disponibles en la Escala. ¡Digite una fecha valida!"
	#define STR0020 "Para realizar la generación de las informaciones de escalas "
	#define STR0022 "El kilometraje límite se sobrepasó, ¿desea continuar?"
	#define STR0023 "Se sobrepasará el kilometraje límite para la revisión del vehículo. Verifique el kilometraje límite de asignación e intente nuevamente"
	#define STR0024 "Existem manutenções cadastradas para o veículo. Deseja confirmar a operação?"
	#define STR0025 "Mantenimientos"
	#define STR0026 "Existem documentos vencidos cadastrados para o veículo. Deseja confirmar a operação?"
	#define STR0027 "Existem manutenções e documentos vencidos cadastrados para o veículo. Deseja confirmar a operação?"
	#define STR0028 "O veículo já possui alocação para a data inicial informada. Altere a data inicial ou o veículo e tente novamente."
#else
	#ifdef ENGLISH
		#define STR0001 "Vehicle Allocation"
		#define STR0002 "VIEW"
		#define STR0003 "ADD"
		#define STR0004 "EDIT"
		#define STR0005 "DELETE"
		#define STR0006 "Vehicle Allocation"
		#define STR0007 "Vehicle"
		#define STR0008 "Scale"
		#define STR0009 "Detail"
		#define STR0010 "Vehicle Allocation"
		#define STR0011 "Include Vehicle"
		#define STR0012 "Vehicle"
		#define STR0013 "Scale"
		#define STR0014 "Details"
		#define STR0015 "Generate Scale"
		#define STR0016 "Generate Scale"
		#define STR0017 "Attention"
		#define STR0018 "Incompatible start date with days available on Scale, enter a valid date!"
		#define STR0020 "To generate Scale information "
		#define STR0022 "Threshold mileage was exceeded, continue?"
		#define STR0023 "The limit mileage for vehicle review will be exceeded. Check the limit allocation mileage and try again"
		#define STR0024 "There are maintenances registered for the vehicle. Confirm the operation?"
		#define STR0025 "Maintenances"
		#define STR0026 "There are due documents registered for the vehicle. Confirm the operation?"
		#define STR0027 "There are due maintenances and documents registered for the vehicle. Confirm the operation?"
		#define STR0028 "The vehicle already has allocation for the start date entered. Change the start date or the vehicle and try again."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Alocação de Veículos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "VISUALIZAR" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "INCLUIR" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "ALTERAR" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "EXCLUIR" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Alocação de Veículos" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Veículo" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Escala" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Detalhe" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Alocação de Veículos" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Incluir Veículo" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Veiculo" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Escala" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Detalhes" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Gerar Escala" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Gerar Escala" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Atenção" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "A data inicial não é compatível com a frequência do Dia e Sequência informados. Digite uma data compatível e tente novamente." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Para realizar a geração da escala, é necessário preencher todos os campos obrigatórios." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "A quilometragem limite #1 foi utrapassada em #2 km." )
		#define STR0023 "A quilometragem limite para revisão do veículo será ultrapassada. Verifique a quilometragem limite da alocação e tente novamente"
		#define STR0024 "Existem manutenções cadastradas para o veículo. Deseja confirmar a operação?"
		#define STR0025 "Manutenções"
		#define STR0026 "Existem documentos vencidos cadastrados para o veículo. Deseja confirmar a operação?"
		#define STR0027 "Existem manutenções e documentos vencidos cadastrados para o veículo. Deseja confirmar a operação?"
		#define STR0028 "O veículo já possui alocação para a data inicial informada. Altere a data inicial ou o veículo e tente novamente."
	#endif
#endif

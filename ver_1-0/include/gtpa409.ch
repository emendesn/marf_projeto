#ifdef SPANISH
	#define STR0001 "Asignaci�n de veh�culos"
	#define STR0002 "VISUALIZAR"
	#define STR0003 "INCLUIR"
	#define STR0004 "MODIFICAR"
	#define STR0005 "BORRAR"
	#define STR0006 "Asignaci�n de veh�culos"
	#define STR0007 "Veh�culo"
	#define STR0008 "Escala"
	#define STR0009 "Detalle"
	#define STR0010 "Asignaci�n de veh�culos"
	#define STR0011 "Incluye veh�culo"
	#define STR0012 "Veh�culo"
	#define STR0013 "Escala"
	#define STR0014 "Detalles"
	#define STR0015 "Generar escala"
	#define STR0016 "Generar escala"
	#define STR0017 "Atenci�n"
	#define STR0018 "Fecha inicial no compatible con los d�as disponibles en la Escala. �Digite una fecha valida!"
	#define STR0020 "Para realizar la generaci�n de las informaciones de escalas "
	#define STR0022 "El kilometraje l�mite se sobrepas�, �desea continuar?"
	#define STR0023 "Se sobrepasar� el kilometraje l�mite para la revisi�n del veh�culo. Verifique el kilometraje l�mite de asignaci�n e intente nuevamente"
	#define STR0024 "Existem manuten��es cadastradas para o ve�culo. Deseja confirmar a opera��o?"
	#define STR0025 "Mantenimientos"
	#define STR0026 "Existem documentos vencidos cadastrados para o ve�culo. Deseja confirmar a opera��o?"
	#define STR0027 "Existem manuten��es e documentos vencidos cadastrados para o ve�culo. Deseja confirmar a opera��o?"
	#define STR0028 "O ve�culo j� possui aloca��o para a data inicial informada. Altere a data inicial ou o ve�culo e tente novamente."
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
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Aloca��o de Ve�culos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "VISUALIZAR" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "INCLUIR" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "ALTERAR" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "EXCLUIR" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Aloca��o de Ve�culos" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Ve�culo" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Escala" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Detalhe" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Aloca��o de Ve�culos" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Incluir Ve�culo" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Veiculo" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Escala" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Detalhes" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Gerar Escala" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Gerar Escala" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Aten��o" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "A data inicial n�o � compat�vel com a frequ�ncia do Dia e Sequ�ncia informados. Digite uma data compat�vel e tente novamente." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Para realizar a gera��o da escala, � necess�rio preencher todos os campos obrigat�rios." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "A quilometragem limite #1 foi utrapassada em #2 km." )
		#define STR0023 "A quilometragem limite para revis�o do ve�culo ser� ultrapassada. Verifique a quilometragem limite da aloca��o e tente novamente"
		#define STR0024 "Existem manuten��es cadastradas para o ve�culo. Deseja confirmar a opera��o?"
		#define STR0025 "Manuten��es"
		#define STR0026 "Existem documentos vencidos cadastrados para o ve�culo. Deseja confirmar a opera��o?"
		#define STR0027 "Existem manuten��es e documentos vencidos cadastrados para o ve�culo. Deseja confirmar a opera��o?"
		#define STR0028 "O ve�culo j� possui aloca��o para a data inicial informada. Altere a data inicial ou o ve�culo e tente novamente."
	#endif
#endif

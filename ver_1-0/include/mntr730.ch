#ifdef SPANISH
	#define STR0001 "Paradas de los Bienes en los Mantenimientos."
	#define STR0002 "Usar los Parametros para Seleccionar el C.Costo, el Bien, el "
	#define STR0003 "Servicio y el Periodo de Paradas que Desea Imprimir."
	#define STR0004 "A Rayas"
	#define STR0005 "Administracion"
	#define STR0006 "Paradas de Equipos para Mantenimientos"
	#define STR0007 "   Bien              Descripcion                                             Mantenimiento                                                                                     Hr.Par.  Hr.Esp.   Hr.Man.  Hr.h"
	#define STR0008 "Total del Bien:"
	#define STR0009 "Hr.Dis:"
	#define STR0010 "Per:"
	#define STR0011 "Centro de Costo  "
	#define STR0012 "Paradas:"
	#define STR0013 "Total del C.Costo:"
	#define STR0014 "Tot.General:"
	#define STR0015 "Total del Mant: "
	#define STR0016 "Procesando archivo..."
	#define STR0017 "Normales"
	#define STR0018 "Historial"
	#define STR0019 "*Promedio:  HP vs HD:"
	#define STR0020 "Bie"
	#define STR0021 "de"
	#define STR0022 "no registrado."
	#define STR0023 "en"
	#define STR0024 "ATENCION"
	#define STR0025 "Calendario"
	#define STR0026 "Selecionando Registros..."
	#define STR0027 "Analitico"
	#define STR0028 "Sintetico"
	#define STR0029 "   Bien              Descripcion                 Orden   Mantenimiento                Desc. Servicio               Contador   Fc.Par.Ini.  Hr.Par.Ini. Fc.Par.Fin  Hr.Par.Fin   Hr.Par.  Hr.Esp.   Hr.Man.  Hr.h"
#else
	#ifdef ENGLISH
		#define STR0001 "Asset Stop in Maintenance."
		#define STR0002 "Use the parameters to select the Cost Center, Asset, "
		#define STR0003 "Service and Stop Period to print."
		#define STR0004 "Z.Form"
		#define STR0005 "Management"
		#define STR0006 "Equipment Stops for Maintenance"
		#define STR0007 "   Asset              Description                                             Maintenance                                                                                     Par.Tm. Esp.Tm.   Man.Tm.  H.Tm."
		#define STR0008 "Total - Asset:"
		#define STR0009 "DisTm.:"
		#define STR0010 "Per:"
		#define STR0011 "Cost Center:  "
		#define STR0012 "Stops:  "
		#define STR0013 "Total - C.Center:"
		#define STR0014 "Grand Total:"
		#define STR0015 "Maint. Total: "
		#define STR0016 "Processing File......."
		#define STR0017 "Normal"
		#define STR0018 "History"
		#define STR0019 "*Average.: HP x HD:"
		#define STR0020 "Asset"
		#define STR0021 "of"
		#define STR0022 "not registered"
		#define STR0023 "on"
		#define STR0024 "ATTENTION"
		#define STR0025 "Calendar"
		#define STR0026 "Selecting records ...    "
		#define STR0027 "Detailed"
		#define STR0028 "Summarized"
		#define STR0029 "   Asset              Description                 Order   Maintenance                Desc. Service               Counter   St.Par.Dt.  St.Par.Tm. Fin.Par.Dt.  Fin.Par.Tm.   Par.Tm. Esp.Tm.  Man.Tm.  H.Tm."
	#else
		#define STR0001 "Paradas dos Bens nas Manutenções."
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Usar os parâmetros para selecionar o C.Custo, o Bem, o ", "Usar os Parâmetros para Selecionar o C.Custo, o Bem, o " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Serviço e o Período de Paradas que deseja imprimir.", "Serviço e o Período de Paradas que Deseja Imprimir." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0005 "Administração"
		#define STR0006 "Paradas de Equipamentos para Manutenções"
		#define STR0007 "   Bem              Descrição                                             Manutenção                                                                                     Hr.Par.  Hr.Esp.   Hr.Man.  Hr.h"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Total Do Bem:", "Total do Bem:" )
		#define STR0009 "Hr.Dis:"
		#define STR0010 "Per:"
		#define STR0011 "Centro de Custo:  "
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Paragens:", "Paradas:" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Total Do C.custo:", "Total do C.Custo:" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Total Crial:", "Total Geral:" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Total da Manut.: ", "Total da Manut: " )
		#define STR0016 "Processando Arquivo..."
		#define STR0017 "Normais"
		#define STR0018 "Histórico"
		#define STR0019 "*Média:  HP x HD:"
		#define STR0020 "Bem"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Do", "do" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "não registado", "não cadastrado" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "No", "no" )
		#define STR0024 "ATENCÃO"
		#define STR0025 "Calendário"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0027 "Analítico"
		#define STR0028 "Sintético"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "   Bem              Descrição                 Ordem   Manutenção                Desc. Serviço               Contador   Dt.Par.Ini.  Hr.Par.In. Dt.Par.Fim  Hr.Par.Fim   Hr.Par.  Hr.Esp.   Hr.Man.  Hr.h", "   Bem              Descrição                 Ordem   Manutenção                Desc. Serviço               Contador   Dt.Par.Ini.  Hr.Par.Ini. Dt.Par.Fim  Hr.Par.Fim   Hr.Par.  Hr.Esp.   Hr.Man.  Hr.h" )
	#endif
#endif

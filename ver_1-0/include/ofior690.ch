#ifdef SPANISH
	#define STR0001 "Ventas"
	#define STR0002 "A rayas"
	#define STR0003 "Administracion"
	#define STR0004 " Piezas y Servicios"
	#define STR0005 "�No hay datos para este informe!"
	#define STR0006 "Atencion"
	#define STR0007 " Vehiculos"
	#define STR0008 "Total General"
	#define STR0009 "Sucursal:"
	#define STR0010 "Total:"
	#define STR0011 "Sucursales"
	#define STR0012 "Sucursales "
	#define STR0013 "Periodo:"
	#define STR0014 "Sucursal"
	#define STR0015 " a "
	#define STR0016 "Vendedor"
	#define STR0017 "Deduce Devolucion"
	#define STR0018 "MOSTRADOR (PIEZAS)"
	#define STR0019 "TALLER (PIEZAS/SERVICIOS)"
	#define STR0020 "VEHICULOS"
	#define STR0021 "- SERVICIOS"
	#define STR0022 "- PIEZAS"
	#define STR0023 "Piezas"
	#define STR0024 "Servicios"
	#define STR0025 "Sucursal Inicial"
	#define STR0026 "Sucursal Final"
	#define STR0027 "Fecha Inicial"
	#define STR0028 "Fecha Final"
	#define STR0029 "Vendedor Inicial"
	#define STR0030 "Vendedor Final"
	#define STR0031 "Tipo de Informe"
	#define STR0032 "Tipos de Ventas"
	#define STR0033 "Resumido"
	#define STR0034 "Todos"
	#define STR0035 "Si"
	#define STR0036 "Sintetico"
	#define STR0037 "Analitico"
	#define STR0038 "No"
	#define STR0039 "Piezas y Srvcs"
	#define STR0040 "Categoria"
	#define STR0041 "De Grupo"
	#define STR0042 "A Grupo"
	#define STR0043 "Solo piezas"
	#define STR0044 "Solo servicios"
#else
	#ifdef ENGLISH
		#define STR0001 "Sales"
		#define STR0002 "Z-form"
		#define STR0003 "Management"
		#define STR0004 " Parts and Services"
		#define STR0005 "There are no data for this Report!"
		#define STR0006 "Attention"
		#define STR0007 " Vehicles"
		#define STR0008 "Grand Total"
		#define STR0009 "Branch:"
		#define STR0010 "Total:"
		#define STR0011 "Branches"
		#define STR0012 "Branches "
		#define STR0013 "Period:"
		#define STR0014 "Branch"
		#define STR0015 " to "
		#define STR0016 "Salesman"
		#define STR0017 "Return Deduction"
		#define STR0018 "COUNTER (PARTS)"
		#define STR0019 "REPAIR SHOP (PARTS/SERVICES)"
		#define STR0020 "VEHICLES"
		#define STR0021 "- SERVICES"
		#define STR0022 "- PARTS"
		#define STR0023 "Parts"
		#define STR0024 "Services"
		#define STR0025 "Initial Branch"
		#define STR0026 "Final Branch"
		#define STR0027 "Initial Date"
		#define STR0028 "Final Date"
		#define STR0029 "Initial Salesman"
		#define STR0030 "Final Salesman"
		#define STR0031 "Type of Report"
		#define STR0032 "Types of Sales"
		#define STR0033 "Summarized"
		#define STR0034 "All"
		#define STR0035 "Yes"
		#define STR0036 "Summarized"
		#define STR0037 "Detailed"
		#define STR0038 "No"
		#define STR0039 "Parts and Services"
		#define STR0040 "Category"
		#define STR0041 "Group from"
		#define STR0042 "Group to"
		#define STR0043 "Only Parts"
		#define STR0044 "Only Services"
	#else
		#define STR0001 "Vendas"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "C�digo de Barras", "Zebrado" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administracao" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", " Pe�as e Servi�os", " Pecas e Servicos" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "N�o existem dados para este relat�rio!", "Nao existem dados para este Relatorio !" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Atencao" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", " Ve�culos", " Veiculos" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Total Crial", "Total Geral" )
		#define STR0009 "Filial:"
		#define STR0010 "Total:"
		#define STR0011 "Filiais"
		#define STR0012 "Filiais "
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Per�odo:", "Periodo:" )
		#define STR0014 "Filial"
		#define STR0015 " a "
		#define STR0016 "Vendedor"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Deduz Devolu��o", "Deduz Devolucao" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "BAL��O (PE�AS)", "BALCAO (PECAS)" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "OFICINA (PE�AS/SERVI�OS)", "OFICINA (PECAS/SERVICOS)" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "VE�CULOS", "VEICULOS" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "- SERVI�OS", "- SERVICOS" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "- PE�AS", "- PECAS" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Pe�as", "Pecas" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Servi�os", "Servicos" )
		#define STR0025 "Filial Inicial"
		#define STR0026 "Filial Final"
		#define STR0027 "Data Inicial"
		#define STR0028 "Data Final"
		#define STR0029 "Vendedor Inicial"
		#define STR0030 "Vendedor Final"
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Tipo de Relat�rio", "Tipo de Relatorio" )
		#define STR0032 "Tipos de Vendas"
		#define STR0033 "Resumido"
		#define STR0034 "Todos"
		#define STR0035 "Sim"
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Sint�tico", "Sintetico" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Anal�tico", "Analitico" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "N�o", "Nao" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Pe�as e Servi�os", "Pecas e Srvcs" )
		#define STR0040 "Categoria"
		#define STR0041 "Grupo De"
		#define STR0042 "Grupo Ate"
		#define STR0043 "Apenas Pe�as"
		#define STR0044 "Apenas Servi�os"
	#endif
#endif
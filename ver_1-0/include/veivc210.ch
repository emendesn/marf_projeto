#ifdef SPANISH
	#define STR0001 "Gestion Depto. de Vehiculos"
	#define STR0002 "Atencion"
	#define STR0003 "�No existen datos para esta Consulta!"
	#define STR0004 "Empresa"
	#define STR0005 "Consolidado"
	#define STR0006 "Todos Vehiculos"
	#define STR0007 "Nuevos"
	#define STR0008 "Utilizados"
	#define STR0009 "Sucursales"
	#define STR0010 "SALIR"
	#define STR0011 "Emp"
	#define STR0012 "Sucursal"
	#define STR0013 "Nombre"
	#define STR0014 "Analizando..."
	#define STR0015 "Grupo Modelo"
	#define STR0016 "Compra"
	#define STR0017 "Pedido"
	#define STR0018 "Transito"
	#define STR0019 "Stock"
	#define STR0020 "Total"
	#define STR0021 "Actualizar"
	#define STR0022 "Pendientes"
	#define STR0023 "Ventas"
	#define STR0024 "Vehiculos"
	#define STR0025 "Color"
	#define STR0026 "Opcionales"
	#define STR0027 "Fab/Mod"
	#define STR0028 "Combustible"
	#define STR0029 "Situacion"
	#define STR0030 "Dias"
	#define STR0031 "Valor"
	#define STR0032 "Chasis"
	#define STR0033 "Matricula"
	#define STR0034 "Atenciones"
	#define STR0035 "Fecha"
	#define STR0036 "Cliente"
	#define STR0037 "Reservado"
	#define STR0038 "Aprobados"
	#define STR0039 "Vendedor"
	#define STR0040 "Dia"
	#define STR0041 "Mes"
	#define STR0042 "Aprobados y Vendidos en el Dia"
	#define STR0043 "Aprobados y Vendidos en el Mes"
	#define STR0044 "Aprobados en los Meses anteriores y continuan Pendientes"
	#define STR0045 "Aprobados en los Meses anteriores y Vendidos en el Mes actual"
	#define STR0046 "FOLLOW-UP"
	#define STR0047 "Simulacion"
	#define STR0048 "Facturados en el Mes"
	#define STR0049 "Atenciones 'Facturados en el Mes', independientemente de su fecha de aprobacion"
	#define STR0050 "Bloqueado"
	#define STR0051 "Envio"
	#define STR0052 "Resumen de stock por modelo"
	#define STR0053 "Modelo del vehiculo"
	#define STR0054 "Ctd Vehiculos"
	#define STR0055 "Factur"
	#define STR0056 "TODOS"
	#define STR0057 "Resumo por sucursales"
	#define STR0058 "Sucursal"
#else
	#ifdef ENGLISH
		#define STR0001 "Vehicle Department Management"
		#define STR0002 "Attention"
		#define STR0003 "There are no data for this query!"
		#define STR0004 "Company "
		#define STR0005 "Consolidated"
		#define STR0006 "All Vehicles"
		#define STR0007 "New"
		#define STR0008 "Used"
		#define STR0009 "Branches"
		#define STR0010 "QUIT"
		#define STR0011 "Comp"
		#define STR0012 "Branch"
		#define STR0013 "Name"
		#define STR0014 "Raising..."
		#define STR0015 "Model Group"
		#define STR0016 "Purchase"
		#define STR0017 "Order"
		#define STR0018 "Transit"
		#define STR0019 "Inventory"
		#define STR0020 "Total"
		#define STR0021 "Update"
		#define STR0022 "Pending"
		#define STR0023 "Sales"
		#define STR0024 "Vehicles"
		#define STR0025 "Color"
		#define STR0026 "Optional Items"
		#define STR0027 "Man./Mod"
		#define STR0028 "Fuel"
		#define STR0029 "Status"
		#define STR0030 "Days"
		#define STR0031 "Value"
		#define STR0032 "Chassis"
		#define STR0033 "License Plate"
		#define STR0034 "Services"
		#define STR0035 "Date"
		#define STR0036 "Customer"
		#define STR0037 "Reserved"
		#define STR0038 "Approved"
		#define STR0039 "Sales Representative"
		#define STR0040 "Day"
		#define STR0041 "Month"
		#define STR0042 "Approved and Sold on the Day"
		#define STR0043 "Approved and Sold in the Month"
		#define STR0044 "Approved in previous Months and keep Pending"
		#define STR0045 "Approved in previous Months and Sold in the current Month"
		#define STR0046 "FOLLOW-UP"
		#define STR0047 "Simulation"
		#define STR0048 "Invoiced in the Month"
		#define STR0049 "Service 'Invoiced in the Month', regardless of date of approval"
		#define STR0050 "Blocked"
		#define STR0051 "Remittance"
		#define STR0052 "Stock summary per model"
		#define STR0053 "Vehicle model"
		#define STR0054 "Amt Vehicles"
		#define STR0055 "Invoic"
		#define STR0056 "ALL"
		#define STR0057 "Summary per State"
		#define STR0058 "Branch"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Gest�o Depto. de Ve�culos", "Gerenciamento Depto. de Veiculos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Atencao" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "N�o existem dados para esta Consulta !", "Nao existem dados para esta Consulta !" )
		#define STR0004 "Empresa"
		#define STR0005 "Consolidado"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Todos Ve�culos", "Todos Veiculos" )
		#define STR0007 "Novos"
		#define STR0008 "Usados"
		#define STR0009 "Filiais"
		#define STR0010 "SAIR"
		#define STR0011 "Emp"
		#define STR0012 "Filial"
		#define STR0013 "Nome"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "A Levantar...", "Levantando..." )
		#define STR0015 "Grupo Modelo"
		#define STR0016 "Compra"
		#define STR0017 "Pedido"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Tr�nsito", "Transito" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Stock", "Estoque" )
		#define STR0020 "Total"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Actualizar", "Atualizar" )
		#define STR0022 "Pendentes"
		#define STR0023 "Vendas"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Ve�culos", "Veiculos" )
		#define STR0025 "Cor"
		#define STR0026 "Opcionais"
		#define STR0027 "Fab/Mod"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Combust�vel", "Combustivel" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Situa��o", "Situacao" )
		#define STR0030 "Dias"
		#define STR0031 "Valor"
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Chassis", "Chassi" )
		#define STR0033 "Placa"
		#define STR0034 "Atendimentos"
		#define STR0035 "Data"
		#define STR0036 "Cliente"
		#define STR0037 "Reservado"
		#define STR0038 "Aprovados"
		#define STR0039 "Vendedor"
		#define STR0040 "Dia"
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "M�s", "Mes" )
		#define STR0042 "Aprovados e Vendidos no Dia"
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Aprovados e Vendidos no M�s", "Aprovados e Vendidos no Mes" )
		#define STR0044 "Aprovados nos Meses anteriores e continuam Pendentes"
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Aprovados nos Meses anteriores e Vendidos no M�s actual", "Aprovados nos Meses anteriores e Vendidos no Mes atual" )
		#define STR0046 "FOLLOW-UP"
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Simula��o", "Simulacao" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Facturados no m�s", "Faturados no Mes" )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Atendimentos 'Facturados no m�s', independentemente da sua data de aprova��o", "Atendimentos 'Faturados no Mes', independentemente da sua data de aprovacao" )
		#define STR0050 "Bloqueado"
		#define STR0051 "Remessa"
		#define STR0052 "Resumo do estoque por modelo"
		#define STR0053 "Modelo do ve�culo"
		#define STR0054 "Qtd Ve�culos"
		#define STR0055 "Fatur"
		#define STR0056 "TODOS"
		#define STR0057 "Resumo por filiais"
		#define STR0058 "Filial"
	#endif
#endif

#ifdef SPANISH
	#define STR0001 "Consulta Entorno de Produccion"
	#define STR0002 "Buscar"
	#define STR0003 "Consulta"
	#define STR0004 "pOsicionado"
	#define STR0005 "Datos"
	#define STR0006 "Leyenda"
	#define STR0007 "Productos"
	#define STR0008 "Componentes / Reservas"
	#define STR0009 "Guias de Operacion"
	#define STR0010 "Operaciones"
	#define STR0011 "Recursos"
	#define STR0012 "Herramientas"
	#define STR0013 "Ordenes de Produccion"
	#define STR0014 "Total de guias para este producto"
	#define STR0015 "Total de operaciones para esta guia"
	#define STR0016 "Total de componentes para esta operacion"
	#define STR0017 "Total de ordenes de produccion para este producto"
	#define STR0018 "Cantidad Total"
	#define STR0019 "Cantidad ya entregada"
	#define STR0020 "Cantidad perdida"
	#define STR0021 "Total de itemes reservados para la OP"
	#define STR0022 "No hay totales para esta consulta."
	#define STR0023 "Componentes por Operacion"
	#define STR0024 "Itemes Reservados"
	#define STR0025 "Consumos"
	#define STR0026 "Graficos"
	#define STR0027 "Ctd.Total vs. Perdida vs. Apunt."
	#define STR0028 "Consumo Real vs. Consumo Estandard"
	#define STR0029 "Consumo Real"
	#define STR0030 "Consumo Estandar"
	#define STR0031 "Componente"
	#define STR0032 "Operaciones"
	#define STR0033 "Costo de produccion de la OP"
	#define STR0034 "Costo por componente"
	#define STR0035 "Costo promedio"
	#define STR0036 "Costo promedio unitario de produccion"
	#define STR0037 "Costo medio unitario por operacion"
	#define STR0038 "Costo Previsto"
	#define STR0039 "Costo Real"
	#define STR0040 "Costo Previsto vs. Real"
	#define STR0041 "Panel de costos"
	#define STR0042 "Revision de la pre-estructura"
	#define STR0043 "Informe codigo de la revision"
	#define STR0044 "Anula"
	#define STR0045 "Confirma"
	#define STR0046 "La fecha inicial de produccion no puede ser mayor que la fecha final, por favor, �informe una fecha valida!"
	#define STR0047 "El periodo informado debe pertenecer al mismo ano, por favor, �informe una fecha valida!"
	#define STR0048 "Total de revisiones de la estructura del producto"
#else
	#ifdef ENGLISH
		#define STR0001 "Search Production Environment"
		#define STR0002 "Search"
		#define STR0003 "Query"
		#define STR0004 "Positioned"
		#define STR0005 "Data"
		#define STR0006 "Caption"
		#define STR0007 "Products"
		#define STR0008 "Components / Reserves"
		#define STR0009 "Operation Courses"
		#define STR0010 "Operations"
		#define STR0011 "Resources"
		#define STR0012 "Tools"
		#define STR0013 "Production Orders"
		#define STR0014 "Total of courses for this product"
		#define STR0015 "Operation total for this course"
		#define STR0016 "Total of components for this operation"
		#define STR0017 "Total of production orders for this product"
		#define STR0018 "Total Quantity"
		#define STR0019 "Quantity already delivered"
		#define STR0020 "Lost quantity"
		#define STR0021 "Total of allocated items for this P.O."
		#define STR0022 "There are not total for this query"
		#define STR0023 "Components per Operation"
		#define STR0024 "Allocated Items"
		#define STR0025 "Usages"
		#define STR0026 "Graphs"
		#define STR0027 "Total Qtty. X Loss X Registration"
		#define STR0028 "Real Use X Standard Use"
		#define STR0029 "Actual Consumption"
		#define STR0030 "Standard Consumption"
		#define STR0031 "Component"
		#define STR0032 "Operations"
		#define STR0033 "PO production cost"
		#define STR0034 "Cost per component"
		#define STR0035 "Unit average cost"
		#define STR0036 "Production unit average cost"
		#define STR0037 "Average unit cost per operation"
		#define STR0038 "Expected Cost"
		#define STR0039 "Real Cost"
		#define STR0040 "Expected x Real Cost"
		#define STR0041 "Costs panel"
		#define STR0042 "Pre-structure review"
		#define STR0043 "Enter review code"
		#define STR0044 "Cancel"
		#define STR0045 "Confirm"
		#define STR0046 "Production initial date can not be higher than final date. Please, enter a valid date!"
		#define STR0047 "Period entered must belong to the same year, please, enter a valid date!"
		#define STR0048 "Total of revisions of product structure"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Consulta De Ambiente De Produ��o", "Consulta Ambiente de Producao" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Consulta"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Posicionado", "pOsicionado" )
		#define STR0005 "Dados"
		#define STR0006 "Legenda"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Artigos", "Produtos" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Componentes / Aloca��es", "Componentes / Empenhos" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Roteiros De Opera��o", "Roteiros de Operacao" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Opera��es", "Operacoes" )
		#define STR0011 "Recursos"
		#define STR0012 "Ferramentas"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Ordens De Produ��o", "Ordens de Producao" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Total de roteiros para este artigo", "Total de roteiros para esse produto" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Total de opera��es para este roteiro", "Total de operacoes para esse roteiro" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Total de componentes para esta opera��o", "Total de componentes para essa operacao" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Total de ordens de produ��o para este artigo", "Total de ordens de producao para esse produto" )
		#define STR0018 "Quantidade Total"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Quantidade j� entregue", "Quantidade ja entregue" )
		#define STR0020 "Quantidade perdida"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Total De Elementos Empenhados Para A Op", "Total de itens empenhados para a OP" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "N�o existem totais para essa consulta.", "Nao existem totais para essa consulta." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Componentes Por Opera��o", "Componentes por Operacao" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Elementos Empenhados", "Itens Empenhados" )
		#define STR0025 "Consumos"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Gr�ficos", "Graficos" )
		#define STR0027 "Qtd Total X Perda X Apontamento"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Consumo Real X Consumo Padr�o", "Consumo Real X Consumo Standard" )
		#define STR0029 "Consumo Real"
		#define STR0030 "Consumo Standard"
		#define STR0031 "Componente"
		#define STR0032 "Opera��es"
		#define STR0033 "Custo de produ��o da OP"
		#define STR0034 "Custo por componente"
		#define STR0035 "Custo m�dio unit�rio"
		#define STR0036 "Custo m�dio unit�rio de produ��o"
		#define STR0037 "Custo m�dio unit�rio por opera��o"
		#define STR0038 "Custo Previsto"
		#define STR0039 "Custo Real"
		#define STR0040 "Custo Previsto x Real"
		#define STR0041 "Painel de custos"
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Revis�o da pr�-estrutura", "Revisao da pre-estrutura" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Informe c�digo da revis�o", "Informe codigo da revisao" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Cancelar", "Cancela" )
		#define STR0045 "Confirma"
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "A data inicial de produ��o n�o pode ser maior que a data final. Por favor, informe uma data v�lida!", "A data inicial de produ��o n�o pode ser maior que a data final, por favor, informe uma data v�lida!" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "O per�odo informado deve pertencer ao mesmo ano. Por favor, informe uma data v�lida!", "O periodo informado deve pertencer ao mesmo ano, por favor, informe uma data v�lida!" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Total de revis�es da estrutura do artigo", "Total de revis�es da estrutura do produto" )
	#endif
#endif
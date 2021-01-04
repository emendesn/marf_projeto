#ifdef SPANISH
	#define STR0001 "bUscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Proyectar"
	#define STR0007 "Actualiz.de monedas "
	#define STR0008 "�Cuanto al borrado? "
	#define STR0009 "Enero     "
	#define STR0010 "Febrero   "
	#define STR0011 "Marzo     "
	#define STR0012 "Abril     "
	#define STR0013 "Mayo      "
	#define STR0014 "Junio     "
	#define STR0015 "Julio     "
	#define STR0016 "Agosto    "
	#define STR0017 "Septiembre"
	#define STR0018 "Octubre   "
	#define STR0019 "Noviembre "
	#define STR0020 "Diciembre "
	#define STR0021 "Num de dias para proyeccion"
	#define STR0022 "Num de dias para regresion"
	#define STR0023 "Regresion lineal"
	#define STR0024 "Inflacion proyectada"
	#define STR0025 "Mes"
	#define STR0026 "�Desea sobreponer las tasas informadas?"
	#define STR0027 "Total de registros"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add "
		#define STR0004 "Edit   "
		#define STR0005 "Delete "
		#define STR0006 "pRoject"
		#define STR0007 "Currency Update"
		#define STR0008 "Delete"
		#define STR0009 "January  "
		#define STR0010 "February "
		#define STR0011 "March    "
		#define STR0012 "April    "
		#define STR0013 "May      "
		#define STR0014 "June     "
		#define STR0015 "July     "
		#define STR0016 "August   "
		#define STR0017 "September"
		#define STR0018 "October  "
		#define STR0019 "November "
		#define STR0020 "December "
		#define STR0021 "*Days to Projection"
		#define STR0022 "*Days to Regression"
		#define STR0023 "*Linear Regression"
		#define STR0024 "*Projected Inflation"
		#define STR0025 "Month"
		#define STR0026 "Do you want to overlay Taxes Indicated?"
		#define STR0027 "Total of Records"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Projectar", "pRojetar" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Actualiza��o de Moedas", "Atualiza��o de Moedas" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Quanto � exclus�o?", "Quanto � exclus�o?" )
		#define STR0009 "Janeiro  "
		#define STR0010 "Fevereiro"
		#define STR0011 "Marco    "
		#define STR0012 "Abril    "
		#define STR0013 "Maio     "
		#define STR0014 "Junho    "
		#define STR0015 "Julho    "
		#define STR0016 "Agosto   "
		#define STR0017 "Setembro "
		#define STR0018 "Outubro  "
		#define STR0019 "Novembro "
		#define STR0020 "Dezembro "
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "No. de dias para projec��o", "No. de dias para proje��o" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "N�. de dias para a regress�o", "No. de dias para regress�o" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Regress�o Linear", "Regress�o Linear" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Infla��o projectada", "Infla��o projetada" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "M�s", "Mes" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Deseja sobrepor as taxas informadas?", "Deseja sobrepor as Taxas Informadas?" )
		#define STR0027 "Total de Registros"
	#endif
#endif

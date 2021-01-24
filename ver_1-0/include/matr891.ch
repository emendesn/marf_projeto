#ifdef SPANISH
	#define STR0001 "Este informe tiene como objetivo presentar los valores analiticos generados en el calculo del InovarAuto para las producciones."
	#define STR0002 "Lista InovarAuto Analitico - Produccion"
	#define STR0003 "Producciones del periodo"
	#define STR0004 "PRODUCTO"
	#define STR0005 "Descripcion"
	#define STR0006 "Cantidad"
	#define STR0007 "Val.Par.Ded. UN"
	#define STR0008 "Val.Par.Ded."
	#define STR0009 "Requisiciones/Devoluciones de las producciones"
	#define STR0010 "Producto"
	#define STR0011 "| Descripcion"
	#define STR0012 "| Orden de produccion"
	#define STR0013 "| C/F"
	#define STR0014 "| Cantidad"
	#define STR0015 "| Val.Par.Ded. UN"
	#define STR0016 "| Val.Par.Ded."
	#define STR0017 "| �Comprado/Producido?"
	#define STR0018 "| Periodo calculo"
	#define STR0019 "T O T A L"
	#define STR0020 "Lista InovarAuto Analitica - Produccion (Periodo: "
	#define STR0021 "C O M P O N E N T E S"
	#define STR0022 "Comprado"
	#define STR0023 "Producido"
#else
	#ifdef ENGLISH
		#define STR0001 "This report aims at displaying the detailed values calculated in the InovarAuto calculation for Productions."
		#define STR0002 "Detailed InovarAuto Relation - Production"
		#define STR0003 "Term Productions"
		#define STR0004 "PRODUCT"
		#define STR0005 "Description"
		#define STR0006 "Quantity"
		#define STR0007 "Vl.Par.Ded. UN."
		#define STR0008 "Vl.Par.Ded."
		#define STR0009 "Requisitions/Returns of the Productions"
		#define STR0010 "Product"
		#define STR0011 "| Description"
		#define STR0012 "| Production Order"
		#define STR0013 "| C/F"
		#define STR0014 "| Quantity"
		#define STR0015 "| Vl.Par.Ded. UN."
		#define STR0016 "| Vl.Par.Ded."
		#define STR0017 "| Purchased/Produced ?"
		#define STR0018 "| Calculation Term"
		#define STR0019 "T O T A L S"
		#define STR0020 "Detailed InovarAuto Relation - Production (Term: "
		#define STR0021 "C O M P O N E N T S"
		#define STR0022 "Purchased"
		#define STR0023 "Produced"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Este relat�rio tem como objetivo apresentar os valores anal�ticos calculados na apura��o do InovarAuto para as Produ��es." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Rela��o InovarAuto Anal�tico - Produ��o" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Produ��es do Per�odo" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "PRODUTO" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Descri��o" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Quantidade" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Vl.Par.Ded. UN" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Vl.Par.Ded." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Requisi��es/Devolu��es das Produ��es" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Produto" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "| Descri��o" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "| Ordem de Produ��o" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "| C/F" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "| Quantidade" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "| Vl.Par.Ded. UN" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "| Vl.Par.Ded." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "| Comprado/Produzido ?" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "| Periodo Apura��o" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "T O T A I S" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Rela��o InovarAuto Anal�tica - Produ��o (Per�odo: " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "C O M P O N E N T E S" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Comprado" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Produzido" )
	#endif
#endif

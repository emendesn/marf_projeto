#Include "Protheus.ch"
#Include "TBIConn.ch" 
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
/*/{Protheus.doc} MDEMENU
    MENU DA ROTINA MANIFESTAÇÃO DO DESTINATÁRIO
/*/
User Function MDEMENU()

Local aRotina := {}

Local aRotina3  := { {"Incluir","MDeInclui"	,0,3,0,.F.},; //Incluir
		           { "Alterar",	"MDeAltera"	,0,2,0,.F.},; //Alterar
		           { "Excluir",	"MDeExclui"	,0,2,0,.F.}} //Excluir

aRotina   := { { "Pesquisar",	"PesqBrw"		,0,1,0,.F.},; //Pesquisar
	               { "Wiz.Config.",	"SpedNFeCfg"	,0,3,0,.F.},; //Wiz.Config.
	               { "Configurar",	"btConfig"		,0,3,0,.F.},; //Configurar
	               { "Sincronizar",	"Sincronizar"	,0,3,0,.F.},; //Sincronizar
                   { "Impressão Danfe Fornecedor", "U_MGFCOMBH"    ,0,5,0,.F.},; //Gera Danfe
		           { "Manifestar",	"Manifest"		,0,2,0,.F.},; //Manifestar
		           { "Monitorar",	"MontaMonitor"	,0,2,0,.F.},; //Monitorar
		           { "Exportar",	"BaixaZip(0)" 	,0,2,0,.F.},; //Exportar Zip
		           { "Legenda",		"BtLegenda"		,0,3,0,.F.},; //Legenda
				   { "Filtro",      "ManiFiltro"    ,0,3,0,.F.},; //ManiFiltro
		           { "MD-e manual"	,aRotina3		,0,3,0,.F.}}  //MD-e Manual       	           				   
		           /*{"Eventos"	,"listaEventos", 0, 2, 0, .F.}}*/ //Eventos  
Return aRotina
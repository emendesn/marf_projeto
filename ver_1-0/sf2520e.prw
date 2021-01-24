#include "Protheus.ch"
/*
=====================================================================================
Programa.:              SF2520E
Autor....:              Roberto Sidney
Data.....:              25/10/2016
Descricao / Objetivo:   Efetua o estorno autom�tico da medi��o no momento da exclus�o da nota fiscal
Doc. Origem:            VEN03 - GAP MGFVEN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamada efetuada atrav�s do ponto de entrada A410CONS()
=====================================================================================
*/
User Function SF2520E()

	If findfunction("U_MGFSF2520E")
		U_MGFSF2520E()
	Endif

// envia exclusao da Nfs ao Taura
If FindFunction("U_TAS03SF2520E")
	U_TAS03SF2520E()
Endif		

// FIS45 Taura
If FindFunction("U_MGFFAT50")
	U_MGFFAT50()
Endif

return

/*
=====================================================================================
Programa.:              MGFSF2520E
Autor....:              Roberto Sidney
Data.....:              25/10/2016
Descricao / Objetivo:   Efetua o estorno autom�tico da medi��o no momento da exclus�o da nota fiscal
Doc. Origem:            VEN03 - GAP MGFVEN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamada efetuada atrav�s do ponto de entrada A410CONS()
=====================================================================================
*/
User Function MGFSF2520E()

	Local _cChaveCND := '' 
	// Declara vari�veis utilizados pelas rotinas autom�ticas
	Private LAUTO      := .T.   
	Private aAutoCab   := {}  
	Private aAutoItens := {}
	Private cCompet    := Space(TamSX3("CNF_COMPET")[1])
	Private	aRotina    := {{"","",0,1,0,.F.},{"","",0,2,0, nil},{"","",0,3,0, nil},{"","",0,4,0,nil},{"","",0,5,0,nil},{"","",0,6,0,nil},;
	{"","",0,7,0,nil},{"","",0,8,0,.F.},{"","",0,3,0,.F.},{"","",0,9,0,nil},{"","",0,4,0,nil},{"","",0,3,0,.F.}}  //


	// Recupera o numero da medi��o
	DbSelectArea("SC5")
	_cChaveCND := SC5->C5_ZNUMED

	DbSelectArea("CND")
	DbSetOrder(4)

	IF CND->(DbSeek(xFilial("CND")+_cChaveCND))    
		// Monta AutoCab para rotina autom�tica
		aAdd(aAutoCab,{"CND_CONTRA",CND->CND_CONTRA,NIL})
		aAdd(aAutoCab,{"CND_REVISA",CND->CND_REVISA,NIL})
		aAdd(aAutoCab,{"CND_COMPET",CND->CND_COMPET,NIL})
		aAdd(aAutoCab,{"CND_NUMERO",CND->CND_NUMERO,NIL})
		aAdd(aAutoCab,{"CND_NUMMED",CND->CND_NUMMED,NIL})
		aAdd(aAutoCab,{"CND_PARCEL",CND->CND_PARCEL,NIL})
		aAdd(aAutoCab,{"CND_MOEDA",CND->CND_MOEDA,NIL})
		aAdd(aAutoCab,{"CND_DESCME",CND->CND_DESCME,NIL})
		aAdd(aAutoCab,{"CND_OBS","Estorno ocorrido atrav�s de exclus�o de N.F.",NIL}) //Medi��o gerada automaticamente a partir da inclus�o do pedido de venda n�mero ###.
		aAdd(aAutoCab,{"NUMPED",CND->CND_PEDIDO,NIL})
		aAdd(aAutoCab,{"CND_SERVIC",CND->CND_SERVIC,NIL})
		CN120Estor("CND",CND->(RECNO()),1) 
		DbSelectArea("CNF")
		cCompet :=  CNF->CNF_COMPET
		//CN120Manut("CND",CND->(RECNO()),3) // Exclus�o da medi��o 
		CN130Manut("CND",CND->(RECNO()),5,,CND->CND_CONTRA,CND->CND_REVISA,cCompet,,,,CND->CND_PARCEL,,,,) 
		msgalert("Estorno da medi��o efetuado com sucesso.")
	Endif

Return .t.
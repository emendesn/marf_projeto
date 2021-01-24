#Include "Protheus.ch"
#include "totvs.ch"
#include "FWMVCDEF.ch"
#include "topconn.ch"

/*
===========================================================================================
Programa.:              MGFEEC4A
Autor....:              Barbieri
Data.....:              Out/2016
Descricao / Objetivo:   Rotina para Relação Pedido x Doc de Exportação 
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/

User Function EEC15A(aRotina)

	aadd(aRotina,{"Doc/Ativ Exportação","U_MGFEEC15",0,1,0}) 
	aadd(aRotina,{"Impressao de Proforma Invoice","U_MGFEEC37",0,1,0}) 	

Return(aRotina) 


/*
===========================================================================================
Programa.:              MGFEEC15
Autor....:              Leonardo Kume
Data.....:              Out/2016
Descricao / Objetivo:   Relação Pedido x Doc de Exportação 
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/


User Function MGFEEC15() 

	Local aRotOld := iif(Type("aRotina") <> "U",aRotina,{})
	Local oBrowse := FwMBrowse():New()
	Local cPedido := iif(IsInCallStack("U_MGFEEC24"),ALLTRIM(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)),Alltrim(EE7->(EE7_ZEXP+EE7_ZANOEX+EE7_ZSUBEX)))

	aRotina := {}    

	u_InsZZJ15()

	oBrowse:setAlias("ZZJ")
	oBrowse:setDescription("Pedido x Doc de Exportação")
	oBrowse:AddLegend("GetAdvFVal('SZZ','ZZ_TIPO',xFilial('SZZ')+ZZJ_CODDOC,1,'') = 'D' ","BLUE" ,'Documento')
	oBrowse:AddLegend("GetAdvFVal('SZZ','ZZ_TIPO',xFilial('SZZ')+ZZJ_CODDOC,1,'') = 'A' ","GREEN" ,"Atividade")

	oBrowse:SetMenuDef("MGFEEC15")

	oBrowse:SetFilterDefault("ALLTRIM(ZZJ_PEDIDO) ==  '"+Alltrim(cPedido)+"' ")
	oBrowse:Activate()

	DbSelectArea("ZB8")
	DbSetOrder(3)
	DbSeek(XFILIAL("ZB8")+cPedido)


	DbSelectArea("ZZJ")
	Set Filter to   

	If Type("aRotina") <> "U"
		aRotina := aRotOld 
	EndIF

Return


Static Function MenuDef()

	Local aRotina := {}                                       



	ADD OPTION aRotina TITLE "Pesquisar" 	ACTION "PesqBrw" 	OPERATION  1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.MGFEEC15" 	OPERATION  2 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" 		ACTION "VIEWDEF.MGFEEC15" 	OPERATION  4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" 		ACTION "U_DELEEC15" OPERATION  7 ACCESS 0
	ADD OPTION aRotina TITLE "Documentos" 	ACTION "U_MGFEEC16('"+MV_PAR01+"','"+xFilial("ZZJ")+"')" OPERATION  3 ACCESS 0
	ADD OPTION aRotina TITLE "Legenda" 		ACTION "U_LEGEEC15" OPERATION  9 ACCESS 0    


Return aRotina     

Static Function ModelDef()
	Local oModel      := Nil
	Local oStrZZJ     := FWFormStruct(1,"ZZJ")

	oModel := MPFormModel():New("EEC15", /*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("ZZJMASTER",/*cOwner*/,oStrZZJ, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription('Pedido x Doc/Ativ Exportação')

	oModel:SetPrimaryKey({"ZZJ_FILIAL","ZZJ_COD"})



Return(oModel)


Static Function ViewDef()



	Local oView       := Nil

	Local oModel      := FWLoadModel( 'MGFEEC15' )

	Local oStrZZJ     := FWFormStruct( 2,"ZZJ")



	oView := FWFormView():New()

	oView:SetModel(oModel)



	oView:AddField( 'VIEW_ZZJ' , oStrZZJ, 'ZZJMASTER' )



	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZZJ', 'TELA' )



Return oView



/*
===========================================================================================
Programa.:              InsZZJ15
Autor....:              Barbieri
Data.....:              Out/2016
Descricao / Objetivo:   Relação Pedido x Doc de Exportação automatico por cliente do pedido
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function InsZZJ15(cResp)

	Local cPerg := "MGFEEC15"
	Local dBase := Stod("")
	Default cResp := ""
	//	Local lOk := IIf (ZZJ->(DbSeek(xFilial("ZZJ")+EE7->EE7_PEDIDO)),.T.,.F.)

	If IsInCallStack("u_MGFEEC24")    
		DbSelectArea("ZZJ")
		DbSetOrder(2) //ZZJ_PEDIDO
		If !(ZZJ->(DbSeek(xFilial("ZZJ")+ALLTRIM(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)))))
			If Empty(cResp)
				Pergunte(cPerg,.T.)
				cResp := MV_PAR01
			EndIf
			DbSelectArea("ZZ2")
			DbSetOrder(2)
			DbSeek(ZZ2->(xFilial("ZZ2")+ZB8->ZB8_IMPORT+ZB8->ZB8_IMLOJA))
			While !ZZ2->(Eof()) .AND. ZZ2->(ZZ2_FILIAL+ZZ2_CODCLI+ZZ2_LOJCLI) == ZB8->(xFilial("ZZ2")+ZB8->ZB8_IMPORT+ZB8->ZB8_IMLOJA)
				cNum := GetSXENum("ZZJ","ZZJ_COD")
				DbSelectArea("ZZJ")			
				ZZJ->(Reclock("ZZJ",.T.))
				ZZJ->ZZJ_FILIAL 	:= xFilial("ZZJ")
				ZZJ->ZZJ_COD 		:= cNum
				ZZJ->ZZJ_CODDOC 	:= ZZ2->ZZ2_CODDOC
				ZZJ->ZZJ_PEDIDO 	:= ALLTRIM(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
				ZZJ->ZZJ_RESPON 	:= cResp
				ZZJ->ZZJ_FINALI		:= "N"
				ZZJ->ZZJ_NECESS		:= ZZ2->ZZ2_OBRIG
				ZZJ->ZZJ_QTDIAS		:= ZZ2->ZZ2_DIAS
				ZZJ->ZZJ_DTBASE		:= U_DATEEC15(ZB8->ZB8_EXP,ZB8->ZB8_ANOEXP,ZB8->ZB8_SUBEXP)
				ZZJ->ZZJ_PRVCON		:= IIF(!Empty(ZZJ->ZZJ_DTBASE),ZZJ->ZZJ_DTBASE+ZZJ->ZZJ_QTDIAS,STOD(""))   
				ZZJ->ZZJ_QTDORI		:= ZZ2->ZZ2_QTDORI   
				ZZJ->ZZJ_QTDCOP		:= ZZ2->ZZ2_QTDCOP   
				ZZJ->(MsUnlock())
				ZZ2->(DbSkip())
			EndDo
		ElseIf Empty(Alltrim(("ZZJ")->ZZJ_RESPON))
			If Empty(cResp)
				Pergunte(cPerg,.T.)
				cResp := MV_PAR01
			EndIf
			While xFilial("ZZJ")+ALLTRIM(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)) == ALLTRIM(ZZJ->(ZZJ_FILIAL+ZZJ_PEDIDO))
				ZZJ->(RecLock("ZZJ",.F.))
				ZZJ->ZZJ_RESPON := cResp
				ZZJ->(MsUnLock())
				ZZJ->(DbSkip())
			EndDo
		EndIf
		DbSelectArea("ZZJ")
		DbSetOrder(1)
//		Set Filter to ALLTRIM(ZZJ_PEDIDO) == ALLTRIM(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
	ElseIf IsInCallStack("EECAP100")       
		DbSelectArea("ZZJ")
		DbSetOrder(2) //ZZJ_PEDIDO
		If !(ZZJ->(DbSeek(xFilial("ZZJ")+Alltrim(EE7->(EE7_ZEXP+EE7_ZANOEX+EE7_ZSUBEX)))))
			Pergunte(cPerg,.T.)
			DbSelectArea("ZZ2")
			DbSetOrder(2)
			DbSeek(ZZ2->(xFilial("ZZ2")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA))
			While !ZZ2->(Eof()) .AND. ZZ2->(ZZ2_FILIAL+ZZ2_CODCLI+ZZ2_LOJCLI) == EE7->(xFilial("ZZ2")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA)
				cNum := GetSXENum("ZZJ","ZZJ_COD")
				DbSelectArea("ZZJ")			
				ZZJ->(Reclock("ZZJ",.T.))
				ZZJ->ZZJ_FILIAL 	:= xFilial("ZZJ")
				ZZJ->ZZJ_COD 		:= cNum
				ZZJ->ZZJ_CODDOC 	:= ZZ2->ZZ2_CODDOC
				ZZJ->ZZJ_PEDIDO 	:= EE7->EE7_ZORCAM
				ZZJ->ZZJ_RESPON 	:= MV_PAR01
				ZZJ->ZZJ_FINALI		:= "N"
				ZZJ->ZZJ_NECESS		:= ZZ2->ZZ2_OBRIG
				ZZJ->ZZJ_QTDIAS		:= ZZ2->ZZ2_DIAS
				ZZJ->ZZJ_DTBASE		:= U_DATEEC15(EE7->EE7_ZEXP,EE7->EE7_ZANOEX,EE7->EE7_ZSUBEX)
				ZZJ->ZZJ_PRVCON		:= IIF(!Empty(ZZJ->ZZJ_DTBASE),ZZJ->ZZJ_DTBASE+ZZJ->ZZJ_QTDIAS,STOD(""))   
				ZZJ->ZZJ_QTDORI		:= ZZ2->ZZ2_QTDORI   
				ZZJ->ZZJ_QTDCOP		:= ZZ2->ZZ2_QTDCOP   
				ZZJ->(MsUnlock())
				ZZ2->(DbSkip())
			EndDo
		ElseIf Empty(Alltrim(("ZZJ")->ZZJ_RESPON))
			Pergunte(cPerg,.T.)
			While xFilial("ZZJ")+Alltrim(EE7->(EE7_ZEXP+EE7_ZANOEX+EE7_ZSUBEX)) == ZZJ->(ZZJ_FILIAL+ZZJ_PEDIDO)
				ZZJ->(RecLock("ZZJ",.F.))
				ZZJ->ZZJ_RESPON := MV_PAR01
				ZZJ->(MsUnLock())
				ZZJ->(DbSkip())
			EndDo
		EndIf
		DbSelectArea("ZZJ")
		DbSetOrder(1)
//		Set Filter to ALLTRIM(ZZJ_PEDIDO) == Alltrim(EE7->(EE7_ZEXP+EE7_ZANOEX+EE7_ZSUBEX))

	Elseif IsInCallStack("EECAE100") //Incluído por Barbieri em 11/2016 com dados da tabela EEC       
		//		cOrcam := GetAdvFVal("EE7","EE7_ZORCAM",xFilial("EE7")+EEC->EEC_PEDREF,1,"")
		cOrcam := Alltrim(EEC->(EEC_ZEXP+EEC_ZANOEX+EEC_ZSUBEX))
		DbSelectArea("ZZJ")
		DbSetOrder(2)//Cliente+Loja+Documento
		If !(ZZJ->(DbSeek(xFilial("ZZJ")+cOrcam)))
			Pergunte(cPerg,.T.)
			DbSelectArea("ZZ2")
			DbSetOrder(2)
			DbGoTop()
			While !ZZ2->(Eof()) .AND. ZZ2->(ZZ2_FILIAL+ZZ2_CODCLI+ZZ2_LOJCLI) == EEC->(xFilial("ZZ2")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA)
				cNum := GetSXENum("ZZJ","ZZJ_COD")
				dBase := U_DATEEC15(EEC->EEC_ZEXP,EEC->EEC_ZANOEX,EEC->EEC_ZSUBEX)
				DbSelectArea("ZZJ")			
				ZZJ->(Reclock("ZZJ",.T.))
				ZZJ->ZZJ_FILIAL 	:= xFilial("ZZJ")
				ZZJ->ZZJ_COD 		:= cNum
				ZZJ->ZZJ_CODDOC 	:= ZZ2->ZZ2_CODDOC
				ZZJ->ZZJ_PEDIDO 	:= cOrcam
				ZZJ->ZZJ_RESPON 	:= MV_PAR01
				ZZJ->ZZJ_FINALI		:= "N"
				ZZJ->ZZJ_NECESS		:= ZZ2->ZZ2_OBRIG
				ZZJ->ZZJ_QTDIAS		:= ZZ2->ZZ2_DIAS
				ZZJ->ZZJ_DTBASE		:= dBase
				ZZJ->ZZJ_PRVCON		:= IIF(!Empty(dBase),dBase+ZZ2->ZZ2_DIAS,STOD("")) 
				ZZJ->ZZJ_QTDORI		:= ZZ2->ZZ2_QTDORI   
				ZZJ->ZZJ_QTDCOP		:= ZZ2->ZZ2_QTDCOP   
				ZZJ->(MsUnlock())
				ZZ2->(DbSkip())
			EndDo
		ElseIf Empty(Alltrim(("ZZJ")->ZZJ_RESPON))
			Pergunte(cPerg,.T.)
			While xFilial("ZZJ")+cOrcam == ZZJ->(ZZJ_FILIAL+ZZJ_PEDIDO)
				ZZJ->(RecLock("ZZJ",.F.))
				ZZJ->ZZJ_RESPON := MV_PAR01
				ZZJ->(MsUnLock())
				ZZJ->(DbSkip())
			EndDO
		EndIf
		DbSelectArea("ZZJ")
		DbSetOrder(1)
//		Set Filter to ALLTRIM(ZZJ_PEDIDO) == ALLTRIM(cOrcam)
	EndIf
	DbSelectArea("ZZJ")

Return

// 02 - Legendas
User Function LEGEEC15()

	aLegenda := { { "BR_AZUL",     "Documento" },;
	{ "BR_VERDE",    "Atividade" }}

	BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return


// 02 - Delete
User Function DELEEC15()

	if MsgYesNo("Deseja remover esse documento do pedido número "+ZZJ->ZZJ_PEDIDO+"?")
		ZZJ->(Reclock("ZZJ",.F.))
		ZZJ->(DbDelete())
		ZZJ->(MsUnlock())
	endif

Return (.t.)



/*
===========================================================================================
Programa.:              DATEEC15
Autor....:              Barbieri
Data.....:              Nov/2016
Descricao / Objetivo:   Função para buscar data base ref. cadastro de Doc/Ativ 
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/

User Function DATEEC15(cExp,cAno,cSub)

	Local cQuery := ""
	Local cPedido := ""
	Local cAliasEE7 := GetNextAlias()
	
	cSub := iif(Empty(Alltrim(cSub))," ",cSub)

	BeginSQL Alias cAliasEE7
	SELECT 
	EE7.EE7_PEDIDO
	FROM %table:EE7% EE7
	WHERE 	EE7.D_E_L_E_T_ = ' ' AND 
	EE7.EE7_FILIAL = %xFilial:EE7% AND
	TRIM(EE7.EE7_ZEXP) = %Exp:cExp% AND
	EE7.EE7_ZSUBEX = %Exp:cSub% AND
	TRIM(EE7.EE7_ZANOEX) = %Exp:cAno%
	EndSQL


	cPedido := iif((cAliasEE7)->(!Eof()),Alltrim((cAliasEE7)->EE7_PEDIDO),"")

	cPreemb := GETADVFVAL("EEC","EEC_PREEMB",XFILIAL("EEC")+cPedido,14,"")

	If ZZ2->ZZ2_DATA == '1'
		dDtbase := GETADVFVAL("EEC","EEC_ETD",XFILIAL("EEC")+cPedido,14,STOD(""))		
	Elseif ZZ2->ZZ2_DATA == '2'
		dDtbase := GETADVFVAL("EEC","EEC_DTENDC",XFILIAL("EEC")+cPedido,14,STOD(""))
	Elseif ZZ2->ZZ2_DATA == '3'
		dDtbase := GETADVFVAL("EES","EES_DTNF",XFILIAL("EES")+cPreemb,1,STOD(""))
	Elseif ZZ2->ZZ2_DATA == '4'
		dDtbase := GETADVFVAL("EEQ","EEQ_VCT",XFILIAL("EEQ")+cPreemb,1,STOD(""))
	Elseif ZZ2->ZZ2_DATA == '5'
		dDtbase := GETADVFVAL("EEC","EEC_ETADES",XFILIAL("EEC")+cPedido,14,STOD(""))
	Elseif ZZ2->ZZ2_DATA == '6'
		dDtbase := GETADVFVAL("ZB8","ZB8_DTFCPR",XFILIAL("ZB8")+cExp+cAno+cSub,3,STOD(""))
	Elseif ZZ2->ZZ2_DATA == '7'
		dDtbase := GETADVFVAL("ZB8","ZB8_ZDTEST",XFILIAL("ZB8")+cExp+cAno+cSub,3,STOD(""))
	Elseif ZZ2->ZZ2_DATA == '8'
		dDtbase := GETADVFVAL("ZB8","ZB8_ZEMPRO",XFILIAL("ZB8")+cExp+cAno+cSub,3,STOD(""))	
	Elseif ZZ2->ZZ2_DATA == '9'
		dDtbase := GETADVFVAL("EEC","EEC_DTESTU",XFILIAL("EEC")+cPedido,14,STOD(""))	
	Elseif ZZ2->ZZ2_DATA == '10'
		dDtbase := GETADVFVAL("EEC","EEC_DTEMBA",XFILIAL("EEC")+cPedido,14,STOD(""))	
	Else
		dDtbase := STOD("")
	Endif
	//
Return(dDtbase)

/*/{Protheus.doc} DTEC15UP
Atualiza todos os campos de data dos pedidos, chamado em PE no fim do Embarque e Pedido
@type function
@author leonardo.kume
@since 06/01/2017
@version 1.0
@param cPedido, character, numero do pedido do EE7
@param cOrcam, character, numero do orçamento caso não tenha pedido
/*/
User Function DTEC15UP(cPedido,cOrcam,lProforma)

	Local aArea := GetArea()
	Local aAreaZZ2 := ZZ2->(GetArea())
	Local aAreaZZJ := ZZJ->(GetArea())
	Local aAreaEE7 := EE7->(GetArea())
	Local lOk := .F.

	Default cOrcam 		:= ""
	Default cPedido		:= ""
	Default lProforma	:= .f.

	DbSelectArea("EE7")
	DbSetOrder(1)
	DbSelectArea("ZZ2")
	DbSetOrder(2)
	DbSelectArea("ZZJ")
	DbSetOrder(2)
	If !Empty(Alltrim(cOrcam))
		lOk := ZZJ->(DbSeek(xFilial("ZZJ")+cOrcam)) 
	ElseIf alltrim(xFilial("EE7")+cPedido) <> ALLTRIM(EE7->EE7_FILIAL+EE7->EE7_PEDIDO)
		lOk := EE7->(DbSeek(xFilial("EE7")+ALLTRIM(cPedido))) 
		cOrcam := Alltrim(EE7->EE7_ZEXP)+Alltrim(EE7->EE7_ZANOEX)+Alltrim(EE7->EE7_ZSUBEX)
		lOk := lOk .and. ZZJ->(DbSeek(xFilial("ZZJ")+cOrcam)) 	
	Else
		cOrcam := Alltrim(EE7->EE7_ZEXP)+Alltrim(EE7->EE7_ZANOEX)+Alltrim(EE7->EE7_ZSUBEX)
		lOk :=  ZZJ->(DbSeek(xFilial("ZZJ")+cOrcam)) 	
	EndIf

	While !ZZJ->(Eof()) .and. alltrim(cOrcam) == Alltrim(ZZJ->ZZJ_PEDIDO)

		ZZ2->(DbSeek(xFilial("ZZ2")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA+alltrim(ZZJ->ZZJ_CODDOC)))
		RecLock("ZZJ",.F.)
		ZZJ->ZZJ_DTBASE := U_DATEEC15(Alltrim(EE7->EE7_ZEXP),Alltrim(EE7->EE7_ZANOEX),Alltrim(EE7->EE7_ZSUBEX))
		ZZJ->ZZJ_PRVCON	:= IIF(!Empty(ZZJ->ZZJ_DTBASE),ZZJ->ZZJ_DTBASE+ZZJ->ZZJ_QTDIAS,STOD(""))	
		ZZJ->(MsUnlock()) 
		ZZJ->(DbSkip())

	EndDo
	ZZ2->(RestArea(aAreaZZ2))
	ZZJ->(RestArea(aAreaZZJ))
	EE7->(RestArea(aAreaEE7))
	RestArea(aArea)


Return .T.

/*/{Protheus.doc} MGFDT15
Chamada do ponto de entrada
@type function
@author leonardo.kume
@since 06/01/2017
@version 1.0
/*/
User Function MGFDT15()
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
	Local cPedido := ""
	Local cOrcam := ""

	If 	IsInCallStack("EECAE100") .and. cParam ==  "GRV_CPOS_CUSTOM" .OR. ;//PE_GRAVA //GRV_PED
	IsInCallStack("EECAP100") .and. cParam ==  "GRV_PED" .OR.;//PE_GRAVA //GRV_PED
	IsInCallStack("EECAF200") .and. cParam ==  "PE_AF200MAN_GRVOK"
		if IsInCallStack("EECAP100")
			cPedido := ALLTRIM(EE7->EE7_PEDIDO)
		Elseif IsInCallStack("EECAE100")
			cPedido := Alltrim(EEC->EEC_PEDREF)
		Elseif IsInCallStack("EECAF200")
			cPedido := GetAdvFVal("EEC","EEC_PEDREF",xFilial("EEC")+EEQ->EEQ_PREEMB,1,"")
		EndIf
		u_DTEC15UP(cPedido)
	ElseIf 	IsInCallStack("U_MGFEEC24") 
		cOrcam := ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP
		u_DTEC15UP(,cOrcam)
	EndIf

Return .t.
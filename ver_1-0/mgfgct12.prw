#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa............: MGFGCT12
Autor...............: Marcos Andrade         
Data................: 25/08/2017 
Descricao / Objetivo: Apresentar Nome do Fornecedor no Browse do Contrato
Doc. Origem.........: Contrato - GAP MGFCGT12
Solicitante.........: Cliente
Uso.................: 
Obs.................: Inicializador de Browse no campo virtual CN9_NOME
=====================================================================================
*/
User Function MGFGCT12() 
LOCAL cNome   := Space(40)  
LOCAL cCodigo := Space(06)  
LOCAL cLoja   := Space(02)    

IF CN9_ESPCTR = "1"     //Compra
     cCodigo := POSICIONE("CNC",1,xFilial("CNC")+CN9->CN9_NUMERO+CN9->CN9_REVISA,"CNC_CODIGO")
     cLoja   := POSICIONE("CNC",1,xFilial("CNC")+CN9->CN9_NUMERO+CN9->CN9_REVISA,"CNC_LOJA")
     cNome   := POSICIONE("SA2",1,xFilial("SA2")+cCodigo+cLoja,"A2_NOME") 
ELSEIF CN9_ESPCTR = "2" //Venda
     cCodigo := POSICIONE("CNC",3,xFilial("CNC")+CN9->CN9_NUMERO+CN9->CN9_REVISA,"CNC_CLIENT")
     cLoja   := POSICIONE("CNC",3,xFilial("CNC")+CN9->CN9_NUMERO+CN9->CN9_REVISA,"CNC_LOJACL")
     cNome   := POSICIONE("SA1",1,xFilial("SA1")+cCodigo+cLoja,"A1_NOME")     
ENDIF

RETURN(cNome)

/*
=====================================================================================
Programa............: xMGF12GGt12
Autor...............: Joni Lima do Carmo         
Data................: 09/11/2017
Descricao / Objetivo: Gatilho para Nome do 
Doc. Origem.........: Contrato - GAP MGFCGT12
Obs.................: Gatilho para Nome do Cliente Fornecedor
=====================================================================================
*/
User Function xMGF12Gt12()
	
	Local aArea := GetArea()
	Local aAreaSA1 := SA1->(GetArea())
	Local aAreaSA2 := SA2->(GetArea())
	
	Local oModel 	:= FwModelActive()
	Local oModelCN9	:= oModel:GetModel("CN9MASTER")
	Local oModelCNC := oModel:GetModel("CNCDETAIL")
	Local cRet := " "
		
	IF oModelCN9:GetValue("CN9_ESPCTR") = "1" //Compra
		oModelCN9:SetValue("CN9_ZNOME", POSICIONE("SA2",1,xFilial("SA2") + oModelCNC:GetValue("CNC_CODIGO") + oModelCNC:GetValue("CNC_LOJA") ,"A2_NOME") )
		cRet := oModelCNC:GetValue("CNC_CODIGO")
	ElseIf oModelCN9:GetValue("CN9_ESPCTR") = "2" //Venda
		oModelCN9:SetValue("CN9_ZNOME", POSICIONE("SA1",1,xFilial("SA1") + oModelCNC:GetValue("CNC_CLIENT") + oModelCNC:GetValue("CNC_LOJACL") ,"A1_NOME") )
		cRet := oModelCNC:GetValue("CNC_CLIENT")
	EndIf

	RestArea(aAreaSA2)
	RestArea(aAreaSA1)
	RestArea(aArea)
	
Return cRet
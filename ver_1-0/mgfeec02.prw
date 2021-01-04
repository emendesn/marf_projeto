#Include "Protheus.ch"
#include "totvs.ch"
#include "FWMVCDEF.ch"

/*
===========================================================================================
Programa.:              MGFEEC02
Autor....:              Francis Oliveira
Data.....:              Out/2016
Descricao / Objetivo:   Browse com os Documentos exigidos pelo cliente  
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              
Obs......:              Leo - Alteracao para incluir os documentos obrigatorios automaticamente no cliente.
===========================================================================================
*/               


User Function MGFEEC02() 

    Local aRotOld := aRotina       
    
    Local oDlgOld := iif(Type("oDlg") <> "U",oDlg,nil)
	
	Local oBrowse := FwMBrowse():New()

	aRotina := {}    
    
	If IsInCallStack("EECAC100")      
  		DbSelectArea("ZZ2")
		DbSetOrder(1)
		Set Filter to ZZ2_CODCLI == SA1->A1_COD
	EndIf
	
	
	
	oBrowse:setAlias("ZZ2")
	oBrowse:setDescription("Clientes x Doc/Ativ Exportacao")
	oBrowse:AddLegend("GetAdvFVal('SZZ','ZZ_TIPO',xFilial('SZZ')+ZZ2_CODDOC,1,'') = 'D' ","BLUE" ,'Documento')
	oBrowse:AddLegend("GetAdvFVal('SZZ','ZZ_TIPO',xFilial('SZZ')+ZZ2_CODDOC,1,'') = 'A' ","GREEN" ,"Atividade")
	
	oBrowse:SetMenuDef("MGFEEC02")
	
	oBrowse:Activate()
	
               
	DbSelectArea("ZZ2")
	Set Filter to   
	             
	aRotina := aRotOld 
	
	If Type("oDlg") == "U"
		oDlg := oDlgOld	
	EndIf
	           
Return
           

Static Function MenuDef()

	Local aRotina := {}
              

	ADD OPTION aRotina TITLE "Pesquisar" 	ACTION "PesqBrw" 	OPERATION  1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.MGFEEC02" 	OPERATION  2 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" 		ACTION "VIEWDEF.MGFEEC02" 	OPERATION  4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" 		ACTION "U_DELEEC02" OPERATION  7 ACCESS 0
	ADD OPTION aRotina TITLE "Documentos" 	ACTION "U_MGFEEC01" OPERATION  3 ACCESS 0
	ADD OPTION aRotina TITLE "Legenda" 		ACTION "U_LEGEEC02" OPERATION  9 ACCESS 0


Return aRotina     

Static Function ModelDef()
      Local oModel      := Nil
      Local oStrZZ2     := FWFormStruct(1,"ZZ2")

      oModel := MPFormModel():New("EEC02", /*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )

      oModel:AddFields("ZZ2MASTER",/*cOwner*/,oStrZZ2, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

      

      oModel:SetDescription('Clientes x Doc/Ativ Exportacao')

      oModel:SetPrimaryKey({"ZZ2_FILIAL","ZZ2_COD"})

      

Return(oModel)


Static Function ViewDef()

      

      Local oView       := Nil

      Local oModel      := FWLoadModel( 'MGFEEC02' )

      Local oStrZZ2     := FWFormStruct( 2,"ZZ2")

      

      oView := FWFormView():New()

      oView:SetModel(oModel)

      

      oView:AddField( 'VIEW_ZZ2' , oStrZZ2, 'ZZ2MASTER' )

      

      oView:CreateHorizontalBox( 'TELA' , 100 )

      oView:SetOwnerView( 'VIEW_ZZ2', 'TELA' )

      

Return oView

//=============================== Relacao das Functions =================================
// 01 - Funcao Principal - Clientes x Doc. de Exportacao -  MGFEEC02()
// 02 - Legendas - LEGEEC02() 
//=======================================================================================
User Function MGFEEC2A()   


	
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
	
	If cParam == "ANTES_DO_MSGET"
		//If Altera
			aAdd(aButtons,{"BITMAP",{|| U_MGFEEC02()}, 'Doc/Ativ Exportacao','Doc/Ativ x Cliente'})
		//EndIf
	EndIf
	 

			
Return


User Function DELEEC02()

	If MsgYesNo("Deseja excluir o documento "+SZZ->ZZ_CODDOC+"?")
		DbSelectArea("ZZ2")
		RecLock("ZZ2",.f.)
		ZZ2->(DbDelete())
		ZZ2->(MsUnlock())        
	EndIf

Return     



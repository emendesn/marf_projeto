#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMBROWSE.CH'  
#INCLUDE 'FWMVCDEF.CH'     

/*/{Protheus.doc} MGFFATBF
Tela de consulta da integração de pedidos do SFA

@type function
@author Paulo da Mata
@since 16/01/2020
@version P12.1.17
@return Nil
/*/

User Function MGFFATBF

	Local oBrowse
	Private aRotina := Menudef()
	oBrowse:= FWMBrowse():New()
	oBrowse:SetAlias('ZC5')
	oBrowse:SetDescription("Tela de Pedidos SFA")
	oBrowse:AddLegend("ZC5_STATUS == '1'","GREEN"  ,"Recebido" )
	oBrowse:AddLegend("ZC5_STATUS == '2'","YELLOW" ,"Processando" )
	oBrowse:AddLegend("ZC5_STATUS == '3'","RED"    ,"Pedido Gerado" )
    oBrowse:AddLegend("ZC5_STATUS == '4'","BLACK"  ,"Erro" )
    oBrowse:AddLegend("ZC5_STATUS == '5'","ORANGE" ,"Alterado na mesa" )
	oBrowse:Activate()

Return

Static Function ModelDef()

	Local oModel
	Local oStruZC5 := FWFormStruct( 1, "ZC5")

	oModel := MPFormModel():New('xPedDel',,,,)
	oModel:AddFields('ZC5MASTER',,oStruZC5)
	oModel:SetPrimaryKey({'ZC5_FILIAL','ZC5_CLIENT','ZC5_PVPROT','ZC5_INTEGR'})
	oModel:SetDescription("Integração de Pedidos SFA")
	oModel:GetModel( 'ZC5MASTER' ):SetDescription( "Tela de Pedidos SFA" )

Return(oModel)

Static Function ViewDef()

	Local oModel	:= ModelDef() 
	Local oView		:= FWFormView():New()
	Local oStruZC5	:= FWFormStruct(2, 'ZC5')

	oView:SetModel(oModel)
	oView:AddField('VIEW_ZC5' ,oStruZC5,'ZC5MASTER')
	oView:CreateHorizontalBox('TELA', 100)
	oView:SetOwnerView('VIEW_ZC5','TELA')
        
Return(oView)

Static Function MenuDef()

	Local aRotina := {}
 
 	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFFATBF" OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Legenda'    ACTION 'U_MGFBFLEG()'     OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Reprocessa' ACTION 'U_MGFBFREP()'     OPERATION 6 ACCESS 0
		
Return aRotina

/*/{Protheus.doc} MGFBFLEG
Mostra a situação dos pedidos do SFA

Status dos Pedidos
==================

1 = Recebido
2 = Processando
3 = Gerado Pedido
4 = Erro
5 = Alterado na mesa

@type function
@author Paulo da Mata
@since 16/01/2020
@version P12.1.17
@return Nil
/*/
User Function MGFBFLEG()

	Local aLegenda := {}
    
    AADD(aLegenda,{"BR_VERDE"    ,"Recebido"      	})
    AADD(aLegenda,{"BR_AMARELO"  ,"Processando"   	})
    AADD(aLegenda,{"BR_VERMELHO" ,"Gerado Pedido" 	})
    AADD(aLegenda,{"BR_PRETO"    ,"Erro"          	})
    AADD(aLegenda,{"BR_LARANJA"  ,"Alterado na mesa"})

    BrwLegenda("Status dos Pedidos","Status dos Pedidos",aLegenda)

Return

/*/{Protheus.doc} MGFBFREP
Efetua o Reprocessamento do Pedido

@type function
@author Paulo da Mata
@since 17/01/2020
@version P12.1.17
@return Nil
/*/
User Function MGFBFREP

    Local cStatus := ZC5->ZC5_STATUS
    Local lOk     := .F.

    If cStatus == "4"
       If ApMsgYesNo(OemToAnsi("Deseja enviar o pedido para reprocessar ?"),OemToAnsi("CONFIRMA"))
          ZC5->(RecLock("ZC5"),.F.)
          ZC5->ZC5_STATUS := "1"
          ZC5->(MsUnLock())
          lOk := .T.
       EndIf
    Else
       ApMsgAlert(OemToAnsi("Somente Pedidos com a Legenda PRETA (ERRO) podem ser enviados "+;
                            "para reprocessamento."),OemToAnsi("ATENÇÃO"))
    EndIf

    If lOk
       ApMsgInfo(OemToAnsi("Pedido Liberado para Reprocessamento !"),OemToAnsi("ATENÇÃO"))
    EndIf
   
Return

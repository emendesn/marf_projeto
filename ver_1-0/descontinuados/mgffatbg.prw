#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMBROWSE.CH'  
#INCLUDE 'FWMVCDEF.CH'     

/*/{Protheus.doc} MGFFATBG
Tela de consulta da integração de pedidos do E-COMMERCE

@type function
@author Paulo da Mata
@since 17/01/2020
@version P12.1.17
@return Nil
/*/

User Function MGFFATBG

	Local oBrowse
	Private aRotina := Menudef()
	oBrowse:= FWMBrowse():New()
	oBrowse:SetAlias('XC5')
	oBrowse:SetDescription("Tela de Pedidos E-COMMERCE")
	oBrowse:AddLegend("XC5_STATUS == '1'","GREEN"  ,"Recebido" )
	oBrowse:AddLegend("XC5_STATUS == '2'","YELLOW" ,"Processando" )
	oBrowse:AddLegend("XC5_STATUS == '3'","RED"    ,"Pedido Gerado" )
    oBrowse:AddLegend("XC5_STATUS == '4'","BLACK"  ,"Erro" )
	oBrowse:Activate()

Return

Static Function ModelDef()

	Local oModel
	Local oStruXC5 := FWFormStruct( 1, "XC5")

	oModel := MPFormModel():New('xPedDel',,,,)
	oModel:AddFields('XC5MASTER',,oStruXC5)
	oModel:SetPrimaryKey({'XC5_FILIAL','XC5_CLIENT','XC5_PVPROT','XC5_INTEGR','XC5_DTRECE'})
	oModel:SetDescription("Integração de Pedidos E-COMMERCE")
	oModel:GetModel( 'XC5MASTER' ):SetDescription( "Tela de Pedidos E-COMMERCE" )

Return(oModel)

Static Function ViewDef()

	Local oModel	:= ModelDef() 
	Local oView		:= FWFormView():New()
	Local oStruXC5	:= FWFormStruct(2, 'XC5')

	oView:SetModel(oModel)
	oView:AddField('VIEW_XC5' ,oStruXC5,'XC5MASTER')
	oView:CreateHorizontalBox('TELA', 100)
	oView:SetOwnerView('VIEW_XC5','TELA')
        
Return(oView)

Static Function MenuDef()

	Local aRotina := {}
 
 	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFFATBG" OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Legenda'    ACTION 'U_MGFBGLEG()'     OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Reprocessa' ACTION 'U_MGFBGREP()'     OPERATION 6 ACCESS 0
		
Return aRotina

/*/{Protheus.doc} MGFBGREP
Efetua o Reprocessamento do Pedido

@type function
@author Paulo da Mata
@since 17/01/2020
@version P12.1.17
@return Nil
/*/
User Function MGFBGREP

    Local cStatus := XC5->XC5_STATUS
    Local lOk     := .F.

    If cStatus == "4"
       If ApMsgYesNo(OemToAnsi("Deseja enviar o pedido para reprocessar ?"),OemToAnsi("CONFIRMA"))
          XC5->(RecLock("XC5"),.F.)
          XC5->XC5_STATUS := "1"
          XC5->(MsUnLock())
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

/*/{Protheus.doc} MGFBGLEG
Mostra a situação dos pedidos do E-COMMERCE

Status dos Pedidos
==================

1 = Recebido
2 = Processando
3 = Gerado Pedido
4 = Erro

@type function
@author Paulo da Mata
@since 17/01/2020
@version P12.1.17
@return Nil
/*/
User Function MGFBGLEG()

	Local aLegenda := {}
    
    AADD(aLegenda,{"BR_VERDE"    ,"Recebido"      })
    AADD(aLegenda,{"BR_AMARELO"  ,"Processando"   })
    AADD(aLegenda,{"BR_VERMELHO" ,"Gerado Pedido" })
    AADD(aLegenda,{"BR_PRETO"    ,"Erro"          })

    BrwLegenda("Status dos Pedidos","Status dos Pedidos",aLegenda)

Return
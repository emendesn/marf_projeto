#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"        
#include "APWEBEX.CH"
#include "APWEBSRV.CH" 
/*
{Protheus.doc} xmatr260 
@description 
	RTASK0010974-Alterar-campos-especiais-do-pedidos-de-venda-sem-processar-regras-de-bloqueio-FAT14
@author Henrique Vidal Santos
@Type Relatório
@since 06/05/2020
@version P12.1.017
*/

User Function MGFFATBW()

    Local lRet	:= .F.
    Altera  := .T.  // Devido não ter tela, garantir integração dos programas TAS01 e TAS06

    lRet	:= U_TAS01VldMnt({SC5->C5_NUM})
  	
	If lRet
		lRet    := U_TAS01StatPV({SC5->C5_NUM,2})
	EndIf 
	
	If lRet

        RegToMemory("SC5", .F. , .F. )
    
        aCabec      := {}
        aItens      := {}
        aLinha      := {}
    
        aadd(aCabec, {"C5_FILIAL",  SC5->C5_FILIAL  ,   Nil})		
        aadd(aCabec, {"C5_NUM",     SC5->C5_NUM     ,   Nil})
        aadd(aCabec, {"C5_TIPO",    SC5->C5_TIPO    ,   Nil})
        aadd(aCabec, {"C5_CLIENTE", SC5->C5_CLIENTE ,   Nil})
        aadd(aCabec, {"C5_LOJACLI", SC5->C5_LOJACLI ,   Nil})
        aadd(aCabec, {"C5_TPFRETE", SC5->C5_TPFRETE ,   Nil})
        aadd(aCabec, {"C5_ZCROAD", SC5->C5_ZCROAD   ,   Nil})

        cQ := "SELECT * "
		cQ += "FROM "+RetSqlName("SC6")+ " SC6 "
		cQ += "WHERE C6_FILIAL = '"+SC5->C5_FILIAL+"' "
		cQ += "AND SC6.D_E_L_E_T_ = ' ' "
		cQ += "AND C6_NUM = '"+SC5->C5_NUM+"' "
		cQ += "ORDER BY R_E_C_N_O_ "

		cQ := ChangeQuery(cQ)
		dbUseArea( .T. ,"TOPCONN",TCGenQry(,,cQ),"MGF1", .F. , .T. )	

		While MGF1->(!Eof())
   
			aLinha := {}
			aadd(aLinha,{"C6_ITEM",    MGF1->C6_ITEM	, Nil})
			aadd(aLinha,{"C6_PRODUTO", MGF1->C6_PRODUTO	, Nil})
			aadd(aLinha,{"C6_QTDVEN",  MGF1->C6_QTDVEN	, Nil})
			aadd(aLinha,{"C6_PRCVEN",  MGF1->C6_PRCVEN	, Nil})
			aadd(aLinha,{"C6_PRUNIT",  MGF1->C6_PRUNIT	, Nil})
			aadd(aLinha,{"C6_VALOR",   MGF1->C6_VALOR	, Nil})
			aadd(aLinha,{"C6_TES",     MGF1->C6_TES		, Nil})
			aadd(aItens, aLinha)
   
			MGF1->(dbSkip())
		EndDo 
	    MGF1->(dbCloseArea())
        
        FATBW01() // Abre pedido para ser alterado

	EndIf 

Return

/*
@description 
	Tratamento dos campos a serem exibidos na tela para alteração
@author Henrique Vidal Santos
*/
Static Function FATBW01()
    Local aArea        := GetArea()
    Local aAreaC5      := SC5->(GetArea())
    Local aAreaC6      := SC6->(GetArea())
    Local aCampos      := {}
    Private aCampAlt   := {}
     
    //Preenchendo os campos de alteração
    aAdd(aCampAlt, 'C5_MENNOTA')
    aAdd(aCampAlt, 'C5_XOBSPED')
    aAdd(aCampAlt, 'C5_ZDTEMBA')
    aAdd(aCampAlt, 'C5_FECENT')
    aAdd(aCampAlt, 'C5_XAGENDA')
    aAdd(aCampAlt, 'C5_XHORAEN')
    aAdd(aCampAlt, 'C5_HORAFIN')

    //Definindo todos os campos que serão mostrados
    aCampos := aClone(aCampAlt)
    aAdd(aCampos, 'C5_NUM')
    aAdd(aCampos, 'C5_TIPO')
    aAdd(aCampos, 'C5_CLIENTE')
    aAdd(aCampos, 'C5_LOJACLI')
    aAdd(aCampos, 'C5_CONDPAG')
    aAdd(aCampos, 'C5_EMISSAO')
     
    //Tela para alteração de pedido de venda - campos especiais.
    u_FATBW02(aCampos, aCampAlt)
     
    RestArea(aAreaC6)
    RestArea(aAreaC5)
    RestArea(aArea)
Return 

/*
@description 
	Tela para alteração dos dados do pedido de venda
    Recebe dois arrays sendo o 1º array, todos os acampos a serem exibidos , e 2º array com campos que podem ser alterado.
@author Henrique Vidal Santos
*/
User Function FATBW02(aCampos, aCampAlt)
    Local aArea     := GetArea()
    Local aAreaC5   := SC5->(GetArea())
    //Variáveis da Janela
    Local oDlgPed
    Local oGrpAco
    Local oBtnConf
    Local oBtnCanc
    Local lConfirm  := .F.
    Local nTamBtn   := 50
    Local aTamanho  := MsAdvSize()
    Local nJanLarg  := aTamanho[5]
    Local nJanAltu  := aTamanho[6]
    //Variáveis da Enchoice
    Local cAliasE   := "SC5"
    Local nReg      := SC5->(RecNo())
    Local aPos      := {001, 001, (nJanAltu/2)-30, (nJanLarg/2)}
    Local nModelo   := 1
    Local lF3       := .T.
    Local lMemoria  := .T.
    Local lColumn   := .F.
    Local caTela    := ""
    Local lNoFolder := .F.
    Local lProperty := .F.
    Local nCampAtu  := 0
    Local bCampo    := {|nField| Field(nField)}
     
    DEFINE MsDialog oDlgPed TITLE "Alteração de Pedido de Venda" FROM 000,000 TO nJanAltu,nJanLarg PIXEL

        RegToMemory(cAliasE, .F.)
            
        Enchoice(    cAliasE,;
                      nReg,;
                      8,;
                     /*aCRA*/,;
                     /*cLetra*/,;
                     /*cTexto*/,;
                     aCampos,;
                     aPos,;
                     aCampAlt,;
                     nModelo,;
                     /*nColMens*/,;
                     /*cMensagem*/,;
                     /*cTudoOk*/,;
                     oDlgPed,;
                     lF3,;
                     lMemoria,;
                     lColumn,;
                     caTela,;
                     lNoFolder,;
                     lProperty)
             
        //Grupo de Ações
        @ (nJanAltu/2)-27, 001 GROUP oGrpAco TO (nJanAltu/2)-3, (nJanLarg/2) PROMPT "Alteração de Pedido de Venda - Campos especiais: "    OF oDlgPed COLOR 0, 16777215 PIXEL
            @ (nJanAltu/2)-20, (nJanLarg/2)-((nTamBtn*1)+03) BUTTON oBtnConf PROMPT "Confirmar" SIZE nTamBtn, 013 OF oDlgPed PIXEL ACTION (lConfirm := .T., oDlgPed:End())
            @ (nJanAltu/2)-20, (nJanLarg/2)-((nTamBtn*2)+06) BUTTON oBtnCanc PROMPT "Cancelar"  SIZE nTamBtn, 013 OF oDlgPed PIXEL ACTION (lConfirm := .F., oDlgPed:End())
             
    ACTIVATE MsDialog oDlgPed CENTERED
         
    
    If lConfirm
        Begin Transaction
            
            For xz := 1 to Len(aCampAlt)
                aadd(aCabec, {aCampAlt[xz], M->&(aCampAlt[xz]) ,   Nil})
            Next xz
            
            If GetNewPar('MGF_FBW03' , .F.)
                FATBW03('Anterior') //Grava histórico anterior a gravação
            EndIf 

            lMsErroAuto    := .F.
            MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, 4, .F.)

            If lMsErroAuto
                Mostraerro()
                DisarmTransaction() // Desfaz as alterações
            Else
                If GetNewPar('MGF_FBW03' , .F.)
                    FATBW03('Alterado') //Grava histórico da alteração
                EndIf 

                MsgInfo('Registro alterado.')
            EndIf

        End Transaction
    EndIf
         
    RestArea(aAreaC5)
    RestArea(aArea)
Return

/*
@description 
	Grava histórico da alteração realizada no P.V a partir da rotina
@author Henrique Vidal Santos
*/
Static Function FATBW03( cTipo )
	
    RecLock("ZVI",.T.)
        ZVI->ZVI_FILIAL := SC5->C5_FILIAL
        ZVI->ZVI_NUM	:= SC5->C5_NUM
        ZVI->ZVI_DATA	:= Date()
        ZVI->ZVI_HORA	:= substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2)
        ZVI->ZVI_TIPO	:= cTipo
        ZVI->ZVI_USUPRO	:= CUSERNAME
        ZVI->ZVI_USUWIN	:= LogUserName()
        ZVI->ZVI_MICRO	:= ComputerName()
        ZVI->ZVI_ZDTEMB	:= SC5->C5_ZDTEMBA
        ZVI->ZVI_FECENT	:= SC5->C5_FECENT
        ZVI->ZVI_XAGEND	:= SC5->C5_XAGENDA
        ZVI->ZVI_XHORAE	:= SC5->C5_XHORAEN
        ZVI->ZVI_HORAFI	:= SC5->C5_HORAFIN
        ZVI->ZVI_XOBSPE	:= SC5->C5_XOBSPED
        ZVI->ZVI_MENNOT	:= SC5->C5_MENNOTA
	ZVI->(MsUnlock("ZVI"))

Return
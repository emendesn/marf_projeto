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
@history Anderson 08/09/2020 - Rtask RTASK0011592 - Datas para reprogramação e Envio de email
@version P12.1.017
*/

User Function MGFFATBW()

    Local lRet	:= .F.
   

    lRet := U_TAS01VldMnt({SC5->C5_NUM})
  	
	If lRet
		lRet:= U_TAS01StatPV({SC5->C5_NUM,2})
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
        
        FATBW01() // Abre pedido para ser alterado

	EndIf 

Return

/*
@description 
	Tratamento dos campos a serem exibidos na tela para alteração
@author Henrique Vidal Santos
*/
Static Function FATBW01()
    Local aArea         := GetArea()
    Local aAreaC5       := SC5->(GetArea())
    Local aAreaC6       := SC6->(GetArea())
    Local aCampos       := {}
    Private _cCds         := ""

    Private aCampAlt    := {}
     
    //--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
	If !ExisteSx6("MGF_FATBWA")
		CriarSX6("MGF_FATBWA", "C", "CDs que poderão alterar os campos. Ex:010033/010041",'010033/010041/010044/010050/010066')	
	EndIf

    _cCds := SUPERGETMV("MGF_FATBWA",.F., '010033/010041/010044/010050/010066' )

    //Preenchendo os campos de alteração
    aAdd(aCampAlt, 'C5_ZDTREMB')
    aAdd(aCampAlt, 'C5_ZDTENTR')
    aAdd(aCampAlt, 'C5_ZREMBJS')
    aAdd(aCampAlt, 'C5_ZREMBMT')
    aAdd(aCampAlt, 'C5_MENNOTA')
    aAdd(aCampAlt, 'C5_XOBSPED')

    If SC5->C5_FILIAL $ _cCds
        aAdd(aCampAlt, 'C5_ZDTEMBA')
        aAdd(aCampAlt, 'C5_FECENT')
    EndIf

    aAdd(aCampAlt, 'C5_XAGENDA')
    aAdd(aCampAlt, 'C5_XHORAEN')
    aAdd(aCampAlt, 'C5_HORAFIN')

    //Definindo todos os campos que serão mostrados 
    aCampos := aClone(aCampAlt)
    aAdd(aCampos, 'C5_NUM'      )
    aAdd(aCampos, 'C5_TIPO'     )
    aAdd(aCampos, 'C5_CLIENTE'  )
    aAdd(aCampos, 'C5_LOJACLI'  )
    aAdd(aCampos, 'C5_CONDPAG'  )
    aAdd(aCampos, 'C5_EMISSAO'  )
    aAdd(aCampos, 'C5_FECENT'   )
     
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

    private cmailx := .F.
     
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

    
     If ! SC5->C5_FILIAL $ _cCds
        If lConfirm  .and. (Empty(M->C5_ZREMBMT) .or. Empty(M->C5_ZREMBJS))
             u_MGFmsg("Campos  MOTIVO E JUSTIFICATIVA são Obrigatórios . Não será alterado o Pedido de Venda !!!! ")
             Return .F.
        Endif
    Endif

    If ! SC5->C5_FILIAL $ _cCds
       If lConfirm  .and. M->C5_ZDTREMB < Date ()
            u_MGFmsg ("Data de Reprogramação de Embarque deverá ser maior que a Data do Dia !!! ")
            Return .F.
       Endif
    Endif

    
    If lConfirm
            
        If GetNewPar('MGF_FBW03' , .F.)
            FATBW03('Anterior') //Grava histórico anterior a gravação
        EndIf 

        SC5->(RecLock("SC5",.F.))
        For xz := 1 to Len(aCampAlt)
            SC5->&(aCampAlt[xz]) := M->&(aCampAlt[xz])  
        Next xz
         SC5->(MsUnLock())  

        If GetNewPar('MGF_FBW03' , .F.)
            FATBW03('Alterado') //Grava histórico da alteração
        EndIf 

        If ! SC5->C5_FILIAL $ _cCds
            If SC5->C5_NUM = M->C5_NUM  .AND. ! Empty (M->C5_ZREMBMT) .AND. ;
                ! Empty (M->C5_ZREMBJS)  .AND.   ;
                ! Empty (M->C5_ZDTREMB)  .AND.   ;
                ! Empty (M->C5_ZDTENTR)
                envmail(ALLTRIM(UsrRetMail(RetCodUsr())))

                if cmailx
                    envmail(ALLTRIM(UsrRetMail(RetCodUsr())))
                Endif

                MsgInfo('Registro alterado e enviado Email ')
            Else
                MsgInfo('Registro nao alterado  ')
            Endif
        else
             MsgInfo('Registro alterado  ')
        Endif
            
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


Static Function EnvMail(cmailPara)

Local oMail, oMessage
Local nErro      := 0
Local lRetMail    := .T.
Local cSmtpSrv  := GETMV("MGF_SMTPSV")
Local cCtMail   := ""
Local cPwdMail  := ""
//Local nMailPort := GETMV("MGF_PTMAIL")
Local nParSmtpP := GETMV("MGF_PTSMTP")
Local nSmtpPort
Local nTimeOut  := GETMV("MGF_TMOUT")
Local cEmail    :=  ALLTRIM(UsrRetMail(RetCodUsr()))
Local cPara     := cmailPara +  ";" + POSICIONE('SA3',1,XFILIAL('SA3') + SC5->C5_VEND1 ,'A3_EMAIL')
Local cCopia    :=  " "
Local cSubject  :=            ""

Local cErrMail

cCtMail :=  cEmail 

if cmailx
    cPara :=  ALLTRIM(UsrRetMail(RetCodUsr()))
Endif



cSubject              :=            "Reprogramação de Embarque- PEDIDO DE VENDA  - Filial / Numero " + SC5->C5_FILIAL + "/" + SC5->C5_NUM

oMail := TMailManager():New()

If nParSmtpP == 25
    oMail:SetUseSSL( .F. )
    oMail:SetUseTLS( .F. )
    oMail:Init("", cSmtpSrv, "", "",, nParSmtpP)
Elseif nParSmtpP == 465
    nSmtpPort := nParSmtpP
    oMail:SetUseSSL( .T. )
    oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
 else
    nParSmtpP == 587
    nSmtpPort := nParSmtpP
    oMail:SetUseTLS( .T. )
    oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
 endif

 oMail:SetSmtpTimeOut( nTimeOut )
nErro := oMail:SmtpConnect()

If nErro != 0
    cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
    conout(cErrMail)
    oMail:SMTPDisconnect()
     lRetMail := .F.
      Return (lRetMail)
Endif

 If  nParSmtpP != 25
    nErro := oMail:SmtpAuth(cCtMail, cPwdMail)
      If nErro != 0
         cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
          conout(cErrMail)
           oMail:SMTPDisconnect()
          lRetMail := .F.
          Return (lRetMail)
         Endif
  Endif

  oMessage := TMailMessage():New()
  oMessage:Clear()
  oMessage:cFrom                  := cEmail
  oMessage:cTo                    := cPara
  oMessage:cCc                    := cCopia
  oMessage:cSubject               := cSubject
  oMessage:cBody                  := BodyMail()
  
  nErro := oMessage:Send( oMail )

    If  nErro != 0
      
        cmailx := .t.
        MsgInfo('Não enviado os Emails corretamente . Problema nos cadastros do Email (Usuario ou Vendedor). Será enviado email só para o usuario que alterou o Pedido de Venda . Verifique estes Emails -- >  ' + cpara)
       
    Endif

 if nErro != 0
     cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
     conout(cErrMail)
     oMail:SMTPDisconnect()
     lRetMail := .F.
      Return (lRetMail)
 Endif

 conout('Desconectando do SMTP')
 oMail:SMTPDisconnect()

Return .T.


static Function BodyMail()
Local  _cHTML := ""
Local  nQtd := MLCount(SC5->C5_ZREMBJS,150)
 
_cHTML:='<HTML><HEAD><TITLE></TITLE>'
_cHTML+='<META http-equiv=Content-Type content="text/html; charset=windows-1252">'
_cHTML+='<META content="MSHTML 6.00.6000.16735" name=GENERATOR></HEAD>'
_cHTML+='<BODY>'
_cHTML+='<H1><FONT color=#ff0000>Reprogramação de Embarque </FONT></H1>'
_cHTML+='<TABLE cellSpacing=0 cellPadding=0 width="100%" bgColor=#afeeee background="" '
_cHTML+='border=1>'
_cHTML+='  <TBODY>'
_cHTML+='  <TR>'
_cHTML+='    <TD><b>Filial / Número Pedido</b></TD>'
_cHTML+='<TD>' + SC5->C5_FILIAL + "/" + SC5->C5_NUM + '</TD></TR>'
//_cHTML+='  <TR>'
_cHTML+='    <TD><b>Data Emissao</b></TD>'
_cHTML+='    <TD>' + SUBSTRING(DTOS(SC5->C5_EMISSAO),7,2) + "/" + SUBSTRING(DTOS(SC5->C5_EMISSAO),5,2) + "/" + SUBSTRING(DTOS(SC5->C5_EMISSAO),1,4) + '</TD></TR>'

_cHTML+='    <TD><b>Data Entrega</b></TD>'
_cHTML+='    <TD> ' + SUBSTRING(DTOS(DATE()),7,2) + "/" + SUBSTRING(DTOS(DATE()),5,2) + "/" + SUBSTRING(DTOS(DATE()),1,4) + '</TD></TR>'

_cHTML+='    <TD><b>Nome Vendedor</b></TD>'
_cHTML+='    <TD>' + POSICIONE('SA3',1,XFILIAL('SA3') + SC5->C5_VEND1 ,'A3_NOME') + '</TD></TR>'

_cHTML+='    <TD><b>Nome Cliente</b></TD>'
_cHTML+='    <TD>' + POSICIONE('SA1',1,XFILIAL('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI ,'A1_NOME') + '</TD></TR>'

//_cHTML+='  <TR>'

_cHTML+='    <TD><b>Motivo</b></TD>'

If SC5->C5_ZREMBMT == "1"
    _cHTML+='    <TD>COMERCIAL</TD></TR>'
Elseif   SC5->C5_ZREMBMT == "2"
    _cHTML+='    <TD>TRANSPORTE</TD></TR>'
Elseif   SC5->C5_ZREMBMT == "3"
    _cHTML+='    <TD>OPERACAO</TD></TR>'
Elseif   SC5->C5_ZREMBMT == "4"
    _cHTML+='    <TD>QUALIDADE</TD></TR>'
Elseif   SC5->C5_ZREMBMT == "5"
    _cHTML+='    <TD>EXPEDICAO</TD></TR>'
Endif 

    For ni:=1 to nQTd
     _cHTML+='    <TD><b>Justificativa</b></TD>'
	 _cHTML+='    <TD>' +  MemoLine(SC5->C5_ZREMBJS,,ni) + '</TD></TR>'
    Next ni


_cHTML+='    <TD><b>Data Reprogramação Embarque</b></TD>'
_cHTML+='    <TD> ' + SUBSTRING(DTOS(C5_ZDTREMB),7,2) + "/" + SUBSTRING(DTOS(C5_ZDTREMB),5,2) + "/" + SUBSTRING(DTOS(C5_ZDTREMB),1,4) + '</TD></TR>'


_cHTML+='    <TD><b>Data Reprog. Entrega</b></TD>'
_cHTML+='    <TD> ' + SUBSTRING(DTOS(C5_ZDTENTR),7,2) + "/" + SUBSTRING(DTOS(C5_ZDTENTR),5,2) + "/" + SUBSTRING(DTOS(C5_ZDTENTR),1,4) + '</TD></TR>'

DbSelectArea("SC6")
DbSetOrder(1)                       
    If DbSeek(xFilial("SC5") + SC5->C5_NUM)

        While 	SC6->(!EOF()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM 	== SC5->C5_NUM

            _cHTML+='    <TD><b>Produtos - Item : ' + SC6->C6_ITEM + ' </b></TD>'
            _cHTML+='    <TD> ' + SC6->C6_PRODUTO + " - "  + POSICIONE('SB1',1,XFILIAL('SB1') + SC6->C6_PRODUTO ,'B1_DESC') + '</TD></TR>'

        SC6->(DbSkip())
        End     	
    Endif

     _cHTML+='    <TD></TD></TR></TBODY></TABLE>'

_cHTML+='  <TR>'

_cHTML+='<P>&nbsp;</P>'
//_cHTML+='<P><A '
_cHTML+='</BODY></HTML>'

return _cHTML

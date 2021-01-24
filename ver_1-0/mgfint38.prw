#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MGFINT38
Autor...............: Marcelo Carneiro
Data................: 28/03/2017
Descricao / Objetivo: Integração De Cadastros
Doc. Origem.........: Contrato GAPS - MIT044- BLOQUEIO DE CADASTROS
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Pontos de Entrada para a Gravação das Tabelas ZB3 ZB2 ZB5

Alteração...........: Inclusão da loja no código do cliente
Autor...............: Cláudio Alves
Data................: 01/10/2019
Descricao / Objetivo: Inclusão da loja no código do cliente
Doc. Origem.........: Contrato GAPS - MIT044- BLOQUEIO DE CADASTROS
Solicitante.........: Ana Rancan
Uso.................: Marfrig
Obs.................: Foi incluído o campo SA1->A1_LOJA para melhorar a
					  identificação do cliente.

Alteração...........: Validação campo B1_MSBLQL
Autor...............: Antonio Carlos
Data................: 28/10/2019
Descricao / Objetivo: Removida a variável bAltBlq
Doc. Origem.........: PRB0040355 Alteração campo B1_MSBLQL
Solicitante.........: Ana Rancan
Uso.................: Marfrig
Obs.................: No IF anterior if bAltBlq .OR.
					  Foi removida a variável bAltBlq.
=====================================================================================

@alteraçães 17/10/2019 - Henrique Vidal
	Criada da função MGF38_EXC
	RTASK0010137 - Impedir exclusão de registro do cadastro com pendências na Grade
	             - Verifica se cadastrados vinculados a grade de aprovação, podem ser exclusos.
*/
*/
User Function MGFINT38(cTab,cSufixo)
Local cVOld  := ''
Local cVNew  := ''
//Local cUserA := FWLeUserlg(cSufixo+"_USERLGA")
//Local cDataA := FWLeUserlg(cSufixo+"_USERLGA", 2)
Local bCad       := .T.
Local nID        :=  ''
Local cCad       := ''
Local bPassou    := .F.
Local aRet       := {}
Local lContinua	 := .F.
Local _cSEL   	 := " " 
Local _aSEL      := {}
Local _xTexto    := ''
Local _nSEL      := 2 //1 = Sim; 2 = Não; 3 = Cancelar  

local cZB1USER		:= ""
local cUsrSaForc	:= allTrim( superGetMv( "MGF_INT39A" , , "004703" ) )
local cUsrEComme	:= allTrim( superGetMv( "MGF_INT39E" , , "" ) )
local aX3Finance	:= {} // Campos do financeiro
local cFinPenFin	:= allTrim( superGetMv( "MGF_INT39B" , , "07" ) ) // 07 - FINANCEIRO - PENDENC
local cFinInativ	:= allTrim( superGetMv( "MGF_INT39C" , , "08" ) ) // 08 - FINANCEIRO - INATIVI
local cFinBlqRec	:= allTrim( superGetMv( "MGF_INT39D" , , "09" ) ) // 09 - FINANCEIRO - RECEITA
local ColabFilial   := ""
local cUnit         := ""
local cUsrSFSA2		:= AllTrim( superGetMv( "MGF_INT39F" , , "004747" ) )

Private aSX3     := {}
Private aFolder  := {}
Private bAltBlq  := .F.
Private bAltTipo := .F.


//Se é cliente vindo pela integração de cadastro de funcionário
//e for cliente de loja montana, não passa pela grade
If isincallstack("U_MGFINT02") .and. cTab == "SA1" 

  colabfilial := alltrim(M->A1_ZCFIL)
  cunit := AllTrim( SuperGetMv( "MGF_INT39E" , , "010001/010065/010041/010039/010042/010045/020003/010069/010068/010070/010067" ) ) 

  if AllTrim(ColabFilial)$cUnit

	Return .T.

  Endif

Endif

if ( isInCallStack( "INSERTORUPDATECUSTOMER" ) .AND. FunName() == "MGFWSS11" .AND. cTab == "SA1" )
	if lPulaGrade
		Return .T.
	endif
endif

IF !ALTERA
    Return .T.
ElseIF cTab = "SA1" .AND. &(cTab+'->'+cSufixo+"_MSBLQL") == '1' // CLIENTE
	_xTexto += ''
	_xTexto += ' Cliente INATIVO.'
	_xtexto += ' Deseja prosseguir apenas com a alteração de cadastro sem ativar o mesmo ?' +CRLF+CRLF+CRLF
	_xTexto += ' -> Clique em SIM para realizar apenas a alteração (o registro continuará INATIVO)' +CRLF+CRLF
	_xTexto += ' -> Clique em NÃO para alterar o registro e enviar o mesmo para a Grade de Aprovação(o registro será alterado para ATIVO)' +CRLF+CRLF
	_xTexto += ' -> Clique em CANCELAR para não realizar nenhuma alteração no registro' +CRLF

	If !IsBlind()
		nRet := AVISO("Alteração cadastro de cliente", _xTexto,{"Não","Sim","Cancelar"},3)
		If nRet == 1
			_nSel := 2
		elseIf nRet == 2
			_nSel := 1
		else
			lRet := .f.
			Return lRet
		Endif
	EndIf
EndIf

if &(cTab+'->'+cSufixo+"_MSBLQL") == '1'
	if U_MGF38_PED(cTab,cSufixo)
		Help( ,, 'Help',, 'Não é possível alterar, pois já o registro está pendente de aprovação !', 1, 0 )
		Return .F.
	Else
		dbSelectArea("SX3")
		SX3->(DbSetOrder(1))
		SX3->(dbSeek(cTab))
		
		While ( SX3->(!EOF()) .And. SX3->X3_ARQUIVO == cTab )
			If X3USO(SX3->X3_USADO) .AND. !(SX3->X3_VISUAL $ ('V') ) .AND. (SX3->X3_CONTEXT <> "V"  )
				If VALTYPE('M->'+SX3->X3_CAMPO) <> 'U'
				    If &('M->'+Alltrim(SX3->X3_CAMPO)) <> &(cTab+'->'+Alltrim(SX3->X3_CAMPO))
						lContinua:= .t.
						IF (Alltrim(SX3->X3_CAMPO))== "B1_MSBLQL"
						   bAltBlq := .T.
						EndIF
					EndIF
				EndIF
			EndIF
			SX3->(dbSkip())
		EndDo
		
		If !lContinua
			Return .T.
		EndIf
	EndIf
EndIf

IF ( FunName() <> "RPC"  .AND.  FunName() <> 'MGFTAC10' .AND.  FunName() <> 'MGFINT37'  .AND. _nSEL == 2)  .OR. ( ( isInCallStack( "RETORNOCONSULTA" ) .OR. isInCallStack( "INSERTORUPDATECUSTOMER" ) ) .AND. FunName() == "RPC" .AND. cTab == "SA1" )
	cZB1USER := ""

	if ( isInCallStack( "INSERTORUPDATECUSTOMER" ) .AND. FunName() == "MGFWSS11" .AND. cTab == "SA1" )
		// SE ORIGEM SALESFORCE COLOCA CODIGO DO VENDEDOR
		cZB1USER := cUsrSaForc
	elseif ( isInCallStack( "INSERTORUPDATECUSTOMER" ) .AND. FunName() == "MGFWSS07" .AND. cTab == "SA1" )
		// SE ORIGEM E-COMMERCE COLOCA CODIGO DO VENDEDOR
		cZB1USER := cUsrEComme
	ElseIf FunName() == "MGFWSS24" .AND. cTab == "SA2"
		cZB1USER := cUsrSFSA2
	else
		cZB1USER := RetCodUsr()
	endif

	aSX3    := {}
	aFolder := {}
	cCad    := U_INT38_CAD(cTab)

	dbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(dbSeek(cTab))
	
	While ( SX3->(!EOF()) .And. SX3->X3_ARQUIVO == cTab )
		If X3USO(SX3->X3_USADO) .AND. !(SX3->X3_VISUAL $ ('V') ) .AND. (SX3->X3_CONTEXT <> "V"  )
			IF VALTYPE('M->'+SX3->X3_CAMPO) <> 'U' //.AND. SX3->X3_CAMPO <>&(cSufixo+"_MSBLQL") //.AND. SX3->X3_CAMPO <> 'A1_ZBOLETO' .AND. SX3->X3_CAMPO <> 'A1_ZGDERED' ALTERADO RAFAEL 13/12/18
				IF &('M->'+Alltrim(SX3->X3_CAMPO)) <> &(cTab+'->'+Alltrim(SX3->X3_CAMPO))
					IF Alltrim(SX3->X3_CAMPO) == "B1_TIPO"
					    bAltTipo := .T.
					ENDIF

					if allTrim( SX3->X3_CAMPO ) $ "A1_XPENFIN | A1_ZINATIV | A1_XBLQREC"
						aadd( aX3Finance , SX3->X3_CAMPO )
					endif

					AAdd(aSX3,{SX3->X3_CAMPO,SX3->X3_TITULO,SX3->X3_TIPO,SX3->X3_FOLDER})
					If aScan(aFolder,{|x| x == SX3->X3_FOLDER} ) == 0
						AAdd(aFolder,SX3->X3_FOLDER)
					EndIf
				EndIf
			EndIf
		EndIf
	
		SX3->(dbSkip())
	
	EndDo
	
	For nI := 1 To Len(aSX3)
		// Cadastra o Pai
		If bCad
			bCad   := .F.
			nID    := U_INT38_ID()

			RecLock("ZB1", .T.)
			ZB1->ZB1_ID     := nID
			ZB1->(msUnlock())
			
			If cTab $ 'SA2 SA1 SB1'
				aRet := ROT_ALTERA(cCad,nID,cTab)
			Else
				aRet := U_INT38_ROT(cCad,nID)
			EndIf
			
			If !aRet[01]
				Reclock("ZB1",.F.)
				ZB1->(dbDelete())
				ZB1->(MsUnlock())
				Help( ,, 'Help',, 'Não existe roteiro de Aprovação', 1, 0 )
				Return .F.
			EndIf

			RecLock("ZB1", .F.)

			ZB1->ZB1_TIPO   := '2'
			ZB1->ZB1_CAD    := cCad
			ZB1->ZB1_RECNO  := &(cTab+'->(Recno())')
			ZB1->ZB1_USER   := cZB1USER
			ZB1->ZB1_DATA   := Date()
			ZB1->ZB1_HORA   := Time()
			ZB1->ZB1_STATUS := '3'
			ZB1->ZB1_EMAIL  := 'N'

			if len( aX3Finance ) > 0 .and. cTab == "SA1"
				//if allTrim( SX3->X3_CAMPO ) $ "A1_XPENFIN | A1_ZINATIV | A1_XBLQREC"
				if aScan( aX3Finance ,{ | x | allTrim( x ) == "A1_XPENFIN" } ) > 0 .and. M->A1_XPENFIN == "S"
					ZB1->ZB1_IDSET  := cFinPenFin
				elseif aScan( aX3Finance ,{ | x | allTrim( x ) == "A1_XBLQREC" } ) > 0 .and. M->A1_XBLQREC == "S"
					ZB1->ZB1_IDSET  := cFinBlqRec
				elseif aScan( aX3Finance ,{ | x | allTrim( x ) == "A1_ZINATIV" } ) > 0 .and. M->A1_ZINATIV == "1"
					ZB1->ZB1_IDSET  := cFinInativ
				else
					ZB1->ZB1_IDSET  := aRet[02]
				endif
			else
				ZB1->ZB1_IDSET  := aRet[02]
			endif

			DO CASE
				CASE cCad  == '1'
					 ZB1->ZB1_COD   := SA1->A1_COD + '-' + SA1->A1_LOJA
					 ZB1->ZB1_DADOS := SA1->A1_NOME
				CASE cCad  == '2'
					 ZB1->ZB1_COD   := SZ9->Z9_ZCLIENT + '-' + SZ9->Z9_ZLOJA
					 ZB1->ZB1_DADOS := SZ9->Z9_ZRAZEND
				CASE cCad  == '3'
					 ZB1->ZB1_COD   := SA2->A2_COD + '-' + SA2->A2_LOJA
					 ZB1->ZB1_DADOS := SA2->A2_NOME
				CASE cCad  == '4'
					 ZB1->ZB1_COD   := SA4->A4_COD
					 ZB1->ZB1_DADOS := SA4->A4_NOME
				CASE cCad  == '5'
					 ZB1->ZB1_COD   := SA3->A3_COD
					 ZB1->ZB1_DADOS := SA3->A3_NOME
				CASE cCad  == '6'
					 ZB1->ZB1_COD   := DA3->DA3_COD
					 ZB1->ZB1_DADOS := DA3->DA3_DESC
				CASE cCad  == '7'
					 ZB1->ZB1_COD   := DA4->DA4_COD
					 ZB1->ZB1_DADOS := DA4->DA4_NOME
				CASE cCad  == '8'
					 ZB1->ZB1_COD   := SB1->B1_COD
					 ZB1->ZB1_DADOS := SB1->B1_DESC
			ENDCASE
			ZB1->(MsUnlock())
		EndIf

		bPassou := .T.
		RecLock("ZB3", .T.)
		ZB3->ZB3_ID     := nID
		ZB3->ZB3_CAMPO	:= aSX3[nI][01]
		ZB3->ZB3_DESC   := aSX3[nI][02]
		ZB3->ZB3_TIPO   := aSX3[nI][03]

		If aSX3[nI][03] == 'D'
			cVNew := DTOC(&('M->'+Alltrim(aSX3[nI][01])))
			cVOld := DTOC(&(cTab+'->'+Alltrim(aSX3[nI][01])))
		ElseIf aSX3[nI][03] == 'N'
			cVNew := Alltrim(STR(&('M->'+Alltrim(aSX3[nI][01]))))
			cVOld := Alltrim(STR(&(cTab+'->'+Alltrim(aSX3[nI][01]))))
		ElseIf aSX3[nI][03] == 'L'
			cVNew := IIf(&('M->'+Alltrim(aSX3[nI][01])),'T','F')
			cVOld := IIf(&(cTab+'->'+Alltrim(aSX3[nI][01])),'T','F')
		Else
			cVNew := &('M->'+Alltrim(aSX3[nI][01]))
			cVOld := &(cTab+'->'+Alltrim(aSX3[nI][01]))
		EndIf

		ZB3->ZB3_OLD   	:= cVOld
		ZB3->ZB3_NEW    := cVNew
		ZB3->ZB3_ABA    := aSX3[nI][04]
		ZB3->(msUnlock())
	Next nI

	If bPassou
		If cTab <> 'SZ9' .And. U_INT38_VMOT(cTab) .and. !U_xMG38Alc(nID)

			// Determina o Bloqueio do Registro
			&('M->'+cSufixo+"_MSBLQL") := '1'
			RecLock(cTab, .f.)
			&(cTab+"->"+cSufixo+"_MSBLQL") := '1'
			&(cTab+"->(msUnlock())")
		else
			//Determina a Aprovação no Registro
			&('M->'+cSufixo+"_MSBLQL") := '2'
			&('M->'+cSufixo+"_MSBLQL") := '2'
			RecLock(cTab, .f.)
			&(cTab+"->"+cSufixo+"_MSBLQL") := '2'
			&(cTab+"->(msUnlock())")

			ZB1->(dbSetOrder(1))//ZB1_ID

			If ZB1->(dbSeek(nID))
				Reclock("ZB1",.F.)
				ZB1->ZB1_STATUS := '1'
				ZB1->(MsUnLock())
			EndIf

		EndIf

	EndIf

EndIf

Return .T.


User Function INT38_CAD(cTab)

Local cCad := ''

If 		cTab == 'SA1'
    	cCad := '1'
ElseIf  cTab =='SZ9'
    	cCad := '2'
ElseIf  cTab =='SA2'
    	cCad := '3'
ElseIf  cTab =='SA4'
    	cCad := '4'
ElseIf  cTab =='SA3'
    	cCad := '5'
ElseIf  cTab =='DA3'
    	cCad := '6'
ElseIf  cTab =='DA4'
		cCad := '7'
ElseIf  cTab =='SB1'
		cCad := '8'
EndIf

Return cCad


User Function INT38_ID

Local aArea		 := GetArea()
Local aAreaZB1   := ZB1->(GetArea())
Local cID

While .t.

	cID := GetSxeNum("ZB1","ZB1_ID")

	//Verifica se o número ja existe na base, se ja existir, pega o próximo
	ZB1->(DbSetOrder(1)) //ZB1_ID
	ZB1->(DbSeek(cID))
	
	If ZB1->(Found())
		ConfirmSX8()
	Else
		exit
	EndIf

EndDo

ConfirmSX8()

RestArea(aAreaZB1)
RestArea(aArea)

Return cID


User Function INT38_ROT(cCad,nID)
Local bRet   := .F.
Local nCont  := 0
Local cIDSET := ''

dbSelectArea('ZB4')
ZB4->(DBOrderNickname("ZB4IND4"))//ZB4_CAD+ZB4_TIPO+ZB4_ABA
If ZB4->(dbSeek(cCad+' '))
	// EXECCAO PARA CADASTRO DO SALESFORCE ADICIONADA:
	// NAO IRA GERAR BLOQUEIO PARA FINANCIEIRO, POIS APROVACAO SERA NO CRM
	While ZB4->(!EOF()) .And. ZB4->ZB4_CAD == cCad .And. ZB4->ZB4_TIPO == ' ' .and. !( funName() == "MGFWSS11" .and. cCad == "1" .and. ZB4->ZB4_IDSET == "04" )
		nCont++
		RecLock( "ZB2", .T. )
		bRet := .T.
		ZB2->ZB2_ID     := nID
		ZB2->ZB2_IDSET  := ZB4->ZB4_IDSET
		If U_FIS40Aprovr(ZB4->ZB4_IDSET,cCad) // Natanael - 30/10/2018 - GAP387 - Criar inteligÃªncia no campo CNAE do cliente x Grupo de TributaÃ§Ã£o
			ZB2->ZB2_SEQ    := '00'
			ZB2->ZB2_STATUS := '1' //Aprovado
			ZB2->ZB2_OBS	:= 'Liberação automática'
			ZB2->ZB2_IDAPR  := RetCodUsr()
			ZB2->ZB2_DATA   := Date()
			ZB2->ZB2_HORA   := Time()
			nCont  			:= nCont-- //Retorna o contador para nÃ£o entrar na sequencia de aprovaÃ§Ã£o ZB1_IDSET
		Else
			ZB2->ZB2_SEQ    := ZB4->ZB4_SEQ
			ZB2->ZB2_STATUS := '3'
		EndIf
		ZB2->ZB2_EMAIL  := IIf(nCont ==1, 'S','N')
		If nCont == 1 .AND. Empty(Alltrim(cIDSet))
			cIDSet := ZB4->ZB4_IDSET
		EndIf
		ZB2->(msUnlock())
		ZB4->(dbSkip())
	enddo

EndIf
Return {bRet,cIDSet}


User Function INT38_VMOT(cTab)
Local bRet     := .T.
Local bFDS     := .F.
Local cHora    := SUBSTR(Time(),5)
Local cHoraIni := PADR(getMv("MGF_CAD041"),5)
Local cHoraFim := PADR(getMv("MGF_CAD042"),5)

If cTab == 'DA3' .OR. cTab == 'DA4'
     dbSelectArea('ZB5')
     ZB5->(dbSetOrder(1))
     ZB5->(dbGoTOp())
     // Verifica se a tabela esta vazia
     if ZB5->(!EOF())
	     //Verifica sem data é final de semana
	     if ZB5->(dbSeek(cFilAnt+DTOS(Date())))
	        bFDS := .T.
	     EndIf

	     If ZB5->(dbSeek(SPACE(6)+DTOS(Date())))
	        bFDS := .T.
	     EndIf

	     // VerIfica o Horario
	     If !bFDS
	          If !(cHora >= cHoraIni .And. cHora <= cHoraFim)
	             bFDS := .T.
	          EndIf
	     EndIf

	     If bFDS
	         bRet := .F.
	     EndIf
    EndIf
EndIf
Return bRet


User Function MGF38_CDM(cTab,cSufixo, bMVC)
Local cCad   := ''
Local bTem   := .F.

Default bMVC := .F.

If isincallstack("u_MGFINT02")
	Return .T.
Endif

If !ALTERA
     If bMVC
         Return .F.
     Else
         Return
     EndIf
EndIf

If &(cTab+'->'+cSufixo+"_MSBLQL") <> '1'
	 If bMVC
         Return .F.
     Else
         Return
     EndIf
EndIf

cCad   := U_INT38_CAD(cTab)

cQuery  := " SELECT * "
cQuery  += " FROM "+RetSqlName("ZB1")
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += " AND ZB1_CAD    = '"+cCad+"' "
cQuery  += " AND ZB1_RECNO  = "+Alltrim(STR(&(cTab+'->(Recno())')))+" "
cQuery  += " AND ZB1_STATUS in ('3','4') "

If Select("QRY_ID") > 0
	QRY_ID->(dbCloseArea())
EndIf

cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ID",.T.,.F.)
dbSelectArea("QRY_ID")

QRY_ID->(dbGoTop())

If !QRY_ID->(EOF())
    bTem   := .T.
endif
if bTem
    Help( ,, 'Help',, 'Este registro está pendente de Aprovação, qualquer alteração efetuada Não será gravada!!', 1, 0 )
//else      alterado Rafael 13/11/18
//    Help( ,, 'Help',, 'O Registro encontra-se Bloqueado, somente é possível alterar a situação, caso altere algum outro campo a alteração será descartada!!', 1, 0 )
endif

Return


User Function MGF38_PED(cTab,cSufixo)

Local cCad   := ''
Local bTem   := .F.
Local cQuery := ''

cCad    := U_INT38_CAD(cTab)

cQuery  := " SELECT * "
cQuery  += " FROM "+RetSqlName("ZB1")
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += " AND ZB1_CAD    = '"+cCad+"' "
cQuery  += " AND ZB1_RECNO  = "+Alltrim(STR(&(cTab+'->(Recno())')))+" "
cQuery  += " AND ZB1_STATUS in ('3','4') "

If Select("QRY_ID") > 0
	QRY_ID->(dbCloseArea())
EndIf

cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ID",.T.,.F.)
dbSelectArea("QRY_ID")

QRY_ID->(dbGoTop())

If !QRY_ID->(EOF())
    bTem  := .T.
EndIf

Return bTem

*****************************************************************************************************************************************

User Function MGF38_EXC(cTab,cSufixo)
Local cCad   := ''
Local bTem   := .F.
Local cQuery := ''

cCad    := U_INT38_CAD(cTab)
cQuery  := " SELECT * "
cQuery  += " FROM "+RetSqlName("ZB1")
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += " AND ZB1_CAD    = '"+cCad+"' "
cQuery  += " AND ZB1_RECNO  = "+Alltrim(STR(&(cTab+'->(Recno())')))+" "
cQuery  += " AND ZB1_STATUS IN ('3','4') "
cQuery  += " AND ZB1_TIPO <> '1' "

If Select("QRY_ID") > 0
	QRY_ID->(dbCloseArea())
EndIf

cQuery  := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ID",.T.,.F.)
dbSelectArea("QRY_ID")
QRY_ID->(dbGoTop())

IF !QRY_ID->(EOF())
    bTem   := .T.
EndIF

Return bTem

// rotina chamada pelo ponto de entrada OMSA060
User Function MGF38_MVC(cTab,cSufixo)

Local oObj     := IIf(Type("ParamIxb[1]")!="U",ParamIxb[1],Nil)
Local cIdPonto := IIf(Type("ParamIxb[2]")!="U",ParamIxb[2],"")
Local cIdModel := IIf(Type("ParamIxb[3]")!="U",ParamIxb[3],"")
Local nOpcx    := 0
Local uRet     := .T.

If oObj == Nil .or. Empty(cIdPonto)
	Return(uRet)
EndIf

nOpcx := oObj:GetOperation()

If cIdPonto == "MODELVLDACTIVE"
	If nOpcx == MODEL_OPERATION_UPDATE
		uRet := U_MGF38_CDM(cTab,cSufixo, .T.)
	EndIf
EndIf

If cIdPonto == "FORMPOS"
    If cTab == 'DA3'

		If nOpcx == MODEL_OPERATION_INSERT .OR. nOpcx == MODEL_OPERATION_UPDATE
		    If U_INT38_VMOT(cTab)
		         oObj:SetValue(cTab+"_MSBLQL", "1")
		    EndIf
		EndIf

	EndIf

    If cTab == 'DA4'

		If nOpcx == MODEL_OPERATION_INSERT
		    If U_INT38_VMOT(cTab)
		         oObj:SetValue(cTab+"_MSBLQL", "1")
		    EndIf
		EndIf

		If nOpcx == MODEL_OPERATION_UPDATE

		    uRet := U_MGFINT38('DA4','DA4')

		    If uRet .And. U_INT38_VMOT(cTab)
		         oObj:SetValue(cTab+"_MSBLQL", "1")
		    EndIf

		EndIf

	EndIf

EndIf

Return(uRet)


Static Function ROT_ALTERA(cCad,nID,cTab)
Local bRet   := .F.
Local nCont  := 0
Local cIDSET := ''
Local nI     := 0
Local cQuery := ''
Local cABAS  := "'X'"
If Len(aFolder)== 0
    Return {bRet,cIDSet}
EndIf

dbSelectArea('SXA')
SXA->(dbSetOrder(1))

bRet   := .T.
dbSelectArea('ZB4')
ZB4->(DBOrderNickname("ZB4IND4"))//ZB4_CAD+ZB4_TIPO+ZB4_ABA
For nI := 1 To Len(aFolder)
   If ZB4->(!dbSeek(cCad+'A'+aFolder[nI]))
	  bRet   := .F.
   EndIf
   cABAS  += ",'"+aFolder[nI]+"'"
Next nI


IF bRet
	if bAltTipo   //bAltBlq  .OR.  //antes incluia essa variável
		ZB4->(dbSeek(cCad+' '))
		// EXECCAO PARA CADASTRO DO SALESFORCE ADICIONADA:
		// NAO IRA GERAR BLOQUEIO PARA FINANCIEIRO, POIS APROVACAO SERA NO CRM
        While ZB4->(!Eof()) .AND. ZB4->ZB4_CAD== cCad .And. ZB4->ZB4_TIPO==' ' .and. !( funName() == "MGFWSS11" .and. cTab == "SA1" .and. ZB4->ZB4_IDSET == "04" )
	        nCont++
	        RecLock("ZB2", .T.)
			ZB2->ZB2_ID     := nID
			ZB2->ZB2_SEQ    := '00'
			ZB2->ZB2_IDSET  := ZB4->ZB4_IDSET
			ZB2->ZB2_STATUS := '3'
			ZB2->ZB2_IDABA  := '1'
			If SXA->(dbSeek(cTab+'1'))
		        ZB2->ZB2_ABA    :=SXA->XA_DESCRIC
			EndIf
			ZB2->ZB2_EMAIL  := IIf(nCont ==1, 'S','N')
			ZB2->(msUnlock())
			bRet := .T.
			If nCont == 1
			    cIDSet := ZB4->ZB4_IDSET
			EndIf
			ZB4->(dbSkip())
       End
   EndIf
	cQuery  := " SELECT * "
	cQuery  += " FROM "+RetSqlName("ZB4")
	cQuery  += " WHERE D_E_L_E_T_  = ' ' "
	cQuery  += " AND ZB4_TIPO='A' "
	cQuery  += " AND ZB4_CAD    = '"+cCad+"' "
	cQuery  += " AND ZB4_ABA in ("+cABAS+")"
	cQuery  += " Order by ZB4_SEQ "
	If Select("QRY_ABA") > 0
		QRY_ABA->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ABA",.T.,.F.)
	dbSelectArea("QRY_ABA")
	QRY_ABA->(dbGoTop())
	While QRY_ABA->(!EOF())
		// EXECCAO PARA CADASTRO DO SALESFORCE ADICIONADA:
		// NAO IRA GERAR BLOQUEIO PARA FINANCIEIRO, POIS APROVACAO SERA NO CRM
		If !( funName() == "MGFWSS11" .and. cTab == "SA1" .and. ZB4->ZB4_IDSET == "04" )
			nCont++
			RecLock("ZB2", .T.)
			ZB2->ZB2_ID     := nID
			ZB2->ZB2_SEQ    := QRY_ABA->ZB4_SEQ
			ZB2->ZB2_IDSET  := QRY_ABA->ZB4_IDSET
			ZB2->ZB2_STATUS := '3'
			ZB2->ZB2_IDABA  := QRY_ABA->ZB4_ABA
			If SXA->(dbSeek(cTab+QRY_ABA->ZB4_ABA))
				ZB2->ZB2_ABA    :=SXA->XA_DESCRIC
			EndIf
			ZB2->ZB2_EMAIL  := IIf(nCont ==1, 'S','N')
			ZB2->(msUnlock())
			bRet := .T.
			If nCont == 1
				cIDSet := QRY_ABA->ZB4_IDSET
			EndIf
		EndIf
		QRY_ABA->(dbSkip())
	 End
EndIF
Return {bRet,cIDSet}

/*/{Protheus.doc} xMG38Alc
	Verifica se Alçada esta Liberada
	@type function

	@param		cId, Id da tabela ZB1
	@return  	lRet, .T. PARA GERAR BLOQUEIO, .F. Entra como liberado

	@author Joni Lima do Carmo
	@since 17/07/2019
	@version P12
/*/
User Function xMG38Alc(cId)

	Local aArea	     := GetArea()
	Local lRet       := .T.
	Local cNextAlias := GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	EndIf

	BeginSql Alias cNextAlias

		SELECT
			ZB2.ZB2_ID,
			ZB2.ZB2_IDSET
		FROM
			%Table:ZB1% ZB1
		INNER JOIN
			%Table:ZB2% ZB2
				ON ZB2.ZB2_FILIAL = ZB1.ZB1_FILIAL
				AND ZB2.ZB2_ID = ZB1.ZB1_ID
		WHERE
				ZB1.%NotDel%
			AND ZB2.%NotDel%
			AND ZB1.ZB1_ID = %Exp:cId%
			AND ZB2.ZB2_STATUS <> '1'

	EndSql

	(cNextAlias)->(dbGoTop())

	If (cNextAlias)->(!EOF())
		lRet := .F.
	EndIf

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	EndIf

	RestArea(aArea)

Return lRet

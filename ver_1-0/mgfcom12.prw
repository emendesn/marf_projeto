#Include 'Protheus.ch'
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"

Static _aErr

//Envios
WSSTRUCT WSMGF12_APRENV
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
	WSDATA APROVADOR    as String
	WSDATA SUBSTITUTO	as String
	WSDATA OBSERVACAO	as String
ENDWSSTRUCT

WSSTRUCT WSMGF12_BLQENV
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
	WSDATA APROVADOR    as String
	WSDATA SUBSTITUTO	as String
	WSDATA OBSERVACAO	as String
ENDWSSTRUCT

WSSTRUCT WSMGF12_REJENV
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
	WSDATA APROVADOR    as String
	WSDATA SUBSTITUTO	as String
	WSDATA OBSERVACAO	as String
ENDWSSTRUCT

//Fluig
WSSTRUCT WSMGF12_BLQFLGA
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
ENDWSSTRUCT

WSSTRUCT WSMGF12_DESFLGA
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
ENDWSSTRUCT


//Retornos
WSSTRUCT WSMGF12_APRRET
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSTRUCT WSMGF12_BLQRET
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSTRUCT WSMGF12_REJRET
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSTRUCT WSMGF12_FLGBLQ
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSTRUCT WSMGF12_FLGDES
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

//
WSSTRUCT WSMGF12_VERSTAT
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
	WSDATA APROV    	as String
ENDWSSTRUCT

WSSTRUCT WSMGF12_RETSTAT
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFCOM12 DESCRIPTION "Aprovar Pedido" NAMESPACE "http://www.totvs.com.br/MGFCOM12"

	WSDATA WSENVAPR  as WSMGF12_APRENV
	WSDATA WSENVBLQ  as WSMGF12_BLQENV
	WSDATA WSENVREJ  as WSMGF12_REJENV
	WSDATA WSENVBFLG as WSMGF12_BLQFLGA
	WSDATA WSENVDFLG as WSMGF12_DESFLGA
			
	//Retornos
	WSDATA WSRETAPR   as WSMGF12_APRRET
	WSDATA WSRETBLQ   as WSMGF12_BLQRET
	WSDATA WSRETREJ   as WSMGF12_REJRET
	WSDATA WSRETBFLG  as WSMGF12_FLGBLQ
	WSDATA WSRETDFLG  as WSMGF12_FLGDES

	WSDATA WSSTAPCFLG  as WSMGF12_VERSTAT
	WSDATA WSSTAPCRET  as WSMGF12_RETSTAT	
	
	WSMETHOD AprovarPedido DESCRIPTION "Aprovar Pedido de Compra"
	WSMETHOD BloquearPedido DESCRIPTION "Bloquear Pedido de Compra"
	WSMETHOD ReprovarPedido DESCRIPTION "Reprovar Pedido de Compra"

	WSMETHOD BlqPCFluig    DESCRIPTION "Bloqueio Fluig"
	WSMETHOD DesblqPCFluig DESCRIPTION "Desbloqueio Fluig"

	WSMETHOD VerStatusPC DESCRIPTION "Verifica Status PC"

ENDWSSERVICE

WSMETHOD AprovarPedido WSRECEIVE WSENVAPR WSSEND WSRETAPR WSSERVICE MGFCOM12
	
	Local cxFil 	:= ::WSENVAPR:FILIAL
	Local cCodigo 	:= STRZERO(val(::WSENVAPR:CODIGO),9)
	Local cAprovad  := ::WSENVAPR:APROVADOR
	Local cSubstit	:= ::WSENVAPR:SUBSTITUTO
	Local cObs		:= ::WSENVAPR:OBSERVACAO

	Local cxEmp		:= '01'//SubStr(cxFil,1,2)

	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lConti	:= .T.
	Local aRetorno	:= {}
	
	BEGIN SEQUENCE
		
		If lConti .and. Empty(Alltrim(cxFil)) .and. Empty(Alltrim(cCodigo)) .and. Empty(Alltrim(cAprovad)) 
			lConti := .F.
			aRetorno := {'ERROR','Filial e/ou Código Fluig e/ou Cod. Aprovador não esta Preenchido não estão preenchidos'}
		EndIf
		
		If !(Empty(Alltrim(cSubstit)))
			cxUserAprv := Alltrim(cSubstit)
		Else
			cxUserAprv := Alltrim(cAprovad)
		EndIf		
		
		If lConti
			RpcSetType( 3 )
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SCR","SC7","DBM","SAL","DBL","SAK","SCH"
				aRetorno := xMC12PCs(cCodigo,cAprovad,cObs)
			RESET ENVIRONMENT
		EndIf
		
	RECOVER
		Conout('Problema Ocorreu as Horas: ' + TIME() )
	END SEQUENCE		
		
	ErrorBlock( bError )	
	
	If ValType(_aErr) == 'A'
		aRetorno := _aErr
	EndIf	
	
	//Retorno
	::WSRETAPR := WSClassNew( "WSMGF12_APRRET")
	::WSRETAPR:STATUS   := aRetorno[1]
	::WSRETAPR:MSG	    := aRetorno[2]
	
Return .T.

Static Function xMC12PCs(cCod,cUserSCR,cObs)
	
	Local aArea	  	:= GetArea()
	Local aAreaSCR	:= SCR->(GetArea())
	
	Local cCodSCR   := Posicione('SC7', nil, xFilial('SC7') + cCod ,'C7_NUM','MGFCODFLG')
	Local cAprov	:= Posicione('SAK',2,xFilial('SAK') + cxUserAprv,'AK_COD')
	Local cChavSC7	:= ''
	
	Local oModel	:= nil
	Local oMdlSCR	:= nil
	
	Local aRet		:= {}
	
	Local lLiberou
	Local lTudLib 	:= .T.
	
	Local nTamChv	:= 0
	
	cCodSCR 	:= PADR(cCodSCR,TamSx3('CR_NUM')[1])
	
	dbSelectArea('SCR')
	SCR->(dbSetOrder(2))//CR_FILIAL, CR_TIPO, CR_NUM, CR_USER
	
	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL,C7_NUM
	
	dbSelectArea('SAK')
	SAK->(dbSetOrder(1))//AK_FILIAL,AK_COD
	
	If SCR->(DbSeek(xFilial('SCR') + 'PC' + cCodSCR + cUserSCR))
		
		cChavSCR := xFilial('SCR') + SCR->(CR_TIPO + CR_NUM)
		cChavSC7 := xFilial('SC7') + SCR->CR_NUM
		nTamChv	:=  TamSx3('C7_FILIAL')[1] + TamSx3('C7_NUM')[1]
			
		lLiberou := U_xAlcAprov({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,cAprov,,SCR->CR_GRUPO},dDatabase,4)
		
		If lLiberou

			RecLock('SCR',.F.)
				SCR->CR_ZUSELIB := cxUserAprv
				SCR->CR_ZAPRLIB := cAprov
				SCR->CR_OBS 	:= cObs
				SCR->CR_ZBLQFLG := 'N'
			SCR->(MsUnlock())

			dbSelectArea("SCR")
			SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL
			
			If SCR->(dbSeek(cChavSCR))			
				
				While SCR->(!EOF()) .and. xFilial('SCR') + SCR->(CR_TIPO + CR_NUM) == cChavSCR
					//Se um item estiver sem data de liberação não libera o titulo
					If Empty(SCR->CR_DATALIB)
						lTudLib := .F.
						Exit
					EndIf
					SCR->(dbSkip())
				EndDo				
				
				If lTudLib
					SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN
					If (SC7->(dbSeek(SubStr(cChavSC7,1,nTamChv))))
						While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) = SubStr(cChavSC7,1,nTamChv)
							RecLock('SC7',.F.)
								SC7->C7_CONAPRO := 'L'
							SC7->(MsUnLock())
							SC7->(dbSkip())
						EndDo
					EndIf				
				EndIf
				
			EndIf
		EndIf
		
		/*SC7->(dbSetOrder(1))
		DBM->(dbSetOrder(1))
		DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_USER+CR_USERORI)))
		While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USER+DBM_USEROR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_USER+CR_USERORI)
         	If MtGLastDBM(SCR->CR_TIPO,DBM->DBM_NUM,DBM->DBM_ITEM) //-- Verifica se é o ultimo item de aprovação
         		If SC7->(dbSeek(xFilial("SC7")+DBM->(PadR(DBM_NUM,TamSX3("C7_NUM")[1])+PadR(DBM_ITEM,TamSX3("C7_ITEM")[1])))) .And. Empty(SC7->C7_APROV)
            		Reclock("SC7",.F.)
            		SC7->C7_CONAPRO := "L"
            		SC7->(MsUnlock())
            	EndIf
         	EndIf
         	DBM->(dbSkip())
		EndDo*/
		
		aRet := {'OK','Aprovado'}

	Else
		aRet := {'ERROR','Não Foi encontrado Registro com esse código fluig: ' + cCod + ' mais esse aprovador:' + cUserSCR}		
	EndIf

	RestArea(aAreaSCR)
	RestArea(aArea)
	
Return aRet

WSMETHOD BloquearPedido WSRECEIVE WSENVBLQ WSSEND WSRETBLQ WSSERVICE MGFCOM12

	Local cxFil 	:= ::WSENVBLQ:FILIAL
	Local cCodigo 	:= STRZERO(val(::WSENVBLQ:CODIGO),9)
	Local cAprovad  := ::WSENVBLQ:APROVADOR
	Local cSubstit	:= ::WSENVBLQ:SUBSTITUTO
	Local cObs		:= ::WSENVBLQ:OBSERVACAO
	
	Local cxEmp		:= '01'//SubStr(cxFil,1,2)
	
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lConti	:= .T.
	Local aRetorno	:= {}
	
	Private cxUserAprv := ''
	
	BEGIN SEQUENCE
		
		If lConti .and. Empty(Alltrim(cxFil)) .and. Empty(Alltrim(cCodigo)) .and. Empty(Alltrim(cAprovad)) 
			lConti := .F.
			aRetorno := {'ERROR','Filial e/ou Código Fluig e/ou Cod. Aprovador não esta Preenchido não estão preenchidos'}
		EndIf
		
		If !(Empty(Alltrim(cSubstit)))
			cxUserAprv := Alltrim(cSubstit)
		Else
			cxUserAprv := Alltrim(cAprovad)
		EndIf

		If lConti
			RpcSetType( 3 )
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SCR","SC7","DBM","SAL","DBL","SAK","SCH"
				aRetorno := xMC12BPC(cCodigo,cAprovad,cObs)
			RESET ENVIRONMENT
		EndIf			
		
	RECOVER
		Conout('Problema Ocorreu as Horas: ' + TIME() )
	END SEQUENCE		
		
	ErrorBlock( bError )	
	
	If ValType(_aErr) == 'A'
		aRetorno := _aErr
	EndIf	
	
	//Retorno
	::WSRETBLQ := WSClassNew( "WSMGF12_BLQRET")
	::WSRETBLQ:STATUS   := aRetorno[1]
	::WSRETBLQ:MSG	    := aRetorno[2]

Return .T.

Static Function xMC12BPC(cCod,cUserSCR,cObs)

	Local aArea	  	:= GetArea()
	Local aAreaSCR	:= SCR->(GetArea())
	
	Local cCodSCR   := Posicione('SC7', nil, xFilial('SC7') + cCod ,'C7_NUM','MGFCODFLG')
	Local cAprov	:= Posicione('SAK',2,xFilial('SAK') + cxUserAprv,'AK_COD')
	
	Local oModel	:= nil
	Local oMdlSCR	:= nil
	
	Local aRet
	
	Local lBloqueou
	
	cCodSCR 	:= PADR(cCodSCR,TamSx3('CR_NUM')[1])
	
	//Encontra o Registro SCR
	
	dbSelectArea('SCR')
	SCR->(dbSetOrder(2))//CR_FILIAL, CR_TIPO, CR_NUM, CR_USER
	
	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL,C7_NUM
	
	dbSelectArea('SAK')
	SAK->(dbSetOrder(1))//AK_FILIAL,AK_COD
	
	If SCR->(DbSeek(xFilial('SCR') + 'PC' + cCodSCR + cUserSCR))	
	
		lBloqueou :=  U_xAlcAprov({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,cAprov,,SCR->CR_GRUPO},dDatabase,6)
		
		RecLock('SCR',.F.)
			SCR->CR_ZUSELIB := cxUserAprv
			SCR->CR_ZAPRLIB := cAprov
			SCR->CR_OBS 	:= cObs
			SCR->CR_ZBLQFLG := 'N'
		SCR->(MsUnlock())
	
		aRet := {'OK','Bloqueado'}
	Else
		aRet := {'ERROR','Não Foi encontrado Registro com esse código fluig: ' + cCod + ' mais esse aprovador:' + cUserSCR}
	EndIf
	
	RestArea(aAreaSCR)
	RestArea(aArea)	

Return aRet

WSMETHOD ReprovarPedido WSRECEIVE WSENVREJ WSSEND WSRETREJ WSSERVICE MGFCOM12

	Local cxFil 	:= ::WSENVREJ:FILIAL
	Local cCodigo 	:= STRZERO(val(::WSENVREJ:CODIGO),9)
	Local cAprovad  := ::WSENVREJ:APROVADOR
	Local cSubstit	:= ::WSENVREJ:SUBSTITUTO
	Local cObs		:= ::WSENVREJ:OBSERVACAO
	
	Local cxEmp		:= '01'//SubStr(cxFil,1,2)
	
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lConti	:= .T.
	Local aRetorno	:= {}
	
	Private cxUserAprv := ''

	BEGIN SEQUENCE

		If lConti .and. Empty(Alltrim(cxFil)) .and. Empty(Alltrim(cCodigo)) .and. Empty(Alltrim(cAprovad)) 
			lConti := .F.
			aRetorno := {'ERROR','Filial e/ou Código Fluig e/ou Cod. Aprovador não esta Preenchido não estão preenchidos'}
		EndIf
		
		If !(Empty(Alltrim(cSubstit)))
			cxUserAprv := Alltrim(cSubstit)
		Else
			cxUserAprv := Alltrim(cAprovad)
		EndIf

		If lConti
			RpcSetType( 3 )
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SCR","SC7","DBM","SAL","DBL","SAK","SCH"
				aRetorno := xMC12RPC(cCodigo,cAprovad,cObs)
			RESET ENVIRONMENT
		EndIf
	
	RECOVER
		Conout('Problema Ocorreu as Horas: ' + TIME() )
	END SEQUENCE	
	
	//Retorno
	::WSRETREJ := WSClassNew( "WSMGF12_REJRET")
	::WSRETREJ:STATUS   := aRetorno[1]
	::WSRETREJ:MSG	    := aRetorno[2]

Return .T.

Static Function xMC12RPC(cCod,cUserSCR,cObs)

	Local aArea	  	:= GetArea()
	Local aAreaSCR	:= SCR->(GetArea())
	
	Local cCodSCR   := Posicione('SC7', nil, xFilial('SC7') + cCod ,'C7_NUM','MGFCODFLG')
	Local cAprov	:= Posicione('SAK',2,xFilial('SAK') + cxUserAprv,'AK_COD')
	Local cTipoDoc  := ''
	Local cDocto	:= ''
	Local oModel	:= nil
	Local oMdlSCR	:= nil
	
	Local aRet
	
	Local lBloqueou
	
	cCodSCR 	:= PADR(cCodSCR,TamSx3('CR_NUM')[1])
	
	//Encontra o Registro SCR
	
	dbSelectArea('SCR')
	SCR->(dbSetOrder(2))//CR_FILIAL, CR_TIPO, CR_NUM, CR_USER
	
	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL,C7_NUM
	
	dbSelectArea('SAK')
	SAK->(dbSetOrder(1))//AK_FILIAL,AK_COD	
	
	If SCR->(DbSeek(xFilial('SCR') + 'PC' + cCodSCR + cUserSCR))	
		
		cTipoDoc := SCR->CR_TIPO
		cDocto   := SCR->CR_NUM
		
		lBloqueou := U_xRejSCR({SCR->CR_NUM,SCR->CR_TIPO	, , , ,SCR->CR_GRUPO,,,,dDataBase,'Bloqueado Pelo Fluig'}, dDataBase ,7)
		
		RecLock('SCR',.F.)
			SCR->CR_ZUSELIB := cxUserAprv
			SCR->CR_ZAPRLIB := cAprov
			SCR->CR_OBS 	:= cObs
			SCR->CR_ZBLQFLG := 'N'
		SCR->(MsUnlock())
		
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(xFilial("SCR")+cTipoDoc+cDocto))
		While !SCR->(EOF()) .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM) == xFilial("SCR")+cTipoDoc+cDocto
			If SCR->CR_ZBLQFLG  <> "N"
				RecLock("SCR",.F.)
					SCR->CR_ZBLQFLG := 'N'
				SCR->(MsUnLock())		
			EndIf
			SCR->(dbSkip())
		EndDO 
		
		aRet := {'OK','Rejeitado'}
	Else
		aRet := {'ERROR','Não Foi encontrado Registro com esse código fluig: ' + cCod + ' mais esse aprovador:' + cUserSCR}
	EndIf
	
	RestArea(aAreaSCR)
	RestArea(aArea)
		
Return aRet

WSMETHOD BlqPCFluig  WSRECEIVE WSENVBFLG WSSEND WSRETBFLG WSSERVICE MGFCOM12
	
	Local cxFil 	:= Alltrim(::WSENVBFLG:FILIAL)
	Local cCodigo 	:= STRZERO(val(::WSENVBFLG:CODIGO),9)

	Local cxEmp		:= '01'//SubStr(cxFil,1,2)
		
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lConti	:= .T.
	Local aRetorno	:= {}

	BEGIN SEQUENCE
		
		If lConti .and. Empty(Alltrim(cxFil)) .and. Empty(Alltrim(cCodigo)) 
			lConti := .F.
			aRetorno := {'ERROR','Filial e/ou Código Fluig não estão preenchidos'}
		EndIf
	
		If lConti
			RpcSetType( 3 )
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SC7"
				
				dbSelectArea('SC7')
				SC7->(DbOrderNickName('MGFCODFLG'))
				If SC7->(dbSeek(xFilial('SC7') + cCodigo))
					While( SC7->(!EOF()) .and. xFilial('SC7') + cCodigo == SC7->(C7_FILIAL + C7_ZCODFLG) )
						RecLock('SC7',.F.)
							SC7->C7_ZBLQFLG := 'S'
						SC7->(MSUNLOCK())
						SC7->(dbSkip())
					EndDo
					aRetorno := {'OK','Realizado o Bloqueio do Pedido numero Fluig: ' + cCodigo}
				Else	
					aRetorno := {'ERROR','Não foi encontrada nenhum Pedido na Filial: ' + cxFil + ', com Numero Fluig: ' + cCodigo}	
				EndIf

			RESET ENVIRONMENT
		EndIf

	RECOVER
		Conout('Problema Ocorreu as Horas: ' + TIME() )
	END SEQUENCE		
		
	ErrorBlock( bError )	
	
	If ValType(_aErr) == 'A'
		aRetorno := _aErr
	EndIf		

	//Retorno
	::WSRETBFLG := WSClassNew( "WSMGF12_FLGBLQ")
	::WSRETBFLG:STATUS  := aRetorno[1]
	::WSRETBFLG:MSG	    := aRetorno[2]

Return .T.

WSMETHOD DesblqPCFluig  WSRECEIVE WSENVDFLG WSSEND WSRETDFLG WSSERVICE MGFCOM12
	
	Local cxFil 	:= Alltrim(::WSENVDFLG:FILIAL)
	Local cCodigo 	:= STRZERO(val(::WSENVDFLG:CODIGO),9)
	Local cUpd		:= ''
	Local cxEmp		:= '01'//SubStr(cxFil,1,2)
		
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lConti	:= .T.
	Local aRetorno	:= {}
	
	BEGIN SEQUENCE
	
		If lConti .and. Empty(Alltrim(cxFil)) .and. Empty(Alltrim(cCodigo)) 
			lConti := .F.
			aRetorno := {'ERROR','Filial e/ou Código Fluig não estão preenchidos'}
		EndIf
		
		If lConti	
			RpcSetType( 3 )
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SC7"			
			
				/*dbSelectArea('SC7')
				SC7->(DbOrderNickName('MGFCODFLG'))
				If SC7->(dbSeek(xFilial('SC7') + cCodigo))
					While( SC7->(!EOF()) .and. xFilial('SC7') + cCodigo == SC7->(C7_FILIAL + C7_ZCODFLG) )
						RecLock('SC7',.F.)
							SC7->C7_ZBLQFLG := 'N'
						SC7->(MSUNLOCK())
						SC7->(dbSkip())
					EndDo
					aRetorno := {'OK','Realizado a Liberação do Pedido numero Fluig: ' + cCodigo}
				Else	
					aRetorno := {'ERROR','Não foi encontrada nenhum Pedido na Filial: ' + cxFil + ', com Numero Fluig: ' + cCodigo}	
				EndIf*/
			
				cUpd := "UPDATE " + RetSQLName("SC7")  + " SC7 " + CRLF
				cUpd += " SET C7_ZBLQFLG = 'N' "   + CRLF
				cUpd += " WHERE " + CRLF
				cUpd += " SC7.C7_ZCODFLG = '" + cCodigo +  "' "
				
				TcSQLExec(cUpd)
				
				aRetorno := {'OK','Realizado a Liberação da Pedido numero Fluig: ' + cCodigo}
			
			RESET ENVIRONMENT
		EndIf	
	
	RECOVER
		Conout('Problema Ocorreu as Horas: ' + TIME() )
	END SEQUENCE		
		
	ErrorBlock( bError )	
	
	If ValType(_aErr) == 'A'
		aRetorno := _aErr
	EndIf

	//Retorno
	::WSRETDFLG := WSClassNew( "WSMGF12_FLGDES")
	::WSRETDFLG:STATUS  := aRetorno[1]
	::WSRETDFLG:MSG	    := aRetorno[2] 
	
Return .T.

WSMETHOD VerStatusPC  WSRECEIVE WSSTAPCFLG WSSEND WSSTAPCRET WSSERVICE MGFCOM12
	
	Local cxFil 	:= Alltrim(::WSSTAPCFLG:FILIAL)
	Local cCodigo 	:= STRZERO(val(::WSSTAPCFLG:CODIGO),9)
	Local cAprv		:= Alltrim(::WSSTAPCFLG:APROV)
	Local cUpd		:= ''
	Local cxEmp		:= '01'//SubStr(cxFil,1,2)
		
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lConti	:= .T.
	Local aRetorno	:= {}	

	BEGIN SEQUENCE
		
		If lConti .and. Empty(Alltrim(cxFil)) .and. Empty(Alltrim(cCodigo)) 
			lConti := .F.
			aRetorno := {'ERROR','Filial e/ou Código Fluig não estão preenchidos'}
		EndIf

		If lConti
			RpcSetType( 3 )
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SC7","SCR"
				
				DbSelectArea('SC7')
				SC7->(DbOrderNickName('MGFCODFLG'))
				If SC7->(dbSeek(xFilial('SC7') + cCodigo))
					dbSelectArea('SCR')
					SCR->(dbSetOrder(2))//CR_FILIAL+CR_TIPO+CR_NUM+CR_USER
					
					If SCR->(dbSeek(xFilial('SCR') + 'PC' + PADR(SC7->C7_NUM,TamSx3('CR_NUM')[1]) + cAprv) )
						
						If SCR->CR_STATUS $ '02|04' .and. ( (Empty(SCR->CR_USERLIB)) .or. (!(Empty(SCR->CR_USERLIB)) .and. SCR->CR_ZBLQFLG == 'N' .and. SCR->CR_STATUS == '04' ) )
							aRetorno := {'OK','OK' }
						Else
							aRetorno := {'NOK','Não Pode ser realizado a aprovação'  }
						EndIf
						
					Else	
						aRetorno := {'ERROR','Não foi encontrado Registro para essa filial: ' + cxFil + ', com Numero Fluig: ' + cCodigo + ' , com esse aprovador ' + cAprv }
					EndIf
				Else	
					aRetorno := {'ERROR','Não foi encontrada nenhuma solicitação na Filial: ' + cxFil + ', com Numero Fluig: ' + cCodigo}	
				EndIf
				
				
			RESET ENVIRONMENT
		EndIf
		
	RECOVER
		Conout('Problema Ocorreu as Horas: ' + TIME() )
	END SEQUENCE	

	ErrorBlock( bError )	
	
	If ValType(_aErr) == 'A'
		aRetorno := _aErr
	EndIf

	//Retorno
	::WSSTAPCRET := WSClassNew( "WSMGF12_RETSTAT")
	::WSSTAPCRET:STATUS  := aRetorno[1]
	::WSSTAPCRET:MSG	    := aRetorno[2]
	
Return .T.

Static Function MyError(oError)
	
	Local nQtd := MLCount(oError:ERRORSTACK)
	Local ni
	Local cEr := ''
	
	nQtd := IIF(nQtd > 4,4,nQtd) //Retorna as 4 linhas 
	
	FOr ni:=1 to nQTd
		cEr += MemoLine(oError:ERRORSTACK,,ni)
	Next ni
	
	Conout( oError:Description + "Deu Erro" )
	_aErr := {'ERROR',cEr}
	BREAK
	
Return .T.
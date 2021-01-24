#Include 'Protheus.ch'
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"

#DEFINE OP_LIB   	"001" //Liberado
#DEFINE OP_EST   	"002" //Estornar
#DEFINE OP_SUP   	"003" //Superior
#DEFINE OP_TRA   	"004" //Transferir Superior
#DEFINE OP_EST	    "005" // Estorna
#DEFINE OP_REJ	    "006" // Rejeitado
#DEFINE OP_BLQ	    "007" // Bloqueio

Static _aErr

//Aprovacao
WSSTRUCT WSMGF11_FLGAPRV
	
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
	WSDATA APROVADOR    as String
	WSDATA SUBSTITUTO	as String
	WSDATA OBSERVACAO	as String

ENDWSSTRUCT

WSSTRUCT WSMGF11_RETORNO
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

//Bloqueio SC
WSSTRUCT WSMGF11_BLQSC
	
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
	WSDATA APROVADOR    as String
	WSDATA SUBSTITUTO	as String
	WSDATA OBSERVACAO	as String
	
ENDWSSTRUCT

WSSTRUCT WSMGF11_RETBLQSC
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

//Reprovaçãp Fluig
WSSTRUCT WSMGF11_RPVSC
	
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
	WSDATA APROVADOR    as String
	WSDATA SUBSTITUTO	as String
	WSDATA OBSERVACAO	as String
	
ENDWSSTRUCT

WSSTRUCT WSMGF11_RPVRET
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

//Bloqueio Fluig
WSSTRUCT WSMGF11_BLQFLGA
	
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String

ENDWSSTRUCT

WSSTRUCT WSMGF11_BLGRET
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

//Desbloqueio Fluig
WSSTRUCT WSMGF11_DESFLGA
	
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String

ENDWSSTRUCT

WSSTRUCT WSMGF11_DESRET
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

//
WSSTRUCT WSMGF11_VERSTAT
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
	WSDATA APROV    	as String
ENDWSSTRUCT

WSSTRUCT WSMGF11_RETSTAT
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFCOM11 DESCRIPTION "Aprovar Solicitacao" NAMESPACE "http://www.totvs.com.br/MGFCOM11"
	
	WSDATA WSDADOS 	 as WSMGF11_FLGAPRV
	WSDATA WSRETORNO as WSMGF11_RETORNO
	
	WSDATA WSBLQDSC as WSMGF11_BLQSC
	WSDATA WSRETBLQ as WSMGF11_RETBLQSC

	WSDATA WSRPVDSC as WSMGF11_RPVSC
	WSDATA WSRETRPV as WSMGF11_RPVRET
	
	WSDATA WSBLQFLG  as WSMGF11_BLQFLGA
	WSDATA WSBLQRET  as WSMGF11_BLGRET

	WSDATA WSDESFLG  as WSMGF11_DESFLGA
	WSDATA WSDESRET  as WSMGF11_DESRET
	
	WSDATA WSSTAFLG  as WSMGF11_VERSTAT
	WSDATA WSSTARET  as WSMGF11_RETSTAT	
	
	WSMETHOD AprovarSolicitacao DESCRIPTION "Aprovar Solicitacao de Compra"
	WSMETHOD BloquearSolicitacao DESCRIPTION "Bloquear Solicitacao de Compra"
	WSMETHOD ReprovarSolicitacao DESCRIPTION "Reprovar Solicitacao de Compra"
	
	WSMETHOD BloqueioFluig 	  DESCRIPTION "Bloqueio Fluig"
	WSMETHOD DesbloqueioFluig DESCRIPTION "Desbloqueio Fluig"
	
	WSMETHOD VerStatusSC DESCRIPTION "Verifica Status SC"
	
ENDWSSERVICE

WSMETHOD AprovarSolicitacao WSRECEIVE WSDADOS WSSEND WSRETORNO WSSERVICE MGFCOM11
	
	Local cxFil 	:= ::WSDADOS:FILIAL
	Local cCodigo 	:= STRZERO(val(::WSDADOS:CODIGO),9)
	Local cAprovad  := ::WSDADOS:APROVADOR
	Local cSubstit	:= ::WSDADOS:SUBSTITUTO
	Local cObs		:= ::WSDADOS:OBSERVACAO
	
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
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SCR","SC1","DBM","SAL","DBL","SAK","SCX"
				aRetorno := U_xMC11ASc(cCodigo,cAprovad,cObs)
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
	::WSRETORNO := WSClassNew( "WSMGF11_RETORNO")
	::WSRETORNO:STATUS  := aRetorno[1]
	::WSRETORNO:MSG	    := aRetorno[2]
	
Return .T.

WSMETHOD BloquearSolicitacao WSRECEIVE WSBLQDSC WSSEND WSRETBLQ WSSERVICE MGFCOM11
	
	Local cxFil 	:= ::WSBLQDSC:FILIAL
	Local cCodigo 	:= STRZERO(val(::WSBLQDSC:CODIGO),9)
	Local cAprovad  := ::WSBLQDSC:APROVADOR
	Local cSubstit	:= ::WSBLQDSC:SUBSTITUTO
	Local cObs		:= ::WSBLQDSC:OBSERVACAO
	
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
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SCR","SC1","DBM","SAL","DBL","SAK","SCX"
				aRetorno := U_xMC11BSc(cCodigo,cAprovad,cObs)
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
	::WSRETBLQ := WSClassNew( "WSMGF11_RETBLQSC")
	::WSRETBLQ:STATUS  := aRetorno[1]
	::WSRETBLQ:MSG	    := aRetorno[2]
	
Return .T.

WSMETHOD ReprovarSolicitacao WSRECEIVE WSRPVDSC WSSEND WSRETRPV WSSERVICE MGFCOM11
	
	Local cxFil 	:= ::WSRPVDSC:FILIAL
	Local cCodigo 	:= STRZERO(val(::WSRPVDSC:CODIGO),9)
	Local cAprovad  := ::WSRPVDSC:APROVADOR
	Local cSubstit	:= ::WSRPVDSC:SUBSTITUTO
	Local cObs		:= ::WSRPVDSC:OBSERVACAO
	
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
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SCR","SC1","DBM","SAL","DBL","SAK","SCX"
				aRetorno := U_xMC11RSc(cCodigo,cAprovad,cObs)
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
	::WSRETRPV := WSClassNew( "WSMGF11_RPVRET")
	::WSRETRPV:STATUS  := aRetorno[1]
	::WSRETRPV:MSG	   := aRetorno[2]
	
Return .T.

User Function xMC11RSc(cCod,cUserSCR,cObs)

	Local aArea	  	:= GetArea()
	Local aAreaSCR	:= SCR->(GetArea())
	
	Local cCodSCR   := Posicione('SC1', nil, xFilial('SC1') + cCod ,'C1_NUM','MGFCODFLG')
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
	
	dbSelectArea('SC1')
	SC1->(dbSetOrder(1))//C1_FILIAL,C1_NUM
	
	dbSelectArea('SAK')
	SAK->(dbSetOrder(1))//AK_FILIAL,AK_COD
	
	If SCR->(DbSeek(xFilial('SCR') + 'SC' + cCodSCR + cUserSCR))	

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
	
		aRet := {'OK','Bloqueado'}
	Else
		aRet := {'ERROR','Não Foi encontrado Registro com esse código fluig: ' + cCod + ' mais esse aprovador:' + cUserSCR}
	EndIf
	
	RestArea(aAreaSCR)
	RestArea(aArea)
		
Return aRet

User Function xMC11BSc(cCod,cUserSCR,cObs)

	Local aArea	  	:= GetArea()
	Local aAreaSCR	:= SCR->(GetArea())
	
	Local cCodSCR   := Posicione('SC1', nil, xFilial('SC1') + cCod ,'C1_NUM','MGFCODFLG')
	Local cAprov	:= Posicione('SAK',2,xFilial('SAK') + cxUserAprv,'AK_COD')
	
	Local oModel	:= nil
	Local oMdlSCR	:= nil
	
	Local aRet
	
	Local lBloqueou
	
	cCodSCR 	:= PADR(cCodSCR,TamSx3('CR_NUM')[1])
	
	//Encontra o Registro SCR
	
	dbSelectArea('SCR')
	SCR->(dbSetOrder(2))//CR_FILIAL, CR_TIPO, CR_NUM, CR_USER
	
	dbSelectArea('SC1')
	SC1->(dbSetOrder(1))//C1_FILIAL,C1_NUM
	
	dbSelectArea('SAK')
	SAK->(dbSetOrder(1))//AK_FILIAL,AK_COD
	
	If SCR->(DbSeek(xFilial('SCR') + 'SC' + cCodSCR + cUserSCR))	
	
		lBloqueou :=  U_xAlcAprov({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,cAprov,,SCR->CR_GRUPO},dDatabase,6)
		
		RecLock('SCR',.F.)
			SCR->CR_ZUSELIB := cxUserAprv
			SCR->CR_ZAPRLIB := cAprov
			SCR->CR_OBS 	:= cObs
			SCR->CR_ZBLQFLG := 'N'
		SCR->(MsUnlock())
	
		aRet := {'OK','Rejeitado'}
	Else
		aRet := {'ERROR','Não Foi encontrado Registro com esse código fluig: ' + cCod + ' mais esse aprovador:' + cUserSCR}
	EndIf
	
	RestArea(aAreaSCR)
	RestArea(aArea)
		
Return aRet

User Function xMC11ASc(cCod,cUserSCR,cObs)
	
	Local aArea	  	:= GetArea()
	Local aAreaSCR	:= SCR->(GetArea())
	
	Local cCodSCR   := Posicione('SC1', nil, xFilial('SC1') + cCod ,'C1_NUM','MGFCODFLG')
	Local cAprov	:= Posicione('SAK',2,xFilial('SAK') + cxUserAprv,'AK_COD')
	Local cChavSC1  := '' 
	
	Local oModel	:= nil
	Local oMdlSCR	:= nil
	
	Local aRet
	
	Local lLiberou
	Local lTudLib 	:= .T.
	
	Local nTamChv	:= 0
		
	cCodSCR 	:= PADR(cCodSCR,TamSx3('CR_NUM')[1])
	
	//Encontra o Registro SCR
	
	dbSelectArea('SCR')
	SCR->(dbSetOrder(2))//CR_FILIAL, CR_TIPO, CR_NUM, CR_USER
	
	dbSelectArea('SC1')
	SC1->(dbSetOrder(1))//C1_FILIAL,C1_NUM
	
	dbSelectArea('SAK')
	SAK->(dbSetOrder(1))//AK_FILIAL,AK_COD
	
	If SCR->(DbSeek(xFilial('SCR') + 'SC' + cCodSCR + cUserSCR))
		
		cChavSCR := xFilial('SCR') + SCR->(CR_TIPO + CR_NUM)
		cChavSC1 := xFilial('SC1') + SCR->CR_NUM
		nTamChv	:=  TamSx3('C1_FILIAL')[1] + TamSx3('C1_NUM')[1]
		
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
					SC1->(dbSetOrder(1))//C1_FILIAL, C1_NUM, C1_ITEM, C7_SEQUEN
					If (SC1->(dbSeek(SubStr(cChavSC1,1,nTamChv))))
						While SC1->(!EOF()) .and. SC1->(C1_FILIAL + C1_NUM) = SubStr(cChavSC1,1,nTamChv)
							RecLock('SC1',.F.)
								SC1->C1_APROV := 'L'
							SC1->(MsUnLock())
							SC1->(dbSkip())
						EndDo

						// Customização - COM03 - Flavio
						If FindFunction('U_MGFCOM28')
							U_MGFCOM28()
						EndIf
						//Fim COM03

					EndIf	
				EndIf
			
			EndIf		
			
		EndIf

		aRet := {'OK','Aprovado'}
	Else
		aRet := {'ERROR','Não Foi encontrado Registro com esse código fluig: ' + cCod + ' mais esse aprovador:' + cUserSCR}
	EndIf
	
	RestArea(aAreaSCR)
	RestArea(aArea)
	
Return aRet

WSMETHOD BloqueioFluig  WSRECEIVE WSBLQFLG WSSEND WSBLQRET WSSERVICE MGFCOM11
	
	Local cxFil 	:= Alltrim(::WSBLQFLG:FILIAL)
	Local cCodigo 	:= STRZERO(val(::WSBLQFLG:CODIGO),9)
	
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
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SC1"
			
				dbSelectArea('SC1')
				SC1->(DbOrderNickName('MGFCODFLG'))
				If SC1->(dbSeek(xFilial('SC1') + cCodigo))
					While( SC1->(!EOF()) .and. xFilial('SC1') + cCodigo == SC1->(C1_FILIAL + C1_ZCODFLG) )
						RecLock('SC1',.F.)
							SC1->C1_ZBLQFLG := 'S'
						SC1->(MSUNLOCK())
						SC1->(dbSkip())
					EndDo
					aRetorno := {'OK','Realizado o bloqueio da Solicitação numero Fluig: ' + cCodigo}
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
	::WSBLQRET := WSClassNew( "WSMGF11_BLGRET")
	::WSBLQRET:STATUS  := aRetorno[1]
	::WSBLQRET:MSG	    := aRetorno[2]
	
Return .T.

WSMETHOD DesbloqueioFluig  WSRECEIVE WSDESFLG WSSEND WSDESRET WSSERVICE MGFCOM11

	Local cxFil 	:= Alltrim(::WSDESFLG:FILIAL)
	Local cCodigo 	:= STRZERO(val(::WSDESFLG:CODIGO),9)
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
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SC1"
			
				/*dbSelectArea('SC1')
				SC1->(DbOrderNickName('MGFCODFLG'))
				If SC1->(dbSeek(xFilial('SC1') + cCodigo))
					While( SC1->(!EOF()) .and. xFilial('SC1') + cCodigo == SC1->(C1_FILIAL + C1_ZCODFLG) )
						RecLock('SC1',.F.)
							SC1->C1_ZBLQFLG := 'N'
						SC1->(MSUNLOCK())
						SC1->(dbSkip())
					EndDo
					aRetorno := {'OK','Realizado a Liberação da Solicitação numero Fluig: ' + cCodigo}
				Else	
					aRetorno := {'ERROR','Não foi encontrada nenhuma solicitação na Filial: ' + cxFil + ', com Numero Fluig: ' + cCodigo}	
				EndIf*/
			cUpd := "UPDATE " + RetSQLName("SC1")  + " SC1 " + CRLF
			cUpd += " SET C1_ZBLQFLG = 'N' "   + CRLF
			cUpd += " WHERE " + CRLF
			cUpd += " SC1.C1_ZCODFLG = '" + cCodigo +  "' "
			
			TcSQLExec(cUpd)
			
			aRetorno := {'OK','Realizado a Liberação da Solicitação numero Fluig: ' + cCodigo}
				
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
	::WSDESRET := WSClassNew( "WSMGF11_DESRET")
	::WSDESRET:STATUS  := aRetorno[1]
	::WSDESRET:MSG	    := aRetorno[2]

Return .T.

WSMETHOD VerStatusSC  WSRECEIVE WSSTAFLG WSSEND WSSTARET WSSERVICE MGFCOM11
	
	Local cxFil 	:= Alltrim(::WSSTAFLG:FILIAL)
	Local cCodigo 	:= STRZERO(val(::WSSTAFLG:CODIGO),9)
	Local cAprv		:= Alltrim(::WSSTAFLG:APROV)
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
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SC1","SCR"
				
				DbSelectArea('SC1')
				SC1->(DbOrderNickName('MGFCODFLG'))
				If SC1->(dbSeek(xFilial('SC1') + cCodigo))
					dbSelectArea('SCR')
					SCR->(dbSetOrder(2))//CR_FILIAL+CR_TIPO+CR_NUM+CR_USER
					
					If SCR->(dbSeek(xFilial('SCR') + 'SC' + PADR(SC1->C1_NUM,TamSx3('CR_NUM')[1]) + cAprv) )
						
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
	::WSSTARET := WSClassNew( "WSMGF11_RETSTAT")
	::WSSTARET:STATUS  := aRetorno[1]
	::WSSTARET:MSG	    := aRetorno[2]
	
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

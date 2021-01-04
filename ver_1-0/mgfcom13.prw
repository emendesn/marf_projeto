#Include 'Protheus.ch'
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"

Static _aErr

//Envios
WSSTRUCT WSMGF13_APRENV
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
	WSDATA APROVADOR    as String
	WSDATA SUBSTITUTO	as String
	WSDATA OBSERVACAO	as String
ENDWSSTRUCT

WSSTRUCT WSMGF13_BLQENV
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
	WSDATA APROVADOR    as String
	WSDATA SUBSTITUTO	as String
	WSDATA OBSERVACAO	as String
ENDWSSTRUCT

//Fluig
WSSTRUCT WSMGF13_BLQFLGA
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
ENDWSSTRUCT

WSSTRUCT WSMGF13_DESFLGA
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
ENDWSSTRUCT

//Retornos
WSSTRUCT WSMGF13_APRRET
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSTRUCT WSMGF13_BLQRET
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSTRUCT WSMGF13_FLGBLQ
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSTRUCT WSMGF13_FLGDES
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSTRUCT WSMGF13_VERSTAT
	WSDATA FILIAL	    as String
	WSDATA CODIGO    	as String
	WSDATA APROV    	as String
ENDWSSTRUCT

WSSTRUCT WSMGF13_RETSTAT
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFCOM13 DESCRIPTION "Aprovar Pagamento" NAMESPACE "http://www.totvs.com.br/MGFCOM13"

	WSDATA WSENVAPR  as WSMGF13_APRENV
	WSDATA WSENVBLQ  as WSMGF13_BLQENV
	WSDATA WSENVBFLG as WSMGF13_BLQFLGA
	WSDATA WSENVDFLG as WSMGF13_DESFLGA
			
	//Retornos
	WSDATA WSRETAPR   as WSMGF13_APRRET
	WSDATA WSRETBLQ   as WSMGF13_BLQRET
	WSDATA WSRETBFLG  as WSMGF13_FLGBLQ
	WSDATA WSRETDFLG  as WSMGF13_FLGDES

	WSDATA WSSTATIFLG  as WSMGF13_VERSTAT
	WSDATA WSSTATIRET  as WSMGF13_RETSTAT
	
	WSMETHOD AprovarTitulo DESCRIPTION "Aprovar Titulo"
	WSMETHOD BloquearTitulo DESCRIPTION "Bloquear Titulo"

	WSMETHOD BlqTitFluig    DESCRIPTION "Bloqueio Fluig"
	WSMETHOD DesblqTitFluig DESCRIPTION "Desbloqueio Fluig"

	WSMETHOD VerStatusTI DESCRIPTION "Verifica Status TI"
	
ENDWSSERVICE

WSMETHOD AprovarTitulo WSRECEIVE WSENVAPR WSSEND WSRETAPR WSSERVICE MGFCOM13
	
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
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SCR","SE2","SAL","DBL","SAK"
				aRetorno := xMC12Tit(cCodigo,cAprovad,cObs)
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
	::WSRETAPR := WSClassNew( "WSMGF13_APRRET")
	::WSRETAPR:STATUS   := aRetorno[1]
	::WSRETAPR:MSG	    := aRetorno[2]
	
Return .T.

Static Function xMC12Tit(cCod,cUserSCR,cObs)
	
	Local aArea	  	:= GetArea()
	Local aAreaSCR	:= SCR->(GetArea())
	
	Local cCodSCR   := ''
 	Local cChavSCR	:= ''
 	Local cChavSE2	:= ''
 	Local aCodSCR   := {}//GetAdvFVal("SE2",{"E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_FORNECE", "E2_LOJA"}, xFilial("SE2") + E2_LOJA, 1, { "", "", "", "", "", ""})//Posicione('SE2', nil, xFilial('SE2') + cCod ,'E2_NUM','MGFCODFLG')
	Local cAprov	:= Posicione('SAK',2,xFilial('SAK') + cxUserAprv,'AK_COD')		   
	
	Local oModel	:= nil
	Local oMdlSCR	:= nil
	
	Local aRet		:= {}
	Local nInd		:= SE2->(IndexOrd())
	Local nTamChv	:= TamSx3('E2_FILIAL')[1] + TamSx3('E2_PREFIXO')[1] + TamSx3('E2_NUM')[1] + TamSx3('E2_PARCELA')[1] + TamSx3('E2_TIPO')[1] + TamSx3('E2_FORNECE')[1] + TamSx3('E2_LOJA')[1]
	Local lLiberou
	Local lTudLib	:= .T.
	
	dbSelectArea('SE2')
	SE2->(DbOrderNickName('MGFCODFLG'))
	nInd := SE2->(IndexOrd())
	
	aCodSCR := GetAdvFVal("SE2",{"E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_FORNECE", "E2_LOJA"}, xFilial("SE2") + cCod, nInd, { "", "", "", "", "", ""})
	cCodSCR := PADR(aCodSCR[1] + aCodSCR[2] + aCodSCR[3] + aCodSCR[4] + aCodSCR[5] + aCodSCR[6] ,TamSx3('CR_NUM')[1])
	
	cChavSCR := xFilial('SCR') + 'ZC' + cCodSCR
	cChavSE2 := xFilial('SE2') + cCodSCR
	
	dbSelectArea('SCR')
	SCR->(dbSetOrder(2))//CR_FILIAL, CR_TIPO, CR_NUM, CR_USER
	
	SE2->(dbSetOrder(1))//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
	
	dbSelectArea('SAK')
	SAK->(dbSetOrder(1))//AK_FILIAL,AK_COD
	
	If SCR->(DbSeek(xFilial('SCR') + 'ZC' + cCodSCR + cUserSCR))
		
		lLiberou := U_xAlcAprov({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,cAprov,,SCR->CR_GRUPO,,,,,cObs},dDatabase,4)
		
		RecLock('SCR',.F.)
			SCR->CR_ZUSELIB := cxUserAprv
			SCR->CR_ZAPRLIB := cAprov
			SCR->CR_OBS 	:= cObs
			SCR->CR_ZBLQFLG := 'N'
		SCR->(MsUnlock())
		
		If lLiberou

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
					SE2->(dbSetOrder(1))//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA            			
					If (SE2->(dbSeek(SubStr(cChavSE2,1,nTamChv))))
						RecLock('SE2',.F.)
							SE2->E2_DATALIB := dDataBase
						SE2->(MsUnlock())
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

WSMETHOD BloquearTitulo WSRECEIVE WSENVBLQ WSSEND WSRETBLQ WSSERVICE MGFCOM13

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
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SCR","SE2","SAL","DBL","SAK","SCH"
				aRetorno := xMC12BTI(cCodigo,cAprovad,cObs)
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
	::WSRETBLQ := WSClassNew( "WSMGF13_BLQRET")
	::WSRETBLQ:STATUS   := aRetorno[1]
	::WSRETBLQ:MSG	    := aRetorno[2]

Return .T.

Static Function xMC12BTI(cCod,cUserSCR,cObs)

	Local aArea	  	:= GetArea()
	Local aAreaSCR	:= SCR->(GetArea())
	
	//Local cCodSCR   := Posicione('SE2', nil, xFilial('SE2') + cCod ,'E2_NUM','MGFCODFLG')
	Local cAprov	:= Posicione('SAK',2,xFilial('SAK') + cxUserAprv,'AK_COD')
	Local cCodSCR   := ''
 	Local aCodSCR   := {}
	
	Local oModel	:= nil
	Local oMdlSCR	:= nil
	
	Local aRet
	
	Local lBloqueou

	dbSelectArea('SE2')
	SE2->(DbOrderNickName('MGFCODFLG'))
	nInd := SE2->(IndexOrd())
	
	aCodSCR := GetAdvFVal("SE2",{"E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_FORNECE", "E2_LOJA"}, xFilial("SE2") + cCod, nInd, { "", "", "", "", "", ""})
	cCodSCR := PADR(aCodSCR[1] + aCodSCR[2] + aCodSCR[3] + aCodSCR[4] + aCodSCR[5] + aCodSCR[6] ,TamSx3('CR_NUM')[1])
	
	cCodSCR := PADR(cCodSCR,TamSx3('CR_NUM')[1])
	
	//Encontra o Registro SCR
	dbSelectArea('SCR')
	SCR->(dbSetOrder(2))//CR_FILIAL, CR_TIPO, CR_NUM, CR_USER
	
	SE2->(dbSetOrder(1))//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
	
	dbSelectArea('SAK')
	SAK->(dbSetOrder(1))//AK_FILIAL,AK_COD
	
	If SCR->(DbSeek(xFilial('SCR') + 'ZC' + cCodSCR + cUserSCR))
	
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

WSMETHOD BlqTitFluig  WSRECEIVE WSENVBFLG WSSEND WSRETBFLG WSSERVICE MGFCOM13

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
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SE2"
				
				dbSelectArea('SE2')
				SE2->(DbOrderNickName('MGFCODFLG'))
				If SE2->(dbSeek(xFilial('SE2') + cCodigo))
					//While( SE2->(!EOF()) .and. xFilial('SE2') + cCodigo == SE2->(E2_FILIAL + E2_ZCODFLG) )
						RecLock('SE2',.F.)
							SE2->E2_ZBLQFLG := 'S'
						SE2->(MSUNLOCK())
						//SE2->(dbSkip())
					//EndDo
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
	::WSRETBFLG := WSClassNew( "WSMGF13_FLGBLQ")
	::WSRETBFLG:STATUS  := aRetorno[1]
	::WSRETBFLG:MSG	    := aRetorno[2] 

Return .T.

WSMETHOD DesblqTitFluig  WSRECEIVE WSENVDFLG WSSEND WSRETDFLG WSSERVICE MGFCOM13

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
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SE2"
				
				/*dbSelectArea('SE2')
				SE2->(DbOrderNickName('MGFCODFLG'))
				If SE2->(dbSeek(xFilial('SE2') + cCodigo))
					//While( SE2->(!EOF()) .and. xFilial('SE2') + cCodigo == SE2->(E2_FILIAL + E2_ZCODFLG) )
						RecLock('SE2',.F.)
							SE2->E2_ZBLQFLG := 'N'
						SE2->(MSUNLOCK())
						//SE2->(dbSkip())
					//EndDo
					aRetorno := {'OK','Realizado o Bloqueio do Pedido numero Fluig: ' + cCodigo}
				Else	
					aRetorno := {'ERROR','Não foi encontrada nenhum Pedido na Filial: ' + cxFil + ', com Numero Fluig: ' + cCodigo}	
				EndIf*/

				cUpd := "UPDATE " + RetSQLName("SE2")  + " SE2 " + CRLF
				cUpd += " SET E2_ZBLQFLG = 'N' "   + CRLF
				cUpd += " WHERE " + CRLF
				cUpd += " SE2.E2_ZCODFLG = '" + cCodigo +  "' "
			
				TcSQLExec(cUpd)
				
				aRetorno := {'OK','Realizado a Liberação do Titutlo numero Fluig: ' + cCodigo}
	
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
	::WSRETDFLG := WSClassNew( "WSMGF13_FLGDES")
	::WSRETDFLG:STATUS  := aRetorno[1]
	::WSRETDFLG:MSG	    := aRetorno[2] 

Return .T.

WSMETHOD VerStatusTI  WSRECEIVE WSSTATIFLG WSSEND WSSTATIRET WSSERVICE MGFCOM13
	
	Local cxFil 	:= Alltrim(::WSSTATIFLG:FILIAL)
	Local cCodigo 	:= STRZERO(val(::WSSTATIFLG:CODIGO),9)
	Local cAprv		:= Alltrim(::WSSTATIFLG:APROV)
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
			PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SE2","SCR"
				
				DbSelectArea('SE2')
				SE2->(DbOrderNickName('MGFCODFLG'))
				If SE2->(dbSeek(xFilial('SE2') + cCodigo))
					dbSelectArea('SE2')
					SCR->(dbSetOrder(2))//CR_FILIAL+CR_TIPO+CR_NUM+CR_USER
					
					If SCR->(dbSeek(xFilial('SCR') + 'ZC' + PADR(SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA),TamSx3('CR_NUM')[1]) + cAprv) )
						
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
	::WSSTATIRET := WSClassNew( "WSMGF13_RETSTAT")
	::WSSTATIRET:STATUS  := aRetorno[1]
	::WSSTATIRET:MSG	    := aRetorno[2]
	
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

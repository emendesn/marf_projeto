#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"

/*
=====================================================================================
Programa............: MGFTAS01
Autor...............: Mauricio Gresele
Data................: 24/10/2016
Descricao / Objetivo: Integração Protheus-Taura, para envio de PV
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: A. Carlos - Incuido converter memo em caracter
Data................: 12/11/2019
=====================================================================================
*/
User Function MGFTAS01()
	
Local cQ 		:= ""
Local cAliasTrb := ""
Local lRet 		:= .F.
Local nRet 		:= 0
Local cIDTaura 	:= ""
Local cEmpSel   := "'x'"
Local nI		:= 0
Local cFilMafig	:= ""
Local nVezes    := 1
Local cVezes    := ''
Local _apeds    := {}

Private nI         := 0
Private cObs       := " "

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010041"

cAliasTrb := GetNextAlias()

U_MFCONOUT('Iniciando integração de pedidos de venda para o Taura...')


U_MFCONOUT('Atualizando tabela intermediária de pedidos de venda...')

cQ := " SELECT SC5.R_E_C_N_O_ REC FROM "
cQ += RetSqlName("SC5")+" SC5 WHERE SC5.D_E_L_E_T_ <> '*' "
cQ += " AND C5_EMISSAO >= '"+dTos(dDataBase-GetMv("MGF_TAS01I",,30))+"' "
cQ += " AND NOT EXISTS (SELECT ZHW_PEDIDO ZHW FROM "
cQ += 					RetSqlName("ZHW")+" ZHW "
cQ += "                    WHERE ZHW.D_E_L_E_T_ <> '*' AND ZHW_FILIAL = C5_FILIAL AND ZHW_PEDIDO = C5_NUM )  "

If select(cAliasTrb) > 0
	(cAliasTrb)->(dbclosearea())
Endif

dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

_ntot := 0
_nni := 1

(cAliasTrb)->(dbGoTop())
While (cAliasTrb)->(!Eof())
	_ntot++
	(cAliasTrb)->(dbSkip())
Enddo

(cAliasTrb)->(dbGoTop())

ZHW->(Dbsetorder(1)) //ZHW_FILIAL+ZHW_PEDIDO

While (cAliasTrb)->(!Eof())

	SC5->(Dbgoto((cAliasTrb)->REC))
	U_MFCONOUT('Registrando pedido ' + SC5->C5_FILIAL + "/" +SC5->C5_NUM + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")
	_nni++

	If !(ZHW->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM)))

		Reclock("ZHW",.T.)
		ZHW->ZHW_FILIAL := SC5->C5_FILIAL
		ZHW->ZHW_PEDIDO := SC5->C5_NUM
		ZHW->(Msunlock())

	Endif

	(cAliasTrb)->(dbSkip())

Enddo

nVezes    := GetMv("MGF_TAUVEZ",,5)

cVezes := "'N',' ','S'"
For nI := 1 To nVezes-1
	cVezes += ",'"+Alltrim(STR(nI))+"'"
Next nI

U_MFCONOUT('Carregando pedidos para integração...')

cQ := 	" SELECT  SUM(C6.ORA_ROWSCN) C6HASH, "
cQ +=   "         SUM(C5.ORA_ROWSCN) C5HASH, "
cQ +=   "         (SELECT NVL(SUM(ZV.ORA_ROWSCN),0) FROM " + RetSqlName("SZV") + " ZV WHERE ZV.D_E_L_E_T_ <> '*' "
cQ +=   " 									AND ZV_FILIAL = C5_FILIAL AND ZV_PEDIDO = C5_NUM ) ZVHASH, "
cQ +=   "          (select MAX(ZHW_HASHC6) FROM ZHW010 ZHWC5 WHERE ZHWC5.D_E_L_E_T_ <> '*' AND ZHWC5.ZHW_FILIAL = C5_FILIAL "
cQ +=   "          																		 AND ZHWC5.ZHW_PEDIDO = C5_NUM )  ZHWC6, "
cQ +=   "          (select MAX(ZHW_HASHC5) FROM ZHW010 ZHWC5 WHERE ZHWC5.D_E_L_E_T_ <> '*' AND ZHWC5.ZHW_FILIAL = C5_FILIAL "
cQ +=   "          																		 AND ZHWC5.ZHW_PEDIDO = C5_NUM )  ZHWC5, "
cQ +=   "          (select MAX(ZHW_HASHZV) FROM ZHW010 ZHWC5 WHERE ZHWC5.D_E_L_E_T_ <> '*' AND ZHWC5.ZHW_FILIAL = C5_FILIAL "
cQ +=   "          																		 AND ZHWC5.ZHW_PEDIDO = C5_NUM )  ZHWZV, "
cQ +=   "         							C5_FILIAL,C5_NUM, C5.R_E_C_N_O_ SC5_RECNO "
cQ +=   " FROM " + RetSqlName("SC5") + " C5 "
cQ +=   " JOIN " + RetSqlName("SC6") + " C6 ON C6_FILIAL = C5_FILIAL AND C5_NUM = C6_NUM "
cQ +=   " WHERE C5.D_E_L_E_T_ <> '*'   "
cQ +=   "       AND C6.D_E_L_E_T_ <> '*' "
cQ +=   "       AND C5_EMISSAO >= '"+dTos(dDataBase-GetMv("MGF_TAS01I",,30))+"' "
cQ +=   " HAVING (TRIM(TO_CHAR(SUM(C5.ORA_ROWSCN))) <> TRIM((select MAX(ZHW_HASHC5) FROM ZHW010 ZHWC5 WHERE ZHWC5.D_E_L_E_T_ <> '*' AND ZHWC5.ZHW_FILIAL = C5_FILIAL "
cQ +=   "                    														   AND ZHWC5.ZHW_PEDIDO = C5_NUM )) OR "
cQ +=   "        TRIM(TO_CHAR(SUM(C6.ORA_ROWSCN))) <> TRIM((select MAX(ZHW_HASHC6) FROM ZHW010 ZHWC6 WHERE ZHWC6.D_E_L_E_T_ <> '*' AND ZHWC6.ZHW_FILIAL = C5_FILIAL "
cQ +=   "                    														   AND ZHWC6.ZHW_PEDIDO = C5_NUM )) OR "
cQ +=   "        TRIM(TO_CHAR((SELECT NVL(SUM(ZV.ORA_ROWSCN),0) FROM SZV010 ZV WHERE ZV.D_E_L_E_T_ <> '*'  "
cQ +=   "         									AND ZV_FILIAL = C5_FILIAL AND ZV_PEDIDO = C5_NUM ))) <> TRIM((select MAX(ZHW_HASHZV) FROM ZHW010 ZHWZV WHERE ZHWZV.D_E_L_E_T_ <> '*' AND ZHWZV.ZHW_FILIAL = C5_FILIAL "
cQ +=   "                   														   AND ZHWZV.ZHW_PEDIDO = C5_NUM )) "
cQ +=   "		OR  (exists((select ZHW_HASHC5 FROM ZHW010 ZHWC5 WHERE ZHWC5.D_E_L_E_T_ <> '*' AND ZHWC5.ZHW_FILIAL = C5_FILIAL "
cQ +=   "         	        												AND ZHWC5.ZHW_PEDIDO = C5_NUM and ZHW_HASHC5 = ' ' ))))"

cQ +=   " GROUP BY C5_FILIAL,C5_NUM,C5.R_E_C_N_O_ "
cQ +=   " ORDER BY C5_FILIAL,C5_NUM,C5.R_E_C_N_O_ "


If select(cAliasTrb) > 0
	(cAliasTrb)->(dbclosearea())
Endif

dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

_ntot := 0
_nni := 1

(cAliasTrb)->(dbGoTop())
While (cAliasTrb)->(!Eof())
	_ntot++
	(cAliasTrb)->(dbSkip())
Enddo

(cAliasTrb)->(dbGoTop())
While (cAliasTrb)->(!Eof())

	U_MFCONOUT("Analisando pedido " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")
	
	SC5->(Dbgoto((cAliasTrb)->SC5_RECNO))

	ZHW->(Dbsetorder(1)) //ZHW_FILIAL+ZHW_PEDIDO

	If ZHW->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM))

		_lenviat := .T.
		_lenvias := .T.

		If alltrim(str((cAliasTrb)->C5HASH)) == alltrim((cAliasTrb)->ZHWC5);
			.AND. alltrim(str((cAliasTrb)->C6HASH)) == alltrim((cAliasTrb)->ZHWC6);
			.AND. alltrim(str((cAliasTrb)->ZVHASH)) == alltrim((cAliasTrb)->ZHWZV);
			.AND. (ZHW->ZHW_STATUT = 200 .OR. ZHW->ZHW_STATUT = 999);
			.AND. (ZHW->ZHW_STATUS = 200 .OR. ZHW->ZHW_STATUS = 999)

			//Atualiza hash
			Reclock("ZHW",.F.)
			ZHW->ZHW_HASHC5 := alltrim(str((cAliasTrb)->C5HASH))
			ZHW->ZHW_HASHC6 := alltrim(str((cAliasTrb)->C6HASH))
			ZHW->ZHW_HASHZV := alltrim(str((cAliasTrb)->ZVHASH))
			ZHW->(Msunlock())


			_nni++
			(cAliasTrb)->(dbSkip())
			Loop
		
		Elseif  alltrim(str((cAliasTrb)->C5HASH)) == alltrim((cAliasTrb)->ZHWC5);
			.AND. alltrim(str((cAliasTrb)->C6HASH)) == alltrim((cAliasTrb)->ZHWC6);
			.AND. alltrim(str((cAliasTrb)->ZVHASH)) == alltrim((cAliasTrb)->ZHWZV);
			.AND. (ZHW->ZHW_STATUT = 200 .OR. ZHW->ZHW_STATUT = 999 .OR. ZHW->ZHW_STATUT = 998)

			_lenviat := .F.

		Elseif  alltrim(str((cAliasTrb)->C5HASH)) == alltrim((cAliasTrb)->ZHWC5);
			.AND. alltrim(str((cAliasTrb)->C6HASH)) == alltrim((cAliasTrb)->ZHWC6);
			.AND. alltrim(str((cAliasTrb)->ZVHASH)) == alltrim((cAliasTrb)->ZHWZV);
			.AND. (ZHW->ZHW_STATUS = 200 .OR. ZHW->ZHW_STATUS = 999)

			_lenvias := .F.

		Endif

	Endif

	BEGIN TRANSACTION
	BEGIN SEQUENCE

	If !SC5->(MsRLock(SC5->(RECNO())))

		U_MFCONOUT("Pedido já em processamento " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")
		BREAK

	Endif

	
	cEmpAnt := Subs(SC5->C5_FILIAL,1,2)
	cFilAnt := Subs(SC5->C5_FILIAL,1,6)

	////Valida para integrar com Taura
	_ltaura := .F.
	lret := .F.

	If _lenviat .and. SC5->C5_XRESERV != "N" .AND. (EMPTY(SC5->C5_NOTA) .OR. ALLTRIM(SC5->C5_NOTA) == 'XXXXXX')

		SZJ->(Dbsetorder(1))	//ZJ_FILIAL+ZJ_COD

		If SZJ->(Dbseek(xfilial("SZJ")+SC5->C5_ZTIPPED)) .AND. SZJ->ZJ_TAURA = 'S'

			_ltaura := .T.
			nRet := U_TAS01EnvPV(,.T.,_nni,_ntot)

			If nret == 1 .or. nret == 3

				U_MFCONOUT('Atualizando controle de integração do  pedido ' + SC5->C5_FILIAL + "/" + SC5->C5_NUM + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")

				ZHW->(Dbsetorder(1)) //ZHW_FILIAL+ZHW_PEDIDO

				If ZHW->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM))

					Reclock("ZHW",.F.)
	
				Else

					Reclock("ZHW",.T.)

				Endif

				ZHW->ZHW_FILIAL := SC5->C5_FILIAL
				ZHW->ZHW_PEDIDO := SC5->C5_NUM
				ZHW->ZHW_HASHC5 := alltrim(str((cAliasTrb)->C5HASH))
				ZHW->ZHW_HASHC6 := alltrim(str((cAliasTrb)->C6HASH))
				ZHW->ZHW_HASHZV := alltrim(str((cAliasTrb)->ZVHASH))
				ZHW->(Msunlock())

				//Apaga bloqueios taura

				cQ := " SELECT ZV.R_E_C_N_O_ REC FROM "
				cQ += RetSqlName("SZV")+" ZV WHERE ZV.D_E_L_E_T_ <> '*' "
				cQ += " AND ZV_FILIAL = '" + ZHW->ZHW_FILIAL + "' AND ZV_PEDIDO = '" + ZHW->ZHW_PEDIDO + "' "
				cQ += " AND (ZV_CODRGA = '000088' OR ZV_CODRGA = '000089') "

				If select("SZVTMP") > 0
					SZVTMP->(dbclosearea())
				Endif

				dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),"SZVTMP",.T.,.T.)

				SZVTMP->(dbGoTop())
				
				While SZVTMP->(!Eof())

					SZV->(Dbgoto(SZVTMP->REC))

					Reclock("SZV",.F.)
					SZV->(Dbdelete())
					SZV->(Msunlock())

					SZVTMP->(dbSkip())

				Enddo

				U_MFCONOUT('Completou a integração do pedido ' + (cAliasTrb)->C5_FILIAL + "/" + (cAliasTrb)->C5_NUM + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")

			Elseif nret == 2

				U_MFCONOUT('Falhou a integração do pedido ' + (cAliasTrb)->C5_FILIAL + "/" + (cAliasTrb)->C5_NUM + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")

			Elseif nret == 4 .or. nret == 5 //Falha permanente de integração

				ZHW->(Dbsetorder(1)) //ZHW_FILIAL+ZHW_PEDIDO

				If ZHW->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM))

					Reclock("ZHW",.F.)
	
				Else

					Reclock("ZHW",.T.)

				Endif

				ZHW->ZHW_FILIAL := SC5->C5_FILIAL
				ZHW->ZHW_PEDIDO := SC5->C5_NUM
				ZHW->ZHW_HASHC5 := alltrim(str((cAliasTrb)->C5HASH))
				ZHW->ZHW_HASHC6 := alltrim(str((cAliasTrb)->C6HASH))
				ZHW->ZHW_HASHZV := alltrim(str((cAliasTrb)->ZVHASH))
				ZHW->ZHW_JSONET := "Falha permanente de integração com Taura"
				ZHW->ZHW_STATUT := 998
				ZHW->ZHW_DATAET := Date()
				ZHW->ZHW_HORAET := time()

				If nret == 5 //Falha permanente sem nenhum envio bem sucedido para o Taura manda para o salesforce

					ZHW->ZHW_JSONES := " "
					ZHW->ZHW_JSONTS := " "
					ZHW->ZHW_JSONRS := " "
					ZHW->ZHW_STATUS := 0
					ZHW->ZHW_DATAES := stod(" ")
					ZHW->ZHW_HORAES := " "

				Endif

				ZHW->(Msunlock())
			
			Endif

		Endif

	Endif

	If !_ltaura .and. _lenviat

		If ZHW->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM))

			Reclock("ZHW",.F.)
	
		Else

			Reclock("ZHW",.T.)

		Endif

		//Se é pedido com origem do Salesforce já marca para envio ao Salesforce
		If !empty(SC5->C5_XIDSFA) .AND. ZHW->ZHW_STATUT != 999
		
			ZHW->ZHW_JSONES := " "
			ZHW->ZHW_JSONTS := " "
			ZHW->ZHW_JSONRS := " "
			ZHW->ZHW_STATUS := 0
			ZHW->ZHW_DATAES := stod(" ")
			ZHW->ZHW_HORAES := " "

		Endif


		ZHW->ZHW_FILIAL := SC5->C5_FILIAL
		ZHW->ZHW_PEDIDO := SC5->C5_NUM
		ZHW->ZHW_HASHC5 := alltrim(str((cAliasTrb)->C5HASH))
		ZHW->ZHW_HASHC6 := alltrim(str((cAliasTrb)->C6HASH))
		ZHW->ZHW_HASHZV := alltrim(str((cAliasTrb)->ZVHASH))
		ZHW->ZHW_JSONET := "Não integra com Taura"
		ZHW->ZHW_STATUT := 999
		ZHW->ZHW_DATAET := Date()
		ZHW->ZHW_HORAET := time()

	
		ZHW->(Msunlock())

	Endif

	
	END SEQUENCE
	END TRANSACTION

	SC5->(Msunlock())

	_nni++
	(cAliasTrb)->(dbSkip())

Enddo

(cAliasTrb)->(dbCloseArea())

U_MFCONOUT('Completou integração de pedidos de venda para o Taura!')

Return()

// funcao de envio do PV para o Taura
User Function TAS01EnvPV(aParam, _lnovo,_nni,_ntot)

	Local cURLPost := Alltrim(GetMv("MGFTAS01NP")) //http://SPDWVAPL203:8081/taura-pedido-venda
	Local cPV      := Alltrim(SC5->C5_NUM)
	Local cStatus  := IIf( SC5->C5_LIBEROK == "Z","3","1")
	Local oItens   := Nil
	Local nRet     := 2
	Local nCnt     := 0
	Local cChave   := ""
	Local nRet     := 0
	Local cQ       := ""
	Local cTamErro := TAMSX3("C5_ZERRO")[1]
	Local cQuant := ''
	Local aRecnoSC6 := {}

	local cUpdSC6	:= ""

	Private oPV    := Nil
	Private oWSPV  := Nil

	Default _lnovo := .F.


	//Irá ignorar os pontos de chamada de atualização de fora desse job
	If !_lnovo

		Return .T.

	Endif

	cChave := cPV

	oPV := Nil
	oPV := GravarPedidoVenda():New()
	oPV:GravarPVCab(cStatus)

	SC6->(Dbsetorder(1)) //C6_FILIAL+C6_NUM+C6_ITEM

	If SC6->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM))

		Do while SC5->C5_FILIAL+SC5->C5_NUM == SC6->C6_FILIAL+SC6->C6_NUM
	
			oItens := Nil
			oItens := ItensPV():New()
			oPV:GravarPVItens(oItens)
		
			SC6->(Dbskip())

		Enddo

	Endif
	
	ZHW->(Dbsetorder(1)) //ZHW_FILIAL+ZHW_PEDIDO

	If ZHW->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM))

		_cJsonT := fwJsonSerialize(oPV, .T., .T.)

	Else

		Return 2 // ERRO POR NÃO ACHAR SZW
	
	Endif

	//Não refaz envio bem sucedido com mesmo json
	If alltrim(ZHW->ZHW_JSONET) == _cJsonT .and. ZHW->ZHW_STATUT >= 200 .AND. ZHW->ZHW_STATUT <= 299

		//Verifica se não teve outros envios pelo TAS06
		cQ := " select z1_tpinteg from  "
		cQ += RetSqlName("SZ1")+" SZ1 WHERE SZ1.D_E_L_E_T_ <> '*' "
		cQ += " and z1_docori = '"+ ALLTRIM(ZHW->ZHW_PEDIDO) + "' and z1_filial = '" + ALLTRIM(ZHW->ZHW_FILIAL) + "' "
		cQ += "  order by z1_dtexec desc, z1_hrexec desc"
	
		If select("SZ1TMP") > 0
			SZ1TMP->(dbclosearea())
		Endif

		dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),"SZ1TMP",.T.,.T.)

		SZ1TMP->(Dbgotop())

		If SZ1TMP->(Eof()) .or. !(alltrim(SZ1TMP->Z1_TPINTEG) = '008') //Ultima integracao feita pelo mgftas06
	
			Return 3 // CÓDIGO DE NÃO ENVIO POR NÃO TER ALTERAÇÃO NO JSON DE ENVIO FEITO PELO MGFTAS01

		ENDIF

	Endif

	//Pedido já faturado ou em carga não envia mais integrações de alterações
	DAI->(Dbsetorder(4)) //DAI_FILIAL+DAI_PEDIDO
	If !EMPTY(ALLTRIM(SC5->C5_NOTA)) .or. DAI->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM))

		Return 3

	Endif 

	U_MFCONOUT('Integrando pedido ' + SC5->C5_FILIAL + "/" + SC5->C5_NUM + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")
	
	oWSPV := MGFINT53():New(cURLPost,oPV/*oObjToJson*/,SC5->(Recno())/*nKeyRecord*/,/*"SC5"/*cTblUpd*/,/*"C5_ZTAUFLA"/*cFieldUpd*/,/*cCodint*/,     ,cChave/*cChave*/,.F./*lDeserialize*/,.F.   ,.F.)


	cSavcInternet := Nil
	cSavcInternet := __cInternet
	__cInternet := "AUTOMATICO"

	oWSPV:SendByHttpPost()

	__cInternet := cSavcInternet

	conout(" [TAURA] [MGFTAS01] * * * * * Status da integracao * * * * *"								)
	conout(" [TAURA] [MGFTAS01] URL..........................: " + cURLPost 							)
	conout(" [TAURA] [MGFTAS01] HTTP Method..................: " + "POST"								)
	conout(" [TAURA] [MGFTAS01] Status Http (200 a 299 ok)...: " + allTrim(  STR( oWSPV:nstatuhttp)  ) 	)
	conout(" [TAURA] [MGFTAS01] Envio Body...................: " + SUBSTR(_cjsont,1,100) 				)
	conout(" [TAURA] [MGFTAS01] Retorno......................: " + alltrim(oWSPV:cpostret) 			)
	conout(" [TAURA] [MGFTAS01] * * * * * * * * * * * * * * * * * * * * "								)

	ZHW->(Dbsetorder(1)) //ZHW_FILIAL+ZHW_PEDIDO

	If ZHW->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM))

		Reclock("ZHW",.F.)
		ZHW->ZHW_JSONET := ALLTRIM(_cjsont)
		ZHW->ZHW_JSONRT := alltrim(oWSPV:cpostret)
		ZHW->ZHW_STATUT := oWSPV:nstatuhttp
		ZHW->ZHW_DATAET := Date()
		ZHW->ZHW_HORAET := time()

		If oWSPV:nstatuhttp >= 200 .and. oWSPV:nstatuhttp <= 201

			ZHW->ZHW_JSONES := " "
			ZHW->ZHW_JSONTS := " "
			ZHW->ZHW_JSONRS := " "
			ZHW->ZHW_STATUS := 0
			ZHW->ZHW_DATAES := stod(" ")
			ZHW->ZHW_HORAES := " "

		Endif

		ZHW->(Msunlock())

	Endif

	//Grava log de envio
	U_MGFMONITOR(	SC5->C5_FILIAL								,;
					IIf(oWSPV:lOk,ALLTRIM(STR(oWSPV:nStatus)),'2')				,;
					'001'										,;
					'023'										,;
					IIf(!(oWSPV:lOk) .and. VALTYPE(oWSPV:cpostret)=="C",alltrim(oWSPV:cpostret),"")											,;
					SC5->C5_NUM									,;
					""											,;
					_cjsont										,;
					SC5->(Recno())								,;
					ALLTRIM(STR(oWSPV:nstatuhttp))				,;
					.F.											,;
					{SC5->C5_FILIAL}							,;
					""											,;
					IIf(VALTYPE(oWSPV:cpostret)=="C",alltrim(oWSPV:cpostret),"")   ,;
					""											,;
					""											,;
					""											,;
					STOD(" ")									,;
					""			 								,;
					""											,;
					""											,;
					""											,;
					""											,;
					""					)

	_lfalha := .T.

	If oWSPV:lOk

		IF oWSPV:nStatus == 1	
			
			SC6->(Dbsetorder(1)) //C6_FILIAL+C6_NUM+C6_ITEM

			If SC6->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM))

				Do while SC5->C5_FILIAL+SC5->C5_NUM == SC6->C6_FILIAL+SC6->C6_NUM
	
					If SC6->C6_XULTQTD != SC6->C6_QTDVEN

						Reclock("SC6",.F.)
						SC6->C6_XULTQTD := SC6->C6_QTDVEN
						SC6->(Msunlock())

					Endif
				
				SC6->(Dbskip())

				Enddo

			Endif

			If SC5->C5_ZBLQTAU != ' ' .or.;
				SC5->C5_ZLIBENV != 'N' .or.;
				SC5->C5_ZERRO   != ' ' .or.;
				SC5->C5_ZTAUREE != 'N' .or.;
				SC5->C5_ZTAUINT != 'S' 

				Reclock("SC5",.F.)
				SC5->C5_ZBLQTAU := ' '
				SC5->C5_ZLIBENV := 'N'
				SC5->C5_ZERRO   := ' '
				SC5->C5_ZTAUREE := 'N'
				SC5->C5_ZTAUINT := 'S'
				SC5->(Msunlock())

			Endif
		
			nRet := 1
			_lfalha := .F.

		Endif
	
	Endif

	If _lfalha 

		//Valida se é uma falha permanente
		cQ := " select r_e_c_n_o_ REC from " + RetSqlName("SZ1") + " where d_e_l_e_t_ <> '*' "
		cQ += " and (z1_tpinteg = '023' or z1_tpinteg = '008') and z1_integra = '001' and z1_docori = '" + SC5->C5_NUM 
		cq +=  "' and z1_filial = '" + SC5->C5_FILIAL + "' "
 		cQ += " order by z1_dtexec desc, z1_hrexec desc " 

		If select("SZ1TMP") > 0
			SZ1TMP->(dbclosearea())
		Endif

		dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),"SZ1TMP",.T.,.T.)


		_ntent := 0
		_lsucesso := .F.

		Do while !(SZ1TMP->(Eof()))

			SZ1->(Dbgoto(SZ1TMP->REC))

			If SZ1->Z1_STATUS = '2' .AND. SZ1->Z1_TPINTEG = '023' .AND. ;
						 alltrim(SZ1->Z1_JSON) == alltrim(_cjsont) .and.;
						 alltrim(SZ1->Z1_JSONR) == alltrim(IIf(VALTYPE(oWSPV:cpostret)=="C",alltrim(oWSPV:cpostret),""))

					_ntent++

			Endif

			If SZ1->Z1_STATUS = '1'
				_lsucesso := .T.
			Endif

			SZ1TMP->(Dbskip())

		Enddo

		If _ntent > 10

			nret := 4 //Retorno de falha permanente n a integração

		Endif

		If !(_lsucesso) //Se tem falha permanente sem nenhum envio com sucesso grava bloqueio taura e manda para salesforce

			nret := 5

			cQ := "SELECT ZV_PEDIDO "
			cQ += "FROM "+RetSqlName("SZV")+" SZV "
			cQ += "WHERE SZV.D_E_L_E_T_ = ' ' "
			cQ += "AND ZV_FILIAL = '" + SC5->C5_FILIAL + "' "
			cQ += "AND ZV_PEDIDO = '" + SC5->C5_NUM + "' "
			cQ += "AND ZV_CODRGA = '000088' " 
			cQ += "AND ZV_CODAPR = ' ' " 

			If select("SZVTMP") > 0
				SZVTMP->(dbclosearea())
			Endif

			dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),"SZVTMP",.T.,.T.)

			SZVTMP->(dbGoTop())
				
			If SZVTMP->(Eof())

				Reclock("SZV",.T.)
				SZV->ZV_FILIAL := SC5->C5_FILIAL
				SZV->ZV_PEDIDO := SC5->C5_NUM
				SZV->ZV_ITEMPED := '01'
				SZV->ZV_CODRGA := '000088'
				SZV->ZV_MOTREJE := IIf(VALTYPE(oWSPV:cpostret)=="C",alltrim(oWSPV:cpostret),"") 
				SZV->ZV_DTBLQ  := DATE()
				SZV->ZV_HRBLQ  := TIME()
				SZV->(Msunlock())

			Endif

			SZVTMP->(dbclosearea())

		Endif


	Endif

Return(nRet)


// funcao de consulta do status do PV no Taura
User Function TAS01StatPV(aParam,_lshow,_lJob)

	Local aArea := {SC5->(GetArea()),GetArea()}
	Local cURLPost := Alltrim(GetMv("MGF_URLTSP")) //"spdwvtds002/wsintegracaoshape/api/v0/pedido/PostVerificarPodeAlterarExcluirPedidoVenda"//AllTrim(getMv(""))
	Local cAliasTrb := GetNextAlias()
	Local cPV := aParam[1]
	Local cStatus := Alltrim(Str(aParam[2]))
	Local lRet := .F.
	Local cChave := ""
	Local bTaura := .F.

	Local aRet   := {}
	Local nCt    := 0
	Local cGrupo := ''
	Local lCont  := .T.
	Local cUser := __CUSERID

	Default _lshow 	:= .T.
	Default _lJob	:= .F.

	Private oStPV	:= Nil
	Private oWSStPV := Nil

	If (IsInCallStack("A410Devol") .or. SC5->C5_TIPO == "D")
		Return(.T.)
	Endif
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+cPV))

		//Perfil de PCP não pode ter acesso a alteração de pedidos Espécie VE – Venda /Tipo Operação BJ e Pedido FIFO operação FG.
		If IsInCallStack("A410Altera")
			If !Empty(cUser)
				aRet := FWSFUsrGrps(cUser)
				_cTpPed := SC5->C5_ZTIPPED
				_cOper := SC5->C5_ZTPOPER
				lCont := .T.
				If _cTpPed $ 'VE/FG' .AND. _cOper $ 'BJ'
					For nCt:= 1 to Len(aRet)
						cGrupo:= Upper(AllTrim(FWGetNameGrp(aRet[nCt])))
						If !Empty(cGrupo)
							If 'PCP' $ cGrupo
								APMsgAlert("[MGFTAS01/001] - Pedido do Tipo: "+_cTpPed+" e Operação: "+_cOper+" não pode ser alterado conforme Regra.")
								lCont := .F.
								Exit
							EndIf
						EndIf
					Next
				EndIf
			EndIf
		Endif

		If lCont

			If (IsInCallStack("A410Devol") .or. SC5->C5_TIPO == "D" .or. IIf(_lJob,.F.,Inclui) .or. M->C5_TIPO == "D")
				aEval(aArea,{|x| RestArea(x)})
				If _lJob
					Return({.T., 'Pedido bloqueado com sucesso. Sem integração com taura.' })
				Else
					Return(.T.)
				EndIf
			Endif

			IF !bTaura
				aEval(aArea,{|x| RestArea(x)})
				If _lJob
					Return({.T.,'Pedido bloqueado com sucesso. Sem integração com taura.'})
				Else
					Return(.T.)
				EndIf
			EndIF

			If FunName() == "EECFATCP" // cModulo == "EEC"
				aEval(aArea,{|x| RestArea(x)})
				Return(.T.)
			Endif

			If IsInCallStack("A410Copia")
				aEval(aArea,{|x| RestArea(x)})
				Return(.T.)
			Endif

			// rotina de importacao de ordem de embarque
			If IsInCallStack("GravarCarga") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("INCPEDEXP") .or. IsInCallStack("U_INCPEDEXP")
				aEval(aArea,{|x| RestArea(x)})
				Return(.T.)
			Endif

			// rotina de exclusao de nota de saida
			// quando ocorre exclusao de nota com processo de fis45, o pedido eh alterado novamente, para a condicao original, para se desfazer o fis45 e esta validacao nao deve ser executada
			If (IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
				aEval(aArea,{|x| RestArea(x)})
				Return(.T.)
			Endif

			// alteracao do pedido de exportacao, somente alteracao de campos permitidos
			// nao envia pedido para o taura
			If IsInCallStack("EECAP100") //.and. IsBlind()
				If Type("nOpcAux") != "U" .and. nOpcAux == 4 //ALTERAR
					If Type("__lRetStatPV") != "U" .and. !__lRetStatPV .and. SC5->C5_ZTAUINT == "S"
						aEval(aArea,{|x| RestArea(x)})
						Return(.T.)
					Endif
				Endif
			Endif

		EndIf

		cChave := xFilial("SC5")+cPV
		oStPV := Nil
		oStPV := PodeAlterarExcluirPedidoVenda():New(cStatus)

		oWSStPV := MGFINT23():New(cURLPost,oStPV/*oObjToJson*/,SC5->(Recno())/*nKeyRecord*/,/*cTblUpd*/,/*cFieldUpd*/,AllTrim(GetMv("MGF_MONI01"))/*cCodint*/,AllTrim(GetMv("MGF_MONI14"))/*cCodtpint*/,cChave/*cChave*/,.F./*lDeserialize*/,.F.,.T.)

		cSavcInternet := Nil
		cSavcInternet := __cInternet
		__cInternet := "AUTOMATICO"

		oWSStPV:SendByHttpPost()

		__cInternet := cSavcInternet


		If (Type("oWSStPV:nStatus") != "U" .and. (oWSStPV:nStatus == 1 .or. oWSStPV:nStatus == 3)) .or. (Type("oWSStPV:CDETAILINT") != "U" .and. 'result' $ oWSStPV:CDETAILINT .and. 'ok' $ oWSStPV:CDETAILINT)
			lRet := .T.
		Endif

		If !lRet .and. !IsIncallStack("U_MGFFATA7") .and. _lshow
			APMsgAlert("Não será permitida manutenção no Pedido de Venda."+CRLF+;
			"Motivo: "+oWSStPV:CDETAILINT)
		ElseIf IsIncallStack("U_MGFFATA7") .and. !lRet .and. _lshow
			If Type("_cMensTaura") == "U"
				_cMensTaura += "Não será permitida manutenção no Pedido de Venda." + CRLF
				_cMensTaura += "Motivo: " + oWSStPV:CDETAILINT + CRLF
				_cMensTaura += "--------------------------------------------------------"
			EndIf
		Endif

	Endif

	aEval(aArea,{|x| RestArea(x)})

	If _lJob
		Return({lRet, Iif( Type('oWSStPV:CDETAILINT') <> 'U' , oWSStPV:CDETAILINT , 'Pedido não localizado.' )})
	EndIf

Return(lRet)

// verifica se PV pode sofrer manutencao
User Function TAS01VldMnt(aParam,_lJob)

Local aArea     := {SC5->(GetArea()),GetArea()}
Local cPV       := aParam[1]
Local lRet      := .T.
Local cExcPed   := Alltrim(GetMv("MGF_EXPR"))
Local cUserEco	:= Alltrim(GetMv("MGF_EXUC"))//Usuario que podem excluir Pedidos do Ecommerce
Local cTiPPEco	:= Alltrim(GetMv("MGF_TPPED"))//Tipo de Pedido Ecommerce
Local cUserAlt  := RetCodUsr()
Local cBloqueio	:= ""

Default _lJob	:= .F.

If _lJob
	Inclui 	:= .F.
 	Altera	:= .F.
EndIf
If cModulo == "EEC"
	Return(.T.)
Endif

If IsInCallStack("A410Copia")
	Return(.T.)
Endif

If SC5->C5_NUM != cPV
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+cPV))
	If SC5->(!Found())
		lRet := .F.
		cBloqueio	:= "Pedido não encontrado."
		APMsgAlert(cBloqueio)
	Endif
Endif

If lRet
	If SC5->C5_ZTAUSEM == "S"
		lRet := .F.
		cBloqueio	:= "Pedido não poderá sofrer manutenção agora, pois está sendo enviado para o Taura. Aguarde o envio."
		APMsgAlert(cBloqueio)
	Endif
Endif
If lRet
	If SC5->C5_ZROAD == "S"
		IF !INCLUI .and. !ALTERA .and. !_lJob
			IF !( cUserAlt $ cExcPed)
				cBloqueio	:= "Pedido já roterizado, não é possivel excluir."
				APMsgAlert(cBloqueio)
			EndIF
		Else
			lRet := .F.
			cBloqueio	:= "Pedido já roterizado, não é possivel alterar."
			APMsgAlert(cBloqueio)
		Endif
	EndIF

	If (SC5->C5_ZTIPPED $ cTiPPEco) .and. lRet
		IF !INCLUI .and. !ALTERA .and. _lJob //Exclusão
			IF !( cUserAlt $ cUserEco)
				lRet := .F.
				cBloqueio	:= "Pedido do Ecommerce, não é possivel excluir."
				APMsgAlert(cBloqueio)
			EndIF
		ElseIf ALTERA .Or. _lJob  //Alteração
			IF !( cUserAlt $ cUserEco)
				lRet := .F.
				cBloqueio	:= "Pedido do Ecommerce, não é possivel alterar."
				APMsgAlert(cBloqueio)
			EndIf
		Endif
	EndIF
Endif

If lRet
	If !Empty(SC5->C5_NOTA)
		lRet := .F.
		cBloqueio	:= "Pedido já Faturado, não é possivel alterar."
		APMsgAlert(cBloqueio)
	Endif
Endif

If _lJob
	Return({lRet,cBloqueio})
EndIf

Return(lRet)


// rotina chamada pelo ponto de entrada MT410CPY
User Function TAS01Cpy()
Local aPar := {"MGF_PVCPY"} // se precisar de mais de 1 parametro, criar os parametros com o seguinte nome MGF_PVCPY1, MGF_PVCPY2, MGF_PVCPY3, etc
Local nCnt := 0
Local cCampos := ""
Local aCampos := {}
Local aCamposSC5 := {}
Local aCamposSC6 := {}
Local nCntCampos := 0
Local cSC6 := ""
Local bSC6 := Nil

Local aArea        := GetArea()
Local nPosProd     := GdFieldPos("C6_PRODUTO")
Local nLinAtu      := 0

For nCnt := 1 To 5 // ate 5 parametros "MGF_PVCPY"
	cCampos := GetMv(aPar[1]+Alltrim(Str(nCnt)),.F.,"") // nao mostra tela se nao encontrar o parametro
	If !Empty(cCampos)
		aCampos := StrToKArr(cCampos,"/")
		For nCntCampos := 1 To Len(aCampos)
			If Subs(aCampos[nCntCampos],1,2) == "C5"
				If SC5->(FieldPos(aCampos[nCntCampos])) > 0
					If aScan(aCamposSC5,aCampos[nCntCampos]) == 0
						aAdd(aCamposSC5,aCampos[nCntCampos])
					Endif
				Endif
			Endif
			If Subs(aCampos[nCntCampos],1,2) == "C6"
				If SC6->(FieldPos(aCampos[nCntCampos])) > 0
					If aScan(aCamposSC6,aCampos[nCntCampos]) == 0
						aAdd(aCamposSC6,aCampos[nCntCampos])
					Endif
				Endif
		  	Endif
		Next
	Endif
Next

// zera campos sc5
For nCnt := 1 To Len(aCamposSC5)
	&("M->"+aCamposSC5[nCnt]) := CriaVar(aCamposSC5[nCnt])
Next

// zera campos sc6
For nCnt := 1 To Len(aCamposSC6)
	cSC6 += IIf(Empty(cSC6),"",",")+"x[aScan(aHeader,{|x| Alltrim(x[2])=='"+aCamposSC6[nCnt]+"'})]:=CriaVar('"+aCamposSC6[nCnt]+"') "
Next
If !Empty(cSC6)
	bSC6 := 'aEval(aCols,{|x| IIf(!x[Len(x)],('+cSC6+'),Nil)})'
	&(bSC6)
Endif

//Se encontrar o campo na grid, sobrepõe o valor
If nPosProd > 0
	//Percorrendo linhas da grid
    For nLinAtu := 1 To Len(aCols)
    	n := nLinAtu // variável publica que indica a linha posicionada
        // verifica se há trigger e executa, caso exista
        If ExistTrigger("C6_PRODUTO")
        	//RunTrigger(2,n,nil,,C6_PRODUTO)
			RunTrigger(2,Len(aCols),,"C6_PRODUTO")
        Endif
    Next nLinAtu
Endif

RestArea(aArea)
Return()



// rotina chamada pelo ponto de entrada M410AGRV
User Function TAS01M410AGRV(ParamIxb)

Local lRet := .F.

// envia exclusao do PV para o Taura
If ParamIxb[1] == 3 // exclusao
	dbSelectArea('SZJ')
	SZJ->(dbSetOrder(1))
	IF SZJ->(dbSeek(xFilial('SZJ')+SC5->C5_ZTIPPED))
		IF SZJ->ZJ_TAURA == 'S'
			SC5->(RecLock("SC5",.F.))
			SC5->C5_ZBLQTAU := "S"
			SC5->(MsUnLock())
		EndIF
	EndIF
Endif

Return()


// rotina chamada pelo ponto de entrada MTA500FIL
User Function TAS01RESFIL()

Local cFil := ""

cFil := " C5_ZTAUFLA = '3' " // somente gera residuo de PV enviado ao Taura e nao aproveitado no Taura

Return(cFil)


// rotina chamada pelo ponto de entrada M410STTS
User Function TAS01STTSM410()

// se estiver alterando um PV, flag para reenviar o PV
If IsInCallStack('A410ALTERA') .and. SC5->C5_ZTAUFLA != "3" //.and. !Empty(SC5->C5_ZTAUINT)
	SC5->(RecLock("SC5",.F.))
	SC5->C5_ZTAUREE := "N"
	SC5->(MsUnLock())
Endif

Return()

// avalia se pedido tem alguma regra de bloqueio do keyconsult
Static Function AvalRgaKey(cPed)

Local aArea := {GetArea()}
Local lRet := .F.
Local cAliasTrb := GetNextAlias()
Local cQ := ""

cQ := "SELECT 1 "
cQ += "FROM "+RetSqlName("SZV")+" SZV "
cQ += "WHERE SZV.D_E_L_E_T_ = ' ' "
cQ += "AND ZV_FILIAL = '"+xFilial("SZV")+"' "
cQ += "AND ZV_PEDIDO = '"+cPed+"' "
cQ += "AND ZV_CODRGA IN "+FormatIn(GetMv("MGF_TAS015"),"/")+" " // somente pedidos com estes bloqueios
cQ += "AND ZV_CODAPR = ' ' " // somente pedidos nao aprovados

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

If (cAliasTrb)->(!Eof())
	lRet := .T.
Endif

(cAliasTrb)->(dbCloseArea())
aEval(aArea,{|x| RestArea(x)})

Return(lRet)


Class PodeAlterarExcluirPedidoVenda

Data Acao				as String
Data Filial				as String
Data Pedido				as String
Data TipoPedido	   		as String
Data DataPedido	   		as String
Data ApplicationArea	as ApplicationArea

Method New()

End Class


Method New(cStatus) Class PodeAlterarExcluirPedidoVenda

Local cStringTime := "T00:00:00"

::Acao := cStatus
::Filial := SC5->C5_FILIAL
::Pedido := Alltrim(SC5->C5_NUM)
::TipoPedido := Alltrim(IIf(SC5->(FieldPos("C5_ZTIPPED"))>0,SC5->C5_ZTIPPED,""))
::DataPedido := IIf(!Empty(SC5->C5_EMISSAO),Subs(dTos(SC5->C5_EMISSAO),1,4)+"-"+Subs(dTos(SC5->C5_EMISSAO),5,2)+"-"+Subs(dTos(SC5->C5_EMISSAO),7,2)+cStringTime,"")
::ApplicationArea := ApplicationArea():New()

Return


Class GravarPedidoVenda

Data Acao					as String
Data Filial					as String
Data Pedido					as String
Data TipoPedidoERP			as String
Data TipoPedido	   			as String
Data Cliente				as String
Data ClienteLoja			as String
Data DataEmissao			as String
Data DataEmbarque			as String
Data DataEntrega			as String
Data Status					as String
Data TipoFrete				as String
Data Observacao				as String
Data CodigoBarras			as String
Data EnderecoEntrega		as String
Data DescricaoEnderecoEntrega		as String
Data CidadeEntrega			as String
Data EstadoEntrega			as String
Data LogradouroEntrega		as String
Data BairroEntrega			as String
Data PedidoCliente			as String
Data ApplicationArea		as ApplicationArea
Data Documento				as String
Data Inscricao_Estadual		as String
Data UF						as String
Data Data_Nascimento		as String
Data Inscricao_Suframa		as String
Data Validade_Suframa		as String
Data Consulta_Hab			as String
Data Taura					as String
Data Produtor_Rural			as String

Data Itens					as Array

Method New()
Method GravarPVCab()
Method GravarPVItens()

EndClass


Method New() Class GravarPedidoVenda

	::ApplicationArea := ApplicationArea():New()

Return


Method GravarPVCab(cStatus) Class GravarPedidoVenda

	Local cStringTime := "T00:00:00"
	Local cCliente := ""
	Local cLoja := ""

	If SC5->C5_TIPO $ ("D/B")
		SA2->(dbSetOrder(1))
		If SA2->(dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			If !Empty(SA2->A2_ZCODMGF)
				cCliente := SA2->A2_ZCODMGF
			Else
				cCliente := SA2->A2_COD
				cLoja := SA2->A2_LOJA
			Endif
			::Documento := SA2->A2_CGC
			::Inscricao_Estadual := SA2->A2_INSCR
			::UF := SA2->A2_EST
			::Data_Nascimento := IIf(!Empty(SA2->A2_DTNASC),Subs(dTos(SA2->A2_DTNASC),1,4)+"-"+Subs(dTos(SA2->A2_DTNASC),5,2)+"-"+Subs(dTos(SA2->A2_DTNASC),7,2)+cStringTime,"")
			::Inscricao_Suframa := ""
			::Validade_Suframa := ""
		Endif
	Else
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			If !Empty(SA1->A1_ZCODMGF) // campo que conterah o codigo do cliente no sistema da Marfrig. ***verificar o nome que este campo serah criado
				cCliente := SA1->A1_ZCODMGF
			Else
				cCliente := SA1->A1_COD
				cLoja := SA1->A1_LOJA
			Endif
			::Documento          := SA1->A1_CGC
			::Inscricao_Estadual := SA1->A1_INSCR
			::UF                 := SA1->A1_EST
			::Data_Nascimento    := IIf(!Empty(SA1->A1_DTNASC),Subs(dTos(SA1->A1_DTNASC),1,4)+"-"+Subs(dTos(SA1->A1_DTNASC),5,2)+"-"+Subs(dTos(SA1->A1_DTNASC),7,2)+cStringTime,IIf(!Empty(SA1->A1_DTCAD),Subs(dTos(SA1->A1_DTCAD),1,4)+"-"+Subs(dTos(SA1->A1_DTCAD),5,2)+"-"+Subs(dTos(SA1->A1_DTCAD),7,2)+cStringTime,""))
			::Inscricao_Suframa  := SA1->A1_SUFRAMA
			::Validade_Suframa   := IIf(SA1->(FieldPos("A1_ZSUFVLD"))>0 .and. !Empty(SA1->A1_ZSUFVLD),Subs(dTos(SA1->A1_ZSUFVLD),1,4)+"-"+Subs(dTos(SA1->A1_ZSUFVLD),5,2)+"-"+Subs(dTos(SA1->A1_ZSUFVLD),7,2)+cStringTime,"")
		Endif
	Endif

	if SC5->C5_ZTIPPED == "EX"
		cObs := allTrim( SC5->C5_ZOBSND ) + " -- " + allTrim( SC5->C5_ZOBS )
	else
	   cObs := allTrim( SC5->C5_ZOBS ) + " -- " + allTrim( SC5->C5_XOBSPED )
	endif

	SZ9->(Dbsetorder(1)) //Z9_FILIAL+Z9_CLIENTE+Z9_ZIDEND

	If SZ9->(Dbseek(xfilial("SZ9")+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_ZIDEND))

		_cendereco := alltrim(SZ9->Z9_ZENDER)
		_ccidade := alltrim(SZ9->Z9_ZMUNIC)
		_cbairro := alltrim(SZ9->Z9_ZBAIRRO)
		_cestado := alltrim(SZ9->Z9_ZEST)

	Else

		If SC5->C5_TIPO $ ("D/B")
			SA2->(dbSetOrder(1))
			If SA2->(dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		
				_cendereco := alltrim(SA2->A2_END)
				_ccidade := alltrim(SA2->A2_MUN)
				_cbairro := alltrim(SA2->A2_BAIRRO)
				_cestado := alltrim(SA2->A2_EST)

			Endif
		Else
			SA1->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			
				_cendereco := IIF(!EMPTY(SA1->A1_ENDENT),alltrim(SA1->A1_ENDENT),alltrim(SA1->A1_END))
				_ccidade := alltrim(SA1->A1_MUN)
				_cbairro := alltrim(SA1->A1_BAIRRO)
				_cestado := alltrim(SA1->A1_EST)

			Endif
		Endif

	
	Endif

	::Acao            := IIf(SC5->(Deleted()) .or. SC5->C5_LIBEROK == "Z","3",IIf(SC5->C5_ZTAUINT=="S","2","1")) //'1' //cStatus
	::Filial 		  := SC5->C5_FILIAL
	::Pedido 		  := Alltrim(SC5->C5_NUM)
	::TipoPedidoERP   := Alltrim(SC5->C5_TIPO) //"VE"
	::TipoPedido 	  := Alltrim(IIf(SC5->(FieldPos("C5_ZTIPPED"))>0,SC5->C5_ZTIPPED,"")) //"VE"
	::Cliente 		  := Alltrim(cCliente)
	::ClienteLoja 	  := Alltrim(cLoja)
	::DataEmissao 	  := IIf(!Empty(SC5->C5_EMISSAO),Subs(dTos(SC5->C5_EMISSAO),1,4)+"-"+Subs(dTos(SC5->C5_EMISSAO),5,2)+"-"+Subs(dTos(SC5->C5_EMISSAO),7,2)+cStringTime,"")
	::DataEmbarque 	  := IIf(!Empty(SC5->C5_ZDTEMBA),Subs(dTos(SC5->C5_ZDTEMBA),1,4)+"-"+Subs(dTos(SC5->C5_ZDTEMBA),5,2)+"-"+Subs(dTos(SC5->C5_ZDTEMBA),7,2)+cStringTime,"")
	::DataEntrega 	  := IIf(!Empty(SC5->C5_FECENT),Subs(dTos(SC5->C5_FECENT),1,4)+"-"+Subs(dTos(SC5->C5_FECENT),5,2)+"-"+Subs(dTos(SC5->C5_FECENT),7,2)+cStringTime,"")
	::Status 		  := IIf(!Empty(SC5->C5_PEDEXP),"N",IIf(SC5->C5_ZBLQRGA=="B","B","N")) // B=bloqueado,N=Liberado
	::TipoFrete 	  := SC5->C5_TPFRETE //IIf(SC5->C5_TPFRETE=="C","1",IIf(SC5->C5_TPFRETE=="F","2",IIf(SC5->C5_TPFRETE=="T","3","")))
	::Observacao 	  := Alltrim(cObs)   //era Alltrim(SC5->C5_ZOBS))
	::CodigoBarras 	  := Alltrim(SC5->C5_ZCODBAR)
	::EnderecoEntrega := cCliente+IIf(Empty(SC5->C5_ZIDEND),"0",Alltrim(Str(Val(SC5->C5_ZIDEND)))) //Alltrim(IIf(SC5->(FieldPos("C5_ZIDEND"))>0,IIf(Empty(SC5->C5_ZIDEND),"0",SC5->C5_ZIDEND),"0"))
	::DescricaoEnderecoEntrega 	:= _cendereco
	::CidadeEntrega				:= _ccidade
	::EstadoEntrega 			:= _cestado
	::LogradouroEntrega 		:= _cendereco
	::BairroEntrega 			:= _cbairro
	::PedidoCliente   := Alltrim(SC5->C5_ZPEDCLI)
	::Consulta_Hab 	  := IIf((GetMv("MGF_TAS012",,.T.) .and. SC5->C5_FILIAL $ GetMv("MGF_TAS014") .and. !Empty(GetMv("MGF_TAS015")) .and. GetAdvFVal("SZJ","ZJ_KEYCONS",xFilial("SZJ")+SC5->C5_ZTIPPED,1,"")=="S" .and. AvalRgaKey(SC5->C5_NUM)),"S",SC5->C5_ZCONFIS)
	::Taura			  := IIf(GetAdvFVal("SZJ","ZJ_TAURA",xFilial("SZJ")+SC5->C5_ZTIPPED,1,"")=="S","S","N")
	::Produtor_Rural  := IIf(SC5->C5_TIPOCLI=="L","S","N")

	::Itens	:= {}

Return()

Class ItensPV

Data Filial					as String
Data Pedido					as String
Data Item					as String
Data Produto				as String
Data UnidadeMedida			as String
Data QuantidadeKGVenda		as Float
Data PrecoVenda				as Float
Data QuantidadeCaixa		as Float
Data DataProducaoMinima		as String
Data DataProducaoMaxima		as String
Data DataPedido				as String
Data TipoPedido				as String
Data QuantidadeVolumes		as Integer
Data Observacao				as String

Method New()

End Class

Method New() Class ItensPV

Local cStringTime := "T00:00:00"
Local cDtMin      := ''
Local cDtMax      := ''

::Filial := SC6->C6_FILIAL
::Pedido := Alltrim(SC6->C6_NUM)
::Item := SC6->C6_ITEM
::Produto := Alltrim(SC6->C6_PRODUTO)
::UnidadeMedida := Alltrim(SC6->C6_UM)
::QuantidadeKGVenda := SC6->C6_QTDVEN
::PrecoVenda := SC6->C6_PRCVEN
::QuantidadeCaixa := SC6->C6_ZQTDPEC
IF (SC6->C6_ZDTMIN  > dDataBase - 10000) .OR. (SC6->C6_ZDTMAX  <= dDataBase + 9000)
	//So preenche se tiver data valida
	If !(empty(alltrim(dTos(SC6->C6_ZDTMIN))))
		cDtMin      := Subs(dTos(SC6->C6_ZDTMIN),1,4)+"-"+Subs(dTos(SC6->C6_ZDTMIN),5,2)+"-"+Subs(dTos(SC6->C6_ZDTMIN),7,2)+cStringTime
	Endif
	If !(empty(alltrim(dTos(SC6->C6_ZDTMAX))))
		cDtMax      := Subs(dTos(SC6->C6_ZDTMAX),1,4)+"-"+Subs(dTos(SC6->C6_ZDTMAX),5,2)+"-"+Subs(dTos(SC6->C6_ZDTMAX),7,2)+cStringTime
	Endif
EndIF
::DataProducaoMinima := cDtMin
::DataProducaoMaxima := cDtMax
::DataPedido := IIf(!Empty(SC5->C5_EMISSAO),Subs(dTos(SC5->C5_EMISSAO),1,4)+"-"+Subs(dTos(SC5->C5_EMISSAO),5,2)+"-"+Subs(dTos(SC5->C5_EMISSAO),7,2)+cStringTime,"")
::TipoPedido := Alltrim(IIf(SC5->(FieldPos("C5_ZTIPPED"))>0,SC5->C5_ZTIPPED,"")) //"VE"
::QuantidadeVolumes := SC6->C6_ZVOLUME

if SC5->C5_ZTIPPED == "EX"
	cObs := allTrim( SC5->C5_ZOBSND ) + " -- " + allTrim( SC5->C5_ZOBS )
else
   cObs := allTrim( SC5->C5_ZOBS ) + " -- " + allTrim( SC5->C5_XOBSPED )
endif

::Observacao := Alltrim(cObs)     //era Alltrim(SC5->C5_ZOBS)

Return()


Method GravarPVItens(oItens) Class GravarPedidoVenda

aAdd(::Itens,oItens)

Return()

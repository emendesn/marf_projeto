#include 'protheus.ch'
#include 'parmtype.ch'

user function MGFFINA4()

	RPCSetType(3)
	RpcSetEnv( '01' , '010001' , Nil, Nil, "FAT", Nil )
	SetFunName("MGFFINA4")

		xAtSA1SE1()
		xAtAteSE1()
		xSituVaz()
		xSituErr()

	RpcClearEnv()

return

Static Function xAtSA1SE1()

	Local cQrySE1 := GetNextAlias()
	Local cUpdQry := ""

	BeginSql Alias cQrySE1

		SELECT
			SE1.R_E_C_N_O_ SE1RECNO,
			SA1.A1_NOME NOME,
			SA1.A1_CGC CGC
		FROM
			%TABLE:SE1% SE1
		INNER JOIN %TABLE:SA1% SA1
			ON SA1.A1_COD  = SE1.E1_CLIENTE
			AND SA1.A1_LOJA = SE1.E1_LOJA
			AND SA1.%NOTDEL%
		WHERE
			SE1.%NOTDEL%
			AND SA1.A1_TIPO <> 'X'
			AND SE1.E1_CLIENTE NOT IN ('000000','001','002','003','004','005','010','008')
			AND SE1.E1_EMISSAO > '20180701'
			AND (SE1.E1_ZCNPJ = ' ' OR SE1.E1_NOMCLI = ' ')

	EndSql

	(cQrySE1)->(dbGoTop())

	While (cQrySE1)->(!EOF())

		cUpdQry := " UPDATE " + RetSqlName("SE1") + " SET E1_ZCNPJ = '" + (cQrySE1)->CGC + "', E1_NOMCLI = '" + Alltrim(substr((cQrySE1)->NOME,1,20)) + "' "
		cUpdQry += " WHERE R_E_C_N_O_ = " + alltrim(str((cQrySE1)->SE1RECNO,0))

		TcSQLExec(cUpdQry)

		(cQrySE1)->(dbSkip())
	EndDo

	(cQrySE1)->(dbCloseArea())

return

Static Function xAtAteSE1()

	Local aArea		:= GetArea()
	Local aAreaSE1	:= SE1->(GetArea())
	Local aAreaSA1	:= SA1->(GetArea())

	Local cQrySE1 := GetNextAlias()
	Local cAliasZDN := GetNextAlias()
	Local cAliasZDM := GetNextAlias()

	Local cCNPJ   	:= ''
	Local cNomeCF 	:= ''
	Local cRede		:= ''
	Local cSegmento	:= ''

	Local _CUSR   	:= ''
	Local _DCUSR  	:= ''
	Local _cREDE  	:= ''
	Local _cDREDE 	:= ''
	Local _cDSEG	:= ''

	BeginSql Alias cQrySE1

		SELECT
			SA1.A1_ZREDE COD_REDE,
			SA1.A1_CODSEG COD_SEGMENTO,
			SE1.E1_ZATEND ATENDENTE,
			SE1.E1_ZSEGMEN DESC_SEGMENTO,
			SE1.E1_ZDESRED DESC_REDE,
			SE1.R_E_C_N_O_ RECNO_SE1,
			SA1.R_E_C_N_O_ RECNO_SA1
		FROM
			%TABLE:SE1% SE1
		INNER JOIN
			%TABLE:SA1% SA1
			 ON SA1.A1_COD = SE1.E1_CLIENTE
			AND SA1.A1_LOJA = SE1.E1_LOJA
			AND SA1.%NOTDEL%
		WHERE SE1.%NOTDEL%
			AND SE1.E1_ZATEND = ' '
			AND SE1.E1_SALDO > 0
			AND (SA1.A1_ZREDE <> ' ' OR SA1.A1_CODSEG <> ' ')
			AND ((SA1.A1_ZREDE = (SELECT ZDN.ZDN_CODRED FROM %TABLE:ZDN%  ZDN WHERE ZDN.ZDN_CODRED = SA1.A1_ZREDE AND ZDN.%NOTDEL%))
			OR (SA1.A1_CODSEG = (SELECT ZDM.ZDM_CODSEG FROM %TABLE:ZDM%  ZDM WHERE ZDM.ZDM_CODSEG = SA1.A1_CODSEG AND ZDM.ZDM_CODSEG <> ' ' AND ZDM.%NOTDEL%)))

	EndSql

	(cQrySE1)->(dbGoTop())

	While (cQrySE1)->(!EOF())

		SA1->(dbGoTo((cQrySE1)->RECNO_SA1))

		cCNPJ   	:= SA1->A1_CGC
		cNomeCF 	:= SA1->A1_NOME
		cRede		:= SA1->A1_ZREDE
		cSegmento	:= SA1->A1_CODSEG

		BeginSql Alias cAliasZDN
			SELECT
				ZDN_USUARI,
				ZDN_CODRED,
				ZDN_DESRED
			FROM %TABLE:ZDN% ZDN
			WHERE
				ZDN.%NOTDEL%
			AND ZDN_CODRED = %EXP:cRede%
		EndSql

		(cAliasZDN)->(dbGoTop())

		If (cAliasZDN)->(!EOF())
			_CUSR   :=(cAliasZDN)->ZDN_USUARI
			_DCUSR  := AllTrim(u_MGF8NomU(_CUSR))
			_cREDE  :=(cAliasZDN)->ZDN_CODRED
			_cDREDE :=(cAliasZDN)->ZDN_DESRED
		Else
			_cREDE  :=""
			_cDREDE :=""

			BeginSql Alias cAliasZDM
				SELECT
					ZDM_USUARI,
					ZDM_CODSEG,
					ZDM_DESCSE
				FROM %TABLE:ZDM% ZDM
				WHERE
					ZDM.%NOTDEL%
				AND ZDM_CODSEG = %EXP:cSegmento%
			EndSql
			(cAliasZDM)->(dbGoTop())

			If (cAliasZDM)->(!EOF())
				_CUSR  := (cAliasZDM)->ZDM_USUARI
				_DCUSR := AllTrim(u_MGF8NomU(_CUSR))
				_cDSEG := (cAliasZDM)->ZDM_DESCSE
			Else
				_CUSR  := ""
				_DCUSR := ""
				_cDSEG := ""
			Endif
			(cAliasZDM)->(dbCloseArea())
		Endif

		(cAliasZDN)->(dbCloseArea())

		SE1->(dbGoTo((cQrySE1)->RECNO_SE1))

		SE1->(RecLock("SE1",.F.))
			SE1->E1_ZATEND  := _DCUSR
			SE1->E1_ZDESRED	:= _cDREDE
			SE1->E1_ZSEGMEN	:= _cDSEG
		SE1->(MsUnlock())

		(cQrySE1)->(dbSkip())
	EndDo

	(cQrySE1)->(dbCloseArea())

	RestArea(aAreaSA1)
	RestArea(aAreaSE1)
	RestArea(aArea)

return

Static Function xSituVaz()

	Local cQrySE1 := GetNextAlias()
	Local cUpdQry := ""

	BeginSql Alias cQrySE1

		SELECT
			SE1.R_E_C_N_O_ SE1RECNO,
			SE1.E1_PORTADO,
			SE1.E1_NUMBOR
		FROM
			%TABLE:SE1% SE1
		WHERE
			SE1.%NOTDEL%
			AND SE1.E1_SITUACA = ' '

	EndSql

	(cQrySE1)->(dbGoTop())

	While (cQrySE1)->(!EOF())

		SE1->(dbGoTo((cQrySE1)->SE1RECNO))

		SE1->(RecLock("SE1",.F.))
			If !Empty((cQrySE1)->E1_PORTADO) .and. !empty((cQrySE1)->E1_NUMBOR)
				SE1->E1_SITUACA := "1"
			Else
				SE1->E1_SITUACA := "0"
			EndIf
		SE1->(MsUnlock())

		(cQrySE1)->(dbSkip())

	EndDo

	(cQrySE1)->(dbCloseArea())

return

Static Function xSituErr()

	Local cQrySE1 := GetNextAlias()
	Local cUpdQry := ""

	BeginSql Alias cQrySE1

		SELECT
			SE1.R_E_C_N_O_ SE1RECNO
		FROM
			%TABLE:SE1% SE1
		WHERE
			SE1.%NOTDEL%
			AND SE1.E1_PORTADO <> ' '
			AND SE1.E1_NUMBOR <> ' '
			AND SE1.E1_SITUACA = '0'

	EndSql

	(cQrySE1)->(dbGoTop())

	While (cQrySE1)->(!EOF())

		SE1->(dbGoTo((cQrySE1)->SE1RECNO))

		SE1->(RecLock("SE1",.F.))
			SE1->E1_SITUACA := "1"
		SE1->(MsUnlock())

		(cQrySE1)->(dbSkip())

	EndDo

	(cQrySE1)->(dbCloseArea())

return
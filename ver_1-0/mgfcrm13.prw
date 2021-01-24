#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
 
#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM13
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              03/04/2017
Descricao / Objetivo:   
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM13()
	local cCdRami		:= ""
	local cStrLog		:= ""
	local nI			:= 0
	local lRet			:= .T.
	local cLocalDev		:= allTrim(superGetMv("MGF_ARMDEV", .F., "99"))
	local nPosItem		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM"		})
	local nPosCod 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"			})
	local nPosQuant 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_QUANT"		})
	local nPosLocal 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOCAL"		})
	local nPosNFOri		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_NFORI"		})
	local nPosSerOri	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_SERIORI"		})
	local nPosItOri 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEMORI"		})
	local nPosRAMI 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ZRAMI"		})

	if M->cTipo <> "D"
	//if empty(M->F1_ZSENHA)
		return lRet
	endif

	if !empty(aCols[1, nPosRAMI])
		cCdRami := aCols[1, nPosRAMI]
	else
		msgAlert("Selecione um processo RAMI para Devolução. Tecla F4 para selecionar o processo RAMI.")
		lRet := .F.
		return lRet
	endif

	itensRami(cCdRami)

	if INCLUI .or. ALTERA
		for nI := 1 to len(aCols)
			if cCdRami <> aCols[nI, nPosRAMI]
				msgAlert("Selecione um processo RAMI para Devolução. Tecla F4 para selecionar o processo RAMI.")
				lRet := .F.
				return lRet
			endif
		next

		for nI := 1 to len(aCols)
			if !aCols[nI, len(aHeader)+1]
				lOk := .F.
				QRYZAW->(DBGoTop())
				while !QRYZAW->(EOF())
					if QRYZAW->ZAV_NOTA			== aCols[nI, nPosNFOri]		.and.;
						QRYZAW->ZAV_SERIE		== aCols[nI, nPosSerOri]	.and.;
						QRYZAW->ZAW_ITEMNF		== aCols[nI, nPosItOri] 	.and.;
						QRYZAW->ZAW_CDPROD		== aCols[nI, nPosCod]		.and.;
						QRYZAW->ZAW_QTD			== aCols[nI, nPosQuant]		.and.;
						aCols[nI, nPosLocal]	== cLocalDev

						lOk := .T.
						exit
					endif
					QRYZAW->(DBSkip())
				enddo

				if !lOk
					lRet := .F.
					cStrLog += "Item " + allTrim(aCols[nI, nPosItem]) + " da Pré nota não corresponde com o RAMI." + CRLF
				endif
			endif
		next

		QRYZAW->(DBGoTop())
		while !QRYZAW->(EOF())
			lOk := .F.
			for nI := 1 to len(aCols)
				if QRYZAW->ZAV_NOTA			== aCols[nI, nPosNFOri]		.and.;
					QRYZAW->ZAV_SERIE		== aCols[nI, nPosSerOri]	.and.;
					QRYZAW->ZAW_ITEMNF		== aCols[nI, nPosItOri] 	.and.;
					QRYZAW->ZAW_CDPROD		== aCols[nI, nPosCod]		.and.;
					QRYZAW->ZAW_QTD			== aCols[nI, nPosQuant]		.and.;
					aCols[nI, nPosLocal]	== cLocalDev				.and.;
					!aCols[nI, len(aHeader)+1]

					lOk := .T.
					exit
				endif
			next

			if !lOk
				lRet := .F.
				cStrLog += "Item " + allTrim(QRYZAW->ZAW_ITEMNF) + " do RAMI não foi lançado na Pré nota." + CRLF
			endif

			QRYZAW->(DBSkip())
		enddo
	endif

	if !empty(cStrLog)
		aviso("Pré Nota de Devolução inválida", "A pré nota de devolução digitada é inválida. " + CRLF + "Verifique problemas abaixo: " + CRLF + cStrLog, {"Ok"}, 3)
	else
		M->F1_ZSENHA := cCdRami
	endif

	QRYZAW->(DBCloseArea())
return lRet

//------------------------------------------------------
//------------------------------------------------------
static function itensRami(cCodRAMI)
	local cQryZAW := ""

	cQryZAW := "SELECT *" 												+ CRLF
	cQryZAW += " FROM " + retSQLName("ZAV") + " ZAV"					+ CRLF
	cQryZAW += " INNER JOIN " + retSQLName("ZAW") + " ZAW"				+ CRLF
	cQryZAW += " ON"													+ CRLF
	cQryZAW += " 		ZAV.ZAV_SERIE	=	ZAW.ZAW_SERIE"				+ CRLF
	cQryZAW += " 	AND	ZAV.ZAV_NOTA	=	ZAW.ZAW_NOTA"				+ CRLF
	cQryZAW += " WHERE"													+ CRLF
	cQryZAW += " 		ZAV.ZAV_CODIGO	=	'" + cCodRAMI		+ "'"	+ CRLF
	cQryZAW += " 	AND	ZAW.ZAW_FILIAL	=	'" + xFilial("ZAW") + "'"	+ CRLF
	cQryZAW += " 	AND	ZAV.ZAV_FILIAL	=	'" + xFilial("ZAV") + "'"	+ CRLF
	cQryZAW += " 	AND	ZAW.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQryZAW += " 	AND	ZAV.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQryZAW += " ORDER BY ZAW.ZAW_ITEMNF"								+ CRLF

	TcQuery cQryZAW New Alias "QRYZAW"
return

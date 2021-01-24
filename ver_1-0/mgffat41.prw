#INCLUDE "TOTVS.CH"
#Include "XMLXFUN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa............: MGFFAT41
Autor...............: Atilio Amarilla
Data................: 06/07/2017
Descricao / Objetivo: Grava ZBS / Gera xml / Envio de averbacao
=====================================================================================
*/
User Function MGFFAT41(oNfe,cNomArq)

	Local cDirGrv	:= GetMv("MGF_FAT41A",,"\\SPDWVAPL182\XML_NFE\") // Caminho de rede, pasta XML_NFE compartilhada
	Local cDirSrv	:= GetMv("MGF_FAT41B",,"\MGF\FAT\XML_NFE\") 	 // Caminho de gravação de Arquivos
	Local cDirCmp	:= "" // Complemento de caminho de gravação de Arquivos
	Local dDatIni	:= GetMv("MGF_FAT41C",,STOD("20170614")) 	 // Data Início - Referência para Averbação RCTRC
	Local nPosChr	:= 0
	Local _lFat41X  := SuperGetMV("MGF_FATXML",.T.,.T.) //Habilita copia do xml

	// Paulo Henrique - 05/12/2019 - Parâmetros de acesso ao Oracle e ao Servidor do dbAccess
	Local cAcesDb   := GetMv("MGF_FAT41G",,"ORACLE/SPED")  // Acesso ao Oracle
	Local cSrvDba   := GetMv("MGF_FAT41H",,"SPDWVAPL228F") // Acesso Servidor do DbAcess
	Local nPortDb   := GetMv("MGF_FAT41I",,7885)

	Local _lRCTRC := .F.

	//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
	If !ExisteSx6("MGF_FAT41J")
		CriarSX6("MGF_FAT41J", "L", "Valida Nova Regra de Exeções RCTRC (.T./.F.)?"			, '.F.' )	
	EndIf

	cNomArq += ".xml"

	cDirCmp += SF2->F2_FILIAL + "\" + Tran( DTOS(SF2->F2_EMISSAO) , "@R 9999\99\99\" )

	U_zMakeDir( cDirSrv + cDirCmp )

	// Grava conexão atual
	_ndbprotheus := AdvConnection()

	// Monta conexão ao SPED (Paulo Henrique - 05/12/2019 - Troca do Acesso por parâmetros )
	_ndbsped := tclink(AllTrim(cAcesDb),AllTrim(cSrvDba),nPortdb)

	//Muda para conexão do SPED e busca strings para montar xml
	TCSETCONN(_ndbsped) 

	_cxml := '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">'

	//Busca xml assinado
	cQuery := " SELECT UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 1)) AS XML_SIG1,
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 2001)) AS XML_SIG2, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 4001)) AS XML_SIG3, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 6001)) AS XML_SIG4, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 8001)) AS XML_SIG5, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 10001)) AS XML_SIG6, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 12001)) AS XML_SIG7, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 14001)) AS XML_SIG8, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 16001)) AS XML_SIG9, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 18001)) AS XML_SIG0, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 20001)) AS XML_SIGA, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 22001)) AS XML_SIGB, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 24001)) AS XML_SIGC, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 26001)) AS XML_SIGD, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 28001)) AS XML_SIGE, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 30001)) AS XML_SIGF, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 32001)) AS XML_SIGG, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 34001)) AS XML_SIGH, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 36001)) AS XML_SIGI, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 38001)) AS XML_SIGJ, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 40001)) AS XML_SIGK, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 42001)) AS XML_SIGL, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 44001)) AS XML_SIGM, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 46001)) AS XML_SIGN, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 48001)) AS XML_SIGO, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 50001)) AS XML_SIGP, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 52001)) AS XML_SIGQ, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 54001)) AS XML_SIGR, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 56001)) AS XML_SIGS, R_E_C_N_O_ AS RECN "
	cQuery += " FROM SPED050 "
	cQuery += "  WHERE DOC_CHV  = '" + SF2->F2_CHVNFE + "'"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP050", .F., .T.)
	If TMP050->(!eof())	
		_cxml += substr(TMP050->XML_SIG1,1,2000)
		_cxml += substr(TMP050->XML_SIG2,1,2000)
		_cxml += substr(TMP050->XML_SIG3,1,2000)
		_cxml += substr(TMP050->XML_SIG4,1,2000)
		_cxml += substr(TMP050->XML_SIG5,1,2000)
		_cxml += substr(TMP050->XML_SIG6,1,2000)
		_cxml += substr(TMP050->XML_SIG7,1,2000)
		_cxml += substr(TMP050->XML_SIG8,1,2000)
		_cxml += substr(TMP050->XML_SIG9,1,2000)
		_cxml += substr(TMP050->XML_SIG0,1,2000)
		_cxml += substr(TMP050->XML_SIGA,1,2000)
		_cxml += substr(TMP050->XML_SIGB,1,2000)
		_cxml += substr(TMP050->XML_SIGC,1,2000)
		_cxml += substr(TMP050->XML_SIGD,1,2000)
		_cxml += substr(TMP050->XML_SIGE,1,2000)
		_cxml += substr(TMP050->XML_SIGF,1,2000)
		_cxml += substr(TMP050->XML_SIGG,1,2000)
		_cxml += substr(TMP050->XML_SIGH,1,2000)
		_cxml += substr(TMP050->XML_SIGI,1,2000)
		_cxml += substr(TMP050->XML_SIGJ,1,2000)
		_cxml += substr(TMP050->XML_SIGK,1,2000)
		_cxml += substr(TMP050->XML_SIGL,1,2000)
		_cxml += substr(TMP050->XML_SIGM,1,2000)
		_cxml += substr(TMP050->XML_SIGN,1,2000)
		_cxml += substr(TMP050->XML_SIGO,1,2000)
		_cxml += substr(TMP050->XML_SIGP,1,2000)
		_cxml += substr(TMP050->XML_SIGQ,1,2000)
		_cxml += substr(TMP050->XML_SIGR,1,2000)
		_cxml += substr(TMP050->XML_SIGS,1,2000)
	Endif
	
	TMP050->(dbclosearea())
		
	//Busca protocolo de retorno
	cQuery := " SELECT UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_PROT, 2000, 1)) AS XML_PROT FROM SPED054 "
	cQuery += "  WHERE NFE_CHV  = '" + SF2->F2_CHVNFE + "'"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP054", .F., .T.)
	
	If TMP054->(!eof())	
		_cxml += alltrim(TMP054->XML_PROT)
	Endif
	
	TMP054->(dbclosearea())

	_cxml += '</nfeProc>'

	//Volta para conexão do Protheus
	TCSETCONN(_ndbprotheus) 

	//Desconecta conexão com o TSS
	TCUnlink(_ndbsped)

	//Salva string no arquivo
	nHandle := FCreate(cDirSrv + cDirCmp + cNomArq)
 
	If nHandle > 0
		FWrite(nHandle, _cxml)
		Fclose(nHandle)
	Endif

	cDirSrv	:= Lower( cDirSrv )
	cDirCmp := Lower( cDirCmp )
	cNomArq := Lower( cNomArq )

	cDirGrv	:= Lower( cDirGrv )

	If File( cDirSrv + cDirCmp + cNomArq)
		RecLock("SF2",.F.)
		SF2->F2_ZARQXML :=  cDirGrv + cDirCmp + cNomArq
		SF2->( msUnlock() )
		If SF2->F2_EMISSAO >= dDatIni
			
			_lRCTRC := SuperGetMV("MGF_FAT41J",.F., '.T.' )	// Habilita ou Não novas regras exceções RCTRC 
			
			If !_lRCTRC
				MGFFAT4101( cDirGrv + cDirCmp + cNomArq )
			Else	
				//Nova Regra de Exceções RCTRC
				MGFFAT4102( cDirGrv + cDirCmp + cNomArq )
			EndIf	
		
		EndIf
	EndIf

	// Executa funcao quando a raiz do cnpj do emitente for igual a raiz do cnpj do cliente
	// RTASK0010932-Wagner Neves
	If _lFat41X
		If SUBS(SA1->A1_CGC,1,8)==SUBS(SM0->M0_CGC,1,8) 
			cTmp02		:= GetNextAlias()
			_cCnpjCli := SA1->A1_CGC
			_cQuery := " SELECT M0_CODIGO,M0_CODFIL,M0_FILIAL FROM " + U_IF_BIMFR("PROTHEUS", "SYS_COMPANY"  ) + " WHERE D_E_L_E_T_ = ' ' AND M0_CGC='"+_cCnpjCli+"'"+CRLF
			If Select(cTmp02) > 0
				cTmp02->(dbCloseArea())
			EndIf
			dbusearea(.T.,"TOPCONN",TcGenQry(	,,_cQuery),cTmp02,.F.,.F.)			
			_cFilSx6   := Alltrim((cTmp02)->M0_CODFIL)
			_cDestLBat := Alltrim(GETMV("MGF_FIS54A"))
			_cDestLXml := Alltrim(GETMV("MGF_FIS54A"))+_cFilSx6+"\" 
			If SX6->(DbSeek(_cFilSx6+"MGF_FIS54B")	)
				_cDestino  := ALLTRIM(SX6->X6_CONTEUD)
			ENDI
			If !ExistDir( _cDestLXml )
				If MakeDir( _cDestLXml ) <> 0
					MsgAlert(  "Impossível criar diretorio ( "+_cDestLXml+" ) " )
					Return
				EndIf
			EndIf
			(cTmp02)->(DbCloseArea())

			nHandle := FCreate(_cDestLXml+cNomArq)
		    if nHandle = -1
        		conout("Erro ao criar arquivo - Erro " + Str(Ferror()))
    		else
	    	  	FWrite(nHandle, _cXml)
				Fclose(nHandle)
			Endif					
			_OrigemXml 	:= Alltrim(GETMV("MGF_FIS54C"))+_cFilSx6+"\"+cNomArq
			_cArqBat  	:= "F54"+StrZero(Seconds(),5,0)+".BAT"
			_OrigemBat  := Alltrim(GETMV("MGF_FIS54C"))+_cArqBat
    		_cCopy  	:= "XCOPY "+_OrigemXml+" "+_cDestino
    		MEMOWRITE(_OrigemBat, _cCopy )
    		inkey(.5)
			ShellExecute("open", _OrigemBat, "", _cDestino, 0)
    		inkey(.5)
    		FERASE(ALLTRIM(GETMV("MGF_FIS54C"))+_cArqBat)
			inkey(.5)
			FERASE(_OrigemXml)
		EndIf
	EndIf
Return

Static Function MGFFAT4101( cNomArq )

	Local lRet := .F.
	Local aArea := GetArea()
	Local cValnota := GetMV('MGF_VALAVE',,2000000)
	Local cPedido, cVeiculo, cPlaca
	Local lcfop		:= .T.
	Local cTN		:= GetMV('MGF_FATTN',,'TN')

	lcfop := U_BUSCACFOP() //função que verifica se existe dentro da Nota CFOP's para averbar

	If SF2->F2_TPFRETE == "C" .AND. SF2->F2_VALBRUT <= val(cValnota) .AND. lcfop == .T.

		dbSelectArea("DAI")
		dbSetOrder(3)

		If DAI->( dbSeek( xFilial("DAI")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) ) )
			dbSelectArea("ZBC")
			dbSetOrder(1) // ZBC_FILIAL+ZBC_CLIENT+ZBC_LJCLI

			If !ZBC->( dbSeek( xFilial("ZBC")+SF2->(F2_CLIENTE+F2_LOJA) ) )
				dbSetOrder(2) // ZBC_FILIAL+ZBC_DEST+ZBC_LJDEST

				If !ZBC->( dbSeek( xFilial("ZBC")+SF2->F2_CLIENT+SF2->F2_LOJENT ) )
					dbSetOrder(3) // ZBC_FILIAL + ZBC_CNPJTR

					If !SC5->C5_ZTIPPED $ cTN
	
						If MGFFAT41BP() //Verifica se tem pelo menos um produto averbável

							dbSelectArea("DA3")
							dbSetOrder(1)
							DA3->( dbSeek( xFilial("DA3")+SC5->C5_VEICULO ) )

							dbSelectArea("ZBC")
							
							If !ZBC->( dbSeek( xFilial("ZBC")+ SA4->A4_CGC ) )
									dbSetOrder(4) // ZBC_FILIAL+ZBC_PLACA

								If IIF(!Empty(DA3->DA3_PLACA),!ZBC->( dbSeek( xFilial("ZBC")+DA3->DA3_PLACA ) ),.T.)
									lRet := .T.

									dbSelectArea("ZBS")
									dbSetOrder(1) //ZBS->FILIAL+ZBS_NUM+ZBS_SERIE+ZBS_OPER
									If ZBS->( dbSeek( SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + "1" ) )
										RecLock("ZBS",.F.)
										ZBS->ZBS_ARQXML	:= cNomArq
	
									Else
					
										RecLock("ZBS",.T.)
										ZBS->ZBS_FILIAL	:= xFilial("ZBS")
										ZBS->ZBS_NUM	:= SF2->F2_DOC
										ZBS->ZBS_SERIE	:= SF2->F2_SERIE
										ZBS->ZBS_EMISS	:= SF2->F2_EMISSAO
										ZBS->ZBS_SITUAC	:= "N"
										ZBS->ZBS_VALTOT	:= SF2->F2_VALBRUT
										ZBS->ZBS_PEDIDO	:= DAI->DAI_PEDIDO
										ZBS->ZBS_OE		:= DAI->DAI_COD
										ZBS->ZBS_CODCLI	:= SF2->F2_CLIENTE
										ZBS->ZBS_LOJCLI	:= SF2->F2_LOJA
										ZBS->ZBS_NOMCLI	:= SA1->A1_NREDUZ
										ZBS->ZBS_UF		:= SF2->F2_EST
										ZBS->ZBS_CNPJ	:= SA1->A1_CGC
										ZBS->ZBS_TRANSP	:= SA4->A4_CGC // SF2->F2_TRANSP
										ZBS->ZBS_NOMTRN	:= SA4->A4_NOME
										ZBS->ZBS_STATUS	:= "N"
										ZBS->ZBS_ARQXML	:= cNomArq
										ZBS->ZBS_OPER := "1"

									Endif

									ZBS->( msUnlock() )

								EndIF

							EndIf

						Endif

					EndIf

				EndIf

			EndIf

		EndIf

		RestArea( aArea )

	EndIf

Return lRet

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFFAT4102()
Função Validar as Exceções RCTRC e Gravar dados na Tabela ZBS-SEGURO RCTRC

@author Rogério Doms
@since 08/09/2020 
@type Function 

@param 
    _cNomArq	- Caracter - Nome Arquivo XML

@return
    _lRet - Lógico - Verdadeiro ou Falso 
/*/
Static Function MGFFAT4102( _cNomArq )

	Local _aArea      := GetArea()
	Local _cTMPTAB    := GetNextAlias()		
	Local _cTMPZH7A   := GetNextAlias()		
	Local _cTMPZH7B   := GetNextAlias()		
	Local _cF2SERIE   := SF2->F2_SERIE
	Local _cF2DOC     := SF2->F2_DOC
	Local _cF2CLIENTE := SF2->F2_CLIENTE
	Local _cF2LOJA    := SF2->F2_LOJA
	Local _dZH7VIGATE := dDataBase
	Local _cZH7SITUAC := "1"	//Ativo
	Local _cZH7CODIGO := ""
	Local _cZH7TABELA := ""
	Local _cZH7EXPRES := ""
	Local _cQuery     := ""
	Local _lRet       := .T.

	//Valida Itens da Carga (DAI)
	DBSelectArea("DAI")
	DAI->( DBSetOrder(03) )
	If DAI->( DBSeek( xFilial("DAI") + SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) ) )

		//Filtra os Codigos das Exceções Tabela (ZH7)
		BeginSql Alias _cTMPZH7A

			COLUMN ZH7_VIGDE AS DATE
			COLUMN ZH7_VIGATE AS DATE

			SELECT DISTINCT ZH7_CODIGO, ZH7_DESCR, ZH7_VIGDE, ZH7_VIGATE, ZH7_SITUAC
			FROM %Table:ZH7% ZH7
			WHERE ZH7.%notdel%
			  AND ZH7.ZH7_VIGATE >= %Exp:DToS(_dZH7VIGATE)%
			  AND ZH7.ZH7_SITUAC = %Exp:_cZH7SITUAC%
			  ORDER BY ZH7_CODIGO

		EndSql

    	DBSelectArea(_cTMPZH7A)
    	(_cTMPZH7A)->( DBGoTop() )

		While (_cTMPZH7A)->( !Eof() )

			_cZH7CODIGO := (_cTMPZH7A)->ZH7_CODIGO

			//Filtra as Tabelas amarrada ao Codigo de Exceção Tabela (ZH7)
			BeginSql Alias _cTMPZH7B

				SELECT ZH7_ITEM, ZH7_TABELA, ZH7_NOME, ZH7_EXPRES
				FROM %Table:ZH7% ZH7
				WHERE ZH7.%notdel%
			  	AND ZH7.ZH7_CODIGO = %Exp:_cZH7CODIGO%
			  	ORDER BY ZH7_TABELA

			EndSql

    		DBSelectArea(_cTMPZH7B)
    		(_cTMPZH7B)->( DBGoTop() )

			While (_cTMPZH7B)->( !Eof() )

				_cZH7TABELA := Alltrim((_cTMPZH7B)->ZH7_TABELA)
				_cZH7EXPRES := AllTrim((_cTMPZH7B)->ZH7_EXPRES)
				
				//If At("'",_cZH7EXPRES,) == 0
				//	(_cTMPZH7B)->( DBSkip() )
				//	Loop
				//EndIf	
				
				_cZH7EXPRES := '%' + _cZH7EXPRES + '%'

				//Verifica Tabelas
				//SF2
				If _cZH7TABELA == "SF2"
					_lRet := FAT41_SF2(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)
				EndIf	

				//SD2
				If _cZH7TABELA == "SD2"
					_lRet := FAT41_SD2(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)
				EndIf

				//SA1
				If _cZH7TABELA == "SA1"
					_lRet := FAT41_SA1(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)
				EndIf

				//SA4
				If _cZH7TABELA == "SA4"
					_lRet := FAT41_SA4(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)
				EndIf

				//SB1
				If _cZH7TABELA == "SB1"
					_lRet := FAT41_SB1(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)
				EndIf

				//DAK
				If _cZH7TABELA == "DAK"
					_lRet := FAT41_DAK(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)
				EndIf

				//DAI
				If _cZH7TABELA == "DAI"
					_lRet := FAT41_DAI(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)
				EndIf

				//SC5	
				If _cZH7TABELA == "SC5"
					_lRet := FAT41_SC5(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)
				EndIf

				//DA3	
				If _cZH7TABELA == "DA3"
					_lRet := FAT41_DA3(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)
				EndIf

				//Se encontrou Exceção sai do Laço
				If !_lRet
					EXIT
				EndIf	

				(_cTMPZH7B)->( DBSkip() )

			EndDo

			(_cTMPZH7B)->( DBCloseArea() )

			//Se encontrou Exceção sai do Laço
			If !_lRet
				EXIT
			EndIf	

			(_cTMPZH7A)->( DBSkip() )

		EndDo
		
		(_cTMPZH7A)->( DBCloseArea() )

	EndIf

	//Grava Registro Tabela "ZBS-SEGURO RCTRC"	
	If _lRet

		DBSelectArea("ZBS")
		ZBS->( DBSetOrder(01) ) //ZBS->FILIAL + ZBS_NUM + ZBS_SERIE + ZBS_OPER
		If ZBS->( DBSeek( SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + "1" ) )
			RecLock("ZBS",.F.)
			ZBS->ZBS_ARQXML	:= _cNomArq
		Else
			RecLock("ZBS",.T.)
			ZBS->ZBS_FILIAL	:= xFilial("ZBS")
			ZBS->ZBS_NUM	:= SF2->F2_DOC
			ZBS->ZBS_SERIE	:= SF2->F2_SERIE
			ZBS->ZBS_EMISS	:= SF2->F2_EMISSAO
			ZBS->ZBS_SITUAC	:= "N"
			ZBS->ZBS_VALTOT	:= SF2->F2_VALBRUT
			ZBS->ZBS_PEDIDO	:= DAI->DAI_PEDIDO
			ZBS->ZBS_OE		:= DAI->DAI_COD
			ZBS->ZBS_CODCLI	:= SF2->F2_CLIENTE
			ZBS->ZBS_LOJCLI	:= SF2->F2_LOJA
			ZBS->ZBS_NOMCLI	:= SA1->A1_NREDUZ
			ZBS->ZBS_UF		:= SF2->F2_EST
			ZBS->ZBS_CNPJ	:= SA1->A1_CGC
			ZBS->ZBS_TRANSP	:= SA4->A4_CGC // SF2->F2_TRANSP
			ZBS->ZBS_NOMTRN	:= SA4->A4_NOME
			ZBS->ZBS_STATUS	:= "N"
			ZBS->ZBS_ARQXML	:= _cNomArq
			ZBS->ZBS_OPER   := "1"
		EndIf
		
		ZBS->( msUnlock() )

	Endif		
	
	RestArea( _aArea )
	
Return()

//-------------------------------------------------------------------
User Function MGFFT41T()

	Local cJson			:= ""
	Local cURLPost		:= GetMv("MGF_FAT41D",,"http://spdwvapl203:8088/averbacao/api/v0/AverbarNFSaida") 
	Local cCodInt		:= Alltrim(GetMv("MGF_FAT41E",,"001"))
	Local cTipInt		:= Alltrim(GetMv("MGF_FAT41F",,"001"))

	local oWSRCTRC	:= nil

	If Empty( cURLPost )
		Return
	EndIf

	Private oRCTRC		:= nil

	oRCTRC := nil
	oRCTRC := RCTRC():new()

	oRCTRC:SetRCTRC()

	cJson := fwJsonSerialize(oRCTRC, .F., .T.)
	oWSRCTRC := nil
	oWSRCTRC := MGFINT53():new(cURLPost, oRCTRC , ZBS->( Recno() ) , "ZBS" , "ZBS_ITAURA" , cCodInt , cTipInt , ZBS->(ZBS_FILIAL+ZBS_NUM+ZBS_SERIE),.F.,.F.,.T.,,,,.T. )
	oWSRCTRC:SendByHttpPost()

	If empty(alltrim(ZBS->ZBS_RETWS))
	
		Reclock("ZBS",.F.)
		ZBS->ZBS_RETWS := allTrim( str( oWSRCTRC:nStatuHttp ) ) + " - " + oWSRCTRC:cPostRet
		ZBS->(Msunlock())

	Endif


Return

/*
Classe de Transferencia (Movimentações)
*/
	Class RCTRC
//Data ApplicationArea	as ApplicationArea

		Data Filial						as String
		Data NumeroNotaFiscal			as String
		Data SerieNotaFiscal			as String
		Data CaminhoCompletoNotaFiscal	as String
		Data Reenvio                    as String

		Method New()
		Method SetRCTRC()
//return
	EndClass

/*
Construtor
*/
method New() class RCTRC
	//Self:ApplicationArea	:= ApplicationArea():new()
return

/*
Carrega o objeto
*/
Method SetRCTRC() Class RCTRC

	Self:Filial						:= AllTrim(ZBS->ZBS_FILIAL)
	Self:NumeroNotaFiscal			:= AllTrim(ZBS->ZBS_NUM)
	Self:SerieNotaFiscal			:= AllTrim(ZBS->ZBS_SERIE)
	Self:CaminhoCompletoNotaFiscal	:= AllTrim(ZBS->ZBS_ARQXML)
	IF ZBS->ZBS_STATUS == 'N' .AND. ZBS->ZBS_ITAURA=='I'
		Self:Reenvio	:= 'S'
	Else
		Self:Reenvio	:= 'N'
	EndIF

Return


User Function BUSCACFOP()

	Local lret 		:= .F.
	Local cQuery	:= ""
	Local cAliasSD2 := ""

	cAliasSD2 := GetNextAlias()

	cQuery := " SELECT D2_FILIAL FROM "
	cQuery +=  RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN " + RetSqlName("ZF0") + " ZF0 ON ZF0.D_E_L_E_T_= ' '  "
	cQuery += "   AND D2_CF = ZF0_CFOP "

	cQuery += " WHERE D2_FILIAL ='" + SF2->F2_FILIAL +"'"
	cQuery += "   AND D2_DOC = '" + SF2->F2_DOC + "'"
	cQuery += "   AND D2_CLIENTE = '" + SF2->F2_CLIENTE +"'"
	cQuery += "   AND D2_LOJA = '" + SF2->F2_LOJA +"'"
	cQuery += "	  AND SD2.D_E_L_E_T_ <> '*'"

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSD2, .F., .T.)

	If (cAliasSD2)->(!eof())
		lRet := .T.
	EndIf

Return lret

//-------------------------------------------------------------------
User Function MGFFT41V()

	Local cQuery	:= ""
	Local cValnota 
	Local cTN	   
	LOCAL cDATAINI 

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
	
	cValnota := Getmv('MGF_VALAVE')
	cTN		 := Getmv('MGF_FATTN')
	cDATAINI := Getmv('MGF_DVAVE')	

	cQuery := " SELECT DISTINCT F2.F2_FILIAL ,"			+CRLF
	cQuery += " F2.F2_DOC ,"							+CRLF
	cQuery += " F2.F2_SERIE,"							+CRLF
	cQuery += " F2.F2_EMISSAO,"							+CRLF
	cQuery += " F2.F2_VALBRUT,"							+CRLF
	cQuery += " DAI.DAI_PEDIDO,"						+CRLF
	cQuery += " DAI.DAI_COD,"							+CRLF
	cQuery += " F2.F2_CLIENTE,"							+CRLF
	cQuery += " F2.F2_LOJA,"							+CRLF
	cQuery += " A1.A1_NREDUZ,"							+CRLF
	cQuery += " F2.F2_EST,"								+CRLF
	cQuery += " A1.A1_CGC,"								+CRLF
	cQuery += " A4.A4_CGC,"								+CRLF
	cQuery += " A4.A4_NOME,"							+CRLF
	cQuery += " F2.F2_ZARQXML"							+CRLF
	cQuery += " FROM "+retSQLName("SF2")+" F2"			+CRLF
	cQuery += " JOIN "+retSQLName("SD2")+" D2"			+CRLF
	cQuery += " ON F2.F2_FILIAL = D2.D2_FILIAL"			+CRLF
	cQuery += " AND F2.F2_DOC = D2.D2_DOC"				+CRLF
	cQuery += " AND F2.F2_CLIENTE =D2.D2_CLIENTE"		+CRLF
	cQuery += " AND F2.F2_LOJA =D2.D2_LOJA"				+CRLF
	cQuery += " AND D2.D_E_L_E_T_ <>'*'"				+CRLF
	cQuery += " JOIN "+retSQLName("DAI")+" DAI"			+CRLF
	cQuery += " ON DAI.DAI_FILIAL=F2.F2_FILIAL"			+CRLF
	cQuery += " AND DAI.DAI_NFISCA=F2.F2_DOC"			+CRLF
	cQuery += " AND DAI.DAI_SERIE=F2.F2_SERIE"			+CRLF
	cQuery += " AND DAI.DAI_CLIENT=F2.F2_CLIENTE"		+CRLF
	cQuery += " AND DAI.DAI_LOJA = F2.F2_LOJA"			+CRLF
	cQuery += " AND DAI.D_E_L_E_T_<>'*'"				+CRLF
	cQuery += " LEFT JOIN "+retSQLName("SA1")+" A1"		+CRLF
	cQuery += " ON A1.A1_COD = F2.F2_CLIENTE"			+CRLF
	cQuery += " AND A1.A1_LOJA = F2.F2_LOJA"			+CRLF
	cQuery += " AND A1.D_E_L_E_T_<>'*'"					+CRLF
	cQuery += " LEFT JOIN "+retSQLName("SC5")+" C5"		+CRLF
	cQuery += " ON C5.C5_FILIAL = D2.D2_FILIAL"			+CRLF
	cQuery += " AND C5.C5_NUM = D2.D2_PEDIDO"			+CRLF
	cQuery += " AND C5.D_E_L_E_T_<>'*'"					+CRLF
	cQuery += " LEFT JOIN "+retSQLName("ZBC")+" BC"		+CRLF
	cQuery += " ON BC.ZBC_FILIAL =' '"					+CRLF
	cQuery += " AND BC.ZBC_CLIENT =F2.F2_CLIENTE"		+CRLF
	cQuery += " AND BC.ZBC_LJCLI = F2.F2_LOJA"			+CRLF
	cQuery += " AND BC.D_E_L_E_T_<>'*'"					+CRLF
	cQuery += " LEFT JOIN "+retSQLName("ZBC")+" BC1"	+CRLF
	cQuery += " ON BC1.ZBC_DEST = C5_CLIENT"			+CRLF
	cQuery += " AND BC1.ZBC_LJDEST = C5_LOJAENT"		+CRLF
	cQuery += " AND BC1.D_E_L_E_T_<>'*'"				+CRLF
	cQuery += " LEFT JOIN "+retSQLName("ZBC")+" BC2"	+CRLF
	cQuery += " ON BC2.ZBC_PLACA = F2.F2_VEICUL1"		+CRLF
	cQuery += " AND BC2.D_E_L_E_T_<>'*'"				+CRLF
	cQuery += " LEFT JOIN "+retSQLName("SA4")+" A4"		+CRLF
	cQuery += " ON A4.A4_COD = F2.F2_TRANSP"			+CRLF
	cQuery += " AND A4.D_E_L_E_T_<>'*'"					+CRLF
	cQuery += " LEFT JOIN "+retSQLName("ZBC")+" BC3"	+CRLF
	cQuery += " ON BC3.ZBC_CNPJTR= A4.A4_CGC"			+CRLF
	cQuery += " AND BC3.D_E_L_E_T_<>'*'"				+CRLF
	cQuery += " LEFT JOIN "+retSQLName("SB1")+" B1"		+CRLF
	cQuery += " ON B1.B1_COD = D2.D2_COD"				+CRLF
	cQuery += " AND B1.D_E_L_E_T_<>'*'"					+CRLF
	cQuery += " LEFT JOIN "+retSQLName("ZF0")+" ZF"		+CRLF
	cQuery += " ON ZF.ZF0_CFOP= D2.D2_CF"				+CRLF
	cQuery += " AND ZF.D_E_L_E_T_<>'*'"					+CRLF
	cQuery += " LEFT JOIN "+retSQLName("ZBS")+" ZBS"	+CRLF
	cQuery += " ON F2.F2_FILIAL = ZBS.ZBS_FILIAL"		+CRLF
	cQuery += " AND F2.F2_DOC =  ZBS.ZBS_NUM"			+CRLF
	cQuery += " AND F2.F2_SERIE =  ZBS.ZBS_SERIE"		+CRLF
	cQuery += " AND F2.F2_CLIENTE = ZBS.ZBS_CODCLI"		+CRLF
	cQuery += " AND F2.F2_LOJA = ZBS_LOJCLI"			+CRLF
	cQuery += " AND ZBS.D_E_L_E_T_<>'*'"				+CRLF
	cQuery += " WHERE "									+CRLF
	cQuery += " F2.D_E_L_E_T_<>'*'"						+CRLF
	cQuery += " AND F2.F2_ZARQXML <> ' '"				+CRLF
	cQuery += " AND F2.F2_TPFRETE= 'C'"					+CRLF
	cQuery += " AND ZF.ZF0_CFOP IS NOT NULL"			+CRLF
	cQuery += " AND C5.C5_TRANSP<> ' '"					+CRLF
	cQuery += " AND C5.C5_ZTIPPED NOT IN "+cTN 			+CRLF
	cQuery += " AND BC.ZBC_CLIENT IS NULL"				+CRLF
	cQuery += " AND BC1.ZBC_DEST IS NULL"				+CRLF
	cQuery += " And BC2.ZBC_PLACA IS NULL"				+CRLF
	cQuery += " and BC3.ZBC_CNPJTR IS NULL"				+CRLF
	cQuery += " AND ZBS.ZBS_NUM IS NULL"				+CRLF
	cQuery += " AND F2.F2_EMISSAO > '"+cDATAINI+"'"		+CRLF
	cQuery += " and F2.F2_VALBRUT <="+cValnota			+CRLF
		
	IF SELECT("qZBS") > 0
		qZBS->(dbCloseArea())
	ENDIF
	TcQuery changeQuery(cQuery) New Alias "qZBS"

	WHILE qZBS->(!eof())
	
		dbSelectArea("ZBS")
		dbSetOrder(1) //ZBS->FILIAL+ZBS_NUM+ZBS_SERIE+ZBS_OPER
		If ZBS->( dbSeek( qZBS->F2_FILIAL + qZBS->F2_DOC + qZBS->F2_SERIE + "1" ) )
			RecLock("ZBS",.F.)
		Else
			RecLock("ZBS",.T.)
		Endif

		ZBS->ZBS_FILIAL	:= qZBS->F2_FILIAL
		ZBS->ZBS_NUM	:= qZBS->F2_DOC
		ZBS->ZBS_SERIE	:= qZBS->F2_SERIE
		ZBS->ZBS_EMISS	:= sTOD(qZBS->F2_EMISSAO)
		ZBS->ZBS_SITUAC	:= "N"
		ZBS->ZBS_VALTOT	:= qZBS->F2_VALBRUT
		ZBS->ZBS_PEDIDO	:= qZBS->DAI_PEDIDO
		ZBS->ZBS_OE		:= qZBS->DAI_COD
		ZBS->ZBS_CODCLI	:= qZBS->F2_CLIENTE
		ZBS->ZBS_LOJCLI	:= qZBS->F2_LOJA
		ZBS->ZBS_NOMCLI	:= qZBS->A1_NREDUZ
		ZBS->ZBS_UF		:= qZBS->F2_EST
		ZBS->ZBS_CNPJ	:= qZBS->A1_CGC
		ZBS->ZBS_TRANSP	:= qZBS->A4_CGC 
		ZBS->ZBS_NOMTRN	:= qZBS->A4_NOME
		ZBS->ZBS_STATUS	:= "N"
		ZBS->ZBS_ARQXML	:= qZBS->F2_ZARQXML
		ZBS->ZBS_OPER	:= "1"
		ZBS->( msUnlock() )
		CONOUT( 'filial:'+qZBS->F2_FILIAL+' - Nota/serie:'+qZBS->F2_DOC+'/'+qZBS->F2_SERIE+' - inserido:'+dtoc(DATE())+' - '+time())
		qZBS->(DBSKIP())
	ENDDO
	IF SELECT("qZBS") > 0
		qZBS->( dbCloseArea() )
	ENDIF

Return


Static Function MGFFAT41BP()

Local _lret := .F.
Local _cliga := getmv("MGFFAT41LFP",,.F.)

If _cliga

	//Verifica se tem produto averbável na nota
	cAliasSD2A := GetNextAlias()

	cQuery := " SELECT D2_FILIAL FROM "
	cQuery +=  RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_= ' '  "
	cQuery += "   AND D2_COD = B1_COD "

	cQuery += " WHERE D2_FILIAL ='" + SF2->F2_FILIAL +"'"
	cQuery += "   AND D2_DOC = '" + SF2->F2_DOC + "'"
	cquery += "   AND NOT (B1_GRUPO IN " +  FORMATIN(GETMV(MGFFAT41PNA,,"")) + ")" 
	cQuery += "	  AND SD2.D_E_L_E_T_ <> '*'"

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSD2, .F., .T.)

	If (cAliasSD2)->(!eof())
		lRet := .T.
	EndIf

else
	
	_lret := .T.

Endif

Return _lret


/*/
==============================================================================================================================================================================
{Protheus.doc} FAT41_SF2()
Função Filtra Exceção RCTRC na Tabela SF2-Cabeçalho Nota Fiscal Saida

@author Rogério Doms
@since 08/09/2020 
@type Function 

@param 
    _cTMPTAB	- Caracter - Nome da Tabela Temporaria
	_cF2SERIE	- Caracter - Serie da Nota Fiscal de Saida
	_cF2DOC		- Caracter - Numero da Nota Fiscal de Saida
	_cF2CLIENTE	- Caracter - Código do Cliente
	_cF2LOJA	- Caracter - Código da Loja do Cliente
	_cZH7EXPRES	- Caracter - Expressão com a Regra da Exceção do RCTRC na Tabela ZH7-Tabela de Exeções

@return
    _lRet - Lógico - Verdadeiro ou Falso 
/*/
Static Function FAT41_SF2(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)

	Local _lRet := .T.

	BeginSql Alias _cTMPTAB

		SELECT * 
  		FROM  %Table:DAI% DAI
		INNER JOIN %Table:SF2% SF2  
		   ON SF2.%notdel%
          AND F2_FILIAL = DAI_FILIAL
          AND F2_DOC =DAI_NFISCA
          AND F2_SERIE = DAI_SERIE
		  AND F2_CLIENTE = DAI_CLIENT
		  AND F2_LOJA = DAI_LOJA
          AND %Exp:AllTrim(_cZH7EXPRES)%
        WHERE DAI.%notdel%
          AND DAI_FILIAL = %Exp:xFILIAL("DAI")%
          AND DAI_NFISCA = %Exp:_cF2DOC%
		  AND DAI_SERIE = %Exp:_cF2SERIE%
		  AND DAI_CLIENT = %Exp:_cF2CLIENTE%
		  AND DAI_LOJA = %Exp:_cF2LOJA%

	EndSql

	DBSelectArea(_cTMPTAB)
	If (_cTMPTAB)->( !Eof() )
		_lRet := .F.
	EndIf

	(_cTMPTAB)->( DBCloseArea() )				

Return(_lRet)

/*/
==============================================================================================================================================================================
{Protheus.doc} FAT41_SD2()
Função Filtra Exceção RCTRC na Tabela SD2-Itens Nota Fiscal Saida

@author Rogério Doms
@since 08/09/2020 
@type Function 

@param 
    _cTMPTAB	- Caracter - Nome da Tabela Temporaria
	_cF2SERIE	- Caracter - Serie da Nota Fiscal de Saida
	_cF2DOC		- Caracter - Numero da Nota Fiscal de Saida
	_cF2CLIENTE	- Caracter - Código do Cliente
	_cF2LOJA	- Caracter - Código da Loja do Cliente
	_cZH7EXPRES	- Caracter - Expressão com a Regra da Exceção do RCTRC na Tabela ZH7-Tabela de Exeções

@return
    _lRet - Lógico - Verdadeiro ou Falso 
/*/
Static Function FAT41_SD2(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)

	Local _lRet := .T.

	BeginSql Alias _cTMPTAB

		SELECT * 
  		FROM  %Table:DAI% DAI
		INNER JOIN %Table:SD2% SD2  
		   ON SD2.%notdel%
          AND D2_FILIAL = DAI_FILIAL
          AND D2_DOC = DAI_NFISCA
          AND D2_SERIE = DAI_SERIE
		  AND D2_CLIENTE = DAI_CLIENT
		  AND D2_LOJA = DAI_LOJA
		  AND %Exp:AllTrim(_cZH7EXPRES)%
        WHERE DAI.%notdel%
          AND DAI_FILIAL = %Exp:xFILIAL("DAI")%
          AND DAI_NFISCA = %Exp:_cF2DOC%
		  AND DAI_SERIE = %Exp:_cF2SERIE%
		  AND DAI_CLIENT = %Exp:_cF2CLIENTE%
		  AND DAI_LOJA = %Exp:_cF2LOJA%

	EndSql

	DBSelectArea(_cTMPTAB)
	If (_cTMPTAB)->( !Eof() )
		_lRet := .F.
	EndIf

	(_cTMPTAB)->( DBCloseArea() )				

Return(_lRet)

/*/
==============================================================================================================================================================================
{Protheus.doc} FAT41_SA1()
Função Filtra Exceção RCTRC na Tabela SA1-Cadastro de Clientes

@author Rogério Doms
@since 08/09/2020 
@type Function 

@param 
    _cTMPTAB	- Caracter - Nome da Tabela Temporaria
	_cF2SERIE	- Caracter - Serie da Nota Fiscal de Saida
	_cF2DOC		- Caracter - Numero da Nota Fiscal de Saida
	_cF2CLIENTE	- Caracter - Código do Cliente
	_cF2LOJA	- Caracter - Código da Loja do Cliente
	_cZH7EXPRES	- Caracter - Expressão com a Regra da Exceção do RCTRC na Tabela ZH7-Tabela de Exeções

@return
    _lRet - Lógico - Verdadeiro ou Falso 
/*/
Static Function FAT41_SA1(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)

	Local _lRet := .T.

	BeginSql Alias _cTMPTAB

		SELECT * 
  		FROM  %Table:DAI% DAI
		INNER JOIN %Table:SA1% SA1  
		   ON SA1.%notdel%
		  AND A1_COD = DAI_CLIENT
		  AND A1_LOJA = DAI_LOJA
		  AND %Exp:AllTrim(_cZH7EXPRES)%
        WHERE DAI.%notdel%
          AND DAI_FILIAL = %Exp:xFILIAL("DAI")%
          AND DAI_NFISCA = %Exp:_cF2DOC%
		  AND DAI_SERIE = %Exp:_cF2SERIE%
		  AND DAI_CLIENT = %Exp:_cF2CLIENTE%
		  AND DAI_LOJA = %Exp:_cF2LOJA%

	EndSql

	DBSelectArea(_cTMPTAB)
	If (_cTMPTAB)->( !Eof() )
		_lRet := .F.
	EndIf

	(_cTMPTAB)->( DBCloseArea() )				

Return(_lRet)

/*/
==============================================================================================================================================================================
{Protheus.doc} FAT41_SA4()
Função Filtra Exceção RCTRC na Tabela SA4-Tabela de Transportadoras

@author Rogério Doms
@since 08/09/2020 
@type Function 

@param 
    _cTMPTAB	- Caracter - Nome da Tabela Temporaria
	_cF2SERIE	- Caracter - Serie da Nota Fiscal de Saida
	_cF2DOC		- Caracter - Numero da Nota Fiscal de Saida
	_cF2CLIENTE	- Caracter - Código do Cliente
	_cF2LOJA	- Caracter - Código da Loja do Cliente
	_cZH7EXPRES	- Caracter - Expressão com a Regra da Exceção do RCTRC na Tabela ZH7-Tabela de Exeções

@return
    _lRet - Lógico - Verdadeiro ou Falso 
/*/
Static Function FAT41_SA4(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)

	Local _lRet := .T.

	BeginSql Alias _cTMPTAB

		SELECT * 
  		FROM  %Table:DAI% DAI
		INNER JOIN %Table:SF2% SF2  
		   ON SF2.%notdel%
          AND F2_FILIAL = DAI_FILIAL
          AND F2_DOC = DAI_NFISCA
          AND F2_SERIE = DAI_SERIE
		  AND F2_CLIENTE = DAI_CLIENT
		  AND F2_LOJA = DAI_LOJA
		INNER JOIN %Table:SA4% SA4
		   ON SA4.%notdel%
		  AND A4_COD = F2_TRANSP
		  AND %Exp:AllTrim(_cZH7EXPRES)%
        WHERE DAI.%notdel%
          AND DAI_FILIAL = %Exp:xFILIAL("DAI")%
          AND DAI_NFISCA = %Exp:_cF2DOC%
		  AND DAI_SERIE = %Exp:_cF2SERIE%
		  AND DAI_CLIENT = %Exp:_cF2CLIENTE%
		  AND DAI_LOJA = %Exp:_cF2LOJA%

	EndSql

	DBSelectArea(_cTMPTAB)
	If (_cTMPTAB)->( !Eof() )
		_lRet := .F.
	EndIf

	(_cTMPTAB)->( DBCloseArea() )				

Return(_lRet)

/*/
==============================================================================================================================================================================
{Protheus.doc} FAT41_SB1()
Função Filtra Exceção RCTRC na Tabela SB1-Tabela de Produtos

@author Rogério Doms
@since 08/09/2020 
@type Function 

@param 
    _cTMPTAB	- Caracter - Nome da Tabela Temporaria
	_cF2SERIE	- Caracter - Serie da Nota Fiscal de Saida
	_cF2DOC		- Caracter - Numero da Nota Fiscal de Saida
	_cF2CLIENTE	- Caracter - Código do Cliente
	_cF2LOJA	- Caracter - Código da Loja do Cliente
	_cZH7EXPRES	- Caracter - Expressão com a Regra da Exceção do RCTRC na Tabela ZH7-Tabela de Exeções

@return
    _lRet - Lógico - Verdadeiro ou Falso 
/*/
Static Function FAT41_SB1(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)

	Local _lRet := .T.

	BeginSql Alias _cTMPTAB

		SELECT * 
  		FROM  %Table:DAI% DAI
		INNER JOIN %Table:SD2% SD2  
		   ON SD2.%notdel%
          AND D2_FILIAL = DAI_FILIAL 
          AND D2_DOC = DAI_NFISCA
          AND D2_SERIE = DAI_SERIE
		  AND D2_CLIENTE = DAI_CLIENT
		  AND D2_LOJA = DAI_LOJA
		INNER JOIN %Table:SB1% SB1
		   ON SB1.%notdel%
		  AND B1_COD = D2_COD
		  AND %Exp:AllTrim(_cZH7EXPRES)%
        WHERE DAI.%notdel%
          AND DAI_FILIAL = %Exp:xFILIAL("DAI")%
          AND DAI_NFISCA = %Exp:_cF2DOC%
		  AND DAI_SERIE = %Exp:_cF2SERIE%
		  AND DAI_CLIENT = %Exp:_cF2CLIENTE%
		  AND DAI_LOJA = %Exp:_cF2LOJA%

	EndSql

	DBSelectArea(_cTMPTAB)
	If (_cTMPTAB)->( !Eof() )
		_lRet := .F.
	EndIf

	(_cTMPTAB)->( DBCloseArea() )				

Return(_lRet)

/*/
==============================================================================================================================================================================
{Protheus.doc} FAT41_DAK()
Função Filtra Exceção RCTRC na Tabela DAK-Tabela Carga

@author Rogério Doms
@since 08/09/2020 
@type Function 

@param 
    _cTMPTAB	- Caracter - Nome da Tabela Temporaria
	_cF2SERIE	- Caracter - Serie da Nota Fiscal de Saida
	_cF2DOC		- Caracter - Numero da Nota Fiscal de Saida
	_cF2CLIENTE	- Caracter - Código do Cliente
	_cF2LOJA	- Caracter - Código da Loja do Cliente
	_cZH7EXPRES	- Caracter - Expressão com a Regra da Exceção do RCTRC na Tabela ZH7-Tabela de Exeções

@return
    _lRet - Lógico - Verdadeiro ou Falso 
/*/
Static Function FAT41_DAK(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)

	Local _lRet := .T.

	BeginSql Alias _cTMPTAB

		SELECT * 
  		FROM  %Table:DAI% DAI
		INNER JOIN %Table:DAK% DAK  
		   ON DAK.%notdel%
          AND DAK_FILIAL = DAI_FILIAL
          AND DAK_COD = DAI_COD
          AND DAK_SEQCAR = DAI_SEQCAR
          AND %Exp:AllTrim(_cZH7EXPRES)%
        WHERE DAI.%notdel%
          AND DAI_FILIAL = %Exp:xFILIAL("DAI")%
          AND DAI_NFISCA = %Exp:_cF2DOC%
		  AND DAI_SERIE = %Exp:_cF2SERIE%
		  AND DAI_CLIENT = %Exp:_cF2CLIENTE%
		  AND DAI_LOJA = %Exp:_cF2LOJA%

	EndSql

	DBSelectArea(_cTMPTAB)
	If (_cTMPTAB)->( !Eof() )
		_lRet := .F.
	EndIf

	(_cTMPTAB)->( DBCloseArea() )				

Return(_lRet)


/*/
==============================================================================================================================================================================
{Protheus.doc} FAT41_DAI()
Função Filtra Exceção RCTRC na Tabela DAI-Tabela de Itens da Carga

@author Rogério Doms
@since 08/09/2020 
@type Function 

@param 
    _cTMPTAB	- Caracter - Nome da Tabela Temporaria
	_cF2SERIE	- Caracter - Serie da Nota Fiscal de Saida
	_cF2DOC		- Caracter - Numero da Nota Fiscal de Saida
	_cF2CLIENTE	- Caracter - Código do Cliente
	_cF2LOJA	- Caracter - Código da Loja do Cliente
	_cZH7EXPRES	- Caracter - Expressão com a Regra da Exceção do RCTRC na Tabela ZH7-Tabela de Exeções

@return
    _lRet - Lógico - Verdadeiro ou Falso 
/*/
Static Function FAT41_DAI(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)

	Local _lRet := .T.

	BeginSql Alias _cTMPTAB

		SELECT *
		FROM %Table:SF2% SF2
		INNER JOIN %Table:DAI% DAI
		   ON DAI.%notdel%
		  AND DAI_FILIAL=F2_FILIAL 
		  AND DAI_SERIE = F2_SERIE
		  AND DAI_NFISCA = F2_DOC
		  AND DAI_CLIENT = F2_CLIENTE
		  AND DAI_LOJA = F2_LOJA
		  AND %Exp:AllTrim(_cZH7EXPRES)%
		WHERE SF2.%notdel%
          AND F2_FILIAL = %Exp:xFILIAL("SF2")%
		  AND F2_SERIE = %Exp:_cF2SERIE%
		  AND F2_DOC = %Exp:_cF2DOC%
		  AND F2_CLIENTE = %Exp:_cF2CLIENTE%
		  AND F2_LOJA = %Exp:_cF2LOJA%

	EndSql

	DBSelectArea(_cTMPTAB)
	If (_cTMPTAB)->( !Eof() )
		_lRet := .F.
	EndIf

	(_cTMPTAB)->( DBCloseArea() )				

Return(_lRet)

/*/
==============================================================================================================================================================================
{Protheus.doc} FAT41_SC5()
Função Filtra Exceção RCTRC na Tabela SC5-Tabela Pedidos de Venda

@author Rogério Doms
@since 08/09/2020 
@type Function 

@param 
    _cTMPTAB	- Caracter - Nome da Tabela Temporaria
	_cF2SERIE	- Caracter - Serie da Nota Fiscal de Saida
	_cF2DOC		- Caracter - Numero da Nota Fiscal de Saida
	_cF2CLIENTE	- Caracter - Código do Cliente
	_cF2LOJA	- Caracter - Código da Loja do Cliente
	_cZH7EXPRES	- Caracter - Expressão com a Regra da Exceção do RCTRC na Tabela ZH7-Tabela de Exeções

@return
    _lRet - Lógico - Verdadeiro ou Falso 
/*/
Static Function FAT41_SC5(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)

	Local _lRet := .T.

	BeginSql Alias _cTMPTAB

		SELECT * 
  		FROM  %Table:DAI% DAI
		INNER JOIN %Table:SC5% SC5
		   ON SC5.%notdel%
		  AND C5_FILIAL = DAI_FILIAL
		  AND C5_NUM = DAI_PEDIDO
		  AND %Exp:AllTrim(_cZH7EXPRES)%
        WHERE DAI.%notdel%
          AND DAI_FILIAL = %Exp:xFILIAL("DAI")%
          AND DAI_NFISCA = %Exp:_cF2DOC%
		  AND DAI_SERIE = %Exp:_cF2SERIE%
		  AND DAI_CLIENT = %Exp:_cF2CLIENTE%
		  AND DAI_LOJA = %Exp:_cF2LOJA%

	EndSql

	DBSelectArea(_cTMPTAB)
	If (_cTMPTAB)->( !Eof() )
		_lRet := .F.
	EndIf

	(_cTMPTAB)->( DBCloseArea() )				

Return(_lRet)

/*/
==============================================================================================================================================================================
{Protheus.doc} FAT41_DA3()
Função Filtra Exceção RCTRC na Tabela DA3-Tabela de Veiculos

@author Rogério Doms
@since 08/09/2020 
@type Function 

@param 
    _cTMPTAB	- Caracter - Nome da Tabela Temporaria
	_cF2SERIE	- Caracter - Serie da Nota Fiscal de Saida
	_cF2DOC		- Caracter - Numero da Nota Fiscal de Saida
	_cF2CLIENTE	- Caracter - Código do Cliente
	_cF2LOJA	- Caracter - Código da Loja do Cliente
	_cZH7EXPRES	- Caracter - Expressão com a Regra da Exceção do RCTRC na Tabela ZH7-Tabela de Exeções

@return
    _lRet - Lógico - Verdadeiro ou Falso 
/*/
Static Function FAT41_DA3(_cTMPTAB,_cF2SERIE,_cF2DOC,_cF2CLIENTE,_cF2LOJA,_cZH7EXPRES)

	Local _lRet := .T.

	BeginSql Alias _cTMPTAB

		SELECT * 
  		FROM  %Table:DAI% DAI
		INNER JOIN %Table:SC5% SC5
		   ON SC5.%notdel%
		  AND C5_FILIAL = DAI_FILIAL
		  AND C5_NUM = DAI_PEDIDO
		INNER JOIN %Table:DA3% DA3
		   ON DA3.%notdel%
		  AND DA3_COD = C5_VEICULO
		  AND %Exp:AllTrim(_cZH7EXPRES)%
        WHERE DAI.%notdel%
          AND DAI_FILIAL = %Exp:xFILIAL("DAI")%
          AND DAI_NFISCA = %Exp:_cF2DOC%
		  AND DAI_SERIE = %Exp:_cF2SERIE%
		  AND DAI_CLIENT = %Exp:_cF2CLIENTE%
		  AND DAI_LOJA = %Exp:_cF2LOJA%

	EndSql

	DBSelectArea(_cTMPTAB)
	If (_cTMPTAB)->( !Eof() )
		_lRet := .F.
	EndIf

	(_cTMPTAB)->( DBCloseArea() )				

Return(_lRet)

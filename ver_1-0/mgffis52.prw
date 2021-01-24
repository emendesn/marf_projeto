#INCLUDE "SPEDNFE.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} MGFFIS52
Importação dos XML oriundo do SEFAZ

@author Paulo da Mata
@since 03/12/2019
@version P12.1.17
@return Nil

@author Wagner Neves
@PRB0040992 - AJUSTE ROTINA DE EXPORTAÇÃO XML
@17/09/2020

/*/

User Function MGFFIS52()

	Local aPerg   	 := {}
	Local aParam  	 := {Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),Space(100),CToD(""),CToD(""),Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_SERIE)),Space(14),Space(14)}
	Local lObrigaF   := .F.
	Local lObrigaT   := .T.

	AADD(aPerg,{1,"Nota fiscal inicial",aParam[01],"",".T.","",".T.",30,lObrigaf})
	AADD(aPerg,{1,"Nota fiscal final",aParam[02],"",".T.","",".T.",30,lObrigat})
	AADD(aPerg,{6,"Diretório de destino",aParam[03],"",".T.","!Empty(mv_par04)",80,.T.," |*.","c:\",GETF_RETDIRECTORY+GETF_LOCALHARD,.F.})
	AADD(aPerg,{1,"Data Inicial",aParam[04],"",".T.","",".T.",50,lObrigaf})
	AADD(aPerg,{1,"Data Final",aParam[05],"",".T.","",".T.",50,lObrigat})
	AADD(aPerg,{1,"Série inicial",aParam[06],"",".T.","",".T.",20,lObrigaf})
	AADD(aPerg,{1,"Série final",aParam[07],"",".T.","",".T.",20,lObrigat})

	If ParamBox(aPerg,"SPED - NFe - Exportador XML",@aParam,,,,,,,,.T.,.T.)
		fwmsgrun(,{|oproc| fGerXML(aParam[01],aParam[02],aParam[03],aParam[04],aParam[05],aParam[06],aParam[07],oproc) },;
			"Aguarde...","Selecionando registros de acordo com os parâmetros informados...")
	EndIf

Return

/*/{Protheus.doc} FGERXML
Efetua a Importação dos XML oriundo do SEFAZ

@author Paulo da Mata
@since 03/12/2019
@version P12.1.17
@return Nil
/*/

Static Function fGerXML(cNotaIni,cNotaFim,cArquivo,dDataDe,dDataAte,cSerDe,cSerAte,oproc)

	Local cQuery  		:= ""
	Local cArqXml 		:= ""
	Local n		  		:= 0
	Local i		  		:= 0
	Local cAcesDb       := GetMv("MGF_FAT41G",,"ORACLE/SPED")  // Acesso ao Oracle
	Local cSrvDba       := GetMv("MGF_FAT41H",,"SPDWVAPL228F") // Acesso Servidor do DbAcess
	Local nPortDb       := GetMv("MGF_FAT41I",,7885)
	Local _cCodFilial   := cFilAnt
	Local _aSelFil		:= {}
	Local _aNotas 		:= {}
	Local _aRetorno 	:= {}
	Local nI 			:= 0
	Local _cControl 	:= 0

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecão das FILIAIS a processar e as armazena na array _aSelFil
	If Empty(_aSelFil) ; Return ; Endif
		_cCodFilial	:= U_Array_In(_aSelFil)

		If Select("CNTSF2") > 0
			dbSelectArea("CNTSF2")
			dbCloseArea()
		EndIf

		// Efetua a contagem  dos registros a processar
		cQuery := "SELECT COUNT(*) AS TOT "+CRLF
		cQuery += "FROM "+RetSqlName("SF2")+" "+CRLF
		cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
		cQuery += "AND F2_CHVNFE <> ' ' "+CRLF
		cQuery += "AND F2_DOC BETWEEN '"+cNotaIni+"' AND '"+cNotaFim+"' "+CRLF
		cQuery += "AND F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "+CRLF
		cQuery += "AND F2_SERIE BETWEEN '"+cSerDe+"' AND '"+cSerAte+"' "+CRLF
		cQuery += "AND F2_FILIAL IN"+_cCodFilial +" "+CRLF
		cQuery += "UNION ALL" +CRLF
		cQuery += "SELECT COUNT(*) AS TOT "+CRLF
		cQuery += "FROM "+RetSqlName("SF1")+" "+CRLF
		cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
		cQuery += "AND F1_CHVNFE <> ' ' "+CRLF
		cQuery += "AND F1_DOC BETWEEN '"+cNotaIni+"' AND '"+cNotaFim+"' "+CRLF
		cQuery += "AND F1_FORMUL = 'S' "+CRLF
		cQuery += "AND F1_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "+CRLF
		cQuery += "AND F1_SERIE BETWEEN '"+cSerDe+"' AND '"+cSerAte+"' "+CRLF
		cQuery += "AND F1_FILIAL IN"+_cCodFilial

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"CNTSF2", .F., .T.)

		CNTSF2->(dbgotop())
		While ! CNTSF2->(Eof())
			i += CNTSF2->TOT
			CNTSF2->(dbskip())
		EndDo

		IF i = 0
			MsgInfo("Nenhuma nota foi selecionada. Favor verificar os parâmetros !!!","Atenção !!!")
			Return
		Endif

		If Select("TMPSF2") > 0
			dbSelectArea("TMPSF2")
			dbCloseArea()
		EndIf

		// Cria a query para a busca de todas as notas, a partir do SF2010
		cQuery := "SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_CHVNFE, R_E_C_N_O_ "+CRLF
		cQuery += "FROM "+RetSqlName("SF2")+" "+CRLF
		cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
		cQuery += "AND F2_CHVNFE <> ' ' "+CRLF
		cQuery += "AND F2_DOC BETWEEN '"+cNotaIni+"' AND '"+cNotaFim+"' "+CRLF
		cQuery += "AND F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "+CRLF
		cQuery += "AND F2_SERIE BETWEEN '"+cSerDe+"' AND '"+cSerAte+"' "+CRLF
		cQuery += "AND F2_FILIAL IN"+_cCodFilial+" "+CRLF
		cQuery += "UNION ALL "+CRLF
		cQuery += "SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_EMISSAO,F1_CHVNFE, R_E_C_N_O_ "+CRLF
		cQuery += "FROM "+RetSqlName("SF1")+" "+CRLF
		cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
		cQuery += "AND F1_CHVNFE <> ' ' "+CRLF
		cQuery += "AND F1_DOC BETWEEN '"+cNotaIni+"' AND '"+cNotaFim+"' "+CRLF
		cQuery += "AND F1_FORMUL='S'"
		cQuery += "AND F1_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "+CRLF
		cQuery += "AND F1_SERIE BETWEEN '"+cSerDe+"' AND '"+cSerAte+"' "+CRLF
		cQuery += "AND F1_FILIAL IN"+_cCodFilial
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMPSF2", .F., .T.)

		ProcRegua(TMPSF2->(RecCount()))
		TMPSF2->(dbGoTop())

		While TMPSF2->(!Eof())

			If valtype(oproc) == "O"
				oproc:cCaption := ("Gerando XML - Filial "+TMPSF2->F2_FILIAL+"| NF "+TMPSF2->F2_DOC+"-"+TMPSF2->F2_SERIE+"| Registro "+StrZero(n++,6)+" de "+StrZero(i,6))
				processmessages()
			Endif
			// Grava conexão atual
			_ndbprotheus := AdvConnection()

			// Monta conexão ao SPED
			_ndbsped := tclink(AllTrim(cAcesDb),AllTrim(cSrvDba),nPortdb)

			// Muda para conexão do SPED e busca strings para montar xml
			TCSETCONN(_ndbsped)

			_cxml := '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">'

			// Busca xml assinado
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
			cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 56001)) AS XML_SIGS"
			cQuery += " FROM SPED050 "
			cQuery += " WHERE DOC_CHV  = '" + AllTrim(TMPSF2->F2_CHVNFE) + "'"
			cQuery += " AND D_E_L_E_T_= ' ' "

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

			// Busca protocolo de retorno
			cQuery := " SELECT UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_PROT, 2000, 1)) AS XML_PROT "
			cQuery += " FROM SPED054 "
			cQuery += " WHERE NFE_CHV  = '" + AllTrim(TMPSF2->F2_CHVNFE) + "' AND CSTAT_SEFR = '100'"
			cQuery += " AND D_E_L_E_T_= ' ' "

			dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP054", .F., .T.)

			If TMP054->(!Eof())
				_cxml += AllTrim(TMP054->XML_PROT)
			Endif

			TMP054->(dbclosearea())

			_cxml += '</nfeProc>'

			// Volta para conexão do Protheus
			TCSETCONN(_ndbprotheus)

			// Desconecta conexão com o TSS
			TCUnlink(_ndbsped)

			For nI := 1 To 5
				If nI == 1
					cDirCmp := Alltrim(cArquivo)
					IF RIGHT(ALLTRIM(CARQUIVO),1)<>"\"
						cDirCmp := cDirCmp+"\"
					Endif
					If !ExistDir(cDirCmp)
						MakeDir(cDirCmp)
					Endif
				ElseIf nI == 2
					cDirCmp := cDirCmp + TMPSF2->F2_FILIAL
					If !ExistDir(cDirCmp)
						MakeDir(cDirCmp)
					Endif
				ElseIf nI == 3
					cDirCmp := cDirCmp + "\"
					If !ExistDir(cDirCmp)
						MakeDir(cDirCmp)
					Endif
				ElseIf nI == 4
					cDirCmp := cdirCmp += Subs(Tran( TMPSF2->F2_EMISSAO, "@R 9999\99\99" ),1,5)
					If !ExistDir(cDirCmp)
						MakeDir(cDirCmp)
					Endif
				ElseIf nI == 5
					cDirCmp := cdirCmp += Subs(Tran( TMPSF2->F2_EMISSAO, "@R 9999\99\99" ),6,3)
					If !ExistDir(cDirCmp)
						MakeDir(cDirCmp)
					Endif
				EndIf
			Next

			cNomArq := AllTrim(TMPSF2->F2_CHVNFE)+"-nfe.xml"
			nHandle := FCreate(cDirCmp + cNomArq)

			If nHandle > 0
				FWrite(nHandle, _cxml)
				Fclose(nHandle)
				_cControl += 1
			Else
				_aNotas := {}
				AADD(_aNotas,{TMPSF2->F2_FILIAL,TMPSF2->F2_DOC})
				AADD(_aRetorno,_aNotas)
			Endif

			TMPSF2->(dbSkip())

		EndDo

		If i = _cControl // Total de registros selecionados está igual ao contador gerado durante o processamento
			MsgInfo("XMLs exportados com sucesso !!!")
		Else
			_cRet := ''
			For nI := 1 To Len(_aRetorno)
				_cRet += "Filial 	  :  "+_aRetorno[ni][1][1]+"     -     "+"Nota Fiscal :  "+_aRetorno[ni][1][2]+CRLF
			Next
			MsgInfo(_cRet,"XMLs que não foram exportados !!!")
		Endif

Return

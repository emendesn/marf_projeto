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
/*/

User Function MGFFIS52()

	Local aPerg   	 := {}
	Local aParam  	 := {Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),Space(60),CToD(""),CToD(""),Space(14),Space(14)}
	Local lObrigat   := .F.

	AADD(aPerg,{1,"Nota fiscal inicial",aParam[01],"",".T.","",".T.",30,lObrigat})
	AADD(aPerg,{1,"Nota fiscal final",aParam[02],"",".T.","",".T.",30,lObrigat}) 
	AADD(aPerg,{6,"Diretório de destino",aParam[03],"",".T.","!Empty(mv_par04)",80,.T.," |*.","c:\",GETF_RETDIRECTORY+GETF_LOCALHARD,.F.})
	AADD(aPerg,{1,"Data Inicial",aParam[04],"",".T.","",".T.",50,lObrigat})
	AADD(aPerg,{1,"Data Final",aParam[05],"",".T.","",".T.",50,lObrigat})

	If ParamBox(aPerg,"SPED - NFe - Exportador XML",@aParam,,,,,,,,.T.,.T.)
	   fwmsgrun(,{|oproc| fGerXML(aParam[01],aParam[02],aParam[03],aParam[04],aParam[05],oproc) },;
	                      "Aguarde...","Exportando os XML's")
	EndIf   

Return

/*/{Protheus.doc} FGERXML
Efetua a Importação dos XML oriundo do SEFAZ

@author Paulo da Mata
@since 03/12/2019
@version P12.1.17
@return Nil
/*/

Static Function fGerXML(cNotaIni,cNotaFim,cArquivo,dDataDe,dDataAte,oproc)

	Local cQuery  := ""
	Local cArqXml := ""

	Local n		  := 0
	Local i		  := 0

	Local cAcesDb   := GetMv("MGF_FAT41G",,"ORACLE/SPED")  // Acesso ao Oracle
	Local cSrvDba   := GetMv("MGF_FAT41H",,"SPDWVAPL228F") // Acesso Servidor do DbAcess
	Local nPortDb   := GetMv("MGF_FAT41I",,7885)

	If Select("CNTSF2") > 0 
		dbSelectArea("TMPSF2")
		dbCloseArea()
	EndIf

	// Efetua a contagem  dos registros a processar
	cQuery := "SELECT COUNT(*) AS TOT "+CRLF
	cQuery += "FROM "+RetSqlName("SF2")+" "+CRLF
	cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "AND F2_CHVNFE <> ' ' "+CRLF
	cQuery += "AND F2_DOC BETWEEN '"+cNotaIni+"' AND '"+cNotaFim+"' "+CRLF
	cQuery += "AND F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "+CRLF

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"CNTSF2", .F., .T.)

	i := CNTSF2->TOT

	If Select("TMPSF2") > 0 
		dbSelectArea("TMPSF2")
		dbCloseArea()
	EndIf

	// Cria a query para a busca de todas as notas, a partir do SF2010
	cQuery := "SELECT F2_CHVNFE, R_E_C_N_O_ "+CRLF
	cQuery += "FROM "+RetSqlName("SF2")+" "+CRLF
	cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "AND F2_CHVNFE <> ' ' "+CRLF
	cQuery += "AND F2_DOC BETWEEN '"+cNotaIni+"' AND '"+cNotaFim+"' "+CRLF
	cQuery += "AND F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "+CRLF

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMPSF2", .F., .T.)

	ProcRegua(TMPSF2->(RecCount()))
	TMPSF2->(dbGoTop())

	While TMPSF2->(!Eof())

	   If valtype(oproc) == "O" 
          oproc:cCaption := ("Gerando XML - Registro : "+StrZero(n++,6)+" de "+StrZero(i,6))
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
		cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 18001)) AS XML_SIG0 "
		cQuery += " FROM SPED050 "
		cQuery += " WHERE DOC_CHV  = '" + AllTrim(TMPSF2->F2_CHVNFE) + "'"
		cQuery += " AND D_E_L_E_T_= ' ' "

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP050", .F., .T.)

		If TMP050->(!eof())	
			_cxml += AllTrim(TMP050->XML_SIG1)
			_cxml += AllTrim(TMP050->XML_SIG2)
			_cxml += AllTrim(TMP050->XML_SIG3)
			_cxml += AllTrim(TMP050->XML_SIG4)
			_cxml += AllTrim(TMP050->XML_SIG5)
			_cxml += AllTrim(TMP050->XML_SIG6)
			_cxml += AllTrim(TMP050->XML_SIG7)
			_cxml += AllTrim(TMP050->XML_SIG8)
			_cxml += AllTrim(TMP050->XML_SIG9)
			_cxml += AllTrim(TMP050->XML_SIG0)
		Endif

		TMP050->(dbclosearea())

		// Busca protocolo de retorno
		cQuery := " SELECT UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_PROT, 2000, 1)) AS XML_PROT "
		cQuery += " FROM SPED054 "
		cQuery += " WHERE NFE_CHV  = '" + AllTrim(TMPSF2->F2_CHVNFE) + "'"
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

		// Salva string no arquivo
		cArqXML := AllTrim(cArquivo)+AllTrim(TMPSF2->F2_CHVNFE)+"-nfe.xml"
		nHandle := FCreate(cArqXML)

		If nHandle > 0
			FWrite(nHandle,_cxml)
			Fclose(nHandle)
		Endif

		TMPSF2->(dbSkip())

	EndDo    
    
Return

#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"                                                                                                                   

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFFATA8 
Envio de averbação e cancelamento de averbação de notas fiscais
@author  Marcelo Carneiro
@since 24/09/2018
*/
User Function MGFFATA8

Local cAlias	:= ''
Local nNotas	:= 0
Local cQuery	:= ''
Local cFilAux	:= ''
Local dEmiss    := 2
Local _lret
Private _cxml := ""

Private aMatriz  := {"01","010001"}  
Private lIsBlind := IsBlind() .OR. Type("__LocalDriver") == "U"                                                            

U_MFCONOUT('Iniciando processamento de envio de averbação e cancelamento de averbações...')

RpcSetType(3)
RpcSetEnv(aMatriz[1],aMatriz[2])

dEmiss    := Date()-GETMV("MGF_FATA81",,2)
cFilAux	:= cFilAnt

calias := getnextalias()

dbSelectArea('SF2')
SF2->(dbSetOrder(1))

U_MFCONOUT('Carregando notas para envio de averbação...')

cQuery	= "SELECT ZBS.ZBS_NUM NFISCAL,ZBS.R_E_C_N_O_ ZBS_RECNO "
cQuery += "FROM "+RetSqlName("ZBS")+" ZBS "
cQuery += "WHERE ZBS.D_E_L_E_T_ = ' ' "
cQuery += "AND ZBS_EMISS >= '"+Dtos(dEmiss)+"' " 
cQuery += "AND ZBS_STATUS = 'N'"
cQuery += "ORDER BY ZBS.R_E_C_N_O_"

cQuery := ChangeQuery(cQuery)

If select(cAlias) > 0
	(cAlias)->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)

U_MFCONOUT('Contando notas para envio de averbação...')

_ntot := 0
nnotas := 1

Do While (cAlias)->(!eof())
	_ntot++
	(cAlias)->(Dbskip())
Enddo

(cAlias)->(Dbgotop())

Do While (cAlias)->(!eof())

	U_MFCONOUT('Enviando nota ' +(cAlias)->NFISCAL + ' para averbação - ' + strzero(nnotas,6) + " de " + strzero(_ntot,6) + "...")
	nNotas++
	
	ZBS->( dbGoTo( (cAlias)->ZBS_RECNO ) )
	cFilAnt	:= ZBS->ZBS_FILIAL
	
	bAchouNF := SF2->(dbSeek(ZBS->(ZBS_FILIAL+ZBS_NUM+ZBS_SERIE+ZBS_CODCLI+ZBS_LOJCLI)))	

	IF (!bAchouNF .AND. ZBS->ZBS_OPER == '1') .OR. (bAchouNF .AND. ZBS->ZBS_OPER == '2')
		(cAlias)->( dbSkip() )
		Loop
	EndIF

	//Se nota já foi enviada para averbação refaz xml se parâmetro de acerto estiver ativo
	If getmv("MGF_XMLREFAZ",,.T.) .AND. (ALLTRIM(ZBS->ZBS_RETWS) == '200 - {"Status": "1",  "Mensagem": "result ok"}' .OR. ALLTRIM(ZBS->ZBS_RETWS) =='XML NAO ENCONTRADO OU INVALIDO')                                                                                                                                                                          
		U_MFCONOUT("Refazendo xml para a nota "+(cAlias)->NFISCAL+"..."+CRLF) 
		U_MGFFAT41(,alltrim(SF2->F2_CHVNFE))
	Endif

	U_MGFFT41T()

	(cAlias)->( dbSkip() )

EndDo

U_MFCONOUT('Carregando notas para envio de cancelamento de averbação...')


cQuery	:= "SELECT ZBS.ZBS_NUM NFISCAL,ZBS.R_E_C_N_O_ ZBS_RECNO, "
cQuery	+= "(SELECT F2_CHVNFE FROM SF2010 WHERE D_E_L_E_T_ <> ' ' AND F2_FILIAL = ZBS_FILIAL
cQuery	+= "                      AND F2_DOC = ZBS_NUM AND F2_SERIE = ZBS_SERIE AND ROWNUM = 1) CHAVE "
cQuery += "FROM "+RetSqlName("ZBS")+" ZBS "
cQuery += "WHERE ZBS.D_E_L_E_T_ = ' ' "
cQuery += "AND ZBS_EMISS >= '"+Dtos(dEmiss)+"' " 
cQuery += "AND ZBS_AVERBA <> ' ' "
cQuery += "AND ZBS_STATUS <> 'C' "
cQuery += "AND NOT EXISTS(SELECT F2_CHVNFE FROM "+RetSqlName("SF2")+" WHERE D_E_L_E_T_ <> '*' " 
cQuery += "AND F2_FILIAL = ZBS_FILIAL AND F2_DOC = ZBS_NUM AND F2_SERIE = ZBS_SERIE) "
cQuery += "ORDER BY ZBS.R_E_C_N_O_"

cQuery := ChangeQuery(cQuery)

If select(cAlias) > 0
	(cAlias)->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)

U_MFCONOUT('Contando notas para envio de cancelamento de averbação...')

_ntot := 0
nnotas := 1

While (cAlias)->(!eof())
	_ntot++
	(cAlias)->(Dbskip())
Enddo

(cAlias)->(Dbgotop())

While (cAlias)->(!eof())

	U_MFCONOUT('Enviando nota ' +(cAlias)->NFISCAL + ' para cancelamento de averbação - ' + strzero(nnotas,6) + " de " + strzero(_ntot,6) + "...")
	
	ZBS->( dbGoTo( (cAlias)->ZBS_RECNO ) )
	cFilAnt	:= ZBS->ZBS_FILIAL
	
	//Localiza xml de cancelamento no TSS
	_lret := MGFFATA8R((cAlias)->CHAVE)


	If _lret

		//Realiza envio do cancelamento
		_lret := MGFFAT8T()

	Endif

	If _lret 

		U_MFCONOUT('Completado envio nota ' +(cAlias)->NFISCAL + ' para cancelamento de averbação - ' + strzero(nnotas,6) + " de " + strzero(_ntot,6) + "...")

	else
		
		U_MFCONOUT('Falha no envio nota ' +(cAlias)->NFISCAL + ' para cancelamento de averbação - ' + strzero(nnotas,6) + " de " + strzero(_ntot,6) + "...")

	Endif

	nNotas++
	(cAlias)->( dbSkip() )

EndDo


cFilAnt	:= cFilAux

U_MFCONOUT('Completou processamento de envio de averbação e cancelamento de averbações.')

Return

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFFAT8T 
Envio de XML averbação e cancelamento de averbação de notas fiscais
@author  Marcelo Carneiro
@since 24/09/2018
*/
Static Function MGFFAT8T()

	Local cJson			:= ""
	Local cURLPost		:= GetMv("MGF_FATA8D",,"http://spdwvapl215:8089/Seguradora/api/v0/AverbarNFSaida") 
	Local _lret := .F.
	Local cCodInt		:= Alltrim(GetMv("MGF_FAT41E",,"001"))
	Local cTipInt		:= Alltrim(GetMv("MGF_FAT41F",,"001"))

	local oWSRCTRC	:= nil

	If Empty( cURLPost )
		Return
	EndIf

	Private oRCTRC		:= nil

	oRCTRC := nil
	oRCTRC := CCTRC():new()

	oRCTRC:xml						:= AllTrim(_cxml)

	cJson := fwJsonSerialize(oRCTRC, .F., .T.)
	oWSRCTRC := nil
	oWSRCTRC := MGFINT53():new(cURLPost, oRCTRC , ZBS->( Recno() ) , "ZBS" , "ZBS_ITAURA" , cCodInt , cTipInt , ZBS->(ZBS_FILIAL+ZBS_NUM+ZBS_SERIE),.F.,.F.,.T.,,,,.T. )
	oWSRCTRC:SendByHttpPost()


	Reclock("ZBS",.F.)
	ZBS->ZBS_ARQXML := allTrim( str( oWSRCTRC:nStatuHttp ) ) + " - " + oWSRCTRC:cPostRet

	If "Nota averbada com sucesso." $ oWSRCTRC:cPostRet

		ZBS->ZBS_STATUS := "C"
		_lret := .T.
		
	Endif

	ZBS->(Msunlock())


Return _lret

/*
Classe de Cancelamento de Averbação 
*/
	Class CCTRC

		Data xml						as String

		Method New()

	EndClass

/*
Construtor
*/
method New() class CCTRC

nTESTE := 0

return

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFFATA8R 
Montagem do xml de cancelamento de averbação
@author  Marcelo Carneiro
@since 24/09/2018
*/
Static Function MGFFATA8R(_cchave)

	Local cAcesDb   := GetMv("MGF_FAT41G",,"ORACLE/SPED")  // Acesso ao Oracle
	Local cSrvDba   := GetMv("MGF_FAT41H",,"SPDWVAPL228F") // Acesso Servidor do DbAcess
	Local nPortDb   := GetMv("MGF_FAT41I",,7885)
	Local _lret := .F.
	// Grava conexão atual
	_ndbprotheus := AdvConnection()

	// Monta conexão ao SPED 
	_ndbsped := tclink(AllTrim(cAcesDb),AllTrim(cSrvDba),nPortdb)

	//Muda para conexão do SPED e busca strings para montar xml
	 TCSETCONN(_ndbsped) 

	_cxml := '<?xml version="1.0" encoding="UTF-8"?>'

	//procura cancelamento no sped150


	//Busca xml assinado
	cQuery := " SELECT UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 1)) AS XML_SIG1,
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 2001)) AS XML_SIG2, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 4001)) AS XML_SIG3, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 6001)) AS XML_SIG4, "
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_SIG, 2000, 8001)) AS XML_SIG5,
	cQuery += "	UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XML_RET, 2000, 1)) AS XML_RET, R_E_C_N_O_ AS RECN "
	cQuery += " FROM SPED150 "
	cQuery += "  WHERE NFE_CHV  = '" + _cchave + "' AND TPEVENTO = '110111'"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP150", .F., .T.)

	If TMP150->(!eof())	
		_cxml += substr(TMP150->XML_SIG1,1,2000)
		_cxml += substr(TMP150->XML_SIG2,1,2000)
		_cxml += substr(TMP150->XML_SIG3,1,2000)
		_cxml += substr(TMP150->XML_SIG4,1,2000)
		_cxml += substr(TMP150->XML_SIG5,1,2000)
		_cxml := strtran(_cxml,"envEvento","procEventoNFe")
		_cxml := strtran(_cxml,'</procEventoNFe>','')
		_cxml := alltrim(_cxml)
		_cxml += substr(TMP150->XML_RET,1,2000)
		_cxml := alltrim(_cxml)
		_cxml += '</procEventoNFe>'

		//Refaz cabecalho
		
		_nposr := at("<infEvento Id",_cxml,1)
		_cxml := substr(_cxml,_nposr,len(_cxml))
		_ccabec := '<?xml version="1.0" encoding="UTF-8"?><procEventoNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="1">'
		_ccabec += '<evento versao="1" xmlns="http://www.portalfiscal.inf.br/nfe">'
		_cxml := _ccabec + _cxml

		//Refaz cabeçalho de retorno do sefaz
		_nposr := at("<retEnvEvento",_cxml,1)-1
		_cxmli := substr(_cxml,1,_nposr)
		_nposr2 := at("<retEvento versao",_cxml,1)
		_cxmlf := substr(_cxml,_nposr2,len(_cxml))
		_cxml := alltrim(_cxmli) + alltrim(_cxmlf)

		_cxml := strtran(_cxml,'</retEnvEvento>','')

		_lret := .T.
	else

		U_MFCONOUT('Não localizou xml de cancelamento da nota ' +(cAlias)->NFISCAL + ' para cancelamento de averbação - ' + strzero(nnotas,6) + " de " + strzero(_ntot,6) + "...")

	Endif

	TMP150->(dbclosearea())

	//Volta para conexão do Protheus
	TCSETCONN(_ndbprotheus) 

	//Desconecta conexão com o TSS
	TCUnlink(_ndbsped)


Return _lret
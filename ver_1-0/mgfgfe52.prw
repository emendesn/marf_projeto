#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'RWMAKE.CH'

/*/
==============================================================================================================================================================================
Descrição   : Tela para aprovação de documento de Frete (Auditoria)

@description
Implementar rotina de liberação de documentos de frete em lote.
No sistema Protheus, na tela "Aprovar Doc Frete" solicito que seja incluído para realizar aprovações em lote, hoje o departamento gasta em média 8 horas
de trabal/ho realizando o clique de aprovação de lançamento por lançamento, com a aprovação em lote reduziríamos consideravelmente o tempo de
execução dessa atividade.

@author     : Cláudio Alves
@since      : 02/10/2019
@type       : User Function

@table
GU5 -   TIPO DA OCORRENCIA
GU6 -	MOTIVO DA OCORRENCIA
GW3 -	DOCUMENTOS DE FRETE
GW4 -	DOCTOS CARGA DOS DOCTOS FRETE
GWD -	OCORRENCIAS
GWL -	OCORRENCIA X DOCTO CARGA

@param

@return

@menu
Gestao Frete Embarcação - Atualizações-MARFRIG-Aprovação Doc Frete Auto

@history //Manter até as últimas 3 manutenções do fonte para facilitar identificação de versão, remover esse comentário
01/10/2019 - RTASK0010082-aprovar-doc-frete-lote_Claudio

/*/   

User Function MGFGFE52()
	local _aStruLib	    :=  {} //Estrutura da tabela de Aprovação GW3private

	//Fitro para entrar na avaliação das divergências
	private _cFilial	:=	''
	private _cDesp		:=	''
	private _cEmisdf	:=  ''
	private _cSerdf		:=  ''
	private _cNrdf		:=  ''
	private _dDtemis	:=	ctod('  /  /    ')


	cPerg		:=  "MGFGFE52PG"
	Pergunte(cPerg,.T.)
	_aStruLib := MGFGFE5201() // Monta a Tabela Temporária
	MGFGFE5202(_aStruLib) //Monta o Mark Browser

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} MGFGFE5202()
//Monta o Mark Browser

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return Nil
/*/
//-------------------------------------------------------------------
static function MGFGFE5202(strTab)
	local _aStruLib	    :=  strTab //Estrutura da tabela de Aprovação GW3
	local _cTmp		    :=  GetNextAlias()
	local _cAliasTmp
	local _aColumns	    :=  {}
	local _cFiltro		:=  {}
	local _cInsert      :=  ''
	local _nx           :=  0
	local _ni           :=  0
	// local _cCampos      :=  ''
	local _cFim         :=  CHR(13) + CHR(10)



	_cFiltro := MGFGFE5215() //Chama a rotina que filtra as aprovações



	//Instancio o objeto que vai criar a tabela temporária no BD para poder utilizar posteriormente
	oTmp := FWTemporaryTable():New( _cTmp )

//Defino os campos da tabela temporária
	oTmp:SetFields(_aStruLib)

//Criação da tabela temporária no BD
	oTmp:Create()

//Obtenho o nome "verdadeiro" da tabela no BD (criada como temporária)
	_cTable := oTmp:GetRealName()

//Preparo o comando para alimentar a tabela temporária

	_cInsert += "INSERT INTO " + _cTable + _cFim
	_cInsert += "   (GW3_FILIAL, GW3_CDESP, GW3_EMISDF, GW3_NRDF, GW3_SERDF, " + _cFim
	_cInsert += "    GW3_DTEMIS, GW3_SIT, GW3_VLDF, VALCALC, GW3_PCIMP, ALIQ, " + _cFim
	_cInsert += "    GW3_VLIMP, IMP, DIFER ) " + _cFim
	if MV_PAR07 == 2
		_cInsert += "SELECT * FROM ( " + _cFim
	endif
	_cInsert += "SELECT " + _cFim
	_cInsert += "	GW3_FILIAL, GW3_CDESP, GW3_EMISDF, GW3_NRDF, GW3_SERDF, " + _cFim
	_cInsert += "   GW3_DTEMIS, GW3_SIT, GW3_VLDF, VALCALC, GW3_PCIMP, ALIQ, " + _cFim
	_cInsert += "   GW3_VLIMP, IMP, DIFIMP + DIFVAL + DIFALIQ DIFER  " + _cFim
	_cInsert += "FROM " + _cFim
	_cInsert += "   ( " + _cFim
	_cInsert += "	SELECT " + _cFim
	_cInsert += "    GW3_FILIAL, GW3_CDESP, GW3_EMISDF, GW3_SERDF, GW3_NRDF, " + _cFim
	_cInsert += "    GW3_DTEMIS, GW3_SIT, GW3_VLDF, GWF_BASICM VALCALC, " + _cFim
	_cInsert += "    CASE " + _cFim
	_cInsert += "        WHEN GW3_VLDF <> GWF_BASICM " + _cFim
	_cInsert += "        THEN 1 " + _cFim
	_cInsert += "        ELSE 0 " + _cFim
	_cInsert += "    END DIFVAL, " + _cFim
	_cInsert += "    GW3_PCIMP, " + _cFim
	_cInsert += "    CASE " + _cFim
	_cInsert += "        WHEN GWF_IMPOST = '2' " + _cFim
	_cInsert += "		THEN GWF_PCISS ELSE " + _cFim
	_cInsert += "        GWF_PCICMS " + _cFim
	_cInsert += "    END ALIQ, " + _cFim
	_cInsert += "    CASE " + _cFim
	_cInsert += "        WHEN GW3_PCIMP <> CASE WHEN GWF_IMPOST = '2' THEN GWF_PCISS ELSE GWF_PCICMS END " + _cFim
	_cInsert += "        THEN 1 " + _cFim
	_cInsert += "        ELSE 0 " + _cFim
	_cInsert += "    END DIFALIQ, " + _cFim
	_cInsert += "    GW3_VLIMP, " + _cFim
	_cInsert += "    CASE " + _cFim
	_cInsert += "        WHEN GWF_IMPOST = '2' " + _cFim
	_cInsert += "		THEN GWF_VLISS " + _cFim
	_cInsert += "        ELSE GWF_VLICMS " + _cFim
	_cInsert += "    END IMP, " + _cFim
	_cInsert += "    CASE " + _cFim
	_cInsert += "        WHEN GW3_VLIMP <> CASE WHEN GWF_IMPOST = '2' THEN GWF_VLISS ELSE GWF_VLICMS END " + _cFim
	_cInsert += "        THEN 1 " + _cFim
	_cInsert += "        ELSE 0 " + _cFim
	_cInsert += "    END DIFIMP " + _cFim
	_cInsert += "FROM  " + _cFim
	_cInsert += "    " + RetSQLName("GW3") + " A INNER JOIN " + _cFim
	_cInsert += "    " + RetSQLName("GW4") + " B ON " + _cFim
	_cInsert += "    GW3_FILIAL = GW4_FILIAL AND  " + _cFim
	_cInsert += "    GW3_EMISDF = GW4_EMISDF AND " + _cFim
	_cInsert += "    GW3_CDESP = GW4_CDESP AND " + _cFim
	_cInsert += "    GW3_SERDF = GW4_SERDF AND " + _cFim
	_cInsert += "    GW3_NRDF = GW4_NRDF AND " + _cFim
	_cInsert += "    GW3_DTEMIS = GW4_DTEMIS INNER JOIN " + _cFim
	_cInsert += "    " + RetSQLName("GW1") + " C ON " + _cFim
	_cInsert += "    GW3_FILIAL = GW1_FILIAL AND " + _cFim
	_cInsert += "    GW1_CDTPDC = GW4_TPDC AND " + _cFim
	_cInsert += "    GW1_EMISDC = GW4_EMISDC AND " + _cFim
	_cInsert += "    GW1_SERDC = GW4_SERDC AND " + _cFim
	_cInsert += "    GW1_NRDC = GW4_NRDC INNER JOIN " + _cFim
	_cInsert += "    ( " + _cFim
	_cInsert += "        SELECT DISTINCT " + _cFim
	_cInsert += "            GWH_FILIAL,  " + _cFim
	_cInsert += "            GWH_CDTPDC,  " + _cFim
	_cInsert += "            GWH_EMISDC,  " + _cFim
	_cInsert += "            GWH_SERDC,  " + _cFim
	_cInsert += "            GWH_NRDC,  " + _cFim
	_cInsert += "            GWH_NRCALC " + _cFim
	_cInsert += "        FROM " + _cFim
	_cInsert += "            " + RetSQLName("GWH") + " " + _cFim
	_cInsert += "        WHERE " + _cFim
	_cInsert += "            R_E_C_D_E_L_ = 0     " + _cFim
	_cInsert += "    ) E ON " + _cFim
	_cInsert += "    GW3_FILIAL = GWH_FILIAL AND  " + _cFim
	_cInsert += "    GW1_CDTPDC = GWH_CDTPDC AND  " + _cFim
	_cInsert += "    GW1_EMISDC = GWH_EMISDC AND  " + _cFim
	_cInsert += "    GW1_SERDC = GWH_SERDC AND  " + _cFim
	_cInsert += "    GW1_NRDC = GWH_NRDC INNER JOIN " + _cFim
	_cInsert += "    " + RetSQLName("GWF") + " F ON " + _cFim
	_cInsert += "    GW3_FILIAL = GWF_FILIAL AND " + _cFim
	_cInsert += "    GWH_NRCALC =  GWF_NRCALC AND " + _cFim
	_cInsert += "    GW3_EMISDF = GWF_TRANSP AND " + _cFim
	_cInsert += "    GW3_TPDF = GWF_TPCALC LEFT JOIN " + _cFim
	_cInsert += "    ( " + _cFim
	_cInsert += "        SELECT  " + _cFim
	_cInsert += "            GWI_FILIAL, GWI_NRCALC, GWI_VLFRET   " + _cFim
	_cInsert += "        FROM " + _cFim
	_cInsert += "            " + RetSQLName("GWI") + " A INNER JOIN " + _cFim
	_cInsert += "            " + RetSQLName("GV2") + " B ON " + _cFim
	_cInsert += "            GV2_FILIAL = GWI_FILIAL AND " + _cFim
	_cInsert += "            GV2_CDCOMP = GWI_CDCOMP " + _cFim
	_cInsert += "        WHERE " + _cFim
	_cInsert += "            A.R_E_C_D_E_L_ = 0 AND     " + _cFim
	_cInsert += "            B.R_E_C_D_E_L_ = 0 AND " + _cFim
	_cInsert += "            GWI_TOTFRE = '1' AND " + _cFim
	_cInsert += "            GV2_CATVAL = '2'     " + _cFim
	_cInsert += "    )G ON " + _cFim
	_cInsert += "    GW3_FILIAL = GWI_FILIAL AND " + _cFim
	_cInsert += "    GWF_NRCALC = GWI_NRCALC   " + _cFim
	_cInsert += "WHERE " + _cFim
	_cInsert += "    A.R_E_C_D_E_L_ = 0 AND     " + _cFim
	_cInsert += "    B.R_E_C_D_E_L_ = 0 AND " + _cFim
	_cInsert += "    C.R_E_C_D_E_L_ = 0 AND " + _cFim
	_cInsert += "    F.R_E_C_D_E_L_ = 0 AND " + _cFim
	_cInsert += "    GW3_DTEMIS BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND  " + _cFim
	_cInsert += "    GW3_FILIAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND  " + _cFim
	_cInsert += "    GW3_EMISDF BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + _cFim
	_cInsert +=  _cFiltro + _cFim
	_cInsert += " )S " + _cFim
	if MV_PAR07 == 2
		_cInsert += " )D " + _cFim
		_cInsert += "WHERE " + _cFim
		_cInsert += "    DIFER = 0 " + _cFim
	endif


//Executo o comando para alimentar a tabela temporária

	memowrite("c:\temp\MGFclaudio_MGFGFE5202.TXT", _cInsert  )
	_cInsert := strTran(_cInsert, _cFim, '')

	Processa({|| TcSQLExec(_cInsert)})


//MarkBrowse
	For _nx := 1 To Len(_aStruLib)
		if !(_aStruLib[_nx][1] == 'GW3_OK')
			aadd(_aColumns,FWBrwColumn():New())
			_aColumns[Len(_aColumns)]:SetData( &("{||"+_aStruLib[_nx][1]+"}") )
			if Alltrim(_aStruLib[_nx][1]) == 'DIFER'
				_aColumns[Len(_aColumns)]:SetTitle("Diferença")
			elseif Alltrim(_aStruLib[_nx][1]) == 'VALCALC'
				_aColumns[Len(_aColumns)]:SetTitle("Valor Calc")
			elseif Alltrim(_aStruLib[_nx][1]) == 'ALIQ'
				_aColumns[Len(_aColumns)]:SetTitle("Alq Calc")
			elseif Alltrim(_aStruLib[_nx][1]) == 'IMP'
				_aColumns[Len(_aColumns)]:SetTitle("Imp Calc")
			elseif Alltrim(_aStruLib[_nx][1]) == 'GW3_OK'
				_aColumns[Len(_aColumns)]:SetTitle("Mark")
			else
				_aColumns[Len(_aColumns)]:SetTitle(RetTitle(_aStruLib[_nx][1]))
			endif
			if !(_aStruLib[_nx][1] $ 'GW3_OK|DIFER|VALCALC|IMP|ALIQ')
				_aColumns[Len(_aColumns)]:SetPicture(PesqPict("GW3",_aStruLib[_nx][1]))
			elseif (_aStruLib[_nx][1] $ 'VALCALC|IMP')
				_aColumns[Len(_aColumns)]:SetPicture(PesqPict("GW3",'GW3_VLDF'))
			elseif (_aStruLib[_nx][1] == 'ALIQ')
				_aColumns[Len(_aColumns)]:SetPicture(PesqPict("GW3",'GW3_PCIMP'))
			endif
			_aColumns[Len(_aColumns)]:SetSize(_aStruLib[_nx][3])
			_aColumns[Len(_aColumns)]:SetDecimal(_aStruLib[_nx][4])
		endif
	Next _nx

	_cAliasTmp := oTmp:GetAlias()

	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetAlias( _cAliasTmp )
	oBrowse:SetDescription( 'Aprovação Documento de Frete Automático' )
	oBrowse:SetTemporary(.T.)
	oBrowse:SetLocate()
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetDBFFilter(.T.)
	oBrowse:SetFilterDefault( "" ) //Exemplo de como inserir um filtro padrão >>> "TR_ST == 'A'"
	oBrowse:DisableDetails()
	oBrowse:AddButton("Aprovar Fretes", {|| MsgRun('Aprovando Fretes','Processando',{|| MGFGFE5205() }) },,,, .F., 2 )
	oBrowse:AddButton("Verificar Diferencas", {|| MGFGFE5206()},,,, .F., 2 )
	oBrowse:SetFieldMark("GW3_OK")
	oBrowse:SetCustomMarkRec({||xMark()})

	oBrowse:SetAllMark({|| xMarkAll() })

// Definição da legenda
	oBrowse:AddLegend( "DIFER == 0 ", "BR_VERDE"	, "Sem Diferenças" )
	oBrowse:AddLegend( "DIFER == 1 ", "BR_AMARELO"	, "Uma Diferença" )
	oBrowse:AddLegend( "DIFER == 2 ", "BR_VERMELHO"	, "Duas Diferenças" )
	oBrowse:AddLegend( "DIFER == 3 ", "BR_PRETO"	, "Três Diferenças" )

	oBrowse:SetColumns(_aColumns)

	oBrowse:Activate()

	oTmp:Delete()

//	EndIf
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFGFE5206()
// Avaliação dos frestes com divergencias

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return Nil
/*/
//-------------------------------------------------------------------
static function MGFGFE5206()
	local cAlias	:= oBrowse:Alias()
	local aRest		:= GetArea()

	(cAlias)->(DbGoTop())
	While (cAlias)->(!Eof())
		If oBrowse:IsMark()
			MGFGFE5207((cAlias)->GW3_FILIAL, (cAlias)->GW3_CDESP, (cAlias)->GW3_EMISDF, (cAlias)->GW3_SERDF, (cAlias)->GW3_NRDF, (cAlias)->GW3_DTEMIS )
		EndIf
		(cAlias)->(DbSkip())
	EndDo
	RestArea(aRest)

	oBrowse:refresh(.F.)
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFGFE5207()
Mostra uma tela com as diferenças dos valores do Documento de Frete com opção para aprovar os valores 
informando o motivo

@author Cláudio Alves
@since 07/10/2019
@version 1.0
----------------------------------------------------------------------------------------------------*/

static function MGFGFE5207(_FILIAL, _CDESP, _EMISDF, _SERDF, _NRDF, _DTEMIS)
	local bCor
	local cArqMKB
	local cIndMA
	local aMKB
	local aCpMKB
	local aCpOcor
	local aTmp 
	local cQuery := ""
	local oButton
	local oPnlCnt
	local oSize
	local aPos
	local _cFim         :=  CHR(13) + CHR(10)
    local lExecFilt := .F.
	local aNewButton := {{"",{|| MGFGFE5211() },"Cons. Cálculo"}}
	local aAreaGW3	:= GW3->( GetArea() )


    private cMarca := GetMark()
	private oDlgGFEA66
	private aCalc := {"GWF_FILIAL", "GWF_NRCALC", "GWI_VLFRET", "GWF_TPCALC", "GWF_ORIGEM", "GWF_FINCAL", "GWF_NRROM", "GWF_TPTRIB", "GWF_IMPOST",;
					  "GWF_VLISS", "GWF_VLICMS"}
	private aDCDF := {"GW4_FILIAL", "GW4_NRDC", "GW4_EMISDC", "GU3_NMEMIT", "GW4_SERDC", "GW4_TPDC"}
	private aDCCL := {"GWH_FILIAL", "GWH_NRDC", "GWH_EMISDC", "GU3_NMEMIT", "GWH_SERDC", "GWH_CDTPDC"}
	private aOcor := {"GWL_FILDC", "GWL_NRDC", "GWL_EMITDC", "GU3_NMEMIT", "GWL_SERDC", "GWL_TPDC", "GWD_FILIAL", "GWD_NROCO", "GWD_DSOCOR", "GWD_CDTIPO", ;
					  "GU5_DESC", "GWD_CDMOT", "GU6_DESC", "GU5_ACAODF", "GU5_BLQ"}
	
	private cMemo  := ''
	private oFolder
	private cAliMKB
	private cAliCalc
	private cAliDCDF
	private cAliDCCL
	private cAliOcor
	private cCalc
	private cDCDF
	private cDCCL
	private cOcor
	
		//Fitro para entrar na avaliação das divergências
	
	private lLoadDocRelac := .F.

	_cFilial	:=	_FILIAL
	_cDesp		:=	_CDESP
	_cEmisdf	:=  _EMISDF
	_cSerdf		:=  _SERDF
	_cNrdf		:=  _NRDF
	_dDtemis	:=	_DTEMIS

	dbSelectArea("GW3")
	dbSetOrder(1)

	GW3->(dbSeek(_cFilial+_cDesp+_cEmisdf+_cSerdf+_cNrdf+DTOS(_dDtemis)))

	aTmp := Array(Len(aOcor)-1)
	
	CursorWait()
	
	//------CONFERÊNCIA
			
	aMKB :=    {{"OBRIGAT" ,"C",01,0},;
				{"CAMPO"   ,"C",35,0},;
				{"VALOR1"  ,"N",16,4},;
				{"VALOR2"  ,"N",16,4},;
				{"DIF"     ,"N",16,4}}
				
  	aCpMKB  := {{"OBRIGAT" ,NIL,"O",""},;
				{"CAMPO"   ,NIL,"Campo",""},; //
				{"VALOR1"  ,NIL,"Informado","@E 999,999,999.99999"},; //"Informado"
				{"VALOR2"  ,NIL,"Calculado","@E 999,999,999.99999"},; //"Calculado"
				{"DIF"     ,NIL,"Diferença","@E 999,999,999.99999"}} //
								
	cAliMKB := GFECriaTab({ aMKB,{"OBRIGAT"} })
	cOcor := GFECriaTab( {MGFGFE5212(1, 1), {"GWD_FILIAL+GWL_FILDC+GWL_NRDC+GWL_EMITDC+GWL_SERDC+GWL_TPDC"}})
	

	//------OCORRÊNCIAS
	ACopy(aOcor, aTmp, 1, Len(aOcor)-1)
	
	aCpOcor := MGFGFE5212(1,2)
	
	cAliOcor := GetNextAlias()
	
	cQuery += "SELECT " + _cFim
	cQuery += "   GWL.GWL_FILDC, GWL.GWL_NRDC, GWL.GWL_EMITDC, " + _cFim
	cQuery += "		(SELECT GU3.GU3_NMEMIT FROM " + RetSQLName("GU3") + " GU3 " + _cFim
	cQuery += "			WHERE GU3.GU3_FILIAL = '" + GW3->GW3_FILIAL + "' AND GU3.GU3_CDEMIT = GWL.GWL_EMITDC AND GU3.D_E_L_E_T_ = ' ' " + _cFim
 	cQuery += "		) GU3_NMEMIT, " + _cFim
 	cQuery += "		GWL.GWL_SERDC, GWL." + SerieNfId("GWL",3,"GWL_SERDC") + ", GWL.GWL_TPDC, GWD.GWD_FILIAL, GWD.GWD_NROCO, GWD.GWD_DSOCOR, GWD.GWD_CDTIPO, " + _cFim
 	cQuery += "		GU5.GU5_DESC, GWD.GWD_CDMOT, GU6.GU6_DESC, GU5.GU5_ACAODF GU5_BLQ, " + _cFim
 	cQuery += 		MGFGFE5213("GU5", "GU5_ACAODF", "GU5_ACAODF", "'Nenhum'") + " " + _cFim
	cQuery += "FROM " + RetSQLName("GWL") + " GWL " + _cFim
	cQuery += "		INNER JOIN " + RetSQLName("GWD") + " GWD ON GWD.GWD_FILIAL = GWL.GWL_FILIAL AND GWD.GWD_NROCO = GWL.GWL_NROCO " + _cFim
	cQuery += "		INNER JOIN " + RetSQLName("GU5") + " GU5 ON GU5.GU5_CDTIPO = GWD.GWD_CDTIPO " + _cFim
	cQuery += "		INNER JOIN " + RetSQLName("GU6") + " GU6 ON GU6.GU6_CDMOT = GWD.GWD_CDMOT " + _cFim
	cQuery += "WHERE "	 + _cFim
	cQuery += "		GWL.GWL_FILDC || GWL.GWL_NRDC || GWL.GWL_EMITDC || GWL.GWL_SERDC || GWL.GWL_TPDC IN " + _cFim
	cQuery += "		(SELECT (GW4.GW4_FILIAL || GW4.GW4_NRDF || GW4.GW4_EMISDF || GW4.GW4_SERDF || GW4.GW4_TPDC)  as CHAVE " + _cFim
	cQuery += "		 FROM " + RetSQLName("GW4") + " GW4 " + _cFim
	cQuery += "		 WHERE GW4.GW4_FILIAL = '" + GW3->GW3_FILIAL + "' AND GW4.GW4_CDESP = '" + GW3->GW3_CDESP + "'"  + _cFim
	cQuery += "         AND GW4.GW4_EMISDF = '" + GW3->GW3_EMISDF + "' AND GW4.GW4_SERDF = '" + GW3->GW3_SERDF + "'" + _cFim
	cQuery += "         AND GW4.GW4_NRDF = '" + GW3->GW3_NRDF + "' AND GW4.GW4_DTEMIS = '" + DTOS(GW3->GW3_DTEMIS) + "'"  + _cFim
	cQuery += "		   	AND GW4.D_E_L_E_T_ = ' ' " + _cFim
	cQuery += "		) " + _cFim
	cQuery += "		AND GWL.D_E_L_E_T_ = ' ' AND GWD.D_E_L_E_T_ = ' ' " + _cFim
	cQuery += "ORDER BY GWL.GWL_FILDC, GWL.GWL_NRDC " + _cFim
		

	

	memowrite("c:\temp\MGFclaudio_MGFGFE5207.TXT", cQuery  )

	cQuery := ChangeQuery(strTran(cQuery, _cFim, ''))
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cAliOcor, .F., .T.)
	
	// if empty(alltrim((cAliOcor)->GWL_NRDC))
	// 	alert('Sem Doc para Análise')
	// 	return .t.
	// endif

	//-----------------
	oSize := FWDefSize():New(.T.)
	oSize:AddObject( "ENCHOICE", 100, 60, .T., .T. ) // Adiciona enchoice
	oSize:SetWindowSize({000, 000, 520,900})
	oSize:lLateral     := .F.  // Calculo vertical	
	oSize:Process() //executa os calculos
	
	//Array com as posições dinamicas se quiser alterar o tamnho da tela é so alterar o tamanho do SetWindowSize
	aPos := {oSize:GetDimension("ENCHOICE","LININI"),; 
            oSize:GetDimension("ENCHOICE","COLINI"),;
            oSize:GetDimension("ENCHOICE","XSIZE"),;
            oSize:GetDimension("ENCHOICE","YSIZE")}
            
	//
	DEFINE MSDIALOG oDlgGFEA66 TITLE "Aprovação de Documento de Frete"	 ;
							FROM oSize:aWindSize[1],oSize:aWindSize[2] ;
							TO oSize:aWindSize[3],oSize:aWindSize[4] ; 
							Of oMainWnd COLORS 0, 16777215 PIXEL
	oDlgGFEA66:lEscClose := .F.
	
	oPnlCnt := tPanel():New(aPos[1],aPos[2],,oDlgGFEA66,,,,,,aPos[3],aPos[4],.F.,.F.)
	
	oPnlA := tPanel():New(00,00,,oPnlCnt,,,,,,10,20,.F.,.F.)
	oPnlA:Align := CONTROL_ALIGN_TOP
	
	/* Folders */
		oFolder := TFolder():New(0,0,{"Diferenças", "Documentos", "Ocorrências", "Observações"},{"HEADER 1", "HEADER 2", "HEADER 3", "HEADER 4"},oPnlCnt,,,,.T.,,10,10,) //"Diferenças"###"Observações"
	
	oFolder:bSetOption := {|nFolSel| IIF(nFolSel==2, LoadDocRelac(_cFilial, _cDesp, _cEmisdf, _cSerdf, _cNrdf, _dDtemis), Nil ) }   
	
	oFolder:Align := CONTROL_ALIGN_ALLCLIENT
	
	oPanelB := TPanel():New(01,01,,oFolder:ADialogs[1],,,,,,0,0,.F.,.T.)
		oPanelB:Align := CONTROL_ALIGN_ALLCLIENT
	
		oPanelD := TPanel():New(01,01,,oFolder:ADialogs[4],,,,,,0,0,.F.,.T.)
			oPanelD:Align := CONTROL_ALIGN_ALLCLIENT
	
	// ----- Criacao dos fields referente ao romaneio no painel superior da tela principal -----//
	cDSTRAN := posicione("GU3",1, GW3->GW3_FILIAL + _EMISDF ,"GU3_NMEMIT")
	@ 07,10  Say "Filial: " Of oPnlA COLOR CLR_BLACK Pixel //
   	@ 05,25  MSGET _FILIAL Picture "@!" Of oPnlA When .F. SIZE 40,10  Pixel
   	                                                                                         
	@ 07,72  Say "Espécie: " Of oPnlA COLOR CLR_BLACK Pixel //                       
   	@ 05,96 MSGET _CDESP Picture "@!" Of oPnlA When .F.  SIZE 55,10  Pixel
	                                                                                         		
	@ 07,167 Say "Emissor: "            Of oPnlA COLOR CLR_BLACK Pixel //
	@ 05,190 MSGET _EMISDF  Picture "@!" Of oPnlA When .F.   SIZE 80,10 Pixel
	@ 05,270 MSGET cDSTRAN Picture "@!" Of oPnlA When .F. SIZE 150,10 Pixel

	
	//---------Fim da criacao dos fields ----------//	

	//--1----- Seleciona a temp-table de Documentos de cargas que nao foram relacionados ao romaneio e cria o browse -----// 	
	dbSelectArea(cAliMKB)
	dbSetOrder(01)
	dbGoTop()
	oMark := MsSelect():New(cAliMKB,"",,aCpMKB,,@cMarca,{0,0,0,0},,,oPanelB)
	oMark:oBrowse:cToolTip := "Documentos de Carga" //
	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oMark:oBrowse:SetBlkBackColor({|| if(AbaixoTol(),RGB(255,128,128),RGB(254,254,254))})
	
	//--------------Fim 1 -- criado o browse---------------//
 	
	//----OCORRÊNCIAS
	
	oPanelG := TPanel():New(01,01,,oFolder:aDialogs[3],,,,,,30,30,.F.,.T.)
		oPanelG:Align := CONTROL_ALIGN_ALLCLIENT
		
	dbSelectArea(cOcor)
	(cOcor)->( dbSetOrder(1) )
	(cOcor)->( dbGoTop() )
	cGrdOcor := MsSelect():New(cOcor,"",,aCpOcor,,/*@cMarcaF*/,{0,0,0,0},,,oPanelG)
	cGrdOcor:oBrowse:cToolTip := "Ocorrências dos Documentos de Carga dos Documentos de Frete." //
	cGrdOcor:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	cGrdOcor:oBrowse:SetBlkBackColor({|| IIf((cOcor)->GU5_BLQ == "3",RGB(255,128,128),)})
	
	cGrdOcor:oBrowse:lVisibleControl := .T.
	cGrdOcor:oBrowse:lVisible := .T.
	//cGrdOcor:oBrowse:nHeight  := 251
	cGrdOcor:oBrowse:nRight   := 80
	cGrdOcor:oBrowse:nWidth   := 80
	
	//----*FIM* OCORRÊNCIAS

	//----Observações---- 
	
	@ 20,15 Say "Motivo para Aprovação:"   Of oPanelD COLOR CLR_BLACK Pixel  //
	@ 30,15 GET oMemo VAR cMemo MEMO when .f. SIZE 200,60 OF oPanelD PIXEL 
	oMemo:bRClicked := {||AllwaysTrue()}

	@ 95,15 Say "Motivos de Bloqueio:"   Of oPanelD COLOR CLR_BLACK Pixel  //
	@ 105,15 GET oMemo VAR GW3->GW3_MOTBLQ MEMO when .f. SIZE 200,60 OF oPanelD PIXEL 
	oMemo:bRClicked := {||AllwaysTrue()}


	//----- Processa os registros e carrega os browses -----//
	Processa({|lEnd| MGFGFE5208(_cFilial, _cDesp, _cEmisdf, _cSerdf, _cNrdf, _dDtemis)},"Processando informações","Aguarde") //###

	CursorArrow()
	
	dbSelectArea(cAliMKB)
	dbGoTOp()
	
	oMark:oBrowse:nAtCol(2,.F.)
	
	ACTIVATE MSDIALOG oDlgGFEA66 ON INIT (EnchoiceBar(oDlgGFEA66,{||Iif(GFEA066OK(),(lExecFilt := .T.,oDlgGFEA66:End()),NIL)},;
		{||oDlgGFEA66:End()},,aNewButton),oMark:oBrowse:Gotop()) CENTERED
		
	GFEDelTab(cAliMKB)
	GFEDelTab(cOcor)
	 
	If lLoadDocRelac
		GFEDelTab(cDCDF)
		GFEDelTab(cDCCL)
		GFEDelTab(cCalc)
	EndIf
	RestArea(aAreaGW3)	
	
Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFGFE5205()
// Aprovar os fretes selecionados

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------
static function MGFGFE5205()
	local cAlias	:= oBrowse:Alias()
	local aRest		:= GetArea()
	local _aheader	:=	{}
	local _acols	:=	{}

	_aheader := {'Filial', 'Especie', 'Emissor', 'Doc', 'Serie', 'Situacao'}

	(cAlias)->(DbGoTop())
	While (cAlias)->(!Eof())
		If oBrowse:IsMark()
			dbSelectArea("GW3")
			dbSetOrder(1)
			GW3->(dbSeek((cAlias)->GW3_FILIAL + (cAlias)->GW3_CDESP + (cAlias)->GW3_EMISDF + (cAlias)->GW3_SERDF + (cAlias)->GW3_NRDF + DTOS((cAlias)->GW3_DTEMIS)))

			RecLock("GW3",.F.)
			GW3->GW3_USUAPR := cUserName
			GW3->GW3_SIT    := "4"
			GW3->GW3_DTAPR  := DDATABASE
			If GfeVerCmpo({"GW3_HRAPR"})
				GW3->GW3_HRAPR  := Time()
			EndIf
			GW3->(MsUnLock())

			aadd( _acols, { (cAlias)->GW3_FILIAL , (cAlias)->GW3_CDESP, (cAlias)->GW3_EMISDF, (cAlias)->GW3_NRDF, (cAlias)->GW3_SERDF, 4})
			(cAlias)->(RecLock(cAlias,.F.))
			(cAlias)->(dbDelete())
			(cAlias)->(MsUnlock())
		EndIf
		(cAlias)->(DbSkip())
	EndDo

	RestArea(aRest)

	U_MGListBox( "Log de aprovações dos Fretes" , _aheader , _acols , .T. , 1 )
// alert('Foram Aprovados: ' + Transform(_nConta, '99999'))

	(cAlias)->(DbGoTop())

	oBrowse:refresh(.F.)

	PROCESSMESSAGES()

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} xMark()
// Marca todas as opções com Zero de diferença

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------
static function xMark()
	local cAlias    :=  oBrowse:Alias()
	local lRet      :=  .T.

	If (!oBrowse:IsMark())
		RecLock(cAlias,.F.)
		(cAlias)->GW3_OK  := oBrowse:Mark()
		(cAlias)->(MsUnLock())
	Else
		RecLock(cAlias,.F.)
		(cAlias)->GW3_OK  := ""
		(cAlias)->(MsUnLock())
	EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} xMarkAll()
// inverte a marcação de todos os itens

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------
static function xMarkAll()
	local lRet      :=  .T.
	local cAlias	:= oBrowse:Alias()
	local aRest		:= GetArea()

	(cAlias)->(DbGoTop())
	While (cAlias)->(!Eof())
		If (!oBrowse:IsMark())
			If (cAlias)->DIFER == 0
				RecLock(cAlias,.F.)
				(cAlias)->GW3_OK  := oBrowse:Mark()
				(cAlias)->(MsUnLock())
			EndIf
		Else
			RecLock(cAlias,.F.)
			(cAlias)->GW3_OK  := ""
			(cAlias)->(MsUnLock())
		EndIf
		(cAlias)->(DbSkip())
	EndDo

	RestArea(aRest)

	oBrowse:refresh(.F.)
Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} MGFGFE5201()
// Monta a Tabela Temporária

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return _aStrut
/*/
//-------------------------------------------------------------------

static function MGFGFE5201()
	local _aStruGW3 :=  {}
	local _aStrut   :=  {}
	local _aCampos  :=  {}
	local _ni       :=  0

	_aStruGW3	:= GW3->(DBSTRUCT())
	_aCampos    :=  {'GW3_FILIAL', 'GW3_CDESP', 'GW3_EMISDF', 'GW3_NRDF', 'GW3_SERDF', 'GW3_DTEMIS', 'GW3_SIT', 'GW3_VLDF', 'GW3_PCIMP', 'GW3_VLIMP'}

	aadd(_aStrut, {'GW3_OK','C',2 ,0})

	for _ni := 1 to len(_aStruGW3)
		if aScan(_aCampos, _aStruGW3[_ni][1]) > 0
			if _aStruGW3[_ni][1] == 'GW3_VLDF'
				aadd(_aStrut, _aStruGW3[_ni])
				aadd(_aStrut, {'VALCALC' ,'N',14,2})
			elseif _aStruGW3[_ni][1] == 'GW3_PCIMP'
				aadd(_aStrut, _aStruGW3[_ni])
				aadd(_aStrut, {'ALIQ' ,'N',5,2})
			elseif _aStruGW3[_ni][1] == 'GW3_VLIMP'
				aadd(_aStrut, _aStruGW3[_ni])
				aadd(_aStrut, {'IMP' ,'N',14,2})
			else
				aadd(_aStrut, _aStruGW3[_ni])
			endif
		endif
	next _ni


	aadd(_aStrut, {'DIFER' ,'N',2,0})


Return _aStrut


/*----------------------------------------------------------------------------------------------------
{Protheus.doc} MGFGFE5212
Função para criar o array da estrutura da msSelect

@sample
MGFGFE5212(aCmp)

@author Octávio Augusto Felippe de Macedo
@since 27/10/2011
@version 1.0
----------------------------------------------------------------------------------------------------*/

static function MGFGFE5212(cCmp, nOp)
	local aStru := {}
	local oStructX3	:= GFESeekSX():New()

	//Cria array com campos que serão mostrados em tela
	If cCmp == 1
		If nOp == 1
			oStructX3:SeekX3("GWL_FILDC")	
			aadd(aStru,  {"GWL_FILDC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWL_NRDC")	
			aadd(aStru,  {"GWL_NRDC" 	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWL_EMITDC")	
			aadd(aStru,  {"GWL_EMITDC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GU3_NMEMIT")	
			aadd(aStru,  {"GU3_NMEMIT"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWL_SERDC")	
			aadd(aStru,  {"GWL_SERDC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWL_TPDC")	
			aadd(aStru,  {"GWL_TPDC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWD_FILIAL")	
			aadd(aStru,  {"GWD_FILIAL"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWD_NROCO")	
			aadd(aStru,  {"GWD_NROCO"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWD_DSOCOR")	
			aadd(aStru,  {"GWD_DSOCOR"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWD_CDTIPO")	
			aadd(aStru,  {"GWD_CDTIPO"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GU5_DESC")	
			aadd(aStru,  {"GU5_DESC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWD_CDMOT")	
			aadd(aStru,  {"GWD_CDMOT"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GU6_DESC")	
			aadd(aStru,  {"GU6_DESC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})			
			aadd(aStru, {"GU5_ACAODF", "C", 25, 0})			
			aadd(aStru, {"GU5_BLQ", "C", 1, 0})					
		ElseIf nOp == 2
			oStructX3:SeekX3("GWL_FILDC")	
			aadd(aStru, {"GWL_FILDC"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWL_NRDC")	
			aadd(aStru, {"GWL_NRDC"		, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWL_EMITDC")	
			aadd(aStru, {"GWL_EMITDC"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GU3_NMEMIT")	
			aadd(aStru, {"GU3_NMEMIT"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWL_SERDC")	
			aadd(aStru, {"GWL_SERDC"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWL_TPDC")	
			aadd(aStru, {"GWL_TPDC"		, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWD_FILIAL")	
			aadd(aStru, {"GWD_FILIAL"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWD_NROCO")	
			aadd(aStru, {"GWD_NROCO"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWD_DSOCOR")	
			aadd(aStru, {"GWD_DSOCOR"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWD_CDTIPO")	
			aadd(aStru, {"GWD_CDTIPO"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GU5_DESC")	
			aadd(aStru, {"GU5_DESC"		, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWD_CDMOT")	
			aadd(aStru, {"GWD_CDMOT"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GU6_DESC")	
			aadd(aStru, {"GU6_DESC"		, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GU5_ACAODF")	
			aadd(aStru, {"GU5_ACAODF"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})

			aadd(aStru, {"GU5_BLQ"		, Nil, "Observação",})		
		EndIf
	ElseIf cCmp == 2
		If nOp == 1
			oStructX3:SeekX3("GWH_FILIAL")	
			aadd(aStru,  {"GWH_FILIAL"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWH_NRDC")	
			aadd(aStru,  {"GWH_NRDC" 	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWH_EMISDC")	
			aadd(aStru,  {"GWH_EMISDC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GU3_NMEMIT")	
			aadd(aStru,  {"GU3_NMEMIT"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWH_SERDC")	
			aadd(aStru,  {"GWH_SERDC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWH_CDTPDC")	
			aadd(aStru,  {"GWH_CDTPDC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
		ElseIf nOp == 2
			oStructX3:SeekX3("GWH_FILIAL")	
			aadd(aStru, {"GWH_FILIAL"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWH_NRDC")	
			aadd(aStru, {"GWH_NRDC"		, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWH_EMISDC")	
			aadd(aStru, {"GWH_EMISDC"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GU3_NMEMIT")	
			aadd(aStru, {"GU3_NMEMIT"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWH_SERDC")	
			aadd(aStru, {"GWH_SERDC"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWH_CDTPDC")	
			aadd(aStru, {"GWH_CDTPDC"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})			
		EndIf
	ElseIf cCmp == 3
		If nOp == 1
			oStructX3:SeekX3("GW4_FILIAL")	
			aadd(aStru,  {"GW4_FILIAL"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GW4_NRDC")	
			aadd(aStru,  {"GW4_NRDC" 	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GW4_EMISDC")	
			aadd(aStru,  {"GW4_EMISDC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GU3_NMEMIT")	
			aadd(aStru,  {"GU3_NMEMIT"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GW4_SERDC")	
			aadd(aStru,  {"GW4_SERDC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GW4_TPDC")	
			aadd(aStru,  {"GW4_TPDC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
		ElseIf nOp == 2
			oStructX3:SeekX3("GW4_FILIAL")	
			aadd(aStru, {"GW4_FILIAL"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GW4_NRDC")	
			aadd(aStru, {"GW4_NRDC"		, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GW4_EMISDC")	
			aadd(aStru, {"GW4_EMISDC"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GU3_NMEMIT")	
			aadd(aStru, {"GU3_NMEMIT"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GW4_SERDC")	
			aadd(aStru, {"GW4_SERDC"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GW4_TPDC")	
			aadd(aStru, {"GW4_TPDC"		, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})			
		EndIf
	ElseIf cCmp == 4
		If nOp == 1
			oStructX3:SeekX3("GWF_FILIAL")	
			aadd(aStru,  {"GWF_FILIAL"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWF_NRCALC")	
			aadd(aStru,  {"GWF_NRCALC" 	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWI_VLFRET")	
			aadd(aStru,  {"GWI_VLFRET"	,"N",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWF_TPCALC")	
			aadd(aStru,  {"GWF_TPCALC"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWF_ORIGEM")	
			aadd(aStru,  {"GWF_ORIGEM"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWF_FINCAL")	
			aadd(aStru,  {"GWF_FINCAL"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWF_NRROM")	
			aadd(aStru,  {"GWF_NRROM"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWF_TPTRIB")	
			aadd(aStru,  {"GWF_TPTRIB"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWF_IMPOST")	
			aadd(aStru,  {"GWF_IMPOST"	,"C",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWF_VLISS")	
			aadd(aStru,  {"GWF_VLISS"	,"N",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})
			oStructX3:SeekX3("GWF_VLICMS")	
			aadd(aStru,  {"GWF_VLICMS"	,"N",oStructX3:getX3Tamanho(),oStructX3:getX3Decimal()})				
		ElseIf nOp == 2
			oStructX3:SeekX3("GWF_FILIAL")	
			aadd(aStru, {"GWF_FILIAL"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWF_NRCALC")	
			aadd(aStru, {"GWF_NRCALC"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWI_VLFRET")	
			aadd(aStru, {"GWI_VLFRET"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWF_TPCALC")	
			aadd(aStru, {"GWF_TPCALC"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWF_ORIGEM")	
			aadd(aStru, {"GWF_ORIGEM"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWF_FINCAL")	
			aadd(aStru, {"GWF_FINCAL"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWF_NRROM")	
			aadd(aStru, {"GWF_NRROM"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWF_TPTRIB")	
			aadd(aStru, {"GWF_TPTRIB"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWF_IMPOST")	
			aadd(aStru, {"GWF_IMPOST"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWF_VLISS")	
			aadd(aStru, {"GWF_VLISS"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
			oStructX3:SeekX3("GWF_VLICMS")	
			aadd(aStru, {"GWF_VLICMS"	, Nil, oStructX3:getX3Titulo(),oStructX3:getX3Picture()})
		EndIf
	EndIf
	oStructX3:Destroy()


Return aStru




//-------------------------------------------------------------------
/*/{Protheus.doc} CalcDif()
Calcula a diferença entres os valores do frete e o valor 
calculado.

@author Cláudio Alves
@since 07/10/2019
@version 1.0
----------------------------------------------------------------------------------------------------*/

static function CalcDif(iValor1, iValor2)
	(cAliMKB)->DIF := iValor1 - iValor2
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} AbaixoTol()
Verifica se a diferença da linha está 
abaixo da tolerância permitida

@author Cláudio Alves
@since 07/10/2019
@version 1.0
----------------------------------------------------------------------------------------------------*/
static function AbaixoTol()
        local lRet := .T.
        local nPorc 
        
        //Caso o campo não seja obrigatório, não cria background vermelho no record do grid
	If AllTrim( (cAliMKB)->OBRIGAT ) != "X"
            Return .F.
	EndIf
        
	If (cAliMKB)->DIF == 0
             Return .F.
	EndIf
        
        //Apenas os campos "Frete Unidade\Frete Valor\Taxas\Valor do Pedágio\Valor total do Frete\Valor do Imposto" são utilizados a tolerancia
	If AllTrim((cAliMKB)->CAMPO)$ "Frete Unidade\Frete Valor\Taxas\Valor do Pedágio\Valor total do Frete\Valor do Imposto"
            /*Faz uma verificaçãode que se o paramtro MV_DCNEG esta setado como "Sim" e o a Variavel nInfo for menor que o valor do calculo
            então Indica que os valores dos documentos de frete menores que os valores calculados
            pelo sistema não serão considerados como divergência na conferência se estiver como "Não" cai na condição Else*/ 
		If GETNEWPAR('MV_DCNEG',"N") $ "1S" .And. (cAliMKB)->VALOR1 < (cAliMKB)->VALOR2
                lRet := .F.
		Else
			If !Empty(GetMv('MV_DCVAL')) .And. !Empty(GetMv('MV_DCPERC')) /*Faz uma verificação para os parametros MV_DCVAL e MV_DCPERC para verificar se eles estejam em branco*/
                    nPorc := (GetMv('MV_DCPERC') / 100) * (cAliMKB)->VALOR2 /*Faz o calculo para achar o percentual aonde ele Divide o parametro MV_DCPERC por 100 e logo após multiplica ele pelo Valor do Calculo*/
				If (abs((cAliMKB)->DIF) <= nPorc ) .And. abs((cAliMKB)->DIF) <= GetMv('MV_DCVAL') /*Verifica se a difença é menor que o percentual e ao mesmo tempo se ela é menor que o parametro MV_DCVAL*/
                        lRet := .F.
				Endif
			Endif
		Endif
            /*abs(<Valor>) - função que retira o sinal de negativo do campo*/
	Else
		If (cAliMKB)->DIF == 0
                lRet := .F.
		EndIf
	EndIf
Return lRet



//-------------------------------------------------------------------
/*/{Protheus.doc} LoadDocRelac()
Carregando os documentos relacionados

@author Cláudio Alves
@since 07/10/2019
@version 1.0
----------------------------------------------------------------------------------------------------*/
static function LoadDocRelac(_FILIAL, _CDESP, _EMISDF, _SERDF, _NRDF, _DTEMIS)
	local aCpCalc
	local aCpDCDF
	local aCpDCCL
	local _cFim         :=  CHR(13) + CHR(10)

	If lLoadDocRelac
		Return
	EndIf
	
	oFolder:aDialogs[2]:cTitle := "Carregando..."
	oFolder:aDialogs[2]:Refresh()
	
	CursorWait()
	
	ProcessMessage()

	dbSelectArea("GW3")
	dbSetOrder(1)

	GW3->(dbSeek(_FILIAL + _CDESP + _EMISDF + _SERDF + _NRDF + DTOS(_DTEMIS)))
	
	cDCDF := GFECriaTab( {MGFGFE5212(3, 1), {"GW4_FILIAL+GW4_EMISDC+GW4_TPDC+GW4_SERDC+GW4_NRDC"}})
	cDCCL := GFECriaTab( {MGFGFE5212(2, 1), {"GWH_FILIAL+GWH_EMISDC+GWH_CDTPDC+GWH_SERDC+GWH_NRDC"}})
	cCalc := GFECriaTab( {MGFGFE5212(4, 1), {"GWF_FILIAL+GWF_NRCALC"}})
	
  	aCpCalc := MGFGFE5212(4,2)
	
	cAliCalc := GetNextAlias()
	
 	
		cQuery := "SELECT DISTINCT GWF.GWF_FILIAL, GWF.GWF_NRCALC, " + _cFim
		cQuery += "		(SELECT SUM(GWI_VLFRET) FROM " + RetSQLName("GWI") + " GWI " + _cFim
		cQuery += "			WHERE GWI.GWI_FILIAL = '" + GW3->GW3_FILIAL + "' AND GWI.GWI_NRCALC = GWF.GWF_NRCALC AND GWI.GWI_TOTFRE = '1' " + _cFim
		cQuery += "         AND GWI.D_E_L_E_T_ = ' ' " + _cFim
		cQuery += "			GROUP BY GWI.GWI_NRCALC " + _cFim
		cQuery += "     ) + GWF.GWF_VLAJUS AS GWI_VLFRET, "	 + _cFim
		cQuery += 		MGFGFE5213("GWF", "GWF_TPCALC", "GWF_TPCALC", "'Nenhum'") + ", " + _cFim
		cQuery += 		MGFGFE5213("GWF", "GWF_ORIGEM", "GWF_ORIGEM", "'Nenhum'") + ", " + _cFim
		cQuery += 		MGFGFE5213("GWF", "GWF_FINCAL", "GWF_FINCAL", "'Nenhum'") + ", " + _cFim
		cQuery += 		"GWF.GWF_NRROM, " + _cFim
		cQuery += 		MGFGFE5213("GWF", "GWF_TPTRIB", "GWF_TPTRIB", "'Nenhum'") + ", " + _cFim
		cQuery += 		MGFGFE5213("GWF", "GWF_IMPOST", "GWF_IMPOST", "'Nenhum'") + ", " + _cFim
		cQuery += 		"GWF.GWF_VLISS, GWF.GWF_VLICMS " + _cFim
		cQuery += "FROM " + RetSQLName("GWF") + " GWF " + _cFim
		cQuery += "		INNER JOIN " + RetSQLName("GWH") + " GWH ON GWH.GWH_FILIAL = '" + GW3->GW3_FILIAL + "' AND GWH.GWH_NRCALC = GWF.GWF_NRCALC "	 + _cFim
		cQuery += "		INNER JOIN " + RetSQLName("GW4") + " GW4 ON GW4.GW4_FILIAL = '" + GW3->GW3_FILIAL + "' AND GW4.GW4_TPDC = GWH.GWH_CDTPDC AND GW4.GW4_EMISDC = GWH.GWH_EMISDC " + _cFim
		cQuery += "											 AND GW4.GW4_SERDC = GWH.GWH_SERDC AND GW4.GW4_NRDC = GWH.GWH_NRDC " + _cFim
		cQuery += "WHERE GW4.GW4_FILIAL = '" + GW3->GW3_FILIAL + "' AND GW4.GW4_CDESP = '" + GW3->GW3_CDESP + "' AND GW4.GW4_EMISDF = '" + GW3->GW3_EMISDF + "' AND GW4.GW4_SERDF = '" + GW3->GW3_SERDF + "' AND GW4.GW4_NRDF = '" + GW3->GW3_NRDF + "' AND GW4.GW4_DTEMIS = '" + DTOS(GW3->GW3_DTEMIS) + "'"  + _cFim
		cQuery += "		 AND GWF.GWF_FILIAL = '" + GW3->GW3_FILIAL + "' AND  GWF.GWF_TPCALC = '" + GW3->GW3_TPDF + "' " + _cFim
		cQuery += "		 AND GWF.D_E_L_E_T_ = ' ' AND GWH.D_E_L_E_T_ = ' ' AND GW4.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY GWF.GWF_NRCALC " + _cFim

		memowrite("c:\temp\MGFclaudio_LoadDocRelac01.TXT", cQuery  )

		cQuery := ChangeQuery(strTran(cQuery, _cFim, ''))

	//	cQuery := ChangeQuery(cQuery)
	
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cAliCalc, .F., .T.)
	
	//------DC'S DO DOCUMENTO DE FRETE
	
	aCpDCDF := MGFGFE5212(3,2)
	
	cAliDCDF := GetNextAlias()
	
	cQuery := "SELECT GW4.GW4_FILIAL, GW4.GW4_NRDC, GW4.GW4_EMISDC, " + _cFim
	cQuery += "		(SELECT GU3.GU3_NMEMIT FROM " + RetSQLName("GU3") + " GU3 " + _cFim
	cQuery += " 		WHERE GU3.GU3_FILIAL = '" + GW3->GW3_FILIAL + "' AND GU3.GU3_CDEMIT = GW4.GW4_EMISDC AND GU3.D_E_L_E_T_ = ' ' " + _cFim
	cQuery += "		) GU3_NMEMIT, " + _cFim
	cQuery += "		GW4.GW4_SERDC, GW4." + SerieNfId("GW4",3,"GW4_SERDC") + ", GW4.GW4_TPDC " + _cFim
	cQuery += "FROM " + RetSQLName("GW4") + " GW4 " + _cFim
	cQuery += "WHERE GW4.GW4_FILIAL = '" + GW3->GW3_FILIAL + "' AND GW4.GW4_CDESP = '" + GW3->GW3_CDESP + "' AND GW4.GW4_EMISDF = '" + GW3->GW3_EMISDF + "' AND GW4.GW4_SERDF = '" + GW3->GW3_SERDF + "' AND GW4.GW4_NRDF = '" + GW3->GW3_NRDF + "' AND GW4.GW4_DTEMIS = '" + DTOS(GW3->GW3_DTEMIS) + "'" + _cFim
	cQuery += "		AND GW4.D_E_L_E_T_ = ' ' AND GW4.GW4_FILIAL = '" + GW3->GW3_FILIAL + "' " + _cFim
	cQuery += "ORDER BY GW4.GW4_FILIAL, GW4.GW4_NRDC " + _cFim
	
	memowrite("c:\temp\MGFclaudio_LoadDocRelac02.TXT", cQuery  )

	cQuery := ChangeQuery(strTran(cQuery, _cFim, ''))
	
	// cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cAliDCDF, .F., .T.)
	
	//------DC'S DO CáLCULO DE FRETE
	
	aCpDCCL := MGFGFE5212(2,2)
	
	cAliDCCL := GetNextAlias()
	
	
		cQuery := "SELECT GWH.GWH_FILIAL, GWH.GWH_NRDC, GWH.GWH_EMISDC, " + _cFim
	  	cQuery += "		(SELECT GU3.GU3_NMEMIT FROM " + RetSQLName("GU3") + " GU3 " + _cFim
		cQuery += "			WHERE GU3.GU3_FILIAL = '" + GW3->GW3_FILIAL + "' AND GU3.GU3_CDEMIT = GWH.GWH_EMISDC AND GU3.D_E_L_E_T_ = ' ' " + _cFim
	 	cQuery += "		) GU3_NMEMIT, " + _cFim
		cQuery += "		GWH.GWH_SERDC, GWH." + SerieNfId("GWH",3,"GWH_SERDC") + ", GWH.GWH_CDTPDC " + _cFim
		cQuery += "FROM " + RetSQLName("GWH") + " GWH " + _cFim
	 	cQuery += "WHERE GWH.D_E_L_E_T_ = ' ' AND GWH.GWH_FILIAL = '" + GW3->GW3_FILIAL + "' AND GWH.GWH_NRCALC IN " + _cFim
	 	cQuery += "		 (SELECT DISTINCT GWF.GWF_NRCALC " + _cFim
	 	cQuery += "		  FROM " + RetSQLName("GWF") + " GWF " + _cFim
	 	cQuery += "			INNER JOIN " + RetSQLName("GWH") + " GWHSUB ON GWHSUB.GWH_FILIAL = '" + GW3->GW3_FILIAL + "' AND GWHSUB.GWH_NRCALC = GWF.GWF_NRCALC " + _cFim
	 	cQuery += "			INNER JOIN " + RetSQLName("GW4") + " GW4 ON GW4.GW4_FILIAL = '" + GW3->GW3_FILIAL + "' AND GW4.GW4_TPDC = GWHSUB.GWH_CDTPDC " + _cFim
	 	cQuery += " 													   AND GW4.GW4_EMISDC = GWHSUB.GWH_EMISDC AND GW4.GW4_SERDC = GWHSUB.GWH_SERDC "  + _cFim
		cQuery += "									     				   AND GW4.GW4_NRDC = GWHSUB.GWH_NRDC " + _cFim
	 	cQuery += "		  WHERE GW4.GW4_FILIAL = '" + GW3->GW3_FILIAL + "' AND GW4.GW4_CDESP = '" + GW3->GW3_CDESP + "' AND GW4.GW4_EMISDF = '" + GW3->GW3_EMISDF + "' AND GW4.GW4_SERDF = '" + GW3->GW3_SERDF + "' AND GW4.GW4_NRDF = '" + GW3->GW3_NRDF + "' AND GW4.GW4_DTEMIS = '" + DTOS(GW3->GW3_DTEMIS) + "'" + _cFim
	   	cQuery += "             AND GWF.GWF_TPCALC = '" + GW3->GW3_TPDF + "' AND GWF.GWF_FILIAL = '" + GW3->GW3_FILIAL + "' " + _cFim
		cQuery += "		    	AND GWF.D_E_L_E_T_ = ' ' AND GWHSUB.D_E_L_E_T_ = ' ' AND GW4.D_E_L_E_T_ = ' ' " + _cFim
	 	cQuery += "		 ) " + _cFim
	 	cQuery += "ORDER BY GWH.GWH_FILIAL, GWH.GWH_NRDC " + _cFim
	
		 memowrite("c:\temp\MGFclaudio_LoadDocRelac03.TXT", cQuery  )

		 cQuery := ChangeQuery(strTran(cQuery, _cFim, ''))
		 
		//  cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cAliDCCL, .F., .T.)
	
	//-------------
	
	oSplitter := tSplitter():New( 0,0,oFolder:ADialogs[2],50,50,1 )
		oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
	
	oPanelE := TPanel():New(01,01,,oSplitter,,,,,,30,30,.F.,.T.)
		oPanelE:Align := CONTROL_ALIGN_TOP		
	
	oPanelF := TPanel():New(0,0,,oSplitter,,,,,,30,30,.F.,.T.)
		oPanelF:Align := CONTROL_ALIGN_BOTTOM
	
	oFolderA := TFolder():New(0,0,{"Documentos de Carga do Documento de Frete"},{"HEADER 1"},oPanelF,,,,.T.,,oPanelF:oWnd:nWidth/4,200,)

	oFolderA:Align := CONTROL_ALIGN_LEFT
	
	oFolderB := TFolder():New(0,0,{"Documentos de Carga do Cálculo de Frete"},{"HEADER 1"},oPanelF,,,,.T.,,0,0,)
	oFolderB:Align := CONTROL_ALIGN_ALLCLIENT
	
	MGFGFE5214(cAliCalc, cCalc, aCalc)
	MGFGFE5214(cAliDCDF, cDCDF, aDCDF)
	MGFGFE5214(cAliDCCL, cDCCL, aDCCL)	
	
	dbSelectArea(cCalc)
	(cCalc)->( dbGoTop() )
	
	
	cGrdCalc := MsSelect():New(cCalc,"",,aCpCalc,,,{0,0,0,0},,,oPanelE)
	cGrdCalc:oBrowse:cToolTip := "Cálculos de Frete dos Documentos de Carga" //
	cGrdCalc:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	cGrdCalc:oBrowse:lAdjustColSize := .T.
	
	cGrdCalc:oBrowse:lVisibleControl := .T.
	cGrdCalc:oBrowse:lVisible := .T.
	cGrdCalc:oBrowse:nHeight  := 251
	cGrdCalc:oBrowse:nRight   := 90
	cGrdCalc:oBrowse:nWidth   := 90

	dbSelectArea(cDCDF)
	(cDCDF)->( dbSetOrder(1) )
	(cDCDF)->( dbGoTop() )
	cGrdDCDF := MsSelect():New(cDCDF,"",,aCpDCDF,,,{0,0,0,0},,,oFolderA:aDialogs[1])
	cGrdDCDF:oBrowse:cToolTip := "Documentos de Carga do Documento de Frete" //
	cGrdDCDF:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	cGrdDCDF:oBrowse:lAdjustColSize := .T.	
	
	cGrdDCDF:oBrowse:lVisibleControl := .T.
	cGrdDCDF:oBrowse:lVisible := .T.
	cGrdDCDF:oBrowse:nHeight  := 251
	cGrdDCDF:oBrowse:nRight   := 80
	cGrdDCDF:oBrowse:nWidth   := 80
	
	dbSelectArea(cDCCL)
	(cDCCL)->( dbSetOrder(1) )
	(cDCCL)->( dbGoTop() )
	cGrdDCCL := MsSelect():New(cDCCL,"",,aCpDCCL,,,{0,0,0,0},,,oFolderB:aDialogs[1])
	cGrdDCCL:oBrowse:cToolTip := "Documentos de Carga dos Cálculos de Frete" //
	cGrdDCCL:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	cGrdDCCL:oBrowse:lVisibleControl := .T.
	cGrdDCCL:oBrowse:lVisible := .T.
	cGrdDCCL:oBrowse:nHeight  := 251
	cGrdDCCL:oBrowse:nRight   := 80
	cGrdDCCL:oBrowse:nWidth   := 80
	
	cGrdCalc:oBrowse:Refresh()
	cGrdDCDF:oBrowse:Refresh()
	cGrdDCCL:oBrowse:Refresh()
	
	lLoadDocRelac := .T.
	
	CursorArrow()
	oFolder:aDialogs[2]:cTitle := "Documentos"
Return




//-------------------------------------------------------------------
/*/{Protheus.doc} MGFGFE5214()
Carregando os documentos relacionados

@author Cláudio Alves
@since 07/10/2019
@version 1.0
----------------------------------------------------------------------------------------------------*/
static function MGFGFE5214(cAliDe, cAliPara, aCmp)
	local nCount	
	dbSelectArea(cAliDe)
	(cAliDe)->( dbGoTop() )
	While !(cAliDe)->( Eof() )
		RecLock(cAliPara, .T.)
		
		For nCount := 1 To Len(aCmp)
				(cAliPara)->&(aCmp[nCount]) := (cAliDe)->&(aCmp[nCount])
		Next nCount
		(cAliPara)->(MsUnLock())
		
		dbSelectArea(cAliDe)
		(cAliDe)->( dbSkip() )
	EndDo
	                 
	dbSelectArea(cAliPara)
	(cAliPara)->( dbGoTop() )
	
	GFEDelTab(cAliDe)
Return
           
//-------------------------------------------------------------------
/*/{Protheus.doc} MGFGFE5208()
Montando a tabela de qtdes em relação aos fretes.

@author Cláudio Alves
@since 07/10/2019
@version 1.0
----------------------------------------------------------------------------------------------------*/
static function MGFGFE5208(_FILIAL, _CDESP, _EMISDF, _SERDF, _NRDF, _DTEMIS)
// Dados dos Documentos (MV_DCOUT)
local iQT_VOL		:= 0	// Quantidade de Volumes
local iPESO_REAL	:= 0   // Peso Real
local iPESO_CUBA	:= 0   // Peso Cubado
local iVOLUME		:= 0   // Volume
local iVALOR		:= 0   // Valor dos Itens

	
// Valores Detalhados (MV_DCABE)
local iFRET_UNID	:= 0	// Frete Unidade
local iFRET_VAL	:= 0	// Frete Valor
local iTAXAS		:= 0	// Taxas
local iVAL_PEDA	:= 0	// Valor do Pedágio	

// Valor Total (MV_DCTOT)
local iVAL_FRETE	:= 0   // Valor do Frete
local iALIQUOTA	:= 0	// Alíquota
local iVAL_IMPO	:= 0	// Valor do Imposto (ICMS ou ISS)	

//Valor de ajuste
local iVAL_VLAJUS	:= 0

local lUnitiz		:= .F. // Possui Unitizador (GWB)
local lObrigat	:= ""	// Grupo de Valores Obrigatórios
local lRet := .T.
local cQuery

local aArea		:= GetArea()
local aAreaGW1	:= GW1->( GetArea() )
local aAreaGW3	:= GW3->( GetArea() )
local aAreaGW4	:= GW4->( GetArea() )
local aAreaGWB	:= GWB->( GetArea() )
local aAreaGW8	:= GW8->( GetArea() )
local aAreaGUG	:= GUG->( GetArea() )
local aAreaGWH	:= GWH->( GetArea() )
local aAreaGWI	:= GWI->( GetArea() )
local aAreaGWF	:= GWF->( GetArea() )
local aAreaGV2	:= GV2->( GetArea() )
local nAliqISS 
local aCalcRel   := {}
local s_VLCNPJ  := SuperGetMV('MV_VLCNPJ',,'1')	
local _cFim         :=  CHR(13) + CHR(10)

nAliqISS := 0 

MGFGFE5214(cAliOcor, cOcor, aOcor)



dbSelectArea("GW3")
dbSetOrder(1)
dbSeek(_FILIAL + _CDESP + _EMISDF + _SERDF + _NRDF+DTOS(_DTEMIS))


dbSelectArea("GW4")
dbSetOrder(1)

dbSeek(GW3->GW3_FILIAL+GW3->GW3_EMISDF+GW3->GW3_CDESP+GW3->GW3_SERDF+GW3->GW3_NRDF+DTOS(GW3->GW3_DTEMIS))
	While !GW4->( Eof() ) .And. GW4->GW4_FILIAL+GW4->GW4_EMISDF+GW4->GW4_CDESP+GW4->GW4_SERDF+GW4->GW4_NRDF+DTOS(GW4->GW4_DTEMIS) == ;
	GW3->GW3_FILIAL+GW3->GW3_EMISDF+GW3->GW3_CDESP+GW3->GW3_SERDF+GW3->GW3_NRDF+DTOS(GW3->GW3_DTEMIS) .And. lRet == .T. 
		
		/* GW1 para pegar os valores de volume*/
		dbSelectArea("GW1")
		dbSetOrder(1)
			If dbSeek(GW3->GW3_FILIAL+GW4->GW4_TPDC+GW4->GW4_EMISDC+GW4->GW4_SERDC+GW4->GW4_NRDC)
			/* GWB */
			dbSelectArea("GWB")
			dbSetOrder(2)
			dbSeek(GW3->GW3_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC)
			While !GWB->( Eof() ) .And. GWB->GWB_FILIAL+GWB->GWB_CDTPDC+GWB->GWB_EMISDC+GWB->GWB_SERDC+GWB->GWB_NRDC == ;
				GW3->GW3_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC 
						
				lUnitiz := .T.
				
				iQT_VOL := iQT_VOL + GWB->GWB_QTDE
				
				dbSelectArea("GUG")
				dbSetOrder(1)
					If dbSeek(GW3->GW3_FILIAL+GWB->GWB_CDUNIT)
					iVOLUME    := iVOLUME    + GUG->GUG_VOLUME*GWB->GWB_QTDE
				EndIf
				
				dbSelectArea("GWB")	
				dbSkip()
			EndDo
		EndIf

		
		/* GWH */
		dbSelectArea("GWH")
		dbSetOrder(2)
		dbSeek(GW3->GW3_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC)
		While !GWH->( Eof() ) .And. ;
				GW3->GW3_FILIAL+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC == ;
			   	GWH->GWH_FILIAL+GWH->GWH_CDTPDC+GWH->GWH_EMISDC+GWH->GWH_SERDC+GWH->GWH_NRDC
			
				If AScan(aCalcRel, {|x| x == GWH->GWH_NRCALC}) > 0
					dbSelectArea("GWH")
					GWH->( dbSkip() )
					Loop
			EndIf
		
				dbSelectArea("GWF")
				GWF->( dbSetOrder(1) )
			If (GWF->( dbSeek(GW3->GW3_FILIAL + GWH->GWH_NRCALC) ) .And. ;
				GW3->GW3_EMISDF == GWF->GWF_TRANSP .And. GW3->GW3_TPDF == GWF->GWF_TPCALC);
				.or. (s_VLCNPJ == "2" .AND. ;
				SubStr(Posicione("GU3", 1, GW3->GW3_FILIAL +GW3->GW3_EMISDF, "GU3->GU3_IDFED"), 1, 8) == ;
				SubStr(Posicione("GU3", 1, GW3->GW3_FILIAL + GWF->GWF_TRANSP, "GU3->GU3_IDFED"), 1, 8) .And. ;
				GW3->GW3_TPDF == GWF->GWF_TPCALC )
					
					MGFGFE5210(@aCalcRel,@iVAL_VLAJUS,@iVAL_FRETE,@iFRET_UNID,@iFRET_VAL,@iTAXAS,@iVAL_PEDA,@iALIQUOTA,@iVAL_IMPO,GWF->GWF_NRCALC,GW3->GW3_FILIAL)
							
				EndIf
			
			dbSelectArea("GWH")
			GWH->( dbSkip() )
		EndDo
		
	
	dbSelectArea("GW4")
	GW4->( dbSkip() )
	EndDo

cAliTotGW8 := GetNextAlias()


cQuery := "SELECT " + _cFim
cQuery += "    SUM(GW8_PESOR) AS TOT_PESOR, SUM(GW8_PESOC) AS TOT_PESOC, SUM(GW8_VALOR) AS TOT_VALOR " + _cFim
	If !lUnitiz
	cQuery += ", SUM(GW8_QTDE) AS TOT_QTDE, SUM(GW8_VOLUME) AS TOT_VOLUME " + _cFim
	EndIf
cQuery += "FROM " + RetSQLName("GW4") + " GW4 " + _cFim
cQuery += "INNER JOIN " + RetSQLName("GW8") + " GW8 ON " + _cFim
cQuery += "GW8_FILIAL = GW4_FILIAL AND  " + _cFim
cQuery += "GW8_CDTPDC = GW4_TPDC   AND " + _cFim
cQuery += "GW8_EMISDC = GW4_EMISDC AND " + _cFim
cQuery += "GW8_SERDC  = GW4_SERDC  AND " + _cFim
cQuery += "GW8_NRDC   = GW4_NRDC   AND " + _cFim
cQuery += "GW8.D_E_L_E_T_ = '' " + _cFim
cQuery += "WHERE " + _cFim
cQuery += "GW4_FILIAL = '" 	+ _cFilial		+ "' AND " + _cFim
cQuery += "GW4_EMISDF = '" 	+ _cEmisdf		+ "' AND " + _cFim
cQuery += "GW4_CDESP = '" 	+ _cDesp		+ "' AND " + _cFim
cQuery += "GW4_SERDF = '" 	+ _cSerdf		+ "' AND " + _cFim
cQuery += "GW4_NRDF	= '" 	+ _cNrdf			+ "' AND " + _cFim
cQuery += "GW4_DTEMIS = '" 	+ DTOS(_dDtemis)	+ "' AND " + _cFim
cQuery += "GW4.D_E_L_E_T_ = '' " 

memowrite("c:\temp\MGFclaudio_MGFGFE5208.TXT", cQuery  )

cQuery := ChangeQuery(strTran(cQuery, _cFim, ''))

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cAliTotGW8, .F., .T.)

dbSelectArea(cAliTotGW8)
(cAliTotGW8)->( dbGoTop() )
	If !(cAliTotGW8)->(Eof()) .And. lRet
		If !lUnitiz
		iQT_VOL := iQT_VOL    + (cAliTotGW8)->TOT_QTDE
		iVOLUME := iVOLUME 	 + (cAliTotGW8)->TOT_VOLUME
		EndIf
			
	iPESO_REAL := (cAliTotGW8)->TOT_PESOR
	iPESO_CUBA := (cAliTotGW8)->TOT_PESOC
	iVALOR     := (cAliTotGW8)->TOT_VALOR
	EndIf

dbSelectArea(cAliMKB)
ZAP

// *** Dados dos Documentos	*******************************

	If GetNewPar('MV_DCOUT','N') $ "1S"
	lObrigat := "X"
	EndIf

/* Quantidade de Volumes  */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Quantidade de Volumes" //"Quantidade de Volumes"
(cAliMKB)->VALOR1  	 := GW3->GW3_QTVOL
(cAliMKB)->VALOR2  	 := iQT_VOL
CalcDif(GW3->GW3_QTVOL, iQT_VOL)
(cAliMKB)->(MsUnLock())

/* Peso Real  */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Peso Real" //
(cAliMKB)->VALOR1  	 := GW3->GW3_PESOR
(cAliMKB)->VALOR2  	 := iPESO_REAL
CalcDif(GW3->GW3_PESOR, iPESO_REAL)
(cAliMKB)->(MsUnLock())

/* Peso Cubado  */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Peso Cubado" //"Peso Cubado"
(cAliMKB)->VALOR1  	 := GW3->GW3_PESOC
(cAliMKB)->VALOR2  	 := iPESO_CUBA
CalcDif(GW3->GW3_PESOC, iPESO_CUBA)
(cAliMKB)->(MsUnLock())

/* Volume  */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Volume" //"Volume"
(cAliMKB)->VALOR1  	 := GW3->GW3_VOLUM
(cAliMKB)->VALOR2  	 := iVOLUME
CalcDif(GW3->GW3_VOLUM, iVOLUME)
(cAliMKB)->(MsUnLock())

/* Valor dos Itens  */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Valor dos Itens" //"Valor dos Itens"
(cAliMKB)->VALOR1  	 := GW3->GW3_VLCARG
(cAliMKB)->VALOR2  	 := iVALOR
CalcDif(GW3->GW3_VLCARG, iVALOR)
(cAliMKB)->(MsUnLock())

// *** Valores Detalhados	*******************************
lObrigat := ""	
	If GetNewPAr('MV_DCABE','N') $ "1S"
	lObrigat := "X"
	EndIf

/* Frete Unidade  */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Frete Unidade" //"Frete Unidade"
(cAliMKB)->VALOR1  	 := GW3->GW3_FRPESO
(cAliMKB)->VALOR2  	 := iFRET_UNID
CalcDif(GW3->GW3_FRPESO, iFRET_UNID)
(cAliMKB)->(MsUnLock())

/* Frete Valor  */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Frete Valor" //"Frete Valor"
(cAliMKB)->VALOR1  	 := GW3->GW3_FRVAL
(cAliMKB)->VALOR2  	 := iFRET_VAL
CalcDif(GW3->GW3_FRVAL, iFRET_VAL)
(cAliMKB)->(MsUnLock())

/* Taxas */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Taxas" //"Taxas"
(cAliMKB)->VALOR1  	 := GW3->GW3_TAXAS
(cAliMKB)->VALOR2  	 := iTAXAS
CalcDif(GW3->GW3_TAXAS, iTAXAS)
(cAliMKB)->(MsUnLock())

/* Valor do Pedágio */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Valor do Pedágio" //"Valor do Pedágio"
(cAliMKB)->VALOR1  	 := GW3->GW3_PEDAG
(cAliMKB)->VALOR2  	 := iVAL_PEDA
CalcDif(GW3->GW3_PEDAG, iVAL_PEDA)
(cAliMKB)->(MsUnLock())

// *** Valores Total 		*******************************
lObrigat := ""
	If GetNewPar('MV_DCTOT','N') $ "1S"
	lObrigat := "X"
	EndIf

/* Valor Total do Frete */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Valor total do Frete" //"Valor total do Frete"
(cAliMKB)->VALOR1  	 := GW3->GW3_VLDF
(cAliMKB)->VALOR2  	 := iVAL_FRETE
CalcDif(GW3->GW3_VLDF, iVAL_FRETE)
(cAliMKB)->(MsUnLock())

/* Alíquota */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Alíquota" //"Alíquota"
(cAliMKB)->VALOR1  	 := GW3->GW3_PCIMP
(cAliMKB)->VALOR2  	 := iALIQUOTA
CalcDif(GW3->GW3_PCIMP, iALIQUOTA)
(cAliMKB)->(MsUnLock())

/* Valor do Imposto */
RecLock((cAliMKB),.T.)
(cAliMKB)->OBRIGAT 	 := lObrigat
(cAliMKB)->CAMPO  	 := "Valor do Imposto" //"Valor do Imposto"
(cAliMKB)->VALOR1  	 := GW3->GW3_VLIMP
(cAliMKB)->VALOR2  	 := iVAL_IMPO
CalcDif(GW3->GW3_VLIMP, iVAL_IMPO)
(cAliMKB)->(MsUnLock())

/* Valor de ajuste de frete */
	If iVAL_VLAJUS > 0
	RecLock((cAliMKB),.T.)
	(cAliMKB)->OBRIGAT 	 := lObrigat
	(cAliMKB)->CAMPO  	 := "Valor do Ajuste" //"Valor do Ajuste"
	(cAliMKB)->VALOR1  	 := 0
	(cAliMKB)->VALOR2  	 := iVAL_VLAJUS
	(cAliMKB)->DIF 		 := 0
	(cAliMKB)->(MsUnLock())
	EndIf

RestArea(aAreaGW1)
RestArea(aAreaGW3)
RestArea(aAreaGW4)
RestArea(aAreaGWB)
RestArea(aAreaGW8)
RestArea(aAreaGUG)
RestArea(aAreaGWH)
RestArea(aAreaGWI)
RestArea(aAreaGWF)
RestArea(aAreaGV2)
RestArea(aArea)

Return .T.



/*----------------------------------------------------------------------------------------------------
{Protheus.doc} MGFGFE5210
Soma valores do cálculo de frete.

@author Cláudio Alves
@since 07/10/2019
@version 1.0
------------------------------------------------------------------------------------------------------*/
static function MGFGFE5210(aCalcRel,iVAL_VLAJUS,iVAL_FRETE,iFRET_UNID,iFRET_VAL,iTAXAS,iVAL_PEDA,iALIQUOTA,iVAL_IMPO,nNrCalc, filGw3)

	aadd(aCalcRel, GWF->GWF_NRCALC)
	iVAL_VLAJUS += GWF->GWF_VLAJUS
	iVAL_FRETE  += GWF->GWF_VLAJUS
	
	dbSelectArea("GWI")
	dbSetOrder(1)
	
	//GWI_FILIAL+GWI_NRCALC+GWI_CDCLFR+GWI_CDTPOP+GWI_CDCOMP
	GWI->(dbSeek(filGw3+nNrCalc))
	While !GWI->( Eof() ) .And. filGw3+nNrCalc == GWI->GWI_FILIAL+GWI->GWI_NRCALC
		
		// GV2 - Componente de Frete
		dbSelectArea("GV2")
		dbSetOrder(1)
		dbSeek(xFilial("GV2")+GWI->GWI_CDCOMP)
		If GWI->GWI_TOTFRE == "1"
			// Valor Total do Frete
			iVAL_FRETE := iVAL_FRETE + GWI->GWI_VLFRET
			
			//1=Frete Unidade;2=Frete Valor;3=Taxas;4=Valor do Pedagio
			Do Case
			Case GV2->GV2_CATVAL == "1"  // Frete Unidade
				iFRET_UNID := iFRET_UNID + GWI->GWI_VLFRET
					
				Case GV2->GV2_CATVAL == "2"  // Frete Valor
					iFRET_VAL  := iFRET_VAL  + GWI->GWI_VLFRET
					
					Case GV2->GV2_CATVAL == "3"  // Taxas
					iTAXAS     := iTAXAS     + GWI->GWI_VLFRET
					
					Case GV2->GV2_CATVAL == "4"  // Valor do Pedagio
					iVAL_PEDA  := iVAL_PEDA  + GWI->GWI_VLFRET	
					EndCase
				EndIf
		
		dbSelectArea("GWI")
		GWI->( dbSkip() )
			EndDo
	
	//Cidade de origem e destino é a mesma, então o calculo é de ISS
	//Grava os valores de Aliquota e de imposto
			If GWF->GWF_IMPOST == "2"
	   	/*ISS*/
		iALIQUOTA := GWF->GWF_PCISS
		iVAL_IMPO += GWF->GWF_VLISS
			Else
		/*ICMS*/
		iALIQUOTA := GWF->GWF_PCICMS
		iVAL_IMPO += GWF->GWF_VLICMS
			EndIf

Return



/*----------------------------------------------------------------------------------------------------
{Protheus.doc} MGFGFE5211
Exibir os cálculos do documento de frete com pendência de aprovação.

@sample
MGFGFE5211()


@author Cláudio Alves
@since 07/10/2019
@version 1.0
----------------------------------------------------------------------------------------------------*/

static function MGFGFE5211

	dbSelectArea("GWF")
	GWF->( dbSetOrder(1) )
	If Empty(cCalc)
		Help( ,, 'Help',, 'Selecione a aba Documentos para carregamento dos cálculos.', 1, 0 )
	Else
		If dbSeek( (cCalc)->(GWF_FILIAL+GWF_NRCALC) )
			FWExecView("Visualiza", "GFEC080", 1,,{|| .T.})
		EndIf
	EndIf
	
Return


/*----------------------------------------------------------------------------------------------------
{Protheus.doc} MGFGFE5213
Função genérica que retorna o CASE sql que mostra a descrição de acordo com o dicionário de dados, ao invés do valor.

@sample
MGFGFE5213(cTbl, cCmp, cAlias)

@author Octávio Augusto Felippe de Macedo
@since 27/10/2011
@version 1.0
----------------------------------------------------------------------------------------------------*/

static function MGFGFE5213(cTbl, cCmp, cAlias, cElse)

	local cCase := ""
	local nCount
	local aAreaSX3 := SX3->( GetArea() )
	
	cCase += " (CASE " + cTbl + "." + cCmp + " "	
	
	For nCount := 1 To Len(StrTokArr(Posicione("SX3", 2, cCmp, "X3_CBOX"),';'))
		cCase += " 	WHEN '" + AllTrim(Str(nCount)) + "' THEN '" + PadR(GFEFldInfo(cCmp, AllTrim(Str(nCount)), 2),25) + "' "
	Next nCount
	
	cCase += "		ELSE " + cElse + " "
	cCase += "	END) " + cAlias
	
	RestArea(aAreaSX3)
	
Return cCase


static function MGFGFE5215()
    local cfilter           := ""
	local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	local cTipAprov := ""
	local nValmin := 0
	local nValate := 0                  
	local lMsg1 := .T.                
	local lMsg2 := .F.
	
	dBselectArea("SZO")
	SZO->(dbSetOrder(1))//ZO_FILIAL+ZO_USUARIO
	If SZO->(dbSeek(xFilial("SZO")+cCodUser))
		If U_GFE01VLDSUB()
			While !SZO->(eof()) .AND. (SZO->ZO_USUARIO = cCodUser )	.AND. lMsg1 
				cTipAprov := SZO->ZO_TPAPROV
				nValmin := SZO->ZO_VLMIN
				nValate := SZO->ZO_VLATE	
				If cTipAprov $ '16'
					cfilter :=  " AND GW3_SIT = '2' "	             
					cfilter +=  " AND GW3_VLDF >= " + Alltrim(Str(nValmin)) 	    	    
					cfilter +=  " AND GW3_VLDF <= " + Alltrim(Str(nValate)) 	    	    	    
					lMsg1 := .F.
				Else
					lMsg1 := .F.
					If lMsg1 = .F.
						lMsg1 := .T.
					EndIf
					cfilter :=  " AND GW3_VLDF = 0 "			    
				EndIf
				SZO->(dBskip())
			Enddo
		Else
			cfilter :=  " .AND. GW3_VLDF = '0' "
			lMsg2 := .F.
		EndIf
	Else
		lMsg2 := .T.
		cfilter :=  " AND GW3_VLDF = 0 "	
	EndIf
	If lMsg1 = .T.
		MsgAlert ("Usuário aprovador não tem permissão para realizar aprovações de Documentos de Frete! Os registros bloqueados não serão apresentados ao usuário!")         			    
	EndIf
	If lMsg2 = .T.
		MsgAlert ("Usuário sem permissão para realizar aprovações! Os registros bloqueados não serão apresentados ao usuário!")          		    
	EndIf
Return cfilter 
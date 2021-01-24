#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "APWEBSRV.CH" 
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "DIRECTRY.CH"

/*/
{Protheus.doc} MGFWSS19
	WebService Protheus x MultiEmbarcador - Irá receber os dados da ND (NDF) do MultiEmbarcador.

	@description
		A integração tem como objetivo a Marfrig (Protheus) receber as informações da ND – Nota de Débito 
		com Desconto Financeiro criada/gerada no MultiEmbarcador. 
		Com isso será possível integrar Ocorrências de ND – Nota de Débito com Desconto Financeiro no 
		Módulo GFE (CONEMB) e criar o Título do tipo NDF no Contas a Pagar, onde será compensado.   

	@author Marcos Cesar Donizeti Vieira
	@since 19/05/2020

	@version P12.1.017
	@country Brasil
	@language Português

	

{Protheus.doc} MGFWSS19REC
	Estrutura dos Dados que sera recebida no WS
	
/*/
WSSTRUCT MGFWSS19REC

	WSDATA Acao				as string
	WSDATA Alterado			as string
	WSDATA DataEmissao		as date
	WSDATA Especie			as string
	WSDATA NumeroND			as string
	WSDATA SerieND			as string
	WSDATA CNPJRemetente	as string
	WSDATA Transportador   	as string
	WSDATA OcorrenciaMulti	as string
	WSDATA Problema			as string
	WSDATA CteOrigem		as string
	WSDATA SerieOrigem		as string
	WSDATA NfeOrigem		as string
	WSDATA QtdParcela		as integer
	WSDATA ValorDocumento	as float

ENDWSSTRUCT



/*/
{Protheus.doc} MGFWSS19RET
	Estrutura dos Dados para retorno do WS

	@author Marcos Cesar Donizeti Vieira
	@since 19/05/2020
/*/
WSSTRUCT MGFWSS19RET
	WSDATA status	as string
	WSDATA Msg		as String
ENDWSSTRUCT



/*/
{Protheus.doc} MGFWSS19
	Classe do WS contendo suas propriedades e metodos - Retorno NDF multiembarcador
	@type class

	@author Marcos Cesar Donizeti Vieira
	@since 19/05/2020
/*/
WSSERVICE MGFWSS19 DESCRIPTION "Integracao Protheus x Multiembarcador - ND (NDF)" NameSpace "http://totvs.com.br/MGFWSS19.apw"

	//-----| Passagem dos parametros de entrada |-----\\
	WSDATA MGFWSS19RECEBER	AS MGFWSS19REC
	//-----| Retorno (array) |-----\\
	WSDATA MGFWSS19RETORNO	AS MGFWSS19RET

	WSMETHOD RetNDF DESCRIPTION "Integracao Protheus x Multiembarcador - Retorno ND (NDF)"

ENDWSSERVICE



/*/
{Protheus.doc} ND - NDF
	Metodo que ira realizar a gravação da Ocorrencia
	@type method

	@param MGFWSS19DADOS, objeto de MGFWSS19DADOS ,  Dados recebidos via WS (Dados da ND (NDF))
	@return MGFWSS19RETORNO, objeto de MGFWSS19Ret ,  Dados enviados apos processamento(Status, mensagem)

	@author Marcos Cesar Donizeti Vieira
	@since 19/05/2020
/*/
WSMETHOD RetNDF WSRECEIVE MGFWSS19RECEBER WSSEND MGFWSS19RETORNO WSSERVICE MGFWSS19

	Local _aRetFuncao 	:= {}
	Local _lRet			:= .T.

	_aRetFuncao	:= u_MGFWSS19(::MGFWSS19RECEBER)

	//-----| Cria e alimenta uma nova instancia de retorno |-----\\
	::MGFWSS19RETORNO			:=  WSClassNew( "MGFWSS19Ret" )
	::MGFWSS19RETORNO:status	:= _aRetFuncao[1][1]
	::MGFWSS19RETORNO:Msg		:= _aRetFuncao[1][2]

Return _lRet



/*/
{Protheus.doc} MGFWSS19
	Função para gerar a ND (NDF) no CONEMB
	@type Function

	@param oNDF, objeto MGFWSS19DADOS ,  objeto da Entrada de Dados do WS
	@return _aRet, Array ,  {Status,Mensagem} Status 1=OK,2=erro, mensagem observacoes do processamento

	@author Marcos Cesar Donizeti Vieira
	@since 19/05/2020
/*/
User Function MGFWSS19(oNDF)
	Local _aRet     	:= {}	
	Local _aArea	   	:= GetArea()
	Local _cGXG			:= GetNextAlias()

	Local _cFil 	   	:= AllTrim( WSS19FIL(oNDF:CNPJRemetente) )
	Local _cSerND		:= Alltrim(oNDF:SerieND)
	Local _cNroND 		:= StrZero( Val(oNDF:NumeroND),9 )
	Local _cOcorMult	:= AllTrim(oNDF:OcorrenciaMulti)

	Local _cTipo		:= oNDF:Especie
	Local _cCnpjTransp	:= AllTrim(oNDF:Transportador)
	Local _dEmissao		:= oNDF:DataEmissao
	Local _dVencto		:= _dEmissao
	Local _dVenctoR		:= DataValida(_dEmissao,.T.)
	Local _nValTot		:= oNDF:valorDocumento
	Local _cHist		:= oNDF:Problema
	Local _QtdParc		:= oNDF:QtdParcela
	Local _cNaturez
	
	Private lMsErroAuto := .F.

	U_MFCONOUT("- Iniciando recebimento de NDF: " + _cSerND + " - " + _cNroND + " Ocorrência: " + _cOcorMult + "..." )
	If Alltrim(_cFil) == ""
		U_MFCONOUT(" 2 - CNPJ DOC.ORIGEM INVALIDO..." )
		Aadd_(_aRet,{"2","CNPJ DOC.ORIGEM INVALIDO"})
	Else
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL _cFil MODULO "GFE"

		//-----| Verifica existência de parâmetros e caso não exista cria. |-----\\
		If !ExisteSx6("MGF_WSS19A")
			CriarSX6("MGF_WSS19A", "C", "Natureza do Titulo da NDF - MultiEmbarcador", "20408" )	
		EndIf

		_cNaturez := AllTrim(SuperGetMV("MGF_WSS19A",.F.,"20408"))

		BeginSql Alias _cGXG
			
			SELECT 
				GXG_FILIAL, GXG_CDESP, GXG_EMISDF, GXG_SERDF, GXG_NRDF, GXG_DTEMIS                                                                                             
			FROM 
				%Table:GXG% GXG
			WHERE 
				GXG.%notdel% 									AND
				GXG.GXG_FILIAL	=  %Exp:_cFil%					AND
				GXG.GXG_CDESP	=  %Exp:oNDF:Especie%			AND
				GXG.GXG_EMISDF	=  %Exp:oNDF:Transportador%		AND
				GXG.GXG_SERDF	=  %Exp:_cSerND%				AND
				GXG.GXG_NRDF	=  %Exp:_cNroND%				AND
				GXG.GXG_DTEMIS	=  %Exp:oNDF:DataEmissao%
			ORDER BY GXG_FILIAL, GXG_CDESP, GXG_EMISDF, GXG_SERDF, GXG_NRDF, GXG_DTEMIS  

		EndSql
		//MemoWrite("C:\QRY\WSS19GXG.SQL",GetLastQuery()[2])

		If (_cGXG)->( Eof())	
			cfilant	:= _cfil

			SA2->( DbSetOrder(3) )	//A2_FILIAL+A2_CGC
			If SA2->( dbSeek(xFilial("SA2")+_cCnpjTransp) )
				//-----| Gerar Titulo NDF |-----\\
				If WSS19NDF(_cfil,_cSerND,_cNroND, _cTipo,_cNaturez,SA2->A2_COD,SA2->A2_LOJA,_dEmissao,_dVencto,_dVenctoR,_nValTot,_cHist,_QtdParc)
					//-----| Se gerou Titulo NDF, gerar CONEMB |-----\\
					WSS19CONEMB(oNDF:Acao,oNDF:Alterado,oNDF:Especie,_cCnpjTransp,_cSerND,_cNroND,_dEmissao, oNDF:CNPJRemetente,_nValTot, _cOcorMult)
					U_MFCONOUT(" 1 - ND(NDF) IMPORTADA COM SUCESSO...")
					Aadd(_aRet,{"1","ND(NDF) IMPORTADA COM SUCESSO."})
				Else
					U_MFCONOUT(" 2 - ERRO AO GERAR NDF...")
					Aadd(_aRet,{"2","ERRO AO GERAR NDF."})
				EndIf
				
			Else
				U_MFCONOUT(" 2 - TRANSPORTADOR NÃO CADASTRADO...")
				Aadd(_aRet,{"2","TRANSPORTADOR NÃO CADASTRADO."})
			EndIf
		Else
			U_MFCONOUT(" 2 - ND (NDF) JÁ IMPORTADA ANTERIORMENTE...")
			Aadd(_aRet,{"2","ND (NDF) JÁ IMPORTADA ANTERIORMENTE."})
		EndIf
	EndIf
    
	U_MFCONOUT("- Finalizando recebimento de NDF: " + _cSerND + " - " + _cNroND + " Ocorrência: " + _cOcorMult + "..." )

	//-----| Fechando area de trabalho |-----
	(_cGXG)->(dbcloseArea())
	
	RestArea(_aArea)		
Return _aRet



/*/
{Protheus.doc} WSS19FIL
	Função para pegar a filial que será integrada.
	@type Function

	@param CNPJ, _cCNPJ
	@return _cRet,  Retorno Filial referente ao cnpjo

	@author Marcos Cesar Donizeti Vieira
	@since 20/05/2020
/*/
Static Function WSS19FIL(_cCNPJ)

	Local _cQuery
	Local _cRet := ""

	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF

	_cQuery := " SELECT M0_CODFIL  FROM SYS_COMPANY "
	_cQuery += "  WHERE M0_CGC = '" + _cCNPJ + "'"
	_cQuery += "  AND SYS_COMPANY.D_E_L_E_T_<> '*' "

	TcQuery changeQuery(_cQuery) New Alias "cSM0"
	If !cSM0->(EOF())
    	_cRet := cSM0->M0_CODFIL
	EndIf

	If SELECT("cSM0") > 0
    	cSM0->( dbCloseArea() )
	EndIf

Return _cRet



/*/
{Protheus.doc} WSS19NDF
	Função para gerar a ND (NDF) no Contas a Pagar.
	@type Function

	@param Filial, Prefixo, Num.Titulo, Tipo, Natureza, Cod.Forn, Loja, Emissao, Vencto, Vencto Real, Valor, Historico
	@return _lRet,  Retorno .T. = OK , .F. = Erro

	@author Marcos Cesar Donizeti Vieira
	@since 20/05/2020
/*/
Static Function WSS19NDF(_cfil,_cPref,_cNroTit,_cTipo,_cNaturez,_cForn,_cLoja,_dEmissao,_dVencto,_dVenctoR,_nValTot,_cHist,_QtdParc)

    Local _cError	:= ''
	Local _aTitNDF	:= {}
	Local _lRet		:= .T.
	Local _nValParc	:= Round( _nValTot/_QtdParc , TamSX3("E2_VALOR")[2])

	Private lMsErroAuto := .F.

	For _n := 1 to _QtdParc

		If _n > 1	//Se for mais de uma parcela, somar 30 dias para o vencimento.
			_dVencto	:= _dVencto+30
			_dVenctoR 	:= DataValida(_dVenctoR+30,.T.)	
		EndIf

		_aTitNDF := { 	{ "E2_FILIAL"  	, _cfil   		, NIL },;
						{ "E2_PREFIXO"  , _cPref   		, NIL },;
						{ "E2_NUM"      , _cNroTit		, NIL },;
						{ "E2_PARCELA"	, StrZero(_n,2)	, NIL },;
						{ "E2_TIPO"     , _cTipo   		, NIL },;
						{ "E2_NATUREZ"  , _cNaturez 	, NIL },;
						{ "E2_FORNECE"  , _cForn    	, NIL },;
						{ "E2_LOJA"  	, _cLoja   		, NIL },;
						{ "E2_EMISSAO"  , _dEmissao		, NIL },;
						{ "E2_VENCTO"   , _dVencto		, NIL },;
						{ "E2_VENCREA"  , _dVenctoR		, NIL },;	
						{ "E2_VALOR"    , _nValParc		, NIL },;
						{ "E2_HIST"  	, _cHist		, NIL }}

		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, _aTitNDF,, 3)	// 3 - Inclusao, 4 - Alteração, 5 - Exclusão

		If lMsErroAuto
			If (!IsBlind()) 
				MostraErro()
			Else // Se é Job
				_cError := MostraErro("/dirdoc", "error.log") 
				ConOut(PadC("Automatic routine ended with error", 80))
				ConOut("Error: "+ _cError)
			EndIf
			_lRet := .F.
		Else
			_lRet := .T.
		EndIf
	Next _n
Return _lRet



/*/
{Protheus.doc} WSS19CONEMB
	Função para gerar o CONEMB.
	@type Function

	@param Prefixo, Tipo, Natureza, Cod.Forn, Loja, Emissao, Vencto, Vencto Real, Valor, Historico
	@return _lRet,  Retorno 1 = OK , 2 = Erro

	@author Marcos Cesar Donizeti Vieira
	@since 20/05/2020
/*/
Static Function WSS19CONEMB(_cAcao,_cAlterado,_cEspecie,_cTransp,_cSerND,_cNroND,_dEmissao, _cCnpjRem, _nValDocto, _cOcorMult )
	Local _cNrImp := GFE118ChSq()

	dbSelectArea("GXG")
	RecLock("GXG",.T.)
		GXG->GXG_FILIAL := xFilial("GXG")
		GXG->GXG_NRIMP  := _cNrImp
		GXG->GXG_ACAO  	:= _cAcao 	
		GXG->GXG_EDINRL	:= 0 
		GXG->GXG_ORIGEM := "1"
		GXG->GXG_EDIARQ	:= "INTEGRACAO-ND NDF"
		GXG->GXG_DTIMP	:= DATE()
		GXG->GXG_ALTER  := _cAlterado
		GXG->GXG_EDISIT := "4"
		GXG->GXG_FILDOC := xFilial("GXG")
		GXG->GXG_CDESP	:= _cEspecie	
		GXG->GXG_EMISDF := _cTransp	
		GXG->GXG_SERDF 	:= _cSerND
		GXG->GXG_NRDF   := _cNroND
		GXG->GXG_DTEMIS := _dEmissao	
		GXG->GXG_CDREM  := _cCnpjRem	
		GXG->GXG_TPDF   := "8"
		GXG->GXG_DTENT  := DATE()
		GXG->GXG_VLDF   := _nValDocto	
		GXG->GXG_USUIMP := "INTEGRACAO MULTIEMBARCADOR"
		GXG->GXG_XPROTO := _cOcorMult
	MsUnlock("GXG")
						 
Return
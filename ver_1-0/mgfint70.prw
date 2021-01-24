#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"

/*/
{Protheus.doc} MGFINT70
	Integração de despesas do cartão de crédito corporativo.

@description
	Esta rotina irá automatizar a inclusão do título a pagar da Fatura através da integração com a solução da Intellilink. 
	O Visa IntelliLink Spend Management é uma solução de gerenciamento de informações para empresas, baseada na internet, 
	que permite controle sobre despesas de cartões de créditos da bandeira Visa. 
	Durante o período aberto para compras, 	o colaborador deverá acessar um link disponibilizado pela empresa Bradesco 
	(https://intellilink.spendmanagement.visa.com), onde será possível classificar cada uma das despesas conforme centro de custo 
	e natureza financeira previamente cadastrados. 
	No fechamento mensal da fatura o Bradesco enviará um arquivo único contendo os lançamentos de todos colaboradores devidamente 
	classificados em um layout compatível com o sistema Protheus. 

@author Marcos Cesar Donizeti Vieira
@since 11/11/2019

@version P12.1.017
@country Brasil
@language Português

@type Function 
@table 
	SE2 – Contas a Pagar 
	SEV – Múltiplas Naturezas por Título 
	SEZ – Distrib de Naturezas em CC     
	
@param
@return

@menu
@history 

/*/
User Function MGFINT70()
	Local _aArea := GetArea()
	If GETINT70()
		fwMsgRun(, {|oSay| PROCINT70( oSay ) }, "Processando arquivo", "Aguarde o término do processamento." )
	EndIf
	RestArea(_aArea)
Return



/*/
{Protheus.doc} GETINT70
	Esta função irá selecionar o arquivo a importar.

@author Marcos Cesar Donizeti Vieira
@since 11/11/2019

@type Function
@param	
@return
/*/
Static Function GETINT70()
	Local _aRet			:= {}
	Local _aParambox	:= {}

	aadd(_aParambox, {6, "Selecione o arquivo"	, space(100), "@!"	, ""	, ""	, 070, .T., "Todos Arquivos |*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE, .F. /*NAO MOSTRA SERVIDOR*/})

Return paramBox(_aParambox, "Importação de despesas do Cartão Visa IntelliLink"	, @_aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)



/*/
{Protheus.doc} PROCINT70
	Esta função irá ler o arquivo selecionado e gerar o titulo a pagar.

@author Marcos Cesar Donizeti Vieira
@since 11/11/2019

@type Function
@param	
@return
/*/
Static Function PROCINT70()
	Local _nOpen		:= FT_FUSE(ALLTRIM(MV_PAR01))
	Local _cHash		:= MD5FILE(ALLTRIM(MV_PAR01)) 
	Local _cLinha		:= ""
	Local _aNatureza	:= {}
	Local _aCCusto		:= {}
	Local _nPosNat		:= 0
	Local _nPosCC		:= 0 
	Local _nPosvirg		:= 0
	Local _nPosFim 		:= 0
	Local _nVlTit 		:= 0
	Local _nVlNature  	:= 0
	Local _nVlCcusto	:= 0
	Local _cIdCartao	:= ""
	Local _lCab 		:= .T.
	Local _cVlDesp
	Local _cPortador
	Local _cNatureza 	
	Local _cCCusto
	
	_cAliasSE2 := GetNextAlias()
	BeginSql Alias _cAliasSE2
		SELECT 
			SE2.E2_PREFIXO, SE2.E2_NUM
		FROM 
			%Table:SE2% SE2
		WHERE
			SE2.E2_FILIAL = %xFilial:SE2% 	AND
			SE2.E2_ZHASH  = %exp:_cHash% 	AND 
			SE2.%NotDel%
	EndSql

	If !(_cAliasSE2)->( Eof() )
		Help(NIL, NIL,"MGFINT70 - Cartão IntelliLink", NIL, "Arquivo já processado anteriormente."+chr(13)+chr(10)+chr(13)+chr(10)+;
	        "Foi gerado o Título: "+(_cAliasSE2)->E2_PREFIXO+" - "+(_cAliasSE2)->E2_NUM, 1, 0, NIL, NIL, NIL, NIL, NIL, ;
	        {"Selecione um novo arquivo para importação."})
		Return
	EndIf
	
	If _nOpen < 0
		Help( ,, "MGFINT70 - Cartão IntelliLink",, "Falha na abertura do arquivo.", 1, 0 )
	Else
		ProcRegua(FT_fLastRec())
		FT_FGoTop()
		While !FT_FEOF()
			IncProc()
			_cLinha := FT_FREADLN()

			If _lCab	// Ignora a linha do cabeçalho
				FT_FSKIP()
				_lCab 	:= .F.
				_cLinha := FT_FREADLN()
			EndIf

			_nPosFim 	:= AT( "|", _cLinha ) 
			_cIdCartao	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))
			_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

			_nPosFim 	:= AT( "|", _cLinha )
			_cVlDesp	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))
			_nPosvirg	:= AT( ",", _cVlDesp )
			If _nPosvirg > 0	//Verifica se o campo valor esta com virgula, se tiver, substitui por ponto.
				_cVlDesp := SUBSTR(_cVlDesp,1,_nPosvirg-1)+"."+SUBSTR(_cVlDesp,_nPosvirg+1,2)
			EndIf
			_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

			_nPosFim 	:= AT( "|", _cLinha )
			_cPortador	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))
			_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

			_nPosFim 	:= AT( "|", _cLinha )
			_cNatureza	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))
			_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

			_nPosFim 	:= AT( "|", _cLinha )
			_cCCusto	:= ALLTRIM(SUBSTR(_cLinha,1,LEN(_cLinha)))

			_nVlNature  := VAL(_cVlDesp)
			_nVlCcusto	:= VAL(_cVlDesp)
			_nVlTit 	+= VAL(_cVlDesp)

			SED->(dbSetOrder(1))
      		If SED->(dbSeek(xFilial("SED")+_cNatureza,.F.))
				If SED->ED_MSBLQL = "1"
					Help(NIL, NIL,"NATUREZA", NIL, "Natureza informada no arquivo está Bloqueada. Natureza: "+_cNatureza, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique o arquivo recebido."})
					Return
				EndiF
			Else
				Help(NIL, NIL,"NATUREZA", NIL, "Natureza informada no arquivo não Cadastrada. Natureza: "+_cNatureza, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique o arquivo recebido."})
				Return
			EndIf

			CTT->(dbSetOrder(1))
      		If !CTT->(dbSeek(xFilial("CTT")+_cCCusto,.F.))
				Help(NIL, NIL,"CENTRO DE CUSTO", NIL, "Centro de Custo informado no arquivo não Cadastrado. Centro de Custo: "+_cCCusto, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique o arquivo recebido."})
				Return
			EndIf

			_nPosNat := AScan( _aNatureza, { |x| x[1] == _cNatureza } )
			If _nPosNat = 0
				AAdd(_aNatureza, {_cNatureza, _nVlNature } )
			Else
				_aNatureza[_nPosNat,2] += _nVlNature
			Endif

			_nPosCC	:= AScan( _aCCusto, { |x| x[1]+x[2] == _cNatureza+_cCCusto } )
			If _nPosCC = 0
				AAdd(_aCCusto, {_cNatureza, _cCCusto, _nVlCcusto } )
			Else
				_aCCusto[_nPosCC,3] += _nVlCcusto
			Endif

			FT_FSKIP()
		EndDo

		If LEN(_aNatureza) > 0
			TITINT70(_aNatureza, _aCCusto , _nVlTit, _cHash)
		Else
			Help( ,, "MGFINT70 - Cartão IntelliLink",, "Não há dados a Importar.", 1, 0 )
		EndIf
	EndIf

Return



/*/
{Protheus.doc} TITINT70
	Esta função irá gerar um titulo a pagar com rateio de naturezas e centro de custos.

@author Marcos Cesar Donizeti Vieira
@since 11/11/2019

@type Function
@param _aNatureza	
@return
/*/
Static Function TITINT70(_aNatureza, _aCCusto , _nVlTit, _cHash)
	Local _cNumTit, _cTipTit, _cNatTit, _cTitFor, _cTitLoj, _cPrfTit
	Local _nPercNat := 0
	Local _aCab 	:= {} 	// Array que recebera o titulo a receber
	Local _aAuxEv 	:= {} 	// Array auxiliar do rateio multinaturezas
	Local _aRatEvEz	:= {} 	// Array do rateio multinaturezas
	Local _aAuxEz 	:= {} 	// Array auxiliar de multiplos centros de custo
	Local _aRatEz	:= {} 	// Array do rateio de centro de custo em multiplas naturezas

	Private lMsErroAuto := .F.

	//-----| Ordenar array de Centro de custos por Natureza |-----\\
	aSort(_aCCusto,,,{|x,y| x[1] < y[1]})
	
	//--------------| Verifica existência de parâmetros e caso não exista, cria. |-----
	If !ExisteSx6("MGF_INT70A")
		CriarSX6("MGF_INT70A", "C", "Prefixo do titulo-Imp.Cartao IntelliLink","CCI" )	
	EndIf

	If !ExisteSx6("MGF_INT70B")
		CriarSX6("MGF_INT70B", "C", "Numero seq.do titulo-Imp.Cartao IntelliLink","000000001" )	
	EndIf

	If !ExisteSx6("MGF_INT70C")
		CriarSX6("MGF_INT70C", "C", "Tipo do titulo-Imp.Cartao IntelliLink","DP" )	
	EndIf

	If !ExisteSx6("MGF_INT70D")
		CriarSX6("MGF_INT70D", "C", "Natureza do titulo-Imp.Cartao IntelliLink","22257" )	
	EndIf

	If !ExisteSx6("MGF_INT70E")
		CriarSX6("MGF_INT70E", "C", "Fornecedor+Loja do titulo-Imp.Cartao IntelliLink","11249901" )	
	EndIf

	_cPrfTit 	:= ALLTRIM(SuperGetMV("MGF_INT70A",.F.,))
	_cNumTit 	:= ALLTRIM(GetMV("MGF_INT70B"))
	_cTipTit 	:= ALLTRIM(SuperGetMV("MGF_INT70C",.F.,)) 
	_cNatTit 	:= ALLTRIM(SuperGetMV("MGF_INT70D",.F.,))
	_cTitFor 	:= SUBSTR(ALLTRIM(SuperGetMV("MGF_INT70E",.F.,)),1,6)
	_cTitLoj	:= SUBSTR(ALLTRIM(SuperGetMV("MGF_INT70E",.F.,)),7,2)

	PUTMV("MGF_INT70B", Soma1(_cNumTit))	//	Grava Próximo número do Título para Cartao IntelliLink. 

	aadd( _aCab ,{"E2_PREFIXO" 	, 	_cPrfTit	, Nil })            
	aadd( _aCab ,{"E2_NUM" 		,	_cNumTit	, Nil })
	aadd( _aCab ,{"E2_PARCELA" 	, 	"01"		, Nil })
	aadd( _aCab ,{"E2_TIPO" 	, 	_cTipTit	, Nil })
	aadd( _aCab ,{"E2_NATUREZ" 	, 	_cNatTit	, Nil })
	aadd( _aCab ,{"E2_FORNECE" 	, 	_cTitFor	, Nil })
	aadd( _aCab ,{"E2_LOJA" 	, 	_cTitLoj	, Nil })
	aadd( _aCab ,{"E2_EMISSAO" 	, 	dDataBase	, Nil })
	aadd( _aCab ,{"E2_VENCTO" 	, 	dDataBase	, Nil })
	aadd( _aCab ,{"E2_VALOR" 	, 	_nVlTit		, Nil })
	aadd( _aCab ,{"E2_MULTNAT" 	, 	"1"			, Nil })		//	Rateio multinaturezas (1=Sim - 2=Não)

	For _nt := 1 to Len(_aNatureza)		//	Adicionando o vetor da natureza
		_aAuxEv		:= {} // Array auxiliar do rateio multinaturezas
 		_aAuxEz		:= {} // Array auxiliar de multiplos centros de custo
 		_aRatEz		:= {} // Array do rateio de centro de custo em multiplas naturezas
		_nPercNat 	:= (_aNatureza [_nt][2] / _nVlTit) * 100	// percentual de rateio Valor total/Natureza
		
		aadd( _aAuxEv ,{"EV_NATUREZ" 	, padr(_aNatureza [_nt][1],tamsx3("EV_NATUREZ")[1])	, Nil })	//	natureza a ser rateada
		aadd( _aAuxEv ,{"EV_VALOR" 		, _aNatureza [_nt][2]								, Nil })	//	valor do rateio na natureza
		aadd( _aAuxEv ,{"EV_PERC"		, _nPercNat											, Nil })	//	percentual do rateio na natureza
		aadd( _aAuxEv ,{"EV_RATEICC" 	, "1"												, Nil })	//	indicando que há rateio por centro de custo (1=Sim - 2=Não)

		_cc	:= AScan( _aCCusto, { |x| x[1] == _aNatureza [_nt][1] } )
		While _aNatureza [_nt][1] = _aCCusto [_cc][1] 	//Adicionando multiplos centros de custo
			_aAuxEz:={}
			aadd( _aAuxEz 	,{"EZ_CCUSTO"	, _aCCusto [_cc][2]	, Nil })	//	centro de custo da natureza
			aadd( _aAuxEz 	,{"EZ_VALOR"	, _aCCusto [_cc][3]	, Nil })	//	valor do rateio neste centro de custo
			aadd( _aRatEz	, _aAuxEz)
			_cc++
			If _cc > LEN(_aCCusto)	// Verifica se contador é maior que o tamanho do array
				Exit
			EndIf
		EndDo
    	aadd(_aAuxEv,{"AUTRATEICC" , _aRatEz, Nil })	//	recebendo dentro do array da natureza os multiplos centros de custo
		aadd(_aRatEvEz, _aAuxEv)	//	adicionando a natureza ao rateio de multiplas naturezas
	Next _nt
	aadd(_aCab,{"AUTRATEEV"	, _aRatEvEz ,Nil})	//	adicionando ao vetor _aCab o vetor do rateio
 
	Begin Transaction
		MsExecAuto( { |x,y,z| FINA050(x,y,z)} , _aCab, ,3)	// 3 - Inclusao, 4 - Alteração, 5 - Exclusão	
		If lMsErroAuto
			If (!IsBlind())	// Com interface gráfica.
				MostraErro()
			Else // EM ESTADO DE JOB
				cError := MostraErro("/dirdoc", "error.log")	// Armazena a mensagem de erro.
		
				ConOut(PadC("Automatic routine ended with error", 80))
				ConOut("Error: "+ cError)
			EndIf
		Else
			RecLock("SE2", .F. )
				SE2->E2_ZHASH := _cHash
			MsUnLock()
			APMsgInfo("Foi gerado o título "+_cPrfTit+" - "+_cNumTit+" com sucesso!","MGFINT70 - Cartão IntelliLink")
		EndIf
	End Transaction

Return
#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFIN19
Autor...............: Roberto Sidney
Data................: 11/10/2016
Descricao / Objetivo: MBrowse - Informações do sinistro
Doc. Origem.........: CRE24 - GAP CRE24
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFIN19()
PRIVATE cCadastro := "Informações de Sinistro
PRIVATE aRotina     := { }

cString := "SZX"
_cAreaSZX := SZX->(GetArea())

//======================================================================
//MsFilter("Z9_ZCLIENT = cCodCli and Z9_ZLOJA = cLojaCli")
//======================================================================
//aAcho := aclone(aCampos)
//_cFilSZ9 := "ZX_CLIENT ='"+cCodCli+"' and ZX_LOJA ='"+cLojaCli+"'"

AADD(aRotina, { "Pesquisar"   ,"AxPesqui"  , 0, 1 })
//AADD(aRotina, { "Visualizar"  ,"U_MGFVISUSIN(ZX_CLISEG,ZX_LOJASEG,ZX_SINISTR,,.F.)" , 0, 2 })
AADD(aRotina, { "Documentos","MsDocument", 0, 3})

dbSelectArea("SZX")
dbSetOrder(1)

mBrowse(6, 1, 22, 75, "SZX",,,,,,,,,,,,,,,,,)

RestArea(_cAreaSZX)

Return(.T.)

/*
=====================================================================================
Programa............: MGFVISUSIN
Autor...............: Roberto Sidney
Data................: 11/10/2016
Descricao / Objetivo: Tela de visualização das informações de sinistro
Doc. Origem.........: CRE24 - GAP CRE24
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFVISUSIN(aTitulos,lGrv,cQtdeT,cSomaT,cNumSin)

//+----------------------------------------------+
//¦ Variaveis do Cabecalho do Modelo 2           ¦
//+----------------------------------------------+
Private cCliSeg := "" // Space(6)
Private cLoja   := ""//Space(2)
Private dData   :=Date()
Private cSiniPro   := cNumSin //GETSX8NUM("SZX","ZX_SINISTR") // space(10)
Private cSiniSeg   := space(15)
private nSomaT	:= 0
private nQtdeT	:= 0
Private cPrxSEG := GetMv("MGF_PRXSEG") // Prefixo para os titulos de seguro
private cPrefix		:= cPrxSEG
private cTitu		:= GETSX8NUM("SE1","E1_NUM")
private cParcela	:= "01" //space(tamSx3("E1_PARCELA")[1])
private dVenc		:= date()
Private cNome   :=Space(40)  
Private cNCli   := Space(40)
Private cObserv := Space(100)
Private aCols := {}
Private aCliente := Strtokarr(GetMv("MGF_CLISEG"),";") // Cliente para titulos de seguro

if valType(cSomaT) <> nil .and. !empty(cSomaT)
	nSomaT	:= Val(strtran(StrTran(cSomaT,".",""),",","."))
endif

if valType(cQtdeT) <> nil .and. !empty(cQtdeT)
	nQtdeT	:= val(strtran(cQtdeT, "."))
endif

cCliSeg  := aCliente[1]
cLoja    := aCliente[2]
cNCli    := Posicione("SA1",1,xFilial("SA1")+cCliSeg+cLoja,"A1_NOME")
nOpcx:=3 //3-Inclusão
//+-----------------------------------------------+
//¦ Montando aHeader para a Getdados              ¦
//+-----------------------------------------------+

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZY")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SZY")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .AND. alltrim(x3_campo) <> "ZY_CLISEG" .AND. alltrim(x3_campo) <> "ZY_LOJASEG"
		nUsado:=nUsado+1

		if allTrim(x3_campo) <> "ZY_VALOR"
			AADD(aHeader,{ TRIM(x3_titulo),x3_campo,x3_picture,x3_tamanho,x3_decimal,"ExecBlock('Md2valid',.f.,.f.)",x3_usado,x3_tipo, x3_arquivo, x3_context } )
		endif
	Endif

	dbSkip()
End

//+-----------------------------------------------+
//¦ Montando aCols para a GetDados                ¦
//+-----------------------------------------------+
aCols:=Array(1,nUsado+1)
dbSelectArea("SX3")
dbSeek("SZY")
nUsado:=0
While !Eof() .And. (x3_arquivo == "SZY")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .AND. alltrim(x3_campo) <> "ZY_CLISEG" .AND. alltrim(x3_campo) <> "ZY_LOJASEG"
		nUsado:=nUsado+1
		IF nOpcx == 3
			IF x3_tipo == "C"
				aCOLS[1][nUsado] := SPACE(x3_tamanho)
			Elseif x3_tipo == "N"
				aCOLS[1][nUsado] := 0.00
			Elseif x3_tipo == "D"
				aCOLS[1][nUsado] := dDataBase
			Elseif x3_tipo == "M"
				aCOLS[1][nUsado] := ""
			Else
				aCOLS[1][nUsado] := .F.
			Endif
		Endif
	Endif
	dbSkip()
End

aCOLS[1][nUsado+1] := .F.

cOPC := iif(lGrv = .T.,"I","V") // I-Inclui / V-Visualiza
lAlt := iif(lGrv = .T.,.T.,.F.) // I-Inclui / V-Visualiza

// Atualiza aCols
aCOLS := aAtuAcols(aCOLS,cOPC)

//+----------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2
//+----------------------------------------------+
nTotSin:=0
//+----------------------------------------------+
//¦ Titulo da Janela                             ¦
//+----------------------------------------------+
cTitulo:="Informações do Sinistro"
//+----------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho  ¦
//+----------------------------------------------+
aC:={}
AADD(aC,{"cCliSeg"		,{15,10}	,"Seguradora"			,"@!"						,'ExecBlock("MD2VLCLI",.F.,.F.)',"SA1",.F.})
AADD(aC,{"cLoja"		,{15,100}	,"Loja"					,"@!"						,,,.F.})
AADD(aC,{"cNCli"		,{15,150}	,"Nome"					,"@!"						,,,.F.})
AADD(aC,{"cSiniPro"		,{34,10}	,"Sinistro Protheus"	,							,,,.F.})
AADD(aC,{"cSiniSeg"		,{34,150}	,"Sinistro Seguro"		,							,,,lAlt})
AADD(aC,{"cPrefix"		,{54,10}	,"Prefixo"				,							,,,.F.})
AADD(aC,{"cTitu"		,{54,060}	,"Num. Titulo"			,							,,,.F.})
AADD(aC,{"cParcela"		,{54,150}	,"Parcela"				,							,,,.F.})
AADD(aC,{"dVenc"		,{54,190}	,"Vencimento"			,							,,,lAlt})
AADD(aC,{"nSomaT"		,{54,300}	,"Vlr. Total"			, "@E 999,999,999,999.99"	,,,.F.})
AADD(aC,{"nQtdeT"		,{54,420}	,"Quantidade"			, "@E 999,999,999"			,,,.F.})

//+-------------------------------------------------+
//¦ Array com descricao dos campos do Rodape        ¦
//+-------------------------------------------------+
aR:={}

nlin := 120
ncol := 10
AADD(aR,{"nTotSin" ,{nlin,ncol},"Total Sinistro ", "@E 999",,,.F.})

//+------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2   ¦
//+------------------------------------------------+
aCGD:={117,5,80,315}
//aCGD:={117,5,80,315}

aGetEdit := {}   // Array com campos colunas editaveis, neste caso nenhuma
//+----------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2           ¦
//+----------------------------------------------+

if lGrv
	//cLinhaOk := "ExecBlock('GrvSinis',.f.,.f.)" // retirado por gresele em 17/05/17
	//cTudoOk  := "ExecBlock('GrvSinis',.f.,.f.)" // retirado por gresele em 17/05/17
	cLinhaOk := "AllwaysTrue()"
	cTudoOk  := 'U_TudOkFin19()'
else
	cLinhaOk := "AllwaysTrue()"
	cTudoOk  := "AllwaysTrue()"
Endif

//+----------------------------------------------+
//¦ Chamada da Modelo2                           ¦
//+----------------------------------------------+
// lRet = .t. se confirmou
// lRet = .f. se cancelou
lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetEdit,,,,,.F.,.T.)
//lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetEdit,,,,,.F.,.T.)

// Grava os dados do sinistro
if lRet .and. lGrv
	
	Begin Transaction // gresele 19/05/17

	fwMsgRun(, {|| u_GrvSinis(aTitulos) }, "Processando", "Aguarde. Gravando Sinistro..." )
	fwMsgRun(, {|| ProcSinis(aTitulos) }, "Processando", "Aguarde. Gerando título seguradora..." )

	APMsgInfo("Informações do Seguro geradas com sucesso.")

	End Transaction 

Endif

//lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,,.F.,.T.)
//lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

Return

//----------------------------------------------
//----------------------------------------------
static function ProcSinis(aTitulos)

	local nPos		:= 0
	local _cChvPesq	:= ""

	Private nTotTitSeg := 0  // Valor total do titulo de seguro

	for nPos := 1 to len(aTitulos)
		if aTitulos[nPos,1] = .T.
			_cChvPesq := ""
			_cChvPesq := aTitulos[nPos,2]+aTitulos[nPos,4]+aTitulos[nPos,5]+aTitulos[nPos,6]+aTitulos[nPos,7]+aTitulos[nPos,10]+aTitulos[nPos,11]

			if !BxTitDac(_cChvPesq)
				// Desmarca o titulo para que o mesmo não seja considerado na amarração DACAO x Titulo de seguri
				aTitulos[nPos,1] := .F.
			endif
		endif
	next

	GerTitSeg(nTotTitSeg)
return

/*
=====================================================================================
Programa............: GrvSinis
Autor...............: Roberto Sidney
Data................: 11/10/2016
Descricao / Objetivo: Grava dados refrentes ao sinistro
Doc. Origem.........: CRE24 - GAP CRE24
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function GrvSinis(aTitulos)
Local nLenTit := 0

// Grava cabeçalho do sinistro
SZX->(Reclock("SZX",.T.))
SZX->ZX_FILIAL := xFilial("SZX")
SZX->ZX_SINISTR := cSiniPro
SZX->ZX_NOME :=cNome
SZX->ZX_CLISEG :=cCliSeg
SZX->ZX_LOJASEG := cLoja
SZX->ZX_OBSERV :=cObserv
SZX->(MsUnlock())

CONFIRMSX8()

// Grava itens do sinistro
For nLenTit := 1 to len(aCols)
	SZY->(Reclock("SZY",.T.))
	SZY->ZY_FILIAL := xFilial("SZY")  
	SZY->ZY_CLISEG := cCliSeg
	SZY->ZY_LOJASEG:= cLoja
	SZY->ZY_ORDEMB := aCols[nLenTit,1]
	SZY->ZY_SINISTR:= aCols[nLenTit,2]
	SZY->ZY_PREFIXO:= aCols[nLenTit,3]
	SZY->ZY_NUMERO := aCols[nLenTit,4]
	SZY->ZY_PARCELA:= aCols[nLenTit,5]
	SZY->ZY_TIPO   := aCols[nLenTit,6]
	SZY->ZY_CLIENTE:= aCols[nLenTit,7]
	SZY->ZY_LOJA   := aCols[nLenTit,8]
	SZY->ZY_EMISSAO:= aCols[nLenTit,9]
	SZY->ZY_VENCTO := aCols[nLenTit,10]
	SZY->ZY_VALOR  := aCols[nLenTit,11]
	SZY->(MsUnlock())
Next nLenTit

Return(.T.)

/*
=====================================================================================
Programa............: aAtuAcols
Autor...............: Roberto Sidney
Data................: 11/10/2016
Descricao / Objetivo: Atualiza acols da tela de dados do sinistro, inclusão e visualização
Doc. Origem.........: CRE24 - GAP CRE24
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
Static Function aAtuAcols(aCOLS,cOpc)

Local nLenAcols := 0

aCOLS := {}

if cOPC = "V" // Visualiza
	DbSelectArea("SZX")
	
	cNome   := SZX->ZX_NOME
	cObserv := SZX->ZX_OBSERV
	
	DbSelectArea("SZY")
	DbSetOrder(1)
	IF SZY->(DbSeek(xFilial("SZY")+cSiniPro+cCliSeg+cLoja))
		While ! SZY->(EOF()) .AND. SZY->ZY_SINISTR+SZY->ZY_CLISEG+SZY->ZY_LOJASEG = cSiniPro+cCliSeg+cLoja
			aadd(aCOLS,{SZY->ZY_ORDEMB,cSiniPro,SZY->ZY_PREFIXO,SZY->ZY_NUMERO,SZY->ZY_PARCELA,SZY->ZY_TIPO,;
			SZY->ZY_CLIENTE,SZY->ZY_LOJA,SZY->ZY_EMISSAO,SZY->ZY_VENCTO,SZY->ZY_VALOR})
			SZY->(DbSkip())
		Enddo
	Endif
Else
	// Grava itens do sinistro
	For nLenAcols := 1 to len(aTitulos)
		if aTitulos[nLenAcols,1] = .T.
			aadd(aCOLS,{aTitulos[nLenAcols,8],cSiniPro,aTitulos[nLenAcols,4],aTitulos[nLenAcols,5],aTitulos[nLenAcols,6],aTitulos[nLenAcols,7],;
			aTitulos[nLenAcols,10],aTitulos[nLenAcols,11],aTitulos[nLenAcols,13],aTitulos[nLenAcols,14],aTitulos[nLenAcols,15]})
			//val(aTitulos[nLenAcols,15])})

		Endif
	Next nLenAcols
Endif

Return(aCOLS)      

/*
=====================================================================================
Programa............: FTMSREL
Autor...............: Roberto Sidney
Data................: 11/10/2016
Descricao / Objetivo: Cria Alias para a função MsDocument - Banco de conhecimento 
Doc. Origem.........: CRE24 - GAP CRE24
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
USER FUNCTION x1FTMSREL(aEntidade)


AADD( aEntidade, { "SZX", { "ZX_SINISTR" }, { || SZX->ZX_SINISTR } } )

Return aEntidade


/*
=====================================================================================
Programa.:              BxTitDac
Autor....:              Roberto Sidney
Data.....:              10/10/2016
Descricao / Objetivo:   Efetua a baixa do titulo por dação
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/

Static Function BxTitDac(_cChvBx)

	lRet := .T.

	DbSelectArea("SE1")
	//DbSetOrder(1)
	If  SE1->(DbSeek(_cChvBx))
		_cIDCNAB := SE1->E1_IDCNAB // Verifica se o titulo foi enviado ao banco
		_cBordero := IIF(!Empty(SE1->E1_NUMBOR),SE1->E1_NUMBOR,'')
		_cChaveSEA := 	SE1->E1_NUMBOR+"R"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO//+SE1->E1_CLIENTE+SE1->E1_LOJA

		//_nValTit := SE1->E1_VALOR
		_nValTit := SE1->E1_SALDO

		// 2-  10 - Sinistro
		//aOcorSin[1]  //  01 - Normal
		_cSituaca := aSituaca[1]  //  1 - Simples

		// Retira o situlo da situação cobrança
		SE1->(Reclock("SE1",.F.))
		SE1->E1_SITUACA := '0' //_cSituaca
		SE1->(MsUnlock())

		// Buscar ocorrência pelo Banco (PORTADOR)
		DbSelectArea("ZA6")
		DbSetOrder(1)
		IF ZA6->(DbSeek(iif(!empty(xFilial("ZA6")), _cFil, xFilial("ZA6"))+SE1->E1_PORTADO+"N"))  
			_cOcorren := ZA6->ZA6_OCOR 
		ELSE    
			//alert("Ocorrencia não encontrada. ")
			//_cInstr1 := "01"
			//_cInstr2 := "00"
		ENDIF

		// Ajusta siutação de cobrança borderô
		u_JusInstCob(_cOcorren,_cBordero,.T.)

		// Ajusta situacao de cobrança - CNAB
		IF _cIDCNAB <> ''
			u_JusInstCob(_cOcorren,_cBordero,.F.)
		Endif

		aBaixa := { ;
		{"E1_FILIAL"  ,SE1->E1_FILIAL,Nil},;
		{"E1_PREFIXO"  ,SE1->E1_PREFIXO,Nil},;
		{"E1_NUM"      ,SE1->E1_NUM            ,Nil},;
		{"E1_TIPO"     ,SE1->E1_TIPO           ,Nil},;
		{"E1_PARCELA"  ,SE1->E1_PARCELA        ,Nil},;
		{"E1_PARCELA"  ,SE1->E1_VALOR          ,Nil},;
		{"AUTMOTBX"    ,_cMotBxSin       	   ,Nil},;     // SIN
		{"AUTDTBAIXA"  ,dDataBase              ,Nil},;
		{"AUTDTCREDITO",dDataBase              ,Nil},; //dDatabase
		{"AUTHIST"     ,"Baixa por Sinistro - Seguro",Nil},;
		{"AUTJUROS"    ,0                      ,Nil,.T.},;
		{"AUTNMULTA"   ,0              		   ,Nil,.T.},;
		{"AUTDESCONT"  ,0		 		 	   ,Nil,.T.},;
		{"AUTVALREC"   ,SE1->E1_VALOR 	  	   ,Nil}}

		if SE1->E1_SALDO = 0 .AND. ! Empty(SE1->E1_BAIXA)
			ShowHelpDlg("NOTIT", {"Titulo "+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+ " já encontra-se baixado",""},3,;
			{"Verificar situação do título junto a área Financeira",""},3)
			lRet := .F.
		Else
			lMsErroAuto := .F.
			MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)

			If lMsErroAuto
				cFileLog := NomeAutoLog()
				cMsgInfo := ""
				If cFileLog <> ""
					cErrolog := MemoRead(cPath+cFileLog)
				Endif
				msgalert(cErrolog)
				lRet := .F.
			Else
				// Totaliza o titulo de seguro
				nTotTitSeg += _nValTit 
			Endif
		Endif
	Else

		ShowHelpDlg("NOTIT", {"Titulo "+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PACELA+" não localizado",""},3,;
		{"Verificar situacao do titulo junto a area financeira",""},3)
		lRet := .F.

	Endif
Return(lRet)

/*
=====================================================================================
Programa.:              GerTitSeg
Autor....:              Roberto Sidney
Data.....:              10/10/2016
Descricao / Objetivo:   Gera titulo se segur
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/

Static Function GerTitSeg(nTotTitSeg)
	Local cError  := ''
	Local nPosSeg := 0
	Local lRetSeg := .T.
	Local nRecSE1 := 0  
	Local cChaveSE1 := ""
	Local aChaveSE1 := {}
	Local cTitSeg := ""

	_cNumero := STRZERO(VAL(SOMA1(GetMv("MGF_TITSEG"))),9) // Numeração do titulo de seguradora

	Begin Transaction

		//INCPROC("Titulo("+alltrim(_cNumero)+")...")
		aTitulo := {{ "E1_PREFIXO"		, cPrxSEG, NIL },;
		{ "E1_NUM"      , cTitu			, NIL },;
		{ "E1_PARCELA"	, cParcela		, NIL },;
		{ "E1_TIPO"     , "NF"			, NIL },;
		{ "E1_NATUREZ"  , cNatFin		, NIL },;
		{ "E1_CLIENTE"  , aCliente[1]	, NIL },;
		{ "E1_LOJA"     , aCliente[2]	, NIL },;
		{ "E1_EMISSAO"  , dDataBase		, NIL },;
		{ "E1_VENCTO"   , dVenc			, NIL },;
		{ "E1_VENCREA"  , dVenc			, NIL },;
		{ "E1_VALOR"    , nTotTitSeg	, NIL }}

		lMsErroAuto := .F.
		MsExecAuto( { |x,y| FINA040(x,y)} , aTitulo, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
		If lMsErroAuto // SE ENCONTROU ALGUM ERRO
			msgStop("Erro na geração do titulos!")
			If (!IsBlind()) // COM INTERFACE GRÁFICA
		         MostraErro()
		    Else // EM ESTADO DE JOB
		        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
		
		        ConOut(PadC("Automatic routine ended with error", 80))
		        ConOut("Error: "+ cError)
		    EndIf
			DisarmTransaction()
			RollBackSx8()
			lRetSeg := .F.
			Break
		Else
			CONFIRMSX8()
			
			nRecSE1 := SE1->(Recno())
			cTitSeg := SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO
			// Amarra os titulos baixados por DACAO ao titulo de seguro
			nPosSeg := 0
			// Carrega variaveis
			DbSelectArea("SE1")
			DbSetOrder(1)

			For nPosSeg := 1 to len(aTitulos)
				if aTitulos[nPosSeg,1] = .T.
					_cChvPesq := aTitulos[nPosSeg,2]+aTitulos[nPosSeg,4]+aTitulos[nPosSeg,5]+aTitulos[nPosSeg,6]+aTitulos[nPosSeg,7]+aTitulos[nPosSeg,10]+aTitulos[nPosSeg,11]
					if SE1->(DbSeek(_cChvPesq))
						SE1->(Reclock("SE1",.F.))
						SE1->E1_ZTITSEG := cTitSeg
						If SE1->(FieldPos("E1_ZSINGEG")) > 0
							SE1->E1_ZSINGEG := cSiniSeg
						Endif
						If SE1->(FieldPos("E1_ZSINSEG")) > 0
							SE1->E1_ZSINSEG := cSiniSeg
						Endif	
						If Len(Alltrim(cChaveSE1))+TamSX3("E1_PREFIXO")[1]+TamSX3("E1_NUM")[1]+TamSX3("E1_PARCELA")[1]+3 < 254
							cChaveSE1 := cChaveSE1+IIf(Empty(cChaveSE1),"","/")+aTitulos[nPosSeg,4]+"-"+aTitulos[nPosSeg,5]+"-"+aTitulos[nPosSeg,6]
						Else 
							If Len(aChaveSE1) <= 4
								aAdd(aChaveSE1,cChaveSE1)
								// variavel eh reiniciada
								cChaveSE1 := aTitulos[nPosSeg,4]+"-"+aTitulos[nPosSeg,5]+"-"+aTitulos[nPosSeg,6]
							Endif	
						Endif
						SE1->(Msunlock())
					Endif
				Endif
			Next nPosSeg
			// no caso de gravacao somente do primeiro campo com a chave dos titulo
			If Len(Alltrim(cChaveSE1)) > 0 .and. Len(aChaveSE1) <= 4
				aAdd(aChaveSE1,cChaveSE1)
			Endif	

			If Len(aChaveSE1) > 0
				SE1->(dbGoto(nRecSE1))
				If SE1->(Recno()) == nRecSE1
					SE1->(RecLock("SE1",.F.))
					For nCnt:=1 To Len(aChaveSE1)
						SE1->&("E1_ZTITSE"+Alltrim(Str(nCnt))) := aChaveSE1[nCnt]
					Next
					If SE1->(FieldPos("E1_ZSINGEG")) > 0
						SE1->E1_ZSINGEG := cSiniSeg
					Endif
					If SE1->(FieldPos("E1_ZSINSEG")) > 0
						SE1->E1_ZSINSEG := cSiniSeg
					Endif	
					SE1->(Msunlock())
				Endif
			Endif			

			// Atualiza sequencia dos titulos de seguro
			//msgalert("Titulo de seguro "+_cNumero+ " gerado com sucesso.")
			PutMv("MGF_TITSEG",_cNumero)

		Endif

	End Transaction

Return(lRetSeg)


// valida o OK da tela
User Function TudOkFin19()

Local lRet := .T. 

If Empty(cSiniSeg)
	MsgStop("Informe o campo 'Sinistro Seguro' no cabeçalho")
	lRet := .F.
Endif

Return(lRet)	
	
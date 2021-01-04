#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAE04
Autor....:              Marcelo Carneiro         
Data.....:              26/10/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Envio Pedido de Compra de Gado - Parte WS Server consumir o Metodo Gerar Pedido
==========================================================================================================
*/

WSSTRUCT FTAE04_ADIANTAMENTO
	WSDATA E2_ACAO	    as String
	WSDATA E2_FILIAL    as String
	WSDATA E2_NATUREZ 	as String
	WSDATA E2_NUM	    as String
	WSDATA E2_EMISSAO   as String
	WSDATA E2_VENCTO    as String
	WSDATA E2_VENCREA   as String
    WSDATA E2_VALOR     as Float
    WSDATA TIPO			as String
    WSDATA BANCO		as String
    WSDATA AGENCIA		as String
    WSDATA AGENCIADIG	as String OPTIONAL
    WSDATA CONTA		as String
    WSDATA CONTADIG		as String OPTIONAL  
    WSDATA TIPO_CONTA   as String OPTIONAL  
ENDWSSTRUCT

WSSTRUCT FTAE04_RETORNO
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFTAE04 DESCRIPTION "Importação Adiantamento - Pedido de Compra de Gado" NameSpace "http://www.totvs.com.br/MGFTAE04"
	WSDATA WSADIANTAMENTO as FTAE04_ADIANTAMENTO
	WSDATA WSRETORNO      as FTAE04_RETORNO

	WSMETHOD GravarAdiantamento DESCRIPTION "Importação Adiantamento - Pedido de Compra de Gado"	
ENDWSSERVICE

WSMETHOD GravarAdiantamento WSRECEIVE WSADIANTAMENTO WSSEND WSRETORNO WSSERVICE MGFTAE04

Local aSE2        := {}
Local bContinua   := .T.
Local cC7Num      := ''
Local cFornecedor := ''
Local cLoja       := ''
Local aRetorno    := {}    
Local nI          := 0                        
Local nValPar     := 0 
Local cTipo := ""
Local cTipoTit := ""
Local cBanco := ""
Local cAgencia := ""
Local cConta := ""
Local cBancoFor := ""
Local cAgeFor := ""
Local cAgeDigFor := ""
Local cConFor := ""
Local cConDigFor := ""
Local cCusto := ""

Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.      
Private cE2FILIAL       := ::WSADIANTAMENTO:E2_FILIAL
Private cACAO           := ::WSADIANTAMENTO:E2_ACAO
Private cNATUREZA       := ""//::WSADIANTAMENTO:E2_NATUREZ
Private cNUM            := SUBSTR(::WSADIANTAMENTO:E2_NUM,1,6) 
Private cPARCELA        := SUBSTR(::WSADIANTAMENTO:E2_NUM,8,2) 
Private cTipoConta      := Alltrim(::WSADIANTAMENTO:TIPO_CONTA)

If ValType(Self:WSADIANTAMENTO:E2_VALOR) != "N" .or. Self:WSADIANTAMENTO:E2_VALOR == 0
	AAdd(aRetorno ,"2")
	AAdd(aRetorno,'Valor informado está no formato errado')
	bContinua := .F.
Endif	

//Fazer a Validação dos Campos 

If bContinua
	IF !(cACAO $ '123')
		AAdd(aRetorno ,"2")
		AAdd(aRetorno,'E2_ACAO:Ação deverá ser : 1=Inclusão, 2=Alteração, 3=Exclusão')
		bContinua := .F.
	Else
		IF !FWFilExist(cEmpAnt,cE2FILIAL)
			AAdd(aRetorno ,"2")
			AAdd(aRetorno,'E2_FILIAL:Filial não cadastrada')
			bContinua := .F.
		Endif
		If bContinua
			cTipo := Self:WSADIANTAMENTO:Tipo
			If !cTipo $ "123"
				AAdd(aRetorno ,"2")
				AAdd(aRetorno,'TIPO:Tipo deverá ser : 1=Fornecedor, 2=ICMS, 3=ICMS Frete')
				bContinua := .F.
			Endif
		Endif
		
		If bContinua		
			cCusto := GetMv("MGF_TAE23")
			If Empty(cCusto)
				AAdd(aRetorno ,"2")
				AAdd(aRetorno,'CENTRO_CUSTO:Centro de Custo não cadastrado no parâmetro: "MGF_TAE23".')
				bContinua := .F.
			Endif
		Endif
		If bContinua		
			cFilAnt := cE2FILIAL
			//Natureza
			If cTipo == "1"
				cNATUREZA := Alltrim(GetMv("MGF_TAE16"))
			Elseif cTipo == "2"
				cNATUREZA := Alltrim(GetMv("MGF_TAE18"))
			Elseif cTipo == "3"
				cNATUREZA := Alltrim(GetMv("MGF_TAE19"))
			Endif	
			If Empty(cNatureza)
				AAdd(aRetorno ,"2")
				AAdd(aRetorno,'E2_NATUREZ:NATUREZA não cadastrada no parâmetro: '+IIf(cTipo=="1","MGF_TAE16",IIf(cTipo=="2","MGF_TAE18",IIf(cTipo=="3","MGF_TAE19",""))))
				bContinua := .F.
			Endif
		Endif
		If bContinua
			cBancoFor  := Padr(Self:WSADIANTAMENTO:Banco,TamSX3("E2_FORBCO")[1])
			cAgeFor    := Padr(Self:WSADIANTAMENTO:Agencia,TamSX3("E2_FORAGE")[1]) //Padr(StrTran(Self:WSADIANTAMENTO:Agencia,"-",""),TamSX3("A6_AGENCIA")[1])
			cAgeDigFor := Padr(Self:WSADIANTAMENTO:AgenciaDig,TamSX3("E2_FAGEDV")[1])
			cConFor    := Padr(Self:WSADIANTAMENTO:Conta,TamSX3("E2_FORCTA")[1]) //Padr(StrTran(Self:WSADIANTAMENTO:Conta,"-",""),TamSX3("A6_NUMCON")[1])
			cConDigFor := Padr(Self:WSADIANTAMENTO:ContaDig,TamSX3("E2_FCTADV")[1])
			If Empty(cBancoFor) .or. Empty(cAgeFor) .or. Empty(cConFor)
				AAdd(aRetorno ,"2")
				AAdd(aRetorno,'BANCO FORNECEDOR:Banco/Agência/Conta do Fornecedor não informada na Integração.')
				bContinua := .F.
			Else
				If cTipo == "1"	
					cBanco := Padr(GetMv("MGF_TAE20"),TamSX3("A6_COD")[1])
					cAgencia := Padr(GetMv("MGF_TAE21"),TamSX3("A6_AGENCIA")[1])
					cConta := Padr(GetMv("MGF_TAE22"),TamSX3("A6_NUMCON")[1])
					If bContinua
						If Empty(cBanco) .or. Empty(cAgencia) .or. Empty(cConta)
							AAdd(aRetorno ,"2")
							AAdd(aRetorno,"BANCO MARFRIG:Banco/Agência/Conta da Marfrig não cadastrada nos parâmetros 'MGF_TAE20', 'MGF_TAE21', 'MGF_TAE22' respectivamente.")
							bContinua := .F.
						Endif
					Endif	
					If bContinua
						If Empty(cTipoConta) .or. !(cTipoConta $ '1 2')
							AAdd(aRetorno ,"2")
							AAdd(aRetorno,"Tipo de Conta não preenchido ou invalido !.")
							bContinua := .F.
						Endif
					Endif	
					If bContinua
						SA6->(dbSetOrder(1))
						If SA6->(!DbSeek(xFilial("SA6")+cBanco+cAgencia+cConta))
							AAdd(aRetorno ,"2")
							AAdd(aRetorno,'BANCO SA6:Banco/Agência/Conta não cadastrada na tabela de Bancos ( SA6 ).')
							bContinua := .F.
						Endif
					Endif	
				Endif	
			Endif	
		EndIF
		If bContinua	
			dbSelectArea('SED')
			SED->(dbSetOrder(1))
			IF SED->(!dbSeek(xFilial('SED')+ALLTRIM(cNATUREZA))) .OR. Empty(cNATUREZA)
				AAdd(aRetorno ,"2")
				AAdd(aRetorno,'E2_NATUREZ:Natureza não cadastrada')
				bContinua := .F.
			Else
				//Verificando  se o Pedido do Taura Existe
				DbSelectArea('SC7')
				SC7->(DbOrderNickName('IDZPTAURA'))
				IF SC7->(DbSeek(cE2FILIAL+cNUM))
					cC7Num      := cNUM //SC7->C7_NUM
					cFornecedor := SC7->C7_FORNECE
					cLoja       := SC7->C7_LOJA
					IF cACAO $ '12'
						IF cACAO == '1'
							DbSelectArea('SE2')
							SE2->(DbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
							//IF SE2->(DbSeek(Padr(cE2FILIAL,TamSX3("E2_FILIAL")[1])+Padr('TAU',TamSX3("E2_PREFIXO")[1])+Padr(cC7Num+'-'+cParcela,TamSX3("E2_NUM")[1])+'  '+'PA '+cFornecedor+cLoja))
							//	AAdd(aRetorno ,"2")
							//	AAdd(aRetorno,'E2_NUM:Adiantamento já Cadastrado !!')
							//	bContinua := .F.
							//EndIF
							nValPar := ::WSADIANTAMENTO:E2_VALOR
						EndIF
						If cTipo == "1"
							IF bContinua
								IF cACAO == '2'
									DbSelectArea('SE2')
									SE2->(DbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
									IF SE2->(DbSeek(Padr(cE2FILIAL,TamSX3("E2_FILIAL")[1])+Padr('TAU',TamSX3("E2_PREFIXO")[1])+Padr(cC7Num+'-'+cParcela,TamSX3("E2_NUM")[1])+'  '+'PA '+cFornecedor+cLoja))
										nValPar := ::WSADIANTAMENTO:E2_VALOR  - SE2->E2_VALOR
									EndIF
								EndIF
								IF cACAO $ '12'  .And. !U_AE02_TOTALPED('2',cE2FILIAL,cNUM, nValPar)
									AAdd(aRetorno ,"2")
									AAdd(aRetorno,'E2_VALOR:Valor do adiantamento supera o do pedido !!')
									bContinua := .F.
								EndIF
							EndIF
						Endif	
					EndIF
				Else
					AAdd(aRetorno ,"2")
					AAdd(aRetorno,'E2_NUM:Pedido de Compra do Taura não encontrado !!')
					bContinua := .F.
				EndIF
			EndIF
		EndIF
	Endif
EndIF              
IF cTipo <> '1'
	IF GetAdvFVal( "SA2", "A2_TIPO", xFilial('SA2')+cFornecedor+cLoja, 1, "" ) == 'F'    
	    cLoja       := '01'
    EndIF
EndIF
IF bContinua
	If cTipo == "1"
		cTipoTit := "PA "
	Elseif cTipo == "2" .or. cTipo == "3"
		cTipoTit := "DP "
	Endif	
	DbSelectArea('SE2')
	SE2->(DbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	//IF SE2->(DbSeek(Padr(cE2FILIAL,TamSX3("E2_FILIAL")[1])+Padr('TAU',TamSX3("E2_PREFIXO")[1])+Padr(cC7Num+'-'+cParcela,TamSX3("E2_NUM")[1])+'  '+'PA '+cFornecedor+cLoja))
	IF SE2->(DbSeek(Padr(cE2FILIAL,TamSX3("E2_FILIAL")[1])+Padr('TAU',TamSX3("E2_PREFIXO")[1])+Padr(cC7Num+'-'+cParcela,TamSX3("E2_NUM")[1])+'  '+cTipoTit+cFornecedor+cLoja))	
		If cTipo == "1"
			//U_AE02_VINCULA_AD('2',cE2FILIAL,cC7Num)
		Endif	       
		SetFunName("MGFTAE04")
		aSE2 := { 	{ "E2_PREFIXO"  , SE2->E2_PREFIXO 	, NIL },;
		{ "E2_NUM"      , SE2->E2_NUM     	, NIL },;
		{ "E2_TIPO"     , SE2->E2_TIPO    	, NIL },;
		{ "E2_NATUREZ"  , SE2->E2_NATUREZ	, NIL },;
		{ "E2_FORNECE"  , SE2->E2_FORNECE 	, NIL },;
		{ "E2_LOJA"     , SE2->E2_LOJA		, NIL },;
		{ "E2_EMISSAO"  , SE2->E2_EMISSAO	, NIL },;
		{ "E2_VENCTO"   , SE2->E2_VENCTO  	, NIL },;
		{ "E2_VENCREA"  , SE2->E2_VENCREA 	, NIL },;
		{ "E2_VALOR"    , SE2->E2_VALOR   	, NIL }}

		dbSelectArea("SE2")
		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aSE2,, 5)
		IF lMsErroAuto
			aErro := GetAutoGRLog()
			cErro := ""
			For nI := 1 to Len(aErro)
				cErro += aErro[nI] + CRLF
			Next nI
			
			AAdd(aRetorno ,"2")
			AAdd(aRetorno ,'Erro na Exclusão:'+cErro)
			bContinua   := .F.
		Else
			bContinua   := .T.
			IF cACAO == '3'
				AAdd(aRetorno ,"1")
				If cTipo == "1"
					AAdd(aRetorno ,'Adiantamento Excluído')
				Else
					AAdd(aRetorno ,"Título 'DP' Excluído")
				Endif	
				If cTipo == "1"
					//U_AE02_VINCULA_AD('1',cE2FILIAL,cC7Num)
				Endif	
			EndIF
		Endif
	Else
	  IF cACAO == '3'	
		AAdd(aRetorno ,"2")
		AAdd(aRetorno ,'Não encontrado o Adiantamento para excluir !!')
		bContinua   := .F.
      EndIF
	EndIF
EndIF

// se for inclusão ou Alteração
IF bContinua .AND. ( cACAO == '1' .OR.  cACAO == '2' )
	SetFunName("FINA050")
	Pergunte("FIN050",.F.)
	//mv_par05 := 2 // NAO: Gerar Chq.p/Adiant. ?         
	//mv_par09 := 2 // NAO: Mov.Banc.sem Cheque ?         
	mv_par05 := SetMVPar(Padr("FIN050",10),"05",2)
	mv_par09 := SetMVPar(Padr("FIN050",10),"09",2)
	
	aSE2 := {}
	AAdd(aSE2, { "E2_PREFIXO"  , "TAU"               , NIL })
	AAdd(aSE2, { "E2_NUM"      , cC7Num+'-'+cParcela , NIL })
	AAdd(aSE2, { "E2_TIPO"     , cTipoTit/*"PA"*/                , NIL })
	AAdd(aSE2, { "E2_NATUREZ"  , cNATUREZA           , NIL })
	AAdd(aSE2, { "E2_FORNECE"  , cFornecedor         , NIL })
	AAdd(aSE2, { "E2_LOJA"     , cLOJA               , NIL })
	AAdd(aSE2, { "E2_EMISSAO"  , StoD(::WSADIANTAMENTO:E2_EMISSAO) , NIL })
	AAdd(aSE2, { "E2_VENCTO"   , StoD(::WSADIANTAMENTO:E2_VENCTO)  , NIL })
	AAdd(aSE2, { "E2_VENCREA"  , StoD(::WSADIANTAMENTO:E2_VENCREA) , NIL })
	AAdd(aSE2, { "E2_ZPTAURA"  , cC7Num                    , NIL })
	AAdd(aSE2, { "E2_VALOR"    , ::WSADIANTAMENTO:E2_VALOR , NIL } )
    IF cTipo == "1"
		AAdd(aSE2, { "AUTBANCO"    , cBanco  		        , NIL } )
		AAdd(aSE2, { "AUTAGENCIA"  , cAgencia     		, NIL } )
		AAdd(aSE2, { "AUTCONTA"    , cConta          		, NIL } )
	EndIF
/*	AAdd(aSE2, { "E2_FORBCO"   , cBancoFor	        , NIL } )
	AAdd(aSE2, { "E2_FORAGE"   , cAgeFor	     		, NIL } )
	IF !Empty(cAgeDigFor)
		AAdd(aSE2, { "E2_FAGEDV"   , cAgeDigFor     		, NIL } )
	EndIF
	AAdd(aSE2, { "E2_FORCTA"   , cConFor         		, NIL } )
	IF !Empty(cConDigFor)
		AAdd(aSE2, { "E2_FCTADV"   , cConDigFor     		, NIL } )
	EndIF
  */						         
	dbSelectArea("SE2")
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aSE2,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	
	IF lMsErroAuto
		aErro := GetAutoGRLog() // Retorna erro em array
		cErro := ""
		For nI := 1 to Len(aErro)
		cErro += aErro[nI] + CRLF
		Next nI
		AAdd(aRetorno ,"2")
		AAdd(aRetorno,cErro)
	Else
		AAdd(aRetorno ,"1")
		If cTipo == "1"
			AAdd(aRetorno,'Adiantamento Incluso/Alterado com sucesso !!!' )
			
		Else
			AAdd(aRetorno,"Título 'DP' Incluso/Alterado com sucesso !!!" )
		Endif	
		SE2->(DbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		IF SE2->(DbSeek(Padr(cE2FILIAL,TamSX3("E2_FILIAL")[1])+Padr('TAU',TamSX3("E2_PREFIXO")[1])+Padr(cC7Num+'-'+cParcela,TamSX3("E2_NUM")[1])+'  '+cTipoTit+cFornecedor+cLoja))
			SE2->(Reclock("SE2",.F.))
			SE2->E2_XFINALI := IIF(cTipoConta == '1','01','11')
			SE2->E2_FORBCO  := cBancoFor	        
			SE2->E2_FORAGE  := cAgeFor	
			IF !Empty(cAgeDigFor)
				SE2->E2_FAGEDV := cAgeDigFor     		
			Else
				SE2->E2_FAGEDV :=  ' '
			EndIF
			SE2->E2_FORCTA := cConFor
			IF !Empty(cConDigFor)
				SE2->E2_FCTADV := cConDigFor     		
			Else                                        
				SE2->E2_FCTADV := ' '
			EndIF
			SE2->(MsUnlock())
		EndIF				
		IF cACAO == '1'
			If cTipo == "1"
			    //U_AE02_VINCULA_AD('2',cE2FILIAL,cC7Num)
			Endif 
		EndIF
		If cTipo == "1"
			//U_AE02_VINCULA_AD('1',cE2FILIAL,cC7Num)
		Endif	
	Endif
EndIF	
If Empty(aRetorno)
	AAdd(aRetorno ,"2")
	AAdd(aRetorno,'Erro indeterminado.')
Endif
::WSRETORNO := WSClassNew( "FTAE04_RETORNO")
::WSRETORNO:STATUS  := aRetorno[1]
::WSRETORNO:MSG	    := aRetorno[2]

Return .T.     


Static Function SetMVPar(cPerg,cOrdem,xValor)

SX1->(dbSetOrder(1))  // X1_GRUPO, X1_ORDEM
If SX1->(dbSeek(cPerg+cOrdem,.F.))
	SX1->(Reclock("SX1",.F.))
	If ValType(xValor) != "N"
		SX1->X1_CNT01 := xValor
	Else	
		SX1->X1_PRESEL := xValor
	Endif	
	SX1->(MsUnlock())
EndIf

SetMVValue(cPerg,"MV_PAR"+cOrdem,xValor)
&("MV_PAR"+cOrdem) := xValor

Return(xValor)

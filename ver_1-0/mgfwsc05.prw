#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFWSC05
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Integracao de Estoque com SFA
=====================================================================================
*/
user function MGFWSC05( aEmpX, _nfila )

	Default _nfila := 0

	U_MFCONOUT(' Iniciando processamento...') 

	U_MFCONOUT('Processamento filial ' + aEmpX[3])

	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA aEmpX[2] FILIAL aEmpX[3]

	U_MFCONOUT(' Iniciada a empresa ' + allTrim( aEmpX[2] ) )

	If _nfila > 0 //Registro de processamento multithread

		ZCE->(Dbsetorder(1)) //ZCE_FILIAL+ZCE_PROD
		_nrecfil := 999999999999 - _nfila

		If ZCE->(Dbseek(alltrim(str(_nrecfil))))

			If !ZCE->(MsRLock(ZCE->(RECNO())))	
				U_MFCONOUT('Falha no controle de multithreading!')
				Return
			Else
			  ZCE->(MsRunlock())
			Endif

			Reclock("ZCE",.F.)
			ZCE->ZCE_QTAURA := 1 //0 FILA LIVRE, 1 FILA OCUPADA
			ZCE->ZCE_Thread := ThreadId() //THREAD EM PROCESSAMENTO
	
		Endif

	Endif

	MGFWSC05F( aEmpx ) //Executa processamento da integração

	U_MFCONOUT(' Completou exportação da filial ' + allTrim( aEmpX[3] ) )

	If _nfila > 0 //Registro de fim de processamento multithread

		ZCE->(Dbsetorder(1)) //ZCE_FILIAL+ZCE_PROD
		_nrecfil := 999999999999 - _nfila
		If ZCE->(Dbseek(alltrim(str(_nrecfil))))

			If !ZCE->(MsRLock(ZCE->(RECNO())))	
				U_MFCONOUT('Falha no controle de multithreading!')
				Return
			Else
			  ZCE->(MsRunlock())
			Endif

			Reclock("ZCE",.F.)
			ZCE->ZCE_QTAURA := 0 //0 FILA LIVRE, 1 FILA OCUPADA
			//ZCE->ZCE_Thread := 0 //THREAD EM PROCESSAMENTO
			ZCE->(Msunlock())

		Endif

	Endif

	RESET ENVIRONMENT


return

/*
=====================================================================================
Programa.:              jMGFWSC05
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Chamada de  job para Integracao de Estoque com SFA
=====================================================================================
*/
user function jMGFWC05(cFilJob)

	U_MGFWSC05({,"01",cFilJob}) //Executa o processamento da integração como job

Return 

/*
=====================================================================================
Programa.:              eMGFWS05
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Chamada de tela para Integracao de Estoque com SFA
=====================================================================================
*/
user function eMGFWS05()

    If msgyesno("Exporta estoques da filial " + cfilant + " para o SFA?","Exportação de estoques")

		fwmsgrun(,{|oproc| MGFWSC05F({,"01",cfilant},oproc) }, "Aguarde...","Processando integração com SFA")

		MsgAlert('Processo concluido!')

	Else

		MsgAlert('Processo cancelado!')

	Endif

Return 

/*
=====================================================================================
Programa.:              MGFWSC05F
Autor....:              Josué Danich Prestes
Data.....:              01/08/2019
Descricao / Objetivo:   Chama integrações por filial para o SFA
=====================================================================================
*/
static function MGFWSC05F(aEmpx,oproc)

Default oproc := nil

If valtype(oproc) == "O" //Se tem tela
	oproc:cCaption := ("Exportando dados da filial " + aEmpx[3] + "...")
	processmessages()
Endif

U_MFCONOUT("Iniciando exportação para filial " + aEmpx[3] + "...")

_cfilori := cFilAnt
cfilant := aEmpx[3]
	
U_MGFWSC5R(oproc)
	
cfilant := _cfilori

U_MFCONOUT("Completada exportação para filial " + aEmpx[3] + "...")

U_MFCONOUT('Completado processo de exportação SFA')

Return


/*
=====================================================================================
Programa.:              MGFWSC5R
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Executa Integracao de Estoque com SFA
=====================================================================================
*/
User function MGFWSC5R(oproc)

	local cURLPost		:= ""
	Local lLog			:= .F.
	local oWSSFA		:= nil
	Local _nrecnot      := 0
	Local _ntot         := 0
	Local _npos         := 1
	local bError 		:= ErrorBlock( { |oError| MGFWSC05E( oError ) } )

	private	qTaura		:= 0
	private oStock		:= nil
	Private aRet        := {}          
	Private cFEFO       := ''

	cURLPost		:= allTrim(getMv("MGF_SFA05")) //
	lLog			:= SUPERGETMV("MGF_LOGSFA",.f.,.f.) // controle de log 

	If valtype(oproc) == "O" //Se tem tela
		oproc:cCaption := ("Carregando produtos da filial " + cfilant + "...")
		processmessages()
	Else
		U_MFCONOUT("Carregando produtos da filial " + cfilant + "...")
	Endif

	MGFWSC05G() //Seleciona produtos em estoque

	//Conta produtos
	while !QRYSB2->(EOF())
		_ntot++
		QRYSB2->(Dbskip())
	End
	QRYSB2->(Dbgotop())

	while !QRYSB2->(EOF())
	
		If valtype(oproc) == "O" //Se tem tela

			oproc:cCaption := ("Exportando dados da filial " + cfilant + " - Produto " + strzero(_npos,6) + " de " + strzero(_ntot,6))
			processmessages()
			_npos++

		Else

			U_MFCONOUT("Exportando dados da filial " + cfilant + " - Produto " + strzero(_npos,6) + " de " + strzero(_ntot,6))
			_npos++

		Endif

		_ntimeini := seconds() //segundos desde a meia noite
		_ddtini := date()
		_chrini := time()
		
		oStock := nil
		oStock := stockSFA():new()

		aRet := {0}
	
		U_MFCONOUT(' [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + " - Iniciando leitura estoque do Taura do produto " + QRYSB2->idproduto )
			
		_ntauraini := seconds() //segundos desde a meia noite
		oStock:setStock() //Lê estoque do Taura
		_ntauratmp := seconds() - _ntauraini 

		If _ntauratmp < 0
			_ntauratmp := 0
		Endif

		_nsfatmp := 0

		U_MFCONOUT(' [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + " - Completada leitura estoque do Taura do produto " + oStock:PRODUTO:IDPRODUTO )
			
		U_MFCONOUT(' [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + " - Iniciando envio estoque para SFA do produto " + oStock:PRODUTO:IDPRODUTO )
				
		_nsfaini := seconds() //segundos desde a meia noite 
		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oStock /*oObjToJson*/, /*nKeyRecord*/, /*cTblUpd*/, /*cFieldUpd*/, allTrim(getMv("MGF_SFACOD")) /*cCodint*/, allTrim(getMv("MGF_SFA05T")) /*cCodtpint*/)
		oWSSFA:lLogInCons := .T. //Se informado .T. exibe mensagens de log de integração no console quando executado o método sendByHttpPost. Não obrigatório. DEFAULT .F.
		oWSSFA:sendByHttpPost()
		_nsfatmp := (seconds()  - _nsfaini)

		If _nsfatmp < 0
			_nsfatmp := 0
		Endif

			
		If oStock:sucesso == 1 //Se leu o Taura com sucesso 

			U_MFCONOUT(' [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + " - Completado envio estoque para SFA do produto " + oStock:PRODUTO:IDPRODUTO )
			
		Else

			U_MFCONOUT(' [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + " - Zerado estoque por falha na leitura estoque do Taura do produto " + oStock:PRODUTO:IDPRODUTO )

		Endif

		_ntimefim := seconds() //segundos desde a meia noite
		_ntemptot := (_ntimefim - _ntimeini)

		if _ntemptot < 0
			_ntemptot := 0
		Endif
		
		If oStock:sucesso == 1 //Se leu o Taura com sucesso

				Reclock("ZCE",.T.)
				ZCE->ZCE_FILIAL := cFilAnt
				ZCE->ZCE_THREAD := ThreadId()
				ZCE->ZCE_PROD	:= oStock:PRODUTO:IDPRODUTO
				ZCE->ZCE_QTAURA	:= qTaura //quantidade retornada pelo Taura
				ZCE->ZCE_QPROTH	:= oStock:QTDESTOQUE
				ZCE->ZCE_DATAI	:= _ddtini 
				ZCE->ZCE_HORAI	:= _chrini
				ZCE->ZCE_DATAF	:= dATE() 
				ZCE->ZCE_HORAF	:= TIME()
				ZCE->ZCE_TMPTOT := _ntemptot
				ZCE->ZCE_TMPTAU := _ntauratmp
				ZCE->ZCE_TMPSFA := _nsfatmp
				ZCE->ZCE_UUID   := oStock:UUID
				ZCE->ZCE_UUID2   := oStock:UUID2
				ZCE->ZCE_LOGSFA	:= oWSSFA:CDETAILINT //Log do envio para o SFA	
				ZCE->ZCE_LOGTAU := oStock:PAYLOAD //String retornado pelo Taura	
				ZCE->ZCE_LOGTA2 := oStock:PAYLOAD2 //String retornado pelo Taura
				ZCE->ZCE_ENVSFA	:= oWSSFA:cJson //String enviado para o SFA	
				ZCE->ZCE_ENVTAU := oStock:ENV //String enviado para o Taura	
				ZCE->ZCE_ENVTA2 := oStock:ENV2 //String enviado para o Taura	
				ZCE->ZCE_TAUROK := "S" 
				ZCE->ZCE_SFAOK  := iif(oWSSFA:lok,"S","N")
				ZCE->ZCE_TUDOOK := iif(oWSSFA:lok,"S","N")	
				ZCE->(MsUnlock())

		Else

				Reclock("ZCE",.T.)
				ZCE->ZCE_FILIAL := cFilAnt
				ZCE->ZCE_THREAD := ThreadId()
				ZCE->ZCE_PROD	:= oStock:PRODUTO:IDPRODUTO
				ZCE->ZCE_QTAURA	:= qTaura //quantidade retornada pelo Taura
				ZCE->ZCE_QPROTH	:= oStock:QTDESTOQUE
				ZCE->ZCE_DATAI	:= _ddtini 
				ZCE->ZCE_HORAI	:= _chrini
				ZCE->ZCE_DATAF	:= dATE() 
				ZCE->ZCE_HORAF	:= TIME()
				ZCE->ZCE_TMPTOT := _ntemptot
				ZCE->ZCE_TMPTAU := _ntauratmp
				ZCE->ZCE_TMPSFA := _nsfatmp
				ZCE->ZCE_UUID   := oStock:UUID
				ZCE->ZCE_UUID2  := oStock:UUID2
				ZCE->ZCE_LOGSFA	:= oWSSFA:CDETAILINT //Log do envio para o SFA	
				ZCE->ZCE_LOGTAU := oStock:PAYLOAD //String retornado pelo Taura	
				ZCE->ZCE_LOGTA2 := oStock:PAYLOAD2 //String retornado pelo Taura
				ZCE->ZCE_ENVSFA	:= oWSSFA:cJson //String enviado para o SFA	
				ZCE->ZCE_ENVTAU := oStock:ENV //String enviado para o  Taura	
				ZCE->ZCE_ENVTA2 := oStock:ENV2 //String enviado para o Taura	
				ZCE->ZCE_TAUROK := "N" 
				ZCE->ZCE_SFAOK  := iif(oWSSFA:lok,"S","N")
				ZCE->ZCE_TUDOOK := "N"
				ZCE->(MsUnlock())

		Endif

		freeObj( oStock )
		freeObj( oWSSFA )

		QRYSB2->(DBSkip())
	enddo

	QRYSB2->(DBCloseArea())

	delClassINTF() //Exclui Classes criadas

return

/*
=====================================================================================
Programa.:              MGFWSC05E
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Tratamento de erros
=====================================================================================
*/
static function MGFWSC05E(oError)
	local nQtd := MLCount(oError:ERRORSTACK)
	local ni
	local cEr := ''

	for ni:=1 to nQtd
		cEr += memoLine(oError:ERRORSTACK,,ni)
	next ni

	conout( cEr )

	_aErr := { '0', cEr }

return .T.

/*
=====================================================================================
Programa.:              ProdutoSFA
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Classe de definição de dados do produto
=====================================================================================
*/
class ProdutoSFA
data centrodistribuicao		as string
data idestruturatipopedido	as string
data idproduto				as string

method New()
EndClass

method new() class ProdutoSFA
return

/*
=====================================================================================
Programa.:              stockSFA
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Classe de tratamento de estoque para o SFA
=====================================================================================
*/
class stockSFA
data applicationArea	as ApplicationArea
data produto			as produtoSFA
data qtdEstoque			as float
data pesoMedio			as float
data sucesso            as integer
data payload            as string
data uuid               as string
data payload2           as string
data uuid2              as string
data env                as string
data env2               as string

method New()
method setStock()
endclass
return

/*
Construtor
*/
method new() class stockSFA
	self:applicationArea	:= ApplicationArea():new()
	self:produto			:= ProdutoSFA():new()
return

/*
Carrega o objeto
*/
Method setStock() Class stockSFA
	local nPorcSFA	:= superGetMv( "MGF_SFA05B" , , 90 )

	::produto:idproduto 			:= allTrim( QRYSB2->idproduto )
	::produto:centrodistribuicao	:= allTrim( cFilAnt )
	::produto:idestruturatipopedido	:= QRYSB2->idtipopedi

	aRetStock := {}
	aRetStock := MGFWSC05T( QRYSB2->idproduto, "", cFilAnt, .T. )

	::payload  := aRetStock[4]
	::uuid     := aRetStock[5]
	::payload2 := aRetStock[6]
	::uuid2    := aRetStock[7]
	::env      := aRetStock[8]
	::env2     := aRetStock[9]

	If aRetStock[3]

		::pesoMedio := aRetStock[2]

		if aRetStock[1] > 0
			::qtdEstoque := ( ( nPorcSFA / 100 ) * aRetStock[1] )		
		else
			::qtdEstoque := aRetStock[01]
		endif

		::sucesso := 1

	Else

		::sucesso := 0

	Endif


return

/*
=====================================================================================
Programa.:              MGFWSC05G
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Seleciona produtos em estoque
=====================================================================================
*/
static function MGFWSC05G()   
	local cQrySB2		:= ""
	local cFilSFA		:= allTrim( getMv( "MGF_SFASZJ" ) ) // 'VE','FF','PR'

  
	
	cQrySB2 := " select distinct x.idproduto idproduto, x.idtipopedido idtipopedi,"	+ CRLF
	cQrySB2 += " SZJ.ZJ_FEFO, SZJ.ZJ_MINIMO, SZJ.ZJ_MAXIMO"														+ CRLF
	cQrySB2 += " from v_listapreco x"										+ CRLF
	cQrySB2 += " INNER JOIN " + retSQLName("SZJ") + " SZJ"							+ CRLF
	cQrySB2 += " ON"																+ CRLF
	cQrySB2 += " 		SZJ.ZJ_COD		= X.idtipopedido"							+ CRLF
	cQrySB2 += " 	AND	SZJ.D_E_L_E_T_	= ' '"										+ CRLF
	cQrySB2 += " where"																+ CRLF
	cQrySB2 += "		x.idtipopedido			in	(" + cFilSFA + ")"				+ CRLF
	cQrySB2 += " 	AND	x.CENTRODISTRIBUICAO	=	'" + cFilAnt + "'"				+ CRLF
	cQrySB2 += " order by x.idproduto, x.idtipopedido desc"							+ CRLF
   
	/*  //Ativar esse trecho para fazer testes rápidos com apenas um produto por filial
	cQrySB2 := "select '303675' idproduto, 'VE' idtipopedi, "
	cQrySB2 += " SZJ.ZJ_FEFO, SZJ.ZJ_MINIMO, SZJ.ZJ_MAXIMO FROM SZJ010 SZJ "
	cQrySB2 += " WHERE SZJ.ZJ_COD = 'VE' "
	*/

	TcQuery cQrySB2 New Alias "QRYSB2"

return


/*
=====================================================================================
Programa.:              MGFWSC05T.
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Retorna saldo do Produto apos consulta com Taura 
OBS.................:   Pedido deve estar posicionado
Retorno.............:   Array: [1] = Saldo (Taura - Protheus) [2] = Peso Medio
							[3] = Sucesso [4] = Payload resp [5] = UUID
							[6] = Payload resp 2 [7] = UUID resp 2
=====================================================================================
*/
static function MGFWSC05T( cB1Cod, cC5Num, cStockFil, lJobStock, dDtMin, dDtMax, _BlqEst )
	local cQueryProt	:= ""
	local nRetProt		:= 0
	local nRetProt2		:= 0
	local aArea			:= getArea()
	local aAreaSZJ		:= SZJ->(getArea())
	local aAreaSA1		:= SA1->(getArea())
	local aAreaSB1		:= SB1->(getArea())

	local aRet			:= {}
	local aRet2			:= {}
	local nSalProt		:= 0
	local nSalProt2		:= 0
	local nPesoMedio	:= 0
	local aRetStock		:= { 0 , 0 }

	local lRet			:= .T.
	local lFefo			:= .F.

	local nMGFDTMIN		:= 0
	local nMGFDTMAX		:= 0

	local dDataMin		:= CTOD("  /  /  ")
	local dDataMax		:= CTOD("  /  /  ")

	local nDtMin		:= superGetMv("MGF_DTMIN", , 0 )
	local nDtMax		:= superGetMv("MGF_DTMAX", , 0 )

	local nDtMinPr		:= superGetMv( "MGF_MINPR", , 0 )
	local nDtMaxPr		:= superGetMv( "MGF_MAXPR", , 0 )

	default lJobStock	:= .F.
	default cC5Num		:= space(06)
	default cStockFil	:= cFilAnt

	default dDtMin		:= CTOD("  /  /  ")
	default dDtMax		:= CTOD("  /  /  ")
	default _BlqEst		:= .F.

	BEGIN SEQUENCE

	if !empty( dDtMin )
		dDataMin := dDtMin
	endif

	if !empty( dDtMax )
		dDataMax := dDtMax
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		lFefo := .T.
	endif

	if lJobStock
		if QRYSB2->ZJ_FEFO <> 'S'
			// Para o tipo VE as datas nao importam na consulta ao Taura, mas na conta para debitar Pedidos do Protheus sim
			dDataMin := CTOD("  /  /  ")
			dDataMax := CTOD("  /  /  ")
		elseif QRYSB2->ZJ_FEFO == 'S'
			dDataMin := dDataBase + QRYSB2->ZJ_MINIMO
			dDataMax := dDataBase + QRYSB2->ZJ_MAXIMO
		endif
	endif

	if lJobStock
		if QRYSB2->ZJ_FEFO <> 'S'
			If !(U_MGFTAE21( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax ))
				lret := .F.
			    Break
			Endif
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos

			if !(U_MGFTAE21( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax ))
				lret := .F.
			    Break
			Endif


			nRetProt := MGFWSC05P( QRYSB2->idproduto, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			If !(U_MGFTAE21( @aRet2, cStockFil, QRYSB2->idproduto, .T., dDataMin, dDataMax ))
				lret := .F.
			    Break
			Endif

			nRetProt2 := MGFWSC05P( QRYSB2->idproduto, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	else
		DBSelectArea('SZJ')
		SZJ->(DBSetOrder(1))
		SZJ->(DBSeek(xFilial('SZJ') + SC5->C5_ZTIPPED))

		if SZJ->ZJ_FEFO <> 'S'
			if !empty( dDataMin ) .and. !empty( dDataMax )
				If !(U_MGFTAE21( @aRet, cStockFil, cB1Cod, .T., dDataMin, dDataMax ))
					lret := .F.
				    Break
				Endif

				nRetProt := 0
				nRetProt := MGFWSC05P( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
				nSalProt := 0
				nSalProt := ( aRet[01] - nRetProt )

				// CASO TENHA PARAMETRIZADO DATA, DEVERA VERIFICAR COM VE SEM DATA
				aRet2 := {0}
				If !(U_MGFTAE21( @aRet2, cStockFil, cB1Cod, .F., dDataMin, dDataMax ))
					lret := .F.
				    Break
				Endif

				nRetProt2 := MGFWSC05P( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
				nSalProt2 := ( aRet2[01] - nRetProt2 )

				// SE - 'VE com Data' for maior que 'VE sem Data' - Considera SEM DATA
				if nSalProt > nSalProt2
					aRet := {}
					aRet := aClone( aRet2 )

					dDataMin := CTOD("  /  /  ")
					dDataMax := CTOD("  /  /  ")
				endif

			else
				If !(U_MGFTAE21( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax ))
					lret := .F.
				    Break
				Endif
			endif
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos
			If !(U_MGFTAE21( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax ))
				lret := .F.
			    Break
			Endif

			nRetProt := MGFWSC05P( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			If !(U_MGFTAE21( @aRet2, cStockFil, cB1Cod, .T., dDataMin, dDataMax ))
				lret := .F.
			    Break
			Endif

			nRetProt2 := MGFWSC05P( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	endif

	if aRet[2] > 0
		nPesoMedio := ( aRet[1] / aRet[2] )
	endif

	nRetProt := 0
	nSalProt := 0
	U_MFCONOUT("Parametros enviado para a função MGFWSC05P: "+cB1Cod +"," + cStockFil + "," + cC5Num )
	nRetProt := MGFWSC05P( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	nSalProt := ( aRet[01] - nRetProt )
	qTaura   := aRet[01]
	restArea(aAreaSB1)
	restArea(aAreaSA1)
	restArea(aAreaSZJ)
	restArea(aArea)

	_cpayload := aret[06]
	_cuuid := aret[07]
	_cenv := aret[08]
	

	If len(aret2) > 5

		_cpayload2 := aret2[06]
		_cuuid2 := aret2[07]
		_cenv2 := aret2[08]

	Else

		_cpayload2 := ""
		_cuuid2 := ""
		_cenv2 := ""

	Endif

	aRetStock := { nSalProt, nPesoMedio, lret, _cpayload,_cuuid, _cpayload2,_cuuid2,_cenv,_cenv2 }
	U_MFCONOUT("[MGFWSC05] - Resultado da funcao MGFWSC05T: Saldo: "+ Alltrim(Transform(nSalProt,"@E 999,999,999.9999")) + " Peso Medio: "+ Alltrim(Transform(nPesoMedio,"@E 999,999,999.9999")) )

	END SEQUENCE 

	//Se falhou a leitura do Taura retorna erro para não zerar estoque
	If !lret

		_cpayload := " "
		_cuuid := " "
		_cpayload2 := " "
		_cuuid2 :=  " "
		_cenv := " "
		_cenv2 := " "

		If len(aret) > 5

			_cpayload :=  aret[06]	
			_cuuid := aret[07]
			_cenv := aret[08]

		Endif

		If len(aret2) > 5

			_cpayload2 := aret2[06]
			_cuuid2 := aret2[07]
			_cenv2 := aret2[08]

		Endif

		aRetStock := { 0, 0, .F., _cpayload,_cuuid, _cpayload2,_cuuid2,_cenv,_cenv2 }

	Endif   

return aRetStock

/*
=====================================================================================
Programa.:              MGFWSC05P
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Retorna o saldo de Pedidos
=====================================================================================
*/
static function MGFWSC05P( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )

	local nSaldoPV		:= 0
	local cQueryProt	:= ""
	local cQryPv		:= getNextAlias()

	U_MFCONOUT("Parametros recebido na função MGFWSC05P: "+cB1Cod +"," + cStockFil + "," + cC5Num )

	// a query abaixo para trazer o saldo que o Protheus tem de pedidos, por produto
	// desconsidera o pedido que está sendo manipulado no momento ou analisado
	// mas considera todos os pedidos que estão com bloqueio seja de estoque o não no sistema
	// gerando erro. Criado um parametro no final para informar se deve ou não descosiderar
	// pedidos com bloqueio de estoque.

	cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
	cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "

	cQueryProt  += " WHERE"
	cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
	cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
	cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
	cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
	cQueryProt  += "  	AND C6_NOTA			=	'         '"
	cQueryProt  += "  	AND C6_BLQ			<>	'R'"

	if !empty( cC5Num )
		cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		cQueryProt  += " AND"
		cQueryProt  += "     ("
		cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "         OR"
		cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "     )"
	endif

	tcQuery cQueryProt New Alias (cQryPv)

	if !(cQryPv)->(EOF())
		nSaldoPV := (cQryPv)->SALDO
	endif

	If Select(cQryPv) > 0
		(cQryPv)->(DBCloseArea())
	EndIf
	U_MFCONOUT("[MGFWSC05] - Resultado da Query funcao MGFWSC05P saldo pvs: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )

	// agora processo o saldo de pedidos que estão com bloqueio de estoque
	// e desconto essa quantidade na quantidade de pedido que a query anterior trouxe pois havia contemplado
	// erroneamente todos os pedidos mesmos os que estão com bloqueio de estoque

	if _BlqEst
		cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
		cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SZV") + " SZV ON SZV.ZV_FILIAL = C5.C5_FILIAL AND SZV.ZV_PEDIDO = C5.C5_NUM AND SZV.D_E_L_E_T_ = ' ' AND SZV.ZV_CODRGA IN ('000011') AND SZV.ZV_ITEMPED = C6.C6_ITEM "
		cQueryProt  += " WHERE"
		cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
		cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
		cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
		cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
		cQueryProt  += "  	AND C6_NOTA			=	'         '"
		cQueryProt  += "  	AND C6_BLQ			<>	'R'"
		cQueryProt  += "  	AND C5.C5_ZBLQRGA = 'B' "
		cQueryProt  += "  	AND SZV.ZV_CODAPR = ' ' "
		if !empty( cC5Num )
			cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
		endif

		if !empty( dDataMin ) .and. !empty( dDataMax )
			cQueryProt  += " AND"
			cQueryProt  += "     ("
			cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "         OR"
			cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "     )"
		endif

		Conout("[MGFWSC05] - Roda Query funcao MGFWSC05P: "+ cQueryProt )
		tcQuery cQueryProt New Alias (cQryPv)

		if !(cQryPv)->(EOF())
			nSaldoPV := nSaldoPV - (cQryPv)->SALDO
		endif

		If Select(cQryPv) > 0
			(cQryPv)->(DBCloseArea())
		EndIf
		U_MFCONOUT("[MGFWSC05] - Resultado da Query funcao MGFWSC05P - saldos bloqueados: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )
	ENDIF

return nSaldoPV

/*
=====================================================================================
Programa.:              mMGFWSC05
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Chamada de Integracao de Estoque com SFA, multithreads
=====================================================================================
*/
user function mMGFWC05()

Local _afiliais := {}
Local _cfiliais := ""
Local _nmaxthreads := 0
Local _nmaxtempo := 0

U_MFCONOUT(' Iniciando processamento multifilial...') 
RPCSetType( 3 )
PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010001'
U_MFCONOUT('Carregado ambiente para ler filiais...')

U_MFCONOUT('Validando processamento simultâneo...')

_afiliais := FWAllFilial('01')
_cfiliais := supergetmv("ZMFGFILIN2",,'')
_athreads := {}
_nmaxthreads := supergetmv("ZMFGTHREADS",,2)
_nmaxtempo := supergetmv("ZMFGMAXTE2",,1800)

//Monta registros de controle de filas de processamento
For _nj := 1 to _nmaxthreads

	ZCE->(Dbsetorder(1)) //ZCE_FILIAL+ZCE_PROD
	_nrecfil := 999999999999 - _nj
	If ZCE->(Dbseek(alltrim(str(_nrecfil))))
		If !ZCE->(MsRLock(ZCE->(RECNO())))	
			U_MFCONOUT('Já existe integração multifilial em processamento!')
			Return
		Else
 		    ZCE->(MsRunlock())
			Reclock("ZCE",.F.)	
			ZCE->ZCE_QTAURA := 0 //0 FILA LIVRE, 1 FILA OCUPADA
			ZCE->ZCE_QPROTH := 0 //tempo de inicio do processamento
			ZCE->(Msunlock())
		Endif
	Else
		Reclock("ZCE",.T.)
		ZCE->ZCE_FILIAL := '999999'
		ZCE->ZCE_PROD	:= alltrim(str(999999 - _nj))
		ZCE->ZCE_QTAURA := 0 //0 FILA LIVRE, 1 FILA OCUPADA
		ZCE->ZCE_QPROTH := 0 //tempo de inicio do processamento
		ZCE->(Msunlock())
	Endif

Next

ZCE->(Dbsetorder(1)) //ZCE_FILIAL+ZCE_PROD
If ZCE->(Dbseek('999999999999'))
	//Se achou o registro tenta fazer um mrlock para ver se não está em uso
	If !ZCE->(MsRLock(ZCE->(RECNO())))	
		U_MFCONOUT('Já existe integração multifilial em processamento!')
		Return
	Endif
Else
	Reclock("ZCE",.T.)
	ZCE->ZCE_FILIAL := '999999'
	ZCE->ZCE_PROD	:= '999999'
Endif


For _nii := 1 to len(_afiliais)
	

	cfiljob := "01" + _afiliais[_nii]

	iF cfiljob $ _cfiliais .or. empty(_cfiliais)

		//Roda registros procurando uma fila livre
		_nfila := 0
		For _nl := 1 to _nmaxthreads

			ZCE->(Dbsetorder(1)) //ZCE_FILIAL+ZCE_PROD
			_nrecfil := 999999999999 - _nl
			If ZCE->(Dbseek(alltrim(str(_nrecfil))))

				If ZCE->ZCE_QTAURA == 0

					If !ZCE->(MsRLock(ZCE->(RECNO())))	
						U_MFCONOUT('Falha no controle de multithreading!')
						Return
					Else
	 			   		ZCE->(DBRunlock(RECNO()))
					Endif
				
					Reclock("ZCE",.F.)
					ZCE->ZCE_QTAURA := 1 //0 FILA LIVRE, 1 FILA OCUPADA
					ZCE->ZCE_QPROTH := val(FWTimeStamp(4)) //segundos desde 01/01/1970
					ZCE->ZCE_THREAD := 0
					_nfila := _nl
					ZCE->(Msunlock())
					Exit

				Endif

			Else

				U_MFCONOUT('Falha no controle de multithreading!')
				Return

			Endif

		Next

		If _nfila > 0 //Encontrou fila livra dispara job

			U_MFCONOUT('Disparando processamento da filial ' + cfiljob  + " na fila " + strzero(_nfila,4) + "...")
			//Executa o processamento da integração como job
			startjob("U_MGFWSC05",GetEnvServer(),.F.,{,"01",cFilJob},_nfila) 

			//espera até um minuto para job inicilizar
			_nini := val(FWTimeStamp(4))
		
			Do while ZCE->ZCE_THREAD == 0 .and.  val(FWTimeStamp(4)) < _nini + 60
				sleep(1000)
				ZCE->(Dbsetorder(1)) //ZCE_FILIAL+ZCE_PROD
				_nrecfil := 999999999999 - _nl
				If ZCE->(Dbseek(alltrim(str(_nrecfil))))
					U_MFCONOUT('Aguardando inicio processamento da filial ' + cfiljob  + " na fila " + strzero(_nfila,4) + "...")
				Else
					_nini := _nini + 60
				Endif
			Enddo

		Else //Não encontrou fila livre, espera 1 segundo e fiscaliza processos em execução

			sleep(1000)
			_nii-- //Retorna para filial anterior pois não começou processamento
			U_MFCONOUT('Não encontrou fila livre...')

			//Valida tempo de processamento das filas e derruba se estourou limite
			For _nl := 1 to _nmaxthreads

				ZCE->(Dbsetorder(1)) //ZCE_FILIAL+ZCE_PROD
				_nrecfil := 999999999999 - _nl
				If ZCE->(Dbseek(alltrim(str(_nrecfil))))

					If (val(FWTimeStamp(4))-ZCE->ZCE_QPROTH) > _nmaxtempo //Estourou o tempo de processamento
				
						//Derruba thread
						_amonitor := GetUserInfoArray()
						_nproc := Ascan(_amonitor,{|aVal| aVal[3] == ZCE->ZCE_THREAD})

						If _nproc > 0
						
							U_MFCONOUT("Derrubando Thread " +strzero(_amonitor[_nproc][3],6) + " por timeout..." )
		
							KillUser( _amonitor[_nproc][1], _amonitor[_nproc][2], _amonitor[_nproc][3], _amonitor[_nproc][4] )	

						Endif	

						//Aguarda até 1 minuto para Liberar fila de processamento
						_nini := val(fwtimestamp(4))
						_lsai := .F.
						
						Do while !_lsai .and. val(fwtimestamp(4)) < _nini + 60
							If !ZCE->(MsRLock(ZCE->(RECNO())))	
								U_MFCONOUT('Tentando liberar fila ' + strzero(_nl,4) + '!')
								Sleep(1000)
								Loop
							Else
	 			   				ZCE->(DBRunlock(RECNO()))
								_lsai := .T.
							Endif
			
							Reclock("ZCE",.F.)
							ZCE->ZCE_QTAURA := 0 //0 FILA LIVRE, 1 FILA OCUPADA
							ZCE->ZCE_QPROTH := 0 //segundos desde 01/01/1970
							ZCE->(Msunlock())

						Enddo

					Endif

				Else

					U_MFCONOUT('Falha no controle de multithreading!')
					Return

				Endif

			Next

		Endif		
	
	Endif

Next

//Acompanha processamentos pendentes e derruba se estourar limite de tempo

_cprocs := "S"

Do while _cprocs == "S"

	_cprocs := "N"

	//Valida tempo de processamento das filas e derruba se estourou limite
	For _nl := 1 to _nmaxthreads

		ZCE->(Dbsetorder(1)) //ZCE_FILIAL+ZCE_PROD
		_nrecfil := 999999999999 - _nl
		If ZCE->(Dbseek(alltrim(str(_nrecfil))))

			If ZCE->ZCE_QTAURA == 1

					_cprocs := "S"
					U_MFCONOUT('Acompanhando jobs em processamento...')
					Sleep(1000)

					If (val(FWTimeStamp(4))-ZCE->ZCE_QPROTH) > _nmaxtempo //Estourou o tempo de processamento
				
						//Derruba thread
						_amonitor := GetUserInfoArray()
						_nproc := Ascan(_amonitor,{|aVal| aVal[3] == ZCE->ZCE_THREAD})

						If _nproc > 0

							U_MFCONOUT("Derrubando Thread " +strzero(_amonitor[_nproc][3],6) + " por timeout..." )
		
							KillUser( _amonitor[_nproc][1], _amonitor[_nproc][2], _amonitor[_nproc][3], _amonitor[_nproc][4] )	

						Endif	

						//Libera fila de processamento
						If !ZCE->(MsRLock(ZCE->(RECNO())))	
							U_MFCONOUT('Falha no controle de multithreading!')
							Return
						Else
	 			   			ZCE->(MsRunlock())
						Endif
			
						Reclock("ZCE",.F.)
						ZCE->ZCE_QTAURA := 0 //0 FILA LIVRE, 1 FILA OCUPADA
						ZCE->ZCE_QPROTH := 0 //segundos desde 01/01/1970
						ZCE->(Msunlock())

					Endif

			Endif

		Else

			U_MFCONOUT('Falha no controle de multithreading!')
			Return

		Endif

	Next

Enddo

U_MFCONOUT('Completou processamento multifiliais...')

RESET ENVIRONMENT

Return 

//Funções antigas mantidas para retrocompatibilidade com fontes que fazem callstatic:
// MGFFAT16, MGFFAT68, MGFLIBPD, MGFWSC27, MGFWSC33
//------------------------------------------------------
// Retorna saldo do Produto apos consulta com Taura - Pedido deve estar posicionado
// [1] = Saldo (Taura - Protheus)
// [2] = Peso Medio
//------------------------------------------------------
static function getSalProt( cB1Cod, cC5Num, cStockFil, lJobStock, dDtMin, dDtMax, _BlqEst )
	local cQueryProt	:= ""
	local nRetProt		:= 0
	local nRetProt2		:= 0
	local aArea			:= getArea()
	local aAreaSZJ		:= SZJ->(getArea())
	local aAreaSA1		:= SA1->(getArea())
	local aAreaSB1		:= SB1->(getArea())

	local aRet			:= {}
	local aRet2			:= {}
	local nSalProt		:= 0
	local nSalProt2		:= 0
	local nPesoMedio	:= 0
	local aRetStock		:= { 0 , 0 }

	local lRet			:= .F.
	local lFefo			:= .F.

	local nMGFDTMIN		:= 0
	local nMGFDTMAX		:= 0

	local dDataMin		:= CTOD("  /  /  ")
	local dDataMax		:= CTOD("  /  /  ")

	local nDtMin		:= superGetMv("MGF_DTMIN", , 0 )
	local nDtMax		:= superGetMv("MGF_DTMAX", , 0 )

	local nDtMinPr		:= superGetMv( "MGF_MINPR", , 0 )
	local nDtMaxPr		:= superGetMv( "MGF_MAXPR", , 0 )

	default lJobStock	:= .F.
	default cC5Num		:= space(06)
	default cStockFil	:= cFilAnt

	default dDtMin		:= CTOD("  /  /  ")
	default dDtMax		:= CTOD("  /  /  ")
	default _BlqEst		:= .F.

	if !empty( dDtMin )
		dDataMin := dDtMin
	endif

	if !empty( dDtMax )
		dDataMax := dDtMax
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		lFefo := .T.
	endif

	if lJobStock
		if QRYSB2->ZJ_FEFO <> 'S'
			// Para o tipo VE as datas nao importam na consulta ao Taura, mas na conta para debitar Pedidos do Protheus sim
			dDataMin := CTOD("  /  /  ")
			dDataMax := CTOD("  /  /  ")
		elseif QRYSB2->ZJ_FEFO == 'S'
			dDataMin := dDataBase + QRYSB2->ZJ_MINIMO
			dDataMax := dDataBase + QRYSB2->ZJ_MAXIMO
		endif
	endif

	if lJobStock
		if QRYSB2->ZJ_FEFO <> 'S'
			U_MGFTAE21( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax )
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos

			U_MGFTAE21( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( QRYSB2->idproduto, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			U_MGFTAE21( @aRet2, cStockFil, QRYSB2->idproduto, .T., dDataMin, dDataMax )

			nRetProt2 := getSaldoPv( QRYSB2->idproduto, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	else
		DBSelectArea('SZJ')
		SZJ->(DBSetOrder(1))
		SZJ->(DBSeek(xFilial('SZJ') + SC5->C5_ZTIPPED))

		if SZJ->ZJ_FEFO <> 'S'
			if !empty( dDataMin ) .and. !empty( dDataMax )
				U_MGFTAE21( @aRet, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

				nRetProt := 0
				nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
				nSalProt := 0
				nSalProt := ( aRet[01] - nRetProt )

				// CASO TENHA PARAMETRIZADO DATA, DEVERA VERIFICAR COM VE SEM DATA
				aRet2 := {0}
				U_MGFTAE21( @aRet2, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

				nRetProt2 := getSaldoPv( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
				nSalProt2 := ( aRet2[01] - nRetProt2 )

				// SE - 'VE com Data' for maior que 'VE sem Data' - Considera SEM DATA
				//if nSalProt2 > nSalProt
				if nSalProt > nSalProt2
					aRet := {}
					aRet := aClone( aRet2 )

					dDataMin := CTOD("  /  /  ")
					dDataMax := CTOD("  /  /  ")
				endif

			else
				U_MGFTAE21( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )
			endif
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos
			U_MGFTAE21( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			U_MGFTAE21( @aRet2, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

			nRetProt2 := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	endif

	if aRet[2] > 0
		nPesoMedio := ( aRet[1] / aRet[2] )
	endif

	nRetProt := 0
	nSalProt := 0
	Conout("Parametros enviado para a função getSaldoPv: "+cB1Cod +"," + cStockFil + "," + cC5Num )
	nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	nSalProt := ( aRet[01] - nRetProt )
	qTaura   := aRet[01]
	restArea(aAreaSB1)
	restArea(aAreaSA1)
	restArea(aAreaSZJ)
	restArea(aArea)

	aRetStock := { nSalProt, nPesoMedio }
	Conout("[MGFWSC05] - Resuldado da funcao getSalProt: Saldo: "+ Alltrim(Transform(nSalProt,"@E 999,999,999.9999")) + " Peso Medio: "+ Alltrim(Transform(nPesoMedio,"@E 999,999,999.9999")) )
return aRetStock

//------------------------------------------------------------
// Retorna o saldo de Pedidos
//------------------------------------------------------------
static function getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	local nSaldoPV		:= 0
	local cQueryProt	:= ""
	local cQryPv		:= getNextAlias()

	Conout("Parametros recebido na função getSaldoPv: "+cB1Cod +"," + cStockFil + "," + cC5Num )

	// a query abaixo para trazer o saldo que o Protheus tem de pedidos, por produto
	// desconsidera o pedido que está sendo manipulado no momento ou analisado
	// mas considera todos os pedidos que estão com bloqueio seja de estoque o não no sistema
	// gerando erro. Criado um parametro no final para informar se deve ou não descosiderar
	// pedidos com bloqueio de estoque.

	cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
	cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "

	cQueryProt  += " WHERE"
	cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
	cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
	cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
	cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
	cQueryProt  += "  	AND C6_NOTA			=	'         '"
	cQueryProt  += "  	AND C6_BLQ			<>	'R'"

	if !empty( cC5Num )
		cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		cQueryProt  += " AND"
		cQueryProt  += "     ("
		cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "         OR"
		cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "     )"
	endif

	Conout("[MGFWSC05] - Roda Query funcao getSaldoPv: "+ cQueryProt )
	tcQuery cQueryProt New Alias (cQryPv)

	if !(cQryPv)->(EOF())
		nSaldoPV := (cQryPv)->SALDO
	endif

	If Select(cQryPv) > 0
		(cQryPv)->(DBCloseArea())
	EndIf
	Conout("[MGFWSC05] - Resuldado da Query funcao getSaldoPv saldo pvs: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )

	// agora processo o saldo de pedidos que estão com bloqueio de estoque
	// e desconto essa quantidade na quantidade de pedido que a query anterior trouxe pois havia contemplado
	// erroneamente todos os pedidos mesmos os que estão com bloqueio de estoque

	if _BlqEst
		cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
		cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SZV") + " SZV ON SZV.ZV_FILIAL = C5.C5_FILIAL AND SZV.ZV_PEDIDO = C5.C5_NUM AND SZV.D_E_L_E_T_ = ' ' AND SZV.ZV_CODRGA IN ('000011') AND SZV.ZV_ITEMPED = C6.C6_ITEM "
		cQueryProt  += " WHERE"
		cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
		cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
		cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
		cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
		cQueryProt  += "  	AND C6_NOTA			=	'         '"
		cQueryProt  += "  	AND C6_BLQ			<>	'R'"
		cQueryProt  += "  	AND C5.C5_ZBLQRGA = 'B' "
		cQueryProt  += "  	AND SZV.ZV_CODAPR = ' ' "
		if !empty( cC5Num )
			cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
		endif

		if !empty( dDataMin ) .and. !empty( dDataMax )
			cQueryProt  += " AND"
			cQueryProt  += "     ("
			cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "         OR"
			cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "     )"
		endif

		Conout("[MGFWSC05] - Roda Query funcao getSaldoPv: "+ cQueryProt )
		tcQuery cQueryProt New Alias (cQryPv)

		if !(cQryPv)->(EOF())
			nSaldoPV := nSaldoPV - (cQryPv)->SALDO
		endif

		If Select(cQryPv) > 0
			(cQryPv)->(DBCloseArea())
		EndIf
		Conout("[MGFWSC05] - Resuldado da Query funcao getSaldoPv - saldos bloqueados: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )
	ENDIF

return nSaldoPV


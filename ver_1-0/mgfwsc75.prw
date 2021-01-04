#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFWSC75
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Integracao de Estoque com SFA com consulta assincrona
=====================================================================================
*/
user function MGFWSC75( aEmpX, _nfila )

	Default _nfila := 0

	U_MFCONOUT(' Iniciando envio de estoques para o SFA...') 

	U_MFCONOUT('Processamento filial ' + aEmpX[3])

	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA aEmpX[2] FILIAL aEmpX[3]

	U_MFCONOUT(' Iniciada a empresa ' + allTrim( aEmpX[2] ) )

	If _nfila > 0 //Registro de processamento multithread

		ZFP->(Dbsetorder(1)) //ZFP_FILIAL+ZFP_PROD
		_nrecfil := 999999999999 - _nfila

		If ZFP->(Dbseek(alltrim(str(_nrecfil))))

			If !ZFP->(MsRLock(ZFP->(RECNO())))	
				U_MFCONOUT('Falha no controle de multithreading!')
				Return
			Else
			  ZFP->(MsRunlock())
			Endif

			Reclock("ZFP",.F.)
			ZFP->ZFP_QTAURA := 1 //0 FILA LIVRE, 1 FILA OCUPADA
			ZFP->ZFP_Thread := ThreadId() //THREAD EM PROCESSAMENTO
	
		Endif

	Endif

	MFWSC75F( aEmpx ) //Executa processamento da integração

	U_MFCONOUT(' Completou exportação da filial ' + allTrim( aEmpX[3] ) )

	If _nfila > 0 //Registro de fim de processamento multithread

		ZFP->(Dbsetorder(1)) //ZFP_FILIAL+ZFP_PROD
		_nrecfil := 999999999999 - _nfila
		If ZFP->(Dbseek(alltrim(str(_nrecfil))))

			If !ZFP->(MsRLock(ZFP->(RECNO())))	
				U_MFCONOUT('Falha no controle de multithreading!')
				Return
			Else
			  ZFP->(MsRunlock())
			Endif

			Reclock("ZFP",.F.)
			ZFP->ZFP_QTAURA := 0 //0 FILA LIVRE, 1 FILA OCUPADA
			ZFP->(Msunlock())

		Endif

	Endif

	RESET ENVIRONMENT


return

/*
=====================================================================================
Programa.:              jMGFWC75
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Chamada de  job para Integracao de Estoque com SFA
=====================================================================================
*/
user function jMGFWC75(cFilJob)

	U_MGFWSC75({,"01",cFilJob}) //Executa o processamento da integração como job

Return 

/*
=====================================================================================
Programa.:              MFWSC75F
Autor....:              Josué Danich Prestes
Data.....:              01/08/2019
Descricao / Objetivo:   Chama integrações por filial para o SFA
=====================================================================================
*/
static function MFWSC75F(aEmpx,oproc)

Default oproc := nil

If valtype(oproc) == "O" //Se tem tela
	oproc:cCaption := ("Exportando dados da filial " + aEmpx[3] + "...")
	processmessages()
Endif

U_MFCONOUT("Iniciando exportação para filial " + aEmpx[3] + "...")

_cfilori := cFilAnt
cfilant := aEmpx[3]
	
U_MGFWS75R(oproc) //Executa integração
	
cfilant := _cfilori

U_MFCONOUT("Completada exportação para filial " + aEmpx[3] + "...")

U_MFCONOUT('Completado processo de exportação SFA')

Return


/*
=====================================================================================
Programa.:              MGFWS75R
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Executa Integracao de Estoque com SFA
=====================================================================================
*/
User function MGFWS75R(oproc)

	local cURLPost		:= ""
	Local lLog			:= .F.
	local oWSSFA		:= nil
	Local _nrecnot      := 0
	Local _ntot         := 0
	Local _npos         := 1
	local bError 		:= ErrorBlock( { |oError| MFWSC75E( oError ) } )

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

	MFWSC75G(0) //Seleciona produtos em estoque

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
		oStock := STOCKS75():new()

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

				Reclock("ZFP",.T.)
				ZFP->ZFP_FILIAL := cFilAnt
				ZFP->ZFP_THREAD := ThreadId()
				ZFP->ZFP_PROD	:= oStock:PRODUTO:IDPRODUTO
				ZFP->ZFP_QTAURA	:= qTaura //quantidade retornada pelo Taura
				ZFP->ZFP_QPROTH	:= oStock:QTDESTOQUE
				ZFP->ZFP_DATAI	:= _ddtini 
				ZFP->ZFP_HORAI	:= _chrini
				ZFP->ZFP_DATAF	:= dATE() 
				ZFP->ZFP_HORAF	:= TIME()
				ZFP->ZFP_TMPTOT := _ntemptot
				ZFP->ZFP_TMPTAU := _ntauratmp
				ZFP->ZFP_TMPSFA := _nsfatmp
				ZFP->ZFP_UUID   := oStock:UUID
				ZFP->ZFP_UUID2   := oStock:UUID2
				ZFP->ZFP_LOGSFA	:= oWSSFA:CDETAILINT //Log do envio para o SFA	
				ZFP->ZFP_LOGTAU := oStock:PAYLOAD //String retornado pelo Taura	
				ZFP->ZFP_LOGTA2 := oStock:PAYLOAD2 //String retornado pelo Taura
				ZFP->ZFP_ENVSFA	:= oWSSFA:cJson //String enviado para o SFA	
				ZFP->ZFP_ENVTAU := oStock:ENV //String enviado para o Taura	
				ZFP->ZFP_ENVTA2 := oStock:ENV2 //String enviado para o Taura	
				ZFP->ZFP_TAUROK := "S" 
				ZFP->ZFP_SFAOK  := iif(oWSSFA:lok,"S","N")
				ZFP->ZFP_TUDOOK := iif(oWSSFA:lok,"S","N")	
				ZFP->ZFP_TIPOP  := QRYSB2->idtipopedi
				ZFP->(MsUnlock())

		Else

				Reclock("ZFP",.T.)
				ZFP->ZFP_FILIAL := cFilAnt
				ZFP->ZFP_THREAD := ThreadId()
				ZFP->ZFP_PROD	:= oStock:PRODUTO:IDPRODUTO
				ZFP->ZFP_QTAURA	:= qTaura //quantidade retornada pelo Taura
				ZFP->ZFP_QPROTH	:= oStock:QTDESTOQUE
				ZFP->ZFP_DATAI	:= _ddtini 
				ZFP->ZFP_HORAI	:= _chrini
				ZFP->ZFP_DATAF	:= dATE() 
				ZFP->ZFP_HORAF	:= TIME()
				ZFP->ZFP_TMPTOT := _ntemptot
				ZFP->ZFP_TMPTAU := _ntauratmp
				ZFP->ZFP_TMPSFA := _nsfatmp
				ZFP->ZFP_UUID   := oStock:UUID
				ZFP->ZFP_UUID2  := oStock:UUID2
				ZFP->ZFP_LOGSFA	:= oWSSFA:CDETAILINT //Log do envio para o SFA	
				ZFP->ZFP_LOGTAU := oStock:PAYLOAD //String retornado pelo Taura	
				ZFP->ZFP_LOGTA2 := oStock:PAYLOAD2 //String retornado pelo Taura
				ZFP->ZFP_ENVSFA	:= oWSSFA:cJson //String enviado para o SFA	
				ZFP->ZFP_ENVTAU := oStock:ENV //String enviado para o  Taura	
				ZFP->ZFP_ENVTA2 := oStock:ENV2 //String enviado para o Taura	
				ZFP->ZFP_TAUROK := "N" 
				ZFP->ZFP_SFAOK  := iif(oWSSFA:lok,"S","N")
				ZFP->ZFP_TUDOOK := "N"
				ZFP->ZFP_TIPOP  := QRYSB2->idtipopedi
				ZFP->(MsUnlock())

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
Programa.:              MFWSC75E
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Tratamento de erros
=====================================================================================
*/
static function MFWSC75E(oError)
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
Programa.:              PRODUTOS75
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Classe de definição de dados do produto
=====================================================================================
*/
class PRODUTOS75
data centrodistribuicao		as string
data idestruturatipopedido	as string
data idproduto				as string

method New()
EndClass

method new() class PRODUTOS75
return

/*
=====================================================================================
Programa.:              STOCKS75
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Classe de tratamento de estoque para o SFA
=====================================================================================
*/
class STOCKS75
data applicationArea	as ApplicationArea
data produto			as PRODUTOS75
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
method new() class STOCKS75
	self:applicationArea	:= ApplicationArea():new()
	self:produto			:= PRODUTOS75():new()
return

/*
Carrega o objeto
*/
Method setStock() Class STOCKS75
	local nPorcSFA	:= superGetMv( "MGF_SFA05B" , , 90 )

	::produto:idproduto 			:= allTrim( QRYSB2->idproduto )
	::produto:centrodistribuicao	:= allTrim( cFilAnt )
	::produto:idestruturatipopedido	:= QRYSB2->idtipopedi

	aRetStock := {}
	aRetStock := MFWSC75T( QRYSB2->idproduto, "", cFilAnt, .T. )

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
Programa.:              MFWSC75G
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Seleciona produtos em estoque
=====================================================================================
*/
static function MFWSC75G(_ntipo)  

local cQrySB2		:= ""
local cFilSFA		:= allTrim( getMv( "MGF_SFASZJ" ) ) // 'VE','FF','PR'
Default _ntipo      := 0 //0 só manda do SFA, 1 manda SFA e E-Commerce

  
If _ntipo == 0
	
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
    
	TcQuery cQrySB2 New Alias "QRYSB2"

Elseif _ntipo == 1

	cQrySB2 := "select distinct idproduto, idtipopedi, "									+ CRLF	
	cQrySB2 += "  ZJ_FEFO, ZJ_MINIMO, ZJ_MAXIMO FROM "										+ CRLF					
	cQrySB2 += " (select distinct x.idproduto idproduto, x.idtipopedido idtipopedi,	"		+ CRLF
	cQrySB2 += " SZJ.ZJ_FEFO, SZJ.ZJ_MINIMO, SZJ.ZJ_MAXIMO"									+ CRLF
	cQrySB2 += " from v_listapreco x"												+ CRLF
	cQrySB2 += " INNER JOIN " + retSQLName("SZJ") + " SZJ"							+ CRLF
	cQrySB2 += " ON"																+ CRLF
	cQrySB2 += " 		SZJ.ZJ_COD		= X.idtipopedido"							+ CRLF
	cQrySB2 += " 	AND	SZJ.D_E_L_E_T_	= ' '"										+ CRLF
	cQrySB2 += " where"																+ CRLF
	cQrySB2 += "		x.idtipopedido			in	(" + cFilSFA + ")"				+ CRLF
	cQrySB2 += " 	AND	x.CENTRODISTRIBUICAO	=	'" + cFilAnt + "'"				+ CRLF
	 						
	cQrySB2 += " UNION ALL "										+ CRLF

	cQrySB2 += " SELECT DISTINCT DA1_CODPRO IDPRODUTO, 'EC' idtipopedi, 'N' ZJ_FEFO, 0 ZJ_MINIMO, 0 ZJ_MAXIMO "		+ CRLF					
	cQrySB2 += "  FROM 			" + retSQLName("DA0") + "   DA0	"		+ CRLF				
	cQrySB2 += "  INNER JOIN 	" + retSQLName("DA1") + "   DA1	"		+ CRLF				
	cQrySB2 += "  ON "		+ CRLF															
	cQrySB2 += "  		DA1.DA1_CODTAB	=	DA0.DA0_CODTAB	"		+ CRLF 					
	cQrySB2 += "  	AND	DA1.DA1_CODPRO	<=	'500000' "		+ CRLF							
	cQrySB2 += "  	AND	DA1.DA1_FILIAL	=	'" + xfilial("DA1") + "' "		+ CRLF					
	cQrySB2 += "  	AND	DA1.D_E_L_E_T_	<>	'*'	 "		+ CRLF							
	cQrySB2 += "  INNER JOIN 	" + retSQLName("SB1") + "   SB1 "		+ CRLF					
	cQrySB2 += "  ON "		+ CRLF															
	cQrySB2 += "  		DA1.DA1_CODPRO	=	SB1.B1_COD	"		+ CRLF						
	cQrySB2 += "  	AND	SB1.B1_ZPESMED	>	0 "		+ CRLF									
	cQrySB2 += "  	AND	SB1.B1_COD		<=	'500000' "		+ CRLF							
	cQrySB2 += "  	AND	SB1.B1_FILIAL	=	'" + xfilial("SB1") + "' "		+ CRLF	
	cQrySB2 += "  	AND	DA1.D_E_L_E_T_	<>	'*'	"		+ CRLF							
	cQrySB2 += "  WHERE															
	cQrySB2 += "  		DA0.DA0_XENVEC	=	'1' "		+ CRLF								 
	cQrySB2 += "  	AND	DA0.DA0_ATIVO	=	'1' "		+ CRLF								 
	cQrySB2 += "  	AND	DA1.DA1_PRCVEN	>	1  "		+ CRLF  								
	cQrySB2 += "  	AND	DA0.DA0_FILIAL	=	'" + xfilial("DA0") + "' "		+ CRLF			
	cQrySB2 += "  	AND	DA0.D_E_L_E_T_	<>	'*'		) "		+ CRLF
	 	
	cQrySB2 += "  order by idproduto, idtipopedi desc "		+ CRLF	

	TcQuery cQrySB2 New Alias "QRYSB2"

Endif



return


/*
=====================================================================================
Programa.:              MFWSC75T.
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Retorna saldo do Produto apos consulta com Taura 
OBS.................:   Pedido deve estar posicionado
Retorno.............:   Array: [1] = Saldo (Taura - Protheus) [2] = Peso Medio
							[3] = Sucesso [4] = Payload resp [5] = UUID
							[6] = Payload resp 2 [7] = UUID resp 2
=====================================================================================
*/
static function MFWSC75T( cB1Cod, cC5Num, cStockFil, lJobStock, dDtMin, dDtMax, _BlqEst )
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
			If !(MFWSC75D( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax ))
				lret := .F.
			    Break
			Endif
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos

			if !(MFWSC75D( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax ))
				lret := .F.
			    Break
			Endif


			nRetProt := MFWSC75P( QRYSB2->idproduto, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			If !(MFWSC75D( @aRet2, cStockFil, QRYSB2->idproduto, .T., dDataMin, dDataMax ))
				lret := .F.
			    Break
			Endif

			nRetProt2 := MFWSC75P( QRYSB2->idproduto, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
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
				If !(MFWSC75D( @aRet, cStockFil, cB1Cod, .T., dDataMin, dDataMax ))
					lret := .F.
				    Break
				Endif

				nRetProt := 0
				nRetProt := MFWSC75P( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
				nSalProt := 0
				nSalProt := ( aRet[01] - nRetProt )

				// CASO TENHA PARAMETRIZADO DATA, DEVERA VERIFICAR COM VE SEM DATA
				aRet2 := {0}
				If !(MFWSC75D( @aRet2, cStockFil, cB1Cod, .F., dDataMin, dDataMax ))
					lret := .F.
				    Break
				Endif

				nRetProt2 := MFWSC75P( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
				nSalProt2 := ( aRet2[01] - nRetProt2 )

				// SE - 'VE com Data' for maior que 'VE sem Data' - Considera SEM DATA
				if nSalProt > nSalProt2
					aRet := {}
					aRet := aClone( aRet2 )

					dDataMin := CTOD("  /  /  ")
					dDataMax := CTOD("  /  /  ")
				endif

			else
				If !(MFWSC75D( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax ))
					lret := .F.
				    Break
				Endif
			endif
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos
			If !(MFWSC75D( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax ))
				lret := .F.
			    Break
			Endif

			nRetProt := MFWSC75P( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			If !(MFWSC75D( @aRet2, cStockFil, cB1Cod, .T., dDataMin, dDataMax ))
				lret := .F.
			    Break
			Endif

			nRetProt2 := MFWSC75P( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
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
	U_MFCONOUT("Parametros enviado para a função MFWSC75P: "+cB1Cod +"," + cStockFil + "," + cC5Num )
	nRetProt := MFWSC75P( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
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

	If nsalprot < 0
		nsalprot := 0
	Endif

	aRetStock := { nSalProt, nPesoMedio, lret, _cpayload,_cuuid, _cpayload2,_cuuid2,_cenv,_cenv2 }
	U_MFCONOUT("[MFWSC75] - Resultado da funcao MFWSC75T: Saldo: "+ Alltrim(Transform(nSalProt,"@E 999,999,999.9999")) + " Peso Medio: "+ Alltrim(Transform(nPesoMedio,"@E 999,999,999.9999")) )

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
Programa.:              MFWSC75P
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Retorna o saldo de Pedidos
=====================================================================================
*/
static function MFWSC75P( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )

	local nSaldoPV		:= 0
	local cQueryProt	:= ""
	local cQryPv		:= getNextAlias()

	U_MFCONOUT("Parametros recebido na função MFWSC75P: "+cB1Cod +"," + cStockFil + "," + cC5Num )

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
	U_MFCONOUT("[MFWSC75] - Resultado da Query funcao MFWSC75P saldo pvs: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )

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

		Conout("[MFWSC75] - Roda Query funcao MFWSC75P: "+ cQueryProt )
		tcQuery cQueryProt New Alias (cQryPv)

		if !(cQryPv)->(EOF())
			nSaldoPV := nSaldoPV - (cQryPv)->SALDO
		endif

		If Select(cQryPv) > 0
			(cQryPv)->(DBCloseArea())
		EndIf
		U_MFCONOUT("[MFWSC75] - Resultado da Query funcao MFWSC75P - saldos bloqueados: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )
	ENDIF

return nSaldoPV

/*
=====================================================================================
Programa.:              mMGFWC75
Autor....:              Josué Danich Prestes
Data.....:              27/09/2016
Descricao / Objetivo:   Chamada de Integracao de Estoque com SFA, multithreads
=====================================================================================
*/
user function mMGFWC75()

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
_cfiliais := supergetmv("ZMFGFILIN3",,'010007|010015|010016|010041|010044|010050|010054|010056|010059|010066')
_athreads := {}
_nmaxthreads := supergetmv("ZMFGTHR3",,10)
_nmaxtempo := supergetmv("ZMFGMAXTE2",,1800)

//Monta registros de controle de filas de processamento
For _nj := 1 to _nmaxthreads

	ZFP->(Dbsetorder(1)) //ZFP_FILIAL+ZFP_PROD
	_nrecfil := 999999999999 - _nj
	If ZFP->(Dbseek(alltrim(str(_nrecfil))))
		If !ZFP->(MsRLock(ZFP->(RECNO())))	
			U_MFCONOUT('Já existe integração multifilial em processamento!')
			Return
		Else
 		    ZFP->(MsRunlock())
			Reclock("ZFP",.F.)	
			ZFP->ZFP_QTAURA := 0 //0 FILA LIVRE, 1 FILA OCUPADA
			ZFP->ZFP_QPROTH := 0 //tempo de inicio do processamento
			ZFP->(Msunlock())
		Endif
	Else
		Reclock("ZFP",.T.)
		ZFP->ZFP_FILIAL := '999999'
		ZFP->ZFP_PROD	:= alltrim(str(999999 - _nj))
		ZFP->ZFP_QTAURA := 0 //0 FILA LIVRE, 1 FILA OCUPADA
		ZFP->ZFP_QPROTH := 0 //tempo de inicio do processamento
		ZFP->(Msunlock())
	Endif

Next

ZFP->(Dbsetorder(1)) //ZFP_FILIAL+ZFP_PROD
If ZFP->(Dbseek('999999999999'))
	//Se achou o registro tenta fazer um mrlock para ver se não está em uso
	If !ZFP->(MsRLock(ZFP->(RECNO())))	
		U_MFCONOUT('Já existe integração multifilial em processamento!')
		Return
	Endif
Else
	Reclock("ZFP",.T.)
	ZFP->ZFP_FILIAL := '999999'
	ZFP->ZFP_PROD	:= '999999'
Endif


For _nii := 1 to len(_afiliais)
	

	cfiljob := "01" + _afiliais[_nii]

	iF cfiljob $ _cfiliais .or. empty(_cfiliais)

		//Roda registros procurando uma fila livre
		_nfila := 0
		For _nl := 1 to _nmaxthreads

			ZFP->(Dbsetorder(1)) //ZFP_FILIAL+ZFP_PROD
			_nrecfil := 999999999999 - _nl
			If ZFP->(Dbseek(alltrim(str(_nrecfil))))

				If ZFP->ZFP_QTAURA == 0

					If !ZFP->(MsRLock(ZFP->(RECNO())))	
						U_MFCONOUT('Falha no controle de multithreading!')
						Return
					Else
	 			   		ZFP->(DBRunlock(RECNO()))
					Endif
				
					Reclock("ZFP",.F.)
					ZFP->ZFP_QTAURA := 1 //0 FILA LIVRE, 1 FILA OCUPADA
					ZFP->ZFP_QPROTH := val(FWTimeStamp(4)) //segundos desde 01/01/1970
					ZFP->ZFP_THREAD := 0
					_nfila := _nl
					ZFP->(Msunlock())
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
			startjob("U_MGFWSC75",GetEnvServer(),.F.,{,"01",cFilJob},_nfila) 

			//espera até um minuto para job inicilizar
			_nini := val(FWTimeStamp(4))
		
			Do while ZFP->ZFP_THREAD == 0 .and.  val(FWTimeStamp(4)) < _nini + 60
				sleep(1000)
				ZFP->(Dbsetorder(1)) //ZFP_FILIAL+ZFP_PROD
				_nrecfil := 999999999999 - _nl
				If ZFP->(Dbseek(alltrim(str(_nrecfil))))
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

				ZFP->(Dbsetorder(1)) //ZFP_FILIAL+ZFP_PROD
				_nrecfil := 999999999999 - _nl
				If ZFP->(Dbseek(alltrim(str(_nrecfil))))

					If (val(FWTimeStamp(4))-ZFP->ZFP_QPROTH) > _nmaxtempo //Estourou o tempo de processamento
				
						//Derruba thread
						_amonitor := GetUserInfoArray()
						_nproc := Ascan(_amonitor,{|aVal| aVal[3] == ZFP->ZFP_THREAD})

						If _nproc > 0
						
							U_MFCONOUT("Derrubando Thread " +strzero(_amonitor[_nproc][3],6) + " por timeout..." )
		
							KillUser( _amonitor[_nproc][1], _amonitor[_nproc][2], _amonitor[_nproc][3], _amonitor[_nproc][4] )	

						Endif	

						//Aguarda até 1 minuto para Liberar fila de processamento
						_nini := val(fwtimestamp(4))
						_lsai := .F.
						
						Do while !_lsai .and. val(fwtimestamp(4)) < _nini + 60
							If !ZFP->(MsRLock(ZFP->(RECNO())))	
								U_MFCONOUT('Tentando liberar fila ' + strzero(_nl,4) + '!')
								Sleep(1000)
								Loop
							Else
	 			   				ZFP->(DBRunlock(RECNO()))
								_lsai := .T.
							Endif
			
							Reclock("ZFP",.F.)
							ZFP->ZFP_QTAURA := 0 //0 FILA LIVRE, 1 FILA OCUPADA
							ZFP->ZFP_QPROTH := 0 //segundos desde 01/01/1970
							ZFP->(Msunlock())

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

		ZFP->(Dbsetorder(1)) //ZFP_FILIAL+ZFP_PROD
		_nrecfil := 999999999999 - _nl
		If ZFP->(Dbseek(alltrim(str(_nrecfil))))

			If ZFP->ZFP_QTAURA == 1

					_cprocs := "S"
					U_MFCONOUT('Acompanhando jobs em processamento...')
					Sleep(1000)

					If (val(FWTimeStamp(4))-ZFP->ZFP_QPROTH) > _nmaxtempo //Estourou o tempo de processamento
				
						//Derruba thread
						_amonitor := GetUserInfoArray()
						_nproc := Ascan(_amonitor,{|aVal| aVal[3] == ZFP->ZFP_THREAD})

						If _nproc > 0

							U_MFCONOUT("Derrubando Thread " +strzero(_amonitor[_nproc][3],6) + " por timeout..." )
		
							KillUser( _amonitor[_nproc][1], _amonitor[_nproc][2], _amonitor[_nproc][3], _amonitor[_nproc][4] )	

						Endif	

						//Libera fila de processamento
						If !ZFP->(MsRLock(ZFP->(RECNO())))	
							U_MFCONOUT('Falha no controle de multithreading!')
							Return
						Else
	 			   			ZFP->(MsRunlock())
						Endif
			
						Reclock("ZFP",.F.)
						ZFP->ZFP_QTAURA := 0 //0 FILA LIVRE, 1 FILA OCUPADA
						ZFP->ZFP_QPROTH := 0 //segundos desde 01/01/1970
						ZFP->(Msunlock())

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

/*
=====================================================================================
Programa.:              MFWSC75D
Autor....:              Josué Danich Prestes
Data.....:              18/11/2019
Descricao / Objetivo:   Consulta de resposta de estoque assincrono na tabela ZFP
=====================================================================================
*/
Static Function MFWSC75D(xRet,xFilProd,xProd,xFEFO,xDTInicial,xDTFinal)
              //MFWSC75D( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

Local _aRet  := {0,0,0,0,0,"","",""}
Local _lret := .T.

If xFEFO
	_ctipo := "F"
Else
	_ctipo := "N"
Endif

//Verifica se tem resposta válida nos últimos 60 minutos
cQryZFQ := " select R_E_C_N_O_ AS REC FROM " + retsqlname("ZFQ") + " where d_e_l_e_t_ <> '*' and "
cQryZFQ += " ZFQ_PROD = '" + alltrim(xProd) + "' AND ZFQ_FILIAL = '" + xFilProd + "' and "
cQryZFQ += " ZFQ_STATUS = 'C' AND ZFQ_TIPOCO = '" + _ctipo + "' and " 
cQryZFQ += " ZFQ_DTRESP = '" + dtos(date()) + "' AND ZFQ_SECMID >= " + alltrim(str(seconds() - 7200)) 

If xFEFO

    cQryZFQ += " AND ZFQ_DTVALI = '" + dtos(xDTInicial) + "' AND ZFQ_DTVALF = '" + dtos(xDTFinal) + "'"

Endif

cQryZFQ += " ORDER BY  ZFQ_DTRESP,ZFQ_HRRESP DESC"

TcQuery cQryZFQ New Alias "QRYZFQ"


If !(QRYZFQ->(EOF()))

    //Retorna resposta válida
	ZFQ->(Dbgoto(QRYZFQ->REC))
	_aRet  := {ZFQ->ZFQ_ESTOQU,ZFQ->ZFQ_CAIXAS,ZFQ->ZFQ_PECAS ,0,ZFQ->ZFQ_PESO,ZFQ->ZFQ_SOLENV,ZFQ->ZFQ_UUID,ZFQ->ZFQ_RESREC}

Else

    //Retorna erro de consulta
	_aRet  := {0,0,0,0,0,"","",""}
	_lret := .F.

Endif

Dbselectarea("QRYZFQ")
Dbclosearea()

xret := _aret

Return _lret


/*
=====================================================================================
Programa.:              MGFWS75V
Autor....:              Josué Danich Prestes
Data.....:              18/11/2019
Descricao / Objetivo:   Envio de consulta de estoque assincrona na tabela ZFP
=====================================================================================
*/
User Function MGFWS75V()

Local oObjRet := nil

//Prepara o ambiente
U_MFCONOUT(' Iniciando envio de consulta de estoque assincrona para o Taura...') 

RPCSetType( 3 )

PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'

U_MFCONOUT(' Iniciado ambiente...' )


//Carrega filiais a verificar
_afiliais := FWAllFilial('01')
_cfiliais := supergetmv("ZMFGFILIN3",,'010007|010015|010016|010041|010044|010050|010054|010056|010059|010066')

    For _nj := 1 to len(_afiliais)

        If _afiliais[_nj] $ _cfiliais

            _cfilori := cfilant
            cfilant := "01" + _afiliais[_nj]

            U_MFCONOUT(' Iniciando filial ' + cfilant + '...' )
            //Carrega produtos a consultar
            MFWSC75G(1) //Seleciona produtos em estoque do sfa e ecommerce

            _ntot := 0
            _nni := 0
	        //Conta produtos
	        while !QRYSB2->(EOF())
		        _ntot++
		        QRYSB2->(Dbskip())
	        End
	        QRYSB2->(Dbgotop())

	        while !QRYSB2->(EOF())

				U_MFCONOUT(' Processando produto ' + cfilant + "/" + alltrim(QRYSB2->idproduto) + " - " + strzero(_nni,6) + ' de ' + strzero(_ntot,6) + '...' )
				_nni++

        	    if QRYSB2->ZJ_FEFO <> 'S'
		    	    // Para o tipo VE as datas nao importam na consulta ao Taura, mas na conta para debitar Pedidos do Protheus sim
			        dDataMin := CTOD("  /  /  ")
			        dDataMax := CTOD("  /  /  ")
		        elseif QRYSB2->ZJ_FEFO == 'S'
			        dDataMin := dDataBase + QRYSB2->ZJ_MINIMO
			        dDataMax := dDataBase + QRYSB2->ZJ_MAXIMO
		        endif

                //Verifica se tem resposta válida nos últimos 10 minutos
                cQryZFQ := " select R_E_C_N_O_ AS REC FROM " + retsqlname("ZFQ") + " where d_e_l_e_t_ <> '*' and "
	            cQryZFQ += " ZFQ_PROD   = '" + alltrim(QRYSB2->idproduto) + "' AND ZFQ_FILIAL = '" + cfilant + "' and "
                cQryZFQ += " ZFQ_STATUS = 'C' AND ZFQ_TIPOCO = '" + QRYSB2->ZJ_FEFO + "' and " 
                cQryZFQ += " ZFQ_DTRESP = '" + dtos(date()) + "' AND ZFQ_SECMID >= " + alltrim(str(seconds() - 600)) 

                If QRYSB2->ZJ_FEFO == 'S'

                    cQryZFQ += " AND ZFQ_DTVALI = '" + dtos(dDataMin) + "' AND ZFQ_DTVALF = '" + dtos(dDataMax) + "'"

                Endif

	            TcQuery cQryZFQ New Alias "QRYZFQ"


                If QRYZFQ->(EOF())

                    //Envia consulta

					oSaldo := nil
        		    IF QRYSB2->ZJ_FEFO == 'S'
			            cURLPost :=GetMV('MGF_TAE76',.F.,"http://spdwvapl203:1337/taura-estoque-async/consulta-por-fefo")
						oSaldo := WS75_ESTOQUEFEFO():new()
		            Else 
			            cURLPost :=GetMV('MGF_TAE75',.F.,"http://spdwvapl203:1337/taura-estoque-async/consulta")
						oSaldo := WS75_ESTOQUE():new()
		            EndIF
		
		            oSaldo:setDados()
		            oWSWSC75 := nil
		            oWSWSC75 := MGFINT23():new(cURLPost, oSaldo,0, "", "", "", "","","", .T. )

        		    // tratamento para funcao padrao do frame, httpPost(), nao apresentar mensagem de "DATA COMMAND ERRO" quando executada em tela,	
        		    // forca funcao padrao IsBlind() a retornar .T.
        		    cSavcInternet	:= Nil
        		    cSavcInternet	:= __cInternet	
        		    __cInternet		:= "AUTOMATICO"
        		    oWSWSC75:SendByHttpPost()
        		    __cInternet := cSavcInternet

        		    IF oWSWSC75:lOk

                        //Grava envio
    		            IF fwJsonDeserialize(oWSWSC75:cPostRet, @oObjRet)
						
                            Reclock("ZFQ",.T.)
                            ZFQ_FILIAL := cfilant
                            ZFQ_PROD   := alltrim(QRYSB2->idproduto)
                            ZFQ_DATAE  := date()
                            ZFQ_HORAE  := time()
                            ZFQ_UUID   := oObjRet:UUID
                            ZFQ_STATUS := "A"
                            ZFQ_SOLENV := fwJsonSerialize(oWSWSC75:oObjToJson, .T., .T.)
                            ZFQ_SOLRES := oWSWSC75:cPostRet
							
                            If QRYSB2->ZJ_FEFO == 'S'

                                ZFQ_DTVALI := dDataMin
                                ZFQ_DTVALF := dDataMax
                                ZFQ_TIPOCO := "F"

                            Else

                                ZFQ_TIPOCO := "N"

                            Endif

                            ZFQ->(Msunlock())
	
                        Endif

                    Else

                        //Grava falha de envio
                        Reclock("ZFQ",.T.)
                        ZFQ_FILIAL := cfilant
                        ZFQ_PROD   := alltrim(QRYSB2->idproduto)
                        ZFQ_DATAE  := date()
                        ZFQ_HORAE  := time()
                        ZFQ_STATUS := "E"
                        ZFQ_SOLENV := fwJsonSerialize(oWSWSC75:oObjToJson, .T., .T.)
                    
                        If QRYSB2->ZJ_FEFO == 'S'

                            ZFQ_DTVALI := dDataMin
                            ZFQ_DTVALF := dDataMax
                            ZFQ_TIPOCO := "F"

                        Else

                            ZFQ_TIPOCO := "N"

                        Endif

                        ZFQ->(Msunlock())
	                
                    Endif

                Endif

                Dbselectarea("QRYZFQ")
                Dbclosearea()

				 QRYSB2->(Dbskip())

            Enddo

			Dbselectarea("QRYSB2")
			Dbclosearea()

			U_MFCONOUT(' Completou filial ' + _afiliais[_nj] + '...' )

        Endif

    Next

Return


******************************************************************************************************************
CLASS WS75_ESTOQUE
Data applicationArea   as ApplicationArea
Data Produto	       as String
Data Filial		       as String

Method New()
Method setDados()

EndClass
******************************************************************************************************************
Method new() Class WS75_ESTOQUE
self:applicationArea	:= ApplicationArea():new()
Return
******************************************************************************************************************
Method setDados() Class WS75_ESTOQUE

Self:Produto  := alltrim(QRYSB2->idproduto)
Self:Filial   := cfilant

Return
******************************************************************************************************************
CLASS WS75_ESTOQUEFEFO
Data applicationArea	  as ApplicationArea
Data Produto	          as String
Data Filial		          as String
Data DataValidadeInicial  as String
Data DataValidadeFinal    as String

Method New()
Method setDados()
endclass
Return
******************************************************************************************************************
Method new() Class WS75_ESTOQUEFEFO
self:applicationArea	:= ApplicationArea():new()
Return
******************************************************************************************************************
Method setDados() Class WS75_ESTOQUEFEFO

Self:Produto             := alltrim(QRYSB2->idproduto)
Self:Filial              := cfilant
Self:DataValidadeInicial := SUBSTR(DTOS(dDataMin),1,4)+'-'+SUBSTR(DTOS(dDataMin),5,2)+'-'+SUBSTR(DTOS(dDataMin),7,2)
Self:DataValidadeFinal   := SUBSTR(DTOS(dDataMax),1,4)+'-'+SUBSTR(DTOS(dDataMax),5,2)+'-'+SUBSTR(DTOS(dDataMax),7,2)

Return

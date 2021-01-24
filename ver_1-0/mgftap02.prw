#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTAP02 
Processamento de integrações assincronas de produção
@author  Atilio Amarilla
@since 08/11/2016
*/
User Function MGFTAP02( _cfils,_cstatus )

Local _nnj := 1
Local _afils := nil

Default _cfils := "010041"
Default _cstatus := " "

_afils := STRTOKARR( _cfils, ',' )

SetFunName("MGFTAP02")

For _nnj := 1 to len(_afils)

	cempant := substr(_afils[_nnj],1,2)
	CFILANT := _afils[_nnj]
	MGFTAP02E( _afils[_nnj],_cstatus )

Next

Return

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTAP02 
Processamento de integrações assincronas de produção
@author  Atilio Amarilla
@since 08/11/2016
*/
Static Function MGFTAP02E( _cfilial,_cstatus )

Local aTables	:= { "SB1" , "SB2" , "SM0" , "SC2" , "ZZE" }
Local cQryInc, cQryExc, cNumDoc, cNumOrd, nPos, aRotAuto
Local nRegSC2	:= 0
Local nMaxThr	:= 0
Local nRegOrd	:= 0
Local nRegPrd	:= 0
Local nI		:= 0
Local cAux		:= ""
Local lProcJob	:= .F.
Local cCodPA	:= ""
Local cOPTaura  := ''
Local cCodOrig  := ""
Local cCodDest  := ""
Local cTipInd, cEndPad
Local cArqLog	:= ""
Local cMsgErr	:= ""
Local lRet		:= .T.
Local nQtdThread:= 0
Local cFunTAP	:= ""
Local _lretproc := .T.


U_MFCONOUT('Iniciando processamento de movimentos produtivos (TAP02) para filial ' + _cfilial + '...') 

Private	aParEnv
Private nRegPrc		:= 0
Private cIdProc		:= ""
Private cIdSeq	:= ""
Private cTMPrd		:= GetMv("MGF_TAP02B",,"111")
Private cTMDev		:= GetMv("MGF_TAP02C",,"112")
Private cTMDev2		:= GetMv("MGF_TAP02U",,"001")
Private cTMReq		:= GetMv("MGF_TAP02D",,"555")

Private cMovPrd		:= GetMv("MGF_TAP02E",,"01/")	// Apontamento de Produção
Private cMovReq		:= GetMv("MGF_TAP02F",,"02/")	// Requisição
Private ctpopign	:= GetMv("MGF_TAP02Y",,"14/09/06")   //Tipo de OP QUE TERÁ MOVIMENTO DE  geração  a ser ignorado
Private ctpopig2	:= GetMv("MGF_TAP02Z",,"07/05/13")   //Tipo de OP QUE TERÁ MOVIMENTO de consumo a ser ignorado
Private ctpopign4	:= GetMv("MGF_TAP023",,"14")   //Tipo de OP QUE TERÁ MOVIMENTO DE  geração  a ser ignorado
Private ctpopig5	:= GetMv("MGF_TAP024",,"11")   //2o. Tipo de OP QUE TERÁ MOVIMENTO DE  geração 05  a ser ignorado
Private cMovReq2	:= GetMv("MGF_TAP025",,"05")	// Requisição a ser ignorada pelo ctpoig5

Private _cosso      := GetMv("MGF_TAP027",,"009983;009985") //Produtos osso para evitar duplicata
Private _ctposso    := GetMv("MGF_TAP026",,"06/07") //Tipo operação desossa para evitar duplicata

Private ctpopdes	:= GetMv("MGF_TAP02W",,"07/")   //Tipo de movimento de produção de desossa
Private cEncPrd		:= GetMv("MGF_TAP02K",,"04/")		// Encerramento de Produção
Private cMovDev		:= GetMv("MGF_TAP02L",,"03/")		// Devolução (Apontamento de Sub-produto)
Private cSubPrd		:= GetMv("MGF_TAP02M",,"02/")		// Tipo OP de Subproduto (02 = Miudo). Não gera OP para ZZE_CODPA
Private cTipTrn		:= GetMv("MGF_TAP02N",,"04")		// Tipo OP de Transformação Cabeça de gado em Kg. Processo de Entrada
Private cTipAbt		:= GetMv("MGF_TAP02Q",,"01/")		// Tipo OP de Abate
Private cMovTr 		:= GetMv("MGF_TAP02X",,"06/")		// Tipo Movimento de Transferencia MATA261
Private lAglMov		:= GetMv("MGF_TAP02G",,.T.)			// Aglutina movimentações
Private _nlast  	:= 0


cCodInt		:= GetMv("MGF_TAP02R",,"001") // Taura Produção
cCodTpInt	:= GetMv("MGF_TAP02S",,"000") // Integração Taura Produção
cEndPad		:= GetMv("MGF_TAP02T",,"01") // Integração Taura Produção
cEndPad		:= Stuff( Space(TamSX3("D3_LOCALIZ")[1]) , 1 , Len(cEndPad) , cEndPad ) 
cTipInd		:= GetMv("MGF_TAP02P",,"11/12/")		// Tipo OP Industrializado.

SB1->( dbSetOrder(1) )
SB2->( dbSetOrder(1) )
SC2->( dbSetOrder(9) ) // C2_FILIAL+C2_NUM+C2_ITEM+C2_PRODUTO
ZZE->( dbSetOrder(1) )
SD3->( dbSetOrder(2) )

_lretproc := .T.

If _cstatus == ' '

	U_MFCONOUT('Iniciando pré processamento de movimentos produtivos para filial ' + CFILANT + '...') 
	_lretproc := MGFTP02I()

Else

	_nlast := 999999999

Endif

If _lretproc .and. _cstatus == ' '

	U_MFCONOUT('Completou pré processamento de movimentos produtivos para filial ' + CFILANT + '...') 

Elseif _cstatus == ' '

	U_MFCONOUT('Falhou pré processamento de movimentos produtivos para filial ' + CFILANT + '...') 
	Return

Endif

If _lretproc

	If _lretproc .and. _cstatus == ' '

		U_MFCONOUT('Iniciando processamento de registros ignorados para filial ' + CFILANT + '...')  
		_lretproc := U_MGFTP02H()   
	
		If _lretproc	
	
			U_MFCONOUT('Completou processamento de registros ignorados para filial ' + CFILANT + '...')    

		Elseif _cstatus == ' '

			U_MFCONOUT('Falhou processamento de registros ignorados para filial ' + CFILANT + '...')  

		Endif  

	Endif                     


	If _lretproc .and. _cstatus == ' '

		U_MFCONOUT('Iniciando processamento de estornos de encerramento de OP para filial ' + CFILANT + '...')  
		_lretproc := U_MGFTP02W()   
	
		If _lretproc	
	
			U_MFCONOUT('Completou processamento de estornos de encerramento de OP para filial ' + CFILANT + '...')    

		Elseif _cstatus == ' '

			U_MFCONOUT('Falhou processamento de estornos de encerramento de OP para filial ' + CFILANT + '...')  

		Endif  

	Endif                     

	If _lretproc .and. _cstatus == ' '

		U_MFCONOUT('Iniciando validação de apontamentos de produção para filial ' + CFILANT + '...')  
		_lretproc := U_MGFTP02Q()
	
		If _lretproc
			U_MFCONOUT('Completou validação de apontamentos de produção para filial ' + CFILANT + '...') 
		Elseif _cstatus == ' '
			U_MFCONOUT('Falhou validação de apontamentos de produção para filial ' + CFILANT + '...') 	
		Endif

	Endif

	If _lretproc

		U_MFCONOUT('Iniciando execução de apontamentos de produção para filial ' + CFILANT + '...')   
		_lretproc := U_MGFTP02E(_cstatus)

		If _lretproc

			U_MFCONOUT('Completou execução de apontamentos de produção para filial ' + CFILANT + '...')  

		Else

			U_MFCONOUT('Falhou execução de apontamentos de produção para filial ' + CFILANT + '...') 

		Endif

	Endif
 
	If _lretproc

		U_MFCONOUT('Iniciando processamento de estornos de movimentos internos/produção para filial ' + CFILANT + '...')   
		_lretproc := U_MGFTP02K(1,_cstatus)           

		If _lretproc
		
			U_MFCONOUT('Completou processamento de estornos de movimentos internos/produção para filial ' + CFILANT + '...')  

		Else

			U_MFCONOUT('Falhou processamento de estornos de movimentos internos/produção para filial ' + CFILANT + '...') 	

		Endif

	Endif

	If _lretproc

		U_MFCONOUT('Iniciando reprocessamento de estornos de movimentos internos/produção para filial ' + CFILANT + '...')   
		_lretproc := U_MGFTP02K(2,_cstatus)           

		If _lretproc
		
			U_MFCONOUT('Completou reprocessamento de estornos de movimentos internos/produção para filial ' + CFILANT + '...')  

		Else

			U_MFCONOUT('Falhou reprocessamento de estornos de movimentos internos/produção para filial ' + CFILANT + '...') 	

		Endif

	Endif

	If _lretproc

		U_MFCONOUT('Iniciando execução de apontamentos de consumo para filial ' + CFILANT + '...')
		_lretproc := U_MGFTP02T(_cstatus)

		If _lretproc

			U_MFCONOUT('Completou execução de apontamentos de consumo para filial ' + CFILANT + '...')

		Else

			U_MFCONOUT('Falhou execução de apontamentos de consumo para filial ' + CFILANT + '...')

		Endif

	Endif

	If _lretproc .and. _cstatus == ' '

		U_MFCONOUT('Iniciando encerramentos de OP para filial ' + CFILANT + '...')
		_lretproc := U_MGFTP02J()

		If _lretproc

			U_MFCONOUT('Completou encerramentos de OP para filial ' + CFILANT + '...')

		Elseif _cstatus == ' '

			U_MFCONOUT('Falhou encerramentos de OP para filial ' + CFILANT + '...')

		Endif

	Endif

Endif

If _lretproc

	U_MFCONOUT('Completou processamento de movimentos produtivos (TAP02) para filial ' + CFILANT + '...') 

Else

	Disarmtransaction()

Endif


Return

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP0202 - Retorna próximo D3_DOC
@author  Atilio Amarilla
@since 08/11/2016
*/
Static Function MGFTP0202() 

Local cNumDoc	:= ""
		
While Empty(cNumDoc) .Or. SD3->( dbSeek( xFilial("SD3")+cNumDoc ) ) 
	cNumDoc	:= GetSXENum("SD3","D3_DOC")
	ConfirmSX8()
EndDo

Return( cNumDoc )
	

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP02I - Pré processamento de registros na ZZE
Realiza validações iniciais e marca registros que não serão processados
para melhorar performance dos jobs com execautos
@author  Atilio Amarilla
@since 08/11/2016
*/
Static Function MGFTP02I(_cstatus)

Local _lretloc := .T.
Local _carealoc := GetNextAlias()
Local _ntot := 0
Local _nni := 0
Local _nposi := ZZE->(Recno())
Local aRecno := {}

	BEGIN SEQUENCE

		//Grava última posição da ZZE para controlar último registro validado
		_cquery := "SELECT MAX(R_E_C_N_O_) RECNO FROM "+RetSqlName("ZZE")+" WHERE D_E_L_E_T_ <> '*'"
		If Select(_carealoc) > 0
			(_carealoc)->(Dbclosearea())
		Endif

		dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), _carealoc,.T.,.F.)
		dbSelectArea(_carealoc)

		_nlast := (_carealoc)->RECNO
		ZZE->(Dbgoto(_nlast))

		U_MFCONOUT('Processando registros até  ' + alltrim(ZZE->ZZE_CHAVEU) + '...') 

		ZZE->(Dbgoto(_nposi))

		//Marca registros da filial com status 2 e 6 enviados nas últimas 48 horas e processados 
		//há mais de 60 minutos para reprocessamento (para evitar erros de falta de saldo)

		U_MFCONOUT("Carregando registros com falha de saldo para reprocessamento...")

		_cquery := "select r_e_c_n_o_ RECNO from "+RetSqlName("ZZE")+" where d_e_l_e_t_ <> '*' "
		_cquery += " and zze_filial = '" + xfilial("ZZE") + "' "
		_cquery += " and zze_dtrec >= '" + dtos(date()-1) + "' "
		_cquery += " and (zze_status = '6' or (zze_acao = '2' and zze_status = '2' and zze_descer like '%TAP19%') "
		_cquery += "                              or (zze_acao = '1' and zze_status = '2' and zze_descer like '%localizada%')) "

		If val(substr(alltrim(time()),1,2)) > 0

			chora := strzero(val(substr(alltrim(time()),1,2))-1,2)
			cminuto := substr(alltrim(time()),3,3)

			_cquery += " and (substr(zze_hrproc,1,5) < '" + chora + cminuto + "' or zze_dtproc < '" + dtos(date()) + "') "

		else
			
			_cquery += " and zze_dtproc < '" + dtos(date()) + "' "

		Endif

		If Select(_carealoc) > 0
			(_carealoc)->(Dbclosearea())
		Endif

		dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), _carealoc,.T.,.F.)
		dbSelectArea(_carealoc)

		U_MFCONOUT("Contando registros com falha de saldo para reprocessamento...")

		_ntot := 0
		_nni := 1

		Do while (_carealoc)->(!Eof())
			_ntot++
			(_carealoc)->(Dbskip())
		ENDDO

		(_carealoc)->(Dbgotop())

		Do while (_carealoc)->(!Eof())

			U_MFCONOUT("Marcando registro para reprocessamento - " + strzero(_nni,6) + " de " +  strzero(_ntot,6) + "...")
			_nni++

			ZZE->(Dbgoto((_carealoc)->RECNO))

			Reclock("ZZE",.F.)
			ZZE->ZZE_CANCEL := " "
			ZZE->ZZE_DESCER := " "
			ZZE->ZZE_STATUS := " "
			ZZE->ZZE_HRPROC := " "
			ZZE->ZZE_DTPROC := STOD(" ")

			ZZE->(Msunlock())

			(_carealoc)->(Dbskip())

		Enddo

		//Marca registros da filial com status 2 e 6 enviados nas últimas 48 horas e processados 
		//há mais de 60 minutos para reprocessamento (para evitar erros de falta de saldo)

		U_MFCONOUT("Carregando registros com data anterior ao fechamento de estoque...")

		dMovBlq		:= GetMV("MV_DBLQMOV",,stod('20010101'))
		dMovBlq		:= Max( dMovBlq , GetMV("MV_ULMES",,stod('20010101')) )

		If dmovblq > stod('20010101')

			_cquery := "select r_e_c_n_o_ RECNO from "+RetSqlName("ZZE")+" where d_e_l_e_t_ <> '*' "
			_cquery += " and zze_filial = '" + xfilial("ZZE") + "' "
			_cquery += " and zze_EMISSA <= '" + dtos(dMovBlq) + "' "
			_cquery += " and ZZE_STATUS = ' ' "

			If Select(_carealoc) > 0
				(_carealoc)->(Dbclosearea())
			Endif

			dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), _carealoc,.T.,.F.)
			dbSelectArea(_carealoc)

			U_MFCONOUT("Contando registros data anterior ao fechamento de estoque...")

			_ntot := 0
			_nni := 1

			Do while (_carealoc)->(!Eof())
				_ntot++
				(_carealoc)->(Dbskip())
			ENDDO

			(_carealoc)->(Dbgotop())

			Do while (_carealoc)->(!Eof())

				U_MFCONOUT("Marcando registro com dat anterior ao fechamento de estoque - " + strzero(_nni,6) + " de " +  strzero(_ntot,6) + "...")
				_nni++

				ZZE->(Dbgoto((_carealoc)->RECNO))

				Reclock("ZZE",.F.)
				ZZE->ZZE_CANCEL := " "
				ZZE->ZZE_DESCER := "[MGFTAP02] Movimentação com data anterior ao fechamento (Bloqueio de Movimentação ou Virada de Saldos)."
				ZZE->ZZE_STATUS := "2"
				ZZE->ZZE_HRPROC := time()
				ZZE->ZZE_DTPROC := date()

				ZZE->(Msunlock())

				(_carealoc)->(Dbskip())

			Enddo

		Endif
 		
	END SEQUENCE


Return _lretloc

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP02W - Estorno de Encerramento de Produção (Mata250)
@author  Atilio Amarilla
@since 08/11/2016
*/
User Function MGFTP02W()

Local _nni := 0
Local _lretloc := .T.
Local _ntot := 0
Local _carealoc := GetNextAlias()

BEGIN SEQUENCE

cQryInc := "SELECT EXC.R_E_C_N_O_ RECNO, EXC.* "+CRLF
cQryInc += "FROM "+RetSqlName("ZZE")+" EXC "+CRLF
cQryInc += "WHERE EXC.D_E_L_E_T_ = ' ' "+CRLF
cQryInc += "	AND EXC.ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
cQryInc += "	AND EXC.ZZE_STATUS = ' ' "+CRLF
cQryInc += "	AND EXC.ZZE_ACAO = '2' "+CRLF
cQryInc += "    AND EXC.R_E_C_N_O_ <= " + alltrim(str(_nlast))
cQryInc += "	AND INSTR('"+alltrim(cEncPrd)+"',EXC.ZZE_TPMOV) > 0  "+CRLF
cQryInc += "ORDER BY EXC.R_E_C_N_O_ "+CRLF

If Select(_carealoc) > 0
	(_carealoc)->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryInc), _carealoc,.T.,.F.)
dbSelectArea(_carealoc)
(_carealoc)->(DbGoTop())

If (_carealoc)->(!Eof())

	While (_carealoc)->(!Eof())
		_ntot++
		(_carealoc)->(Dbskip())
	Enddo

	(_carealoc)->(DbGoTop())

Endif

While (_carealoc)->(!Eof()) .and. _lretloc

	_nni++
	U_MFCONOUT('Executando estorno de encerramento de OP ' + alltrim((_carealoc)->ZZE_OPTAUR) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6)) 

	aRotThread	:= {}

	ZZE->( dbGoTo( (_carealoc)->RECNO ) )

	cCodPA	:= (_carealoc)->ZZE_CODPA
	cTpOP	:= (_carealoc)->ZZE_TPOP
	SC2->( dbOrderNickName("OPTAURA") )
	cChave	:= (_carealoc)->(ZZE_FILIAL+ZZE_OPTAUR+ZZE_CODPA)

	If SC2->( dbSeek( cChave ) )

			If cCodPA == SC2->C2_PRODUTO

				SB1->( dbSeek( xFilial("SB1")+cCodPA ) )
				cNumOrd	:= SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )
				cNumDoc	:= ""
				cFilAnt		:= (_carealoc)->ZZE_FILIAL
				dDataBase	:= STOD( (_carealoc)->ZZE_EMISSAO )
				aRotAuto	:= {}

				aAdd( aRotAuto , {'C2_FILIAL'	, (_carealoc)->ZZE_FILIAL			,NIL} )
				aAdd( aRotAuto , {'C2_NUM'		, Subs(cNumOrd,1,6) 				,NIL} )
				aAdd( aRotAuto , {'C2_SEQUEN'	, Subs(cNumOrd,9,3)					,NIL} )
				aAdd( aRotAuto , {'C2_ITEM'		, Subs(cNumOrd,7,2)					,NIL} )
				aAdd( aRotAuto , {'C2_PRODUTO'	, cCodPA							,NIL} )
				aAdd( aRotAuto , {'C2_QUANT'	, (_carealoc)->ZZE_QUANT			,NIL} )
				aAdd( aRotAuto , {'__ZTPOP'		, cTpOP								,NIL} )
				aAdd( aRotAuto , {'__ZTPMOV'	, (_carealoc)->ZZE_TPMOV			,NIL} )
				aAdd( aRotAuto , {'__ZNUMOP'	, cNumOrd							,NIL} )
				aAdd( aRotAuto , {'__ZDATOP'	, STOD( (_carealoc)->ZZE_GERACA )	,NIL} )
				aAdd( aRotAuto , {'__ZDATEM'	, STOD( (_carealoc)->ZZE_EMISSA )	,NIL} )
				cIdSeq	:= Soma1(cIdSeq)
				aAdd( aRotAuto , {'__ZIDSEQ'	, cIdSeq							,NIL} )

				aAdd( aRotThread , aRotAuto )

			Else

				ZZE->( dbGoTo( (_carealoc)->RECNO ) )
				
				RecLock("ZZE",.F.)
				ZZE->ZZE_STATUS	:= "2"
				ZZE->ZZE_DESCER	:= "[MGFTAP02] PA "+AllTrim(cCodPA)+" diferente do PA da OP: "+AllTrim((_carealoc)->ZZE_CODPA)+". Chave : "+cChave
				ZZE->ZZE_DTPROC	:=  Date() 
				ZZE->ZZE_HRPROC	:= Time()
				ZZE->( msUnlock() )

				U_MFCONOUT("  PA "+AllTrim(cCodPA)+" diferente do PA da OP: "+AllTrim((_carealoc)->ZZE_CODPA)+". Chave : "+cChave) 
	
			EndIf

	Else

			ZZE->( dbGoTo( (_carealoc)->RECNO ) )
				
			RecLock("ZZE",.F.)
			ZZE->ZZE_STATUS	:= "2"
			ZZE->ZZE_DESCER	:= "[MGFTAP02] OP não localizada. Chave : "+cChave
			ZZE->ZZE_DTPROC	:=  Date() 
			ZZE->ZZE_HRPROC	:= Time()
			ZZE->( msUnlock() )

			U_MFCONOUT("  OP não localizada. Chave : "+cChave) 

	EndIf


	If Len( aRotThread ) > 0 .and. _lretloc

		cFunTAP		:= "U_MGFTAP07"
		cOpc		:= "2"
		aParThread	:= { " " , " " , cIdProc , (_carealoc)->ZZE_IDPROC }
		_lretloc := U_MGFTAP07( {cOpc ,;					//01
								aRotThread ,;				//02
								aParThread[1] ,;			//03
								aParThread[2] ,;			//04
								aParThread[3] ,;			//05
								(_carealoc)->ZZE_CHAVEU,;	//06
								(_carealoc)->RECNO})	//07		
		If _lretloc
			U_MFCONOUT('Completou estorno de encerramento de OP ' + alltrim((_carealoc)->ZZE_OPTAUR) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6)) 
		Else
			U_MFCONOUT('Falha de integridade dos dados...')
			Disarmtrnsaction()
			BREAK
		Endif
		aRotThread := {}

	EndIf

	(_carealoc)->( dbSkip() )

EndDo

dbSelectArea(_carealoc)
dbCloseArea()

END SEQUENCE

Return _lretloc

//-------------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP02K - Estorno de Movimentos Internos/Produção (Mata240/Mata250) 
@author  Atilio Amarilla
@since 08/11/2016
*/
User Function MGFTP02K(_nexe,_cstatus)

Local _lretloc := .T.
Local _carealoc := GetNextAlias()
Local _nni := 1
Local _ntot := 0

BEGIN SEQUENCE

cQryInc := "SELECT ZZE_ID, ZZE_FILIAL, ZZE_GERACA, ZZE_TPOP, ZZE_TPMOV, ZZE_CODPA, ZZE_PEDLOT, "+CRLF
cQryInc += "		ZZE_COD, EXC.ZZE_LOTECT, EXC.ZZE_DTVALI, EXC.ZZE_QUANT ZZE_QUANT, EXC.ZZE_LOCAL, ZZE_OPTAUR, "+CRLF
cQryInc += "		EXC.ZZE_QTDPCS ZZE_QTDPCS, EXC.ZZE_QTDCXS ZZE_QTDCXS, R_E_C_N_O_ RECNO, ZZE_CHAVEU  "+CRLF
cQryInc += "FROM "+RetSqlName("ZZE")+" EXC "+CRLF
cQryInc += "WHERE EXC.D_E_L_E_T_ = ' ' "+CRLF
cQryInc += "	AND EXC.ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF

If _cstatus == ' '
	cQryInc += "	AND (EXC.ZZE_STATUS = ' ' OR EXC.ZZE_STATUS = 'X') "+CRLF
Else
	cQryInc += "	AND (EXC.ZZE_STATUS = '" + _cstatus + "') "+CRLF
Endif

cQryInc += "	AND EXC.ZZE_ACAO = '2' "+CRLF
cQryInc += "    AND EXC.R_E_C_N_O_ <= " + alltrim(str(_nlast))+CRLF
cQryInc += "    AND ROWNUM < 100 " //Limita quantidade de estornos por execução para não atrasar outras integrações
If _nexe == 1 // Processamento = 1 , reprocessamento completo = 2
	cQryInc += "	AND INSTR('"+cEncPrd+cMovTr+"',EXC.ZZE_TPMOV) = 0 "+CRLF
Else
	cQryInc += "	AND INSTR('"+cMovTr+cEncPrd + cMovPrd + cMovDev+"',EXC.ZZE_TPMOV) = 0 "+CRLF
Endif
cQryInc += "ORDER BY ZZE_TPMOV DESC, ZZE_COD, ZZE_ID "+CRLF 

If Select(_carealoc) > 0
	(_carealoc)->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryInc), _carealoc,.T.,.F.)
dbSelectArea(_carealoc)
(_carealoc)->(DbGoTop())

If (_carealoc)->(!Eof())

	While (_carealoc)->(!Eof())
		_ntot++
		(_carealoc)->(Dbskip())
	Enddo

	(_carealoc)->(DbGoTop())

Endif

While (_carealoc)->(!Eof()) .and. _lretloc

	aRotThread	:= {}

	U_MFCONOUT('Executando estorno de movimento ' + alltrim((_carealoc)->ZZE_CHAVEU) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6)) 

	SB1->( dbSeek( xFilial("SB1")+(_carealoc)->ZZE_COD ) )
	cIdSeq	:= Soma1(cIdSeq)


	If LEN(ALLTRIM((_carealoc)->ZZE_PEDLOT))>=8

		_cpedlote := ALLTRIM((_carealoc)->ZZE_PEDLOT)


	Else

		_cpedlote := ""

	Endif
	
				
	aAdd( aRotThread , {	(_carealoc)->ZZE_FILIAL,	;
									(_carealoc)->ZZE_GERACA,	;
									(_carealoc)->ZZE_TPOP,		;
									(_carealoc)->ZZE_TPMOV,	;
									(_carealoc)->ZZE_CODPA,	;
									(_carealoc)->ZZE_COD,		;
									(_carealoc)->ZZE_LOTECT,	;
									(_carealoc)->ZZE_DTVALI,	;
									(_carealoc)->ZZE_QUANT,	;	
									(_carealoc)->ZZE_LOCAL,	;
									(_carealoc)->ZZE_OPTAUR,	;
									cIdProc,					;
									cIdSeq,						;
									(_carealoc)->ZZE_QTDPCS,	;
									(_carealoc)->ZZE_QTDCXS,;
									_cpedlote	;
									}	)


	If Len( aRotThread ) > 0 .and. _lretloc
				
		cFunTAP		:= "U_MGFTAP19"
		cOpc		:= "1"
		aParThread	:= { " " , " " , cIdProc , "" }
		_lretloc := U_MGFTAP19( {aRotThread , aParThread[3],(_carealoc)->ZZE_CHAVEU,(_carealoc)->RECNO} )

		If !_lretloc
			U_MFCONOUT('Falha de integridade dos dados...')
			Disarmtransaction()
			BREAK
		Endif
			
		aRotThread := {}

	EndIf

	U_MFCONOUT('Completou estorno de movimento ' + alltrim((_carealoc)->ZZE_CHAVEU) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6)) 
	_nni++
	(_carealoc)->( dbSkip() )

EndDo

dbSelectArea(_carealoc)
dbCloseArea()

END SEQUENCE


Return _lretloc

//-------------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP02Z - Abertura de OP de Industrializados 
@author  Atilio Amarilla
@since 08/11/2016
*/
User Function MGFTP02Z(_cfilial,coptaura,_cproduto,_nquant,_ddata,_ctipo)

Local _nni := 0
Local _ntot := 0
Local aNumOrd	:= {}
Local _lretloc := .T.
Local _carealoc := GetNextAlias()
Local _cultimo := " "


cCodPA	 := alltrim(_cproduto)
coptaura := alltrim(coptaura)

aRotThread	:= {}

_nni++
U_MFCONOUT('Abrindo OP ' + ALLTRIM(_cfilial) + "/" +alltrim(coptaura) + "/" + cCodPA + "...")

cCodPA	 := Stuff( Space(TamSX3("B1_COD")[1])     , 1 , Len(cCodPA) , cCodPA )
cOPTaura := Stuff( Space(TamSX3("C2_NUM")[1]) , 1 , Len(coptaura), coptaura )
	
SC2->( dbsetorder(1) ) //C2_FILIAL+C2_NUM  

_citem := "01"

//Define item a ser usado
If SC2->( dbSeek( _cfilial+SUBSTR(ALLTRIM(cOPTaura),1,6) ) )

	Do while SC2->C2_FILIAL + alltrim(SC2->C2_NUM) == _cfilial+SUBSTR(ALLTRIM(cOPTaura),1,6)

		If SC2->C2_ITEM >= _citem
			If SC2->C2_ITEM < '10'
				_citem := strzero(val(SC2->C2_ITEM)+1,2)
			Else
				_citem := soma1(SC2->C2_ITEM)
			Endif
		Endif


		SC2->(Dbskip())

	Enddo

Endif

//Define sequencia, se op tem mais de 6 caracteres coloca caracteres adicionais no c2_sequen
If len(alltrim(cOPTaura)) <= 6
	_cc2seque := '001'
Else
	_cc2seque := padl(substr(alltrim(cOPTaura),7,3),3,"0")
Endif
	
cChave	:= _cfilial+alltrim(cOPTaura)

			
aRotAuto	:= {}
	
aAdd( aRotAuto , {'C2_FILIAL'	, _cfilial								,NIL} )
aAdd( aRotAuto , {'C2_PRODUTO'	, _ccodpa								,NIL} )
aAdd( aRotAuto , {'C2_ITEM'		, _citem								,NIL} )
aAdd( aRotAuto , {'C2_SEQUEN'	, _cc2seque								,NIL} )
aAdd( aRotAuto , {'C2_NUM'		, alltrim(cOPTaura)						,NIL} )
aAdd( aRotAuto , {'C2_QUANT'	, _nquant								,NIL} )
aAdd( aRotAuto , {'C2_DATPRI'	, STOD(_ddata)-3						,NIL} )
aAdd( aRotAuto , {'C2_DATPRF'	, STOD(_ddata)							,NIL} )
aAdd( aRotAuto , {'C2_ZTIPO'	, _ctipo								,NIL} )
aAdd( aRotAuto , {'C2_ZOPTAUR'	, alltrim(cOPTaura)						,NIL} )
aAdd( aRotAuto , {'AUTEXPLODE'	, "N"									,NIL} )
aAdd( aRotAuto , {'__ZTPOP'		, _ctipo								,NIL} )

aAdd( aRotThread , aRotAuto )
		
cFunTAP		:= "U_MGFTAP03"
cOpc		:= "1"
aParThread	:= { " " , " " , cIdProc , "" }

IF Len(aRotThread) > 0 
	_lretloc := U_MGFTAP03( {	cOpc ,;						//01
								aRotThread ,; 				//02
								aParThread[1] ,; 			//03
								aParThread[2] ,; 			//04
								aParThread[3] ,; 			//05
								aParThread[4]  	} )			//06
	If _lretloc
		U_MFCONOUT('Abriu OP ' + alltrim(SC2->C2_FILIAL) + "/" + alltrim(SC2->C2_NUM)  + "/" + alltrim(SC2->C2_PRODUTO) + "...") 
	Else
		U_MFCONOUT('Falha de integridade dos dados...')
	Endif

EndIF

Return _lretloc

//-----------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP02H - Validação de apontamentos de produção ignorados pois não usa mais PI
@author  Josué Danich
@since 13/04/2020
*/
User Function MGFTP02H()

Local _lretloc := .T.
Local _nni := 0
Local _ntot := 0
Local _carealoc := GetNextAlias()
Local _careadup := GetNextAlias()
Local _careaval := GetNextAlias()

Local _cprod08 := getmv("MV_TAP17P8") //produtos para movimento 08 02
Local _cprod1102 := getmv("MV_TAP17P1") // produtos para não ignorar movimento 11 02
Local _cprod14 := getmv("MV_TAP17P2") + "," + getmv("MV_TAP17P3") //produtos para tratar diferente os movimentos 14 02


cUpd := "SELECT R_E_C_N_O_ RECNO, 1  TIPO FROM  "+RetSqlName("ZZE")+" " + CRLF
cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += "	AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
cUpd += "	AND ZZE_STATUS = ' ' "+CRLF
cUpd += "	AND ZZE_ACAO IN ('1','2') "+CRLF // 1 - Inclusão / 2 - Estorno/Exclusaão
cUpd += "	AND INSTR('"+cMovPrd+cMovReq+"',ZZE_TPMOV) > 0 "+CRLF
cUpd += "   AND R_E_C_N_O_ <= " + alltrim(str(_nlast))
cUpd += "	AND INSTR('" + ctpopign + "',ZZE_TPOP) > 0  " + CRLF

cUpd += " UNION ALL "

cUpd += " SELECT R_E_C_N_O_ RECNO, 1  TIPO FROM  "+RetSqlName("ZZE")+" " + CRLF
cUpd += " WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += "	AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
cUpd += "	AND ZZE_STATUS = ' ' "+CRLF
cUpd += "	AND ZZE_ACAO IN ('1','2') "+CRLF // 1 - Inclusão / 2 - Estorno/Exclusaão
cUpd += "	AND INSTR('"+cMovReq+"',ZZE_TPMOV) > 0 "+CRLF
cUpd += "   AND R_E_C_N_O_ <= " + alltrim(str(_nlast))
cUpd += "	AND INSTR('" + ctpopig2 + "',ZZE_TPOP) > 0  " + CRLF


cUpd += " UNION ALL "

cUpd += " SELECT R_E_C_N_O_ RECNO, 1  TIPO FROM  "+RetSqlName("ZZE")+" " + CRLF
cUpd += " WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += "	AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
cUpd += "	AND ZZE_STATUS = ' ' "+CRLF
cUpd += "	AND ZZE_ACAO IN ('1','2') "+CRLF // 1 - Inclusão / 2 - Estorno/Exclusaão
cUpd += "	AND INSTR('"+cMovReq2+"',ZZE_TPMOV) > 0 "+CRLF
cUpd += "   AND R_E_C_N_O_ <= " + alltrim(str(_nlast))
cUpd += "	AND INSTR('" + ctpopig5 + "',ZZE_TPOP) > 0  " + CRLF

cUpd += " UNION ALL "

cUpd += " SELECT R_E_C_N_O_ RECNO, 2  TIPO FROM  "+RetSqlName("ZZE")+" ZZE " + CRLF
cUpd += " WHERE ZZE.D_E_L_E_T_ = ' ' "+CRLF
cUpd += "	AND ZZE.ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
cUpd += "   AND ZZE.ZZE_COD IN  "+ FORMATIN(_cosso,";")+CRLF
cUpd += "	AND ZZE.ZZE_STATUS = ' ' "+CRLF
cUpd += "	AND ZZE.ZZE_ACAO IN ('1') "+CRLF // 1 - Inclusão / 2 - Estorno/Exclusaão
cUpd += "	AND INSTR('"+cMovPrd+"',ZZE.ZZE_TPMOV) > 0 "+CRLF
cUpd += "   AND R_E_C_N_O_ <= " + alltrim(str(_nlast))
cUpd += "	AND INSTR('" + _ctposso + "',ZZE_TPOP) > 0  " + CRLF
cUpd += "   and exists(select * from zze010 zze2 where zze2.zze_filial = ZZE.ZZE_FILIAL  " + CRLF
cUpd += "                                                    and zze2.zze_tpop = zze.ZZE_TPOP " + CRLF
cUpd += "                                                    and zze2.zze_tpmov = zze.zze_tpmov " + CRLF
cUpd += "                                                     and zze2.zze_acao = '1' " + CRLF
cUpd += "                                                      and zze2.d_e_l_e_t_ <> '*' " + CRLF
cUpd += "                                                   and zze.zze_cod = zze2.zze_cod " + CRLF
cUpd += "                                                   and zze.zze_codpa = zze2.zze_codpa " + CRLF
cUpd += "                                                   and zze.zze_filial = zze2.zze_filial " + CRLF
cUpd += "                                                   and zze.zze_optaur = zze2.zze_optaur " + CRLF
cUpd += "                                                   and zze.zze_quant = zze2.zze_quant " + CRLF
cUpd += "                                                   and zze.zze_geraca = zze2.zze_geraca " + CRLF
cUpd += "                                                   and zze.zze_emissa = zze2.zze_emissa " + CRLF
cUpd += "                                                    and zze.r_e_c_n_o_ < zze2.r_e_c_n_o_) " + CRLF

cUpd += " UNION ALL "

cUpd += " SELECT R_E_C_N_O_ RECNO, 1  TIPO FROM  "+RetSqlName("ZZE")+" " + CRLF
cUpd += " WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += "	AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
cUpd += "	AND ZZE_STATUS = ' ' "+CRLF
cUpd += "	AND ZZE_ACAO IN ('1','2') "+CRLF // 1 - Inclusão / 2 - Estorno/Exclusaão
cUpd += "	AND INSTR('02',ZZE_TPMOV) > 0 "+CRLF
cUpd += "   AND R_E_C_N_O_ <= " + alltrim(str(_nlast))
cUpd += "	AND INSTR('08',ZZE_TPOP) > 0  " + CRLF
cUpd += "	AND INSTR('" + _cprod08 + "',TRIM(ZZE_COD)) > 0  " + CRLF

cUpd += " UNION ALL "

cUpd += " SELECT R_E_C_N_O_ RECNO, 1  TIPO FROM  "+RetSqlName("ZZE")+" " + CRLF
cUpd += " WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += "	AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
cUpd += "	AND ZZE_STATUS = ' ' "+CRLF
cUpd += "	AND ZZE_ACAO IN ('1','2') "+CRLF // 1 - Inclusão / 2 - Estorno/Exclusaão
cUpd += "	AND INSTR('02',ZZE_TPMOV) > 0 "+CRLF
cUpd += "   AND R_E_C_N_O_ <= " + alltrim(str(_nlast))
cUpd += "	AND INSTR('11',ZZE_TPOP) > 0  " + CRLF
cUpd += "	AND (ZZE_QTDPCS = 0 OR INSTR('010056',ZZE_FILIAL) > 0 )   " + CRLF

cUpd += " UNION ALL "

cUpd += " SELECT R_E_C_N_O_ RECNO, 1  TIPO FROM  "+RetSqlName("ZZE")+" " + CRLF
cUpd += " WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += "	AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
cUpd += "	AND ZZE_STATUS = ' ' "+CRLF
cUpd += "	AND ZZE_ACAO IN ('1','2') "+CRLF // 1 - Inclusão / 2 - Estorno/Exclusaão
cUpd += "	AND INSTR('05',ZZE_TPMOV) > 0 "+CRLF
cUpd += "   AND R_E_C_N_O_ <= " + alltrim(str(_nlast))
cUpd += "	AND INSTR('05/06',ZZE_TPOP) > 0  " + CRLF
cUpd += "	AND INSTR('010003,010067,010068,010056',ZZE_FILIAL) > 0  " + CRLF
	

If Select(_carealoc) > 0
	(_carealoc)->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cUpd), _carealoc,.T.,.F.)
dbSelectArea(_carealoc)
(_carealoc)->(DbGoTop())


If .F. //(_carealoc)->(!Eof())

	U_MFCONOUT('Contando validação de registros a serem ignorados na filial  ' + CFILANT + '...') 

	While (_carealoc)->(!Eof())
		_ntot++
		(_carealoc)->(Dbskip())
	Enddo

	(_carealoc)->(DbGoTop())

Endif

While (_carealoc)->(!Eof())

	ZZE->( dbGoTo( (_carealoc)->RECNO ) )

	_nni++
	U_MFCONOUT('Gravando registros a serem ignorados -  '; 
					+ alltrim(str((_carealoc)->RECNO))  + " - " +  strzero(_nni,6) + " de " +  strzero(_ntot,6) + '...') 


	_ltratar := .T.

	//Para alegrete ignora movimentos de troca de produto com código diferente do código pa
	If _ltratar .and. ZZE->ZZE_TPOP = '11' .AND. ZZE->ZZE_TPMOV = '02' ;
			.and. ZZE->ZZE_FILIAL $ '010056' .AND. ALLTRIM(ZZE->ZZE_COD) != ALLTRIM(ZZE->ZZE_CODPA);
			.and. !(alltrim(ZZE->ZZE_COD) $ _cprod1102)
	
		RecLock("ZZE",.F.)
		ZZE->ZZE_STATUS	:= "1"
		ZZE->ZZE_DESCER	:= "[MGFTAP02] Registro ignorado por troca de produto com PA diferente do código"
		ZZE->ZZE_DTPROC	:=  Date() 
		ZZE->ZZE_HRPROC	:= Time()
		ZZE->( msUnlock() )
		_ltratar := .F.

	Elseif _ltratar .and. ZZE->ZZE_TPOP = '11' .AND. ZZE->ZZE_TPMOV = '02' .and. ZZE->ZZE_FILIAL $ '010056';
			 .AND. (ALLTRIM(ZZE->ZZE_COD) == ALLTRIM(ZZE->ZZE_CODPA) .OR. (alltrim(ZZE->ZZE_COD) $ _cprod1102))
	
		_ltratar := .F.

	Endif

	//Ignora movimentos de troca de produto com caixas e pecas zeradas
	If _ltratar .and. ZZE->ZZE_TPOP = '11' .AND. ZZE->ZZE_TPMOV = '02' .and. ZZE->ZZE_QTDPCS = 0 .and.  alltrim(ZZE->ZZE_COD) $ '009860,009861'
	
		RecLock("ZZE",.F.)
		ZZE->ZZE_STATUS	:= "1"
		ZZE->ZZE_DESCER	:= "[MGFTAP02] Registro ignorado por troca de produto com pecas e caixas zeradas"
		ZZE->ZZE_DTPROC	:=  Date() 
		ZZE->ZZE_HRPROC	:= Time()
		ZZE->( msUnlock() )
		_ltratar := .F.

	Endif

	//Ignora movimentos tpop 05/06 e tpmov 05 de Promissão e Várzea Grande
	If _ltratar .and. ZZE->ZZE_TPOP $ '05/06' .AND. ZZE->ZZE_TPMOV = '05' .and. ZZE->ZZE_FILIAL $ '010003,010067,010068,010056'
	
		RecLock("ZZE",.F.)
		ZZE->ZZE_STATUS	:= "1"
		ZZE->ZZE_DESCER	:= "[MGFTAP02] Registro ignorado por regra TPOP 05/06 e TPMOV 05 de Promissao/Varzea"
		ZZE->ZZE_DTPROC	:=  Date() 
		ZZE->ZZE_HRPROC	:= Time()
		ZZE->( msUnlock() )
		_ltratar := .F.

	Endif

	//Não ignora movimentos de estorno especificos
	If _ltratar .and. ZZE->ZZE_TPOP = '11' .AND. ZZE->ZZE_TPMOV = '02' .and. ZZE->ZZE_ACAO = '2' .AND. alltrim(ZZE->ZZE_COD) $ '301460'
		_ltratar := .F.
	Endif 

	//Não ignora movimentos de produtos 11/02 de Pampeano e Promissao e os que sobraram de Alegrete
	If _ltratar .and. ZZE->ZZE_TPOP = '11' .AND. ZZE->ZZE_TPMOV = '02' .and. alltrim(ZZE->ZZE_FILIAL) $ '010003,020001'  
		_ltratar := .F.
	Endif 

	//não ignora movimentos de produtos 35000 com 11/02 para Várzea Grande industrializado
	If _ltratar .and. ZZE->ZZE_TPOP = '11' .AND. ZZE->ZZE_TPMOV = '02' .and. alltrim(ZZE->ZZE_FILIAL) $ '010067'  
		If alltrim(ZZE->ZZE_COD) >= '035000'
			_ltratar := .F.
		Endif
	Endif

	//Tratamento de dessossa de conserva 
	If _ltratar .and. alltrim(ZZE->ZZE_COD) $ _cprod08 .AND. alltrim(ZZE->ZZE_TPOP) $ '08' .AND. alltrim(ZZE->ZZE_TPMOV) $ '02'

		//Ignora consumos de desossa de conserva do tipo 08
		RecLock("ZZE",.F.)
		ZZE->ZZE_STATUS	:= "1"
		ZZE->ZZE_DESCER	:= "[MGFTAP02] Registro ignorado por regra de negócio - Desossa conserva"
		ZZE->ZZE_DTPROC	:=  Date() 
		ZZE->ZZE_HRPROC	:= Time()
		ZZE->( msUnlock() )
		_ltratar := .F.

	Endif

	//Tratamento para graxaria
	If _ltratar .and.  alltrim(ZZE->ZZE_COD) $ "005325,017356,017358" .and. alltrim(ZZE->ZZE_TPOP) $ '11' .AND. alltrim(ZZE->ZZE_TPMOV) $ '03'

		_ltratar := .F.

	Endif

	//Tratamento de consumo de dianteiro
	If _ltratar .and. alltrim(ZZE->ZZE_COD) $ _cprod14 .AND. alltrim(ZZE->ZZE_TPOP) $ '14' .AND. alltrim(ZZE->ZZE_TPMOV) $ '02'

		//Exceções para Promissão
		If !(alltrim(ZZE->ZZE_FILIAL) $ '010003' .and. alltrim(ZZE->ZZE_COD) $ '008003,008004,009498') 

			_ltratar := .F.

		Endif

	Endif


	If  _ltratar .and. alltrim(ZZE->ZZE_TPOP) $ ctpopign .AND. (_carealoc)->TIPO == 1

		If alltrim(ZZE->ZZE_TPMOV) $ cmovprd .and. alltrim(ZZE->ZZE_TPOP) $ ctpopign4  //movimento de produção de intermediário que vira consumo

			//Não realiza para produtos de dianteiro
			If (alltrim(ZZE->ZZE_FILIAL) $ '010003' .and. alltrim(ZZE->ZZE_COD) $ '008003,008004,009498') ;
				.or. !(ALLTRIM(ZZE->ZZE_COD) $ _cprod14 .AND. alltrim(ZZE->ZZE_TPOP) = '14' .AND. alltrim(ZZE->ZZE_TPMOV) = '01')  

				RecLock("ZZE",.F.)
				ZZE->ZZE_STATUS	:= "X"
				ZZE->ZZE_TPMOV	:= "XX"
				ZZE->( msUnlock() )

			else
	
				RecLock("ZZE",.F.)
				ZZE->ZZE_STATUS	:= "1"
				ZZE->ZZE_DESCER	:= "[MGFTAP02] Registro ignorado por regra de negócio - PI Dianteiro"
				ZZE->ZZE_DTPROC	:=  Date() 
				ZZE->ZZE_HRPROC	:= Time()
				ZZE->( msUnlock() )
	
			Endif

		Elseif !(alltrim(ZZE->ZZE_TPMOV) $ cmovprd) 
		
		
				RecLock("ZZE",.F.)
				ZZE->ZZE_STATUS	:= "1"
				ZZE->ZZE_DESCER	:= "[MGFTAP02] Registro ignorado por regra de negócio -Parametro MGF_TAP02Y."
				ZZE->ZZE_DTPROC	:=  Date() 
				ZZE->ZZE_HRPROC	:= Time()
				ZZE->( msUnlock() )


		Endif

	Elseif  _ltratar .and.  (_carealoc)->TIPO == 1

		//Movimentos de consumo de intermediarios a serem ignorados
		RecLock("ZZE",.F.)
		ZZE->ZZE_STATUS	:= "1"
		ZZE->ZZE_DESCER	:= "[MGFTAP02] Registro ignorado por regra de negócio -Parametro MGF_TAP02Y."
		ZZE->ZZE_DTPROC	:=  Date() 
		ZZE->ZZE_HRPROC	:= Time()
		ZZE->( msUnlock() )

	Elseif  _ltratar  

		//Movimentos de consumo de intermediarios a serem ignorados
		RecLock("ZZE",.F.)
		ZZE->ZZE_STATUS	:= "1"
		ZZE->ZZE_DESCER	:= "[MGFTAP02] Registro ignorado por regra de negócio -Parametro MGF_TAP02Y."
		ZZE->ZZE_DTPROC	:=  Date() 
		ZZE->ZZE_HRPROC	:= Time()
		ZZE->( msUnlock() )

	Endif

	(_carealoc)->(Dbskip())

Enddo

//Corrigindo valores absurdos na SB2
If cfilant $ GETMV("MGFTAP02AF",,"010099") 

	U_MFCONOUT('Validando SB2 na filial  ' + CFILANT + '...') 

	cUpd := " SELECT R_E_C_N_O_ RECNO  FROM  "+RetSqlName("SB2")+" " + CRLF
	cUpd += " WHERE D_E_L_E_T_ = ' ' "+CRLF
	cUpd += "	AND (B2_VATU1 > 1000000000 OR  B2_VATU1 < -1000000000) AND B2_LOCAL = '05' " + CRLF
	cUpd += "	AND INSTR('"+GETMV("MGFTAP02AF",,"010099")+"',B2_FILIAL) > 0   " + CRLF
	

	If Select(_carealoc) > 0
		(_carealoc)->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cUpd), _carealoc,.T.,.F.)
	dbSelectArea(_carealoc)

	Do while (_carealoc)->(!Eof())

		SB2->(DBGOTO((_carealoc)->RECNO))

		If SB2->B2_VATU1 < -1000000000 .OR. SB2->B2_VATU1 > 1000000000
		
			Reclock("SB2",.F.)
			SB2->B2_VATU1 := 0
			SB2->(Msunlock())

		Endif

		(_carealoc)->(Dbskip())

	Enddo

Endif

	

Return _lretloc

//-----------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP02Q - Validação de apontamentos de produção para produto igual a produto acabado
@author  Atilio Amarilla
@since 08/11/2016
*/
User Function MGFTP02Q()

Local _lretloc := .T.
Local _nni := 0
Local _ntot := 0
Local _carealoc := GetNextAlias()

cUpd := "SELECT R_E_C_N_O_ RECNO FROM  "+RetSqlName("ZZE")+" " + CRLF
cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += "	AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
cUpd += "	AND ZZE_STATUS = ' ' "+CRLF
cUpd += "	AND ZZE_ACAO IN ('1','2') "+CRLF // 1 - Inclusão / 2 - Estorno/Exclusaão
cUpd += "	AND INSTR('"+cMovPrd+"',ZZE_TPMOV) > 0 "+CRLF
cUpd += "   AND R_E_C_N_O_ <= " + alltrim(str(_nlast))
cUpd += "	AND ZZE_CODPA <> ZZE_COD " + CRLF

If Select(_carealoc) > 0
	(_carealoc)->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cUpd), _carealoc,.T.,.F.)
dbSelectArea(_carealoc)
(_carealoc)->(DbGoTop())


If (_carealoc)->(!Eof())

	U_MFCONOUT('Contando validação de registros contra Código PA <> Código do Produto da filial ' + CFILANT + '...') 

	While (_carealoc)->(!Eof())
		_ntot++
		(_carealoc)->(Dbskip())
	Enddo

	(_carealoc)->(DbGoTop())

Endif

While (_carealoc)->(!Eof())

	ZZE->( dbGoTo( (_carealoc)->RECNO ) )

	_nni++
	U_MFCONOUT('Gravando validação de registros contra Código PA <> Código do Produto da chave '; 
					+ alltrim(str((_carealoc)->RECNO))  + "-" +  strzero(_nni,6) + " de " +  strzero(_ntot,6) + '...') 
				
	RecLock("ZZE",.F.)
	ZZE->ZZE_STATUS	:= "2"
	ZZE->ZZE_DESCER	:= "[MGFTAP02] Apontamento de Produção. Inconsistência de dados, Código PA <> Código do Produto."
	ZZE->ZZE_DTPROC	:=  Date() 
	ZZE->ZZE_HRPROC	:= Time()
	ZZE->( msUnlock() )

	(_carealoc)->(Dbskip())

Enddo

Return _lretloc

//-----------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP02E - Execução de Apontamentos (Mata250)  
@author  Atilio Amarilla
@since 08/11/2016
*/
User Function MGFTP02E(_cstatus)

Local _nni := 0
Local _lretloc := .T.
Local _ntot := 0
Local _carealoc := GetNextAlias()
Local _cultimo := " "

BEGIN SEQUENCE

cQryInc := "SELECT ZZE_ID, ZZE_FILIAL, ZZE_LOCAL, ZZE_GERACA, ZZE_EMISSA, ZZE_TPOP, ZZE_TPMOV, ZZE_CODPA, ZZE_COD, ZZE_LOTECT, ZZE_DTVALI, "+CRLF
cQryInc += "		ZZE_QUANT ZZE_QUANT, ZZE_QTDPCS ZZE_QTDPCS, ZZE_QTDCXS ZZE_QTDCXS, ZZE_PEDLOT, ZZE_OPTAUR,ZZE_CHAVEU, R_E_C_N_O_ RECNO "+CRLF
cQryInc += "FROM "+RetSqlName("ZZE")+" ZZE "+CRLF
cQryInc += "WHERE ZZE.D_E_L_E_T_ = ' ' "+CRLF
cQryInc += "	AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
cQryInc += "	AND ZZE_STATUS = '" + _cstatus + "' "+CRLF
cQryInc += "	AND ZZE_ACAO = '1' "+CRLF
cQryInc += "	AND ZZE_CANCEL = ' ' "+CRLF
cQryInc += "    AND R_E_C_N_O_ <= " + alltrim(str(_nlast))
cQryInc += "	AND INSTR('"+cMovPrd+"',ZZE_TPMOV) > 0 "+CRLF
cQryInc += "ORDER BY ZZE_OPTAUR,ZZE_COD,ZZE_PEDLOT "+CRLF

If Select(_carealoc) > 0
	(_carealoc)->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryInc), _carealoc,.T.,.F.)
dbSelectArea(_carealoc)
(_carealoc)->(DbGoTop())

If (_carealoc)->(!Eof())

	While (_carealoc)->(!Eof())
		_ntot++
		_cultimo := ((_carealoc)->ZZE_OPTAUR + (_carealoc)->ZZE_COD + (_carealoc)->ZZE_PEDLOT)
		Do while (_carealoc)->( !eof()) .and. ((_carealoc)->ZZE_OPTAUR + (_carealoc)->ZZE_COD + (_carealoc)->ZZE_PEDLOT) == _cultimo
			(_carealoc)->(Dbskip())
		Enddo
	Enddo

	(_carealoc)->(DbGoTop())

Endif

While (_carealoc)->(!Eof())

	aRotThread	:= {}

	BEGIN TRANSACTION

	While !(_carealoc)->( eof() ) .And. Len( aRotThread  ) < 1

		_nni++
		_coptaura := alltrim((_carealoc)->ZZE_OPTAUR)
		_ccodpa := alltrim((_carealoc)->ZZE_CODPA)
		_cchaveu := (_carealoc)->ZZE_CHAVEU
		_nrecno := (_carealoc)->RECNO

		U_MFCONOUT('Executando apontamento para ' + _coptaura  + "/" + _ccodpa  + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

		aRotAuto	:= {}
		cCodPA	 := Stuff( Space(TamSX3("B1_COD")[1])     , 1 , Len((_carealoc)->ZZE_CODPA) , (_carealoc)->ZZE_CODPA )
		cOPTaura := Stuff( Space(TamSX3("C2_ZOPTAUR")[1]) , 1 , Len((_carealoc)->ZZE_OPTAUR), (_carealoc)->ZZE_OPTAUR )
		SC2->( dbOrderNickName("OPTAURA") )
		cChave	:= (_carealoc)->ZZE_FILIAL+cOPTaura+cCodPA

		//Se não achar a OP cria agora
		If !(SC2->( dbSeek( cChave ) ))

			U_MGFTP02Z((_carealoc)->ZZE_FILIAL,coptaura,cCodPA,0.01,(_carealoc)->ZZE_EMISSA,(_carealoc)->ZZE_TPOP)
			aRotThread := {}

		Endif

		cCodPA	 := Stuff( Space(TamSX3("B1_COD")[1])     , 1 , Len((_carealoc)->ZZE_CODPA) , (_carealoc)->ZZE_CODPA )
		cOPTaura := Stuff( Space(TamSX3("C2_ZOPTAUR")[1]) , 1 , Len((_carealoc)->ZZE_OPTAUR), (_carealoc)->ZZE_OPTAUR )
		SC2->( dbOrderNickName("OPTAURA") )
		cChave	:= (_carealoc)->ZZE_FILIAL+cOPTaura+cCodPA

		If SC2->( dbSeek( cChave ) )

			If !Empty( SC2->C2_DATRF )
				RecLock("SC2",.F.)
				SC2->C2_DATRF	:= CTOD("")
				SC2->( msUnlock() )
			EndIf

			If SC2->C2_PRODUTO == (_carealoc)->ZZE_CODPA

				SB1->( dbSeek( xFilial("SB1")+(_carealoc)->ZZE_COD ) )
				_ccodpro := SB1->B1_COD
				_clocpr := SB1->B1_LOCPAD
				cNumOrd	:= SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )
				cNumDoc	:= MGFTP0202()
				cTM := cTMPrd
				aRotAuto	:= {}

				_nquant := 0
				_nqtdpcs := 0
				_nqtdcxs := 0
				_cultimo := ((_carealoc)->ZZE_OPTAUR + (_carealoc)->ZZE_COD) + (_carealoc)->ZZE_PEDLOT
				_cfilial := (_carealoc)->ZZE_FILIAL
				_clocal := (_carealoc)->ZZE_LOCAL 

				//Se for produção de dessossa deve seguir data de geração da OP
				If (_carealoc)->ZZE_TPOP $ ctpopdes
					_demissao := STOD((_carealoc)->ZZE_GERACA)
				Else
					_demissao := STOD((_carealoc)->ZZE_EMISSA)
				Endif

				_ctpop := (_carealoc)->ZZE_TPOP
				_coptaura := (_carealoc)->ZZE_OPTAUR
				_cpedlot := (_carealoc)->ZZE_PEDLOT
				_ctpmov := (_carealoc)->ZZE_TPMOV
				_ccodpa := (_carealoc)->ZZE_CODPA
				
				//Busca registros seguintes para aglutinar em uma D3
				Do while (_carealoc)->( !eof()) .and. ((_carealoc)->ZZE_OPTAUR + (_carealoc)->ZZE_COD + (_carealoc)->ZZE_PEDLOT) == _cultimo

					_nquant += (_carealoc)->ZZE_QUANT
					_nqtdpcs += (_carealoc)->ZZE_QTDPCS
					_nqtdcxs += (_carealoc)->ZZE_QTDCXS

					//Grava mesma chave de aglutinação em todos os registros
					ZZE->(Dbgoto((_carealoc)->RECNO))
						Reclock("ZZE",.F.)
					ZZE->ZZE_CHAVEA := _cchaveu
					ZZE->(Msunlock())

					(_carealoc)->( dbSkip() )

				Enddo
				

				aAdd( aRotAuto ,	{"D3_FILIAL"	, _cfilial		,NIL} )
				aAdd( aRotAuto ,	{"D3_TM"		, cTM							,NIL} )
				aAdd( aRotAuto ,	{"D3_COD"		, _ccodpro					,NIL} )
				aAdd( aRotAuto ,	{"D3_QUANT"		, _nquant		,NIL} )
				aAdd( aRotAuto ,	{"D3_ZQTDPCS"	, _nqtdpcs		,NIL} )
				aAdd( aRotAuto ,	{"D3_ZQTDCXS"	, _nqtdcxs		,NIL} )
				aAdd( aRotAuto ,	{"D3_OP"		, cNumOrd						,NIL} )
				aAdd( aRotAuto ,	{"D3_LOCAL"		, IIF(Empty(_clocal), _clocpr , _clocal ),NIL} )
				aAdd( aRotAuto ,	{"D3_DOC"		, cNumDoc						,NIL} )
				aAdd( aRotAuto ,	{"D3_PARCTOT"	, "P"							,NIL} )
				aAdd( aRotAuto ,	{"D3_EMISSAO"	, _demissao ,NIL} )
				aAdd( aRotAuto ,	{"D3_ZTIPO"		, _ctpop		,NIL} )
				aAdd( aRotAuto ,	{"__UUID"		, _cchaveu		,NIL} )

				If SB1->B1_LOCALIZ == "S"
					aAdd( aRotAuto ,	{"D3_LOCALIZ"	, cEndPad				,NIL} )
				EndIf

				aAdd( aRotAuto , {"D3_ZOPTAUR"	, _coptaura			,NIL} )

				If !Empty(_cpedlot) .And. _ctpop == "01" // Abate
					aAdd( aRotAuto ,	{"D3_ZPEDLOT"	, _cpedlot				,NIL} )
				EndIf

				aAdd( aRotAuto , {'__ZTPOP'		, _ctpop			,NIL} )
				aAdd( aRotAuto , {'__ZTPMOV'	, _ctpmov			,NIL} )
				aAdd( aRotAuto , {'__ZCODPA'	, _ccodpa			,NIL} )
				aAdd( aRotAuto , {'__ZOPTAURA'	, _coptaura			,NIL} )
				aAdd( aRotAuto , {'__LOCAL'	    ,IIF(Empty(_clocal), .F. , .T.),NIL}  )

				aAdd( aRotThread , aRotAuto )

			Else

				ZZE->( dbGoTo( (_carealoc)->RECNO ) )
				
				RecLock("ZZE",.F.)
				ZZE->ZZE_STATUS	:= "2"
				ZZE->ZZE_DESCER	:= "[MGFTAP02] PA "+AllTrim((_carealoc)->ZZE_CODPA)+" diferente do PA da OP: "+AllTrim(SC2->C2_PRODUTO)+". Chave : "+cChave
				ZZE->ZZE_DTPROC	:=  Date() 
				ZZE->ZZE_HRPROC	:= Time()
				ZZE->( msUnlock() )
				
				U_MFCONOUT("PA " + _ccodpa +" diferente do PA da OP: "+AllTrim(SC2->C2_PRODUTO) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

			EndIf

		Else

				ZZE->( dbGoTo( (_carealoc)->RECNO ) )
				
				RecLock("ZZE",.F.)
				ZZE->ZZE_STATUS	:= "2"
				ZZE->ZZE_DESCER	:= "[MGFTAP02] OP não localizada. Chave : "+cChave
				ZZE->ZZE_DTPROC	:=  Date() 
				ZZE->ZZE_HRPROC	:= Time()
				ZZE->( msUnlock() )
	
				U_MFCONOUT('OP não localizada ' + _coptaura + "/" + _ccodpa + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

		EndIf


		If _nrecno == (_carealoc)->RECNO //Se não avançou de registro faz avanço agora
			(_carealoc)->(Dbskip())
		Endif

	EndDo

	If Len( aRotThread ) > 0 .and. _lretloc
				
		cFunTAP		:= "U_MGFTAP04"
		cOpc		:= "1"
		aParThread	:= { " " , " " , cIdProc , "" }
		_lretloc := U_MGFTAP04( {cOpc ,;					//01
								 aRotThread ,;				//02
								 aParThread[1] ,;			//03
								 aParThread[2] ,;			//04
								 aParThread[3] ,;			//05
								_cchaveu		,;			//06
								_nrecno  	} )				//07
		
		If _lretloc
		
			U_MFCONOUT('Completado apontamento para ' + ALLTRIM(_coptaura) + "/" + ALLTRIM(_ccodpa) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

		Else

				_lretloc := .F.
				U_MFCONOUT('Falha de integridade dos dados...')
				Disarmtransaction()

		Endif

		aRotThread := {}
	
	EndIf

	END TRANSACTION
	
EndDo

dbSelectArea(_carealoc)
dbCloseArea()

END SEQUENCE

Return _lretloc

//-----------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP02T - Movimentos Internos (Mata240) - Requisição para OP (Consumo)  
@author  Atilio Amarilla
@since 08/11/2016
*/
User Function MGFTP02T(_cstatus)

Local _nni := 0
Local _lretloc := .T.
Local _carealoc := GetNextAlias()
Local _ntot := 0
Local _cultimo := ""

BEGIN SEQUENCE

cQryInc := "SELECT ZZE_ID, ZZE_FILIAL, ZZE_GERACA, ZZE_EMISSA, ZZE_TPOP, ZZE_TPMOV, ZZE_CODPA, ZZE_COD, ZZE_LOTECT, ZZE_DTVALI, "+CRLF
cQryInc += "		ZZE_QUANT, ZZE_QTDPCS, ZZE_QTDCXS, ZZE_LOCAL, ZZE_OPTAUR,ZZE_CHAVEU, ZZE.R_E_C_N_O_ RECNO "+CRLF
cQryInc += "FROM "+RetSqlName("ZZE")+" ZZE "+CRLF
cQryInc += "WHERE ZZE.D_E_L_E_T_ = ' ' "+CRLF
cQryInc += "	AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF

If _cstatus == ' '
	cQryInc += "	AND (ZZE_STATUS = ' ' OR ZZE_STATUS = 'X') "+CRLF
Else
	cQryInc += "	AND (ZZE_STATUS = '" + _cstatus + "') "+CRLF
Endif

cQryInc += "	AND ZZE_CANCEL = ' ' "+CRLF
cQryInc += "    AND R_E_C_N_O_ <= " + alltrim(str(_nlast))
cQryInc += "	AND INSTR('"+cMovReq+cMovDev+"/XX',ZZE_TPMOV) > 0 "+CRLF
cQryInc += "ORDER BY ZZE_TPMOV DESC, ZZE_OPTAUR,ZZE_CODPA,ZZE_COD,ZZE_ID "+CRLF 

If Select(_carealoc) > 0
	(_carealoc)->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryInc), _carealoc,.T.,.F.)
dbSelectArea(_carealoc)
(_carealoc)->(DbGoTop())

cCodPA	 := (_carealoc)->ZZE_CODPA
cOPTaura := (_carealoc)->ZZE_OPTAUR
_cultimo	:= (_carealoc)->ZZE_FILIAL+(_carealoc)->ZZE_TPMOV+(_carealoc)->ZZE_OPTAUR+(_carealoc)->ZZE_CODPA+(_carealoc)->ZZE_COD
	
If (_carealoc)->(!Eof())

	_ntot := 1

	While (_carealoc)->(!Eof())
		If _cultimo != (_carealoc)->ZZE_FILIAL+(_carealoc)->ZZE_TPMOV+(_carealoc)->ZZE_OPTAUR+(_carealoc)->ZZE_CODPA+(_carealoc)->ZZE_COD
			_ntot++
			_cultimo	:= (_carealoc)->ZZE_FILIAL+(_carealoc)->ZZE_TPMOV+(_carealoc)->ZZE_OPTAUR+(_carealoc)->ZZE_CODPA+(_carealoc)->ZZE_COD
		Endif
		(_carealoc)->(DbSkip())	
	Enddo

	(_carealoc)->(DbGoTop())

Endif

While (_carealoc)->(!Eof()) .and. _lretloc

	BEGIN TRANSACTION

	aRotThread	:= {}

	While !(_carealoc)->( eof() ) .And. Len( aRotThread  ) < 1 .and. _lretloc
				
		_nni++
		_coptaura := alltrim((_carealoc)->ZZE_OPTAUR)
		_ccodpa := alltrim((_carealoc)->ZZE_CODPA)
		_cchaveu := (_carealoc)->ZZE_CHAVEU
		_nrecno := (_carealoc)->RECNO

		U_MFCONOUT('Executando movimento interno para ' + _coptaura + "/" + _ccodpa + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

		cTpOP	:= (_carealoc)->ZZE_TPOP
		cCodPA	 := Stuff( Space(TamSX3("B1_COD")[1])     , 1 , Len((_carealoc)->ZZE_CODPA) , (_carealoc)->ZZE_CODPA )
		cOPTaura := Stuff( Space(TamSX3("C2_ZOPTAUR")[1]) , 1 , Len((_carealoc)->ZZE_OPTAUR), (_carealoc)->ZZE_OPTAUR )
		SC2->( dbOrderNickName("OPTAURA") )
		cChave	:= (_carealoc)->ZZE_FILIAL+cOPTaura+cCodPA

		//Se não achar a OP cria agora
		If !(SC2->( dbSeek( cChave ) ))

			U_MGFTP02Z((_carealoc)->ZZE_FILIAL,coptaura,cCodPA,0.01,(_carealoc)->ZZE_EMISSA,(_carealoc)->ZZE_TPOP)
			aRotThread := {}

		Endif

		cCodPA	 := Stuff( Space(TamSX3("B1_COD")[1])     , 1 , Len((_carealoc)->ZZE_CODPA) , (_carealoc)->ZZE_CODPA )
		cOPTaura := Stuff( Space(TamSX3("C2_ZOPTAUR")[1]) , 1 , Len((_carealoc)->ZZE_OPTAUR), (_carealoc)->ZZE_OPTAUR )

		SC2->( dbOrderNickName("OPTAURA") )
		cChave	:= (_carealoc)->ZZE_FILIAL+cOPTaura+cCodPA
		
		If SC2->( dbSeek( cChave ) )

			If !Empty( SC2->C2_DATRF )
				RecLock("SC2",.F.)
				SC2->C2_DATRF	:= CTOD("")
				SC2->( msUnlock() )
			EndIf

			If SC2->C2_PRODUTO == cCodPA
	
				SB1->( dbSeek( xFilial("SB1")+(_carealoc)->ZZE_COD ) )

				If !Empty( (_carealoc)->ZZE_LOCAL )
					cCodLoc	:= Stuff( Space(TamSX3("ZZE_LOCAL")[1]) , 1 , Len((_carealoc)->ZZE_LOCAL) , (_carealoc)->ZZE_LOCAL )
				Else
					cCodLoc	:= SB1->B1_LOCPAD
				EndIf

				cNumOrd	:= SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )
				cNumDoc	:= MGFTP0202()

				If (_carealoc)->ZZE_TPMOV $ cMovDev
					IF Alltrim((_carealoc)->ZZE_TPMOV) == '05'
						cTM := cTMDev2
					Else
						cTM := cTMDev
					EndIF
				Else
					cTM := cTMReq
				EndIf

				cFilAnt		:= (_carealoc)->ZZE_FILIAL
				dDataBase	:= STOD( (_carealoc)->ZZE_EMISSAO )

				aRotAuto	:= {}

				_nquant := 0
				_nqtdpcs := 0
				_nqtdcxs := 0
				_cultimo := (_carealoc)->ZZE_FILIAL+(_carealoc)->ZZE_TPMOV+(_carealoc)->ZZE_OPTAUR+(_carealoc)->ZZE_CODPA+(_carealoc)->ZZE_COD
				_cfilial := (_carealoc)->ZZE_FILIAL
				_clocal := (_carealoc)->ZZE_LOCAL  
				_demissao := STOD((_carealoc)->ZZE_EMISSA)
				_ctpop := (_carealoc)->ZZE_TPOP
				_coptaura := (_carealoc)->ZZE_OPTAUR
				_ctpmov := (_carealoc)->ZZE_TPMOV
				_ccodpa := (_carealoc)->ZZE_CODPA
				
				//Busca registros seguintes para aglutinar em uma D3
				Do while (_carealoc)->( !eof()) .and. (_carealoc)->ZZE_FILIAL+(_carealoc)->ZZE_TPMOV+(_carealoc)->ZZE_OPTAUR+(_carealoc)->ZZE_CODPA+(_carealoc)->ZZE_COD == _cultimo

					_nquant += (_carealoc)->ZZE_QUANT
					_nqtdpcs += (_carealoc)->ZZE_QTDPCS
					_nqtdcxs += (_carealoc)->ZZE_QTDCXS

					//Grava mesma chave de aglutinação em todos os registros
					ZZE->(Dbgoto((_carealoc)->RECNO))
					Reclock("ZZE",.F.)
					ZZE->ZZE_CHAVEA := _cchaveu
					ZZE->(Msunlock())

					(_carealoc)->( dbSkip() )

				Enddo
	

				aAdd( aRotAuto ,	{"D3_FILIAL"	, cFilAnt						,NIL} )
				aAdd( aRotAuto ,	{"D3_TM"		, cTM							,NIL} )
				aAdd( aRotAuto ,	{"D3_COD"		, SB1->B1_COD					,NIL} )
				aAdd( aRotAuto ,	{"D3_QUANT"		, _nquant		,NIL} )
				aAdd( aRotAuto ,	{"D3_ZQTDPCS"	, _nqtdpcs		,NIL} )
				aAdd( aRotAuto ,	{"D3_ZQTDCXS"	, _nqtdcxs		,NIL} )
				aAdd( aRotAuto ,	{"D3_OP"		, cNumOrd						,NIL} )
				aAdd( aRotAuto ,	{"D3_LOCAL"		, cCodLoc						,NIL} )
				aAdd( aRotAuto ,	{"D3_DOC"		, cNumDoc						,NIL} )
				aAdd( aRotAuto ,	{"D3_PARCTOT"	, "P"							,NIL} )
				aAdd( aRotAuto ,	{"D3_EMISSAO"	, _demissao,NIL} )
				aAdd( aRotAuto ,	{"D3_ZTIPO"		, _ctpop		,NIL} )

				If SB1->B1_LOCALIZ == "S"
					aAdd( aRotAuto ,	{"D3_LOCALIZ"	, cEndPad				,NIL} )
				EndIf

				aAdd( aRotAuto , {"D3_ZOPTAUR"	, _coptaura			,NIL} )
				aAdd( aRotAuto , {'__ZTPOP'		, _ctpop			,NIL} )
				aAdd( aRotAuto , {'__ZTPMOV'	, _ctpmov			,NIL} )
				aAdd( aRotAuto , {'__ZOPTAURA'	, _coptaura			,NIL} )
				aAdd( aRotAuto , {'__ZCODPA'	, _ccodpa			,NIL} )
				aAdd( aRotAuto , {'__UUID'		, _cchaveu			,NIL} )

				aAdd( aRotAuto , {'__ZLOCAL'	, _clocal			,NIL} )

				aAdd( aRotThread , aRotAuto )

			Else

				ZZE->( dbGoTo( (_carealoc)->RECNO ) )
				
				RecLock("ZZE",.F.)
				ZZE->ZZE_STATUS	:= "2"
				ZZE->ZZE_DESCER	:= "[MGFTAP02] PA "+AllTrim(cCodPA)+" diferente do PA da OP: "+AllTrim(SC2->C2_PRODUTO)+". Chave : "+cChave
				ZZE->ZZE_DTPROC	:=  Date() 
				ZZE->ZZE_HRPROC	:= Time()
				ZZE->( msUnlock() )
	
				U_MFCONOUT('OP não localizada ' + _coptaura + "/" + _ccodpa + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

			EndIf

		Else

			ZZE->( dbGoTo( (_carealoc)->RECNO ) )
				
			RecLock("ZZE",.F.)
			ZZE->ZZE_STATUS	:= "2"
			ZZE->ZZE_DESCER	:= "[MGFTAP02] OP não localizada. Chave : "+cChave
			ZZE->ZZE_DTPROC	:=  Date() 
			ZZE->ZZE_HRPROC	:= Time()
			ZZE->( msUnlock() )
		
			U_MFCONOUT('OP não localizada ' + _coptaura + "/" + alltrim((_carealoc)->ZZE_COD) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

		EndIf

		If _nrecno == (_carealoc)->RECNO //Se não avançou de registro faz avanço agora
			(_carealoc)->(Dbskip())
		Endif

	EndDo

	If Len( aRotThread ) > 0 .and. _lretloc

		cFunTAP		:= "U_MGFTAP05"
		cOpc		:= "1"
		aParThread	:= { " " , " " , cIdProc , "" }
	
		_lretloc := U_MGFTAP05( {cOpc ,;							//01			
								 aRotThread ,;						//02
								 aParThread[1] ,;					//03
								 aParThread[2] ,;					//04
								 aParThread[3] ,;					//05
								 aParThread[4] ,;					//06
								 _cchaveu  ,;						//07
								 _nrecno  } )						//08
		
		If _lretloc
			U_MFCONOUT('Completado movimento interno para ' + alltrim(_coptaura) + "/" + alltrim(_ccodpa) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 
		Else
			Disarmtransaction() 
			_lretloc := .F.
			U_MFCONOUT('Falha de integridade dos dados...')
		Endif
		aRotThread := {}

	EndIf

	END TRANSACTION

EndDo

dbSelectArea(_carealoc)
dbCloseArea()

END SEQUENCE


Return _lretloc

//-----------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP02J - Encerramento de Ordens de Produção (Mata250) 
@author  Atilio Amarilla
@since 08/11/2016
*/
User Function MGFTP02J()

Local _nni := 0
Local _lretloc := .T.
Local _ntot := 0
Local _carealoc := GetNextAlias()
Local aRotThread := {}

BEGIN SEQUENCE

cQryInc := "SELECT ZZE.R_E_C_N_O_ RECNO, ZZE.* "+CRLF
cQryInc += "FROM "+RetSqlName("ZZE")+" ZZE "+CRLF
cQryInc += "WHERE ZZE.D_E_L_E_T_ = ' ' "+CRLF
cQryInc += "	AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
cQryInc += "	AND ZZE_STATUS = ' ' "+CRLF
cQryInc += "	AND ZZE_ACAO = '1' "+CRLF
cQryInc += "    AND R_E_C_N_O_ <= " + alltrim(str(_nlast))
cQryInc += "	AND INSTR('"+alltrim(cEncPrd)+"',ZZE_TPMOV) > 0 "+CRLF
cQryInc += "ORDER BY RECNO "+CRLF

If Select(_carealoc) > 0
	(_carealoc)->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryInc), _carealoc,.T.,.F.)
dbSelectArea(_carealoc)
(_carealoc)->(DbGoTop())

If (_carealoc)->(!Eof())

	While (_carealoc)->(!Eof())
		_ntot++
		(_carealoc)->(Dbskip())
	Enddo

	(_carealoc)->(DbGoTop())

Endif

While (_carealoc)->(!Eof()) 

	aRotThread	:= {}
	_nni++
	_coptaura := alltrim((_carealoc)->ZZE_OPTAUR)
	_ccodpa := alltrim((_carealoc)->ZZE_CODPA)

	U_MFCONOUT('Encerrando OP ' + _coptaura + "/" + _ccodpa + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

	cCodPA	:= (_carealoc)->ZZE_CODPA
	cTpOP	:= (_carealoc)->ZZE_TPOP
	SC2->( dbOrderNickName("OPTAURA") )
	cChave	:= (_carealoc)->(ZZE_FILIAL+ZZE_OPTAUR+ZZE_CODPA)
	coptaura := (_carealoc)->ZZE_OPTAUR

	//Se não achar a OP cria agora
	If !(SC2->( dbSeek( cChave ) ))

		U_MGFTP02Z((_carealoc)->ZZE_FILIAL,coptaura,cCodPA,0.01,(_carealoc)->ZZE_EMISSA,(_carealoc)->ZZE_TPOP)
		aRotThread := {}

	Endif

 	cCodPA	:= (_carealoc)->ZZE_CODPA
	cChave	:= (_carealoc)->(ZZE_FILIAL+ZZE_OPTAUR+ZZE_CODPA)
	coptaura := (_carealoc)->ZZE_OPTAUR

	If SC2->( dbSeek( cChave ) )

		If SC2->C2_PRODUTO == cCodPA

				SB1->( dbSeek( xFilial("SB1")+cCodPa ) )
				cNumOrd	:= SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )
				cNumDoc	:= "" 
				cFilAnt		:= (_carealoc)->ZZE_FILIAL
				dDataBase	:= STOD( (_carealoc)->ZZE_EMISSAO )
				aRotAuto	:= {}

				aAdd( aRotAuto , {'C2_FILIAL'	, (_carealoc)->ZZE_FILIAL			,NIL} )
				aAdd( aRotAuto , {'C2_NUM'		, Subs(cNumOrd,1,6) 				,NIL} )
				aAdd( aRotAuto , {'C2_SEQUEN'	, Subs(cNumOrd,9,3)					,NIL} )
				aAdd( aRotAuto , {'C2_ITEM'		, Subs(cNumOrd,7,2)					,NIL} )
				aAdd( aRotAuto , {'C2_PRODUTO'	, cCodPA							,NIL} )
				aAdd( aRotAuto , {'C2_QUANT'	, (_carealoc)->ZZE_QUANT			,NIL} )
				aAdd( aRotAuto , {'__ZTPOP'		, cTPop								,NIL} )
				aAdd( aRotAuto , {'__ZTPMOV'	, (_carealoc)->ZZE_TPMOV			,NIL} )
				aAdd( aRotAuto , {'__ZNUMOP'	, cNumOrd							,NIL} )
				aAdd( aRotAuto , {'__ZDATOP'	, STOD( (_carealoc)->ZZE_GERACA )	,NIL} )
				aAdd( aRotAuto , {'__ZDATEM'	, STOD( (_carealoc)->ZZE_EMISSA )	,NIL} )

				cIdSeq	:= Soma1(cIdSeq)
				aAdd( aRotAuto , {'__ZIDSEQ'	, cIdSeq							,NIL} )

				aAdd( aRotThread , aRotAuto )

		Else

				ZZE->( dbGoTo( (_carealoc)->RECNO ) )
				
				RecLock("ZZE",.F.)
				ZZE->ZZE_STATUS	:= "2"
				ZZE->ZZE_DESCER	:= "[MGFTAP02] PA "+AllTrim(cCodPA)+" diferente do PA da OP: "+AllTrim(SC2->C2_PRODUTO)+". Chave : "+cChave
				ZZE->ZZE_DTPROC	:=  Date() 
				ZZE->ZZE_HRPROC	:= Time()
				ZZE->( msUnlock() )

				U_MFCONOUT('PA '+AllTrim(_cCodPA)+' diferente do PA da OP' + _coptaura + "/" + alltrim((_carealoc)->ZZE_COD) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

		EndIf

	Else

			ZZE->( dbGoTo( (_carealoc)->RECNO ) )
				
			RecLock("ZZE",.F.)
			ZZE->ZZE_STATUS	:= "2"
			ZZE->ZZE_DESCER	:= "[MGFTAP02] OP não localizada. Chave : "+cChave
			ZZE->ZZE_DTPROC	:=  Date() 
			ZZE->ZZE_HRPROC	:= Time()
			ZZE->( msUnlock() )

			U_MFCONOUT('OP não localizada ' + _coptaura + "/" + _ccodpa + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

	EndIf

	If Len( aRotThread ) > 0 .and. _lretloc

		cFunTAP		:= "U_MGFTAP07"
		cOpc		:= "1"
		aParThread	:= { " " , " " , cIdProc , "" }
		_lretloc := U_MGFTAP07( {cOpc ,;					//01
								aRotThread ,;				//02
								aParThread[1] ,;			//03
								aParThread[2] ,;			//04
								aParThread[3] ,;			//05
								(_carealoc)->ZZE_CHAVEU,;	//06
								(_carealoc)->RECNO})		//07		
		
		If _lretloc
			U_MFCONOUT('Encerrou OP ' + _coptaura + "/" + _ccodpa + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 
		Else
			U_MFCONOUT('Falha de integridade dos dados...')
			Disarmtransaction()
			BREAK
		Endif

		aRotThread := {}

	EndIf

	(_carealoc)->( dbSkip() )

EndDo

dbSelectArea(_carealoc)
dbCloseArea()

END SEQUENCE

Return _lretloc



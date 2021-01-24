#include "rwmake.ch"
#include "protheus.ch"

#define CRLF chr(13) + chr(10)

/*/
=============================================================================
{Protheus.doc} MGFFINC2
Baixa do CP de TAxa referente a Gilrat

@description
Após a Devolução de uma NFE com Gilrat calculado (D2_CONTSOC > 0)
Efetua a leitura por itens (SD2) pois nota de Devolução pode conter mais notas de origem

@author Renato Junior , Bandeira
@since 02/12/2020
@type Function
@table
SE2 - Ttulos a Pagar
@param
@return
@menu
@history
/*/
User Function MGFFINC2()
	Local aArea     := GetArea()
	Local aSE2      := SE2->( GetArea() )
	Local aSD2      := SD2->( GetArea() )
	Local aRecSD2	:= {}
	Local nPos      := 0
	Local _cParInss :=  ""
	Local _cMsgSE2  := ""
    Local nI        :=  0

	If SF2->F2_TIPO = 'D' .AND. SF2->F2_CONTSOC > 0     //Verifica se é devolução de compras e se tem GILRAT, adiciona em array
		aRecSD2	:= {}
		_cKeySF2    := SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
		_cParInss :=  SuperGetMV( "MV_FORINSS" , .T. /*lHelp*/, "015197")    + "00"
		SD2->( dbSetOrder(3) ) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		SD2->( dbSeek( _cKeySF2 ) )
		While !SD2->( eof() )   .And. 	SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == _cKeySF2
			If SD2->D2_VALFUN   > 0
				nPos := aScan( aRecSD2 , { |x| x[1]== _cParInss+SD2->(D2_SERIORI+D2_NFORI) } )
				If nPos == 0
					aAdd( aRecSD2 , { _cParInss+SD2->(D2_SERIORI+D2_NFORI) , SD2->D2_VALFUN } )
				Else
					aRecSD2[nPos,2] += SD2->D2_VALFUN
				EndIf
			Endif
			SD2->( dbSkip() )
		EndDo
		// Efetua a baixa se encontrar CP com saldo > 0
		If Len( aRecSD2 )   > 0
			_cMotBaixa :=  SuperGetMV( "MGF_FINC2A" , .T. /*lHelp*/, "CCC")
			Begin Transaction
				SE2->( dbSetOrder(6) ) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
				_cMsgSE2 := ""
				For nI := 1 to Len( aRecSD2 )
					If SE2->( dbSeek(xFilial("SE2")+aRecSD2[nI,1]) )
						// Pré-validações
						nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,1,,,SE2->E2_LOJA,,0/*nTxMoeda*/)
						If nSaldo	> 0
							_cMsgSE2 += "CP TX com saldo (For/Loja/Pref/Num:"+aRecSD2[nI,1]+")|"+CRLF
						Else
							If ! FINC02BXCP(nSaldo, _cMotBaixa)
								_cMsgSE2 += "Erro na rotina automatica da baixa (For/Loja/Pref/Num:"+aRecSD2[nI,1]+")|"+CRLF
							Endif
							If  aRecSD2[nI,2]  <>   SE2->E2_VALOR
								_cMsgSE2 += "Vlr do CP TX diferente da devolução (For/Loja/Pref/Num:"+aRecSD2[nI,1]+")|"+CRLF
							EndIf
						Endif
					EndIf
				Next nI
				RestArea(aSE2)
			End Transaction
			If ! empty(_cMsgSE2)
				Help( ,, _cMsgSE2,, "Atenção, inconsistência(s) encontrada(s)", 1, 0 )
			Endif
		Endif
		RestArea(aSD2)
	EndIf
	RestArea(aArea)
Return Nil


/*/
	======================================================================================
	{Protheus.doc} FINC02BXCP()
	Rotina automatica da Baixa do CP de TX

	@author Renato Junior , Bandeira
	@since 02/12/2020
	@type Function
	@param
	XValBaixa - valor da baixa
	XcMotBaixa
	@return
	_Lret - Se processou a baixa pela rotina automatica
/*/
Static Function FINC02BXCP(XValBaixa, XcMotBaixa)
	Local _lRet         :=  .T.
	Local aBaixa        := {}    //³Monta array com os dados da baixa a pagar do título³
	Local cHistBaixa    := "BX.Auto.GILRAT"
	Private lMsErroAuto := .F.

	AADD(aBaixa, {"E2_FILIAL"   , SE2->E2_FILIAL    , Nil})
	AADD(aBaixa, {"E2_PREFIXO"  , SE2->E2_PREFIXO   , Nil})
	AADD(aBaixa, {"E2_NUM"      , SE2->E2_NUM       , Nil})
	AADD(aBaixa, {"E2_PARCELA"  , SE2->E2_PARCELA   , Nil})
	AADD(aBaixa, {"E2_TIPO"     , SE2->E2_TIPO      , Nil})
	AADD(aBaixa, {"E2_FORNECE"  , SE2->E2_FORNECE   , Nil})
	AADD(aBaixa, {"E2_LOJA"     , SE2->E2_LOJA      , Nil})
	AADD(aBaixa, {"AUTMOTBX"    , XcMotBaixa        , Nil})
	AADD(aBaixa, {"AUTDTBAIXA"  , dDataBase , Nil})
	AADD(aBaixa, {"AUTHIST"     , cHistBaixa , Nil})
	AADD(aBaixa, {"AUTVLRPG"    , XValBaixa , Nil})
	MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 3)
	If lMsErroAuto
		MOSTRAERRO()
		_lRet :=  .F.
	EndIf
Return  _lRet

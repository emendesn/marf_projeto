#include "protheus.ch"

/*
=====================================================================================
Programa.:              MGFCOM56
Autor....:              Gresele
Data.....:              Nov/2017
Descricao / Objetivo:   Funcao chamada pelo ponto de entrada MA125BUT
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MGFCOM56()

Local aButtons := {}

If IsInCallStack("U_MGFCOM55") .or. (IsInCallStack("A125Contrato") .and. Altera)
	If IsInCallStack("U_MGFCOM55")
		aAdd(aButtons,{ "PESQUISA"   , { || GdSeek(oGetDados,OemtoAnsi("Busca produto no Contrato"),,,.T.) }, OemtoAnsi("Busca produto no Contrato"), OemtoAnsi("Busca") } )
	Endif	
	aAdd(aButtons,{ "S4WB005N"   , { || Com56Campos() }, OemtoAnsi("Atualiza Campos"), OemtoAnsi("Atualiza Campos") } )
Endif	
	
Return(aButtons)


Static Function Com56Campos()

Processa( {|| Com56AtuCampos() },"Aguarde...", "Atualizando itens...",.F. )

Return()


Static Function Com56AtuCampos()

Local aRet := {}
Local aParambox := {}
Local nCnt := 0
Local nPosQuant := aScan(aHeader,{|x| Alltrim(x[2])=="C3_QUANT"})
Local nPosVUnit := aScan(aHeader,{|x| Alltrim(x[2])=="C3_PRECO"})
Local nPosVTot := aScan(aHeader,{|x| Alltrim(x[2])=="C3_TOTAL"})
Local nPosDtIni := aScan(aHeader,{|x| Alltrim(x[2])=="C3_DATPRI"})
Local nPosDtFim := aScan(aHeader,{|x| Alltrim(x[2])=="C3_DATPRF"})
Local nPosOper := aScan(aHeader,{|x| Alltrim(x[2])=="C3_ZOPER"})
Local nPosTes := aScan(aHeader,{|x| Alltrim(x[2])=="C3_ZTES"})
//Local nPosQuantI := aScan(aHeader,{|x| Alltrim(x[2])=="C3_QTIMP"})
Local nPosProd := aScan(aHeader,{|x| Alltrim(x[2])=="C3_PRODUTO"})
Local nPosItem := aScan(aHeader,{|x| Alltrim(x[2])=="C3_ITEM"})

AAdd(aParamBox, {1, "Quantidade"		, 0																															, "@E 999,999,999.999"			,"Positivo()"							, 		,	, 070	, .F.	})
AAdd(aParamBox, {1, "Data Inicio"		, CToD(Space(8))																											, 								, 										, 		,	, 070	, .F.	})
AAdd(aParamBox, {1, "Data Fim"			, CToD(Space(8))																											, 								, 										, 		,	, 070	, .F.	})
AAdd(aParamBox, {1, "Tipo de Operacao"	, Space(tamSx3("FM_TIPO")[1]) 																								, "@!"							,'Vazio() .or. ExistCpo("SX5","DJ"+mv_par04) .and. mv_par04 <= "99"'		, "DJ" 	,	, 070	, .F.	})

If ParamBox(aParambox, "Atualiza Campos Contrato"	, @aRet, {|| VldData()} , , .T. /*lCentered*/, 0, 0, , , .F. /*lCanSave*/, .F. /*lUserSave*/)
	ProcRegua(Len(aCols))
	For nCnt:=1 To Len(aCols)
		IncProc()
		If !Empty(mv_par01)
			aCols[nCnt][nPosQuant] := mv_par01
			aCols[nCnt][nPosVTot] := NoRound(aCols[nCnt][nPosQuant]*aCols[nCnt][nPosVUnit],TamSX3("C3_TOTAL")[2])
    		// prepara variaveis para a A125Quant 
			n := nCnt
			M->C3_QUANT := mv_par01
			A125Quant(mv_par01)
			MaFisRef("IT_QUANT","MT120",mv_par01)
			MaFisRef("IT_VALMERC","MT120",aCols[nCnt][nPosVTot])
			//aCols[nCnt][nPosQuantI] := mv_par01
		Endif	
		If !Empty(mv_par02)
			aCols[nCnt][nPosDtIni] := mv_par02
		Endif	
		If !Empty(mv_par03)
			aCols[nCnt][nPosDtFim] := mv_par03
		Endif	
		If !Empty(mv_par04)
			aCols[nCnt][nPosOper] := mv_par04
			aCols[nCnt][nPosTes] := MaTesInt(1,mv_par04,cA125Forn,cA125Loj,"F",aCols[nCnt][nPosProd])
			If Empty(aCols[nCnt][nPosTes])
				APMsgAlert("Nao  foi encontrado o 'TES' para o item: "+aCols[nCnt][nPosItem]+CRLF+;
				"Verifique se existe regra de 'TES inteligente' cadastrada para este Tipo de Operacao.")
			Endif	
		Endif	
	Next
	If Type("oGetDados") != "U"
		oGetDados:oBrowse:Refresh()
	Endif	
	Eval(bRefresh)
Endif

Return()


Static Function VldData()

Local lRet := .T.
Local nPosDtIni := aScan(aHeader,{|x| Alltrim(x[2])=="C3_DATPRI"})
Local nPosDtFim := aScan(aHeader,{|x| Alltrim(x[2])=="C3_DATPRF"})
Local nPosItem := aScan(aHeader,{|x| Alltrim(x[2])=="C3_ITEM"})

If (Empty(mv_par02) .and. !Empty(mv_par03)) .or. (!Empty(mv_par02) .and. Empty(mv_par03)) 
	If !APMsgYesNo("Foi informado apenas uma data para a atualizacao."+CRLF+;
	"Deseja continuar ?")
		lRet := .F.
	Endif
Endif		

If lRet
	If !Empty(mv_par02) .and. !Empty(mv_par03)
		If mv_par02 > mv_par03
			lRet := .F.
			APMsgStop("Data inicial maior que Data final.")
		Endif	
	Endif
Endif

If lRet
	If !Empty(mv_par02) .or. !Empty(mv_par03)
		// verifica datas informadas nos parametros com relacao as datas dos itens
		aEval(aCols,{|x,y| IIf((lRet .and. !Empty(mv_par03) .and. !aCols[y][Len(aCols[y])] .and. aCols[y][nPosDtIni]>mv_par03),(lRet:=.F.,APMsgStop("Data final do parametro menor que a Data inicial do item: "+aCols[y][nPosItem])),IIf((lRet .and. !Empty(mv_par02) .and. !aCols[y][Len(aCols[y])] .and. aCols[y][nPosDtFim]<mv_par02),(lRet:=.F.,APMsgStop("Data inicial do parametro maior que a Data final do item: "+aCols[y][nPosItem])),Nil)) })
	Endif
Endif		

If lRet		
	If !Empty(mv_par01) .or. !Empty(mv_par02) .or. !Empty(mv_par03) .or. !Empty(mv_par04)
		If !APMsgYesNo("Esta acao ira alterar todos os itens do Contrato."+CRLF+;
		"Deseja continuar ?")
			lRet := .F.
		Endif
	Else
		lRet := .F.	
	Endif
Endif		
			
Return(lRet)



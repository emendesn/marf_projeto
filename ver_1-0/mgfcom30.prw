#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFCOM30
@author Joni Lima do Carmo - TOTVS
@since 24/05/2017
/*/
//-------------------------------------------------------------------
User Function MGFCOM30()

	Local cPerg := "XMGF3001"

	If Pergunte(cPerg,.T.)

		If Upper(Alltrim(FUNNAME())) == 'MATA121'
			xAtua120(MV_PAR01)
		ElseIf Upper(Alltrim(FUNNAME())) == 'MATA150'
			xAtua150(MV_PAR01)
		EndIf

	EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} xAtua120
@author Joni Lima do Carmo - TOTVS
@since 24/05/2017
@description Função para Atualizar Valores com Desconto no Pedido de Compra Mata120
/*/
//-------------------------------------------------------------------
Static Function xAtua120(nValDes)

	Local ni		:= 0
	Local nLinha	:= n
	Local nPosValUn	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C7_PRECO' })
	Local nPosTotal	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C7_TOTAL' })
	Local nPosQtde	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C7_QUANT' })

	Local nNewVal	:= 0

	For ni := 1 to Len(aCols)
		
		If Empty( GDFieldGet("C7_ZPRCORI",ni) )
			GdFieldPut( "C7_ZPRCORI" , GDFieldGet("C7_PRECO",ni) , ni )
		EndIf
		
		//GdFieldPut( "C7_PRECO"	, ( 1 - ( nValDes / 100 ) ) * GDFieldGet("C7_ZPRCORI",ni) , ni )
		
		n := ni

		//Calcula Nova Valor
		//nNewVal	:= Round(aCols[ni, nPosValUn] - ( ( nValDes / 100 ) * aCols[ni, nPosValUn]), TamSX3("C7_PRECO")[2])
		nNewVal	:= Round( GDFieldGet("C7_ZPRCORI") - ( ( nValDes / 100 ) * GDFieldGet("C7_ZPRCORI") ) , TamSX3("C7_PRECO")[2])

		If MaFisFound("IT",N)
			MaFisRef("IT_PRCUNI","MT120",nNewVal)
			If ExistTrigger("C7_PRECO")
				RunTrigger(2,N)
			EndIf
		EndIf

	Next ni
	
	n	:= nLinha

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} xAtua150
@author Joni Lima do Carmo - TOTVS
@since 24/05/2017
@description Função para Atualizar Valores com Desconto na atualização da Cotação Mata150
/*/
//-------------------------------------------------------------------
Static Function xAtua150(nPrcRepl)

	Local ni		:= 0
	Local nx		:= 0
	Local nLinha	:= n
	Local nPosPreco	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C8_PRECO' })
	Local nPosTotal	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C8_TOTAL' })
	Local nPosQuant	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C8_QUANT' })
	Local nNewVal	:= 0

	For nX :=1 to Len(aCols)

		If Empty( GDFieldGet("C8_ZPRCORI",nX) )
			GdFieldPut( "C8_ZPRCORI"	, GDFieldGet("C8_PRECO",nX) , nX )
		EndIf
		
		//GdFieldPut( "C8_PRECO"	, ( 1 - ( nValDes / 100 ) ) * GDFieldGet("C8_ZPRCORI",nX) , nX )

		N := nX
		
		//nNewVal	:= Round(aCols[nX][nPosPreco] - ( ( nPrcRepl / 100 ) * aCols[nX][nPosPreco]), TamSX3("C8_PRECO")[2])
		nNewVal	:= Round( GDFieldGet("C8_ZPRCORI") - ( ( nPrcRepl / 100 ) * GDFieldGet("C8_ZPRCORI") ), TamSX3("C8_PRECO")[2])

		aCols[nX][nPosPreco]:= nNewVal

		If MaFisFound("IT",nX)
			MaFisRef("IT_PRCUNI","MT150",nPrcRepl)
		EndIf

		If Abs(aCols[nX][nPosTotal]-NoRound(aCols[nX][nPosPreco]*aCols[nX][nPosQuant],TamSx3("C8_TOTAL")[2]))<>0.09
			aCols[nX][nPosTotal] := NoRound(aCols[nX][nPosPreco]*aCols[nX][nPosQuant],TamSx3("C8_TOTAL")[2])
			If MaFisFound("IT",nX)
				MaFisRef("IT_VALMERC","MT150",aCols[nX][nPosTotal])
			EndIf
		EndIf	

		If ExistTrigger("C8_PRECO")
			RunTrigger(2,nX)
		EndIf
		
	Next nX
	
	n	:= nLinha

	Eval(bRefresh)
	Eval(bGDRefresh)

Return
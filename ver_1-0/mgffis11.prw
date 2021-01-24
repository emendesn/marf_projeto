#include 'protheus.ch'
#include 'fwmvcdef.ch'

/*
=====================================================================================
Programa.:              MGFFIS11
Autor....:              Gustavo Ananias Afonso
Data.....:              10/11/2016
Descricao / Objetivo:   Ajuste Fiscal
Doc. Origem:            GAP FIS040
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Manutenção dos Livros Fiscais - NF Entrada
=====================================================================================
*/
User Function MGFFIS11()
	local aArea		:= getArea()
	local aAreaSF3	:= SF3->(getArea())
	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	DBSelectArea("SF3")
	SF3->(DBGoTop())
	SF3->(DBSetOrder(4)) // 4 - F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE

	if SF3->( DBSeek( xFilial("SF3") + SF1->(F1_FORNECE + F1_LOJA + F1_DOC + F1_SERIE ) ) )
		//UPDATE/ exclusao precisa estar possicionado
		fwExecView("Alteração", "MGFFIS08", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)//"AlteraÃ§Ã£o"
	else
		msgAlert("Livro Fiscal não encontrado!")
	endif

	SF3->(DBCloseArea())

	restArea(aAreaSF3)
	restArea(aArea)
return

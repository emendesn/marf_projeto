// ponto de entrada para adicionar campos na tela de analise da cotacao
User Function MT161CPO()

Local aPropostas := PARAMIXB[1] // Array com os dados das propostas dos Fornecedores
Local aItens := PARAMIXB[2] // Array com os dados da grid "Produtos"
//Local aCampos := {"C8_PRECO","C8_ALIIPI","C8_ZPERST","C8_ZMARCA"} // Array com os campos adicionados na grid "Item da Proposta"
Local aCampos := {"C8_ALIIPI","C8_ZPERST","C8_ZMARCA"} // Array com os campos adicionados na grid "Item da Proposta" Teste para trazer o campo C8_PRECO ao lado do campo C8_TOTAL
Local aCposProd := {} // Array com os campos adicionados na grid "Produtos"
Local aRetorno := {}
Local nX := 0
Local nY := 0
Local nZ := 0
Local nCount := 0
Local nW := 0

For nX := 1 To Len(aPropostas)
	For nY := 1 To Len(aPropostas[nX])
		For nZ := 1 To Len(aPropostas[nX][nY][2])
			nCount++
			SC8->(dbGoto(aPropostas[nX][nY][2][nZ][9]))
			If SC8->(Recno()) == aPropostas[nX][nY][2][nZ][9]
				For nW := 1 To Len(aCampos)
					AADD(aPropostas[nX][nY][2][nZ],&("SC8->"+aCampos[nW]))
				Next	
			Else
				For nW := 1 To Len(aCampos)
					AADD(aPropostas[nX][nY][2][nZ],"")
				Next	
			Endif	
		next nZ
	Next nY
Next nX
For nX := 1 To Len(aItens)
	AADD(aItens[nX],nX)
Next nX
AADD(aRetorno,aPropostas)
AADD(aRetorno,aCampos)
AADD(aRetorno,aItens)
AADD(aRetorno,aCposProd)

Return aRetorno
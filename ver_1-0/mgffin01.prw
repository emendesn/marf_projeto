#include "rwmake.ch"

//Programa    ³CNABxFUN ³ Biblioteca de Funcoes genericas utilizadas nos Cnabs          º±±
// Observacoes ³ Aqui devem ser incluidas apenas as funcoes que serao utilizadas         º±±
//            ³ nos processos de CNAB receber ou pagar.                                 º±±
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGAR001  ºAutor                       º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera as informacoes para o cnab a pagar o banco do brasil. º±±
±±º          ³                      º±±
±±º                                                                       º±±
±±ºParametros:                                                            º±±
±±º                                                                       º±±
±±º   1 - Retorna codigo agencia (SA6)                                    º±±
±±º   2 - Retorna digito do codigo agencia (SA6)                          º±±
±±º   3 - Retorna conta corrente (SA6)                                    º±±
±±º   4 - Retorna digito da conta corrente (SA6)                          º±±
±±º   5 - Retorna o endereco da empresa (SM0)                             º±±
±±º   6 - Retorna o numero do endereco da empresa (SM0)                   º±±
±±º   7 - Retorna o codigo da camara centralizadora                       º±±
±±º   8 - Retorna o valor do pagamento                                    º±±
±±º   9 - Retorna o valor do desconto                                     º±±
±±º  10 - Retorna o valor dos juros                                       º±±
±±º  11 - Retorna o nome do contribuinte (segmento N)                     º±±
±±º  12 - Retorna os detalhes do segmento N (depende do tipo do tributo)  º±±
±±º  13 - Retorna o tipo de inscricao do favorecido                       º±±
±±º  14 - Retorna o CNPJ do favorecido                                    º±±
±±º  15 - Retorna o digito da agencia do fornecedor (SA2)                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Pagar001(_cOpcao)

	Local _cReturn := ""
	Local _Posicao := 0
	Local _TtAbat  := 0.00
	Local _Juros   := 0.00
	Local _Liqui   := 0.00
	Local _Dig1    := ""
	Local _Dig2    := ""
	Local _Dig3    := ""
	Local _Dig4    := ""
	Local _Retdig  := " "
	Local _Multa
	Local _Resul
	Local _Resto
	Local _Digito

	If _cOpcao == "1"  // Obtem o numero da agencia da empresa (SA6)

		_cReturn := Strzero(Val(Substr(SA6->A6_AGENCIA,1,Len(Alltrim(SA6->A6_AGENCIA))-1)),5,0)

	ElseIf _cOpcao =="2"  // Obtem o digito da agencia da empresa (SA6)

		_cReturn := Substr(SA6->A6_AGENCIA,Len(Alltrim(SA6->A6_AGENCIA)),1)

	ElseIf _cOpcao == "3"    // Obtem o numero da conta corrente da empresa (SA6)

		_cReturn  := Strzero(Val(Substr(SA6->A6_NUMCON,1,Len(Alltrim(SA6->A6_NUMCON))-1)),12,0)

	elseIf _cOpcao =="4"     // Obtem o digito da conta corrente da empresa (SA6)

		_cReturn := Substr(SA6->A6_NUMCON,Len(Alltrim(SA6->A6_NUMCON)),1)

	ElseIf _cOpcao =="5"   // Obtem o endereco da empresa

		_posicao   := at(",",sm0->m0_endcob)
		if _posicao == 0
			_cReturn := sm0->m0_endcob
		else
			_cReturn := substr(sm0->m0_endcob,1,(_posicao-1))
		endif

	ElseIf _cOpcao == "6"  // Obtem Numero do endereco da empresa (SM0)
		_posicao   := at(",",sm0->m0_endcob)
		if _posicao == 0
			_cReturn := "0"
		else
			_cReturn := substr(sm0->m0_endcob,(_posicao+1),30)
		endif
		_cReturn := alltrim(_cReturn)
		_cReturn := StrZero(val(_cReturn),5,0)

	ElseIf _cOpcao == "7"   // Obtem codigo da camara centralizadora
		
		If SEA->EA_MODELO == "03"
			_cReturn := "700"
		ElseIf SEA->EA_MODELO $ "41|43"
			_cReturn := "018"
		ElseIf SEA->EA_MODELO $ "01|10"
			_cReturn := "000"
		Else
			_cReturn := ""
		EndIf

	Elseif _cOpcao == "8"   // Obtem Valor Pagamento

		//--- Funcao SOMAABAT totaliza todos os titulos com e2_tipo AB- relacionado ao
		//---        titulo do parametro
		_TtAbat  := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
		_TtAbat  += SE2->E2_SDDECRE 
		_TtAbat  += SE2->E2_XDESCO
		_TtAbat  += SE2->E2_ZTXBOL 
		_Juros   := (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_SDACRES + SE2->E2_XJUROS + SE2->E2_XMULTA + SE2->E2_ZJURBOL)
		_Liqui   := (SE2->E2_SALDO-_TtAbat+_Juros)

		_cReturn := Left(StrZero((_Liqui*1000),16),15)

	ElseIf _cOpcao == "9"   // Obtem Valor do Desconto

		_TtAbat  := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
		_TtAbat  += SE2->E2_SDDECRE

		_cReturn := Left(StrZero((_TtAbat*1000),16),15)

	ElseIf _cOpcao == "10"   // Obtem Valor de Juros

		_Juros   := (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_SDACRES)
		_cReturn := Left(StrZero((_Juros*1000),16),15)

	ElseIf _cOpcao == "11"   // Nome do Contribuinte

		If !Empty(SE2->E2_XCNPJ)
			_cReturn := Subs(SE2->E2_XCONTR,1,30)
			If Empty(_cReturn)
				MsgAlert('Nome do Contribuinte não informado para a DARF - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
			EndIf
		Else
			_cReturn := Subs(SM0->M0_NOMECOM,1,30)
		EndIf

	ElseIf _cOpcao == "12"   // Detalhes Segmento N

		//--- Mensagem ALERTA que está sem periodo de apuração
		If Empty(se2->e2_xapur)

			MsgAlert('Tributo sem Periodo de Apuracao. Informe o campo Per.Apuracao no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

		EndIf 


		//--- Codigo Receita do Tributo - Posicao 111 a 116
		_cReturn := If(!Empty(SE2->E2_XINSS),Strzero(Val(SE2->E2_XINSS),6),Strzero(Val(SE2->E2_CODRET),6))

		//--- Tipo de Identificacao do Contribuinte - Posicao 117 a 118
		//--- CNPJ (1) /  CPF (2)
		If !Empty(SE2->E2_XCNPJ)
			_cReturn += Iif (len(alltrim(SE2->E2_XCNPJ))>11,"01","02")
		Else
			_cReturn += "01"
		EndIf

		//--- Identificacao do Contribuinte - Posicao 119 a 132
		//--- CNPJ/CPF do Contribuinte
		If !Empty(SE2->E2_XCNPJ)
			_cReturn += Strzero(Val(SE2->E2_XCNPJ),14)
		Else
			_cReturn += Subs(SM0->M0_CGC,1,14)
		EndIf

		//--- Identificacao do Tributo - Posicao 133 a 134
		//--- 16 - DARF Normal
		//--- 17 - GPS
		//--- 22 - GARE SP


		_cReturn += SEA->EA_MODELO

		//--- GPS
		If SEA->EA_MODELO == "17" //--- GPS

			//--- Competencia (Mes/Ano) - Posicao 135 a 140  Formato MMAAAA
			_cReturn += Strzero(Month(SE2->E2_XAPUR),2)+Strzero(Year(SE2->E2_XAPUR),4)

			//--- Valor do Tributo - Posicao 141 a 155
			_cReturn += Strzero((SE2->E2_SALDO-SE2->E2_XVLENT)*100,15)

			//--- Valor Outras Entidades - Posicao 156 a 170
			_cReturn += Strzero(SE2->E2_XVLENT*100,15)

			//--- Atualizacao Monetaria - Posicao 171 a 185
			_cReturn += Strzero(SE2->E2_SDACRES*100,15)

			//--- Mensagem ALERTA que está sem Codigo da Receita
			If Empty(se2->e2_codins)

				MsgAlert('Tributo sem Codigo Receita. Informe o campo Cod.Ret INSS no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

			EndIf

			//--- DARF Normal
		ElseIf SEA->EA_MODELO == "16" //--- DARF Normal

			//--- Periodo de Apuracao - Posicao 135 a 142  Formato DDMMAAAA
			_cReturn += Gravadata(SE2->E2_XAPUR,.F.,5)

			//--- Referencia - Posicao 143 a 159
			_cReturn += Repl("0",17)

			//--- Valor Principal - Posicao 160 a 174
			_cReturn += Strzero(SE2->E2_SALDO*100,15)

			//--- Valor da Multa - Posicao 175 a 189
			_cReturn += Strzero((SE2->E2_SDACRES-SE2->E2_XJUROS)*100,15)

			//--- Valor Juros/Encargos - Posicao 190 a 204
			_cReturn += Strzero(SE2->E2_XJUROS*100,15)

			//--- Data de Vencimento - Posicao 205 a 212  Formato DDMMAAAA
			_cReturn += Gravadata(SE2->E2_VENCTO,.F.,5)

			//--- GARE - SP
		ElseIf SEA->EA_MODELO == "22" //--- GARE - SP


			//--- Data de Vencimento - Posicao 135 a 142  Formato DDMMAAAA
			_cReturn += Gravadata(SE2->E2_VENCTO,.F.,5)

			// --- Inscrição Estadual - Posição 143 a 154
			_cReturn += IIf( Substr(SE2->E2_FORNECE,1,5)=="UNIAO",StrZero(Val(Substr(SM0->M0_INSC,1,12)),12),StrZero(Val(Substr(SA2->A2_INSCR,1,12)),12) )

			// --- Dívida Ativa/ Número Etiqueta  - Posição 155 a 167
			_cReturn += StrZero(Val(SE2->E2_XDIVID),13)

			// ---  Período de Referencia - Posicao 168 a 173   Formato MMAAAA
			_cReturn += SE2->E2_XAPUR

			// --- Número da Parcela / Notificação - Posição 174 a 186
			_cReturn += StrZero(Val(SE2->E2_XNUMPAR),13)

			// --- Valor da Receita - Posição 187 a 201
			_cReturn += IIf(SE2->E2_XRECEIT > 0, StrZero((SE2->E2_XRECEIT*100),13) , StrZero((SE2->E2_VALOR*100),13) )

			//--- Valor Juros/Encargos - Posicao 202 a 215
			_cReturn += Strzero(SE2->E2_XJUROS*100,12)

			//--- Valor da Multa - Posicao 216 a 229
			_cReturn += Strzero((SE2->E2_SDACRES-SE2->E2_XJUROS)*100,12) 



		EndIf

	ElseIf _cOpcao == "13"   // Obtem Tipo de Inscrição do Contribuinte

		If Empty(SA2->A2_XCGCDEP)
			_cReturn := IF(Length(Alltrim(SA2->A2_CGC))==14,"2","1")
		Else
			_cReturn := If(Length(Alltrim(SA2->A2_XCGCDEP))==14,"2","1")
		EndIf

	ElseIf _cOpcao == "14"   // Obtem CNPJ do Contribuinte

		If Empty(SA2->A2_XCGCDEP)
			_cReturn := Strzero(Val(SA2->A2_CGC),14,0)
		Else
			_cReturn := Strzero(Val(SA2->A2_XCGCDEP),14,0)
		EndIf


	ElseIf _cOpcao == "15"   // Obtem Digito do Codigo da Agencia

		//--- Vou calcular sempre o digito da agencia para o Banco Bradesco
		If SA2->A2_BANCO == "237"	// BRADESCO

			_DIG1    := SUBSTR(SA2->A2_AGENCIA,1,1)
			_DIG2    := SUBSTR(SA2->A2_AGENCIA,2,1)
			_DIG3    := SUBSTR(SA2->A2_AGENCIA,3,1)
			_DIG4    := SUBSTR(SA2->A2_AGENCIA,4,1)

			_RETDIG := " "
			_MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
			_RESUL  := INT(_MULT /11 )
			_RESTO  := INT(_MULT % 11)
			_DIGITO := 11 - _RESTO

			_RETDIG := IF( _RESTO == 0,"0",IF(_RESTO == 1,"0",ALLTRIM(STR(_DIGITO))))

			_cReturn := _RETDIG

		Else

			//--- Para os demais bancos, pega o digito da agencia que está na posicao 6 do campo A2_AGENCIA
			_cReturn := Substr(SA2->A2_AGENCIA,6,1)

		EndIf  

		_cReturn += SEA->EA_MODELO   

	ElseIf _cOpcao == "35"   // Detalhes Segmento W (FGTS)

		//--- FGTS
		If SEA->EA_MODELO == "35" //--- FGTS

			//---Codigo da Receita - Posicao 179 a 184  
			_cReturn := If(!Empty(SE2->E2_XINSS),Strzero(Val(SE2->E2_XINSS),6),Strzero(Val(SE2->E2_CODRET),6)) 

			//---Tipo de identificação do contribuinte - Posição 185 a 186 
			//--- CNPJ (1) /  CPF (2)
			If !Empty(SE2->E2_XCNPJ)
				_cReturn += Iif (len(alltrim(SE2->E2_XCNPJ))>11,"01","02")
			Else
				_cReturn += "01"
			EndIf

			//--- Identificacao do Contribuinte - Posicao 187 a 200
			//--- CNPJ/CPF do Contribuinte
			If !Empty(SE2->E2_XCNPJ)
				_cReturn += Strzero(Val(SE2->E2_XCNPJ),14)
			Else
				_cReturn += Subs(SM0->M0_CGC,1,14)
			EndIf

			//--- Campo Identificador do FGTS Posicao 201 a 216
			_cReturn +=  StrZero(Val(SE2->E2_XIDFGTS),16)

			//--- Lacre do Conectividade Social - Posicao 217 a 225
			_cReturn +=  Strzero(Val(SE2->E2_XLACRE),9)

			//--- Digito do Lacre - Posicao 226 a 227
			_cReturn += Strzero(Val (SE2->E2_XDGLACR),2)

			//--- Mensagem ALERTA que está sem Codigo da Receita
			If Empty(se2->e2_codins)

				MsgAlert('Tributo sem Codigo Receita. Informe o campo Cod.Ret INSS no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

			EndIf

		Endif

	EndIf

Return(_cReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CNAB2    ºAutor  ³Marciane Gennari    º Data ³  06/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Incrementa 1 (Hum) no sequencial de linha detalhe          º±±
±±º                                                                       º±±
±±ºObservacao³ Deve ser utilizado em conjunto com o P.E. FIN150_1, para   º±±
±±º          ³ que nÆo seja acrescentado 2 (dois) quando mudar de t¡tulo. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Cnab2

	If MV_PAR09 == 2 //--- Para Modelo 2 - controla o sequencial
		nSeq := nSeq+1
	EndIf

	Return(nSeq)    


	#include "rwmake.ch"

///--------------------------------------------------------------------------\
//| Função: CODBAR				Autor:         		Data: 
//|--------------------------------------------------------------------------|
//             |
//|--------------------------------------------------------------------------|
//| Descrição: Função para Validação de Código de Barras (CB) e Representação|
//|            Numérica do Código de Barras - Linha Digitável (LD).          |
//|                                                                          |
//|            A LD de Bloquetos possui três Digitos Verificadores (DV) que  |
//|				são consistidos pelo Módulo 10, além do Dígito Verificador   |
//|				Geral (DVG) que é consistido pelo Módulo 11. Essa LD têm 47  |
//|            Dígitos.                                                      |
//|                                                                          |
//|            A LD de Títulos de Concessinárias do Serviço Público e IPTU   |
//|				possui quatro Digitos Verificadores (DV) que são consistidos |
//|            pelo Módulo 10, além do Digito Verificador Geral (DVG) que    |
//|            também é consistido pelo Módulo 10. Essa LD têm 48 Dígitos.   |
//|                                                                          |
//|            O CB de Bloquetos e de Títulos de Concessionárias do Serviço  |
//|            Público e IPTU possui apenas o Dígito Verificador Geral (DVG) |
//|            sendo que a única diferença é que o CB de Bloquetos é         |
//|            consistido pelo Módulo 11 enquanto que o CB de Títulos de     |
//|            Concessionárias é consistido pelo Módulo 10. Todos os CB´s    |
//|            têm 44 Dígitos.                                               |
//|                                                                          |
//|            Para utilização dessa Função, deve-se criar o campo E2_CODBAR,|
//|            Tipo Caracter, Tamanho 48 e colocar na Validação do Usuário:  |
//|            EXECBLOCK("CODBAR",.T.).                                      |
//|                                                                          |
//|            Utilize também o gatilho com a Função CONVLD() para converter |
//|            a LD em CB.													 |
//\--------------------------------------------------------------------------/

USER FUNCTION CodBar()

	LOCAL I
	Local lGPS := .F.
	SETPRVT("cStr,lRet,cTipo,nConta,nMult,nVal,nDV,cCampo,i,nMod,nDVCalc")

	// Retorna .T. se o Campo estiver em Branco.
	IF VALTYPE(M->E2_CODBAR) == NIL .OR. EMPTY(M->E2_CODBAR)
		RETURN(.T.)
	ENDIF

	cStr := LTRIM(RTRIM(M->E2_CODBAR))

	// Se o Tamanho do String for 45 ou 46 está errado! Retornará .F.
	lRet := IF(LEN(cStr)==45 .OR. LEN(cStr)==46,.F.,.T.)

	// Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
	// necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
	cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)

	// Verifica se a LD é de (B)loquetos ou (C)oncessionárias/IPTU. Se for CB retorna (I)ndefinido.
	cTipo := IF(LEN(cStr)==47,"B",IF(LEN(cStr)==48,"C","I"))

	// Verifica se todos os dígitos são numérios.
	FOR i := LEN(cStr) TO 1 STEP -1
		lRet := IF(SUBSTR(cStr,i,1) $ "0123456789",lRet,.F.)
	NEXT

	IF LEN(cStr) == 47 .AND. lRet
		// Consiste os três DV´s de Bloquetos pelo Módulo 10.
		nConta  := 1
		WHILE nConta <= 3
			nMult  := 2
			nVal   := 0
			nDV    := VAL(SUBSTR(cStr,IF(nConta==1,10,IF(nConta==2,21,32)),1))
			cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,11,22)),IF(nConta==1,9,10))
			FOR i := LEN(cCampo) TO 1 STEP -1
				nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
				nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
				nMult := IF(nMult==2,1,2)
			NEXT
			nDVCalc := 10-MOD(nVal,10)
			// Se o DV Calculado for 10 é assumido 0 (Zero).
			nDVCalc := IF(nDVCalc==10,0,nDVCalc)
			lRet    := IF(lRet,(nDVCalc==nDV),.F.)
			nConta  := nConta + 1
		ENDDO
		// Se os DV´s foram consistidos com sucesso (lRet=.T.), converte o número para CB para consistir o DVG.
		cStr := IF(lRet,SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10),cStr)
	ENDIF

	IF LEN(cStr) == 48 .AND. lRet
		// Consiste os quatro DV´s de Títulos de Concessionárias de Serviço Público e IPTU pelo Módulo 10.
		nConta  := 1
		WHILE nConta <= 4
			nMult  := 2
			nVal   := 0
			nDV    := VAL(SUBSTR(cStr,IF(nConta==1,12,IF(nConta==2,24,IF(nConta==3,36,48))),1))
			cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,13,IF(nConta==3,25,37))),11)
			FOR i := 11 TO 1 STEP -1
				nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
				nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
				nMult := IF(nMult==2,1,2)
			NEXT
			nDVCalc := 10-MOD(nVal,10)
			// Se o DV Calculado for 10 é assumido 0 (Zero).
			nDVCalc := IF(nDVCalc==10,0,nDVCalc)
			lRet    := IF(lRet,(nDVCalc==nDV),.F.)
			nConta  := nConta + 1
		ENDDO
		// Se os DV´s foram consistidos com sucesso (lRet=.T.), converte o número para CB para consistir o DVG.
		cStr := IF(lRet,SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11),cStr)
	ENDIF

	IF LEN(cStr) == 44 .AND. lRet
		IF cTipo $ "BI"
			// Consiste o DVG do CB de Bloquetos pelo Módulo 11.
			nMult  := 2
			nVal   := 0
			nDV    := VAL(SUBSTR(cStr,5,1))
			cCampo := SUBSTR(cStr,1,4)+SUBSTR(cStr,6,39)
			FOR i := 43 TO 1 STEP -1
				nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
				nVal  := nVal + nMod
				nMult := IF(nMult==9,2,nMult+1)
			NEXT
			nDVCalc := 11-MOD(nVal,11)
			// Se o DV Calculado for 0,10 ou 11 é assumido 1 (Um).
			nDVCalc := IF(nDVCalc==0 .OR. nDVCalc==10 .OR. nDVCalc==11,1,nDVCalc)
			lRet    := IF(lRet,(nDVCalc==nDV),.F.)
			// Se o Tipo é (I)ndefinido E o DVG NÂO foi consistido com sucesso (lRet=.F.), tentará
			// consistir como CB de Título de Concessionárias/IPTU no IF abaixo.
		ENDIF
		IF cTipo == "C" .OR. (cTipo == "I" .AND. !lRet)
			// Consiste o DVG do CB de Títulos de Concessionárias pelo Módulo 10.
			lRet   := .T.
			nMult  := 2
			nVal   := 0
			nDV    := VAL(SUBSTR(cStr,4,1))
			cCampo := SUBSTR(cStr,1,3)+SUBSTR(cStr,5,40)
			FOR i := 43 TO 1 STEP -1
				nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
				nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
				nMult := IF(nMult==2,1,2)
			NEXT
			nDVCalc := 10-MOD(nVal,10)
			// Se o DV Calculado for 10 é assumido 0 (Zero).
			nDVCalc := IF(nDVCalc==10,0,nDVCalc)
			lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		ENDIF
	ENDIF

	// Caso lRet seja .F. tenta validar pelo Módulo 11
	// (GPS é validado por este módulo e possui 48 posições)
	// (Guia do Fundo de Garantia e validado por este modulo e possui 48 posicoes)
	// As validações acima não conseguem validar pois esta sendo validado pelo módulo 10

	IF LEN(cStr) == 48 .AND. !lRet
		//
		// Verifica se todos os dígitos são numérios.
		lRet := .T.

		For i := LEN(cStr) TO 1 STEP -1
			If lRet
				If SubStr(cStr,i,1) $ "0123456789"
					lRet := .T.
				Else
					lRet := .F.
				EndIf
			EndIf
		Next
		//
		nConta  := 1

		WHILE nConta <= 4

			nMult  := 2                              
			nVal   := 0
			nMod   := 0
			nDV    := VAL(SUBSTR(cStr,IF(nConta==1,12,IF(nConta==2,24,IF(nConta==3,36,48))),1))
			cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,13,IF(nConta==3,25,37))),11)
			//
			FOR i := 11 TO 1 STEP -1
				nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
				nVal  += nMod
				If nMult == 9
					nMult := 2
				Else
					nMult := nMult + 1
				EndIf
			NEXT
			//
			nDVCalc := 11-MOD(nVal,11)
			//
			// Se o DV Calculado for 0,10 ou 11 é assumido 0
			//
			If nDVCalc==10 .Or. nDVCalc==11
				nDVCalc := 0               
			EndIf
			//
			//Alert("Digito Calculado "+str(nDVCalc))
			//
			If lRet
				If nDVCalc==nDV
					lRet := .T.
				Else
					lRet := .F.
				EndIf
			EndIf

			nConta  := nConta + 1
			//
		EndDo
		cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
		lGPS := lRet
	EndIf

	If (Len(cStr) == 44 .And. !lRet ) .Or. lGPS
		//
		// Se os DV´s foram consistidos com sucesso (lRet=.T.), converte o número para CB para consistir o DVG.
		//
		lRet   := .T.
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,4,1))
		cCampo := AllTrim(SUBSTR(cStr,1,3)+SUBSTR(cStr,5,40))
		For i := 43 To 1 STEP -1
			nMod  := Val(SUBSTR(cCampo,i,1)) * nMult
			nVal  += nMod
			If nMult == 9
				nMult := 2
			Else
				nMult := nMult+1
			EndIf
		Next

		nDVCalc := 11-MOD(nVal,11)

		// Se o DV Calculado for 0,10 ou 11 é assumido 1 (Um).
		If nDVCalc==10 .OR. nDVCalc==11 .Or. nDVCalc==0 
			nDVCalc := 0 //1
		EndIf

		If lRet
			If nDVCalc == nDV
				lRet := .T.
			Else
				lRet := .F.
			EndIf
		EndIf
		//
		//Alert("Digito Geral Calculado "+str(nDVCalc))
		//
	EndIf

	IF !lRet
		HELP(" ",1,"ONLYNUM")
	ENDIF

RETURN(lRet)   



///--------------------------------------------------------------------------\
//| Função: CONVLD				Autor: Flávio Novaes				Data: 19/10/2003 |
//|--------------------------------------------------------------------------|
//| Descrição: Função para Conversão da Representação Numérica do Código de  |
//|            Barras - Linha Digitável (LD) em Código de Barras (CB).       |
//|                                                                          |
//|            Para utilização dessa Função, deve-se criar um Gatilho para o |
//|            campo E2_CODBAR, Conta Domínio: E2_CODBAR, Tipo: Primário,    |
//|            Regra: EXECBLOCK("CONVLD",.T.), Posiciona: Não.               |
//|                                                                          |
//|            Utilize também a Validação do Usuário para o Campo E2_CODBAR  |
//|            EXECBLOCK("CODBAR",.T.) para Validar a LD ou o CB.            |
//\--------------------------------------------------------------------------/
USER FUNCTION ConvLD()
	SETPRVT("cStr")

	cStr := LTRIM(RTRIM(M->E2_LINDIG))

	IF VALTYPE(M->E2_LINDIG) == NIL .OR. EMPTY(M->E2_LINDIG)
		// Se o Campo está em Branco não Converte nada.
		cStr := ""
	ELSE
		// Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
		// necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
		cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)
	ENDIF

	DO CASE
		CASE LEN(cStr) == 47
		cStr := SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)
		CASE LEN(cStr) == 48
		cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
		OTHERWISE
		cStr := cStr+SPACE(48-LEN(cStr))
	ENDCASE

RETURN(cStr)


/*/{Protheus.doc} RetNPR
//TODO Retorna data faturada conforme orientação do analista Éric
@author Eugenio
@since 15/01/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
USER FUNCTION RetNPR()

If !Empty(SE2->E2_ZDTNPR)
    _cVenc := Gravadata(SE2->E2_ZDTNPR,.F.,5)
    
Else
	_cVenc := Gravadata(SE2->E2_EMISSAO,.F.,5)
Endif

RETURN(_cVenc)

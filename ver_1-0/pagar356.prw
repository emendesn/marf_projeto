#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PAGAR356  �Autor  �                    � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera as informacoes para o cnab a pagar                  . ���
���                                                                       ���
���Parametros:                                                            ���
���                                                                       ���
���  01 - Retorna o nome do contribuinte (segmento N)                     ���
���  02 - Retorna os detalhes do segmento N (depende do tipo do tributo)  ���
���                                                                       ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function Pagar356(_cOpcao)


Local _cReturn := ""
Local _cMes     := ""
Local _cAno     := ""



If _cOpcao == "01"   // Nome do Contribuinte
	
	If !Empty(SE2->E2_XCNPJC)
		_cReturn := Subs(SE2->E2_XCONTR,1,30)
		If Empty(_cReturn)
			Alert('Nome do Contribuinte n�o informado para o segmento N - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
		EndIf
	Else
		_cReturn := Subs(SM0->M0_NOMECOM,1,30)
	EndIf
	
ElseIf _cOpcao == "02"   // Detalhes Segmento N
	
	//--- Codigo Receita do Tributo - Posicao 111 a 116
	If SEA->EA_MODELO == "18"   //--- Para DARF Simples - fixar c�digo 6106
		_cReturn := "6106"+SPACE(2)
	Else
		//_cReturn := "00"+If(!Empty(SE2->E2_CODINS),SE2->E2_CODINS,SE2->E2_CODRET)
		_cReturn := "00"+If(!Empty(SE2->E2_RETINS),SE2->E2_RETINS,If(!Empty(SE2->E2_CODINS),SE2->E2_CODINS,SE2->E2_CODRET))
	EndIf
	
	//--- Tipo de Identificacao do Contribuinte - Posicao 117 a 118
	//--- CNPJ (2) /  CPF (1)
	If !Empty(SE2->E2_XCNPJC)
		_cReturn += Iif (len(alltrim(SE2->E2_XCNPJC))>11,"01","02")
	Else
		//   _cReturn += "01" -SITUACAO ANTERIOR
		_cReturn += "02"
	EndIf
	
	//--- Identificacao do Contribuinte - Posicao 119 a 132
	//--- CNPJ/CPF do Contribuinte
	If !Empty(SE2->E2_XCNPJC)
		_cReturn += Strzero(Val(SE2->E2_XCNPJC),14)
	Else
		_cReturn += Subs(SM0->M0_CGC,1,14)
	EndIf
	
	
	//--- Identificacao do Tributo - Posicao 133 a 134
	//--- 16 - DARF Normal
	//--- 17 - GPS
	//--- 18 - DARF Simples
	//--- 19 - IPTU
	//--- 22 - GARE-SP ICMS
	//--- 23 - GARE-SP DR
	//--- 24 - GARE-SP ITCMD
	//--- 25 - IPVA
	//--- 26 - Licenciamento
	//--- 27 - DPVAT
	//--- 35 - FGTS
	_cReturn += SEA->EA_MODELO
	
	
	//--- GPS
	If SEA->EA_MODELO == "17" //--- GPS
		
		//--- Competencia (Mes/Ano) - Posicao 135 a 140  Formato MMAAAA
		//   _cReturn :=strzero(Month(SE2->E2_XAPUR,2)+Strzero(Year(SE2->E2_XAPUR),4) ///  - SITUA��O ANTERIOR
		
		_cMes:=Subs(Dtos(SE2->E2_XAPUR),5,2)
		_cAno:= Subs(Dtos(SE2->E2_XAPUR),1,4)
		_cReturn+=_cMes+_cAno
		
		//--- Valor do Tributo - Posicao 141 a 155
		//     _cReturn += Strzero((SE2->E2_SALDO-SE2->E2_E_VLENT)*100,15)
		
		_cReturn+=STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC)*100,15)
		//_cReturn +=Strzero(SE2->E2_SALDO*100,15)
		
		//--- Valor Outras Entidades - Posicao 156 a 170
		_cReturn += Strzero(( SE2->E2_XVENT * 100 ), 15)
		///  _cReturn +=Strzero(0,14)+Strzero(SE2->E2_SALDO*100,15)
		//_cReturn +=Strzero(0,14)
		
		//--- Atualizacao Monetaria - Posicao 171 a 185
		_cReturn +=Strzero((SE2->E2_MULTA+SE2->E2_JUROS)*100,15)
		
		//--- Mensagem ALERTA que est� sem Codigo da Receita
		//     If Empty(SE2->E2_CODREC) ->SITUA��O ANTERIOR
		//     If Empty(SE2->E2_CODRET)
		
		If Empty(SE2->E2_CODINS)
			
			Alert('Tributo sem Codigo Receita. Informe o campo Cod.Receita no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')
			
		EndIf
		
		//--- Mensagem ALERTA que est� sem periodo de apura��o
		If Empty(SE2->E2_XAPUR)
			
			Alert('Tributo sem Periodo de Apuracao. Informe o campo Per.Apuracao no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')
			
		EndIf
		
		//--- DARF Normal
	ElseIf SEA->EA_MODELO == "16" //--- DARF Normal
		
		//--- Periodo de Apuracao - Posicao 135 a 142  Formato DDMMAAAA
		//     _cReturn += Strzero(0,2)
		_cReturn += Gravadata(SE2->E2_XAPUR,.F.,5)
		
		//--- Referencia - Posicao 143 a 159
		_cReturn += Strzero(Val(SE2->E2_XREFER),17)  //verificar a necessidade
		
		//--- Valor Principal - Posicao 160 a 174
		_cReturn += Strzero(0,17)
		
		
		//--- Valor Principal - Posicao 165 a 179
		_cReturn += Strzero(SE2->E2_SALDO*100,15)
		
		//--- Valor da Multa - Posicao 175 a 189
		_cReturn += Strzero(SE2->E2_MULTA*100,15)
		
		//--- Valor da Multa - Posicao 175 a 189
		//    _cReturn += Strzero(SE2->E2_XMULTA*100,15)    --> situa��o anterior
		
		//--- Valor Juros/Encargos - Posicao 190 a 204
		//  _cReturn += Strzero(SE2->E2_E_JUROS*100,15)
		
		//--- Valor Juros/Encargos - Posicao 190 a 204  -> situa��o anterior
		_cReturn += Strzero(SE2->E2_JUROS*100,15)
		
		
		//--- Data de Vencimento - Posicao 205 a 212  Formato DDMMAAAA
		_cReturn += Gravadata(SE2->E2_VENCTO,.F.,5)
		
		///--- Mensagem ALERTA que est� sem Codigo da Receita para DARF de Reten��o
		If Empty(SE2->E2_CODRET)
			
			Alert('Tributo sem Codigo Receita. Informe o campo Cd.Reten��o no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')
			
		EndIf
		
		//--- Mensagem ALERTA que est� sem periodo de apura��o
		If Empty(SE2->E2_XAPUR)
			Alert('Tributo sem Periodo de Apuracao. Informe o campo Per.Apuracao no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')
		EndIf
		
		
		//--- DARF Simples
	ElseIf SEA->EA_MODELO == "18" //--- DARF Simples
		
		//--- Periodo de Apura��o  (Dia/Mes/Ano) - Posicao 135 a 142  Formato DDMMAAAA
		_cReturn += Gravadata(SE2->E2_XAPUR,.F.,5)
		
		//--- Receita Bruta - Posicao 143 a 157
		_cReturn += Repl("0",15)
		
		//--- Percentual - Posicao 158 a 164
		_cReturn += Repl("0",7)
		
		//--- Valor Principal - Posicao 165 a 179
		_cReturn += Strzero(SE2->E2_SALDO*100,15)
		
		//--- Valor da Multa - Posicao 180 a 194
		//     _cReturn += Strzero(SE2->E2_XMULTA*100,15)
		_cReturn += Strzero(SE2->E2_MULTA*100,15)
		
		//--- Valor Juros/Encargos - Posicao 195 a 209
		//  _cReturn += Strzero(SE2->E2_E_JUROS*100,15)
		_cReturn += Strzero(SE2->E2_JUROS*100,15)
		
		//--- Mensagem ALERTA que est� sem periodo de apura��o
		If Empty(SE2->E2_XAPUR)
			
			Alert('Tributo sem Periodo de Apuracao. Informe o campo Per.Apuracao no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')
			
		EndIf
		
		
		//--- GARE ICMS SP
	ElseIf SEA->EA_MODELO == "22" //--- GARE ICMS - SP
		
		//--- Codigo da Receita GARE ICMS - Posicao 111 a 116
		_cReturn := Strzero(Val(SE2->E2_XINSS),6)
		
		//--- Tipo de Identificacao do Contribuinte - Posicao 117 a 118
		//--- CNPJ (2) /  CPF (1)
		If !Empty(SE2->E2_XCNPJC)
			_cReturn += Iif (len(alltrim(SE2->E2_XCNPJC))>11,"01","02")
		Else
			//   _cReturn += "01" -SITUACAO ANTERIOR
			_cReturn += "02"
		EndIf
		
		//--- Identificacao do Contribuinte - Posicao 119 a 132
		//--- CNPJ/CPF do Contribuinte
		If SEA->EA_MODELO == "22"  //--- Para GARE ICMS - Retornar o CNPJ da Filial do SE2->E2_FILIAL
			_cReturn +=  Strzero(Val(u_dadosSM0("02",SE2->E2_FILIAL)),14)
		Endif
		
		//--- Identificacao do Tributo - Posicao 133 a 134
		_cReturn += SEA->EA_MODELO
		
		//--- Data de Vencimento - Posicao 135 a 142  Formato DDMMAAAA
		_cReturn += Gravadata(SE2->E2_VENCREA,.F.,5)
		
		//--- Inscricao Estadual - Posicao 143 a 154
		_cReturn +=  Strzero(Val(u_dadosSM0("01",SE2->E2_FILIAL)),12)
		
		//--- Divida Ativa / Etiqueta - Posicao 155 a 167
		_cReturn +=  Strzero(SE2->E2_XDIVID,13)
		
		//--- Periodo de Referencia (Mes/Ano) - Posicao 168 a 173  Formato MMAAAA
		_cReturn += Strzero(Month(SE2->E2_XAPUR),2)+Strzero(Year(SE2->E2_XAPUR),4)
		
		//--- N. Parcela / Notifica��o - Posicao 174 a 186
		_cReturn +=  Strzero(Val(SE2->E2_XPARCE),13)
		
		//--- Valor da Receita (Principal) - Posicao 187 a 201
		_cReturn += Strzero(SE2->E2_SALDO*100,15)
		
		//--- Valor Juros/Encargos - Posicao 202 a 215
		//  _cReturn += Strzero(SE2->E2_E_JUROS*100,14)
		_cReturn += Strzero(SE2->E2_XJUROS*100,14)
		
		//--- Valor da Multa - Posicao 216 a 229
		_cReturn += Strzero(SE2->E2_XMULTA*100,14)
		//   _cReturn += Strzero(SE2->E2_MULTA*100,14)
		
		
		//--- 25 - IPVA SP
		//--- 26 - Licenciamento
		//--- 27 - DPVAT
	ElseIf SEA->EA_MODELO == "25"  .or. SEA->EA_MODELO == "26" .or. SEA->EA_MODELO == "27"
		
		//--- Exercicio Ano Base - Posicao 135 a 138
		_cReturn += Strzero(VAL(SE2->E2_ANOBASE),4)
		
		//--- Renavam - Posicao 139 a 147
		_cReturn +=Strzero(Val(SE2->E2_XRENAV),9)
		
		//--- Unidade Federa��o - Posicao 148 a 149
		_cReturn +=  Upper(SE2->E2_XIPVUF)
		
		//--- Codigo do Municipio - Posicao 150 a 154
		_cReturn += Strzero(Val(SE2->E2_XCODMUN),5)
		
		//--- Placa - Posicao 155 a 161
		_cReturn +=  SE2->E2_XPLACA
		
		//--- Op��o de Pagamento - Posicao 162 a 162 - Para DPVAT sempre op��o 5
		If SEA->EA_MODELO == "25"
			_cReturn += Alltrim(SE2->E2_XOPCAO)
		Else
			_cReturn += "5"   //--- Para 27-DPVAT e 26-Licenciamento � obrigat�rio utilizar o c�digo 5.
		EndIf
		
		//--- Renavam - Posicao 163 a 174 - NOVO RENAVAM COM 11 DIGITOS
		_cReturn +="0"+Strzero(Val(SE2->E2_XRENANE),11)
		
		//--- Op��o de Retirada do CRVL - Posicao 163 a 163 - Somente para LICENCIAMENTO
		//---- 1 = Correio
		//---  2 = Detran / Ciretran
		If SEA->EA_MODELO == "26"
			_cReturn += "1"    //---  1 = Correio
		EndIf
	EndIf
	
EndIf

Return(_cReturn)

//--- Retornar Inscri��o Estadual e CNPJ da Filial do T�tulo do SE2
User Function DadosSM0(_cOpc,_cFilSE2)

Local _cVolta := ""
Local _nRecnoSM0 :=SM0->(Recno())


SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpAnt+_cFilSE2))

If _cOpc == "01"
	_cVolta := SM0->M0_INSC
Else
	_cVolta := SM0->M0_CGC
EndIf

SM0->(dbGoto(_nRecnoSM0))


Return(_cVolta)


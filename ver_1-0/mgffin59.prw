#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa.:              MGFFIN59
Autor....:              Atilio Amarilla
Data.....:              25/09/2017
Descricao / Objetivo:   Baixa CNAB - Bloqueio de baixa pelo portador para título FIDC
Doc. Origem:            Contrato - GAP CRE019/20/21
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Transações referentes a Banco/Carteira FIDC
=====================================================================================
*/

User Function MGFFIN59(lRet)

Local _cLinha	:= " "
Local _cConven	:= Alltrim(SEE->EE_CODEMP) //Convênio do banco.

/*
__________________________________
| Perguntas:						|
| __________________________________|
|									|
| 01	Mostra Lanc Contab ?		|
| 02	Aglut Lancamentos ?			|
| 03	Atualiza Moedas por ?		|
| 04	Arquivo de Entrada ?		|
| 05	Arquivo de Config ?			|
| 06	Codigo do Banco ?			|
| 07	Codigo da Agencia ?			|
| 08	Codigo da Conta ?			|
| 09	Codigo da Sub-Conta ?		|
| 10	Abate Desc Comissao ?		|
| 11	Contabiliza On Line ?		|
| 12	Configuracao CNAB ?			|
| 13	Processa Filial?			|
| 14	Contabiliza Transferencia ?	|
| 15	Considera Dias de Retencao ?|
|___________________________________|
*/
If File( AllTrim(MV_PAR04) )

	FT_FUSE(AllTrim(MV_PAR04))
	FT_FGOTOP()
	_cLinha    := FT_FREADLN()
	FT_FUSE()

	If !Subs(MV_PAR07,1,4) $ _cLinha .And. !Subs(MV_PAR08,1,5) $ _cLinha

		If Empty(_cConven) .OR. !(_cConven $ _cLinha)

			MV_PAR04	:= Space(Len(MV_PAR04))
		
			MsgStop( "O Arquivo de Entrada não pertence ao banco selecionado nos parâmetros"+CRLF+CRLF+"Verifique os parâmetros" , "Divergência Banco x Arquivo" )
		EndIf
	EndIf 
EndIf

lRet := .F.

Return lRet
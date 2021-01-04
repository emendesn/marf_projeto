//Bibliotecas
#Include "Protheus.ch"

/*/
=============================================================================
{Protheus.doc} MGFFATBT 
Programa para preenchimento automatico dos campos Tipo de Operação e TES no Pedido de Venda

@description
Programa para preenchimento automatico dos campos Tipo de Operação e TES no Pedido de Venda

@author Rodrigo Franco
@since 23/03/2020 
@type Function  

@table 
    SC5 - Pedido de Venda
	SC6 - Itens do Pedido de Vendas
 
@history //Manter até as últimas 3 manutenções do fonte para facilitar identificação de versão, remover esse comentário 
/*/   

User Function MGFFATBT()

    Local _aArea := GetArea()
	Local _lRet := .T.
	Local _lFATBT := SuperGetMV("MGF_FATBT1",.F.,.T.) // Ativa/Desabilita a funcionalidade RITM0024612 - Bloquear alteração do campo TES no Pedido de Vendas 

	If _lFATBT 
        FATBT01(@_lRet)
    Endif

	RestArea(_aArea)
Return _lRet

Static Function FATBT01(_lRet)
	Local _cTipo   := M->C5_TIPO
	Local _cTipCli := M->C5_TIPOCLI
	Local _cTipOpe := M->C5_ZTPOPER

	If _cTipo == 'N' .AND. _cTipCli <> 'X' .OR. _cTipo == 'C' .OR. _cTipo == 'B'
		IF _cTipOpe == '  '
			If (!IsBlind()) // COM INTERFACE GRÁFICA
				MSGINFO( "Campo - Tipo Opera - no Cabeçalho esta em Branco, favor preencher", "Tipo Opera" )
			Else // EM ESTADO DE JOB
				ConOut("Error: "+ "Campo - Tipo Opera - no Cabeçalho esta em Branco, favor preencher")
			EndIf
			_lRet := .F.
		else
		 	ACOLS[N][GDFIELDPOS("C6_OPER")] := _cTipOpe
		Endif
	Endif

	_cPedCli := ACOLS[N][GDFIELDPOS("C6_PEDCLI")]
	U_SAcento(@_cPedCli)
	ACOLS[N][GDFIELDPOS("C6_PEDCLI")] := _cPedCli
   	  
Return
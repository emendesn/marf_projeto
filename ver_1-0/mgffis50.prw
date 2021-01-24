#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"
/*/
{Protheus.doc} MGFFIS50
Ponto de Entrada para valida��o de manifesta��o no SEFAZ.

@description
Este ponto de entrada ir� verificar a Chave de acesso da NF(F1_CHVNFE) e localizar a mesma na tabela C00 (C00_CHVNFE).  
Caso localize, dever� alterar o campo status (C00_STATUS) para �Confirma��o da opera��o� e fazer a transmiss�o autom�tica para o SEFAZ. 
Caso localize a chave, mas encontre alguma manifesta��o (desconhecimento da opera��o/opera��o n�o realizada/documento cancelado/fora do periodo), 
a entrada do documento dever� ser bloqueada. 
Caso n�o localize chave na tabela C00 a classifica��o do documento  ser� conclu�da e para controle ser� criado um campo na tabela SF1 para 
a informa��o �Notas classificadas sem consulta no manifesto� e ser� apresentado um alerta para o usu�rio. 

	====================| STATUS DA MANIFESTA��O |=========================
	C00_STATUS=='1' .and. alltrim(C00_CODEVE)=='3' ====> Confirmada
	C00_STATUS=='2' .and. alltrim(C00_CODEVE)=='3' ====> Desconhecida								
	C00_STATUS=='3' .and. alltrim(C00_CODEVE)=='3' ====> N�o realizada								
	C00_STATUS=='4' .and. alltrim(C00_CODEVE)=='3' ====> Ci�ncia							
	C00_STATUS=='0'								   ====> Sem Manifesta��o
	=======================================================================
 
@author Marcos Cesar Donizeti Vieira
@since 22/08/2019

@version P12.1.017
@country Brasil
@language Portugu�s

@type Function 
@table 
	SF1 - Cabe�alho das NF de Entrada
	SD1 - Itens das NF de Entrada
	C00 - Manifesto do Destinat�rio
@param
@return

@menu
@history 
/*/
User Function MGFFIS50()
	Local _aArea	:= GetArea()
	Local _lRet 	:= .T.
	Local _lManif 	:= .F.
	Local _cMensNf	:= ""
	Local _aMontXml	:= {}
	Local _cRetorno	:= ""
	Local _lVldMnf  := .T.

	Local _cJustific	:= ""
	Local _oOkx			:= LoadBitmap( GetResources(), "LBOK" )
	Local _cOpcManif	:= "210200"
	Local _nPrzConfOp	:= 0

	Local _aRotExc		:= {}	
	Local _dEmisNf		:= dDataBase

	//--------------| Verifica exist�ncia de par�metros e caso n�o exista cria. |-------------------------
	If !ExisteSx6("MGF_FIS50F")
		CriarSX6("MGF_FIS50F", "C", "Rotinas que n�o passar�o pela valida��o. Ex:GFEA065;MGFINT09"	, 'GFEA065;MGFINT09' )	
	EndIf

	//--------------| Verifica exist�ncia de par�metros e caso n�o exista cria. |-------------------------
	If !ExisteSx6("MGF_VLDMNF")
		CriarSX6("MGF_VLDMNF", "L", "Valida manifesta��es de NF na Entrada(.T./.F.)?"			, '.T.' )	
	EndIf

	//--------------| Verifica exist�ncia de par�metros e caso n�o exista cria. |-------------------------
	If !ExisteSx6("MGF_PRZCIN")
		CriarSX6("MGF_PRZCIN", "N", "Prazo legal para CONFIRMACAO OPERACAO(Internas)."			, '20' 	)	
	EndIf

	//--------------| Verifica exist�ncia de par�metros e caso n�o exista cria. |-------------------------
	If !ExisteSx6("MGF_PRZCOU")
		CriarSX6("MGF_PRZCOU", "N", "Prazo legal para CONFIRMACAO OPERACAO(Interestaduais)."	, '35'	)	
	EndIf

	_aRotExc := STRTOKARR(SuperGetMV("MGF_FIS50F",.F.,'GFEA065;MGFINT09'),";")
	_lVldMnf := SUPERGETMV("MGF_VLDMNF",.F., '.T.' )

	//Verifica se as rotinas que n�o devem passar pela valida��o est�o na pilha de chamada. Se estiver, sai da fun��o. 
	For _nCnt := 1 To Len(_aRotExc)
		If IsInCallStack(Alltrim(_aRotExc[_nCnt]))
			_lVldMnf := .F.		// Se valida o Manifesto
		EndIf
	Next

	If _lVldMnf	// Valida Manifesta��es - C00
		If cFormul == "N"
			If SF1->F1_EST = ALLTRIM( SUPERGETMV("MV_ESTADO") )
				_nPrzConfOp := SUPERGETMV("MGF_PRZCIN",.F., '20')
			Else
				_nPrzConfOp	:= SUPERGETMV("MGF_PRZCOU",.F., '35') 
			EndIf

			C00->(dbSetOrder(1))
			If C00->(DbSeek(xFilial("C00")+aNfeDanfe[13]))
				If C00->C00_SITDOC <> "3"
					If 	(C00->C00_STATUS = "0" .AND. AllTrim(C00->C00_CODEVE) = "1") .OR. ;
						(C00->C00_STATUS = "4" .AND. AllTrim(C00->C00_CODEVE) = "2") .OR. ;
						(C00->C00_STATUS = "4" .AND. AllTrim(C00->C00_CODEVE) = "3") .OR. ;
						(C00->C00_STATUS = "1" .AND. AllTrim(C00->C00_CODEVE) = "3")

						If C00->C00_STATUS = "1" .AND. AllTrim(C00->C00_CODEVE) = "3"
							_cMensNf := "MANISFESTACAO EFETUADA ANTERIORMENTE. [RECLASSIFICACAO DA NFISCAL]"
							MsgInfo("Nota Fiscal com status de CONFIRMA��O DA OPERA��O no SEFAZ, n�o ser� necess�rio fazer nova Manifesta��o.","ALERTA FISCAL")
						Else
							_dEmisNf := Iif( EMPTY(C00->C00_DTEMI), dDataBase, C00->C00_DTEMI ) 
							If (dDataBase - _dEmisNf) <= _nPrzConfOp  
								aadd(_aMontXml,{_oOkx,C00->C00_CHVNFE,C00->C00_SERNFE,C00->C00_NUMNFE,C00->C00_VLDOC,C00->C00_CNPJEM,C00->C00_NOEMIT,C00->C00_IEEMIT,;
												C00->C00_DTEMI,C00->C00_DTREC,.T.,C00->C00_STATUS,C00->C00_CODEVE})

								_lManif := U_FIS49D(_cOpcManif,_aMontXml,@_cRetorno,_cJustific)
								If _lManif
									_cMensNf := "NOTA FISCAL MANIFESTADA COMO: 210200 - CONFIRMACAO DA OPERACAO."
									MsgInfo("Nota Fiscal MANIFESTADA como: 210200 - Confirma��o da Opera��o.","ALERTA FISCAL")
								Else
									_cMensNf := "NOTA FISCAL NAO MANISFESTADA. [ERRO DE CONEXAO NO SEFAZ]"			
									MsgInfo("Nota Fiscal N�O MANIFESTADA com a Confirma��o da Opera��o."+chr(13)+chr(10)+chr(13)+chr(10)+;
											"Por favor, entrar na Rotina de Manifesto e manifestar manualmente","ALERTA FISCAL")
								EndIf
							Else
								_cMensNf := "NOTA FISCAL NAO MANISFESTADA. [FORA DO PRAZO LEGAL - DTEMIS/DATAATU]"
								MsgInfo("Nota Fiscal fora do prazo legal para manifesta��o como: 210200 - Confirma��o da Opera��o."+chr(13)+chr(10)+chr(13)+chr(10)+;
										"NF ser� Classificada, mas ficar� com flag de advert�ncia","ALERTA FISCAL")
							EndIf
						EndIf
					ElseIf C00->C00_STATUS = "2" .AND. AllTrim(C00->C00_CODEVE) = "3"
						_lRet := .F.
						MsgStop("Nota Fiscal com status de NF DESCONHECIDA no SEFAZ, n�o ser� poss�vel a sua classifica��o.","ALERTA FISCAL")
					ElseIf C00->C00_STATUS = "3" .AND. AllTrim(C00->C00_CODEVE) = "3"
						_lRet := .F.
						MsgStop("Nota Fiscal com status de N�O REALIZADA no SEFAZ, n�o ser� poss�vel a sua classifica��o.","ALERTA FISCAL")
					Else
						_lRet := .F.
						MsgStop("Nota Fiscal com Manifesto desconhecido no SEFAZ, n�o ser� poss�vel a sua classifica��o."+chr(13)+chr(10)+chr(13)+chr(10)+;
						"Status: "+C00->C00_STATUS+chr(13)+chr(10)+"Cod.Envio: "+AllTrim(C00->C00_CODEVE),"ALERTA FISCAL")
					EndIf
				Else
					_lRet := .F.
					MsgStop("Nota Fiscal CANCELADA NO SEFAZ, n�o ser� poss�vel a sua classifica��o.","ALERTA FISCAL")
				EndIf
			Else
				_cMensNf := "NOTA CLASSIFICADA SEM MANIFESTO. [NAO ENCONTRADO A CHAVE DA NF NO C00]"
				MsgInfo("Nota Fiscal SEM MANIFESTO, esta NF ser� classificada, mas ficar� com flag de Nota classificada sem Manifesto.","ALERTA FISCAL")
			EndIf

			If !Empty(_cMensNf) .AND. _lRet .AND. cTipo <> "D"
				Begin Transaction
					SF1->(Reclock("SF1",.F.))
					SF1->F1_ZMMANIF := _cMensNf
					SF1->(MsUnLock())
				End Transaction
			EndIf
		EndIf
	EndIf

	RestArea(_aArea)	
Return(_lRet)
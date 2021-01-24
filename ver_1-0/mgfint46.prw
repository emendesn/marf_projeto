#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'     

#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa............: MGFINT46
Autor...............: Marcelo Carneiro
Data................: 22/05/2017
Descricao / Objetivo: Codigo Automatico do Codigo do Cliente
Doc. Origem.........: MIT044
Solicitante.........: Cliente - João 
Uso.................: Marfrig
Obs.................: Chamado pelos PE 
- O campo codigo e Loja devem estar como XXXXX no inicializador 

=====================================================================================
*/
User Function MGFINT46(xTipo) 
	Local bRet    := .T. 
	Local aCodErp := {}

	IF IsInCallStack("U_XEXEC")
		Return .T.
	EndIF

	IF xTipo == 1
		IF !INCLUI .AND. !ALTERA
			Return .T.
		EndIF

		IF ALTERA
			IF M->A1_CGC <> SA1->A1_CGC
				MsgAlert('Não é possivel alterar o campo CNPJ/CPF !!')
				Return .F.
			EndIF
			IF M->A1_PESSOA <> SA1->A1_PESSOA
				MsgAlert('Não é possivel alterar o Tipo de Cliente !!')
				Return .F.
			EndIF
			IF M->A1_TIPO <> SA1->A1_TIPO .And. (M->A1_TIPO == 'X' .OR. SA1->A1_TIPO=='X')
				MsgAlert('Não é possivel alterar o Tipo do cliente Estrangeiro!!')
				Return .F.
			EndIF
		EndIF
		// Informa que o O CNPJ é obrigatorio
		IF Empty(M->A1_CGC) .And. M->A1_TIPO <> 'X'
			MsgAlert('É Obrigatório o campo CNPJ/CPF !!')
			Return .F.
		EndIF

		// Estrangeiro não pode CNPJ
		IF !Empty(M->A1_CGC)
			IF  M->A1_TIPO == 'X'
				MsgAlert('Não é possivel ter CNPJ para cliente estrangeiro !!')
				Return .F.
			Else
				//Verifica se já existe
				IF INCLUI
					IF !ValCNPJ(M->A1_TIPO,M->A1_CGC)
						If IsBlind()
							Help(" ",1,'CNPJEMUSO',,'CNPJ já utilizado, não será possivel o cadastramento!',1,0)
						Else
							MsgAlert('CNPJ já utilizado, não será possivel o cadastramento!')
						eNDiF
						Return .F.
					EndIF
				EndIF
			EndIF
		EndIF
	EndIF
	IF xTipo == 2
		aCodErp := Ret_Codigo(SA1->A1_CGC,SA1->A1_PESSOA)
		RecLock('SA1', .F.)
		SA1->A1_COD  := aCodErp[1]
		SA1->A1_LOJA := aCodErp[2]
		SA1->(msUnlock())
		If !IsBlind()
			msgAlert('Cliente Cadastrado (Codigo/Loja): '+SA1->A1_COD+' / '+SA1->A1_LOJA)
		EndIf
	EndIF
	Return bRet
	******************************************************************************************************************************************************************	
Static Function ValCNPJ(cTipo,cCNPJ, cTipoMarfrig)
	Local aArea     := GetArea()
	Local aAreaSA1  := SA1->(GetArea())
	Local bRet      := .T. 

	dbSelectArea("SA1")
	SA1->(dbSetOrder(3))
	SA1->(dbSeek(xFilial("SA1")+cCNPJ)) 
	IF SA1->(!Eof()) 
		bRet := .F.
	EndIF

	RestArea(aAreaSA1)
	RestArea(aArea)

	Return bRet
	***************************************************************************************************************************************************************
Static Function Ret_Codigo(cCNPJ,cTipo)

	Local aRet    	:= {'000001','01'}
	Local _cWhrQry := 'AND 1 = 1'
	
	IF cTipo == 'J' .AND. M->A1_TIPO <> 'X'
		_cWhrQry := "AND A1_CGC Like '"+SubString(cCNPJ,1,8)+"%' AND SA1.A1_PESSOA = '"+ALLTRIM(cTipo)+"'"
	EndIF

		_cWhrQry := "%" + _cWhrQry + "%"

	_cAliasSA1	:= GetNextAlias()
	BeginSql Alias _cAliasSA1
		
		SELECT 
			Max(SA1.A1_COD) COD , Max(SA1.A1_LOJA) LOJA
		FROM 
			%table:SA1% SA1
		WHERE
			SA1.%notDel%
			AND SA1.A1_COD < 'A'     
			%exp:_cWhrQry%  

	EndSql

	IF cTipo == 'J'     
		IF M->A1_TIPO == 'X'        
			aRet[01] := CodSA1SX6((_cAliasSA1)->COD)
			aRet[02] := '01'
		ELSE
			IF Empty((_cAliasSA1)->COD)
				aRet[01] := CodSA1SX6((_cAliasSA1)->COD)
				aRet[02] := '01'
			Else
				aRet[01] := (_cAliasSA1)->COD
				aRet[02] := SOMA1((_cAliasSA1)->LOJA)
			EndIF    
		ENDIF
	Else
		IF Empty((_cAliasSA1)->COD)
			aRet[01] := '000001'
			aRet[02] := '01'
		Else
			aRet[01] := CodSA1SX6((_cAliasSA1)->COD)
			aRet[02] := '01'
		EndIF
	EndIF

	//---Fechando area de trabalho
	(_cAliasSA1)->(dbcloseArea())

Return aRet

Static Function Ret_Max
	Local cCod    := ''

	_cRetMaxSA1	:= GetNextAlias()
	BeginSql Alias _cRetMaxSA1
		
		SELECT 
			Max(SA1.A1_COD) COD
		FROM 
			%table:SA1% SA1
		WHERE
			SA1.%notDel%
			AND SA1.A1_COD < 'A'    

	EndSql

	IF Empty((_cRetMaxSA1)->COD)
		cCod := '000001'
	Else
		cCod := CodSA1SX6((_cRetMaxSA1)->COD)
	EndIF

	//---Fechando area de trabalho
	(_cRetMaxSA1)->(dbcloseArea())

Return cCod


Static Function CodSA1SX6(cCod)

	Local cCodSX6 := GetMv('MGF_A1COD')

	If Empty(cCodSX6) .or. cCodSX6 > 'A     '
		cCodSX6 := cCod
	Endif	

	cCodSX6 := Soma1(cCodSX6)	
	// casos que o parametro ficou menor que o sa1
	While cCodSX6 <= cCod
		cCodSX6 := Soma1(cCodSX6)		
	Enddo	
	PutMv('MGF_A1COD',cCodSX6)

Return(cCodSX6)

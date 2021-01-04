#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'     
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa............: MGFINT45
Autor...............: Marcelo Carneiro
Data................: 19/05/2017
Descricao / Objetivo: Codigo Automatico do Codigo do Cliente/Fornecedor
Doc. Origem.........: MIT044
Solicitante.........: Cliente - João 
Uso.................: Marfrig
Obs.................: Chamado pelos PE 
- O campo codigo e Loja devem estar como XXXXX no inicializador 
=====================================================================================
*/
User Function MGFINT45 
	Local bRet    := .T. 
	Local aCodErp := {}

	IF IsInCallStack("U_XEXEC")
		Return .T.
	EndIF

	IF !INCLUI .AND. !ALTERA
		Return .T.
	EndIF
	
	IF IsInCallStack("A020Altera") //Alteração necessária pois o padrão do botão Bancos (FtBanco) altera o INCLUI para .T. independente da operação (ALTERA, INCLUI)
		ALTERA := .T.
		INCLUI := .F.
	Endif
	
	IF ALTERA
			IF M->A2_CGC <> SA2->A2_CGC
				MsgAlert('Não é possivel alterar o campo CNPJ/CPF !!')
				Return .F.
			EndIF
			IF M->A2_TIPO <> SA2->A2_TIPO
				MsgAlert('Não é possivel alterar o Tipo do Forneceodor !!')
				Return .F.
			EndIF
			IF M->A2_ZTPFORN <> SA2->A2_ZTPFORN .And. (M->A2_ZTPFORN == '2' .OR. SA2->A2_ZTPFORN=='2')
				MsgAlert('Não é possivel alterar o Tipo do Forneceodor Marfrig!!')
				Return .F.
			EndIF
	EndIF
	// Informa que o O CNPJ é obrigatorio
	IF Empty(M->A2_CGC) .And. M->A2_TIPO <> 'X'
		MsgAlert('É Obrigatório o campo CNPJ/CPF !!')
		Return .F.
	EndIF

	// Estrangeiro não pode CNPJ
	IF !Empty(M->A2_CGC)
		IF  M->A2_TIPO == 'X'
			MsgAlert('Não é possivel ter CNPJ para fornecedor estrangeiro !!')
			Return .F.
		Else
			//Verifica se já existe
			IF INCLUI
				IF !ValCNPJ(M->A2_TIPO,M->A2_CGC,M->A2_ZTPFORN)
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

	IF INCLUI
		aCodErp := Ret_Codigo(M->A2_CGC,M->A2_TIPO,M->A2_ZTPFORN)
		M->A2_COD  := aCodErp[1]
		M->A2_LOJA := aCodErp[2]
		msgAlert('Fornecedor Cadastrado (Codigo/Loja): '+M->A2_COD+' / '+M->A2_LOJA)
	EndIF

	Return bRet
	******************************************************************************************************************************************************************	
Static Function ValCNPJ(cTipo,cCNPJ, cTipoMarfrig)
	Local aArea     := GetArea()
	Local aAreaSA2  := SA2->(GetArea())
	Local bRet      := .T. 

	dbSelectArea("SA2")
	SA2->(dbSetOrder(3))
	SA2->(dbSeek(xFilial("SA2")+cCNPJ)) 
	Do While SA2->(!Eof()) .AND. SA2->A2_CGC == cCNPJ
		IF cTipoMarfrig == '2' 
			IF cTipoMarfrig <> SA2->A2_ZTPFORN
				bRet := .F.
			EndIF
		Else
			bRet := .F. 
		EndIf
		SA2->(DbSkip())
	EndDo

	RestArea(aAreaSA2)
	RestArea(aArea)

	Return bRet
	***************************************************************************************************************************************************************
Static Function Ret_Codigo(cCNPJ,cTipo,cTipoMarfrig)

	Local aRet    := {'000001','01'}
	Local _cWhrQry := 'AND 1 = 1'

	IF cTipoMarfrig =='2'
		_cWhrQry	:= "AND SA2.A2_CGC = '"+cCNPJ+"' AND SA2.A2_ZTPFORN = '2'"
	Else
		IF cTipo == 'J'
			_cWhrQry := "AND SA2.A2_CGC Like '"+SubString(cCNPJ,1,8)+"%' AND SA2.A2_ZTPFORN <> '2' AND SA2.A2_TIPO = '"+ALLTRIM(cTipo)+"'" 
		EndIF    
	EndIF

		_cWhrQry := "%" + _cWhrQry + "%"

	_cAliasSA2	:= GetNextAlias()
	BeginSql Alias _cAliasSA2
		
		SELECT 
			Max(SA2.A2_COD) COD , Max(SA2.A2_LOJA) LOJA
		FROM 
			%table:SA2% SA2
		WHERE
			SA2.%notDel%
			AND SA2.A2_COD < 'A'     
			%exp:_cWhrQry%  

	EndSql

	IF cTipoMarfrig =='2'
		IF Empty((_cAliasSA2)->COD)
			aRet[01] := Ret_Max()
			aRet[02] := '01'
		Else
			aRet[01] := (_cAliasSA2)->COD
			aRet[02] := SOMA1((_cAliasSA2)->LOJA)
		EndIF
	Else
		IF cTipo == 'J'      
			IF M->A2_TIPO == 'X' 
				aRet[01] := Ret_Max()
				aRet[02] := '01'
			ELSE
				IF Empty((_cAliasSA2)->COD)
					aRet[01] := Ret_Max()
					aRet[02] := '01'
				Else
					aRet[01] := (_cAliasSA2)->COD
					aRet[02] := SOMA1((_cAliasSA2)->LOJA)
				EndIF
			ENDIF
		Else 
			IF Empty((_cAliasSA2)->COD)
				aRet[01] := '000001'
				aRet[02] := '01'
			Else
				aRet[01] := CodSA2SX6((_cAliasSA2)->COD)
				aRet[02] := '01'
			EndIF
		EndIF       
	EndIF

	//---Fechando area de trabalho
	(_cAliasSA2)->(dbcloseArea())

Return aRet


Static Function Ret_Max
	Local cCod    := ''

	_cRetMaxSA2	:= GetNextAlias()
	BeginSql Alias _cRetMaxSA2
		
		SELECT 
			Max(SA2.A2_COD) COD
		FROM 
			%table:SA2% SA2
		WHERE
			SA2.%notDel%
			AND SA2.A2_COD < 'A'    

	EndSql
	
	IF Empty((_cRetMaxSA2)->COD)
		cCod := '000001'
	Else
		cCod := CodSA2SX6((_cRetMaxSA2)->COD)
	EndIF
	
	//---Fechando area de trabalho
	(_cRetMaxSA2)->(dbcloseArea())

Return cCod


Static Function CodSA2SX6(cCod)

	Local cCodSX6 := GetMv('MGF_A2COD')

	If Empty(cCodSX6) .or. cCodSX6 > 'A     '
		cCodSX6 := cCod
	Endif	

	cCodSX6 := Soma1(cCodSX6)	
	// casos que o parametro ficou menor que o sa2
	While cCodSX6 <= cCod
		cCodSX6 := Soma1(cCodSX6)		
	Enddo	
	PutMv('MGF_A2COD',cCodSX6)

Return(cCodSX6)

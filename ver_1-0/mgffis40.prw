#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#DEFINE CRLF chr(13) + chr(10)

//-------------------------------------------------------------------
/*{Protheus.doc} MGFFIS40
GAP387 - Criar inteligencia no campo Cnae do cliente x Grupo de Tributação

Descrição da rotina:

Desenvolver duas funções (FIS40VlCli / FIS40VlFor) dentro do arquivo MGFFIS40.PRW para preenchimento automático dos campos A1_GRPTRIB ou A2_GRPTRIB,
grupo de tributação do cadastro de clientes ou fornecedores, conforme regras definidas no cadastro de Regras de Aprovação Automática. As mesmas também
devem alimentar os campos A1_ZAUTAPR ou A2_ZAUTAPR adicionando os códigos dos setores, conforme tabela ZB6, que passarão pela aprovação automática. Exemplo ‘02’ – Fiscal.

01	CDM
02	FISCAL
03	CONTABILIDADE
06	USUARIOS BLOQUEADOS
04	FINANCEIRO (CRE)
05	FINANCEIRO (CAP)

As funções devem ser acionadas pelos pontos de entrada  MA020TOK (Fornecedor) e MA030TOK (Cliente) e apenas para inclusão de registros.


@author Natanael Simões
@since 19/10/2018
@version P12.1.17
*/
//-------------------------------------------------------------------

User Function MGFFIS40(opc)//1: Fornecedor / 2:Cliente
	Local aArea := GetArea()

	If opc = 1 //Atualiza Fornecedor
		If SA2->A2_ZTPRHE <> "F" //A Rotina de aprovação do Fiscal não pode ser executada quando o Fornecedor é funcionario
			FIS40VlFor()
		EndIf
	Elseif opc = 2 //Atualiza cliente
		If SA1->A1_ZTPRHE <> "F"//A Rotina de aprovação do Fiscal não pode ser executada quando o Cliente é funcionario
			FIS40VlCli()
		EndIf
	EndIf

	RestArea(aArea)
	Return Nil


	//------------------------------
	/*
	Preenchimento automático dos campos A1_GRPTRIB e A1_ZAUTAPR
	*/
	//------------------------------
User Function FIS40Aprov(idSet,cCad) //Setor (ZB6),Cadastro (Conforme U_INT38_CAD())
	Local lRet

	If cCad = '1' //Cliente
		lRet := IIf(idSet $ SA1->A1_ZAUTAPR,.T.,.F.)
	ElseIf cCad = '3' //Fornecedor
		lRet := IIf(idSet $ SA2->A2_ZAUTAPR,.T.,.F.)
	EndIf

	Return lRet

	/*
	Preenchimento automático dos campos A2_GRPTRIB, A2_ZAUTAPR e A2_NATUREZ
	*/
Static Function FIS40VlFor()
	Local cPessoa
	Local cTpForn
	Local cSimpNac
	Local cInsc
	Local cEst
	Local cTipo
	Local cAutApr
	Local cGrpTrib := ''
	Local cNaturez := ''

	cCnae := SA2->A2_CNAE
	cTpForn := SA2->A2_ZTPFORN
	cSimpNac := SA2->A2_SIMPNAC
	cPessoa := SA2->A2_TIPO
	cInsc := IIF(EMPTY(SA2->A2_INSCR) .OR. SA2->A2_INSCR == 'ISENTO','2','1') //1= Possui Inc. ; 2= Isento o em branco
	cEst := SA2->A2_EST
	cTipo := SA2->A2_TPESSOA
	cAutApr := AllTrim(SA2->A2_ZAUTAPR)

	//Query na ZEA - Regras de Aprov. Automática
	BeginSQL Alias 'ZEATMP'
		SELECT
		ZEA_CNAE,
		ZEA_PESSOA,
		ZEA_ZTPFOR,
		ZEA_SIMNAC,
		ZEA_INSCR,
		ZEA_EST,
		ZEA_NATURE,
		ZEA_GRPTRI,
		ZEA_ATVFOR
		FROM
		%Table:ZEA%
		WHERE
		ZEA_CLIFOR = 'F' //C : cliente ; F: Fornecedor
		AND ZEA_CNAE		= %Exp:cCnae%
		AND (ZEA_PESSOA	= %Exp:cPessoa%		OR ZEA_PESSOA = ' ')
		AND (ZEA_ZTPFOR	= %Exp:cTpForn%		OR ZEA_ZTPFOR = ' ')
		AND (ZEA_SIMNAC	= %Exp:cSimpNac%	OR ZEA_SIMNAC = ' ')
		AND (ZEA_INSCR	= %Exp:cInsc%		OR ZEA_INSCR	= ' ')
		AND (ZEA_EST	= %Exp:cEst%		OR ZEA_EST	= ' ')
		AND (ZEA_ATVFOR	= %Exp:cTipo%		OR ZEA_ATVFOR	= ' ')
	EndSQL

	ZEATMP->(DBGoTop())
	If ZEATMP->(!EOF())

		cGrpTrib := ZEATMP->ZEA_GRPTRI
		cNaturez := ZEATMP->ZEA_NATURE
		Reclock("SA2",.F.)
		If !Empty(cGrpTrib)
			SA2->A2_GRPTRIB := cGrpTrib
			If !Empty(cAutApr)
				cAutApr += '/'
			EndIf
			cAutApr += SuperGetMV("MGF_FIS39D",.T.,'') //Código relacionado ao setor Fiscal no cadastro de Setores (ZB6)
		EndIf

		If !Empty(cNaturez)
			SA2->A2_NATUREZ := cNaturez

			If !Empty(cAutApr)
				cAutApr += '/'
			EndIf
			cAutApr += SuperGetMV("MGF_FIS39C",.T.,'') //Código relacionado ao setor de contabilidade no cadastro de Setores (ZB6)
		EndIf

		SA2->A2_ZAUTAPR := cAutApr //Alimenta o campo com os códigos dos setores que serão liberados automativamente pela aprovação de cadastro.
		MSUNLOCK()
	EndIf

	ZEATMP->(DbCloseArea())

	Return Nil

	//------------------------------
	/*
	Preenchimento automático dos campos A1_GRPTRIB, A1_ZAUTAPR e A1_NATUREZ
	*/
	//------------------------------
Static Function FIS40VlCli()
	Local cPessoa
	Local cSufram
	Local cSimpNac
	Local cInsc
	Local cEst
	Local cTipo
	Local cAutApr
	Local cGrpTrib := ''
	Local cNaturez := ''

	cCnae := SA1->A1_CNAE
	cSufram := IIF(EMPTY(SA1->A1_SUFRAMA),'2','1')
	cSimpNac := SA1->A1_SIMPNAC
	cPessoa := SA1->A1_PESSOA
	cInsc := IIF(EMPTY(SA1->A1_INSCR) .OR. SA1->A1_INSCR == 'ISENTO','2','1') //1= Possui Inc. ; 2= Isento o em branco
	cEst := SA1->A1_EST
	cTipo := SA1->A1_TIPO
	cAutApr := AllTrim(SA1->A1_ZAUTAPR)

	//Query na ZEA - Regras de Aprov. Automática
	BeginSQL Alias 'ZEATMP'
		SELECT
		ZEA_CNAE,
		ZEA_PESSOA,
		ZEA_SUFRAM,
		ZEA_SIMNAC,
		ZEA_INSCR,
		ZEA_EST,
		ZEA_NATURE,
		ZEA_GRPTRI,
		ZEA_ATVCLI
		FROM
		%Table:ZEA%
		WHERE
		ZEA_CLIFOR = 'C' //C : cliente ; F: Fornecedor
		AND ZEA_CNAE		= %Exp:cCnae%
		AND (ZEA_PESSOA	= %Exp:cPessoa%		OR ZEA_PESSOA = ' ')
		AND (ZEA_SUFRAM	= %Exp:cSufram%		OR ZEA_SUFRAM = ' ')
		AND (ZEA_SIMNAC	= %Exp:cSimpNac%	OR ZEA_SIMNAC = ' ')
		AND (ZEA_INSCR	= %Exp:cInsc%		OR ZEA_INSCR	= ' ')
		AND (ZEA_EST	= %Exp:cEst%		OR ZEA_EST	= ' ')
		AND (ZEA_ATVCLI	= %Exp:cTipo%		OR ZEA_ATVCLI	= ' ')
	EndSQL

	ZEATMP->(DBGoTop())
	If ZEATMP->(!EOF())

		cGrpTrib := ZEATMP->ZEA_GRPTRI
		cNaturez := ZEATMP->ZEA_NATURE
		Reclock("SA1",.F.)
		If !Empty(cGrpTrib)
			SA1->A1_GRPTRIB := cGrpTrib
			If !Empty(cAutApr)
				cAutApr += '/'
			EndIf
			cAutApr += SuperGetMV("MGF_FIS39D",.T.,'') //Código relacionado ao setor Fiscal no cadastro de Setores (ZB6)
		EndIf

		If !Empty(cNaturez)
			SA1->A1_NATUREZ := cNaturez

			If !Empty(cAutApr)
				cAutApr += '/'
			EndIf
			cAutApr += SuperGetMV("MGF_FIS39C",.T.,'') //Código relacionado ao setor de contabilidade no cadastro de Setores (ZB6)
		EndIf

		SA1->A1_ZAUTAPR := cAutApr //Alimenta o campo com os códigos dos setores que serão liberados automativamente pela aprovação de cadastro.
		MSUNLOCK()
	EndIf

	ZEATMP->(DbCloseArea())
	Return Nil
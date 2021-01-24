#include "Protheus.ch"
//#include "OMSA010.CH"
#include "FWMVCDEF.CH"
#include "TBICONN.CH"
#Include "topconn.ch"
//#include 'FWADAPTEREAI.CH'    //Include para rotinas de integração com EAI
//#include 'FILEIO.CH'

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 15/09/2016
Descricao / Objetivo: Cadastro de departamentos
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina para gravar dados adicionais na tabela de preco
=====================================================================================
@alterações 06/02/2020 - Henrique Vidal
	PRB0040687 - Desenvolvido processo para não permitir alterações no preço para o 
	             produto posicionado, quando o campo B1_zlinha estiver inconsistente.
				 Funções acionadas, somente quando campo DA0_XENVECO == 1
*/

User Function MGFFAT04()
Local aArea	:= GetArea()
Local oBtn1
Local oBtn2
Local oBtn3
Local oBtn4
Local oBtn5
Local oBtn6
Local oBtn7
Local oBtn8
Local oBtn9
Local oBtn10
Local oBtn11
Local oBtn12
Local oBtn13
Local oBtn14
Local oBtn15
Local oBtn16
Local oBtn17
Local oBtn18
Local oBtn19
Local oBtn20
Local oBtn21
Local oBtn22

Local oLstSZB	:= Nil
Local oLstSZC	:= Nil
Local oLstSZF	:= Nil
Local oLstSZG	:= Nil
Local oLstSZH	:= Nil
Local oLstSZI	:= Nil
Local oLstSZJ	:= Nil
Local oLstSZL	:= Nil
Local oLstSZM	:= Nil

Local nListBox1 := 1

Local aSZB		:= {}
Local aSZC		:= {}
Local aSZF		:= {}
Local aSZG		:= {}
Local aSZH		:= {}
Local aSZI		:= {}
Local aSZJ 		:= {}
Local aSZL 		:= {}
Local aSZM 		:= {}

Local oDlg1
Local oFolder1

//------------------------------------------
//Busca os dados Tab.Preco x Filiais
//------------------------------------------
T04SZB( @aSZB )

//------------------------------------------
//Busca os dados Tab.Preco x Vendedores
//------------------------------------------
T04SZC( @aSZC )

//------------------------------------------
//Busca os dados Tab.Preco x Departamento
//------------------------------------------
T04SZF( @aSZF )

//------------------------------------------
//Busca os dados Tab.Preco x Cliente
//------------------------------------------
T04SZG( @aSZG )

//------------------------------------------
//Busca os dados Tab.Preco x Estado
//------------------------------------------
T04SZH( @aSZH )

//------------------------------------------
//Busca os dados Tab.Preco x Regiao
//------------------------------------------
T04SZI( @aSZI )

//------------------------------------------
//Busca os dados Tab.Preco x Tipo de Pedido
//------------------------------------------
T04SZJ( @aSZJ )

//------------------------------------------
//Busca os dados Tab.Preco x Volume
//------------------------------------------
T04SZL( @aSZL )

//------------------------------------------
//Busca os dados Tab.Preco x Quantidade
//------------------------------------------
T04SZM( @aSZM )

  DEFINE MSDIALOG oDlg1 TITLE "Dados Adicionais" FROM 000, 000  TO 500, 700 COLORS 0, 16777215 PIXEL

    @ 011, 015 FOLDER oFolder1 SIZE 321, 207 OF oDlg1 ITEMS 	"Filial"		,;
    															"Vendedor"		,;
    															"Departamento"	,;
    															"Cliente"		,;
    															"Estado"		,;
    															"Regiao"		,;
    															"Tipo de Pedido",;
    															"Desc.Volume"	,;
    															"Desc.Qtde" 	COLORS 0, 16777215 PIXEL


	//-----------------------------------------------------------------------------------------------
	//List Box Filial
	//-----------------------------------------------------------------------------------------------
	@ 007, 005 LISTBOX oLstSZB	 	VAR nListBox1 ;
    								Fields HEADER "Filial", "Descrição" ;
    								SIZE 265, 158 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

	oLstSZB:SetArray(aSZB)
	oLstSZB:nAt := 1
	oLstSZB:bLine := { || {aSZB[oLstSZB:nAt,1], aSZB[oLstSZB:nAt,2]}}



    @ 173, 231 BUTTON oBtn1 PROMPT "&Incluir"	ACTION (U_T04IncZB(@oLstSZB,@aSZB));
    												SIZE 037, 012 OF oFolder1:aDialogs[1] PIXEL

    @ 172, 189 BUTTON oBtn2 PROMPT "&Excluir" 	ACTION (U_T04ExcZB(@oLstSZB,@aSZB));
    												SIZE 037, 012 OF oFolder1:aDialogs[1] PIXEL


	//-----------------------------------------------------------------------------------------------
	//List Box Vendedor
	//-----------------------------------------------------------------------------------------------
	@ 007, 005 LISTBOX oLstSZC	 	VAR nListBox1 ;
    								Fields HEADER "Codigo", "Nome", "% Comissao" ;
    								SIZE 285, 158 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

	oLstSZC:SetArray(aSZC)
	oLstSZC:nAt := 1
	oLstSZC:bLine := { || {aSZC[oLstSZC:nAt,1], aSZC[oLstSZC:nAt,2], aSZC[oLstSZC:nAt,3]}}


    @ 172, 108 BUTTON oBtn19 PROMPT "&Limpar Todos"	ACTION (T04ZCLimp(@oLstSZC,@aSZC));
    											SIZE 037, 012 OF oFolder1:aDialogs[2] PIXEL

    @ 172, 148 BUTTON oBtn20 PROMPT "&Importa .CSV"	ACTION (T04ZCImp(@oLstSZC,@aSZC));
    											SIZE 037, 012 OF oFolder1:aDialogs[2] PIXEL

    @ 173, 231 BUTTON oBtn3 PROMPT "&Incluir"	ACTION (U_T04IncZC(@oLstSZC,@aSZC));
    											SIZE 037, 012 OF oFolder1:aDialogs[2] PIXEL

    @ 172, 189 BUTTON oBtn4 PROMPT "&Excluir" 	ACTION (U_T04ExcZC(@oLstSZC,@aSZC));
    											SIZE 037, 012 OF oFolder1:aDialogs[2] PIXEL


	//-----------------------------------------------------------------------------------------------
	//List Box Departamento
	//-----------------------------------------------------------------------------------------------
	@ 007, 005 LISTBOX oLstSZF	 	VAR nListBox1 ;
    								Fields HEADER "Codigo", "Nome" ;
    								SIZE 265, 158 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL

	oLstSZF:SetArray(aSZF)
	oLstSZF:nAt := 1
	oLstSZF:bLine := { || {aSZF[oLstSZF:nAt,1], aSZF[oLstSZF:nAt,2]}}

    @ 173, 231 BUTTON oBtn11 PROMPT "&Incluir"	ACTION (U_T04IncZF(@oLstSZF,@aSZF));
    												SIZE 037, 012 OF oFolder1:aDialogs[3] PIXEL

    @ 172, 189 BUTTON oBtn12 PROMPT "&Excluir" 	ACTION (U_T04ExcZF(@oLstSZF,@aSZF));
    												SIZE 037, 012 OF oFolder1:aDialogs[3] PIXEL

	//-----------------------------------------------------------------------------------------------
	//List Box Cliente
	//-----------------------------------------------------------------------------------------------
	@ 007, 005 LISTBOX oLstSZG	 	VAR nListBox1 ;
    								Fields HEADER "Codigo", "Loja", "Nome" ;
    								SIZE 285, 158 OF oFolder1:aDialogs[4] COLORS 0, 16777215 PIXEL

	oLstSZG:SetArray(aSZG)
	oLstSZG:nAt := 1
	oLstSZG:bLine := { || {aSZG[oLstSZG:nAt,1], aSZG[oLstSZG:nAt,2], aSZG[oLstSZG:nAt,3]}}

    @ 172, 108 BUTTON oBtn21 PROMPT "&Limpar Todos"	ACTION (T04ZGLimp(@oLstSZG,@aSZG));
    											SIZE 037, 012 OF oFolder1:aDialogs[4] PIXEL

    @ 172, 148 BUTTON oBtn22 PROMPT "&Importa .CSV"	ACTION (T04ZGImp(@oLstSZG,@aSZG));
    											SIZE 037, 012 OF oFolder1:aDialogs[4] PIXEL

    @ 173, 231 BUTTON oBtn5 PROMPT "&Incluir"	ACTION (U_T04IncZG(@oLstSZG,@aSZG));
    												SIZE 037, 012 OF oFolder1:aDialogs[4] PIXEL

    @ 172, 189 BUTTON oBtn6 PROMPT "&Excluir" 	ACTION (U_T04ExcZG(@oLstSZG,@aSZG));
    												SIZE 037, 012 OF oFolder1:aDialogs[4] PIXEL


	//-----------------------------------------------------------------------------------------------
	//List Box Estado
	//-----------------------------------------------------------------------------------------------
	@ 007, 005 LISTBOX oLstSZH	 	VAR nListBox1 ;
    								Fields HEADER "Sigla", "Nome" ;
    								SIZE 265, 158 OF oFolder1:aDialogs[5] COLORS 0, 16777215 PIXEL

	oLstSZH:SetArray(aSZH)
	oLstSZH:nAt := 1
	oLstSZH:bLine := { || {aSZH[oLstSZH:nAt,1], aSZH[oLstSZH:nAt,2]}}

    @ 173, 231 BUTTON oBtn9 PROMPT "&Incluir"	ACTION (U_T04IncZH(@oLstSZH,@aSZH));
    												SIZE 037, 012 OF oFolder1:aDialogs[5] PIXEL

    @ 172, 189 BUTTON oBtn10 PROMPT "&Excluir" 	ACTION (U_T04ExcZH(@oLstSZH,@aSZH));
    												SIZE 037, 012 OF oFolder1:aDialogs[5] PIXEL
	//-----------------------------------------------------------------------------------------------
	//List Box Regiao
	//-----------------------------------------------------------------------------------------------
	@ 007, 005 LISTBOX oLstSZI	 	VAR nListBox1 ;
    								Fields HEADER "Cod.Reg", "Descrição" ;
    								SIZE 265, 158 OF oFolder1:aDialogs[6] COLORS 0, 16777215 PIXEL


	oLstSZI:SetArray(aSZI)
	oLstSZI:nAt := 1
	oLstSZI:bLine := { || {aSZI[oLstSZI:nAt,1], aSZI[oLstSZI:nAt,2]}}



    @ 173, 231 BUTTON oBtn7 PROMPT "&Incluir"	ACTION (U_T04IncZI(@oLstSZI,@aSZI));
    												SIZE 037, 012 OF oFolder1:aDialogs[6] PIXEL

    @ 172, 189 BUTTON oBtn8 PROMPT "&Excluir" 	ACTION (U_T04ExcZI(@oLstSZI,@aSZI));
    												SIZE 037, 012 OF oFolder1:aDialogs[6] PIXEL



	//-----------------------------------------------------------------------------------------------
	//List Box Tipo de Pedido
	//-----------------------------------------------------------------------------------------------
	@ 007, 005 LISTBOX oLstSZJ	 	VAR nListBox1 ;
    								Fields HEADER "Tipo Ped", "Descrição" ;
    								SIZE 265, 158 OF oFolder1:aDialogs[7] COLORS 0, 16777215 PIXEL


	oLstSZJ:SetArray(aSZJ)
	oLstSZJ:nAt := 1
	oLstSZJ:bLine := { || {aSZJ[oLstSZJ:nAt,1], aSZJ[oLstSZJ:nAt,2]}}



    @ 173, 231 BUTTON oBtn7 PROMPT "&Incluir"	ACTION (U_T04IncZK(@oLstSZJ,@aSZJ));
    												SIZE 037, 012 OF oFolder1:aDialogs[7] PIXEL

    @ 172, 189 BUTTON oBtn8 PROMPT "&Excluir" 	ACTION (U_T04ExcZK(@oLstSZJ,@aSZJ));
    												SIZE 037, 012 OF oFolder1:aDialogs[7] PIXEL

	//-----------------------------------------------------------------------------------------------
	//List Box Volume
	//-----------------------------------------------------------------------------------------------
	@ 007, 005 LISTBOX oLstSZL	 	VAR nListBox1 ;
    								Fields HEADER "Volume", "% Desconto" ;
    								SIZE 265, 158 OF oFolder1:aDialogs[8] COLORS 0, 16777215 PIXEL


	oLstSZL:SetArray(aSZL)
	oLstSZL:nAt := 1
	oLstSZL:bLine := { || {aSZL[oLstSZL:nAt,1], aSZL[oLstSZL:nAt,2]}}



    @ 173, 231 BUTTON oBtn7 PROMPT "&Incluir"	ACTION (U_T04IncZL(@oLstSZL,@aSZL));
    												SIZE 037, 012 OF oFolder1:aDialogs[8] PIXEL

    @ 172, 189 BUTTON oBtn8 PROMPT "&Excluir" 	ACTION (U_T04ExcZL(@oLstSZL,@aSZL));
    												SIZE 037, 012 OF oFolder1:aDialogs[8] PIXEL


	//-----------------------------------------------------------------------------------------------
	//List Box Quantidade
	//-----------------------------------------------------------------------------------------------
	@ 007, 005 LISTBOX oLstSZM	 	VAR nListBox1 ;
    								Fields HEADER "Quantidade", "% Desconto" ;
    								SIZE 265, 158 OF oFolder1:aDialogs[9] COLORS 0, 16777215 PIXEL


	oLstSZM:SetArray(aSZM)
	oLstSZM:nAt := 1
	oLstSZM:bLine := { || {aSZM[oLstSZM:nAt,1], aSZM[oLstSZM:nAt,2]}}



    @ 173, 231 BUTTON oBtn17 PROMPT "&Incluir"	ACTION (U_T04IncZM(@oLstSZM,@aSZM));
    												SIZE 037, 012 OF oFolder1:aDialogs[9] PIXEL

    @ 172, 189 BUTTON oBtn18 PROMPT "&Excluir" 	ACTION (U_T04ExcZM(@oLstSZM,@aSZM));
    												SIZE 037, 012 OF oFolder1:aDialogs[9] PIXEL

	//-----------------------------------------------------------------------------------------
	//Botão Sair da Rotina
	//-----------------------------------------------------------------------------------------
	@ 227, 298 BUTTON oButton1 PROMPT "&Sair" Action(oDlg1:End()) SIZE 037, 012 OF oDlg1 PIXEL

  ACTIVATE MSDIALOG oDlg1 CENTERED


RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 15/09/2016
Descricao / Objetivo: Cadastro de departamentos
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna o cadastro  Tabela de Preco x Filial
=====================================================================================
*/
Static Function T04SZB( aDados )
Local 	aArea		:= GetArea()
Local	aAreaSM0   	:= SM0->(GetArea())
Local 	cQuery		:= ""
Local 	cAlias1		:= GetNextAlias()

DEFAULT aDados 		:= {}

cQuery := " SELECT ZB_CODFIL  "
cQuery += " FROM "+RetSQLName("SZB") + " SZB  "
cQuery += " WHERE SZB.ZB_FILIAL = '" + xFilial("SZB") + "' "
cQuery += " AND SZB.ZB_CODTAB = '" + DA0->DA0_CODTAB + "' "
cQuery += " AND SZB.D_E_L_E_T_= ' ' "
cQuery += " ORDER BY SZB.ZB_CODFIL "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias1)

If (cAlias1)->(Eof())
	AADD(aDados,{"",""})
Else
	Do While (cAlias1)->(!Eof())
		If cEmpAnt == "99"
		 	aAdd( aDados, { (cAlias1)->ZB_CODFIL, FwFilialName("99", Substr((cAlias1)->ZB_CODFIL,1 ,Len(cEmpAnt))) })
		Else
		 	aAdd( aDados, { (cAlias1)->ZB_CODFIL, FwFilialName(Substr((cAlias1)->ZB_CODFIL,1,2) ,Substr( (cAlias1)->ZB_CODFIL,1 ,Len(cEmpAnt))) })
		Endif
		(cAlias1)->(DbSkip())
	End
Endif

(cAlias1)->(DbCloseArea())


RestArea(aAreaSM0 )
RestArea(aArea )


Return


/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 15/09/2016
Descricao / Objetivo: Cadastro de departamentos
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna o cadastro  Tabela de Preco x Vendedor
=====================================================================================
*/
Static Function T04SZC( aDados )
Local 	aArea		:= GetArea()
Local 	cQuery		:= ""
Local 	cAlias1		:= GetNextAlias()

DEFAULT aDados 		:= {}

cQuery := " SELECT SA3.A3_COD, SA3.A3_NOME, SZC.ZC_PERCOMI "
cQuery += " FROM "+RetSQLName("SZC") + " SZC  "
cQuery += " INNER JOIN "+RetSQLName("SA3") + " SA3 ON A3_COD = SZC.ZC_CODVEND   "
cQuery += " WHERE SZC.ZC_FILIAL = '" + xFilial("SZC") + "' "
cQuery += " AND SZC.ZC_CODTAB = '" + DA0->DA0_CODTAB + "' "
cQuery += " AND SZC.D_E_L_E_T_= ' ' "
cQuery += " ORDER BY SA3.A3_COD "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias1)

If (cAlias1)->(Eof())
	AADD(aDados,{"","",""})
Else
	Do While (cAlias1)->(!Eof())

		aAdd( aDados, { (cAlias1)->A3_COD, (cAlias1)->A3_NOME, (cAlias1)->ZC_PERCOMI} )
		(cAlias1)->(DbSkip())

	End
Endif

(cAlias1)->(DbCloseArea())


Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 15/09/2016
Descricao / Objetivo: Cadastro de departamentos
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna o cadastro  Tabela de Preco x Vendedor
=====================================================================================
*/
Static Function T04SZF( aDados )
Local 	aArea		:= GetArea()
Local 	cQuery		:= ""
Local 	cAlias1		:= GetNextAlias()

DEFAULT aDados 		:= {}

cQuery := " SELECT SZD.ZD_COD, SZD.ZD_NOME "
cQuery += " FROM "+RetSQLName("SZF") + " SZF  "
cQuery += " INNER JOIN "+RetSQLName("SZD") + " SZD ON SZD.ZD_COD = SZF.ZF_CODDEP   "
cQuery += " WHERE SZF.ZF_FILIAL = '" + xFilial("SZF") + "' "
cQuery += " AND SZF.ZF_CODTAB = '" + DA0->DA0_CODTAB + "' "
cQuery += " AND SZF.D_E_L_E_T_= ' ' "
cQuery += " ORDER BY SZD.ZD_COD "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias1)

If (cAlias1)->(Eof())
	AADD(aDados,{"",""})
Else
	Do While (cAlias1)->(!Eof())

		aAdd( aDados, { (cAlias1)->ZD_COD, (cAlias1)->ZD_NOME} )
		(cAlias1)->(DbSkip())
	End
Endif

(cAlias1)->(DbCloseArea())


Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 15/09/2016
Descricao / Objetivo: Cadastro de departamentos
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna o cadastro  Tabela de Preco x Vendedor
=====================================================================================
*/
Static Function T04SZG( aDados )
Local 	aArea		:= GetArea()
Local 	cQuery		:= ""
Local 	cAlias1		:= GetNextAlias()

DEFAULT aDados 		:= {}

cQuery := " SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME "
cQuery += " FROM "+RetSQLName("SZG") + " SZG  "
cQuery += " INNER JOIN "+RetSQLName("SA1") + " SA1 ON SA1.A1_COD = SZG.ZG_CODCLI AND SA1.A1_LOJA = SZG.ZG_LOJCLI   "
cQuery += " WHERE SZG.ZG_FILIAL = '" + xFilial("SZG") + "' "
cQuery += " AND SZG.ZG_CODTAB = '" + DA0->DA0_CODTAB + "' "
cQuery += " AND SZG.D_E_L_E_T_= ' ' "
cQuery += " ORDER BY SA1.A1_COD,SA1.A1_LOJA "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias1)

If (cAlias1)->(Eof())
	AADD(aDados,{"","",""})
Else
	Do While (cAlias1)->(!Eof())

		aAdd( aDados, { (cAlias1)->A1_COD, (cAlias1)->A1_LOJA,(cAlias1)->A1_NOME} )
		(cAlias1)->(DbSkip())

	End
Endif

(cAlias1)->(DbCloseArea())

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 15/09/2016
Descricao / Objetivo: Cadastro de departamentos
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna o cadastro  Tabela de Preco x Estado
=====================================================================================
*/
Static Function T04SZH( aDados )
Local 	aArea		:= GetArea()
Local 	cQuery		:= ""
Local 	cAlias1		:= GetNextAlias()

DEFAULT aDados 		:= {}

cQuery := " SELECT SX5.X5_CHAVE, SX5.X5_DESCRI "
cQuery += " FROM "+RetSQLName("SZH") + " SZH  "
cQuery += " INNER JOIN "+RetSQLName("SX5") + " SX5 ON SX5.X5_TABELA ='12' AND SX5.X5_CHAVE = SZH.ZH_CODEST   "
cQuery += " WHERE SZH.ZH_FILIAL = '" + xFilial("SZH") + "' "
cQuery += " AND SZH.ZH_CODTAB = '" + DA0->DA0_CODTAB + "' "
cQuery += " AND SZH.D_E_L_E_T_= ' ' "
cQuery += " ORDER BY SX5.X5_CHAVE "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias1)

If (cAlias1)->(Eof())
	AADD(aDados,{"",""})
Else
	Do While (cAlias1)->(!Eof())

		aAdd( aDados, { (cAlias1)->X5_CHAVE, (cAlias1)->X5_DESCRI} )
		(cAlias1)->(DbSkip())

	End
Endif

(cAlias1)->(DbCloseArea())


Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 15/09/2016
Descricao / Objetivo: Cadastro de departamentos
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna o cadastro  Tabela de Preco x Regiao
=====================================================================================
*/
Static Function T04SZI( aDados )
Local 	aArea		:= GetArea()
Local 	cQuery		:= ""
Local 	cAlias1		:= GetNextAlias()

DEFAULT aDados 		:= {}

cQuery := " SELECT ZP_CODREG, ZP_DESCREG "
cQuery += " FROM "+RetSQLName("SZI") + " SZI  "
cQuery += " INNER JOIN "+RetSQLName("SZP") + " SZP ON SZP.ZP_CODREG = SZI.ZI_CODREG   "
cQuery += " WHERE SZI.ZI_FILIAL = '" + xFilial("SZI") + "' "
cQuery += " AND SZI.ZI_CODTAB = '" + DA0->DA0_CODTAB + "' "
cQuery += " AND SZI.D_E_L_E_T_= ' ' "
cQuery += " ORDER BY SZP.ZP_CODREG "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias1)

If (cAlias1)->(Eof())
	AADD(aDados,{"",""})
Else
	Do While (cAlias1)->(!Eof())

		aAdd( aDados, { (cAlias1)->ZP_CODREG, (cAlias1)->ZP_DESCREG} )
		(cAlias1)->(DbSkip())

	End
Endif

(cAlias1)->(DbCloseArea())


Return


/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 15/09/2016
Descricao / Objetivo: Cadastro de departamentos
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna o cadastro  Tabela de Preco x Tipo de Pedido
=====================================================================================
*/
Static Function T04SZJ( aDados )
Local 	aArea		:= GetArea()
Local 	cQuery		:= ""
Local 	cAlias1		:= GetNextAlias()

DEFAULT aDados 		:= {}

cQuery := " SELECT ZJ_COD, ZJ_NOME "
cQuery += " FROM "+RetSQLName("SZK") + " SZK  "
cQuery += " INNER JOIN "+RetSQLName("SZJ") + " SZJ ON SZJ.ZJ_COD = SZK.ZK_CODTPED   "
cQuery += " WHERE SZK.ZK_FILIAL = '" + xFilial("SZK") + "' "
cQuery += " AND SZK.ZK_CODTAB = '" + DA0->DA0_CODTAB + "' "
cQuery += " AND SZK.D_E_L_E_T_= ' ' "
cQuery += " AND SZJ.D_E_L_E_T_= ' ' "
cQuery += " ORDER BY SZK.ZK_CODTPED "

cQuery := ChangeQuery(cQuery)

//MEMOWRITE("C:\TEMP\" + funName() + ".sql", cQuery)

dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias1)

If (cAlias1)->(Eof())
	AADD(aDados,{"",""})
Else
	Do While (cAlias1)->(!Eof())

		aAdd( aDados, { (cAlias1)->ZJ_COD, (cAlias1)->ZJ_NOME} )
		(cAlias1)->(DbSkip())

	End
Endif

(cAlias1)->(DbCloseArea())


Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 15/09/2016
Descricao / Objetivo: Cadastro de departamentos
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna o cadastro  Tabela de Preco x Regiao
=====================================================================================
*/
Static Function T04SZL( aDados )
Local 	aArea		:= GetArea()
Local 	cQuery		:= ""
Local 	cAlias1		:= GetNextAlias()

DEFAULT aDados 		:= {}

cQuery := " SELECT ZL_VOLUME, ZL_PERDESC "
cQuery += " FROM "+RetSQLName("SZL") + " SZL  "
cQuery += " WHERE SZL.ZL_FILIAL = '" + xFilial("SZL") + "' "
cQuery += " AND SZL.ZL_CODTAB = '" + DA0->DA0_CODTAB + "' "
cQuery += " AND SZL.D_E_L_E_T_= ' ' "
cQuery += " ORDER BY SZL.ZL_VOLUME "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias1)

If (cAlias1)->(Eof())
	AADD(aDados,{"",""})
Else
	Do While (cAlias1)->(!Eof())

		aAdd( aDados, { (cAlias1)->ZL_VOLUME, (cAlias1)->ZL_PERDESC} )
		(cAlias1)->(DbSkip())

	End
Endif

(cAlias1)->(DbCloseArea())


Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 15/09/2016
Descricao / Objetivo: Cadastro de departamentos
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna o cadastro  Tabela de Preco x Quantidade
=====================================================================================
*/
Static Function T04SZM( aDados )
Local 	aArea		:= GetArea()
Local 	cQuery		:= ""
Local 	cAlias1		:= GetNextAlias()

DEFAULT aDados 		:= {}

cQuery := " SELECT ZM_QTDE, ZM_PERDESC "
cQuery += " FROM "+RetSQLName("SZM") + " SZM  "
cQuery += " WHERE SZM.ZM_FILIAL = '" + xFilial("SZM") + "' "
cQuery += " AND SZM.ZM_CODTAB = '" + DA0->DA0_CODTAB + "' "
cQuery += " AND SZM.D_E_L_E_T_= ' ' "
cQuery += " ORDER BY SZM.ZM_QTDE "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias1)

If (cAlias1)->(Eof())
	AADD(aDados,{"",""})
Else
	Do While (cAlias1)->(!Eof())

		aAdd( aDados, { (cAlias1)->ZM_QTDE, (cAlias1)->ZM_PERDESC} )
		(cAlias1)->(DbSkip())

	End
Endif

(cAlias1)->(DbCloseArea())


Return


/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Adiciona opcao no menu da tabela de preco
=====================================================================================
*/
User Function FAT04Menu()

aAdd(aRotina,{"MGF-Dados Adicionais"			,"u_MGFFAT04"		, 0, 3, 0, .F. }) 	//"Legenda"
//aAdd(aRotina,{"MGF-Importa Tab.Preco"			,"u_FAT01ImpTab"	, 0, 3, 0, .F. }) 	//"Legenda"
aAdd(aRotina,{"MGF-Copiar Tabela"				,"u_FAT01Cpy"		, 0, 3, 0, .F. })
aAdd(aRotina,{"MGF-Clientes E-COMERC"			,"u_EXEFAT94"		, 0, 3, 0, .F. })
aadd(aRotina,{OemtoAnsi("TXT Bal.Toledo")		,"u_txtbal()"		, 0, 2 })

Return()


/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro de Filial x Tabela de Preco
=====================================================================================
*/
User Function T04IncZB(oLstSZ, aSZ)
Local aArea		:= GetArea()
Local oButton1
Local oButton2
Local oGet1
Local oGet2
Local oGroup1
Local oSay1
Local oSay2
Local oDlg3
Local cCod		:= Space(Len(cFilAnt))
Local cDescr	:= Space(60)

  dbSelectArea('SX3')
  SX3->(dbSetOrder(2))
  SX3->(dbSeek('A1_COD'))

  DEFINE MSDIALOG oDlg3 TITLE "Filial x Tabela de Preço" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 010, 007 GROUP oGroup1 TO 080, 225 PROMPT "" OF oDlg3 COLOR 0, 16777215 	PIXEL
    @ 020, 016 SAY 		oSay1 	PROMPT "Filial" 								SIZE 041, 012 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 016 MSGET 	oGet1 	VAR cCod PICTURE("@!") 												;
    							Valid(T4ValSZB(cCod,@cDescr))					;
																						SIZE 037, 010 OF oDlg3 COLORS 0, 16777215 F3 "SM0" PIXEL
	oGet1:bHelp := {||    ShowHelpCpo(    "cCod",;
                        {"Informe o código da filial."},2,;
                        {"Solução"},2)}

    @ 020, 064 SAY 		oSay2 PROMPT "Descrição" 										SIZE 046, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 064 MSGET 	oGet2 VAR cDescr 												SIZE 152, 010 OF oDlg3 COLORS 0, 16777215 PIXEL

	oGet2:bHelp := {||    ShowHelpCpo(    "cDescr",;
                        {"Descrição da filial."},2,;
                        {"Solução"},2)}

    @ 053, 135 BUTTON oButton2 PROMPT "Confirmar" 		Action(	IIF(T4GRVSZB(@oLstSZ,@aSZ,cCod,cDescr),oDlg3:End(),)) 	SIZE 037, 012 OF oDlg3 PIXEL

    @ 053, 178 BUTTON oButton1 PROMPT "Cancelar" 										;
    							ACTION( oDlg3:End()  )									SIZE 037, 012 OF oDlg3 PIXEL


  ACTIVATE MSDIALOG oDlg3 CENTERED


RestArea(aArea)

Return


/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro de Vendedor x Tabela de Preco
=====================================================================================
*/
User Function T04IncZC(oLstSZ, aSZ)
Local aArea		:= GetArea()
Local oButton1
Local oButton2
Local oGet1
Local oGet2
Local oGet3

Local oGroup1

Local oSay1
Local oSay2
Local oSay3

Local oDlg3
Local cCod		:= Space(TamSx3("A3_COD")[1])
Local cDescr	:= Space(TamSx3("A3_NOME")[1])
Local nPerComis	:=0

  DEFINE MSDIALOG oDlg3 TITLE "Vendedor x Tabela de Preço" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 010, 007 GROUP oGroup1 TO 093, 226 PROMPT "" OF oDlg3 COLOR 0, 16777215 		PIXEL
    @ 020, 016 SAY 		oSay1 	PROMPT "Codigo" 									SIZE 041, 012 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 016 MSGET 	oGet1 	VAR cCod PICTURE("@!") 											;
    							Valid(T4ValSZC(cCod,@cDescr))						;
																					SIZE 037, 010 OF oDlg3 COLORS 0, 16777215 F3 "SA3" PIXEL
	oGet1:bHelp := {||    ShowHelpCpo(    "cCod",;
                        {"Informe o código do vendedor."},2,;
                        {"Solução"},2)}

    @ 020, 064 SAY 		oSay2 	PROMPT "Nome" 										SIZE 046, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 064 MSGET 	oGet2 	VAR cDescr 											SIZE 152, 010 OF oDlg3 COLORS 0, 16777215 PIXEL

	oGet2:bHelp := {||    ShowHelpCpo(    "cDescr",;
                        {"Nome do vendedor."},2,;
                        {"Solução"},2)}

    @ 052, 016 SAY 		oSay3 PROMPT "% Comissao" 									SIZE 041, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 064, 015 MSGET 	oGet3 VAR nPerComis Picture PesqPict( "SZC","ZC_PERCOMI" ) 	SIZE 037, 010 OF oDlg3 COLORS 0, 16777215 PIXEL

	oGet3:bHelp := {||    ShowHelpCpo(    "nPerComis",;
                        {"Percentual de comissão para a tabela."},2,;
                        {"Solução"},2)}

    @ 064, 135 BUTTON oButton2 	PROMPT "Confirmar" 		Action(	IIF(T4GRVSZC(@oLstSZ,@aSZ,cCod,cDescr,nPerComis),oDlg3:End(),))	SIZE 037, 012 OF oDlg3 PIXEL
    @ 064, 178 BUTTON oButton1 	PROMPT "Cancelar" 								;
    							ACTION( oDlg3:End()  )							SIZE 037, 012 OF oDlg3 PIXEL


  ACTIVATE MSDIALOG oDlg3 CENTERED


RestArea(aArea)

Return


/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro de Departamento x Tabela de Preco
=====================================================================================
*/
User Function T04IncZF(oLstSZ, aSZ)
Local aArea		:= GetArea()
Local oButton1
Local oButton2
Local oGet1
Local oGet2
Local oGroup1
Local oSay1
Local oSay2
Local oDlg3
Local cCod		:= Space(TamSx3("ZD_COD")[1])
Local cDescr	:= Space(TamSx3("ZD_NOME")[1])

  DEFINE MSDIALOG oDlg3 TITLE "Departamento x Tabela de Preço" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 010, 007 GROUP oGroup1 TO 080, 225 PROMPT "" OF oDlg3 COLOR 0, 16777215 	PIXEL
    @ 020, 016 SAY 		oSay1 	PROMPT "Codigo" 								SIZE 041, 012 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 016 MSGET 	oGet1 	VAR cCod PICTURE("@!") 										;
    							Valid(T4ValSZF(cCod,@cDescr))					;
																				SIZE 037, 010 OF oDlg3 COLORS 0, 16777215 F3 "SZD" PIXEL
	oGet1:bHelp := {||    ShowHelpCpo(    "cCod",;
                        {"Informe o código do departamento."},2,;
                        {"Solução"},2)}

    @ 020, 064 SAY 		oSay2 	PROMPT "Nome" 									SIZE 046, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 064 MSGET 	oGet2 	VAR cDescr 										SIZE 152, 010 OF oDlg3 COLORS 0, 16777215 PIXEL

	oGet2:bHelp := {||    ShowHelpCpo(    "cDescr",;
                        {"Departamento."},2,;
                        {"Solução"},2)}

    @ 053, 135 BUTTON oButton2 	PROMPT "Confirmar" 		Action(	IIF(T4GRVSZF(@oLstSZ,@aSZ,cCod,cDescr),oDlg3:End(),))	SIZE 037, 012 OF oDlg3 PIXEL

    @ 053, 178 BUTTON oButton1 	PROMPT "Cancelar" 								;
    							ACTION( oDlg3:End()  )							SIZE 037, 012 OF oDlg3 PIXEL


  ACTIVATE MSDIALOG oDlg3 CENTERED


RestArea(aArea)

Return



/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro de Cliente x Tabela de Preco
=====================================================================================
*/
User Function T04IncZG(oLstSZ, aSZ)
Local aArea		:= GetArea()
Local oButton1
Local oButton2
Local oGet1
Local oGet2
Local oGroup1
Local oSay1
Local oSay2
Local oDlg3
Local cCod		:= Space(TamSx3("A1_COD")[1])
Local cLoja		:= Space(TamSx3("A1_LOJA")[1])
Local cDescr	:= Space(TamSx3("A1_NOME")[1])

  DEFINE MSDIALOG oDlg3 TITLE "Cliente x Tabela de Preço" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 010, 007 GROUP oGroup1 TO 080, 244 PROMPT "" OF oDlg3 COLOR 0, 16777215 	PIXEL

    @ 020, 016 SAY 		oSay1 	PROMPT "Codigo" 								SIZE 031, 012 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 016 MSGET 	oGet1 	VAR cCod PICTURE("@!") 										;
    							Valid(T4ValSZG(cCod, cLoja, @cDescr))			;
																				SIZE 037, 010 OF oDlg3 COLORS 0, 16777215 F3 "SA1" PIXEL
	oGet1:bHelp := {||    ShowHelpCpo(    "cCod",;
                        {"Informe o código do cliente."},2,;
                        {"Solução"},2)}

    @ 020, 056 SAY oSay3 PROMPT "Loja" 											SIZE 019, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 056 MSGET oGet3 VAR  cLoja 											;
    							Valid(T4ValSZG(cCod, cLoja, @cDescr))			SIZE 019, 010 OF oDlg3 COLORS 0, 16777215 PIXEL

	oGet3:bHelp := {||    ShowHelpCpo(    "cLoja",;
                        {"Loja do cliente."},2,;
                        {"Solução"},2)}

    @ 020, 082 SAY 		oSay2 	PROMPT "Nome" 									SIZE 046, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 082 MSGET 	oGet2 	VAR cDescr 										SIZE 152, 010 OF oDlg3 COLORS 0, 16777215 PIXEL

	oGet2:bHelp := {||    ShowHelpCpo(    "cDescr",;
                        {"Nome do cliente."},2,;
                        {"Solução"},2)}

    @ 053, 153 BUTTON oButton2 	PROMPT "Confirmar" 		Action(	IIF(T4GRVSZG(@oLstSZ,@aSZ,cCod,cLoja,cDescr),oDlg3:End(),))	SIZE 037, 012 OF oDlg3 PIXEL

    @ 053, 195 BUTTON oButton1 	PROMPT "Cancelar" 								;
    							ACTION( oDlg3:End()  )							SIZE 037, 012 OF oDlg3 PIXEL


  ACTIVATE MSDIALOG oDlg3 CENTERED



RestArea(aArea)

Return


/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro de Estado x Tabela de Preco
=====================================================================================
*/
User Function T04IncZH(oLstSZ, aSZ)
Local aArea		:= GetArea()
Local oButton1
Local oButton2
Local oGet1
Local oGet2
Local oGroup1
Local oSay1
Local oSay2
Local oDlg3
Local cCod		:= Space(2)
Local cDescr	:= Space(60)

  DEFINE MSDIALOG oDlg3 TITLE "Estado x Tabela de Preço" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 010, 007 GROUP oGroup1 TO 080, 225 PROMPT "" OF oDlg3 COLOR 0, 16777215 	PIXEL
    @ 020, 016 SAY 		oSay1 	PROMPT "Sigla" 								SIZE 041, 012 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 016 MSGET 	oGet1 	VAR cCod  PICTURE("@!")										;
    							Valid(T4ValSZH(cCod,@cDescr))					;
																				SIZE 037, 010 OF oDlg3 COLORS 0, 16777215 F3 "12" PIXEL
	oGet1:bHelp := {||    ShowHelpCpo(    "cCod",;
                        {"Informe o Estado."},2,;
                        {"Solução"},2)}

    @ 020, 064 SAY 		oSay2 	PROMPT "Nome" 									SIZE 046, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 064 MSGET 	oGet2 	VAR cDescr 										SIZE 152, 010 OF oDlg3 COLORS 0, 16777215 PIXEL

	oGet2:bHelp := {||    ShowHelpCpo(    "cDescr",;
                        {"Nome do Estado."},2,;
                        {"Solução"},2)}

    @ 053, 135 BUTTON oButton2 	PROMPT "Confirmar" 		Action(	IIF(T4GRVSZH(@oLstSZ,@aSZ,cCod,cDescr),oDlg3:End(),))	SIZE 037, 012 OF oDlg3 PIXEL

    @ 053, 178 BUTTON oButton1 	PROMPT "Cancelar" 								;
    							ACTION( oDlg3:End()  )							SIZE 037, 012 OF oDlg3 PIXEL


  ACTIVATE MSDIALOG oDlg3 CENTERED


RestArea(aArea)

Return


/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro de Regiao x Tabela de Preco
=====================================================================================
*/
User Function T04IncZI(oLstSZ, aSZ)
Local aArea		:= GetArea()
Local oButton1
Local oButton2
Local oGet1
Local oGet2
Local oGroup1
Local oSay1
Local oSay2
Local oDlg3
Local cCod		:= Space(3)
Local cDescr	:= Space(60)


  DEFINE MSDIALOG oDlg3 TITLE "Regiao x Tabela de Preço" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 010, 007 GROUP oGroup1 TO 080, 225 PROMPT "" OF oDlg3 COLOR 0, 16777215 	PIXEL
    @ 020, 016 SAY 		oSay1 	PROMPT "Cod.Reg" 								SIZE 041, 012 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 016 MSGET 	oGet1 	VAR cCod PICTURE("@!") 										;
    							Valid(T4ValSZI(cCod,@cDescr))					;
																				SIZE 037, 010 OF oDlg3 COLORS 0, 16777215 F3 "SZP" PIXEL
	oGet1:bHelp := {||    ShowHelpCpo(    "cCod",;
                        {"Informe o código da região."},2,;
                        {"Solução"},2)}

    @ 020, 064 SAY 		oSay2 	PROMPT "Nome" 									SIZE 046, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 064 MSGET 	oGet2 	VAR cDescr 										SIZE 152, 010 OF oDlg3 COLORS 0, 16777215 PIXEL

	oGet2:bHelp := {||    ShowHelpCpo(    "cDescr",;
                        {"Nome da Região."},2,;
                        {"Solução"},2)}

    @ 053, 135 BUTTON oButton2 	PROMPT "Confirmar" 		Action(	IIF(T4GRVSZI(@oLstSZ,@aSZ,cCod,cDescr),oDlg3:End(),))	SIZE 037, 012 OF oDlg3 PIXEL

    @ 053, 178 BUTTON oButton1 	PROMPT "Cancelar" 								;
    							ACTION( oDlg3:End()  )							SIZE 037, 012 OF oDlg3 PIXEL


  ACTIVATE MSDIALOG oDlg3 CENTERED


RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro de Tipo de Pedido x Tabela de Preco
=====================================================================================
*/
User Function T04IncZK(oLstSZJ, aSZJ)
Local aArea		:= GetArea()
Local oButton1
Local oButton2
Local oGet1
Local oGet2
Local oGroup1
Local oSay1
Local oSay2
Local oDlg2
Local cCodTPed	:= Space(TamSx3("ZJ_COD")[1])
Local cNomTped	:= Space(TamSx3("ZJ_NOME")[1])


  DEFINE MSDIALOG oDlg2 TITLE "Tipo de Pedido x Tabela de Preço" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 010, 007 GROUP oGroup1 TO 080, 225 PROMPT "" OF oDlg2 COLOR 0, 16777215 PIXEL
    @ 020, 016 SAY 		oSay1 	PROMPT "Tipo de Pedido" 								SIZE 041, 012 OF oDlg2 COLORS 0, 16777215 PIXEL
    @ 033, 016 MSGET 	oGet1 	VAR cCodTPed PICTURE("@!") 											;
    							Valid(T04ValSZK(cCodTPed,@cNomTped))					;
																						SIZE 037, 010 OF oDlg2 COLORS 0, 16777215 F3 "SZJ" PIXEL
	oGet1:bHelp := {||    ShowHelpCpo(    "cCod",;
                        {"Informe o tipo de pedido."},2,;
                        {"Solução"},2)}


    @ 020, 064 SAY 		oSay2 PROMPT "Descrição" 										SIZE 046, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
    @ 033, 064 MSGET 	oGet2 VAR cNomTped 												SIZE 152, 010 OF oDlg2 COLORS 0, 16777215 PIXEL

	oGet2:bHelp := {||    ShowHelpCpo(    "cDescr",;
                        {"Tipo de pedido."},2,;
                        {"Solução"},2)}

    @ 053, 135 BUTTON oButton2 PROMPT "Confirmar" 		Action(	IIF(T4GRVSZK(@oLstSZJ,@aSZJ,cCodTPed,cNomTped),oDlg2:End(),))	SIZE 037, 012 OF oDlg2 PIXEL

    @ 053, 178 BUTTON oButton1 PROMPT "Cancelar" 										;
    							ACTION( oDlg2:End()  )									SIZE 037, 012 OF oDlg2 PIXEL


  ACTIVATE MSDIALOG oDlg2 CENTERED


RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro Volume x Tabela de Preco
=====================================================================================
*/
User Function T04IncZL(oLstSZ, aSZ)
Local aArea		:= GetArea()
Local oButton1
Local oButton2
Local oGet1
Local oGet2
Local oGroup1
Local oSay1
Local oSay2
Local oDlg3
Local nVolume	:= 0
Local nPerc		:= 0


  DEFINE MSDIALOG oDlg3 TITLE "Volume x Tabela de Preço" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 010, 007 GROUP oGroup1 TO 080, 168 PROMPT "" OF oDlg3 COLOR 0, 16777215 			PIXEL
    @ 020, 016 SAY 		oSay1 	PROMPT "Volume" 										SIZE 041, 012 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 016 MSGET 	oGet1 	VAR nVolume  Picture PesqPict( "SZL","ZL_VOLUME" )		;
    							Valid(T4ValSZL(nVolume,nPerc))							;
																						SIZE 052, 010 OF oDlg3 COLORS 0, 16777215 PIXEL
	oGet1:bHelp := {||    ShowHelpCpo(    "cCod",;
                        {"Informe o volume para desconto."},2,;
                        {"Solução"},2)}


    @ 020, 089 SAY 		oSay2 PROMPT "% Desconto" 										SIZE 046, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 089 MSGET 	oGet2 VAR nPerc Picture PesqPict( "SZL","ZL_PERDESC" )			SIZE 052, 010 OF oDlg3 COLORS 0, 16777215 PIXEL

	oGet2:bHelp := {||    ShowHelpCpo(    "nPerc",;
                        {"% de desconto para o volume."},2,;
                        {"Solução"},2)}

    @ 059, 056 BUTTON oButton2 PROMPT "Confirmar" 		Action(	IIF(T4GRVSZL(@oLstSZ,@aSZ,nVolume,nPerc),oDlg3:End(),))	SIZE 037, 012 OF oDlg3 PIXEL

    @ 059, 103 BUTTON oButton1 PROMPT "Cancelar" 										;
    							ACTION( oDlg3:End()  )									SIZE 037, 012 OF oDlg3 PIXEL


  ACTIVATE MSDIALOG oDlg3 CENTERED


RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro Quantidade x Tabela de Preco
=====================================================================================
*/
User Function T04IncZM(oLstSZ, aSZ)
Local aArea		:= GetArea()
Local oButton1
Local oButton2
Local oGet1
Local oGet2
Local oGroup1
Local oSay1
Local oSay2
Local oDlg3
Local nQtde		:= 0
Local nPerc		:= 0


  DEFINE MSDIALOG oDlg3 TITLE "Quantidade x Tabela de Preço" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 010, 007 GROUP oGroup1 TO 080, 168 PROMPT "" OF oDlg3 COLOR 0, 16777215 			PIXEL
    @ 020, 016 SAY 		oSay1 	PROMPT "Quantidade" 									SIZE 041, 012 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 016 MSGET 	oGet1 	VAR nQtde  Picture PesqPict( "SZM","ZM_QTDE" )			;
    							Valid(T4ValSZM(nQtde,nPerc))							;
																						SIZE 052, 010 OF oDlg3 COLORS 0, 16777215 PIXEL

	oGet1:bHelp := {||    ShowHelpCpo(    "cCod",;
                        {"Informe a quantidade para desconto."},2,;
                        {"Solução"},2)}

    @ 020, 089 SAY 		oSay2 PROMPT "% Desconto" 										SIZE 046, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
    @ 033, 089 MSGET 	oGet2 VAR nPerc Picture PesqPict( "SZM","ZM_PERDESC" )			SIZE 052, 010 OF oDlg3 COLORS 0, 16777215 PIXEL

	oGet2:bHelp := {||    ShowHelpCpo(    "nPerc",;
                        {"% de desconto para a quantidade."},2,;
                        {"Solução"},2)}

    @ 059, 056 BUTTON oButton2 PROMPT "Confirmar" 		Action(	IIF(T4GRVSZM(@oLstSZ,@aSZ,nQtde,nPerc),oDlg3:End(),))	SIZE 037, 012 OF oDlg3 PIXEL

    @ 059, 103 BUTTON oButton1 PROMPT "Cancelar" 										;
    							ACTION( oDlg3:End()  )									SIZE 037, 012 OF oDlg3 PIXEL


  ACTIVATE MSDIALOG oDlg3 CENTERED


RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Valida se o tipo de pedido esta vinculado à tabela de preço
=====================================================================================
*/
Static Function T4ValSZB(xCod,xNom)
Local aArea	:= SM0->(GetArea())
Local lRet	:= .T.

//--------------------------------------------------------------
//Valida se ja existe o codigo tipo de pedido x tabela de preco
//--------------------------------------------------------------
If !Empty(xCod)
	DbSelectArea("SZB")
	DbSetOrder(1)
	If DbSeek(xFilial("SZB")+DA0->DA0_CODTAB+xCod)
		Alert("Filial já cadastrada para esta tabela de preço!")
		xNom	:= " "
		lRet	:= .F.
	Else

		xCod := Substr(xCod,1,Len(cFilant))

		DbSelectArea("SM0")
		DbSetOrder(1)
		If DbSeek(cEmpAnt+xCod)
			xNom	:= SM0->M0_NOME
		Else
			Alert("Filial não encontrada!")
			xNom	:= Space(60)
			lRet	:= .F.
		Endif
	Endif
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Valida se o vendedor esta vinculado à tabela de preço
=====================================================================================
*/
Static Function T4ValSZC(xCod,xDesc)
Local aArea	:= GetArea()
Local lRet	:= .T.

//--------------------------------------------------------------
//Valida se ja existe o codigo tipo de pedido x tabela de preco
//--------------------------------------------------------------
If !Empty(xCod)
	DbSelectArea("SZC")
	DbSetOrder(1)
	If DbSeek(xFilial("SZC")+DA0->DA0_CODTAB+xCod)
		Alert("Vendedor já cadastrado para esta tabela de preço!")
		xDesc		:= " "
		lRet		:= .F.
	Else
		DbSelectArea("SA3")
		DbSetOrder(1)
		If DbSeek(xFilial("SA3")+xCod)
			xDesc	:= SA3->A3_NOME
		Else
			Alert("Vendedor não encontrado!")
			xDesc		:= " "
			lRet		:= .F.
		Endif
	Endif
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Valida se o departamento esta vinculado à tabela de preço
=====================================================================================
*/
Static Function T4ValSZF(xCod,xDesc)
Local aArea	:= GetArea()
Local lRet	:= .T.

If !Empty(xCod)
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZF")
	DbSetOrder(1)
	If DbSeek(xFilial("SZF")+DA0->DA0_CODTAB+xCod)
		Alert("Departamento já cadastrado para esta tabela de preço!")
		xDesc		:= " "
		lRet		:= .F.
	Else
		DbSelectArea("SZD")
		DbSetOrder(1)
		If DbSeek(xFilial("SZD")+xCod)
			xDesc	:= SZD->ZD_NOME
		Else
			Alert("Departamento não encontrado!")
			xDesc		:= " "
			lRet		:= .F.
		Endif
	Endif
Endif
RestArea(aArea)

Return(lRet)


/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Valida se o cliente esta vinculado à tabela de preço
=====================================================================================
*/
Static Function T4ValSZG(xCod,xLoja,xDesc, lGrava)
Local aArea		:= GetArea()
Local lRet		:= .T.
DEFAULT xLoja	:= Space(TamSx3("A1_LOJA")[1])
DEFAULT xDesc	:= ""
default lGrava	:= .F.

if lGrava
	if empty(xCod) .or. empty(xLoja)
		msgAlert("Cliente e/ou Loja vazio!")
		return .F.
	endif
endif

If !Empty(xCod+xLoja)
	//--------------------------------------------------------------
	//Valida se ja existe o Cliente x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZG")
	DbSetOrder(1)
	If DbSeek(xFilial("SZG")+DA0->DA0_CODTAB+xCod+xLoja)
		Alert("Cliente já cadastrado para esta tabela de preço!")
		xDesc		:= " "
		lRet		:= .F.
	Else
		DbSelectArea("SA1")
		DbSetOrder(1)
		If Empty(xLoja)
			If DbSeek(xFilial("SA1")+xCod)
				xDesc	:= SA1->A1_NOME
			Else
				Alert("Cliente não encontrado!")
				xDesc		:= " "
				lRet		:= .F.
			Endif
		Else
			If DbSeek(xFilial("SA1")+xCod+xLoja)
				xDesc	:= SA1->A1_NOME
	        Else
				Alert("Cliente não encontrado!")
				xDesc		:= " "
				lRet		:= .F.
			Endif
		Endif
	Endif
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Valida se o Estado esta vinculado à tabela de preço
=====================================================================================
*/
Static Function T4ValSZH(xCod,xDesc)
Local 	aArea		:= GetArea()
Local 	lRet		:= .T.
Local 	cQuery		:= ""
Local 	cAlias1		:= GetNextAlias()

If !Empty(xCod)
	//--------------------------------------------------------------
	//Valida se ja existe o Cliente x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZH")
	DbSetOrder(1)
	If DbSeek(xFilial("SZH")+DA0->DA0_CODTAB+xCod)
		Alert("Estado já cadastrado para esta tabela de preço!")
		xDesc		:= " "
		lRet		:= .F.
	Else
		cQuery := " SELECT SX5.X5_CHAVE, SX5.X5_DESCRI "
		cQuery += " FROM "+RetSQLName("SX5") + " SX5  "
		cQuery += " WHERE SX5.X5_FILIAL = '" + xFilial("SX5") + "' "
		cQuery += " AND SX5.X5_TABELA ='12' "
		cQuery += " AND SX5.X5_CHAVE = '" + xCod + "' "
		cQuery += " AND SX5.D_E_L_E_T_= ' ' "

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias1)

		If (cAlias1)->(Eof())
			Alert("Estado não encontrado!")
			xDesc		:= " "
			lRet		:= .F.
		Else
			xDesc	:= (cAlias1)->X5_DESCRI
		Endif

	Endif
Endif

(cAlias1)->(DbCloseArea())

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Valida se a regiao esta vinculado à tabela de preço
=====================================================================================
*/
Static Function T4ValSZI(xCod,xDesc)
Local aArea	:= GetArea()
Local lRet	:= .T.

If !Empty(xCod)
	//--------------------------------------------------------------
	//Valida se ja existe o Cliente x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZI")
	DbSetOrder(1)
	If DbSeek(xFilial("SZI")+DA0->DA0_CODTAB+xCod)
		Alert("Regiao já cadastrada para esta tabela de preço!")
		xDesc		:= " "
		lRet		:= .F.
	Else
		DbSelectArea("SZP")
		DbSetOrder(1)
		If DbSeek(xFilial("SZP")+xCod)
			xDesc	:= SZP->ZP_DESCREG
		Else
			Alert("Regiao não encontrada!")
			xDesc		:= " "
			lRet		:= .F.
		Endif
	Endif
Endif

RestArea(aArea)

Return(lRet)



/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Valida se o tipo de pedido esta vinculado à tabela de preço
=====================================================================================
*/
Static Function T04ValSZK(xCodTPed,xNomTped)
Local aArea	:= GetArea()
Local lRet	:= .T.

If !Empty(xCodTPed)
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZK")
	DbSetOrder(1)
	If DbSeek(xFilial("SZK")+DA0->DA0_CODTAB+xCodTPed)
		Alert("Tipo de Pedido já cadastrado para esta tabela de preço!")
		xNomTped	:= " "
		lRet	:= .F.
	Else
		DbSelectArea("SZJ")
		DbSetOrder(1)
		If DbSeek(xFilial("SZJ")+xCodTPed)
			xNomTped	:= SZJ->ZJ_NOME
		Else
			Alert("Tipo de Pedido não encontrado!")
			xNomTped	:= " "
			lRet	:= .F.
		Endif
	Endif
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Valida se o tipo de pedido esta vinculado à tabela de preço
=====================================================================================
*/
Static Function T4ValSZL(xVolume,xDesc)
Local aArea	:= GetArea()
Local lRet	:= .T.

If xVolume > 0
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZL")
	DbSetOrder(1)
	If DbSeek(xFilial("SZM")+DA0->DA0_CODTAB)

		While 	SZL->ZL_FILIAL  == xFilial("SZL")	.AND.;
			 	SZL->ZL_CODTAB	== DA0->DA0_CODTAB

			If SZL->ZL_VOLUME == xVolume
				Alert("Faixa de Volume já cadastrado para esta tabela de preço!")
				lRet	:= .F.
				Exit
			Endif
			SZL->(DbSkip())
		End
	Endif
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Valida se o % De desconto esta vinculado à tabela de preço
=====================================================================================
*/
Static Function T4ValSZM(xQtde,xDesc)
Local aArea	:= GetArea()
Local lRet	:= .T.

If xQtde > 0
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZM")
	DbSetOrder(1)
	If DbSeek(xFilial("SZM")+DA0->DA0_CODTAB)

		While 	SZM->ZM_FILIAL  == xFilial("SZM")	.AND.;
			 	SZM->ZM_CODTAB	== DA0->DA0_CODTAB

			If SZM->ZM_QTDE == xQtde
				Alert("Regra já cadastrado para esta tabela de preço!")
				lRet	:= .F.
				Exit
			Endif
			SZM->(DbSkip())
		End
	Endif
Endif

RestArea(aArea)

Return(lRet)


/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Grava o codigo da tab.preco + Filial
=====================================================================================
*/
Static Function T4GRVSZB(oLstSZ,aSZ,cCod,cDesc)
Local aArea		:= GetArea()
Local lRet		:= .T.
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

If Empty(cCod)
	Alert("Informe um código válido!")
	lRet	:= .F.
Else
	//---------------------------------------------------------------
	//Grava os dados na tabela
	//---------------------------------------------------------------
	DbSelectArea("SZB")
	RecLock("SZB",.T.)
		SZB->ZB_FILIAL	:= xFilial("SZB")
		SZB->ZB_CODTAB	:= DA0->DA0_CODTAB
		SZB->ZB_CODFIL	:= cCod
		//SZB->SZB_XALTER	:= cIDInteg
	SZB->(MsUnlock())

	u_MGFINT31()

	//---------------------------------------------------------------
	//Atualiza o Array
	//---------------------------------------------------------------
	aSZ	:= {}
	T04SZB( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
	oLstSZ:Refresh()
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Grava o codigo da tab.preco + Vendedor
=====================================================================================
*/
Static Function T4GRVSZC(oLstSZ,aSZ,cCod,cDesc,nPercomis)
Local aArea		:= GetArea()
Local lRet		:= .T.
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

//---------------------------------------------------------------
//Grava os dados na tabela
//---------------------------------------------------------------
If Empty(cCod)
	Alert("Informe um código válido!")
	lRet	:=.F.
Else
	DbSelectArea("SZC")
	RecLock("SZC",.T.)
		SZC->ZC_FILIAL	:= xFilial("SZC")
		SZC->ZC_CODTAB	:= DA0->DA0_CODTAB
		SZC->ZC_CODVEND	:= cCod
		SZC->ZC_PERCOMI	:= nPercomis
		//SZC->SZC_XALTER	:= cIDInteg
	SZC->(MsUnlock())

	u_MGFINT31()

	//---------------------------------------------------------------
	//Atualiza o Array
	//---------------------------------------------------------------
	aSZ	:= {}
	T04SZC( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2], aSZ[oLstSZ:nAt,3]}}
	oLstSZ:Refresh()
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Grava o codigo da tab.preco + Departamento
=====================================================================================
*/
Static Function T4GRVSZF(oLstSZ,aSZ,cCod,cDesc)
Local aArea		:= GetArea()
Local lRet		:= .T.
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

//---------------------------------------------------------------
//Grava os dados na tabela
//---------------------------------------------------------------
If Empty(cCod)
	Alert("Informe um código válido!")
	lRet	:= .F.
Else
	DbSelectArea("SZF")
	RecLock("SZF",.T.)
		SZF->ZF_FILIAL	:= xFilial("SZF")
		SZF->ZF_CODTAB	:= DA0->DA0_CODTAB
		SZF->ZF_CODDEP	:= cCod
		//SZF->SZF_XALTER	:= cIDInteg
	SZF->(MsUnlock())

	u_MGFINT31()

	//---------------------------------------------------------------
	//Atualiza o Array
	//---------------------------------------------------------------
	aSZ	:= {}
	T04SZF( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
	oLstSZ:Refresh()
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Grava o codigo da tab.preco + Cliente
=====================================================================================
*/
Static Function T4GRVSZG(oLstSZ,aSZ,cCod,cLoja,cDesc)
Local aArea		:= GetArea()
Local lRet		:= .T.
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

If Empty(cCod+cLoja )
	Alert("Informe um código válido!")
	lRet	:= .F.
Else
	If T4ValSZG(cCod,cLoja, nil,.T.)
		//---------------------------------------------------------------
		//Grava os dados na tabela
		//---------------------------------------------------------------
		DbSelectArea("SZG")
		RecLock("SZG",.T.)
			SZG->ZG_FILIAL	:= xFilial("SZG")
			SZG->ZG_CODTAB	:= DA0->DA0_CODTAB
			SZG->ZG_CODCLI	:= cCod
			SZG->ZG_LOJCLI	:= cLoja
			//SZG->SZG_XALTER	:= cIDInteg
		SZG->(MsUnlock())
	Endif

	u_MGFINT31()

	//---------------------------------------------------------------
	//Atualiza o Array
	//---------------------------------------------------------------
	aSZ	:= {}
	T04SZG( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2],aSZ[oLstSZ:nAt,3]}}
	oLstSZ:Refresh()
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Grava o codigo da tab.preco + Estado
=====================================================================================
*/
Static Function T4GRVSZH(oLstSZ,aSZ,cCod,cDesc)
Local aArea		:= GetArea()
Local lRet		:= .T.
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

//---------------------------------------------------------------
//Grava os dados na tabela
//---------------------------------------------------------------
If Empty(cCod)
	Alert("Informe um código válido!")
	lRet	:= .F.
Else
	DbSelectArea("SZH")
	RecLock("SZH",.T.)
		SZH->ZH_FILIAL	:= xFilial("SZH")
		SZH->ZH_CODTAB	:= DA0->DA0_CODTAB
		SZH->ZH_CODEST	:= cCod
		//SZH->SZH_XALTER	:= cIDInteg
	SZH->(MsUnlock())

	u_MGFINT31()

	//---------------------------------------------------------------
	//Atualiza o Array
	//---------------------------------------------------------------
	aSZ	:= {}
	T04SZH( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
	oLstSZ:Refresh()
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Grava o codigo da tab.preco + Filial
=====================================================================================
*/
Static Function T4GRVSZI(oLstSZ,aSZ,cCod,cDesc)
Local aArea		:= GetArea()
Local lRet		:= .T.
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

//---------------------------------------------------------------
//Grava os dados na tabela
//---------------------------------------------------------------
If Empty(cCod)
	Alert("Informe um código válido!")
	lRet	:= .F.
Else
	DbSelectArea("SZI")
	RecLock("SZI",.T.)
		SZI->ZI_FILIAL	:= xFilial("SZI")
		SZI->ZI_CODTAB	:= DA0->DA0_CODTAB
		SZI->ZI_CODREG	:= cCod
		//SZI->SZI_XALTER	:= cIDInteg
	SZI->(MsUnlock())

	u_MGFINT31()

	//---------------------------------------------------------------
	//Atualiza o Array
	//---------------------------------------------------------------
	aSZ	:= {}
	T04SZI( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
	oLstSZ:Refresh()
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Grava o codigo da tab.preco + Tipo Pedido na tabela SZK
=====================================================================================
*/
Static Function T4GRVSZK(oLstSZJ,aSZJ,cCod,cDesc)
Local aArea		:= GetArea()
Local lRet		:= .T.
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

//---------------------------------------------------------------
//Grava os dados na tabela
//---------------------------------------------------------------
If Empty(cCod)
	Alert("Informe um código válido!")
	lRet	:= .F.
Else
	DbSelectArea("SZK")
	RecLock("SZK",.T.)
		SZK->ZK_FILIAL	:= xFilial("SZK")
		SZK->ZK_CODTAB	:= DA0->DA0_CODTAB
		SZK->ZK_CODTPED	:= cCod
		//SZK->SZK_XALTER	:= cIDInteg
	SZK->(MsUnlock())

	u_MGFINT31()

	//---------------------------------------------------------------
	//Atualiza o Array
	//---------------------------------------------------------------
	aSZJ	:= {}
	T04SZJ( @aSZJ )
	//Aadd(aSZJ, {cCod,cDesc} )
	oLstSZJ:SetArray(aSZJ)
	oLstSZJ:nAt := 1
	oLstSZJ:bLine := { || {aSZJ[oLstSZJ:nAt,1], aSZJ[oLstSZJ:nAt,2]}}
	oLstSZJ:Refresh()
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Grava o codigo da tab.preco + Filial
=====================================================================================
*/
Static Function T4GRVSZL(oLstSZ,aSZ,xVolume,xPerc)
Local aArea	:= GetArea()
Local lRet	:= .T.

//---------------------------------------------------------------
//Grava os dados na tabela
//---------------------------------------------------------------
If xVolume > 0
	DbSelectArea("SZL")
	RecLock("SZL",.T.)
		SZL->ZL_FILIAL	:= xFilial("SZL")
		SZL->ZL_CODTAB	:= DA0->DA0_CODTAB
		SZL->ZL_VOLUME	:= xVolume
		SZL->ZL_PERDESC	:= xPerc
		SZL->ZL_XSFA	:= DA0->DA0_XSFA
	SZL->(MsUnlock())

	u_MGFINT31("SZL")

	//---------------------------------------------------------------
	//Atualiza o Array
	//---------------------------------------------------------------
	aSZ	:= {}
	T04SZL( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
	oLstSZ:Refresh()
Else
	lRet	:= .F.
	Alert("Informe o volume!")
Endif


RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Grava o codigo da tab.preco + % DESCONTO POR QUANTIDADE
=====================================================================================
*/
Static Function T4GRVSZM(oLstSZ,aSZ,xQtde,xPerc)
Local aArea	:= GetArea()
Local lRet	:= .T.

//---------------------------------------------------------------
//Grava os dados na tabela
//---------------------------------------------------------------
If xQtde > 0
	DbSelectArea("SZM")
	RecLock("SZM",.T.)
		SZM->ZM_FILIAL	:= xFilial("SZM")
		SZM->ZM_CODTAB	:= DA0->DA0_CODTAB
		SZM->ZM_QTDE	:= xQtde
		SZM->ZM_PERDESC	:= xPerc
		SZM->ZM_XSFA	:= DA0->DA0_XSFA
	SZM->(MsUnlock())

	u_MGFINT31("SZM")

	//---------------------------------------------------------------
	//Atualiza o Array
	//---------------------------------------------------------------
	aSZ	:= {}
	T04SZM( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
	oLstSZ:Refresh()
Else
	lRet	:= .F.
		Alert("Informe a quantidade!")
Endif

RestArea(aArea)

Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Deleta Registro da tab.preco X Filial
=====================================================================================
*/
User Function T04ExcZB(oLstSZ,aSZ)
Local aArea		:= GetArea()
Local xCod		:= 0
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

xCod			:= aSZ[oLstSZ:nAt][1]

If !Empty(xCod)
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZB")
	DbSetOrder(1)
	If DbSeek(xFilial("SZB")+DA0->DA0_CODTAB+xCod)

		//---------------------------------------------------------------
		//Deleta o Registo
		//---------------------------------------------------------------
		RecLock( "SZB" , .F. )
	    	//SZB->SZB_XALTER := cIDInteg
	    	SZB->(DbDelete())
	    SZB->(MsUnlock())

	    u_MGFINT31()

		//---------------------------------------------------------------
		//Atualiza o Arrayad
		//---------------------------------------------------------------
		aSZ	:= {}
		T04SZB( @aSZ )
		oLstSZ:SetArray(aSZ)
		oLstSZ:nAt := 1
		oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
		oLstSZ:Refresh()


	Endif
Endif

RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Deleta Registro da tab.preco X Vendedor
=====================================================================================
*/
User Function T04ExcZC(oLstSZ,aSZ)
Local aArea		:= GetArea()
Local xCod		:= 0
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

xCod		:= aSZ[oLstSZ:nAt][1]

If !Empty(xCod)
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZC")
	DbSetOrder(1)
	If DbSeek(xFilial("SZC")+DA0->DA0_CODTAB+xCod)
	   	//---------------------------------------------------------------
		//Deleta o Registo
		//---------------------------------------------------------------
		RecLock( "SZC" , .F. )
	    	//SZC->SZC_XALTER := cIDInteg
	    	SZC->(DbDelete())
	    SZC->(MsUnlock())

	    u_MGFINT31()

		//---------------------------------------------------------------
		//Atualiza o Arrayad
		//---------------------------------------------------------------
		aSZ	:= {}
		T04SZC( @aSZ )
		oLstSZ:SetArray(aSZ)
		oLstSZ:nAt := 1
		oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
		oLstSZ:Refresh()
	Endif
Endif

RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Deleta Registro da tab.preco X Departamento
=====================================================================================
*/
User Function T04ExcZF(oLstSZ,aSZ)
Local aArea		:= GetArea()
Local xCod		:= 0
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

xCod		:= aSZ[oLstSZ:nAt][1]

If !Empty(xCod)
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZF")
	DbSetOrder(1)
	If DbSeek(xFilial("SZF")+DA0->DA0_CODTAB+xCod)
	   	//---------------------------------------------------------------
		//Deleta o Registo
		//---------------------------------------------------------------
		RecLock( "SZF" , .F. )
	    	//SZF->SZF_XALTER := cIDInteg
	    	SZF->(DbDelete())
	    SZF->(MsUnlock())

	    u_MGFINT31()

		//---------------------------------------------------------------
		//Atualiza o Arrayad
		//---------------------------------------------------------------
		aSZ	:= {}
		T04SZF( @aSZ )
		oLstSZ:SetArray(aSZ)
		oLstSZ:nAt := 1
		oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
		oLstSZ:Refresh()
	Endif
Endif

RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Deleta Registro da tab.preco X Vendedor
=====================================================================================
*/
User Function T04ExcZG(oLstSZ,aSZ)
Local aArea		:= GetArea()
Local xCod		:= 0
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

xCod		:= aSZ[oLstSZ:nAt][1]

If !Empty(xCod)
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZG")
	DbSetOrder(1)
	If DbSeek(xFilial("SZG")+DA0->DA0_CODTAB+xCod)
	   	//---------------------------------------------------------------
		//Deleta o Registo
		//---------------------------------------------------------------
		RecLock( "SZG" , .F. )
	    	//SZG->SZG_XALTER := cIDInteg
	    	SZG->(DbDelete())
	    SZG->(MsUnlock())

	    u_MGFINT31()

		//---------------------------------------------------------------
		//Atualiza o Arrayad
		//---------------------------------------------------------------
		aSZ	:= {}
		T04SZG( @aSZ )
		oLstSZ:SetArray(aSZ)
		oLstSZ:nAt := 1
		oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2],aSZ[oLstSZ:nAt,3]}}
		oLstSZ:Refresh()
	Endif
Endif

RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Deleta Registro da tab.preco X Estado
=====================================================================================
*/
User Function T04ExcZH(oLstSZ,aSZ)
Local aArea		:= GetArea()
Local xCod		:= 0
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

xCod		:= aSZ[oLstSZ:nAt][1]

If !Empty(xCod)
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZH")
	DbSetOrder(1)
	If DbSeek(xFilial("SZH")+DA0->DA0_CODTAB+xCod)
	   	//---------------------------------------------------------------
		//Deleta o Registo
		//---------------------------------------------------------------
		RecLock( "SZH" , .F. )
	    	//SZH->SZH_XALTER	:= cIDInteg
	    	SZH->(DbDelete())
	    SZH->(MsUnlock())

	    u_MGFINT31()

		//---------------------------------------------------------------
		//Atualiza o Arrayad
		//---------------------------------------------------------------
		aSZ	:= {}
		T04SZH( @aSZ )
		oLstSZ:SetArray(aSZ)
		oLstSZ:nAt := 1
		oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
		oLstSZ:Refresh()
	Endif
Endif

RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Deleta Registro da tab.preco X Regiao
=====================================================================================
*/
User Function T04ExcZI(oLstSZ,aSZ)
Local aArea		:= GetArea()
Local xCod		:= 0
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

xCod		:= aSZ[oLstSZ:nAt][1]


If !Empty(xCod)
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZI")
	DbSetOrder(1)
	If DbSeek(xFilial("SZI")+DA0->DA0_CODTAB+xCod)

		//---------------------------------------------------------------
		//Deleta o Registo
		//---------------------------------------------------------------
		RecLock( "SZI" , .F. )
	    	//SZI->SZI_XALTER := cIDInteg
	    	SZI->(DbDelete())
	    SZI->(MsUnlock())

	    u_MGFINT31()

		//---------------------------------------------------------------
		//Atualiza o Arrayad
		//---------------------------------------------------------------
		aSZ	:= {}
		T04SZI( @aSZ )
		oLstSZ:SetArray(aSZ)
		oLstSZ:nAt := 1
		oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
		oLstSZ:Refresh()


	Endif
Endif

RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Grava o codigo da tab.preco + Tipo Pedido na tabela SZK
=====================================================================================
*/
User Function T04ExcZK(oLstSZJ,aSZJ)
Local aArea		:= GetArea()
Local xCodTPed	:= 0
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

xCodTPed	:= aSZJ[oLstSZJ:nAt][1]


If !Empty(xCodTPed)
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZK")
	DbSetOrder(1)
	If DbSeek(xFilial("SZK")+DA0->DA0_CODTAB+xCodTPed)

		//---------------------------------------------------------------
		//Deleta o Registo
		//---------------------------------------------------------------
		RecLock( "SZK" , .F. )
			//SZK->SZK_XALTER	:= cIDInteg
	    	SZK->(DbDelete())
	    SZK->(MsUnlock())

	    u_MGFINT31()

		//---------------------------------------------------------------
		//Atualiza o Arrayad
		//---------------------------------------------------------------
		aSZJ	:= {}
		T04SZJ( @aSZJ )
		//Aadd(aSZJ, {cCod,cDesc} )
		oLstSZJ:SetArray(aSZJ)
		oLstSZJ:nAt := 1
		oLstSZJ:bLine := { || {aSZJ[oLstSZJ:nAt,1], aSZJ[oLstSZJ:nAt,2]}}
		oLstSZJ:Refresh()


	Endif
Endif

RestArea(aArea)

Return


/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Deleta Registro da tab.preco X Filial
=====================================================================================
*/
User Function T04ExcZL(oLstSZ,aSZ)
Local aArea		:= GetArea()
Local xVolume	:= 0

xCod			:= aSZ[oLstSZ:nAt][1]

If !Empty(xCod)
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZL")
	DbSetOrder(1)
	If DbSeek(xFilial("SZL")+DA0->DA0_CODTAB)

		While 	SZL->ZL_FILIAL  == xFilial("SZL")	.AND.;
			 	SZL->ZL_CODTAB	== DA0->DA0_CODTAB

			If SZL->ZL_VOLUME == xCod
				RecLock("SZL")
			    	SZL->(DbDelete())
			    SZL->(MsUnlock())
				Exit
			Endif
			SZL->(DbSkip())
		End
	Endif

	u_MGFINT31("SZL")

	//---------------------------------------------------------------
	//Atualiza o Arrayad
	//---------------------------------------------------------------
	aSZ	:= {}
	T04SZL( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
	oLstSZ:Refresh()

Endif

RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFAT04
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Cadastro de Dados Adicionais da tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Deleta Registro da tab.preco X % DESCONTO POR QUANTIDADE
=====================================================================================
*/
User Function T04ExcZM(oLstSZ,aSZ)
Local aArea		:= GetArea()
Local xCod

xCod			:= aSZ[oLstSZ:nAt][1]

If !Empty(xCod)
	//--------------------------------------------------------------
	//Valida se ja existe o codigo tipo de pedido x tabela de preco
	//--------------------------------------------------------------
	DbSelectArea("SZM")
	DbSetOrder(1)
	If DbSeek(xFilial("SZM")+DA0->DA0_CODTAB)

		While 	SZM->ZM_FILIAL  == xFilial("SZM")	.AND.;
			 	SZM->ZM_CODTAB	== DA0->DA0_CODTAB

			If SZM->ZM_QTDE == xCod
				RecLock("SZM")
			    	SZM->(DbDelete())
			    SZM->(MsUnlock())
				Exit
			Endif
			SZM->(DbSkip())
		End
	Endif

	u_MGFINT31("SZM")

	//---------------------------------------------------------------
	//Atualiza o Arrayad
	//---------------------------------------------------------------
	aSZ	:= {}
	T04SZM( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2]}}
	oLstSZ:Refresh()

Endif

RestArea(aArea)

Return



User Function FAT01Cpy()
Local cTitle 	:= "MGF-Copiar"
Local cTabPai	:= DA0->DA0_CODTAB
Local cTabCop	:= ""
Local aArea
Local cCod		:=""
Local cLoja		:=""
Local cCod2		:=""
Local nPerComis	:=0

FWExecView(cTitle , 'OMSA010', 9,, { || .T. } )

cTabCop	:= DA0->DA0_CODTAB

If cTabPai <> cTabCop
	//---------------------------------------------------------------------------------------------
	//Copia Filial x Tabela de Preco
	//---------------------------------------------------------------------------------------------
	DbSelectArea("SZB")
	DbSetOrder(1)
	If DbSeek(xFilial("SZB")+cTabPai)
		While SZB->(!EOF()) .AND. SZB->ZB_FILIAL == xFilial("SZB")	.AND. SZB->ZB_CODTAB == cTabPai

			cCod	:= SZB->ZB_CODFIL

		   	aArea	:= GetArea()
			aAreaSZ	:= SZB->(GetArea())
			RecLock("SZB",.T.)
				SZB->ZB_FILIAL	:= xFilial("SZB")
				SZB->ZB_CODTAB	:= cTabCop
				SZB->ZB_CODFIL	:= cCod
			SZB->(MsUnlock())
			RestArea(aAreaSZ)
			RestArea(aArea)
			SZB->(DbSkip())
		End
	Endif
	//---------------------------------------------------------------------------------------------
	//Copia Vendedor x Tabela de Preco
	//---------------------------------------------------------------------------------------------
	DbSelectArea("SZC")
	DbSetOrder(1)
	If DbSeek(xFilial("SZC")+cTabPai)
		While SZC->(!EOF()) .AND. SZC->ZC_FILIAL == xFilial("SZC")	.AND. SZC->ZC_CODTAB == cTabPai

			cCod		:= SZC->ZC_CODVEND
			nPerComis	:= SZC->ZC_PERCOMI

		   	aArea	:= GetArea()
			aAreaSZ	:= SZC->(GetArea())
			RecLock("SZC",.T.)
				SZC->ZC_FILIAL	:= xFilial("SZC")
				SZC->ZC_CODTAB	:= cTabCop
				SZC->ZC_CODVEND	:= cCod
				SZC->ZC_PERCOMI	:= nPerComis
			SZC->(MsUnlock())
			RestArea(aAreaSZ)
			RestArea(aArea)
			SZC->(DbSkip())
		End
	Endif
	//---------------------------------------------------------------------------------------------
	//Copia Departamento x Tabela de Preco
	//---------------------------------------------------------------------------------------------
	DbSelectArea("SZF")
	DbSetOrder(1)
	If DbSeek(xFilial("SZF")+cTabPai)
		While SZF->(!EOF()) .AND. SZF->ZF_FILIAL == xFilial("SZF")	.AND. SZF->ZF_CODTAB == cTabPai

			cCod	:= SZF->ZF_CODDEP

		   	aArea	:= GetArea()
			aAreaSZ	:= SZF->(GetArea())
			RecLock("SZF",.T.)
				SZF->ZF_FILIAL	:= xFilial("SZF")
				SZF->ZF_CODTAB	:= cTabCop
				SZF->ZF_CODDEP	:= cCod
			SZF->(MsUnlock())
			RestArea(aAreaSZ)
			RestArea(aArea)
			SZF->(DbSkip())
		End
	Endif
	//---------------------------------------------------------------------------------------------
	//Copia Cliente x Tabela de Preco
	//---------------------------------------------------------------------------------------------
	DbSelectArea("SZG")
	DbSetOrder(1)
	If DbSeek(xFilial("SZG")+cTabPai)
		While SZG->(!EOF()) .AND. SZG->ZG_FILIAL == xFilial("SZG")	.AND. SZG->ZG_CODTAB == cTabPai

			cCod	:= SZG->ZG_CODCLI
			cLoja	:= SZG->ZG_LOJCLI

		   	aArea	:= GetArea()
			aAreaSZ	:= SZG->(GetArea())
			RecLock("SZG",.T.)
				SZG->ZG_FILIAL	:= xFilial("SZG")
				SZG->ZG_CODTAB	:= cTabCop
				SZG->ZG_CODCLI	:= cCod
				SZG->ZG_LOJCLI	:= cLoja
			SZG->(MsUnlock())
			RestArea(aAreaSZ)
			RestArea(aArea)
			SZG->(DbSkip())
		End
	Endif
	//---------------------------------------------------------------------------------------------
	//Copia Estado x Tabela de Preco
	//---------------------------------------------------------------------------------------------
	DbSelectArea("SZH")
	DbSetOrder(1)
	If DbSeek(xFilial("SZH")+cTabPai)
		While SZH->(!EOF()) .AND. SZH->ZH_FILIAL == xFilial("SZH")	.AND. SZH->ZH_CODTAB == cTabPai

			cCod	:= SZH->ZH_CODEST

		   	aArea	:= GetArea()
			aAreaSZ	:= SZH->(GetArea())
			RecLock("SZH",.T.)
				SZH->ZH_FILIAL	:= xFilial("SZH")
				SZH->ZH_CODTAB	:= cTabCop
				SZH->ZH_CODEST	:= cCod
			SZH->(MsUnlock())
			RestArea(aAreaSZ)
			RestArea(aArea)
			SZH->(DbSkip())
		End
	Endif
	//---------------------------------------------------------------------------------------------
	//Copia Estado x Tabela de Preco
	//---------------------------------------------------------------------------------------------
	DbSelectArea("SZI")
	DbSetOrder(1)
	If DbSeek(xFilial("SZI")+cTabPai)
		While SZI->(!EOF()) .AND. SZI->ZI_FILIAL == xFilial("SZI")	.AND. SZI->ZI_CODTAB == cTabPai

			cCod	:= SZI->ZI_CODREG

		   	aArea	:= GetArea()
			aAreaSZ	:= SZI->(GetArea())
			RecLock("SZI",.T.)
				SZI->ZI_FILIAL	:= xFilial("SZI")
				SZI->ZI_CODTAB	:= cTabCop
				SZI->ZI_CODREG	:= cCod
			SZI->(MsUnlock())
			RestArea(aAreaSZ)
			RestArea(aArea)
			SZI->(DbSkip())
		End
	Endif
	//---------------------------------------------------------------------------------------------
	//Copia Estado x Tabela de Preco
	//---------------------------------------------------------------------------------------------
	DbSelectArea("SZK")
	DbSetOrder(1)
	If DbSeek(xFilial("SZK")+cTabPai)
		While SZK->(!EOF()) .AND. SZK->ZK_FILIAL == xFilial("SZK")	.AND. SZK->ZK_CODTAB == cTabPai

			cCod	:= SZK->ZK_CODTPED

		   	aArea	:= GetArea()
			aAreaSZ	:= SZK->(GetArea())
			RecLock("SZK",.T.)
				SZK->ZK_FILIAL	:= xFilial("SZK")
				SZK->ZK_CODTAB	:= cTabCop
				SZK->ZK_CODTPED	:= cCod
			SZK->(MsUnlock())
			RestArea(aAreaSZ)
			RestArea(aArea)
			SZK->(DbSkip())
		End
	Endif
	//---------------------------------------------------------------------------------------------
	//Copia Volume x Tabela de Preco
	//---------------------------------------------------------------------------------------------
	DbSelectArea("SZL")
	DbSetOrder(1)
	If DbSeek(xFilial("SZL")+cTabPai)
		While SZL->(!EOF()) .AND. SZL->ZL_FILIAL == xFilial("SZL")	.AND. SZL->ZL_CODTAB == cTabPai

			cCod	:= SZL->ZL_VOLUME
			cCod2	:= SZL->ZL_PERDESC

		   	aArea	:= GetArea()
			aAreaSZ	:= SZL->(GetArea())
			RecLock("SZL",.T.)
				SZL->ZL_FILIAL	:= xFilial("SZL")
				SZL->ZL_CODTAB	:= cTabCop
				SZL->ZL_VOLUME 	:= cCod
				SZL->ZL_PERDESC	:= cCod2
				SZL->ZL_XSFA	:= DA0->DA0_XSFA
			SZL->(MsUnlock())
			RestArea(aAreaSZ)
			RestArea(aArea)
			SZL->(DbSkip())
		End
	Endif
	//---------------------------------------------------------------------------------------------
	//Copia Volume x Tabela de Preco
	//---------------------------------------------------------------------------------------------
	DbSelectArea("SZM")
	DbSetOrder(1)
	If DbSeek(xFilial("SZM")+cTabPai)
		While SZM->(!EOF()) .AND. SZM->ZM_FILIAL == xFilial("SZM")	.AND. SZM->ZM_CODTAB == cTabPai

			cCod	:= SZM->ZM_QTDE
			cCod2	:= SZM->ZM_PERDESC

		   	aArea	:= GetArea()
			aAreaSZ	:= SZM->(GetArea())
			RecLock("SZM",.T.)
				SZM->ZM_FILIAL	:= xFilial("SZM")
				SZM->ZM_CODTAB	:= cTabCop
				SZM->ZM_QTDE 	:= cCod
				SZM->ZM_PERDESC	:= cCod2
				SZM->ZM_XSFA	:= DA0->DA0_XSFA
			SZM->(MsUnlock())
			RestArea(aAreaSZ)
			RestArea(aArea)
			SZM->(DbSkip())
		EndDo
	Endif

	u_MGFINT31("SZL")
	u_MGFINT31("SZM")

Endif
Return


// rotina chamada pelo ponto de entrada OMSA010
User Function OMSA010_PE()

Local aArea 	:= {GetArea()}
Local oObj 		:= IIf(Type("ParamIxb[1]")!="U",ParamIxb[1],Nil)
Local cIdPonto 	:= IIf(Type("ParamIxb[2]")!="U",ParamIxb[2],"")
Local cIdModel 	:= IIf(Type("ParamIxb[3]")!="U",ParamIxb[3],"")
Local nOpcx 	:= 0
Local uRet 		:= .T.
Local nX		:= 0

Local oMldDA0	:= nil
Local oMldDA1	:= nil
Local cUpdTbl	:= ""
Local nDA0Recno := 0
Local nDA1Recno := 0
Local oVlDA0	:= nil
Local oVlDA1	:= nil

If oObj == Nil .or. Empty(cIdPonto)
	Return(uRet)
Endif

nOpcx := oObj:GetOperation()

If cIdPonto == "MODELCOMMITNTTS"

	oMldDA0	:= oObj:GetModel("DA0MASTER")
	nDA0Recno := oMldDA0:GetDataId()
	cUpdTbl	:= ""

	cUpdTbl := " UPDATE " + retSQLName("DA0")								+ CRLF
	cUpdTbl += "	SET"													+ CRLF

	If nOpcx == MODEL_OPERATION_INSERT
		cUpdTbl += " 		DA0_ZSTAEC = '0', DA0_ZSTASF = 'N',"			+ CRLF
	EndIf

	cUpdTbl += " 		DA0_XINTEC = '0' , DA0_XINTSF = 'P'"				+ CRLF
	cUpdTbl += " WHERE"														+ CRLF
	cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( nDA0Recno ) ) + ""	+ CRLF

	if tcSQLExec( cUpdTbl ) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
	endif

	If nOpcx <> MODEL_OPERATION_INSERT
		oMldDA1	:= oObj:GetModel("DA1DETAIL")

		For nX := 1 To oMldDA1:Length()
			oMldDA1:GoLine( nX )

			nDA1Recno := oMldDA1:GetDataId(nX)

			If oMldDA1:IsDeleted()

				cUpdTbl	:= ""

				cUpdTbl := " UPDATE " + retSQLName("DA1")								+ CRLF
				cUpdTbl += "	SET"													+ CRLF
				cUpdTbl += " 		DA1_XENEEC = '0' "									+ CRLF
				cUpdTbl += " WHERE"														+ CRLF
				cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( nDA1Recno ) ) + ""	+ CRLF

				if tcSQLExec( cUpdTbl ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif

			EndIf

		Next nX

	EndIf
ElseIf cIdPonto == "BUTTONBAR"
	If nOpcx == MODEL_OPERATION_INSERT .or. nOpcx == MODEL_OPERATION_UPDATE
		//uRet := {{'MGF-Importa Tab.Preco',,{|| MsgRun("Aguarde, carregando Tabela de Preço...",,{ ||u_FAT01IImpTab(oObj,nOpcx)})}, OemtoAnsi("MGF-Importa Tab.Preco")}}
		uRet := {{'MGF-Importa Tab.Preco',,{|| Processa({|| u_FAT01IImpTab(oObj,nOpcx)})}, OemtoAnsi("MGF-Importa Tab.Preco")}}
	Endif
	If nOpcx == MODEL_OPERATION_UPDATE
		aAdd(uRet,{'MGF-Dados Adicionais',,{||u_MGFFAT04()}, OemtoAnsi("MGF-Dados Adicionais")})
	Endif

ElseIf cIdPonto == "FORMLINEPRE"	
	
	oModel 	:= FwModelActive()
	oVlDA1	:= oModel:GetModel("DA0MASTER")
	cTabDa1	:= oVlDA1:GetValue('DA0_XENVEC')

	If cTabDa1 == '1' .and. GetNewPar('MGF_FAT041', .T.)

		oVlDA0	:= oModel:GetModel("DA1DETAIL")
		nVlVen	:= oVlDA0:GetValue('DA1_PRCVEN')

		If FWFldGet('DA1_PRCVEN') <>  nVlVen
			nPrd	:= oVlDA0:GetValue('DA1_CODPRO')

			If Retfield("SB1",1, xFilial("SB1")+ nPrd , "B1_XENVECO") == "1"
				If !ExistCpo("ZC4",Retfield("SB1",1,xFilial("SB1") + nPrd ,"B1_ZLINHA") )
					uRet	:= T04INB1()
					If !uRet
						Help( ,, 'Pendência de cadastro',, 'Campo LINHA do cadastro de produto inválido. O preço para esse item não será atualizado.' , 1, 0 ,,,,,,; 
						{"Informe a linha através da janela, ou corrija o campo linha diretamente no cadastro de produtos, para prosseguir."} )
					EndIf
				EndIf 
			EndIf 
		EndIf
	Endif 

EndIf

aEval(aArea,{|x| RestArea(x)})

Return(uRet)

// limpa registros da tabela de amarracao entre tabela de preco e vendedores
Static Function T04ZCLimp(oLstSZ,aSZ)

Local aArea		:= {SZC->(GetArea()),GetArea()}
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

If !APMsgYesNo("Esta operação vai excluir todas as amarrações existentes entre esta Tabela de Preço com os Vendedores."+CRLF+;
"Deseja continuar ?")
	Return()
Endif

If Len(aSZ) == 1 .and. Empty(aSZ[1][1])
	APMsgStop("Não existem Vendedores amarrados a esta Tabela de Preço.")
	Return()
Endif

SZC->(dbSetOrder(1))
If SZC->(dbSeek(xFilial("SZC")+DA0->DA0_CODTAB))
	While SZC->(!Eof()) .and. xFilial("SZC")+DA0->DA0_CODTAB == SZC->ZC_FILIAL+SZC->ZC_CODTAB
		SZC->( RecLock( "SZC" , .F. ) )
			//SZC->SZC_XALTER := cIDInteg
			SZC->(dbDelete())
		SZC->(MsUnLock())

		SZC->(dbSkip())
    Enddo
Endif

u_MGFINT31()

aSZ := {{"","",""}}
oLstSZ:SetArray(aSZ)
oLstSZ:nAt := 1
oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2], aSZ[oLstSZ:nAt,3]}}
oLstSZ:Refresh()

aEval(aArea,{|x| RestArea(x)})

Return()


// importa registros na tabela de amarracao dentre a tabela de preco e vendedores, a partir de arquivo .csv
Static Function T04ZCImp(oLstSZ,aSZ)

Local aArea	:= {SA3->(GetArea()),SZC->(GetArea()),GetArea()}
Local aDados := {}
Local cArq := ""
Local cLinha := ""
Local lContinua := .T.
Local nCnt := 0
local cIDInteg		:= fwTimeStamp( 1 ) // aaaammddhhmmss

cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

If !File(cArq)
	MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
	Return()
EndIf

FT_FUSE(cArq)
FT_FGOTOP()
While !FT_FEOF()
	IncProc("Lendo arquivo texto...")
	cLinha := FT_FREADLN()
	aAdd(aDados,Separa(cLinha,";",.T.))
	If Len(aDados[Len(aDados)]) != 2
		lContinua := .F.
		Exit
	Endif
	FT_FSKIP()
End

If lContinua
	SA3->(dbSetOrder(1))
	SZC->(dbSetOrder(1))
	For nCnt:=1 to Len(aDados)
		If SA3->(dbSeek(xFilial("SA3")+aDados[nCnt][1]))
			If SA3->A3_MSBLQL == "1"
				ApMsgAlert("Vendedor está bloqueado, código: "+aDados[nCnt][1]+CRLF+;
				"Esta linha do arquivo não será importada.")
			Elseif SZC->(dbSeek(xFilial("SZC")+DA0->DA0_CODTAB+aDados[nCnt][1]))
				If SZC->ZC_PERCOMI != Val(aDados[nCnt][2])
					SZC->(RecLock("SZC",.F.))
					SZC->ZC_PERCOMI := Val(aDados[nCnt][2])
					SZC->SZC_XALTER := cIDInteg
					SZC->(MsUnLock())
				Endif
			Else
				SZC->(RecLock("SZC",.T.))
				SZC->ZC_FILIAL := xFilial("SZC")
				SZC->ZC_CODTAB := DA0->DA0_CODTAB
				SZC->ZC_CODVEND := aDados[nCnt][1]
				SZC->ZC_PERCOMI := Val(aDados[nCnt][2])
				//SZC->SZC_XALTER := cIDInteg
				SZC->(MsUnLock())
			Endif
		Else
			ApMsgAlert("Vendedor não cadastrado, código: "+aDados[nCnt][1]+CRLF+;
			"Esta linha do arquivo não será importada.")
		Endif
	Next

	u_MGFINT31()

	//---------------------------------------------------------------
	//Atualiza o Array
	//---------------------------------------------------------------
	aSZ := {}
	T04SZC( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2], aSZ[oLstSZ:nAt,3]}}
	oLstSZ:Refresh()
	APMsgInfo("Importação realizada com sucesso.")
Else
	ApMsgStop("Arquivo com lay-out inválido, devem haver 2 colunas ( Código do Vendedor e %Comissão ) para cada linha do arquivo.")
Endif

aEval(aArea,{|x| RestArea(x)})

Return()


// limpa registros da tabela de amarracao entre tabela de preco e clientes
Static Function T04ZGLimp(oLstSZ,aSZ)

Local aArea		:= {SZG->(GetArea()),GetArea()}
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

If !APMsgYesNo("Esta operação vai excluir todas as amarrações existentes entre esta Tabela de Preço com os Clientes."+CRLF+;
"Deseja continuar ?")
	Return()
Endif

If Len(aSZ) == 1 .and. Empty(aSZ[1][1])
	APMsgStop("Não existem Clientes amarrados a esta Tabela de Preço.")
	Return()
Endif

SZG->(dbSetOrder(1))
If SZG->(dbSeek(xFilial("SZG")+DA0->DA0_CODTAB))
	While SZG->(!Eof()) .and. xFilial("SZG")+DA0->DA0_CODTAB == SZG->ZG_FILIAL+SZG->ZG_CODTAB
		SZG->(RecLock("SZG",.F.))
			//SZG->SZG_XALTER := cIDInteg
			SZG->(dbDelete())
		SZG->(MsUnLock())

		SZG->(dbSkip())
    Enddo
Endif

u_MGFINT31()

aSZ := {{"","",""}}
oLstSZ:SetArray(aSZ)
oLstSZ:nAt := 1
oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2], aSZ[oLstSZ:nAt,3]}}
oLstSZ:Refresh()

aEval(aArea,{|x| RestArea(x)})

Return()


// importa registros na tabela de amarracao dentre a tabela de preco e clientes, a partir de arquivo .csv
Static Function T04ZGImp(oLstSZ,aSZ)

Local aArea	:= {SA1->(GetArea()),SZG->(GetArea()),GetArea()}
Local aDados := {}
Local cArq := ""
Local cLinha := ""
Local lContinua := .T.
Local nCnt := 0
local cIDInteg	:= fwTimeStamp( 1 ) // aaaammddhhmmss

cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

If !File(cArq)
	MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
	Return()
EndIf

FT_FUSE(cArq)
FT_FGOTOP()
While !FT_FEOF()
	IncProc("Lendo arquivo texto...")
	cLinha := FT_FREADLN()
	aAdd(aDados,Separa(cLinha,";",.T.))
	If Len(aDados[Len(aDados)]) != 2
		lContinua := .F.
		Exit
	Endif
	FT_FSKIP()
End

If lContinua
	SA1->(dbSetOrder(1))
	SZG->(dbSetOrder(1))
	For nCnt:=1 to Len(aDados)
		If SA1->(dbSeek(xFilial("SA1")+aDados[nCnt][1]+aDados[nCnt][2]))
			If SA1->A1_MSBLQL == "1"
				ApMsgAlert("Cliente está bloqueado, código/loja: "+aDados[nCnt][1]+"/"+aDados[nCnt][2]+CRLF+;
				"Esta linha do arquivo não será importada.")
			Elseif SZG->(!dbSeek(xFilial("SZG")+DA0->DA0_CODTAB+aDados[nCnt][1]+aDados[nCnt][2]))
				SZG->(RecLock("SZG",.T.))
				SZG->ZG_FILIAL	:= xFilial("SZG")
				SZG->ZG_CODTAB	:= DA0->DA0_CODTAB
				SZG->ZG_CODCLI	:= aDados[nCnt][1]
				SZG->ZG_LOJCLI	:= aDados[nCnt][2]
				//SZG->SZG_XALTER	:= cIDInteg
				SZG->(MsUnLock())
			Endif
		Else
			ApMsgAlert("Cliente não cadastrado, código/loja: "+aDados[nCnt][1]+"/"+aDados[nCnt][2]+CRLF+;
			"Esta linha do arquivo não será importada.")
		Endif
	Next

	u_MGFINT31()

	//---------------------------------------------------------------
	//Atualiza o Array
	//---------------------------------------------------------------
	aSZ := {}
	T04SZG( @aSZ )
	oLstSZ:SetArray(aSZ)
	oLstSZ:nAt := 1
	oLstSZ:bLine := { || {aSZ[oLstSZ:nAt,1], aSZ[oLstSZ:nAt,2], aSZ[oLstSZ:nAt,3]}}
	oLstSZ:Refresh()
	APMsgInfo("Importação realizada com sucesso.")
Else
	ApMsgStop("Arquivo com lay-out inválido, devem haver 2 colunas ( Código do Cliente e Loja do Cliente ) para cada linha do arquivo.")
Endif

aEval(aArea,{|x| RestArea(x)})

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³txtbal    ºAutor  ³ TOTVS              º Data ³  Junho/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Utilizado para Gerar TXT Balança Toledo                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function txtbal()

	Processa( {|| _ExpProd()}, "Processando..." )

Return




Static Function _ExpProd(lJob)
Local aArea			:= GetArea()
Local _cAlias
Local cQuery     	:= ""
Local lRet 			:= .T.
Local nI 			:= 1
Local nH
Local cDirLoc		:= ""
Local cFile 		:= ""
Local cMVTABPAD 	:= Alltrim(SuperGetMv("MV_TABPAD",,""))

DEFAULT lJob		:= .F.

cDirLoc := 	cGetFile('','Selecione o Diretório',0,,.F.,GETF_LOCALHARD+ GETF_RETDIRECTORY+GETF_NETWORKDRIVE)
//cGetFile( "" , "Local para gravar o arquivo", , , , nOR(GETF_MULTISELECT, GETF_NETWORKDRIVE, GETF_LOCALHARD) ) //cGetFile("","Local dos arquivos XML para importação",,"",.T.,GETF_RETDIRECTORY,.T.)

//cDirLoc		:= GetMV( 'MGF_TOLEDO',, "C:\Microsiga\Marfrig\LIVE\" )
cFile		:= cDirLoc + "TXITENS.TXT"

//---------------------------
//Cria Arquivo de Exportacao
//---------------------------
If File(cFile)
	If FErase( cFile  ) ==-1
		Alert( "Erro ao deletar o arquivo " + cFile + ": Arquivo de exportação não será gerado!")
		lRet:=.F.
	Endif
Endif

_cAlias		:= GetNextAlias()

If lRet

	cQuery 	:= " SELECT DA1.*, SB1.B1_DESC "
	cQuery 	+= " FROM " + RetSqlName("DA1") 		+ " DA1 "
	cQuery 	+= " INNER JOIN " + RetSqlName("SB1") 	+ " SB1 "
	cQuery 	+= " ON SB1.B1_FILIAL = '" 				+ xFilial("SB1") + "' "
	cQuery 	+= " AND SB1.B1_COD = DA1.DA1_CODPRO "
	cQuery 	+= " AND SB1.B1_XLJPROD = '1' "
	cQuery 	+= " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery 	+= " WHERE DA1.DA1_FILIAL <> 'ZZ' " //			+ xFilial("DA1") + "' "
	cQuery 	+= " AND DA1.DA1_CODTAB = '" + cMVTABPAD + "' "
	cQuery 	+= " AND DA1.D_E_L_E_T_ = ' ' "

	TCQUERY cQuery NEW ALIAS ( _cAlias )

	DbSelectArea( _cAlias )
	(_cAlias)->( DbGoTop() )
	If (_cAlias)->(Eof())

	Else
		ProcRegua((_cAlias)->(RecCount()))


		//nH := fCreate(cFile)

		cFile := Upper( cFile )
		nH  := FCreate( cFile, , , .F. )
		If nH == -1
 			Alert("Falha ao criar arquivo com os produtos! " )
   			lRet:=.F.
		Else
			(_cAlias)->( DbGoTop() )
			While (_cAlias)->(!Eof())
	  			If !lJob
					IncProc("Gravando arquivo de produtos para exportação...")
				Endif

				fWrite(nH, 	'01000'														+;
        					Substr((_cAlias)->DA1_CODPRO,1,6)							+;
        					strzero(val(StrTran(Transform((_cAlias)->DA1_PRCVEN,"@E 999.99"),",","")),6)+;
				 			'000'														+;
				 			Substr((_cAlias)->B1_DESC,1,25)+chr(13)+chr(10)	)

				DbSelectArea( _cAlias )
				(_cAlias)->(dbskip())
			End
		Endif
		fClose(nH)
	Endif
Endif
	//STRZERO(VAL(STRTRAN(STR((_cAlias)->DA1_PRCVEN),".","")),6)	+;
(_cAlias)->(DbCloseArea())

RestArea(aArea)

Return(lRet)

Static Function T04INB1()

Local oDlgMain
Local oLinha	:=  Nil
Local cCodLin	:= 	CriaVar("ZC4_CODIGO",.F.)
Local lOk     	:= 	.F.
Local lRet		:= 	.F.

	DEFINE MSDIALOG oDlgMain TITLE "Atualizar cadastro de produto" FROM 000, 000  TO 190, 500 COLORS 0, 16777215 PIXEL

		nUltLin    := 15
		nCol       := 15
		@ nUltLin,nCol SAY "Código da Linha" SIZE 45, 07 OF oDlgMain PIXEL 
		@ nUltLin-2,nCol+50 MSGET oLinha Var cCodLin  WHEN .T.  SIZE 65, 08 OF oDlgMain PIXEL F3 "ZC4" VALID ExistCpo("ZC4",cCodLin) .Or. Empty(cCodLin)

		nUltLin += 18
		@ nUltLin		,nCol SAY "Campo LINHA do cadastro de produto inválido." SIZE 176, 07 OF oDlgMain  PIXEL 
		@ nUltLin + 15	,nCol SAY "Necessário ajustar a linha do produto. " +;
								  "Ao confirmar o código da linha, "			SIZE 176, 07 OF oDlgMain  PIXEL 
		@ nUltLin + 22	,nCol SAY "este será atualizado automaticamente no cadastro de produtos.  "  SIZE 176, 07 OF oDlgMain  PIXEL 
		@ nUltLin + 35	,nCol SAY  "Informe código da linha para prosseguir."  	SIZE 176, 07 OF oDlgMain  PIXEL 


		oBtn := TButton():New( 015, 186 ,"Confirmar Linha"   , oDlgMain,{||  lOk:= .T. , oDlgMain:End()  	},50, 011,,,.F.,.T.,.F.,,.F.,,,.F. ) 
		oBtn := TButton():New( 030, 186 ,"Cancelar"          , oDlgMain,{|| oDlgMain:End() 					},50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   

	ACTIVATE MSDIALOG oDlgMain CENTERED

	If lOk .and. !Empty(cCodLin)
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+ aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "DA1_CODPRO"})] )
			RecLock('SB1',.F.)
				B1_ZLINHA := cCodLin
			SB1->(MsUnlock())

			If B1_ZLINHA == cCodLin
				lRet := .T.
			EndIf

		EndIf
	EndIf 
	
Return lRet
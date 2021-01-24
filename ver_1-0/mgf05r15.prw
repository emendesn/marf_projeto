#INCLUDE "rwMake.ch"                        
#INCLUDE "PROTHEUS.CH" 
#Include "TopConn.ch"  

/*/{Protheus.doc} MGF05R15
@description
Relatório listará cadastro de produtos x linhas de produtos

@author Henrique Vidal Santos
@since 13/01/2020

@version P12.1.017
@country Brasil
@language Português

@type Function  
@table 
	SB1 - Cadastro de produtos
	ZC4 - LINHA DE PRODUTO              
@param
@return
@menu
	Sigafat/Relatórios/Especificos - MGF05R15.PRW 
/*/

User Function MGF05R15()   

	Private cperg := Padr("MGF05R15",Len(SX1->X1_GRUPO))

	MGFPGT() 

	If pergunte(cperg,.T.)

		fwmsgrun(,{|| MGFQRY()},"Aguarde...","Consultando dados...")

	Else

		Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Relatório Cancelado"),{"OK"})

	Endif   

Return

/* 
@Function: MGFQRY- Executa query e relatório
@Autor: Henrique Vidal @Date: 13/01/2020    
*/ 

Static Function MGFQRY()

	Local aheader 	:= {}
	Local acols 	:= {}
	Local cquery 	:= ""
	Local calias 	:= getnextalias()

	cQuery := " SELECT B1_COD,B1_DESC,B1_ZLINHA,
	cQuery += " (
	cQuery += "   SELECT ZC4_DESCRI FROM ZC4010 ZC4 WHERE ZC4.D_E_L_E_T_ <> '*' AND ZC4.ZC4_CODIGO = B1_ZLINHA
	cQuery += " ) AS ZC4DESC 
	cQuery += " FROM SB1010 SB1 
	cQuery += " WHERE SB1.D_E_L_E_T_ <> '*'
	cQuery += " AND B1_ZLINHA > ' ' 
	cQuery += " AND B1_XENVECO = '1' 

	If !Empty(MV_PAR01)
		cQuery += " AND B1_FILIAL IN " + formatin(MV_PAR01,";")
	Endif

	If !Empty(MV_PAR02)
		cQuery += " AND B1_COD >='" + MV_PAR02 + "' AND B1_COD <='" + MV_PAR03 + "' " 
	Endif

	cQuery += " ORDER BY B1_COD

	DBUseArea( .T. , "TOPCONN" , TCGenQry(,,cQuery) , calias , .F. , .T. )
		
	(calias)->( DBGoTop() )

	Do while (calias)->(!Eof())

		AADD(aCOLS,{(calias)->B1_COD,;
					(calias)->B1_DESC,;
					(calias)->B1_ZLINHA,;
					(calias)->ZC4DESC})
		(calias)->(Dbskip())

	Enddo

	(calias)->(Dbclosearea())

	aheader := {"Código",;
				"Produto",;
				"Linha",;
				"Descrição"}

	If len(acols) > 0

		U_MGListBox( "Produtos x Linhas" , aheader , acols , .T. , 1 )

	Else

		Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Não foram localizados títulos com nosso número duplicado"),{"OK"})

	Endif

Return

/* 
@Function: MGFPGT- Forma perguntas
@Autor: Henrique Vidal @Date: 13/01/2020    
*/ 

Static Function MGFPGT()

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j   


	dbSelectArea("SX1")
	dbSetOrder(1)

    aAdd(aRegs,{cPerg,"01","Filiais        ?","","","mv_ch1","C",99,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","LSTFIL","","","",""})
	aAdd(aRegs,{cPerg,"02","Do produto     ?","","","mv_chi","C",6,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
	aAdd(aRegs,{cPerg,"03","Ate produto    ?","","","mv_chj","C",6,0,0,"G","","MV_PAR03","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)


Return()


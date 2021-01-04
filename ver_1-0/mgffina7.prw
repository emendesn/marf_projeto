#INCLUDE "rwMake.ch"                        
#INCLUDE "PROTHEUS.CH" 
#Include "TopConn.ch"  

/*
=====================================================================================
Programa............: MGFFINA7
Autor...............: Josué Danich Prestes
Data................: 18/07/2019
Descrição / Objetivo: Relatório de títulos com nosso numero duplicado - PRB0040153 
=====================================================================================
*/
User Function MGFFINA7()    

Private cperg := "MGFFINA7  "


MGFFINA7X1() //Cria perguntes no sx1

If pergunte(cperg,.T.)

    fwmsgrun(,{|| MGFFINA7E()},"Aguarde...","Montando relatório...")

Else

    Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Relatório Cancelado"),{"OK"})

Endif   


Return

/*
=====================================================================================
Programa............: MGFFINA7E
Autor...............: Josué Danich Prestes
Data................: 18/07/2019
Descrição / Objetivo: Execução de query e relatório
=====================================================================================
*/
Static Function MGFFINA7E()

Local aheader := {}
Local acols := {}
Local cquery := ""
Local calias := getnextalias()
Local _cdtini := SUPERGETMV("MV_MGFFINA71", .F., "20010101") //Parametro de limitação de data de busca para performance

cQuery := " SELECT  E1_FILIAL,E1_NUM,E1_VALOR,E1_VENCREA,E1_NUMBCO,E1_PREFIXO,E1_PARCELA, "
cQuery += " E1_TIPO,E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_PORTADO, E1_AGEDEP,E1_NUMBOR,E1_CONTA, "
cQuery += " (SELECT E12.R_E_C_N_O_ FROM SE1010 E12 	WHERE E12.D_E_L_E_T_ <> '*' "
cQuery += "    								               AND E12.E1_NUMBCO = E1.E1_NUMBCO "
cQuery += "  											   AND E12.E1_EMISSAO > '" + _cdtini + "' "
cQuery += "                                                AND E12.R_E_C_N_O_ <> E1.R_E_C_N_O_
cQuery += "                                                AND ROWNUM = 1) AS DUP "
cQuery += " FROM  "+ RetSqlName('SE1') +' E1 '
cQuery += " WHERE	D_E_L_E_T_ = ' '
If !empty(MV_PAR01)
	cQuery += " AND E1_FILIAL IN " + formatin(MV_PAR01,";")
Endif
cQuery += " AND E1_PREFIXO>='" + MV_PAR02 + "' AND E1_PREFIXO<='" + MV_PAR03 + "' " 
cQuery += " AND E1_NUM>='" + MV_PAR04 + "' AND E1_NUM<='" + MV_PAR05 + "' "
cQuery += " AND E1_PARCELA>='" + MV_PAR06 + "' AND E1_PARCELA<='" + MV_PAR07 + "' "
cQuery += " AND E1_PORTADO>='" + MV_PAR08 + "' AND E1_PORTADO<='" + MV_PAR09 + "' "
cQuery += " AND E1_CLIENTE>='" + MV_PAR10 + "' AND E1_CLIENTE<='" + MV_PAR11 + "' "
cQuery += " AND E1_LOJA>='" + MV_PAR12 + "' AND E1_LOJA<='"+MV_PAR13+"' "
cQuery += " AND E1_EMISSAO>='"+DTOS(mv_par14)+"' AND E1_EMISSAO<='"+ DTOS(mv_par15)+"' "
cQuery += " AND E1_VENCREA>='"+DTOS(mv_par16)+"' AND E1_VENCREA<='"+ DTOS(mv_par17)+"' " 
cQuery += " AND E1_NUMBOR>='" + MV_PAR18 + "' AND E1_NUMBOR<='" + MV_PAR19 + "' "
cQuery += " AND E1.E1_NUMBCO <> ' ' "
cQuery += " AND EXISTS(SELECT E1_NUMBCO FROM SE1010 E12 WHERE E12.D_E_L_E_T_ <> '*' "
cQuery += "  												   AND E12.E1_NUMBCO = E1.E1_NUMBCO "
cQuery += " 												   AND E12.E1_EMISSAO > '" + _cdtini + " ' "
cQuery += "                                                    AND E12.R_E_C_N_O_ <> E1.R_E_C_N_O_) "
cQuery += " ORDER BY E1_FILIAL,E1_VENCREA "

DBUseArea( .T. , "TOPCONN" , TCGenQry(,,cQuery) , calias , .F. , .T. )
	
(calias)->( DBGoTop() )

Do while (calias)->(!Eof())

	SE1->(Dbgoto((calias)->DUP))

    AADD(aCOLS,{(calias)->E1_FILIAL,;
				(calias)->E1_PREFIXO,;
                (calias)->E1_NUM,;
				(calias)->E1_TIPO,;
				(calias)->E1_PARCELA,;
				stod((calias)->E1_VENCREA),;
                (calias)->E1_VALOR,;
				(calias)->E1_CLIENTE,;
				(calias)->E1_LOJA,;
				(calias)->E1_NOMCLI,;
				(calias)->E1_PORTADO,;
				(calias)->E1_NUMBOR,;
				(calias)->E1_AGEDEP,;
				(calias)->E1_CONTA,;
                (calias)->E1_NUMBCO,;
				SE1->E1_FILIAL,;
				SE1->E1_PREFIXO,;
				SE1->E1_NUM,;
				SE1->E1_TIPO,;
				SE1->E1_PARCELA,;
				SE1->E1_VENCREA,;
				SE1->E1_VALOR,;
				SE1->E1_CLIENTE,;
				SE1->E1_LOJA,;
				SE1->E1_NOMCLI,;
				SE1->E1_NUMBOR})

    (calias)->(Dbskip())

Enddo

(calias)->(Dbclosearea())

aheader := {"Filial",;
			"Prefixo",;
			"Titulo",;
			"Tipo",;
			"Parcela",;
			"Vencimento",;
			"Valor",;
			"Cod Cli",;
			"Loja",;
			"Cliente",;
			"Banco",;
			"Bordero",;
			"Agencia",;
			"Conta",;
			"Nosso numero",;
			"Filial Dup",;
			"Prefixo Dup",;
			"Titulo Dup",;
			"Tipo Dup",;
			"Parc Dup",;
			"Venc Dup",;
			"Valor Dup",;
			"Cod Cli Dup",;
			"Loja Dup",;
			"Cliente Dup",;
			"Bordero Dup"}

If len(acols) > 0

	U_MGListBox( "Títulos com nosso número duplicado" , aheader , acols , .T. , 1 )

Else

    Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Não foram localizados títulos com nosso número duplicado"),{"OK"})

Endif

Return

/*
=====================================================================================
Programa............: MGFFINA7X1
Autor...............: Josué Danich Prestes
Data................: 18/07/2019
Descrição / Objetivo: Cria perguntas no sx1
=====================================================================================
*/
Static Function MGFFINA7X1()

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j   


	dbSelectArea("SX1")
	dbSetOrder(1)

    aAdd(aRegs,{cPerg,"01","Filiais        ?","","","mv_ch1","C",99,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","LSTFIL","","","",""})
	aAdd(aRegs,{cPerg,"02","De Prefixo     ?","","","mv_ch2","C",TamSX3("E1_PREFIXO")[1],0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Ate Prefixo    ?","","","mv_ch3","C",TamSX3("E1_PREFIXO")[1],0,0,"G","","MV_PAR03","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","De Numero      ?","","","mv_ch4","C",TamSX3("F2_DOC")[1],0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Ate Numero     ?","","","mv_ch5","C",TamSX3("F2_DOC")[1],0,0,"G","","MV_PAR05","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","De Parcela     ?","","","mv_ch6","C",TamSX3("E1_PARCELA")[1],0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Ate Parcela    ?","","","mv_ch7","C",TamSX3("E1_PARCELA")[1],0,0,"G","","MV_PAR07","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08","De Portador    ?","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	aAdd(aRegs,{cPerg,"09","Ate Portador   ?","","","mv_ch9","C",3,0,0,"G","","MV_PAR09","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	aAdd(aRegs,{cPerg,"10","De Cliente     ?","","","mv_cha","C",TamSX3("A1_COD")[1],0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(aRegs,{cPerg,"11","Ate Cliente    ?","","","mv_chb","C",TamSX3("A1_COD")[1],0,0,"G","","MV_PAR11","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(aRegs,{cPerg,"12","De Loja        ?","","","mv_chc","C",TamSX3("A1_LOJA")[1],0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"13","Ate Loja       ?","","","mv_chd","C",TamSX3("A1_LOJA")[1],0,0,"G","","MV_PAR13","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"14","De Emissao     ?","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"15","Ate Emissao    ?","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"16","De Vencimento  ?","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"17","Ate Vencimento ?","","","mv_chh","D",8,0,0,"G","","MV_PAR17","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"18","Do Bordero     ?","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"19","Ate Bordero    ?","","","mv_chj","C",6,0,0,"G","","MV_PAR19","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})

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


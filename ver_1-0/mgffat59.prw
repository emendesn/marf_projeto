#INCLUDE "TOTVS.CH"
#Include "XMLXFUN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"

/*
=====================================================================================
Programa............: MGFFAT59
Autor...............: Flavio Dentello
Data................: 24/11/2017
Descricao / Objetivo: Cancelamento de Averbação
=====================================================================================
*/

/// Chamada via Menu (Teste)

User Function xFAT59()

	Runfat59()

Return

///Chamada Schedule
user function MGFFAT59(aEmpX)

	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA aEmpX[2] FILIAL aEmpX[3]

	conout('[MGFFAT59] Iniciada Threads para a empresa' + allTrim( aEmpX[3] ) + ' - ' + dToC(dDataBase) + " - " + time())

	Runfat59()

	RESET ENVIRONMENT

Return

/// Processamento
Static Function Runfat59()		

	Local cAlias  	:= ""
	Local cAlias2 	:= ""
	Local cDBStr	:= GetMv("MGF_FAT59A",,"@!!@ORACLE/SPED")//Banco TSS
	Local cDBSrv  	:= GetMv("MGF_FAT59B",,"spdwvapl189")// Servidor do Banco do TSS
	Local nDBPrt  	:= GetMv("MGF_FAT59C")//Porta do Banco TSS                                         
	Local cChaveNFE := ""
	Local cNomArq 	:= ""
	Local cDirGrv	:= GetMv("MGF_FAT41A",,"\\SPDWVAPL182\XML_NFE\") // Caminho de rede, pasta XML_NFE compartilhada
	Local cDirSrv	:= GetMv("MGF_FAT41B",,"\MGF\FAT\XML_NFE\") 	 // Caminho de gravação de Arquivos
	Local cDirCmp	:= "" // Complemento de caminho de gravação de Arquivos
	Local cDatIni	:= GetMv("MGF_FAT41C",,"20171129") 	 // Data Início - Referência para Averbação RCTRC
	Local aExecute  := {}
	Local aNotas	:= {}    
	Local cModalidade := ""
	Private oDoc	:= Nil


	*****************************************************
	// Query que consulta os cancelamentos da tabela SF3
	*****************************************************

	cAlias := GetNextAlias()           

	cQuery := " SELECT * FROM "
	cQuery +=  RetSqlName("SF3") + " SF3 "
	cQuery += " WHERE SF3.F3_CODRSEF = '101'"
	cQuery += " AND SF3.F3_EMISSAO >= '" + cDatIni + "'"
	cQuery += " AND SF3.F3_ZARQXML = ' ' "
	cQuery += " AND SF3.D_E_L_E_T_<> '*' "

	conout(cQuery)

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)


	WHILE (cAlias)->(!eof())

		cChaveNFE := (cAlias)->F3_CHVNFE

		/// Busca xml no banco do TSS
		nHwnd := TCLINK( cDBStr,cDBSrv,nDBPrt )

		dbUseArea(.T.,"TOPCONN","SPED150","XXX1")
		IndRegua("XXX1",CriaTrab(Nil,.F.),"NFE_CHV",,,"INDEXANDO...")

		If nHwnd >= 0
			If XXX1->(MSSeek(cChaveNFE))
				If !Empty(PROTOCOLO) .AND. TPEVENTO = 110111
					If !Empty(XML_SIG)

						cXml := XML_SIG

						cNomArq := NFE_CHV + "CANC"+".xml"
						cDirCmp := (cAlias)->F3_FILIAL + "\" + Tran( DTOS(DDATABASE) , "@R 9999\99\99\" )

						TCUnlink()

						cAlias2 := GetNextAlias()

						cQuery := " SELECT * FROM "
						cQuery +=  RetSqlName("ZBS") + " ZBS " + ", " +RetSqlName("SF3") + " SF3 " + ", " +RetSqlName("SA1") + " SA1 "
						cQuery += " WHERE ZBS.ZBS_FILIAL = '" + (cAlias)->F3_FILIAL +"'"
						cQuery += " AND ZBS.ZBS_NUM = '" + (cAlias)->F3_NFISCAL + "'"
						cQuery += " AND ZBS.ZBS_SERIE = '" + (cAlias)->F3_SERIE + "'"
						cQuery += " AND ZBS.ZBS_OPER = '1' "
						cQuery += " AND SF3.F3_FILIAL = ZBS.ZBS_FILIAL "
						cQuery += " AND SF3.F3_CLIEFOR = '" + (cAlias)->F3_CLIEFOR + "'"
						cQuery += " AND SF3.F3_LOJA = '" + (cAlias)->F3_LOJA + "'"
						cQuery += " AND SF3.F3_NFISCAL = ZBS.ZBS_NUM "
						cQuery += " AND SF3.F3_SERIE = ZBS.ZBS_SERIE "
						cQuery += " AND SA1.A1_COD = SF3.F3_CLIEFOR "
						cQuery += " AND SA1.A1_LOJA = SF3.F3_LOJA "
						cQuery += " AND SA1.A1_FILIAL = '" + XFILIAL("SA1") + "'" 
						cQuery += " AND ZBS.D_E_L_E_T_<> '*' "
						cQuery += " AND SF3.D_E_L_E_T_<> '*' "
						cQuery += " AND SA1.D_E_L_E_T_<> '*' "


						cQuery := ChangeQuery(cQuery)

						dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias2, .F., .T.)


						If  (cAlias2)->(!eof())


							U_zMakeDir( cDirSrv + cDirCmp ) //\MGF\FAT\XML_NFE\020001\2017\11\29\

							MemoWrite(cDirSrv+cDirCmp+cNomArq,cXml)// retirei o .xml que estava a mais no arquivo


							dbSelectArea("SF3")
							dBsetOrder(5)//F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA+F3_IDENTFT                                                                                                                          
							If DbSeek((cAlias)->F3_filial+alltrim((cAlias)->F3_SERIE)+alltrim((cAlias)->F3_NFISCAL)+(cAlias)->F3_CLIEFOR+(cAlias)->F3_LOJA )

								RecLock("SF3",.F.)
								SF3->F3_ZARQXML :=  cDirGrv + cDirCmp + cNomArq
								SF3->( msUnlock() )

								dbSelectArea("ZBS")
								dbSetOrder(1) //ZBS->FILIAL+ZBS_NUM+ZBS_SERIE+ZBS_OPER
								If ZBS->( dbSeek( (cAlias)->F3_filial + (cAlias)->F3_NFISCAL + (cAlias)->F3_SERIE + "2" ) )
									RecLock("ZBS",.F.)
								Else
									RecLock("ZBS",.T.)
								Endif

								ZBS->ZBS_FILIAL	:= (cAlias)->F3_filial
								ZBS->ZBS_NUM	:= (cAlias)->F3_NFISCAL
								ZBS->ZBS_SERIE	:= (cAlias)->F3_SERIE
								ZBS->ZBS_EMISS	:= SF3->F3_EMISSAO
								ZBS->ZBS_SITUAC	:= "N"
								ZBS->ZBS_VALTOT	:= (cAlias2)->ZBS_VALTOT
								ZBS->ZBS_PEDIDO	:= (cAlias2)->ZBS_PEDIDO
								ZBS->ZBS_OE		:= (cAlias2)->ZBS_OE
								ZBS->ZBS_CODCLI	:= (cAlias)->F3_CLIEFOR
								ZBS->ZBS_LOJCLI	:= (cAlias)->F3_LOJA
								ZBS->ZBS_NOMCLI	:= (cAlias2)->A1_NREDUZ
								ZBS->ZBS_UF		:= (cAlias)->F3_ESTADO
								ZBS->ZBS_CNPJ	:= (cAlias2)->A1_CGC 
								ZBS->ZBS_TRANSP	:= (cAlias2)->ZBS_TRANSP
								ZBS->ZBS_NOMTRN	:= (cAlias2)->ZBS_NOMTRN
								ZBS->ZBS_STATUS	:= "N"
								ZBS->ZBS_ARQXML	:= cDirGrv + cDirCmp + cNomArq
								ZBS->ZBS_OPER := "2"// 2= Cancelamento ; 1=Averbação
								ZBS->( msUnlock() )

							EndIf

						EndIf
					EndIf
				EndIf	
			EndIf
		EndIf
		(cAlias)->(dbskip())
	Enddo

	(cAlias)->(DbCloseArea())
	(cAlias2)->(DbCloseArea())

Return


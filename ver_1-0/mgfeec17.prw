#Include 'Protheus.ch'  
/*
==========================================================================================
Programa.:              MGFEEC17
Autor....:              Leo Kume
Data.....:              Nov/2016
Descricao / Objetivo:   Relatório de Follow Up para Documentos de Exportação  
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
==========================================================================================
*/
User Function MGFEEC17()

	//Função nova para novo layout do Follow UP.
	u_MGFEEC40()
	
Return


//Função antiga Relatorio Follow UP, alterado modelo.
User Function OLDEEC17()
Local oReport

If TRepInUse()	
	Pergunte("MGFEEC17",.F.)	
	oReport := ReportDef()	
	oReport:PrintDialog()	
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection
//Local oBreak

oReport := TReport():New("MGFEEC17",'Follow Up Documentos Exportação',"MGFEEC17",{|oReport| PrintReport(oReport)},'Follow Up Documentos Exportação')

oSection := TRSection():New(oReport,"Pedidos",{"ZZ2","ZZJ","SZZ","USR"})
TRCell():New(oSection,"PEDIDO"		,"ZZJ"	,"Pedido Export."		,,							,.F.,,,,,,,.F.)
TRCell():New(oSection,"COD_DOC"		,"ZZJ"	,"Cod.Docmento"			,,							,.F.,,,,,,,.F.)
TRCell():New(oSection,"DOCUMENTO"	,"ZZ2"	,"Documento"			,,							,.F.,,,,,,,.F.)
TRCell():New(oSection,"RESPONSAVEL"	,"ZZJ"	,"Cod.Responsável"		,,							,.F.,,,,,,,.F.)
TRCell():New(oSection,"NOME_RESP"	,"USR"	,"Responsável"			,,							,.F.,,,,,,,.F.)
TRCell():New(oSection,"FINALIZADO"	,"ZZJ"	,"Finalizado?"			,,							,.F.,,,,,,,.F.)
TRCell():New(oSection,"NECESSARIO"	,"ZZJ"	,"Necessário?"			,,							,.F.,,,,,,,.F.)
TRCell():New(oSection,"QTD_DIAS"	,"ZZJ"	,"Dias a Contar"		,,							,.F.,,,,,,,.F.)
TRCell():New(oSection,"DATA_BASE"	,"ZZJ"	,"Data Base"			,,							,.F.,,,,,,,.F.)
TRCell():New(oSection,"DATA_PREV"	,"ZZJ"	,"Prev.Conclusão"		,,							,.F.,,,,,,,.F.)
TRCell():New(oSection,"DATA_CONCLU"	,"ZZJ"	,"Data Conclusão"		,,							,.F.,,,,,,,.F.)

//oBreak := TRBreak():New(oSection,oSection:Cell("PEDIDO"),"Sub Total ")
//TRFunction():New(oSection:Cell("COD_DOC"),NIL,"COUNT",oBreak)

Return oReport


Static Function PrintReport(oReport)

Local oSection := oReport:Section(1)
Local cPart
Local cFiltro   := ""
Local cAliasZZJ := GetNextAlias()

_cQuery := "  SELECT ZZJ_PEDIDO,ZZJ_CODDOC, ZZJ_PEDIDO, ZZ_DESCR,ZZJ_FINALI, "
_cQuery += " ZZJ_NECESS,ZZJ_QTDIAS,ZZJ_DTBASE,ZZJ_PRVCON,ZZJ_CONCLU	 "	
_cQuery += " FROM "+RetSqlName("ZZJ")+" ZZJ
_cQuery += " INNER JOIN "+RetSqlName("SZZ")+" SZZ
_cQuery += " ON  SZZ.ZZ_FILIAL = '"+xFilial("SZZ")+"' AND
_cQuery += " 		SZZ.D_E_L_E_T_ = ' ' AND
_cQuery += " 	SZZ.ZZ_CODDOC = ZZJ.ZZJ_CODDOC 
_cQuery += " WHERE 	ZZJ.D_E_L_E_T_ = ' ' AND
_cQuery += " 		ZZJ.ZZJ_FILIAL = '"+xFilial("ZZJ")+"' AND
If !Empty(alltrim(MV_PAR05))
	_cQuery += " 		ZZJ.ZZJ_PEDIDO = '"+MV_PAR05+"' AND "
EndIf
If !Empty(alltrim(MV_PAR04))
	_cQuery += " 		ZZJ.ZZJ_RESPON = '"+MV_PAR04+"' AND "
EndIf
_cQuery += " 		ZZJ.ZZJ_FINALI IN ("+iif(MV_PAR03==2,"'N'","'S','N'")+") AND "
//Se filtrar finalizados considerar todos os com data menor que "até data", senão também considerar o parâmetro "de data"
If MV_PAR03 == 1
	_cQuery += " 		ZZJ.ZZJ_PRVCON >= '"+DTOS(MV_PAR01)+"' AND "
EndIf
_cQuery += " 		ZZJ.ZZJ_PRVCON <= '"+DTOS(MV_PAR02)+"' AND "
_cQuery += " 		SZZ.ZZ_MSBLQL = '2' "
_cQuery += " ORDER BY ZZJ.ZZJ_PEDIDO, ZZJ.ZZJ_CODDOC
_cQuery := ChangeQuery(_cQuery) 
	
//%DEFINE O ALIAS PARA A QUERY E VERIFICAR SE O ALIAS ESTA EM USO
If Select(cAliasZZJ) > 0
	DbSelectArea(cAliasZZJ)
	DbCloseArea()
EndIf
	
//%CRIAR O ALIAS EXECUTANDO A QUERY
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,_cQuery),cAliasZZJ,.F.,.T.)

	
oSection:Init()

//(cAliasZZJ)->(dbGoTop())
	
While !oReport:Cancel() .And. !((cAliasZZJ)->(EOF()))
	
	oReport:IncMeter()

	oSection:Cell("PEDIDO")			:SetValue((cAliasZZJ)->ZZJ_PEDIDO)		 			
	oSection:Cell("COD_DOC")   		:SetValue((cAliasZZJ)->ZZJ_CODDOC)	
	oSection:Cell("DOCUMENTO")		:SetValue((cAliasZZJ)->ZZ_DESCR)
	oSection:Cell("FINALIZADO")	   	:SetValue((cAliasZZJ)->ZZJ_FINALI)	
	oSection:Cell("NECESSARIO")		:SetValue((cAliasZZJ)->ZZJ_NECESS)	   			
	oSection:Cell("QTD_DIAS")		:SetValue((cAliasZZJ)->ZZJ_QTDIAS)					
	oSection:Cell("DATA_BASE")		:SetValue(DTOC(STOD((cAliasZZJ)->ZZJ_DTBASE)))		   			
	oSection:Cell("DATA_PREV")		:SetValue(DTOC(STOD((cAliasZZJ)->ZZJ_PRVCON))) 			
	oSection:Cell("DATA_CONCLU")	:SetValue(DTOC(STOD((cAliasZZJ)->ZZJ_CONCLU)))
	

	oSection:PrintLine()
		
	(cAliasZZJ)->(dbSkip())

Enddo
	
//oSection:Print()

Return


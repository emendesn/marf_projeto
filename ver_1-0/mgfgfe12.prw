#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PRTOPDEF.CH"           
//#Include "FIVEWIN.Ch"

                      
/*
=========================================================================================================
Programa.................: MGFGFE12
Autor:...................: Flavio Dentello
Data.....................: 03/04/2017
Descricao / Objetivo.....: Relatorio de titulos de frete a pagar
Doc. Origem..............: GAP - GFE10
Solicitante..............: 
Uso......................: 
Obs......................: Criado para regra de descontos de RCTRC
=========================================================================================================
*/


User Function MGFGFE12()

Local oReport

Local oBreak
Local lRet := .F.

If FindFunction("TRepInUse") .And. TRepInUse()
	
	oReport:=ReportDef()
	oReport:PrintDialog()
	
EndIf

Return

Static Function ReportDef(nReg)

Local oReport
Local oSintetico
Local oSintetico2
Local oSection3
Local oSection4
Local oSection5
Local oCell
Local aOrdem := {}        
Local ntotal := 0

Private cPerg := "MGFGFE12"

Public cAliasGWN := GetNextAlias()
     
//������������������������������������������������������������������������Ŀ
//�Habilita as perguntas da Rotina                                         �
//��������������������������������������������������������������������������

ValidPerg()

oReport:= TReport():New("MGFGFE12","Relatorio de Titulo de Frete","MGFGFE12", {|oReport| ReportPrint(oReport)},"")
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

Pergunte("MGFGFE12",.T.)

oSintetico := TRSection():New(oReport,"Relatorio de Titulo de Frete",{"cAliasGWN"}) //"Relacao de Pedidos de Compras"
oSintetico :SetTotalInLine(.F.)

TRCell():New(oSintetico,"FILIAL"	       ,"cAliasGWN" , "Filial"	            /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"NUM_ROMANEIO"     ,"cAliasGWN" , "Romaneio"	            /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"COD_TIPO_VEICULO" ,"cAliasGWN" , "Tp Ve�culo"	        /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DESC_TIPO_VEICULO","cAliasGWN" , "Descr.Tp Ve�culo"      /*Titulo*/	,/*Picture*/,35/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"NUM_TITULO"       ,"cAliasGWN" , "Titulo"				/*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DT_EMISSAO"	   ,"cAliasGWN" , "Emissao"   			/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->DT_EMISSAO,7,2)+"/"+SUBS(cAliasGWN->DT_EMISSAO,5,2)+"/"+SUBS(cAliasGWN->DT_EMISSAO,1,4)})
TRCell():New(oSintetico,"DT_VENCIMENTO"    ,"cAliasGWN" , "Vencimento"  			/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->DT_VENCIMENTO,7,2)+"/"+SUBS(cAliasGWN->DT_VENCIMENTO,5,2)+"/"+SUBS(cAliasGWN->DT_VENCIMENTO,1,4)})
TRCell():New(oSintetico,"DESCONTO_GERAL"   ,"cAliasGWN",  "Vlr Desconto"			/*Titulo*/	,"@E 999,999.99"/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DECRESCIMO"	   ,"cAliasGWN",  "Decr�scimo"      		/*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"FORNECEDOR"	   ,"cAliasGWN",  "Fornecedor"      		/*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DESC_DESCONTO"	   ,"cAliasGWN",  "Descr Desconto"   		/*Titulo*/	,/*Picture*/,30/*Tamanho*/,/*lPixel*/,{||ALLTRIM(cAliasGWN->DESC_DESCONTO)})
TRCell():New(oSintetico,"DESCONTO_RCTRC"   ,"cAliasGWN",  "Desc RCTRC"     		/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GWN_DTIMPL"	   ,"cAliasGWN",  "Data Implant"   		/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->GWN_DTIMPL,7,2)+"/"+SUBS(cAliasGWN->GWN_DTIMPL,5,2)+"/"+SUBS(cAliasGWN->GWN_DTIMPL,1,4)})
TRCell():New(oSintetico,"E2_VENCTO_FILTRO" ,"cAliasGWN",  "Vencto Filtro"  		/*Titulo*/	,/*Picture*/,15/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->E2_VENCTO_FILTRO,7,2)+"/"+SUBS(cAliasGWN->E2_VENCTO_FILTRO,5,2)+"/"+SUBS(cAliasGWN->E2_VENCTO_FILTRO,1,4)})
TRCell():New(oSintetico,"GW3_EMISDF"	   ,"cAliasGWN",  "Emitente"	    	    /*Titulo*/	,/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GW3_NRDF"	       ,"cAliasGWN",  "Numero DF"	    	    /*Titulo*/	,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
Return(oReport)

Static Function ReportPrint(oReport)
Local oSintetico := oReport:Section(1)

Local nTxMoeda	:= 1
Local lFirst    := .F.
Local nOrdem    := oReport:Section(1):GetOrder()

Local nFilters 	:= 0
Local nI
Local cProdAnt := " "
Local cOrdem := " "

Local nAtual := 0
Local nTotal := 0

Local oSectDad := Nil

#IFNDEF TOP
	Local cCondicao := ""
#ELSE
	Local cWhere := ""
	Local cFrom := "%%"
#ENDIF

Local lFilUsr	:= oSintetico:GetAdvplExp() <> ""

MakeSqlExpr(oReport:uParam)
oReport:Section(1):BeginQuery()

//������������������������������������������������������������������������Ŀ
//�Todos os campos que serao impressos no relatorio������������������������
//��������������������������������������������������������������������������

//BeginSql Alias cAliasGWN

cQuery := ' '
cQuery += "SELECT DISTINCT "
cQuery += " GWN_FILIAL          AS FILIAL, "
cQuery += " GWN_NRROM   		AS NUM_ROMANEIO,"
cQuery += " GWN_CDTPVC			AS COD_TIPO_VEICULO,"
cQuery += " DUT_DESCRI			AS DESC_TIPO_VEICULO,"
cQuery += " E2_NUM				AS NUM_TITULO,"
cQuery += " TO_CHAR(TO_DATE( "
cQuery += " CASE WHEN E2_EMISSAO = ' ' "
cQuery += " THEN NULL"
cQuery += "	ELSE "
cQuery += " E2_EMISSAO "
cQuery += "	END "
cQuery += ", 'YYYYMMDD'))		AS DT_EMISSAO"
cQuery += "    , TO_CHAR(TO_DATE("
cQuery += "    CASE WHEN E2_VENCTO = ' '"
cQuery += "   THEN NULL"
cQuery += " ELSE "
cQuery += " E2_VENCTO " 
cQuery += " END"
cQuery += " , 'YYYYMMDD' ))         AS DT_VENCIMENTO"
cQuery += " , E2_VALOR              AS DESCONTO_GERAL"
cQuery += " , E2_DECRESC            AS DECRESCIMO"
cQuery += " , E2_FORNECE	        AS FORNECEDOR"
cQuery += " , ZDS_COD||ZDS_HISTOR   AS DESC_DESCONTO"
cQuery += " , ZDS_VALOR				AS DESCONTO_RCTRC"
cQuery += " , GWN.GWN_DTIMPL"
cQuery += " , E2_VENCTO			    AS E2_VENCTO_FILTRO"
cQuery += " , GW3.GW3_EMISDF"
cQuery += "	, GW3.GW3_NRDF "
cQuery += "  FROM "+RetSqlName("GWN")+" GWN"
cQuery += "  LEFT JOIN "+RetSqlName("GW1") +" GW1 ON GWN.GWN_FILIAL = GW1.GW1_FILIAL "
cQuery += "  AND GWN.GWN_NRROM  = GW1.GW1_NRROM "
cQuery += "  AND GW1.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN "+RetSqlName("GW4") +" GW4 ON GW1.GW1_FILIAL = GW4.GW4_FILIAL "
cQuery += "  AND GW1.GW1_CDTPDC = GW4.GW4_TPDC "
cQuery += "  AND GW1.GW1_EMISDC = GW4.GW4_EMISDC "
cQuery += "  AND GW1.GW1_SERDC  = GW4.GW4_SERDC "
cQuery += "  AND GW1.GW1_NRDC   = GW4.GW4_NRDC "
cQuery += "  AND GW4.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN "+RetSqlName("GW3")+" GW3 ON GW4.GW4_FILIAL = GW3.GW3_FILIAL "
cQuery += "  AND GW4.GW4_EMISDF = GW3.GW3_EMISDF "
cQuery += "  AND GW4.GW4_CDESP  = GW3.GW3_CDESP "
cQuery += "  AND GW4.GW4_SERDF  = GW3.GW3_SERDF "
cQuery += "  AND GW4.GW4_NRDF   = GW3.GW3_NRDF "
cQuery += "  AND GW4.GW4_DTEMIS = GW3.GW3_DTEMIS "
cQuery += "  AND GW3.D_E_L_E_T_ = ' ' "
cQuery += "  LEFT JOIN "+RetSqlName("SA2")+" A2 ON GW3.GW3_EMISDF = A2.A2_CGC "
cQuery += "  AND A2.D_E_L_E_T_  = ' ' "
cQuery += "  LEFT JOIN "+RetSqlName("SE2")+" E2 ON GW3.GW3_FILIAL = E2.E2_FILIAL "
cQuery += "   AND GW3.GW3_EMISDF = A2.A2_CGC "
cQuery += "   AND GW3.GW3_SERDF  = E2.E2_PREFIXO "
cQuery += "   AND GW3.GW3_NRDF   = E2.E2_NUM "
cQuery += "   AND GW3.GW3_DTEMIS = E2.E2_EMISSAO"
cQuery += "   AND E2.E2_HIST     LIKE '%RCTRC%' "
cQuery += "   AND E2.D_E_L_E_T_  = ' '       "
cQuery += "  INNER JOIN "+RetSqlName("ZDS")+" ZDS ON ZDS.ZDS_FILIAL = E2.E2_FILIAL"
cQuery += "  AND ZDS.ZDS_PREFIX = E2.E2_PREFIXO"
cQuery += "                      AND ZDS.ZDS_NUM    = E2.E2_NUM
cQuery += "                      AND ZDS.ZDS_FORNEC = E2.E2_FORNECE
cQuery += "                      AND ZDS.ZDS_LOJA   = E2.E2_LOJA
cQuery += "                      AND ZDS.ZDS_COD    = '621'
cQuery += "                      AND ZDS.D_E_L_E_T_ = ' '
cQuery += "  LEFT JOIN "+RetSqlName("DUT")+" DUT ON GWN.GWN_CDTPVC = DUT.DUT_TIPVEI 
cQuery += "                      AND DUT.D_E_L_E_T_ =' ' 
cQuery += "                      AND DUT.DUT_FILIAL =' ' 
cQuery += "WHERE GWN.GWN_FILIAL =  '"+xFilial("GWN")+"'"
cQuery += "AND GWN.GWN_DTIMPL   >= '"+DTOS(MV_PAR01)+"'"
cQuery += "AND GWN.GWN_DTIMPL   <= '"+DTOS(MV_PAR02)+"'"
cQuery += "AND E2.E2_VENCTO 	>= '"+DTOS(MV_PAR03)+"'"
cQuery += "AND E2.E2_VENCTO     <= '"+DTOS(MV_PAR04)+"'"
cQuery += "AND GW3.GW3_EMISDF   >= '"+MV_PAR05+"'"
cQuery += "AND GW3.GW3_EMISDF   <= '"+MV_PAR06+"'"
cQuery += "AND GWN.GWN_NRROM    >= '"+MV_PAR07+"'"
cQuery += "AND GWN.GWN_NRROM    <= '"+MV_PAR08+"'"
cQuery += "AND GW3.GW3_NRDF     >= '"+MV_PAR09+"'"
cQuery += "AND GW3.GW3_NRDF     <= '"+MV_PAR10+"'"
cQuery += "AND GWN.D_E_L_E_T_ = ' '"
cQuery := ChangeQuery(cQuery)
TcQuery cQuery New Alias "cAliasGWN"

//Memowrite("c:\temp\cQuery.txt",cquery)

Count To nTotal 
oReport:SetMeter(nTotal)
oSintetico:Init()
cAliasGWN->(DbGoTop())
While ! cAliasGWN->(Eof())
    nAtual++
    oReport:SetMsgPrint("Imprimindo registro "+cValtoChar(nAtual)+" de "+cValToChar(ntotal)+"...")
    oReport:IncMeter()
    oSintetico:PrintLine()  
    cAliasGWN->(DbSkip())
ENDDO

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relatorio                               �
//��������������������������������������������������������������������������

cAliasGWN->(DbCloseArea())

Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �VALIDPERG � Autor � Flavio Dentello    � Data �  07/12/2015 ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aPerguntas := {}
Local aRegs := {}
Local i,j
Local cPerg              := "MGFGFE12"
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Data Romaneio de :     ","","","mv_ch1" ,"D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Romaneio ate:     ","","","mv_ch2" ,"D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Data Vencimento de :   ","","","mv_ch3" ,"D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Vencimento ate:   ","","","mv_ch4" ,"D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Transportador de:      ","","","mv_ch5" ,"C",14,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","GU3","","","",""})
aAdd(aRegs,{cPerg,"06","Transportador Ate:     ","","","mv_ch6" ,"C",14,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","GU3","","","",""})
aAdd(aRegs,{cPerg,"07","Romaneio de:           ","","","mv_ch7" ,"C",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","GWN","","","",""})
aAdd(aRegs,{cPerg,"08","Romaneio Ate:          ","","","mv_ch8" ,"C",08,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","GWN","","","",""})
aAdd(aRegs,{cPerg,"09","Documento de Frete de: ","","","mv_ch9" ,"C",09,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Documento de Frete Ate:","","","mv_ch10","C",09,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])//2
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

            
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PRTOPDEF.CH"           

                      
/*/
==============================================================================================================================================================================
{Protheus.doc} MGFGFE62

Relatorio Taxa de Conveniencia

@description
De acordo com os parametros informados, gera relatorio (padrao Treport)
Novo relatório de TAXA DE CONVENIÊNCIA,  contemplando os campos inseridos na VIEW V_LOGIST_TAXA_CONVENIENCIA, 
Considerar os mesmo parâmetros inseridos no relatório de Contas a Pagar RCTRC.

@author Renato Vieira Bandeira Junior
@since 16/03/2020
@type Function

@table 
    GWN, GW1, GW3, GW4, SA2, SE2, GV4, GDS, DUT
	
@param

MV_PAR01 ,"Data Romaneio de :     "
MV_PAR02 ,"Data Romaneio até:     "
MV_PAR03 ,"Data Vencimento de :   "
MV_PAR04 ,"Data Vencimento até:   "
MV_PAR05 ,"Transportador de:      "
MV_PAR06 ,"Transportador Até:     "
MV_PAR07 ,"Romaneio de:           "
MV_PAR08 ,"Romaneio Até:          "
MV_PAR09 ,"Documento de Frete de: "
MV_PAR10 ,"Documento de Frete Até:"
MV_PAR11 ,"	Filiais	Seleção De: "
MV_PAR12 ,"	Filiais	Seleção Até: "
MV_PAR13 ,"	Data de Contabilização	De: "
MV_PAR14 ,"	Data de Contabilização	Até: "
MV_PAR15 ,"	Data de Emissão	De: "
MV_PAR16 ,"	Data de Emissão	Até: "
MV_PAR17 ,"	Data de Vencimento	De: "
MV_PAR18 ,"	Data de Vencimento	Até: "
MV_PAR19 ,"	Data de Pagamento	De: "
MV_PAR20 ,"	Data de Pagamento	Até: "
MV_PAR21 ,"	Data de Baixa	De: "
MV_PAR22 ,"	Data de Baixa	Até: "
MV_PAR23 ,"	Tipo operação (Código)	De: "
MV_PAR24 ,"	Tipo operação (Código)	Até: "
MV_PAR25 ,"	Placa	De: "
MV_PAR26 ,"	Placa	Até: "
MV_PAR27 ,"	Cód Fornecedor	De: "
MV_PAR28 ,"	Cód Fornecedor	Até: "
MV_PAR29 ,"	Emitente	De: "
MV_PAR30 ,"	Emitente	Até: "
MV_PAR31 ,"	Tipo de Relatorio: 1-Com Descon.2-Sem Descont,3-Ambos

@return
 	NIL

@menu
    Gestao Frete Embarcador \ Atualizacoes \ MARFRIF \  Rel Taxa Conveniencia
	
@history
/*/   

User Function MGFGFE62()

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

Private cPerg := "MGFGFE62"

Public cAliasGWN := GetNextAlias()
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Habilita as perguntas da Rotina                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()

oReport:= TReport():New("MGFGFE62","Relatório Taxa de Conveniência","MGFGFE62", {|oReport| ReportPrint(oReport)},"")
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

Pergunte("MGFGFE62",.T.)

oSintetico := TRSection():New(oReport,"Relatório Taxa de Conveniência",{"cAliasGWN"})
oSintetico :SetTotalInLine(.F.)

TRCell():New(oSintetico,"FILIAL"	       ,"cAliasGWN" , "Filial"	            /*Titulo*/	,/*Picture*/,06/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSintetico,"NOME_FILIAL"	   ,"cAliasGWN" , "Nome Filial"         /*Titulo*/	,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSintetico,"NUM_ROMANEIO"     ,"cAliasGWN" , "Romaneio"	        /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSintetico,"OE_REFERENC"     ,"cAliasGWN" , "OE Referenc"	        /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
// RVBJ
TRCell():New(oSintetico,"TIPO_OPERACAO"			,"cAliasGWN" , "Tp Operação"	        /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DESCRICAO_TIPO_OPERACAO"	,"cAliasGWN" , "Descr.Tp Oper"	        /*Titulo*/	,/*Picture*/,35/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSintetico,"VEICULO"	       ,"cAliasGWN" , "Veiculo"	        	/*Titulo*/	,/*Picture*/,07/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"PLACA_VEICULO"	   ,"cAliasGWN" , "Placa Veiculo"      	/*Titulo*/	,/*Picture*/,07/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"TRACAO"   		   ,"cAliasGWN" , "Tracao"	        	/*Titulo*/	,/*Picture*/,07/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"PLACA_TRACAO"     ,"cAliasGWN" , "Placa Tracao"	        	/*Titulo*/	,/*Picture*/,07/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"REBOQUE2" 		   ,"cAliasGWN" , "Reboque2"	       	/*Titulo*/	,/*Picture*/,07/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"PLACAL_REBOQUE2"   ,"cAliasGWN" , "Placa Reboque2"	       	/*Titulo*/	,/*Picture*/,07/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"COD_TIPO_VEICULO" ,"cAliasGWN" , "Tp Veículo"	        /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DESC_TIPO_VEICULO","cAliasGWN" , "Descr.Tp Veículo"      /*Titulo*/	,/*Picture*/,35/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"NUM_TITULO"       ,"cAliasGWN" , "Título"				/*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DT_EMISSAO"	   ,"cAliasGWN" , "Emissão"   			/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->DT_EMISSAO,7,2)+"/"+SUBS(cAliasGWN->DT_EMISSAO,5,2)+"/"+SUBS(cAliasGWN->DT_EMISSAO,1,4)})
TRCell():New(oSintetico,"DT_VENCIMENTO"    ,"cAliasGWN" , "Vencimento"  			/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->DT_VENCIMENTO,7,2)+"/"+SUBS(cAliasGWN->DT_VENCIMENTO,5,2)+"/"+SUBS(cAliasGWN->DT_VENCIMENTO,1,4)})

TRCell():New(oSintetico,"DT_BAIXA	"      ,"cAliasGWN" , "Baixa" 	 			/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->DT_BAIXA,7,2)+"/"+SUBS(cAliasGWN->DT_BAIXA,5,2)+"/"+SUBS(cAliasGWN->DT_BAIXA,1,4)})

TRCell():New(oSintetico,"DESCONTO_GERAL"   ,"cAliasGWN",  "Vlr Titulo"			/*Titulo*/	,"@E 999,999.99"/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DECRESCIMO"	   ,"cAliasGWN",  "Desc Total"      		/*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"FORNECEDOR"	   ,"cAliasGWN",  "Fornecedor"      		/*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSintetico,"DESC_FORNECEDOR"  ,"cAliasGWN",  "Descr Fornecedor"  		/*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"APL_DESC_CONV"    ,"cAliasGWN",  "Apl.Desc.Con"      		/*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DESC_DESCONTO"	   ,"cAliasGWN",  "Descr Desconto"   		/*Titulo*/	,/*Picture*/,30/*Tamanho*/,/*lPixel*/,{||ALLTRIM(cAliasGWN->DESC_DESCONTO)})
TRCell():New(oSintetico,"DESCONTO_RCTRC"   ,"cAliasGWN",  "Desc Tx C"     		/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GWN_DTIMPL"	   ,"cAliasGWN",  "Data Implant"   		/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->GWN_DTIMPL,7,2)+"/"+SUBS(cAliasGWN->GWN_DTIMPL,5,2)+"/"+SUBS(cAliasGWN->GWN_DTIMPL,1,4)})
TRCell():New(oSintetico,"E2_VENCTO_FILTRO" ,"cAliasGWN",  "Vencto Filtro"  		/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->E2_VENCTO_FILTRO,7,2)+"/"+SUBS(cAliasGWN->E2_VENCTO_FILTRO,5,2)+"/"+SUBS(cAliasGWN->E2_VENCTO_FILTRO,1,4)})
TRCell():New(oSintetico,"GW3_EMISDF"	   ,"cAliasGWN",  "Emitente"	    	    /*Titulo*/	,/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSintetico,"DESC_EMISDF"  ,"cAliasGWN",  "Descr Emitente"	    	    /*Titulo*/	,/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSintetico,"GW3_NRDF"	       ,"cAliasGWN",  "Número DF"	    	    /*Titulo*/	,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSintetico,"GW3_SERDF"	       ,"cAliasGWN",  "Serie DF"	    	    /*Titulo*/	,/*Picture*/,05/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Todos os campos que serão impressos no relatórioÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//BeginSql Alias cAliasGWN

cQuery := ' '
cQuery += "SELECT * FROM " + U_IF_BIMFR( "IF_BIMFR", "V_LOGIST_TAXA_CONVENIENCIA" )

If ! Empty(MV_PAR12) //Filiais	Seleção ou De - Até
	cQuery += " WHERE FILIAL BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'"
EndIf
If ! Empty( DTOS(MV_PAR02))
	cQuery += " AND GWN_DTIMPL       BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
Endif
If ! Empty( DTOS(MV_PAR04))
	cQuery += " AND E2_VENCTO_FILTRO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
Endif

If ! Empty( MV_PAR06)
	cQuery += " AND GW3_EMISDF   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
ENDIF
If ! Empty( MV_PAR08)
	cQuery += " AND NUM_ROMANEIO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
Endif
If ! Empty( MV_PAR10)
	cQuery += " AND GW3_NRDF     BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
Endif

//inicio da alteração
If ! Empty( MV_PAR14) //Data de Contabilização	De - Até
	cQuery += " AND DT_EMIS1 BETWEEN '"+dtos(MV_PAR13)+"' AND '"+dtos(MV_PAR14)+"'"
Endif
If ! Empty( MV_PAR15) 	//Data de Emissão	De - Até
	cQuery += " AND DT_EMISSAO BETWEEN '"+dtos(MV_PAR15)+"' AND '"+dtos(MV_PAR16)+"'"
Endif
If ! Empty( MV_PAR17) //Data de Pagamento	De - Até
	cQuery += " AND DT_VENCREA BETWEEN '"+dtos(MV_PAR17)+"' AND '"+dtos(MV_PAR18)+"'"
Endif
If ! Empty( MV_PAR19) //Data de Baixa	De - Até
	cQuery += " AND DT_BAIXA BETWEEN '"+dtos(MV_PAR19)+"' AND '"+dtos(MV_PAR20)+"'"
Endif
If ! Empty( MV_PAR21) //Tipo operação (Código)	De - Até
	cQuery += " AND GWN_CDTPOP BETWEEN '"+MV_PAR21+"' AND '"+MV_PAR22+"'"
Endif
If ! Empty( MV_PAR23) //Placa Dianteira	De - Até
	cQuery += " AND GWN_PLACAD BETWEEN '"+MV_PAR23+"' AND '"+MV_PAR24+"'"
Endif
If ! Empty( MV_PAR25) //	Cód Fornecedor	De - Até
	cQuery += " AND E2_FORNECE BETWEEN '"+MV_PAR25+"' AND '"+MV_PAR26+"'"
Endif
If ! Empty( MV_PAR27) //	Emitente	De - Até
	cQuery += " AND GW3_EMISDF BETWEEN '"+MV_PAR27+"' AND '"+MV_PAR28+"'"
Endif
If MV_PAR29 == 1 	//1-Com desconto /2-Sem desconto /3-Ambos
	cQuery += " AND NVL(DESCONTO_RCTRC,0) <> 0 "
ElseIf MV_PAR29 == 2 
	cQuery += " AND NVL(DESCONTO_RCTRC,0) = 0 "
Endif

If MV_PAR30 == 1 	//Sim Com APL_DESC_CONV
	cQuery += " AND APL_DESC_CONV = '2' " //2-sim
ElseIf MV_PAR30 == 2 //Não Sem APL_DESC_CONV
	cQuery += " AND APL_DESC_CONV = '1' " //1-Nao
Endif

//fim da alteração
Memowrite("MGGFE62.SQL",cQuery)

cQuery := ChangeQuery(cQuery)
TcQuery cQuery New Alias "cAliasGWN"

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cAliasGWN->(DbCloseArea())

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ Flávio Dentello    º Data ³  07/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aPerguntas := {}
Local aRegs := {}
Local i,j
Local cPerg              := "MGFGFE62"
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Data Romaneio de :     ","","","mv_ch1" ,"D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Romaneio até:     ","","","mv_ch2" ,"D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Data Vencimento de :   ","","","mv_ch3" ,"D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Vencimento até:   ","","","mv_ch4" ,"D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Transportador de:      ","","","mv_ch5" ,"C",14,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","GU3","","","",""})
aAdd(aRegs,{cPerg,"06","Transportador Até:     ","","","mv_ch6" ,"C",14,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","GU3","","","",""})
aAdd(aRegs,{cPerg,"07","Romaneio de:           ","","","mv_ch7" ,"C",06,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","GWN","","","",""})
aAdd(aRegs,{cPerg,"08","Romaneio Até:          ","","","mv_ch8" ,"C",06,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","GWN","","","",""})
aAdd(aRegs,{cPerg,"09","Documento de Frete de: ","","","mv_ch9" ,"C",09,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Documento de Frete Até:","","","mv_ch10","C",09,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Filiais	Seleção De:    ","","","mv_ch11","C",06,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Filiais	Seleção Até:   ","","","mv_ch12","C",06,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","Data de Contabiliz De: ","","","mv_ch13","D",08,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"14","Data de Contabiliz Até:","","","mv_ch14","D",08,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"15","Data de Emissão	De:    ","","","mv_ch15","D",08,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"16","Data de Emissão	Até:   ","","","mv_ch16","D",08,0,0,"G","","MV_PAR16","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","Data de Pagamento De:  ","","","mv_ch17","D",08,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"18","Data de Pagamento Até: ","","","mv_ch18","D",08,0,0,"G","","MV_PAR18","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"19","Data de Baixa De:      ","","","mv_ch19","D",08,0,0,"G","","MV_PAR19","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"20","Data de Baixa Até:     ","","","mv_ch20","D",08,0,0,"G","","MV_PAR20","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"21","Tipo oper (Código) De: ","","","mv_ch21","C",10,0,0,"G","","MV_PAR21","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"22","Tipo oper (Código) Até:","","","mv_ch22","C",10,0,0,"G","","MV_PAR22","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"23","Placa De:              ","","","mv_ch23","C",08,0,0,"G","","MV_PAR23","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"24","Placa Até:             ","","","mv_ch24","C",08,0,0,"G","","MV_PAR24","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"25","Cód Fornecedor	De:    ","","","mv_ch25","C",06,0,0,"G","","MV_PAR25","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegs,{cPerg,"26","Cód Fornecedor	Até:   ","","","mv_ch26","C",06,0,0,"G","","MV_PAR26","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegs,{cPerg,"27","Emitente De:           ","","","mv_ch27","C",14,0,0,"G","","MV_PAR27","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"28","Emitente Até:          ","","","mv_ch28","C",14,0,0,"G","","MV_PAR28","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"29","Tipo C/Desc-S/Desc:    ","","","mv_ch29","N",01,0,0,"C","","mv_par29","Com Desconto","Com Desconto","Com Desconto","","","Sem Desconto","Sem Desconto","Sem Desconto","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"30","Com Apl.Desc.Con       ","","","mv_ch30","N",01,0,0,"C","","mv_par30","Sim","Sim","Sim","","","Não","Não","Não","","","Todos","Todos","Todos","","","","","","","","","","","","","","","",""})

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

            
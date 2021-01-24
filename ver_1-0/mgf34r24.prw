#Include "PROTHEUS.Ch"
#INCLUDE "FWCOMMAND.CH"

#DEFINE QUEBR				1
#DEFINE FORNEC				2
#DEFINE TITUL				3
#DEFINE TIPO				4
#DEFINE NATUREZA			5
#DEFINE EMISSAO				6
#DEFINE VENCTO				7
#DEFINE VENCREA				8
#DEFINE VL_ORIG				9
#DEFINE VL_NOMINAL			10
#DEFINE VL_CORRIG			11
#DEFINE VL_VENCIDO			12
#DEFINE PORTADOR			13
#DEFINE VL_JUROS			14
#DEFINE ATRASO				15
#DEFINE HISTORICO			16
#DEFINE VL_SOMA				17
#DEFINE EMIS1				18

#DEFINE STR0001 FWI18NLang("FINR150","STR0001",1)
#DEFINE STR0002 FWI18NLang("FINR150","STR0002",2)
#DEFINE STR0003 FWI18NLang("FINR150","STR0003",3)
#DEFINE STR0004 FWI18NLang("FINR150","STR0004",4)
#DEFINE STR0005 FWI18NLang("FINR150","STR0005",5)
#DEFINE STR0006 FWI18NLang("FINR150","STR0006",6)
#DEFINE STR0007 FWI18NLang("FINR150","STR0007",7)
#DEFINE STR0008 FWI18NLang("FINR150","STR0008",8)
#DEFINE STR0009 FWI18NLang("FINR150","STR0009",9)
#DEFINE STR0010 FWI18NLang("FINR150","STR0010",10)
#DEFINE STR0011 FWI18NLang("FINR150","STR0011",11)
#DEFINE STR0012 FWI18NLang("FINR150","STR0012",12)
#DEFINE STR0013 FWI18NLang("FINR150","STR0013",13)
#DEFINE STR0014 FWI18NLang("FINR150","STR0014",14)
#DEFINE STR0015 FWI18NLang("FINR150","STR0015",15)
#DEFINE STR0016 FWI18NLang("FINR150","STR0016",16)
#DEFINE STR0017 FWI18NLang("FINR150","STR0017",17)
#DEFINE STR0018 FWI18NLang("FINR150","STR0018",18)
#DEFINE STR0019 FWI18NLang("FINR150","STR0019",19)
#DEFINE STR0020 FWI18NLang("FINR150","STR0020",20)
#DEFINE STR0021 FWI18NLang("FINR150","STR0021",21)
#DEFINE STR0022 FWI18NLang("FINR150","STR0022",22)
#DEFINE STR0023 FWI18NLang("FINR150","STR0023",23)
#DEFINE STR0024 FWI18NLang("FINR150","STR0024",24)
#DEFINE STR0025 FWI18NLang("FINR150","STR0025",25)
#DEFINE STR0026 FWI18NLang("FINR150","STR0026",26)
#DEFINE STR0027 FWI18NLang("FINR150","STR0027",27)
#DEFINE STR0028 FWI18NLang("FINR150","STR0028",28)
#DEFINE STR0029 FWI18NLang("FINR150","STR0029",29)
#DEFINE STR0030 FWI18NLang("FINR150","STR0030",30)
#DEFINE STR0031 FWI18NLang("FINR150","STR0031",31)
#DEFINE STR0032 FWI18NLang("FINR150","STR0032",32)
#DEFINE STR0033 FWI18NLang("FINR150","STR0033",33)
#DEFINE STR0034 FWI18NLang("FINR150","STR0034",34)
#DEFINE STR0035 FWI18NLang("FINR150","STR0035",35)
#DEFINE STR0036 FWI18NLang("FINR150","STR0036",36)
#DEFINE STR0037 FWI18NLang("FINR150","STR0037",37)
#DEFINE STR0038 FWI18NLang("FINR150","STR0038",38)
#DEFINE STR0039 FWI18NLang("FINR150","STR0039",39)
#DEFINE STR0040 FWI18NLang("FINR150","STR0040",40)
#DEFINE STR0041 FWI18NLang("FINR150","STR0041",41)
#DEFINE STR0042 FWI18NLang("FINR150","STR0042",42)
#DEFINE STR0043 FWI18NLang("FINR150","STR0043",43)
#DEFINE STR0044 FWI18NLang("FINR150","STR0044",44)
#DEFINE STR0045 FWI18NLang("FINR150","STR0045",45)
#DEFINE STR0046 FWI18NLang("FINR150","STR0046",46)
#DEFINE STR0047 FWI18NLang("FINR150","STR0047",47)
#DEFINE STR0048 FWI18NLang("FINR150","STR0048",48)
#DEFINE STR0049 FWI18NLang("FINR150","STR0049",49)
#DEFINE STR0050 FWI18NLang("FINR150","STR0050",50)
#DEFINE STR0051 FWI18NLang("FINR150","STR0051",51)
#DEFINE STR0052 FWI18NLang("FINR150","STR0052",52)
#DEFINE STR0053 FWI18NLang("FINR150","STR0053",53)
#DEFINE STR0054 FWI18NLang("FINR150","STR0054",54)
#DEFINE STR0055 FWI18NLang("FINR150","STR0055",55)
#DEFINE STR0056 FWI18NLang("FINR150","STR0056",56)
#DEFINE STR0057 FWI18NLang("FINR150","STR0057",57)
#DEFINE STR0058 FWI18NLang("FINR150","STR0058",58)
#DEFINE STR0059 FWI18NLang("FINR150","STR0059",59)
#DEFINE STR0060 FWI18NLang("FINR150","STR0060",60)
#DEFINE STR0061 FWI18NLang("FINR150","STR0061",61)
#DEFINE STR0062 FWI18NLang("FINR150","STR0062",62)
#DEFINE STR0063 FWI18NLang("FINR150","STR0063",63)
#DEFINE STR0064 FWI18NLang("FINR150","STR0064",64)
#DEFINE STR0065 FWI18NLang("FINR150","STR0065",65)
#DEFINE STR0066 FWI18NLang("FINR150","STR0066",66)
#DEFINE STR0066 FWI18NLang("FINR150","STR0067",67)
#DEFINE STR_EMIS1          "Entrada"  

Static lFWCodFil := FindFunction("FWCodFil")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MGF34R24 - a partir do FINR150	³ Autor ³ Geronimo Benedito Alves ³ Data ³ 16.08.18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posi‡„o dos Titulos a Pagar - MGF34R24 - Gerado a partir do FINR150	                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MGF34R24(void)                                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MGF34R24()			//FINR150()

Local oReport  

Private cTitAux := ""    // Guarda o titulo do relatório para R3 e R4 

//GESTAO - inicio 
Private aSelFil	:= {}

ATUSX1()	//Altero descricao das perguntaS 18 e 19 do FIN150 de Data Contabil p/ Data de Entrada		//ATUSX1FULL() Cria o gupo de perguntas M34R24		
 
oReport := ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ReportDef³ Autor ³ Daniel Batori         ³ Data ³ 07.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definicao do layout do Relatorio									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport
Local oSection1
Local cPictTit
Local nTamVal, nTamCli, nTamQueb
Local aOrdem := {STR0008,;	//"Por Numero"
				 STR0009,;	//"Por Natureza"
				 STR0010,;	//"Por Vencimento"
				 STR0011,;	//"Por Banco"
				 STR0012,;	//"Fornecedor"
				 STR0013,;	//"Por Emissao"
				 STR0014}	//"Por Cod.Fornec."

// As linhas abaixo, são apenas p/ na compilacao não aparecer a msg "Local variable MV_PAR09 never used", que é indevida
Public MV_PAR01, MV_PAR02, MV_PAR03,MV_PAR04,MV_PAR05, MV_PAR06, MV_PAR07, MV_PAR08, MV_PAR09,  MV_PAR10, MV_PAR11, MV_PAR12, MV_PAR13,MV_PAR14,MV_PAR15, MV_PAR16, MV_PAR17, MV_PAR18, MV_PAR19,  MV_PAR20, MV_PAR21, MV_PAR22, MV_PAR23,MV_PAR24,MV_PAR25, MV_PAR26, MV_PAR27, MV_PAR28, MV_PAR29,  MV_PAR30, MV_PAR31, MV_PAR32, MV_PAR33,MV_PAR34,MV_PAR35, MV_PAR36, MV_PAR37, MV_PAR38   
MV_PAR05 := MV_PAR06 := MV_PAR22 := MV_PAR37 := MV_PAR38	:= ""

oReport := TReport():New("MGF34R24",STR0005,"FIN150",{|oReport| ReportPrint(oReport)},STR0001+STR0002)

oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)		//Imprime o total em linha

/*
GESTAO - inicio */
oReport:SetUseGC(.F.)
/* GESTAO - fim
*/

dbSelectArea("SX1")

pergunte("FIN150",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ MV_PAR01	  // do Numero 			  ³
//³ MV_PAR02	  // at‚ o Numero 		  ³
//³ MV_PAR03	  // do Prefixo			  ³
//³ MV_PAR04	  // at‚ o Prefixo		  ³
//³ MV_PAR05	  // da Natureza  	     ³
//³ MV_PAR06	  // at‚ a Natureza		  ³
//³ MV_PAR07	  // do Vencimento		  ³
//³ MV_PAR08	  // at‚ o Vencimento	  ³
//³ MV_PAR09	  // do Banco			     ³
//³ MV_PAR10	  // at‚ o Banco		     ³
//³ MV_PAR11	  // do Fornecedor		  ³
//³ MV_PAR12	  // at‚ o Fornecedor	  ³
//³ MV_PAR13	  // Da Emiss„o			  ³
//³ MV_PAR14	  // Ate a Emiss„o		  ³
//³ MV_PAR15	  // qual Moeda			  ³
//³ MV_PAR16	  // Imprime Provis¢rios  ³
//³ MV_PAR17	  // Reajuste pelo vencto ³
//³ MV_PAR18	  // Da data contabil	  ³
//³ MV_PAR19	  // Ate data contabil	  ³
//³ MV_PAR20	  // Imprime Rel anal/sint³
//³ MV_PAR21	  // Considera  Data Base?³
//³ MV_PAR22	  // Cons filiais abaixo ?³
//³ MV_PAR23	  // Filial de            ³
//³ MV_PAR24	  // Filial ate           ³
//³ MV_PAR25	  // Loja de              ³
//³ MV_PAR26	  // Loja ate             ³
//³ MV_PAR27 	  // Considera Adiantam.? ³
//³ MV_PAR28	  // Imprime Nome 		  ³
//³ MV_PAR29	  // Outras Moedas 		  ³
//³ MV_PAR30     // Imprimir os Tipos    ³
//³ MV_PAR31     // Nao Imprimir Tipos	  ³
//³ MV_PAR32     // Consid. Fluxo Caixa  ³
//³ MV_PAR33     // DataBase             ³
//³ MV_PAR34     // Tipo de Data p/Saldo ³
//³ MV_PAR35     // Quanto a taxa		  ³
//³ MV_PAR36     // Tit.Emissao Futura	  ³
//³ MV_PAR37     // Seleciona filiais (GESTAO)
//³ MV_PAR38     // Considera Tit Exclu³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPictTit := PesqPict("SE2","E2_VALOR")
If cPaisLoc == "CHI"
	cPictTit := SubStr(cPictTit,1,At(".",cPictTit)-1)
EndIf   

nTamVal	 := TamSX3("E2_VALOR")[1]
nTamCli	 := TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1] + 25
nTamTit	 := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + 8
nTamQueb := nTamCli + nTamTit + TamSX3("E2_TIPO")[1] + TamSX3("E2_NATUREZ")[1] + TamSX3("E2_EMISSAO")[1] +;
			TamSX3("E2_VENCTO")[1] + TamSX3("E2_VENCREA")[1] + 14
			
//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Secao 1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,STR0061,{"SE2","SA2"},aOrdem)

TRCell():New(oSection1,"FORNECEDOR"	,	  ,STR0038				,,nTamCli,.F.,)  		//"Codigo-Nome do Fornecedor"
TRCell():New(oSection1,"TITULO"		,	  ,STR0039+CRLF+STR0040	,,nTamTit,.F.,)  		//"Prf-Numero" + "Parcela"
TRCell():New(oSection1,"E2_TIPO"	,"SE2",STR0041				,,,.F.,)  				//"TP"
TRCell():New(oSection1,"E2_NATUREZ"	,"SE2",STR0042				,,TamSX3("E2_NATUREZ")[1] + 5,.F.,)  				//"Natureza"
TRCell():New(oSection1,"E2_EMISSAO"	,"SE2",STR0043+CRLF+STR0044	,,,.F.,) 				//"Data de" + "Emissao"
TRCell():New(oSection1,"E2_VENCTO"	,"SE2",STR0043+CRLF+STR0045	,,,.F.,)  				//"Vencto" + "Titulo"
TRCell():New(oSection1,"E2_VENCREA"	,"SE2",STR0045+CRLF+STR0047	,,,.F.,)  				//"Vencto" + "Real"
TRCell():New(oSection1,"VAL_ORIG"	,	  ,STR0048				,cPictTit,nTamVal+3,.F.,) //"Valor Original"
TRCell():New(oSection1,"VAL_NOMI"	,	  ,STR0049+CRLF+STR0050	,cPictTit,nTamVal+3,.F.,) //"Tit Vencidos" + "Valor Nominal"
TRCell():New(oSection1,"VAL_CORR"	,	  ,STR0049+CRLF+STR0051	,cPictTit,nTamVal+3,.F.,) //"Tit Vencidos" + "Valor Corrigido"
TRCell():New(oSection1,"VAL_VENC"	,	  ,STR0052+CRLF+STR0050	,cPictTit,nTamVal+3,.F.,) //"Titulos a Vencer" + "Valor Nominal"
TRCell():New(oSection1,"E2_PORTADO"	,"SE2",STR0053+CRLF+STR0054	,,,.F.,)  				//"Porta-" + "dor"
TRCell():New(oSection1,"JUROS"		,	  ,STR0055+CRLF+STR0056	,cPictTit,nTamVal+3,.F.,) //"Vlr.juros ou" + "permanencia"
TRCell():New(oSection1,"DIA_ATR"	,	  ,STR0057+CRLF+STR0058	,,4,.F.,)  				//"Dias" + "Atraso"
TRCell():New(oSection1,"E2_HIST"	,"SE2",IIf(cPaisloc =="MEX",STR0063,STR0059) ,,35,.F.,)  			//"Historico(Vencidos+Vencer)"
TRCell():New(oSection1,"VAL_SOMA"	,	  ,STR0060				,cPictTit,nTamVal+7,.F.,) 	//"(Vencidos+Vencer)"
TRCell():New(oSection1,"E2_EMIS1"	,"SE2",STR0043+CRLF+STR_EMIS1	,,,.F.,) 				//"Data de" + "Entrada"

oSection1:Cell("VAL_ORIG"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_NOMI"):SetHeaderAlign("RIGHT")             
oSection1:Cell("VAL_CORR"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_VENC"):SetHeaderAlign("RIGHT")
oSection1:Cell("JUROS")   :SetHeaderAlign("RIGHT")  
oSection1:Cell("VAL_SOMA"):SetHeaderAlign("RIGHT") 

oSection1:SetLineBreak(.f.)		//Quebra de linha automatica

oSection2 := TRSection():New(oReport,STR0061,{"SM0"},aOrdem)

TRCell():New(oSection2,"FILIAL"		,,STR0065	,			,105) //"Total por Filial:"
TRCell():New(oSection2,"FILLER1","","",,10,.F.,)
TRCell():New(oSection2,"VALORORIG"	,,STR0048				,cPictTit	,nTamVal+3)//"Valor Original"
TRCell():New(oSection2,"VALORNOMI"	,,STR0049+CRLF+STR0050	,cPictTit	,nTamVal+3)//"Tit Vencidos" + "Valor Nominal"
TRCell():New(oSection2,"VALORCORR"	,,STR0049+CRLF+STR0051	,cPictTit	,nTamVal+3)//"Tit Vencidos" + "Valor Corrigido"
TRCell():New(oSection2,"VALORVENC"	,,STR0052+CRLF+STR0050	,cPictTit	,nTamVal+3)//"Titulos a Vencer" + "Valor Nominal"
TRCell():New(oSection2,"JUROS"		,,STR0055+CRLF+STR0056	,cPictTit	,nTamVal+5)//"Vlr.juros ou" + "permanencia"
TRCell():New(oSection2,"VALORSOMA"	,,STR0060				,cPictTit	,nTamVal+20)//"(Vencidos+Vencer)"


oSection2:Cell("VALORORIG"):SetHeaderAlign("RIGHT")
oSection2:Cell("VALORNOMI"):SetHeaderAlign("RIGHT")             
oSection2:Cell("VALORCORR"):SetHeaderAlign("RIGHT")
oSection2:Cell("VALORVENC"):SetHeaderAlign("RIGHT")
oSection2:Cell("JUROS")   :SetHeaderAlign("RIGHT")  
oSection2:Cell("VALORSOMA"):SetHeaderAlign("RIGHT")

oSection2:SetLineBreak(.F.)

Return oReport                                                                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Daniel Batori          ³ Data ³08.08.06	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport)

Local oSection1	:=	oReport:Section(1) 
Local oSection2	:=	oReport:Section(2)
Local nOrdem 	:= oSection1:GetOrder()
Local oBreak
Local oBreak2
Local aDados[18]
Local nRegEmp := SM0->(RecNo())
Local nRegSM0 := SM0->(Recno())
Local nAtuSM0 := SM0->(Recno())
Local dOldDtBase := dDataBase
Local dOldData := dDataBase
Local nJuros  :=0
Local nQualIndice := 0
Local lContinua := .T.
Local nTit0:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0
Local nTot0:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotJur:=0
LOcal nTotFil0:=0, nTotFil1:=0, nTotFil2:=0, nTotFil3:=0,nTotFil4:=0, nTotFilTit:=0, nTotFilJ:=0
Local nFil0:=0,nFil1:=0,nFil2:=0,nFil3:=0,nFil4:=0,nFilTit:=0,nFilJ:=0
Local cCond1,cCond2,cCarAnt,nSaldo:=0,nAtraso:=0
Local dDataReaj
Local dDataAnt := dDataBase , lQuebra
Local nMestit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
Local cIndexSe2
Local cChaveSe2
Local nIndexSE2
Local cFilDe,cFilAte
Local nTotsRec := SE2->(RecCount())
Local aTamFor := TAMSX3("E2_FORNECE")
Local nDecs := Msdecimais(MV_PAR15)
Local lFr150flt := EXISTBLOCK("FR150FLT")
Local cFr150flt := iif(lFr150flt,ExecBlock("FR150FLT",.F.,.F.),"")
Local cMoeda := LTrim(Str(MV_PAR15))
Local cFilterUser
Local cFilUserSA2 := oSection1:GetADVPLExp("SA2")

Local cNomFor	:= ""
Local cNomNat	:= ""
Local cNomFil	:= ""
Local cNumBco	:= 0
Local nTotVenc	:= 0
Local nTotMes	:= 0
Local nTotGeral := 0
Local nTotTitMes:= 0
Local nTotFil	:= 0
Local dDtVenc
Local aFiliais	:= {}
Local lTemCont := .F.
Local cNomFilAnt := ""
Local cFilialSE2	:= ""
Local nInc := 0    
Local aSM0 := {}
Local cPictTit := ""
Local nGerTot := 0
Local nFilTot := 0
Local nAuxTotFil := 0
Local nRecnoSE2 := 0
Local aTotFil :={}
local lQryEmp := .F.
Local nI := 0
Local dUltBaixa	:= STOD("")
Local nCont	:= 0
Local nTamFil	:= FWSizeFilial()
Local lExistFJU := FJU->(ColumnPos("FJU_RECPAI")) > 0 .and. FindFunction("FinGrvEx")
Local cCampos := ""
Local cQueryP := ""
Local aStru := SE2->(dbStruct())
Local nFilAtu		:= 0
Local nLenSelFil	:= 0
Local nTamUnNeg		:= 0
Local nTamEmp		:= 0
Local nTotEmp		:= 0
Local nTotEmpJ		:= 0
Local nTotEmp0		:= 0
Local nTotEmp1		:= 0
Local nTotEmp2		:= 0
Local nTotEmp3		:= 0
Local nTotEmp4		:= 0
Local nTotTitEmp	:= 0
Local cNomEmp		:= ""
Local cTmpFil		:= ""
Local cQryFilSE1	:= ""
Local cQryFilSE5	:= ""
Local lTotEmp		:= .F.
Local aTmpFil		:= {}
Local oBrkFil		:= Nil
Local oBrkEmp		:= Nil
Local oBrkNat		:= Nil
Local nBx			:= 0
/* GESTAO - fim
*/

// A linha abaixo tem a função unica de evitar as mensagens indevidad do compilador de "Warning W0003 Local Variable never used"
R_E_C_N_O_:=0;  MVABATIM:=MVABATIM;  cQryFilSE2:=""; lTotFil:= .f.; cQryFilSE1:=""; nTamFil:= FWSizeFilial(); nCont:= 0; cNomFilAnt:= ""; nDecs:=Msdecimais(MV_PAR15); aTamFor:=TAMSX3("E2_FORNECE"); nIndexSE2:=""; cIndexSe2:=""; nMestit0:=0 ; cPaisloc:=cPaisloc; nTotTmp:= .F.        


Private dBaixa := dDataBase
Private cTitulo  := ""

cPictTit := PesqPict("SE2","E2_VALOR")
If cPaisLoc == "CHI"
	cPictTit := SubStr(cPictTit,1,At(".",cPictTit)-1)
EndIf   

//Valida data base (MV_PAR33)
If Empty(MV_PAR33)
    //Help(" ",1,'FINDTBASE',,STR0066,1,0,,,,,,{STR0067} ) //"Data Base nao informada na parametrizacao do relatorio."  ###  "Por favor, informe a data base nos parƒmetros do relatorio (pergunte)."
    Help(" ",1,'FINDTBASE',,"Data Base não informada na parametrização do relatório.",1,0,,,,,,{"Por favor, informe a data base nos parâmetros do relatório (pergunte)."} ) //"Data Base nao informada na parametrizacao do relatorio."  ###  "Por favor, informe a data base nos parâmetros do relatório (pergunte)."
    oReport:CancelPrint()
    Return
Endif

/*
GESTAO - inicio */

If MV_PAR37 == 1
	If Empty(aSelFil)
		If  FindFunction("AdmSelecFil")
			AdmSelecFil("FIN150",37,.F.,@aSelFil,"SE2",.F.)
		Else
			aSelFil := AdmGetFil(.F.,.F.,"SE2")
			If Empty(aSelFil)
				Aadd(aSelFil,cFilAnt)
			Endif
		Endif
	Endif
Else
	Aadd(aSelFil,cFilAnt)
Endif
nLenSelFil := Len(aSelFil)
lTotFil := (nLenSelFil > 1)
nTamEmp := Len(FWSM0LayOut(,1))
nTamUnNeg := Len(FWSM0LayOut(,2))
lTotEmp := .F.
If nLenSelFil > 1
	nX := 1 
	While nX < nLenSelFil .And. !lTotEmp
		nX++
		lTotEmp := !(Substr(aSelFil[nX-1],1,nTamEmp) == Substr(aSelFil[nX],1,nTamEmp))
	Enddo
Else
	nTotTmp := .F.
Endif
cQryFilSE2 := GetRngFil( aSelFil, "SE2", .T., @cTmpFil)
Aadd(aTmpFil,cTmpFil)
cQryFilSE5 := GetRngFil( aSelFil, "SE5", .T., @cTmpFil)
Aadd(aTmpFil,cTmpFil)
/* GESTAO - fim
*/

//*******************************************************
// Solução para o problema no filtro de Serie minuscula *
//*******************************************************
//MV_PAR04 := LOWER(MV_PAR04)

oSection1:Cell("FORNECEDOR"	):SetBlock( { || aDados[FORNEC] 			})
oSection1:Cell("TITULO"		):SetBlock( { || aDados[TITUL] 				})
oSection1:Cell("E2_TIPO"	):SetBlock( { || aDados[TIPO] 					})
oSection1:Cell("E2_NATUREZ"	):SetBlock( { || MascNat(aDados[NATUREZA])})
oSection1:Cell("E2_EMISSAO"	):SetBlock( { || aDados[EMISSAO] 			})
oSection1:Cell("E2_VENCTO"	):SetBlock( { || aDados[VENCTO] 			})
oSection1:Cell("E2_VENCREA"	):SetBlock( { || aDados[VENCREA] 			})
oSection1:Cell("VAL_ORIG"	):SetBlock( { || aDados[VL_ORIG] 			})
oSection1:Cell("VAL_NOMI"	):SetBlock( { || aDados[VL_NOMINAL] 		})
oSection1:Cell("VAL_CORR"	):SetBlock( { || aDados[VL_CORRIG] 		})
oSection1:Cell("VAL_VENC"	):SetBlock( { || aDados[VL_VENCIDO] 		})
oSection1:Cell("E2_PORTADO"	):SetBlock( { || aDados[PORTADOR] 			})
oSection1:Cell("JUROS"		):SetBlock( { || aDados[VL_JUROS] 			})
oSection1:Cell("DIA_ATR"	):SetBlock( { || aDados[ATRASO] 				})
oSection1:Cell("E2_HIST"	):SetBlock( { || aDados[HISTORICO] 			})
oSection1:Cell("VAL_SOMA"	):SetBlock( { || aDados[VL_SOMA] 			})

oSection1:Cell("VAL_SOMA"):Disable()
oSection1:Cell("E2_EMIS1"	):SetBlock( { || aDados[EMIS1] 			})

TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as quebras da seção, conforme a ordem escolhida.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 2	//Natureza
	oBreak := TRBreak():New(oSection1,{|| IIf(!MV_MULNATP,SE2->E2_NATUREZ,aDados[NATUREZA]) },{|| cNomNat })
	oBrkNat := oBreak
ElseIf nOrdem == 3	.Or. nOrdem == 6	//Vencimento e por Emissao
	oBreak  := TRBreak():New(oSection1,{|| IIf(nOrdem == 3,SE2->E2_VENCREA,SE2->E2_EMISSAO) },{|| STR0026 + DtoC(dDtVenc) })	//"S U B - T O T A L ----> "
	oBreak2 := TRBreak():New(oSection1,{|| IIf(nOrdem == 3,Month(SE2->E2_VENCREA),Month(SE2->E2_EMISSAO)) },{|| STR0030 + "("+ALLTRIM(STR(nTotTitMes))+" "+IIF(nTotTitMes > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")" })		//"T O T A L   D O  M E S ---> "
	If MV_PAR20 == 1	//1- Analitico  2-Sintetico
		TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak2,,Iif(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport, nTotGeral, nTotMes)},.F.,.F.)
	EndIf
ElseIf nOrdem == 4	//Banco
	oBreak := TRBreak():New(oSection1,{|| SE2->E2_PORTADO },{|| STR0026 + cNumBco })	//"S U B - T O T A L ----> "
ElseIf nOrdem == 5	//Fornecedor
	oBreak := TRBreak():New(oSection1,{|| SE2->(E2_FORNECE+E2_LOJA) },{|| cNomFor })
ElseIf nOrdem == 7	//Codigo Fornecedor
	oBreak := TRBreak():New(oSection1,{|| SE2->E2_FORNECE },{|| cNomFor })	
EndIf                                                                       


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprimir TOTAL por filial somente quando ³
//³ houver mais do que uma filial.	         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SM0->(Reccount()) > 1 .And. nLenSelFil > 1
	If nOrdem  == 3 .Or. nOrdem == 6
		oSection2:Cell("FILIAL"	)	:SetBlock( { || aTotFil[ni,1] + aTotFil[ni,9]})
		oSection2:Cell("VALORORIG")	:SetBlock( { || aTotFil[ni,2]})
		oSection2:Cell("VALORNOMI")	:SetBlock( { || aTotFil[ni,3]})
		oSection2:Cell("VALORCORR")	:SetBlock( { || aTotFil[ni,4]})
		oSection2:Cell("VALORVENC")	:SetBlock( { || aTotFil[ni,5]})
		oSection2:Cell("JUROS")		:SetBlock( { || aTotFil[ni,8]})
		oSection2:Cell("VALORSOMA")	:SetBlock( { || aTotFil[ni,4] + aTotFil[ni,5]})

		TRPosition():New(oSection2,"SM0",1,{|| xFilial("SM0")+SM0->M0_CODIGO+	SM0->M0_CODFIL })
	Else
		oBreak2 := TRBreak():New(oSection1,{|| SE2->E2_FILIAL },{|| STR0032+" "+cNomFil })	//"T O T A L   F I L I A L ----> " 
		If MV_PAR20 == 1	//1- Analitico  2-Sintetico
			TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak2,,,,.F.,.F.)
			//nTotGeral nao estava imprimindo corretamente o totalizador por isso foi necessario o ajuste abaixo
			//embora seja estranho mas neste caso foi necessario inicializar a variavel nFilTot:=0 no break 
			//por isso salvei o conteudo na variavel nAuxTotFil antes de inicializar e depois imprimo nAuxTotFil
			TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak2,,Iif(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport, ( nAuxTotFil:=nFilTot,nFilTot:=0,nAuxTotFil )/*nTotGeral*/, nTotFil)},.F.,.F.)
		EndIf
	EndIf 
EndIf

/*
GESTAO - inicio */
/* quebra por empresa */
If lTotEmp .And. MV_MULNATP .And. nOrdem == 2 
	oBrkEmp := TRBreak():New(oSection1,{|| Substr(SE2->E2_FILIAL,1,nTamEmp)},{|| STR0064 + " " + cNomEmp })		//"T O T A L  E M P R E S A -->" 
	// "Salta pagina por cliente?" igual a "Sim" e a ordem eh por cliente ou codigo do cliente
/*	If MV_PAR35 == 1 .And. (nOrdem == 1 .Or. nOrdem == 8)
		oBrkEmp:OnPrintTotal( { || oReport:EndPage() } )	// Finaliza pagina atual
	Else
		oBrkEmp:OnPrintTotal( { || oReport:SkipLine()} )
	EndIf*/
	If MV_PAR20 == 1	//1- Analitico  2-Sintetico
		TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBrkEmp,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBrkEmp,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBrkEmp,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBrkEmp,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBrkEmp,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_SOMA"),"","ONPRINT",oBrkEmp,,PesqPict("SE2","E2_VALOR"),{|lSection,lReport| If(lReport, nTotGeral, nTotEmp)},.F.,.F.)
	EndIf
Endif
/* GESTAO - fim 
*/

If MV_PAR20 == 1	//1- Analitico  2-Sintetico
	//Altero o texto do Total Geral
	oReport:SetTotalText({|| STR0027 + "(" + ALLTRIM(STR(nTotTit))+" "+If(nTotTit > 1,STR0028,STR0029)+")" })
	TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak,,,,.F.,.T.)
	//nTotGeral nao estava imprimindo corretamente o totalizador por isso foi necessario o ajuste abaixo
	//portanto foi criado a variavel nGerTot que eh o acumulador geral da coluna
	TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak,,Iif(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport,Iif(nOrdem==2,nTotGeral,nGerTot), nTotVenc)},.F.,.T.)
EndIf

dbSelectArea ( "SE2" )
Set Softseek On

If MV_PAR37 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
Endif

//Acerta a database de acordo com o parametro
If MV_PAR21 == 1    // Considera Data Base
	dDataBase := MV_PAR33
Endif	

dbSelectArea("SM0")

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

//Caso nao preencha o MV_PAR15 um erro ocorre ao procurar o parametro do sistema MV_MOEDA0.
If Val(cMoeda) == 0
	cMoeda := "1"
Endif

cTitulo := oReport:title()
cTitAux := cTitulo

cTitulo += " " + STR0035 + GetMv("MV_MOEDA"+cMoeda)  //"Posicao dos Titulos a Pagar" + " em "

// Cria vetor com os codigos das filiais da empresa corrente                     
aFiliais := FinRetFil()

oSection1:Init()      

aSM0	:= AdmAbreSM0()

/*
GESTAO - inicio */
If nLenSelFil == 0
	// Cria vetor com os codigos das filiais da empresa corrente
	aFiliais := FinRetFil()
	lContinua := SM0->(!Eof()) .And. SM0->M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
Else
	aFiliais := Aclone(aSelFil)
	cFilDe := aSelFil[1]
	cFilAte := aSelFil[nLenSelFil]
	nFilAtu := 1
	lContinua := nFilAtu <= nLenSelFil
	aSM0 := FWLoadSM0()
Endif
/* GESTAO - fim 
*/

nInc := 1

While nInc <= Len( aSM0 )
	
	If !Empty(cFilAte) .AND. aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte) .and. lContinua
		
		//UTILIZADO PARA VALIDAR AS FILIAIS SELECIONADAS PELO USUARIO.
		If Ascan(aSelFil,aSM0[nInc][2]) == 0
			nInc++
			Loop						
		Endif
		
		dbSelectArea("SE2")
		/*
		GESTAO - inicio */
		If nLenSelFil > 0
			nPosFil := aScan( aSM0 ,{ | sm0 | sm0[SM0_GRPEMP] + sm0[SM0_CODFIL] == aSM0[nInc][1] + aSelFil[nFilAtu] } )
			If nPosFil > 0
				SM0->( DbGoTo( aSM0[nPosFil,SM0_RECNO] ) )
			Else
				SM0->( MsSeek( cEmpAnt + aSelFil[nFilAtu] ) )
			EndIf
		EndIf
		cFilAnt := aSM0[nInc][2]
		/* GESTAO - fim
		*/ 
		
		IF cFilialSE2 == xFilial("SE2")
			nInc++
			Loop
		ELSE
			cFilialSE2 := xFilial("SE2")
		ENDIF
			
		cFilterUser := oSection1:GetSqlExp("SE2")
		If TcSrvType() != "AS/400"
			cQueryP := ""
			cCampos := ""
			aEval(SE2->(DbStruct()),{|e| If(e[2]<> "M", cCampos += ",SE2."+AllTrim(e[1]),Nil)})
			cCampos += ",SE2.R_E_C_N_O_, SE2.R_E_C_D_E_L_, SE2.D_E_L_E_T_ " 
			cQuery := "SELECT " + SubStr(cCampos,2)
			cQuery += "  FROM "+	RetSqlName("SE2")+ " SE2"
			cQuery += " WHERE SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
			cQuery += "   AND D_E_L_E_T_ = ' ' " 
			If !empty(cFilterUser)
				cQueryP += " AND ( "+cFilterUser + " ) "
			Endif
		Endif
	
		IF nOrdem == 1
			SE2->(dbSetOrder(1))
			cOrder := SqlOrder(indexkey())
			cCond1 := "SE2->E2_PREFIXO <= MV_PAR04"
			cCond2 := "SE2->E2_PREFIXO"
			cTitulo += OemToAnsi(STR0016)  //" - Por Numero"
			nQualIndice := 1
		Elseif nOrdem == 2
			SE2->(dbSetOrder(2))
			cOrder := SqlOrder(indexkey())
			cCond1 := "SE2->E2_NATUREZ <= MV_PAR06"
			cCond2 := "SE2->E2_NATUREZ"
			cTitulo += STR0017  //" - Por Natureza"
			nQualIndice := 2
		Elseif nOrdem == 3
			SE2->(dbSetOrder(3))
			cOrder := SqlOrder(indexkey())
			cCond1 := "SE2->E2_VENCREA <= MV_PAR08"
			cCond2 := "SE2->E2_VENCREA"
			cTitulo += STR0018  //" - Por Vencimento"
			nQualIndice := 3
		Elseif nOrdem == 4
			SE2->(dbSetOrder(4))
			cOrder := SqlOrder(indexkey())
			cCond1 := "SE2->E2_PORTADO <= MV_PAR10"
			cCond2 := "SE2->E2_PORTADO"
			cTitulo += OemToAnsi(STR0031)  //" - Por Banco"
			nQualIndice := 4
		Elseif nOrdem == 6
			SE2->(dbSetOrder(5))
			cOrder := SqlOrder(indexkey())
			cCond1 := "SE2->E2_EMISSAO <= MV_PAR14"
			cCond2 := "SE2->E2_EMISSAO"
			cTitulo += STR0019 //" - Por Emissao"
			nQualIndice := 5
		Elseif nOrdem == 7
			SE2->(dbSetOrder(6))
			cOrder := SqlOrder(indexkey())
			cCond1 := "SE2->E2_FORNECE <= MV_PAR12"
			cCond2 := "SE2->E2_FORNECE"
			cTitulo += STR0020 //" - Por Cod.Fornecedor"
			nQualIndice := 6
		Else
			cChaveSe2 := "E2_FILIAL+E2_NOMFOR+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
			cOrder := SqlOrder(cChaveSe2)
			cCond1 := "SE2->E2_FORNECE <= MV_PAR12"
			cCond2 := "SE2->E2_FORNECE+SE2->E2_LOJA"
			cTitulo += STR0022 //" - Por Fornecedor"
			nQualIndice := IndexOrd()
		EndIF
	
		If MV_PAR20 == 1	//1- Analitico  2-Sintetico	
			cTitulo += STR0023  //" - Analitico"
		Else
			cTitulo += STR0024  // " - Sintetico"
		EndIf
	
		oReport:SetTitle(cTitulo)
		cTitulo := cTitAux
		
		dbSelectArea("SE2")
	
		Set Softseek Off

		cQueryP += " AND SE2.E2_NUM     BETWEEN '"+ MV_PAR01+ "' AND '"+ MV_PAR02 + "'"
		cQueryP += " AND SE2.E2_PREFIXO BETWEEN '"+ MV_PAR03+ "' AND '"+ MV_PAR04 + "'"
		cQueryP += " AND (SE2.E2_MULTNAT = '1' OR (SE2.E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'))"
		cQueryP += " AND SE2.E2_VENCREA BETWEEN '"+ DTOS(MV_PAR07)+ "' AND '"+ DTOS(MV_PAR08) + "'"
		cQueryP += " AND SE2.E2_PORTADO BETWEEN '"+ MV_PAR09+ "' AND '"+ MV_PAR10 + "'"
		cQueryP += " AND SE2.E2_FORNECE BETWEEN '"+ MV_PAR11+ "' AND '"+ MV_PAR12 + "'"
		cQueryP += " AND SE2.E2_EMISSAO BETWEEN '"+ DTOS(MV_PAR13)+ "' AND '"+ DTOS(MV_PAR14) + "'"
		cQueryP += " AND SE2.E2_EMIS1   BETWEEN '"+ DTOS(MV_PAR18)+ "' AND '"+ DTOS(MV_PAR19) + "'"		
		cQueryP += " AND SE2.E2_LOJA    BETWEEN '"+ MV_PAR25 + "' AND '"+ MV_PAR26 + "'"
		//Considerar titulos cuja emissao seja maior que a database do sistema
		If MV_PAR36 == 2
			cQueryP += " AND SE2.E2_EMISSAO <= '" + DTOS(dDataBase) +"'"
		Endif

		If !Empty(MV_PAR30) // Deseja imprimir apenas os tipos do parametro 30
			cQueryP += " AND SE2.E2_TIPO IN "+FormatIn(MV_PAR30,";") 
		ElseIf !Empty(MV_PAR31) // Deseja excluir os tipos do parametro 31
			cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MV_PAR31,";")
		EndIf

		If MV_PAR32 == 1
			cQueryP += " AND SE2.E2_FLUXO != 'N'"
		Endif
		
		cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVABATIM,";")
		
		If MV_PAR16 == 2
			cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")			
		Endif
		
		If MV_PAR27 == 2
			cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVPAGANT,";")			 
			cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MV_CPNEG,";")			
		Endif		

		IF MV_PAR34 == 2 .And. !Empty(MV_PAR33)
			cQueryP += " AND SE2.E2_EMIS1 <= '" + DTOS(MV_PAR33) +"'"
		Endif

		//verifica moeda do campo=moeda parametro
		If MV_PAR29 == 2 // nao imprime
			cQueryP += " AND SE2.E2_MOEDA = " + Alltrim(Str(MV_PAR15))
		Endif  

		// Desconsidera os titulos de acordo com o parametro considera filial e a tabela SE2 estiver compartilhada
		If MV_PAR22 == 1 .and. Empty(xFilial("SE2"))
			cQueryP += " AND SE2.E2_FILORIG   BETWEEN '"+MV_PAR23+ "' AND '"+MV_PAR24+ "'"		
		Endif 

		cQuery += cQueryP
		If lExistFJU
			If MV_PAR38 == 1
				cQuery += " AND SE2.R_E_C_N_O_ NOT IN (SELECT PAI.FJU_RECPAI FROM "+ RetSqlName("FJU")+" PAI " 
				cQuery += " WHERE PAI.D_E_L_E_T_ = ' ' AND "
				cQuery += " PAI.FJU_CART = 'P' AND "
				cQuery += " PAI.FJU_DTEXCL >= '" + DTOS(dDataBase) + "' "
				cQuery += " AND PAI.FJU_EMIS1 <= '" + DTOS(dDataBase) + "') "			    		
				cQuery += "UNION "
				
				cQuery += "SELECT " + SubStr(cCampos,2)
				cQuery += " FROM "+ RetSqlName("SE2")+" SE2,"+ RetSqlName("FJU") +" FJU"
				cQuery += " WHERE SE2.E2_FILIAL = '" + xFilial("SE2") + "'"
				cQuery += " AND FJU.FJU_FILIAL	 = '" + xFilial("FJU") + "'"
				cQuery += " AND SE2.E2_PREFIXO 	= FJU.FJU_PREFIX "
				cQuery += " AND SE2.E2_NUM 		= FJU.FJU_NUM "
				cQuery += " AND SE2.E2_PARCELA 	= FJU.FJU_PARCEL "
				cQuery += " AND SE2.E2_TIPO 	= FJU.FJU_TIPO "
				cQuery += " AND SE2.E2_FORNECE	= FJU.FJU_CLIFOR "
				cQuery += " AND SE2.E2_LOJA 	= FJU.FJU_LOJA "
				cQuery += " AND FJU.FJU_EMIS   <= '" + DTOS(dDataBase) +"'"
				cQuery += " AND FJU.FJU_DTEXCL >= '" + DTOS(dDataBase) +"'"
				cQuery += " AND FJU.FJU_CART = 'P' "
				cQuery += " AND SE2.R_E_C_N_O_ = FJU.FJU_RECORI "
				cQuery += " AND FJU.FJU_RECORI IN ( SELECT MAX(FJU_RECORI) "

				cQuery +=   "FROM "+ RetSqlName("FJU")+" LASTFJU "
				cQuery +=   "WHERE LASTFJU.FJU_FILIAL = FJU.FJU_FILIAL "
				cQuery +=   "AND LASTFJU.FJU_PREFIX = FJU.FJU_PREFIX "
				cQuery +=   "AND LASTFJU.FJU_NUM = FJU.FJU_NUM "
				cQuery +=   "AND LASTFJU.FJU_PARCEL = FJU.FJU_PARCEL "
				cQuery +=   "AND LASTFJU.FJU_TIPO = FJU.FJU_TIPO "
				cQuery +=   "AND LASTFJU.FJU_CLIFOR = FJU.FJU_CLIFOR "
				cQuery +=   "AND LASTFJU.FJU_LOJA = FJU.FJU_LOJA "	
				cQuery +=   "AND FJU.FJU_DTEXCL = LASTFJU.FJU_DTEXCL "
					
				cQuery +=   "GROUP BY FJU_FILIAL "
				cQuery +=   ",FJU_PREFIX "
				cQuery +=   ",FJU_NUM "
				cQuery +=   ",FJU_PARCEL "
				cQuery +=   ",FJU_CLIFOR "
				cQuery +=   ",FJU_LOJA ) "

				cQuery += " AND SE2.D_E_L_E_T_ = '*' " 
				cQuery += " AND FJU.D_E_L_E_T_ = ' ' " 
				
				cQuery += " AND " 
				cQuery += " (SELECT COUNT(*) " 
				cQuery += " FROM "+ RetSqlName("SE2")+" NOTDEL " 
				cQuery += " WHERE NOTDEL.E2_FILIAL = FJU.FJU_FILIAL "         
				cQuery += " AND NOTDEL.E2_PREFIXO = FJU.FJU_PREFIX     "      
				cQuery += " AND NOTDEL.E2_NUM = FJU.FJU_NUM            "
				cQuery += " AND NOTDEL.E2_PARCELA = FJU.FJU_PARCEL      "        
				cQuery += " AND NOTDEL.E2_TIPO = FJU.FJU_TIPO "        
				cQuery += " AND NOTDEL.E2_FORNECE = FJU.FJU_CLIFOR       "     
				cQuery += " AND NOTDEL.E2_LOJA = FJU.FJU_LOJA  	"
				cQuery += " AND FJU.FJU_RECPAI = 0 "
				cQuery += " AND NOTDEL.E2_EMIS1   <= '" + DTOS(dDataBase) +"'"
				cQuery += " AND NOTDEL.D_E_L_E_T_ = '') = 0 " 
					
				cQuery += " AND FJU.FJU_RECORI NOT IN (SELECT PAI.FJU_RECPAI FROM "+ RetSqlName("FJU")+" PAI " 
				cQuery += " WHERE PAI.D_E_L_E_T_ = ' ' AND "
				cQuery += " PAI.FJU_CART = 'P' AND "
				cQuery += " PAI.FJU_DTEXCL >= '" + DTOS(dDataBase) + "' "
				cQuery += " AND PAI.FJU_EMIS1 <= '" + DTOS(dDataBase) + "') "			    		
					
				cQuery += cQueryP
			Endif	
		Endif									

		cQuery += " ORDER BY "+ cOrder

		cQuery := ChangeQuery(cQuery)	
		dbSelectArea("SE2")
		dbCloseArea()
		dbSelectArea("SA2")

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)

		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
		
		oReport:SetMeter(nTotsRec)	
		
		If MV_MULNATP .And. nOrdem == 2
			If dDataBase > SE2->E2_VENCREA 		//vencidos 
				dBaixa := dDataBase
			EndIf
			
			//GESTAO - inicio
			If nLenSelFil == 0
				Finr155(cFr150flt, .F., @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ, oReport, aDados, @cNomNat, @nTotVenc, @nTotGeral)
			Else
				cTitBkp := cTitulo
				Finr155(cFr150flt, .F., @nTotFil0, @nTotFil1, @nTotFil2, @nTotFil3, @nTotFilTit, @nTotFilJ, oReport, aDados, @cNomNat, @nTotVenc, @nTotGeral)
				nTot0 += nTotFil0
				nTot1 += nTotFil1
				nTot2 += nTotFil2
				nTot3 += nTotFil3
				nTot4 += nTotFil4
				nTotJ += nTotFilJ
				nTotTit += nTotFilTit
				cNomFil := cFilAnt + " - " + AllTrim(SM0->M0_FILIAL)
				cNomEmp := Substr(cFilAnt,1,nTamEmp) + " - " + AllTrim(SM0->M0_NOMECOM)
				cTitulo := cTitBkp
			Endif
			//GESTAO - fim
			
			dbSelectArea("SE2")
			dbCloseArea()
			ChKFile("SE2")
			dbSetOrder(1)
			
			//GESTAO - inicio
			If nLenSelFil == 0
				dbSelectArea("SM0")
				dbSkip()
				lContinua := SM0->(!Eof()) .And. SM0->M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
			Else
				nFilAtu++
				lContinua := (nFilAtu <= nLenSelFil)
				If lContinua
					If oBrkNat:Execute()
						oBrkNat:PrintTotal()
					Endif
					If nTotFil0 <> 0
						oBrkFil := oBreak
						If oBrkFil:Execute()
							oBrkFil:PrintTotal()
						Endif
					Endif
					Store 0 To nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ
					If !(Substr(aSelFil[nFilAtu-1],1,nTamEmp) == Substr(aSelFil[nFilAtu],1,nTamEmp))
						If nTotEmp0 <> 0
							oBrkEmp:PrintTotal()
						Endif
						nTotEmp0 := 0
						nTotEmp1 := 0
						nTotEmp2 := 0
						nTotEmp3 := 0
						nTotEmp4 := 0
						nTotEmpJ := 0
						nTotTitEmp := 0
					Endif
				Endif
			Endif
			
			//GESTAO - fim
			If Empty(xFilial("SE2")) .and. MV_PAR22 = 2
				Exit
			Endif
			
			nInc ++
			Loop
		Endif  
		
		lQryEmp := Eof()
		
		While &cCond1 .and. !Eof() .and. lContinua .and. SE2->E2_FILIAL == xFilial("SE2")
		
			oReport:IncMeter()
	
			dbSelectArea("SE2")
	
			Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
	
			If nOrdem == 3 .And. Str(Month(SE2->E2_VENCREA)) <> Str(Month(dDataAnt))
				nMesTTit := 0
			Elseif nOrdem == 6 .And. Str(Month(SE2->E2_EMISSAO)) <> Str(Month(dDataAnt))
				nMesTTit := 0
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega data do registro para permitir ³
			//³ posterior analise de quebra por mes.   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
	
			cCarAnt := &cCond2
	        
			lTemCont := .F.

			While &cCond2 == cCarAnt .and. !Eof() .and. lContinua .and. SE2->E2_FILIAL == xFilial("SE2")
				
				oReport:IncMeter()
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Filtro de usuário pela tabela SA2.					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SA2")
				MsSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
				If !Empty(cFilUserSA2).And.!SA2->(&cFilUserSA2)
					SE2->(dbSkip())
					Loop
				Endif
				
				dbSelectArea("SE2")
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Considera filtro do usuario no ponto de entrada.             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFr150flt
					If &cFr150flt
						DbSkip()
						Loop
					Endif
				Endif					
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se titulo, apesar do E2_SALDO = 0, deve aparecer ou ³
				//³ nÆo no relat¢rio quando se considera database (MV_PAR21 = 1) ³
				//³ ou caso nÆo se considere a database, se o titulo foi totalmen³
				//³ te baixado.																  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE2")
				IF !Empty(SE2->E2_BAIXA) .and. Iif(MV_PAR21 == 2 ,SE2->E2_SALDO == 0 ,SE2->E2_SALDO == 0 .and. SE2->E2_BAIXA <= dDataBase)						
					dbSkip()
					Loop
				EndIF
	            
				 // Tratamento da correcao monetaria para a Argentina
				If  cPaisLoc=="ARG" .And. MV_PAR15 <> 1  .And.  SE2->E2_CONVERT == 'N'
					dbSkip()
					Loop
				Endif
	
				dbSelectArea("SA2")
				MSSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
				dbSelectArea("SE2")
	
				// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
				If SE2->E2_VENCREA < dDataBase
					If MV_PAR17 == 2 .And. RecMoeda(SE2->E2_VENCREA,cMoeda) > 0
						dDataReaj := SE2->E2_VENCREA
					Else
						dDataReaj := dDataBase
					EndIf	
				Else
					dDataReaj := dDataBase
				EndIf       
	
				If MV_PAR21 == 1
					nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,MV_PAR15,dDataReaj,,SE2->E2_LOJA,,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil),IIF(MV_PAR34 == 2,3,1)) // 1 = DT BAIXA    3 = DT DIGIT
					//Verifica se existem compensações em outras filiais para descontar do saldo, pois a SaldoTit() somente
					//verifica as movimentações da filial corrente. Nao deve processar quando existe somente uma filial.
					If !Empty(xFilial("SE2")) .And. !Empty(xFilial("SE5"))
						nSaldo -= FRVlCompFil("P",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,IIF(MV_PAR34 == 2,3,1),,,,MV_PAR15,SE2->E2_MOEDA,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil),dDataReaj,.T.)
					EndIf
					// Subtrai decrescimo para recompor o saldo na data escolhida.
					If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_DECRESC > 0 .And. SE2->E2_SDDECRE == 0
						nSAldo -= SE2->E2_DECRESC
					Endif	
					// Soma Acrescimo para recompor o saldo na data escolhida.
					If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_ACRESC > 0 .And. SE2->E2_SDACRES == 0
						nSAldo += SE2->E2_ACRESC
					Endif				
				Else
					nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,MV_PAR15,dDataReaj,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil))
				Endif
				If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
				   ! ( MV_PAR21 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
	
					//Quando considerar Titulos com emissao futura, eh necessario
					//colocar-se a database para o futuro de forma que a Somaabat()
					//considere os titulos de abatimento
					If MV_PAR36 == 1
						dOldData := dDataBase
						dDataBase := CTOD("31/12/40")
					Endif
	
					nSaldo-=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",MV_PAR15,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)
	
					If MV_PAR36 == 1
						dDataBase := dOldData
					Endif
				EndIf
	
				nSaldo:=Round(NoRound(nSaldo,3),2)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Desconsidera caso saldo seja menor ou igual a zero   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nSaldo <= 0
					dbSkip()
					Loop
				Endif  
	
				aDados[FORNEC] := SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+If(MV_PAR28 == 1, SA2->A2_NREDUZ, SA2->A2_NOME)
				aDados[TITUL]		:= SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
				aDados[TIPO]		:= SE2->E2_TIPO
				aDados[NATUREZA]	:= SE2->E2_NATUREZ
				aDados[EMISSAO]	:= SE2->E2_EMISSAO
				aDados[VENCTO]		:= SE2->E2_VENCTO
				aDados[VENCREA]	:= SE2->E2_VENCREA
				aDados[VL_ORIG]	:= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil)) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
				aDados[EMIS1]	:= SE2->E2_EMIS1
	
				If dDataBase > SE2->E2_VENCREA 		//vencidos
					aDados[VL_NOMINAL] := nSaldo * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
					nJuros := 0
					dBaixa := dDataBase
					
					// Cálculo dos Juros retroativo.
					dUltBaixa := SE2->E2_BAIXA
					If MV_PAR21 == 1 // se compoem saldo retroativo verifico se houve baixas
						If !Empty(dUltBaixa) .And. dDataBase < dUltBaixa
							dUltBaixa := FR150DBX() // Ultima baixa até DataBase
						EndIf
					EndIf
					
					dbSelectArea("SE2")
					nJuros := fa080Juros(MV_PAR15,nSaldo,"SE2",dUltBaixa)
			
					dbSelectArea("SE2")
					aDados[VL_CORRIG] := (nSaldo+nJuros) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1)
					If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
						nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil))
						nTit1 -= nSaldo
						nTit2 -= nSaldo+nJuros
						nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit1 -= nSaldo
						nMesTit2 -= nSaldo+nJuros
					Else
						nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil))
						nTit1 += nSaldo
						nTit2 += nSaldo+nJuros
						nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit1 += nSaldo
						nMesTit2 += nSaldo+nJuros
					Endif
					nTotJur += (nJuros)
					nMesTitJ += (nJuros)
				Else				  //a vencer
					aDados[VL_VENCIDO] := nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
					If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
						nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil))
						nTit3 -= nSaldo
						nTit4 -= nSaldo
						nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit3 -= nSaldo
						nMesTit4 -= nSaldo
					Else
						nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil))
						nTit3 += nSaldo
						nTit4 += nSaldo
						nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit3 += nSaldo
						nMesTit4 += nSaldo
					Endif
				Endif
	
				aDados[PORTADOR] := SE2->E2_PORTADO
	
				If nJuros > 0
					aDados[VL_JUROS] := nJuros
					nJuros := 0
				Endif
	
				IF dDataBase > E2_VENCREA
					nAtraso:=dDataBase-E2_VENCTO
					IF Dow(E2_VENCTO) == 1 .Or. Dow(E2_VENCTO) == 7
						IF Dow(dBaixa) == 2 .and. nAtraso <= 2
							nAtraso:=0
						EndIF
					EndIF
					nAtraso := If(nAtraso<0,0,nAtraso)
					IF nAtraso>0
						aDados[ATRASO] := nAtraso
					EndIF
				EndIF
				If MV_PAR20 == 1	//1- Analitico  2-Sintetico
					If nLenSelFil > 1
						obreak2:execute(.F.)
					EndIf					
					aDados[HISTORICO] := SUBSTR(SE2->E2_HIST,1,25)+If(E2_TIPO $ MVPROVIS,"*"," ")
					nRecnoSE2 := SE2->(R_E_C_N_O_)

					DbChangeAlias("SE2","SE2QRY")
					DbChangeAlias("__SE2","SE2")
					SE2->(DBGoto(nRecnoSE2))
					oSection1:PrintLine()
					DbChangeAlias("SE2","__SE2")
					DbChangeAlias("SE2QRY","SE2")
					aFill(aDados,nil)
				EndIf
				cNomFil 	:= cFilAnt + " - " + AllTrim(aSM0[nInc][7])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Carrega data do registro para permitir ³
				//³ posterior analise de quebra por mes.	 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
	
				If nOrdem == 5		//Forncedor
					cNomFor := If(MV_PAR28 == 1,AllTrim(SA2->A2_NREDUZ),AllTrim(SA2->A2_NOME))+" "+Substr(SA2->A2_TEL,1,15)
	            ElseIf nOrdem == 7	//Codigo Fornecedor
					cNomFor :=	SA2->A2_COD+" "+SA2->A2_LOJA+" "+AllTrim(SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
				EndIf
				
				If nOrdem == 2		//Natureza
					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xFilial("SED")+SE2->E2_NATUREZ)
					cNomNat	:= MascNat(SED->ED_CODIGO)+" "+SED->ED_DESCRIC
				EndIf
				
				cNumBco	 := SE2->E2_PORTADO
				dDtVenc  := IIf(nOrdem == 3,SE2->E2_VENCREA,SE2->E2_EMISSAO)
				nTotVenc := nTit2+nTit3
				nTotMes	 := nMesTit2+nMesTit3
	
				SE2->(dbSkip())
	
				nTotTit ++
				nMesTTit ++
				nFilTit++
				nTit5 ++
				nTotTitEmp++		/* GESTAO */				
			EndDo
	
			If nTit5 > 0 .and. nOrdem != 1 .And. MV_PAR20 == 2	//1- Analitico  2-Sintetico	
				SubT150R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,oReport,oSection1)
			EndIF
					
		   	nTotGeral  := nTotMes 
			nTotTitMes := nMesTTit
			nGerTot  += nTit2+nTit3
			nFilTot  += nTit2+nTit3
	
			If MV_PAR20 == 2	//1- Analitico  2-Sintetico	
				lQuebra := .F.
				If nOrdem == 3 .and. Month(SE2->E2_VENCREA) # Month(dDataAnt)
					lQuebra := .T.
				Elseif nOrdem == 6 .and. Month(SE2->E2_EMISSAO) # Month(dDataAnt)
					lQuebra := .T.
				Endif
				If lQuebra .And. nMesTTit # 0
					oReport:SkipLine()
					IMes150R(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nTotTitMes,oReport,oSection1)
					oReport:SkipLine()
					nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
				Endif
			EndIf
					
			dbSelectArea("SE2")
	
			nTot0 += nTit0
			nTot1 += nTit1
			nTot2 += nTit2
			nTot3 += nTit3
			nTot4 += nTit4
			nTotJ += nTotJur
			
			/*
			GESTAO - inicio */
			nTotEmp0 += nTit0
			nTotEmp1 += nTit1
			nTotEmp2 += nTit2
			nTotEmp3 += nTit3
			nTotEmp4 += nTit4
			nTotEmpJ += nTotJur
			/* GESTAO - fim
			 */	
	
			nFil0 += nTit0
			nFil1 += nTit1
			nFil2 += nTit2
			nFil3 += nTit3
			nFil4 += nTit4
			nFilJ += nTotJur
			Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur
			
			nTotMes 	:= nTotVenc
			nTotFil 	:= nFil2 + nFil3
			nTotEmp 	+= nTotFil		
			
		Enddo					
	        
		
		IF !lQryEmp .And. (nOrdem == 3 .OR. nOrdem == 6)
			aAdd(aTotFil,{aSM0[nInc][2],nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj,aSM0[nInc][7]})
		EndIf
		
			
		If MV_PAR20 == 1 .and.  nTotFil <> 0 .and. nLenSelFil > 1
			obreak2:PrintTotal()
			oReport:Skipline()
		EndIF
		

		If MV_PAR20 == 2	//1- Analitico  2-Sintetico	
			if MV_PAR22 == 1 .and. Len(aSM0) > 1 
				oReport:SkipLine()
				IFil150R(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj,oReport,oSection1,aSM0[nInc][7])
				Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
				oReport:SkipLine()			
			Endif	
		EndIf
		
		Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilJ,nTotJur,nTotFil

		dbSelectArea("SE2")		// voltar para alias existente, se nao, nao funciona
		If Empty(xFilial("SE2"))
			Exit
		Endif

		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSetOrder(1)
	
	EndIf
	nInc++
EndDo
	
SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL 


If MV_PAR20 == 2	//1- Analitico  2-Sintetico	
	If (nLenSelFil > 1) .Or. (MV_PAR22 == 1 .And. SM0->(Reccount()) > 1) 		
		oReport:ThinLine()  
		ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)
		oReport:SkipLine()
	Else
		ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)	
	EndIf
EndIf

If !nLenSelFil > 1 	
	oSection1:Finish()
EndIf


IF nOrdem == 3 .OR. nOrdem == 6
	
	oSection2:Init()   
	For ni := 1 to Len(aTotFil)
		oSection2:printline()
	Next
	
	oSection2:Finish()
EndIf

dbSelectArea("SE2")
dbCloseArea()
ChKFile("SE2")
dbSetOrder(1)
If !Empty(aTmpFil)
	For nBx := 1 To Len(aTmpFil)
		CtbTmpErase(aTmpFil[nBx])
	Next
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura empresa / filial original    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SM0->(dbGoto(nRegEmp))
cFilAnt := SM0->M0_CODFIL

//Acerta a database de acordo com a database real do sistema
If MV_PAR21 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubT150R  ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR SUBTOTAL DO RELATORIO 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubT150R()  															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SubT150R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,oReport,oSection1)

Local cQuebra := ""

If nOrdem == 1 .Or. nOrdem == 3 .Or. nOrdem == 6
	cQuebra := STR0026 + DtoC(cCarAnt) //"S U B - T O T A L ----> "
ElseIf nOrdem == 2
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+cCarAnt)
	cQuebra := cCarAnt +" "+SED->ED_DESCRIC
ElseIf nOrdem == 4
	cQuebra := STR0026 + cCarAnt //"S U B - T O T A L ----> "
Elseif nOrdem == 5
	cQuebra := If(MV_PAR28 == 1,SA2->A2_NREDUZ,SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
ElseIf nOrdem == 7
	cQuebra := SA2->A2_COD+" "+SA2->A2_LOJA+" "+SA2->A2_NOME+" "+Substr(SA2->A2_TEL,1,15)
Endif

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| cQuebra })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nTit1   })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nTit2   })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nTit3   })
oSection1:Cell("JUROS"     ):SetBlock({|| nTotJur })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nTit2+nTit3 })

oSection1:PrintLine()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpT150R  ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpT150R()	 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0027 + "(" + ALLTRIM(STR(nTotTit))+" "+If(nTotTit > 1,STR0028,STR0029)+")" })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nTot1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nTot2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nTot3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nTotJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nTot2+nTot3 })

oSection1:PrintLine()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³IMes150R  ³ Autor ³ Vinicius Barreira	  ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ IMes150R()  															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function IMes150R(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nTotTitMes,oReport,oSection1)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0030 + "("+ALLTRIM(STR(nTotTitMes))+" "+IIF(nTotTitMes > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")" })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nMesTit1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nMesTit2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nMesTit3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nMesTitJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nMesTit2+nMesTit3 })

oSection1:PrintLine()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ IFil150R	³ Autor ³ Paulo Boschetti 	     ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ IFil150R()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico				   									 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function IFil150R(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ,oReport,oSection1,cFilSM0)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0032 + " " + cFilAnt + " - " + AllTrim(cFilSM0) })	//"T O T A L   F I L I A L ----> " 
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nFil1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nFil2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nFil3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nFilJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nFil2+nFil3 })

oSection1:PrintLine()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³HabiCel	³ Autor ³ Daniel Tadashi Batori ³ Data ³ 04/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³habilita ou desabilita celulas para imprimir totais		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ HabiCel()	 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±³			 ³ oReport ->objeto TReport que possui as celulas 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function HabiCel(oReport)

Local oSection1 := oReport:Section(1)

oSection1:Cell("FORNECEDOR"):SetSize(50)
oSection1:Cell("TITULO"    ):Disable()
oSection1:Cell("E2_TIPO"   ):Hide()
oSection1:Cell("E2_NATUREZ"):Hide()
oSection1:Cell("E2_EMISSAO"):Hide()
oSection1:Cell("E2_VENCTO" ):Hide()
oSection1:Cell("E2_VENCREA"):Hide()
oSection1:Cell("VAL_ORIG"  ):Hide()
oSection1:Cell("E2_PORTADO"):Hide()
oSection1:Cell("DIA_ATR"   ):Hide()
oSection1:Cell("E2_HIST"   ):Disable()
oSection1:Cell("VAL_SOMA"  ):Enable()
oSection1:Cell("E2_EMIS1"  ):Hide()

oSection1:Cell("FORNECEDOR"):HideHeader()
oSection1:Cell("E2_TIPO"   ):HideHeader()
oSection1:Cell("E2_NATUREZ"):HideHeader()
oSection1:Cell("E2_EMISSAO"):HideHeader()
oSection1:Cell("E2_VENCTO" ):HideHeader()
oSection1:Cell("E2_VENCREA"):HideHeader()
oSection1:Cell("VAL_ORIG"  ):HideHeader()
oSection1:Cell("E2_PORTADO"):HideHeader()
oSection1:Cell("DIA_ATR"   ):HideHeader()	
oSection1:Cell("E2_EMIS1"   ):HideHeader()	

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 22/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna um array com as informacoes das filias das empresas ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AdmAbreSM0()
	Local aArea			:= SM0->( GetArea() )
	Local aAux			:= {}
	Local aRetSM0		:= {}
	Local lFWLoadSM0	:= FindFunction( "FWLoadSM0" )
	Local lFWCodFilSM0 	:= FindFunction( "FWCodFil" )

	If lFWLoadSM0
		aRetSM0	:= FWLoadSM0()
	Else
		DbSelectArea( "SM0" )
		SM0->( DbGoTop() )
		While SM0->( !Eof() )
			aAux := { 	SM0->M0_CODIGO,;
						IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
						"",;
						"",;
						"",;
						SM0->M0_NOME,;
						SM0->M0_FILIAL }

			aAdd( aRetSM0, aClone( aAux ) )
			SM0->( DbSkip() )
		End
	EndIf

	RestArea( aArea )
Return aRetSM0


//-------------------------------------------------------------------
/*/{Protheus.doc} FR150DBX

Busca a data da ultima baixa realizada do titulo a pagar até a
DataBase do sistema.

@author leonardo.casilva

@since 20/05/2016
@version P1180
 
@return
/*/
//-------------------------------------------------------------------
Static Function FR150DBX()

Local dDataRet := SE2->E2_VENCREA
Local cQuery	 := "SELECT"

cQuery += " MAX(SE5.E5_DATA) DBAIXA"
cQuery += " FROM "+ RetSQLName( "SE5" ) + " SE5 "
cQuery += " WHERE SE5.E5_FILIAL IN ('" + xFilial("SE2")  + "') " 
cQuery += " AND SE5.E5_PREFIXO = '" + SE2->E2_PREFIXO	 + "'"
cQuery += " AND SE5.E5_NUMERO = '"  + SE2->E2_NUM		 + "'"
cQuery += " AND SE5.E5_PARCELA = '" + SE2->E2_PARCELA	 + "'"
cQuery += " AND SE5.E5_TIPO = '"	+ SE2->E2_TIPO	 	 + "'"
cQuery += " AND SE5.E5_CLIFOR = '"	+ SE2->E2_FORNECE	 + "'"
cQuery += " AND SE5.E5_LOJA = '"	+ SE2->E2_LOJA	 	 + "'"
cQuery += " AND SE5.E5_TIPODOC IN('BA','VL')"
cQuery += " AND SE5.E5_RECPAG  = 'P'"
cQuery += " AND SE5.E5_DATA <= '"	+ DTOS(dDataBase) + "'"
cQuery += " AND SE5.D_E_L_E_T_ = ' '"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBDATA",.T.,.T.)

If TRBDATA->(!EOF())
	If !Empty(AllTrim(TRBDATA->DBAIXA))
		dDataRet := STOD(TRBDATA->DBAIXA)
	Endif
EndIf
TRBDATA->(dbCloseArea())

Return dDataRet


//--------------------------------------------------------------------
/*/{Protheus.doc} AtuSX1, Grupo de perguntas do FIN150
Atualização do SX1 - Perguntas, 

@author TOTVS Protheus - Geronimo Benedito Alves
@since  20/08/2018
@obs    Gerado por EXPORDIC - V.5.4.1.3 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function AtuSX1()
Local aArea    := GetArea()
Local aAreaDic := SX1->( GetArea() )
Local aEstrut  := {}
Local aStruDic := SX1->( dbStruct() )
Local aDados   := {}
Local nI       := 0
Local nJ       := 0
Local nTam1    := Len( SX1->X1_GRUPO )
Local nTam2    := Len( SX1->X1_ORDEM )

aEstrut := { "X1_GRUPO"  , "X1_ORDEM"  , "X1_PERGUNT", "X1_PERSPA" , "X1_PERENG" , "X1_VARIAVL", "X1_TIPO"   , ;
             "X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC"    , "X1_VALID"  , "X1_VAR01"  , "X1_DEF01"  , ;
             "X1_DEFSPA1", "X1_DEFENG1", "X1_CNT01"  , "X1_VAR02"  , "X1_DEF02"  , "X1_DEFSPA2", "X1_DEFENG2", ;
             "X1_CNT02"  , "X1_VAR03"  , "X1_DEF03"  , "X1_DEFSPA3", "X1_DEFENG3", "X1_CNT03"  , "X1_VAR04"  , ;
             "X1_DEF04"  , "X1_DEFSPA4", "X1_DEFENG4", "X1_CNT04"  , "X1_VAR05"  , "X1_DEF05"  , "X1_DEFSPA5", ;
             "X1_DEFENG5", "X1_CNT05"  , "X1_F3"     , "X1_PYME"   , "X1_GRPSXG" , "X1_HELP"   , "X1_PICTURE", ;
             "X1_IDFIL"  }

aAdd( aDados, {'FIN150','18','Da Data Entrada  (Dt Contabil)','¿A Fecha Contable ?','From Acconting Date ?','mv_chh','D',8,0,0,'G','','mv_dtcont1','','','','20160101','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2418.','',''} )
aAdd( aDados, {'FIN150','19','Ate Data Entrada (Dt Contabil)','¿A Fecha Contable ?','To Accounting Date ?','mv_chi','D',8,0,0,'G','','mv_dtcont2','','','','20161231','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2419.','',''} )

//
// Atualizando dicionário
//
dbSelectArea( "SX1" )
SX1->( dbSetOrder( 1 ) )

For nI := 1 To Len( aDados )
	If SX1->( dbSeek( PadR( aDados[nI][1], nTam1 ) + PadR( aDados[nI][2], nTam2 ) ) )
		RecLock( "SX1", .F. )
		For nJ := 1 To Len( aDados[nI] )
			If nJ == 3		// Altero somente a descrição da pergunta 18 para 'Da Data Entrada  (Dt Contabil)' e a 19 para 'Ate Data Entrada (Dt Contabil)' 
				If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
					SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aDados[nI][nJ] ) )
				EndIf
			Endif
		Next nJ
		MsUnLock()
	EndIf
Next nI

RestArea( aAreaDic )
RestArea( aArea )

Return NIL



////--------------------------------------------------------------------
////{Protheus.doc} AtuSX1FULL, Grupo de perguntas do M34R24
//Atualização do SX1 - Perguntas, 
//
//@author TOTVS Protheus - Geronimo Benedito Alves
//@since  20/08/2018
//@obs    Gerado por EXPORDIC - V.5.4.1.3 EFS / Upd. V.4.21.17 EFS
//@version 1.0
////
////--------------------------------------------------------------------
//Static Function AtuSX1FULL()
//Local aArea    := GetArea()
//Local aAreaDic := SX1->( GetArea() )
//Local aEstrut  := {}
//Local aStruDic := SX1->( dbStruct() )
//Local aDados   := {}
//Local nI       := 0
//Local nJ       := 0
//Local nTam1    := Len( SX1->X1_GRUPO )
//Local nTam2    := Len( SX1->X1_ORDEM )
//
//aEstrut := { "X1_GRUPO"  , "X1_ORDEM"  , "X1_PERGUNT", "X1_PERSPA" , "X1_PERENG" , "X1_VARIAVL", "X1_TIPO"   , ;
//             "X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC"    , "X1_VALID"  , "X1_VAR01"  , "X1_DEF01"  , ;
//             "X1_DEFSPA1", "X1_DEFENG1", "X1_CNT01"  , "X1_VAR02"  , "X1_DEF02"  , "X1_DEFSPA2", "X1_DEFENG2", ;
//             "X1_CNT02"  , "X1_VAR03"  , "X1_DEF03"  , "X1_DEFSPA3", "X1_DEFENG3", "X1_CNT03"  , "X1_VAR04"  , ;
//             "X1_DEF04"  , "X1_DEFSPA4", "X1_DEFENG4", "X1_CNT04"  , "X1_VAR05"  , "X1_DEF05"  , "X1_DEFSPA5", ;
//             "X1_DEFENG5", "X1_CNT05"  , "X1_F3"     , "X1_PYME"   , "X1_GRPSXG" , "X1_HELP"   , "X1_PICTURE", ;
//             "X1_IDFIL"  }
//
//aAdd( aDados, {'M34R24','01','Do Numero ?','¿De número ?','From Number ?','MV_CH1','C',9,0,0,'G','','mv_numde','','','','','','','','','','','','','','','','','','','','','','','','','','S','018','.M34R2401.','',''} )
//aAdd( aDados, {'M34R24','02','Ate o Numero ?','¿A número ?','To Number ?','MV_CH2','C',9,0,0,'G','','mv_numate','','','','ZZZZZZ','','','','','','','','','','','','','','','','','','','','','','S','018','.M34R2402.','',''} )
//aAdd( aDados, {'M34R24','03','Do Prefixo ?','¿De Prefijo ?','From Prefix ?','mv_ch3','C',3,0,0,'G','','mv_prfde','','','','','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2403.','',''} )
//aAdd( aDados, {'M34R24','04','Ate o Prefixo ?','¿A Prefijo ?','To Prefix ?','mv_ch4','C',3,0,0,'G','','mv_prfate','','','','ZZZ','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2404.','',''} )
//aAdd( aDados, {'M34R24','05','Da Natureza ?','¿De Naturaleza ?','From Class ?','mv_ch5','C',10,0,0,'G','','mv_natde','','','','','','','','','','','','','','','','','','','','','','','','','SED','S','','.M34R2405.','',''} )
//aAdd( aDados, {'M34R24','06','Ate a Natureza ?','¿A Naturaleza ?','To Class ?','mv_ch6','C',10,0,0,'G','','mv_natate','','','','ZZZZZZZZZZ','','','','','','','','','','','','','','','','','','','','','SED','S','','.M34R2406.','',''} )
//aAdd( aDados, {'M34R24','07','Do Vencimento ?','¿De Vencimiento ?','From Due Date ?','mv_ch7','D',8,0,0,'G','','mv_vencde','','','','20160101','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2407.','',''} )
//aAdd( aDados, {'M34R24','08','Ate o Vencimento ?','¿A Vencimiento ?','To Due Date ?','mv_ch8','D',8,0,0,'G','','mv_vencate','','','','20170928','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2408.','',''} )
//aAdd( aDados, {'M34R24','09','Do Banco ?','¿De Banco ?','From Bank ?','mv_ch9','C',3,0,0,'G','','mv_bcode','','','','','','','','','','','','','','','','','','','','','','','','','BCO','S','007','.M34R2409.','',''} )
//aAdd( aDados, {'M34R24','10','Ate o Banco ?','¿A Banco ?','To Bank ?','mv_cha','C',3,0,0,'G','','mv_bcoate','','','','ZZZ','','','','','','','','','','','','','','','','','','','','','BCO','S','007','.M34R2410.','',''} )
//aAdd( aDados, {'M34R24','11','Do Fornecedor ?','¿De Proveedor ?','From Supplier ?','mv_chb','C',6,0,0,'G','','mv_fornde','','','','','','','','','','','','','','','','','','','','','','','','','SA2','S','001','.M34R2411.','',''} )
//aAdd( aDados, {'M34R24','12','Ate o Fornecedor ?','¿A Proveedor ?','To Supplier ?','mv_chc','C',6,0,0,'G','','mv_fornate','','','','ZZZZZZ','','','','','','','','','','','','','','','','','','','','','SA2','S','001','.M34R2412.','',''} )
//aAdd( aDados, {'M34R24','13','Da Emissao ?','¿De Emision ?','From Issue Date ?','mv_chd','D',8,0,0,'G','','mv_emisde','','','','20160101','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2413.','',''} )
//aAdd( aDados, {'M34R24','14','Ate a Emissao ?','¿A Emision ?','To Issue Date ?','mv_che','D',8,0,0,'G','','mv_emisate','','','','20170913','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2414.','',''} )
//aAdd( aDados, {'M34R24','15','Qual Moeda ?','¿Que Moneda ?','Which Currency ?','mv_chf','N',2,0,0,'G','VerifMoeda(MV_PAR15)','MV_PAR15','','','','0','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2415.','',''} )
//aAdd( aDados, {'M34R24','16','Imprime Provisorios ?','¿Imprime Provisorios ?','Print Temporary ?','mv_chg','N',1,0,2,'C','','','Sim','Si','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','S','','.M34R2416.','',''} )
//aAdd( aDados, {'M34R24','17','Converte Venci pela ?','¿Convierte Vencidos por ?','Convert per ?','MV_CHH','N',1,0,2,'C','','MV_PAR17','Data Base','Fecha de Hoy','Base Date','','','Data de Vencto','Fecha Vencto.','Due Date','','','','','','','','','','','','','','','','','','S','','.M34R2417.','',''} )
//aAdd( aDados, {'M34R24','18','Data de Entrada Inicial ?','¿A Fecha Contable ?','From Acconting Date ?','mv_chh','D',8,0,0,'G','','mv_dtcont1','','','','20160101','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2418.','',''} )
//aAdd( aDados, {'M34R24','19','Data de Entrada Final ?','¿A Fecha Contable ?','To Accounting Date ?','mv_chi','D',8,0,0,'G','','mv_dtcont2','','','','20161231','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2419.','',''} )
//aAdd( aDados, {'M34R24','20','Imprime Relatorio ?','¿Imprimir Informe ?','Print Report ?','mv_chj','N',1,0,1,'C','','MV_PAR20','Analitico','Analitico','Detailed','','','Sintetico','Sintetico','Summarized','','','','','','','','','','','','','','','','','','S','','.M34R2420.','',''} )
//aAdd( aDados, {'M34R24','21','Compoem Saldo Retroativo ?','¿Componen Saldo Retroactivo ?','Consider Base Date ?','mv_chk','N',1,0,1,'C','','','Sim','Si','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','S','','.M34R2421.','',''} )
//aAdd( aDados, {'M34R24','22','Cons.Filiais abaixo ?','¿Considera Siguientes Suc ?','Cons.Branches below ?','mv_chx','C',1,0,2,'C','','','Sim','Si','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','S','','.M34R2422.','',''} )
//aAdd( aDados, {'M34R24','23','Da Filial ?','¿De Sucursal ?','From Branch ?','mv_chy','C',6,0,0,'G','','MV_PAR23','','','','','','','','','','','','','','','','','','','','','','','','','SM0_01','S','033','.M34R2423.','',''} )
//aAdd( aDados, {'M34R24','24','Ate a Filial ?','¿A Sucursal ?','To Branch ?','mv_chz','C',6,0,0,'G','','MV_PAR24','','','','','','','','','','','','','','','','','','','','','','','','','SM0_01','S','033','.M34R2424.','',''} )
//aAdd( aDados, {'M34R24','25','Da Loja ?','¿De Tienda ?','From Unit ?','mv_cho','C',2,0,0,'G','','MV_PAR25','','','','','','','','','','','','','','','','','','','','','','','','','','S','002','.M34R2425.','',''} )
//aAdd( aDados, {'M34R24','26','Ate a Loja ?','¿A Tienda ?','To Unit ?','mv_chp','C',2,0,0,'G','','MV_PAR26','','','','ZZ','','','','','','','','','','','','','','','','','','','','','','S','002','.M34R2426.','',''} )
//aAdd( aDados, {'M34R24','27','Considera Adiantam. ?','¿Considera Anticipo ?','Consider Advance ?','mv_chq','N',1,0,1,'C','','MV_PAR27','Sim','Si','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','S','','.M34R2427.','',''} )
//aAdd( aDados, {'M34R24','28','Imprime Nome ?','¿Imprime Nombre ?','Print Name ?','mv_chm','N',1,0,1,'C','','MV_PAR28','Nome Reduzido','Nombre Reducido','Reduced Name','','','Razao Social','Razon Social','Trade Name','','','','','','','','','','','','','','','','','','S','','.M34R2428.','',''} )
//aAdd( aDados, {'M34R24','29','Outras Moedas ?','¿Otras Monedas ?','Other Currencies ?','mv_chn','N',1,0,1,'C','','MV_PAR29','Converter','Convertir','Convert','','','Nao Imprimir','No Imprimir','Do Not Print','','','','','','','','','','','','','','','','','','S','','.M34R2429.','',''} )
//aAdd( aDados, {'M34R24','30','Imprimir Tipos ?','¿Imprimir Tipos ?','Print Types ?','mv_cho','C',40,0,0,'G','','MV_PAR30','','','','','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2430.','',''} )
//aAdd( aDados, {'M34R24','31','Nao Imprimir Tipos ?','¿No imprimir tipos ?','Do Not Print Types ?','mv_chn','C',40,0,0,'G','','MV_PAR31','','','','','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2431.','',''} )
//aAdd( aDados, {'M34R24','32','Somente Tit.p/Fluxo ?','¿Solamente Titulo p/Flujo ?','Only Bill per Flow ?','mv_cho','N',1,0,2,'C','','MV_PAR32','Sim','Si','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','S','','.M34R2432.','',''} )
//aAdd( aDados, {'M34R24','33','Data Base ?','¿Fecha base ?','Base Date ?','MV_CHX','D',8,0,0,'G','!Empty(MV_PAR33)','MV_PAR33','','','','18/01/2018','','','','','','','','','','','','','','','','','','','','','','S','','.M34R2433.','',''} )
//aAdd( aDados, {'M34R24','34','Compoe Saldo por ?','¿Compone saldo por ?','Set Balance by ?','MV_CHS','N',1,0,1,'C','','MV_PAR34','Data da Baixa','Fecha Baja','Posting Date','','','Data Digitacao','Fch.Digitacion','Entry Date','','','','','','','','','','','','','','','','','','S','','.M34R2434.','',''} )
//aAdd( aDados, {'M34R24','35','Quanto a taxa ?','¿Con referencia a tasa ?','How about rate ?','MV_CHT','N',1,0,1,'C','','MV_PAR35','Taxa contratada','Tasa contratada','Hired rate','','','Taxa normal','Tasa normal','Standard rate','','','','','','','','','','','','','','','','','','S','','.M34R2435.','',''} )
//aAdd( aDados, {'M34R24','36','Tit. Emissao Futura ?','¿Tit. Emision Futura ?','Future issue bill ?','MV_CHU','N',1,0,2,'C','','MV_PAR36','Sim','Si','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','S','','.M34R2436.','',''} )
//aAdd( aDados, {'M34R24','37','Seleciona  Filiais ?','¿Selecciona sucursales ?','Select Branches ?','MV_CHX','N',1,0,1,'C','','MV_PAR37','Sim','Sí','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','S','','.M34R2437.','',''} )
//aAdd( aDados, {'M34R24','38','Considera Titulos Excluidos ?','¿Considera títulos borrados ?','Consider Deleted Titles ?','MV_CHY','N',1,0,2,'C','','MV_PAR38','Sim','Sí','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','S','','.M34R2438.','',''} )
//
////
//// Atualizando dicionário
////
//dbSelectArea( "SX1" )
//SX1->( dbSetOrder( 1 ) )
//
//For nI := 1 To Len( aDados )
//	If !SX1->( dbSeek( PadR( aDados[nI][1], nTam1 ) + PadR( aDados[nI][2], nTam2 ) ) )
//		RecLock( "SX1", .T. )
//		For nJ := 1 To Len( aDados[nI] )
//			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
//				SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aDados[nI][nJ] ) )
//			EndIf
//		Next nJ
//		MsUnLock()
//	EndIf
//Next nI
//
//// Atualiza Helps
//AtuSX1Hlp()
//
//RestArea( aAreaDic )
//RestArea( aArea )
//
//Return NIL


////--------------------------------------------------------------------
// {Protheus.doc} AtuSX1Hlp
// Função de processamento da gravação dos Helps de Perguntas
// 
// @author TOTVS Protheus
// @since  16/06/2016
// @obs    Gerado por EXPORDIC - V.5.2.1.0 EFS / Upd. V.4.20.15 EFS
// @version 1.0
// 
//--------------------------------------------------------------------
//Static Function AtuSX1Hlp()
//	Local aArea 	:= GetArea()
//	Local aHelpPor	:= {}
//	Local aHelpEng	:= {}
//	Local aHelpSpa	:= {}
//	Local aExiste  := {}
//
//	aExiste  := AP5GetHelp(".M34R2438.")
//
//	If Empty(aExiste)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe código inicial do intervalo " )
//		aAdd( aHelpPor, "de número dos títulos a pagar a ser " )
//		aAdd( aHelpPor, "considerados na geração do relatório" )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2401.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		Aadd(aHelpPor,"Informe o código final do intervalo  " )
//		Aadd(aHelpPor,"de número dos títulos a pagar a ser  " )
//		Aadd(aHelpPor,"considerado na geração do relatório. " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2402.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//		
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe código inicial do intervalo " )
//		aAdd( aHelpPor, "dos prefixos dos titulos a pagar a  " )
//		aAdd( aHelpPor, "considerar na geração do relatório" )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2403.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe código final do intervalo " )
//		aAdd( aHelpPor, "dos prefixos dos titulos a pagar a  " )
//		aAdd( aHelpPor, "considerar na geração do relatório" )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2404.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione o código inicial do        " )
//		aAdd( aHelpPor, "intervalo de código das naturezas    " )
//		aAdd( aHelpPor, "dos títulos a pagar a serem          " )
//		aAdd( aHelpPor, "considerados na geração do relatório " )
//		aAdd( aHelpPor, "Tecla [F3] disponível para consultar " )
//		aAdd( aHelpPor, " o Cadastro  de Naturezas." )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2405.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione o código final do          " )
//		aAdd( aHelpPor, "intervalo de código das naturezas    " )
//		aAdd( aHelpPor, "dos títulos a pagar a serem          " )
//		aAdd( aHelpPor, "considerados na geração do relatório " )
//		aAdd( aHelpPor, "Tecla [F3] disponível para consultar " )
//		aAdd( aHelpPor, " o Cadastro  de Naturezas." )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2406.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe data inicial do intervalo de " )
//		aAdd( aHelpPor, "datas de vencimento dos títulos a pagar" )
//		aAdd( aHelpPor, " a serem considerados na geração do  " )
//		aAdd( aHelpPor, "relatório.                           " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2407.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe data final do intervalo de   " )
//		aAdd( aHelpPor, "datas de vencimento dos títulos a pagar" )
//		aAdd( aHelpPor, "a serem considerados na geração do   " )
//		aAdd( aHelpPor, "relatório.                           " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2408.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione código inicial do intervalo " )
//		aAdd( aHelpPor, "de códigos dos bancos a que pertençam " )
//		aAdd( aHelpPor, "os títulos a pagar a serem considerados " )
//		aAdd( aHelpPor, "na geração do relatório. Tela [F3]   " )
//		aAdd( aHelpPor, "disponível para consultar o Cadastro " )
//		aAdd( aHelpPor, "de Bancos.                           " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2409.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione código final do intervalo " )
//		aAdd( aHelpPor, "de códigos dos bancos a que pertençam " )
//		aAdd( aHelpPor, "os títulos a pagar a serem considerados " )
//		aAdd( aHelpPor, "na geração do relatório. Tela [F3]   " )
//		aAdd( aHelpPor, "disponível para consultar o Cadastro " )
//		aAdd( aHelpPor, "de Bancos.                           " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2410.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione código inicial do intervalo " )
//		aAdd( aHelpPor, "de códigos dos fornecedores           " )
//		aAdd( aHelpPor, "cadastrados nos títulos a pagar a serem " )
//		aAdd( aHelpPor, "considerados na geração do relatório. " )
//		aAdd( aHelpPor, "Tecla [F3] disponível para consultar o" )
//		aAdd( aHelpPor, " Cadastro de Fornecedores.            " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2411.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione código final do intervalo " )
//		aAdd( aHelpPor, "de códigos dos fornecedores           " )
//		aAdd( aHelpPor, "cadastrados nos títulos a pagar a serem " )
//		aAdd( aHelpPor, "considerados na geração do relatório. " )
//		aAdd( aHelpPor, "Tecla [F3] disponível para consultar o" )
//		aAdd( aHelpPor, " Cadastro de Fornecedores.            " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2412.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe data inicial do intervalo de " )
//		aAdd( aHelpPor, "datas de emissão dos títulos a pagar " )
//		aAdd( aHelpPor, "a serem considerados na geração do   " )
//		aAdd( aHelpPor, "relatório.                           " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2413.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe data final do intervalo de  " )
//		aAdd( aHelpPor, "datas de emissão dos títulos a pagar " )
//		aAdd( aHelpPor, "a serem considerados na geração do   " )
//		aAdd( aHelpPor, "relatório.                           " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2414.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione qual moeda deve ser        " )
//		aAdd( aHelpPor, "considerada na geração do relatório, " )
//		aAdd( aHelpPor, "se “Moeda 1”, “Moeda 2”, “Moeda 3”,  " )
//		aAdd( aHelpPor, "“Moeda 4” ou “Moeda 5”.              " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2415.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe a opção “Sim” caso o         " )
//		aAdd( aHelpPor, "relatório deva emitir os títulos     " )
//		aAdd( aHelpPor, "provisórios,ou “Não”, caso contrário." )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2416.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione qual a data a ser utilizada  " )
//		aAdd( aHelpPor, "para converter os valores de títulos   " )
//		aAdd( aHelpPor, "vencidos em moedas diferentes da selecionada" )
//		aAdd( aHelpPor, "na pergunta 'Qual Moeda?'.  Selecione  " )
//		aAdd( aHelpPor, " “Data Base”, caso a data a ser considerada" )
//		aAdd( aHelpPor, "para a cotação da moeda seja a database " )
//		aAdd( aHelpPor, "do sistema, ou  pela “Data de Venc.”,  " )
//		aAdd( aHelpPor, "caso data a ser considerada  para a    " )
//		aAdd( aHelpPor, "cotação da moeda seja a da data de     " )
//		aAdd( aHelpPor, "vencimento do título.                  " )	
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2417.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe data inicial do intervalo de " )
//		aAdd( aHelpPor, "datas de entrada (datas contábeis) a " )
//		aAdd( aHelpPor, "serem consideradas na geração do     " )
//		aAdd( aHelpPor, "relatório.                           " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2418.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe data final do intervalo de " )
//		aAdd( aHelpPor, "datas de entrada (datas contábeis) a " )
//		aAdd( aHelpPor, "serem consideradas na geração do     " )
//		aAdd( aHelpPor, "relatório.                           " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2419.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione, a opção “Analítico”, para " )
//		aAdd( aHelpPor, "que o relatório seja impresso com    " )
//		aAdd( aHelpPor, "informações completas, ou “Sintético”" )
//		aAdd( aHelpPor, ", com as informações principais dos  " )
//		aAdd( aHelpPor, "títulos a pagar."                      )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2420.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Compõe Saldo Retroativo ?            " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2421.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione a opção “Sim” para que a   " )
//		aAdd( aHelpPor, "geração do relatório considere as    " )
//		aAdd( aHelpPor, "filiais a serem informadas nos campos" )
//		aAdd( aHelpPor, "a seguir, ou “Não”, caso contrário.  " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2422.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Caso a resposta do parâmetro anterior" )
//		aAdd( aHelpPor, "“Cons. Filiais Abaixo?” seja igual a " )
//		aAdd( aHelpPor, "“Sim”, informe neste campo a filial  " )
//		aAdd( aHelpPor, "inicial do intervalo de filiais a    " )
//		aAdd( aHelpPor, "serem consideradas para emissão do   " )
//		aAdd( aHelpPor, "relatório.                           " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2423.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Caso a resposta do parâmetro anterior" )
//		aAdd( aHelpPor, "“Cons. Filiais Abaixo?” seja igual a " )
//		aAdd( aHelpPor, "“Sim”, informe neste campo a filial  " )
//		aAdd( aHelpPor, "final do intervalo de filiais a      " )
//		aAdd( aHelpPor, "serem consideradas para emissão do   " )
//		aAdd( aHelpPor, "relatório.                           " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2424.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe o código inicial do intervalo " )
//		aAdd( aHelpPor, "de lojas a serem consideradas na     " )
//		aAdd( aHelpPor, "emissão do relatório                 " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2425.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe o código final do intervalo " )
//		aAdd( aHelpPor, "de lojas a serem consideradas na     " )
//		aAdd( aHelpPor, "emissão do relatório                 " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2426.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione a opção “Sim” para que a " )
//		aAdd( aHelpPor, "geração do relatório considere os " )
//		aAdd( aHelpPor, "títulos cadastrados como adiantamentos " )
//		aAdd( aHelpPor, "de pagamento, ou “Não”, caso contrário. " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2427.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione a opção “Nome Reduzido” p/ " )
//		aAdd( aHelpPor, "que o nome do fornecedor referente   " )
//		aAdd( aHelpPor, "aos títulos selecionados sejam       " )
//		aAdd( aHelpPor, "impressos pelo nome reduzido, conforme " )
//		aAdd( aHelpPor, "cadastro, ou “Razão Social”, para que " )
//		aAdd( aHelpPor, "o nome seja a Razão Social do fornecedor. " )
//		aAdd( aHelpPor, "Este parâmetro somente terá funcionalidade " )
//		aAdd( aHelpPor, "quando a ordem utilizada for por     " )
//		aAdd( aHelpPor, "Fornecedor.                          " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2428.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione a opção “Converter” caso   " )
//		aAdd( aHelpPor, "queira que títulos a pagar em outras " )
//		aAdd( aHelpPor, "moedas tenham seu valores convertidos " )
//		aAdd( aHelpPor, "para a moeda escolhida no parâmetro  " )
//		aAdd( aHelpPor, "“Qual moeda“, ou “Não imprimir“, caso" )
//		aAdd( aHelpPor, "queira que os titulos em outras moedas " )
//		aAdd( aHelpPor, "sejam desconsiderados na geração do  " )
//		aAdd( aHelpPor, "relatório                            " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2429.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe os tipos de titulos que deseja " )
//		aAdd( aHelpPor, "imprimir separados por um “;“ (ponto e " )
//		aAdd( aHelpPor, "vírgula) e 3 caracteres cada.Exemplo: " )
//		aAdd( aHelpPor, "caso deseja imprimir apenas os titulos " )
//		aAdd( aHelpPor, "de duplicata e titulos de notas fiscais, " )
//		aAdd( aHelpPor, "informe aqui: DP ;NF.                " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2430.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe os tipos de titulos que não  " )
//		aAdd( aHelpPor, "desejá imprimir separados por um “;“ " )
//		aAdd( aHelpPor, "(ponto e vírgula) e 3 caracteres     " )
//		aAdd( aHelpPor, "cada. Exemplo: caso deseja imprimir  " )
//		aAdd( aHelpPor, "todos os titulos exceto os titulos   " )
//		aAdd( aHelpPor, "de  duplicata e titulos de notas     " )
//		aAdd( aHelpPor, "fiscais, informe aqui: DP ;NF.       " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2431.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione “Sim“ para listar apenas    " )
//		aAdd( aHelpPor, "titulos marcados para Fluxo de Caixa, " )
//		aAdd( aHelpPor, "na inclusão do contas a pagar, ou não " )
//		aAdd( aHelpPor, "caso contrário.                       " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2432.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe a data base do sistema a ser " )
//		aAdd( aHelpPor, "considerada para não ter que alterá-la" )
//		aAdd( aHelpPor, " antes de imprimir este relatório.   " )
//		aAdd( aHelpPor, " o Cadastro  de Naturezas." )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2433.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Informe se deve compor o saldo pela  " )
//		aAdd( aHelpPor, "Data da Baixa ou pela Data de        " )
//		aAdd( aHelpPor, "Digitação                            " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2434.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Indica que o valor será convertido de " )
//		aAdd( aHelpPor, "acordo com a “Taxa contradada“ ou de  " )
//		aAdd( aHelpPor, "acordo com a “Taxa normal“. Se for    " )
//		aAdd( aHelpPor, "escolhida “Taxa contratada“, o valor  " )
//		aAdd( aHelpPor, "será convertido pela taxa contradada  " )
//		aAdd( aHelpPor, "para o titulo. Se for escolhida “Taxa " )
//		aAdd( aHelpPor, "Normal“ o valor será convertido pela  " )
//		aAdd( aHelpPor, "taxa da data base do sistema, ou se o " )
//		aAdd( aHelpPor, "titulo estiver vencido, pela taxa da  " )
//		aAdd( aHelpPor, "data informada na pergunta            " )
//		aAdd( aHelpPor, " “Converte Venci Por?“                " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2435.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Selecione “Sim“ para que sejam       " )
//		aAdd( aHelpPor, "considerados no relatório, títulos cuja " )
//		aAdd( aHelpPor, "emissão seja em data posterior a     " )
//		aAdd( aHelpPor, "database do relatório, ou “Não“ em   " )
//		aAdd( aHelpPor, "Tecla [F3] disponível para consultar " )
//		aAdd( aHelpPor, "caso contrário                       " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2436.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Escolha Sim se deseja selecionar as  " )
//		aAdd( aHelpPor, "filiais. Esta pergunta somente terá  " )
//		aAdd( aHelpPor, "efeito em ambiente TOPCONNECT /      " )
//		aAdd( aHelpPor, "TOTVSDBACCESS.                       " )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2437.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//		aHelpPor	:= {}
//		aHelpSpa	:= {}
//		aHelpEng	:= {}
//		aAdd( aHelpPor, "Seleciona a opção (Sim) para que seja " )
//		aAdd( aHelpPor, "considerado na posição financeira os  " )
//		aAdd( aHelpPor, "títulos excluídos conforme DataBase.  " )
//		aAdd( aHelpPor, "Seleciona a opção (Não) será considerado " )
//		aAdd( aHelpPor, "na posição financeira os títulos que  " )
//		aAdd( aHelpPor, "não foram deletados conforme DataBase." )
//		aHelpSpa := AClone(aHelpPor)	// Espanhol
//		aHelpEng := AClone(aHelpPor)	// Ingles
//		PutHelp("P.M34R2438.",aHelpPor,aHelpEng,aHelpSpa,.T.)
//
//	EndIf
//
//	RestArea(aArea)
//	
//Return NIL


#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/03/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function MGFEST52()        // incluido pelo assistente de conversao do AP5 IDE em 25/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������
                       
SetPrvt("_CALIAS,_NORDEM,_NRECNO,CSTRING,WNREL,TAMANHO")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,ARETURN,AORD")
SetPrvt("CNOMEPRG,NLASTKEY,CBTXT,CABEC1,CABEC2,CBCONT")
SetPrvt("LIMITE,LI,M_PAG,NTIPO,NORDEM,CPERG")
SetPrvt("_APERGUNTAS,_NLACO,_ACAMPOS,_CARQTMP,_NSE1ORDEM,_NSA1ORDEM")
SetPrvt("_NSD2ORDEM,_NTOTRES,_NTOTVAL,_CCODCLI,_CCLIENTE,_NPZO,_NTOTVAL2")
SetPrvt("_NVAL,_NRESULT,CQUERY,_NVAL2")

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/03/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*
===========================================================================================
Programa.:              MT241TOK
Autor....:              Tarcisio Galeano
Data.....:              Nov/2018
Descricao / Objetivo:   relatorio de baixas de solicitacao ao armazem.
Doc. Origem:            
Solicitante:            Cliente
Uso......:                               

Obs......:               
===========================================================================================
*/
//��������������������������������������������������������������Ŀ
//� Guarda ambiente                                              �
//����������������������������������������������������������������
_cAlias:=ALIAS()
_nOrdem:=INDEXORD()
_nRecno:=RECNO()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
cString := " "
wnRel   := "MGFEST52"
Tamanho   := "G"
Titulo  := "RELATORIO DE BAIXAS DE SOLICITACAO AO ARMAZEM"
cDesc1  := "SOLICITACAO AO ARMAZEM"
cDesc2  := ""
cDesc3  := ""
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
aOrd    := {}
cNomePrg:= "MGFEST52"
nLastKey:= 0
Cbtxt     := Space( 10 )
Cabec1    :="BAIXAS DE SOLICITACAO AO ARMAZEM"


Cabec2    :=""
cbCont    := 00
Limite    := 200
li        := 80
m_pag     := 01
nTipo     := IIF(aReturn[4]==1,15,18)
nOrdem    := aReturn[8]
//cPerg   := "COMIS1"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//Pergunte( cPerg,.F.)
wnRel:=SetPrint(cString,wnRel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

#IFDEF WINDOWS
	Processa({|| RPZCOM() })// Substituido pelo assistente de conversao do AP5 IDE em 25/03/02 ==>    Processa({|| Execute(RPZOVD) })
	Return
	/*/
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������Ŀ��
	���Funcao    � RPZOVD   � Autor � Dirceu C. Castilho    � Data � 18.08.99 ���
	�������������������������������������������������������������������������Ĵ��
	���Descricao � Processamento                                              ���
	�������������������������������������������������������������������������Ĵ��
	��� Uso      � DVPZOVEN                                                   ���
	�������������������������������������������������������������������������Ĵ��
	��� Revisao  �                                          � Data �          ���
	��������������������������������������������������������������������������ٱ�
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	/*/
	// Substituido pelo assistente de conversao do AP5 IDE em 25/03/02 ==>   FUNCTION RPZOVD
	Static FUNCTION RPZCOM()
#ENDIF

#IFDEF TOP
	//��������������������������������������������������������������Ŀ
	//� Gera Arquivo Temporario utilizando TCQUERY                   �
	//����������������������������������������������������������������
		Titulo  := "BAIXA SOLICITACAO AO ARMAZEM "
	
	CriaTmp()
	//��������������������������������������������������������������Ŀ
	//� Trabalha os dados do arquivo gerado                          �
	//����������������������������������������������������������������
	dbSelectArea("TRC")
	dbGotop()
	
	ProcRegua(RecCount())
		//While !Eof()

            
			//��������������������������������������������������������������Ŀ
			//� Verifica se o usuario interrompeu o relatorio                �
			//����������������������������������������������������������������
			If li > 59
				Cabec(Titulo,Cabec1,Cabec2,cNomePrg,Tamanho,nTipo)
			Endif
			//

			@ li,001 PSAY "UNIDADE      :"+TRC->D3_FILIAL
			li ++
			//@ li,001 PSAY "NRO. SA      :"+TRC->CP_NUM
			//li ++
			@ li,001 PSAY "DATA         :"+TRC->D3_EMISSAO
			li ++
			@ li,001 PSAY "REQUISITANTE :"+TRC->USR_NOME
			li ++
			@ li,001 PSAY "APROVADOR    :"
			li ++
			li ++
            @ li,001 PSAY "_________________________________________________________________________________________________________________________________________________________________________________________________________________"
			li ++
			@ li,001 PSAY "| NUM S.A | ITEM | COD.PROD        | DESCRI��O                      | UM | ARMAZEM | DESCR.ARMAZEM        | ENDERE�O | LOTE        | TP | GRUPO |   QTDE.SOLIC.  |   QTDE.ATEND.  |   SALDO ATUAL  |  MATRICULA |"
			li ++
		
		While !Eof()

            @ li,001 PSAY "|_______________________________________________________________________________________________________________________________________________________________________________________________________________|"
			li ++
			@ li,001 PSAY "| "+TRC->D3_NUMSA+"  |  "+TRC->D3_ITEMSA+"  | "+TRC->D3_COD+" | "+TRC->CP_DESCRI+" | "+TRC->D3_UM+" | "+TRC->D3_LOCAL+"      | "+TRC->NNR_DESCRI+" | "+TRC->D3_LOCAL+"       |             | "+TRC->D3_TIPO+" | "+TRC->D3_GRUPO+"  | "+TRANS(TRC->D3_QUANT,"99999999.99")+"    | "+TRANS(TRC->CP_QUJE,"99999999.99")+"    | "+TRANS(TRC->B2_QATU,"99999999.99")+"    |   "+TRC->CP_ZMATFUN+"   | "
            li ++
            @ li,001 PSAY "|_______________________________________________________________________________________________________________________________________________________________________________________________________________|"
			li ++
			li ++
			DbSkip()
		EndDo
	
#ENDIF


//��������������������������������������������������������������Ŀ
//� Apaga arquivos temporarios                                   �
//����������������������������������������������������������������
dbSelectarea("TRC")
dbCloseArea()

//��������������������������������������������������������������Ŀ
//� Retorna ambiente original                                    �
//����������������������������������������������������������������
//dbSelectArea("SE1")
//dbSetOrder(_nSE1Ordem)
//��������������������������������������������������������������Ŀ
//� Apresenta relatorio na tela                                  �
//����������������������������������������������������������������
Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnRel)
EndIf
MS_FLUSH()
RETURN

#IFDEF TOP
	/*/
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������Ŀ��
	���Funcao    � CriaTmp  � Autor � Dirceu C. Castilho    � Data � 19.08.99 ���
	�������������������������������������������������������������������������Ĵ��
	���Descricao � Cria area temporaria em TopConnect ( Query )               ���
	�������������������������������������������������������������������������Ĵ��
	��� Uso      � RPZOVD                                                     ���
	�������������������������������������������������������������������������Ĵ��
	��� Revisao  �                                          � Data �          ���
	��������������������������������������������������������������������������ٱ�
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	/*/
	// Substituido pelo assistente de conversao do AP5 IDE em 25/03/02 ==> Function CriaTmp
	Static Function CriaTmp()
		cQuery := ''
		cQuery += " SELECT D3_FILIAL,D3_NUMSA,D3_ITEMSA,D3_EMISSAO,D3_COD,D3_UM,D3_TIPO,D3_LOCAL,D3_QUANT,D3_LOCALIZ,D3_GRUPO,NNR_DESCRI,CP_CODSOLI,CP_QUJE,CP_DESCRI,CP_ZMATFUN,CP_CODSOLI,USR_NOME,B2_QATU "
		cQuery += " FROM "+RetSQLName("SD3")+" " 
		cQuery += " LEFT OUTER JOIN "+RetSQLName("NNR")+" ON NNR_CODIGO=D3_LOCAL AND NNR010.D_E_L_E_T_=' ' "
		cQuery += " LEFT OUTER JOIN "+RetSQLName("SCP")+" ON CP_NUM=D3_NUMSA AND CP_ITEM=D3_ITEMSA AND SCP010.D_E_L_E_T_=' ' AND CP_FILIAL=D3_FILIAL "
		cQuery += " LEFT OUTER JOIN SYS_USR ON USR_ID = CP_CODSOLI "
		cQuery += " LEFT OUTER JOIN SB2010 ON B2_COD=D3_COD AND SB2010.D_E_L_E_T_=' ' AND B2_FILIAL=D3_FILIAL AND B2_LOCAL=D3_LOCAL "
		cQuery += " WHERE D3_DOC='"+SD3->D3_DOC+"' AND D3_FILIAL='"+SD3->D3_FILIAL+"' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRC", .F., .T.)
	Return
#ENDIF


#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAE27
Autor....:              Marcelo Carneiro         
Data.....:              21/06/2017 
Descricao / Objetivo:   Integração TAURA - Protheus
Doc. Origem:            MIT044- METODO CONSULTA Data de Fechamento
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WbeService Server Metodo ConsultaChaveNF
==========================================================================================================
*/

WSSTRUCT TAE27_CONSULTA
	WSDATA FILIAL        as String
	WSDATA CNPJ          as String
	WSDATA CODEXPORTACAO as String
	WSDATA NF 			 as String
	WSDATA SERIE  		 as String
    WSDATA TIPO  		 as String	
ENDWSSTRUCT

WSSTRUCT TAE27_RETORNO
	WSDATA CHAVE        		as String
ENDWSSTRUCT

WSSERVICE MGFTAE27 DESCRIPTION "Consulta Chave NF no Protheus" NameSpace "http://www.totvs.com.br/MGFTAE27"
	WSDATA WSCONSULTA as TAE27_CONSULTA
	WSDATA WSRETORNO  as TAE27_RETORNO

	WSMETHOD ConsultaChaveNF DESCRIPTION "Consulta Chave NF no Protheus"
ENDWSSERVICE

WSMETHOD ConsultaChaveNF  WSRECEIVE WSCONSULTA WSSEND WSRETORNO WSSERVICE MGFTAE27
     
Private cFilChave      := Alltrim(::WSCONSULTA:FILIAL)
Private cCNPJ          := Alltrim(::WSCONSULTA:CNPJ)
Private cCODEXPORTACAO := Alltrim(::WSCONSULTA:CODEXPORTACAO)
Private cNF 		   := Alltrim(::WSCONSULTA:NF)
Private cSERIE  	   := Alltrim(::WSCONSULTA:SERIE)
Private cTIPO  		   := Alltrim(::WSCONSULTA:TIPO)
Private cCHAVE 		   := ''

cCHAVE := TAE27_CON(cFilChave,cCNPJ,cCODEXPORTACAO,cNF,cSERIE,cTIPO)                       

::WSRETORNO := WSClassNew( "TAE27_RETORNO")
::WSRETORNO:CHAVE            := cCHAVE

Return .T.
**********************************************************************************************************************************************
Static Function TAE27_CON(cFilChave,cCNPJ,cCODEXPORTACAO,cNF,cSERIE,cTIPO)

Local cQuery  := ''
Private cChave 	 := ''         
            
dbSelectArea('SA2')
SA2->(dbSetOrder(1))            

dbSelectArea('SA1')
SA1->(dbSetOrder(1))            
                    
IF cTipo $ '1 2'
	IF TAE27_VALCNPJ(cTipo,cCODEXPORTACAO, cCNPJ )
		// Entrada , 2 Saida
		cQuery  := " SELECT F"+cTIPO+"_CHVNFE CHAVENFE"
		cQuery  += " FROM "+RetSqlName('SF'+cTIPO)
		cQuery  += " WHERE D_E_L_E_T_  = ' ' "
		cQuery  += "   AND F"+cTIPO+"_FILIAL = '"+cFilChave+"'"
		cQuery  += "   AND F"+cTIPO+"_DOC    = '"+cNF+"'"
		cQuery  += "   AND F"+cTIPO+"_SERIE  = '"+cSERIE+"'"
		IF cTipo == '1'
			cQuery  += "   AND F1_FORNECE = '"+SA2->A2_COD+"'"
			//cQuery  += "   AND F1_LOJA    = '"+SA2->A2_LOJA+"'"
		Else                                                   
			cQuery  += "   AND F2_CLIENTE = '"+SA1->A1_COD+"'"
			cQuery  += "   AND F2_LOJA    = '"+SA1->A1_LOJA+"'"
		EndIF                                        
		If Select("QRY_CHAVE") > 0
			QRY_CHAVE->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_CHAVE",.T.,.F.)
		dbSelectArea("QRY_CHAVE")
		QRY_CHAVE->(dbGoTop())
		IF QRY_CHAVE->(!EOF())                
		     cCHAVE := QRY_CHAVE->CHAVENFE
		EndIF
	EndIF
EndIF
Return cChave
**************************************************************************************************************************************************
Static Function TAE27_VALCNPJ(cTipo,cCODEXP, cCNPJ )
Local bRet   := .F.
Local cQuery := ''    
Local cTipoC := IIF(cTipo=='1','2','1')
                                                         

     
cQuery := " SELECT R_E_C_N_O_  RECFOR "
cQuery += " FROM "+RetSQLName("SA"+cTipoC)
cQuery += " WHERE D_E_L_E_T_ = ' ' "
IF !Empty(cCODEXP)
   cQuery += " AND A"+cTipoC+"_ZCODMGF = '"+Alltrim(cCODEXP)+"' "
Else
   cQuery += " AND A"+cTipoC+"_CGC = '"+Alltrim(cCNPJ)+"' "
EndIF

If Select("QRY_CNPJ") > 0
	QRY_CNPJ->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_CNPJ",.T.,.F.)
dbSelectArea("QRY_CNPJ")
QRY_CNPJ->(dbGoTop())
IF QRY_CNPJ->(!EOF())      
      IF cTipo == '1'
      	   SA2->(dbGoTo(QRY_CNPJ->RECFOR))
      Else 
           SA1->(dbGoTo(QRY_CNPJ->RECFOR))
      EndIF
      bRet   := .T.
EndIF
QRY_CNPJ->(dbCloseArea())                                  

Return bRet
*****************************************************************************************************************************
User Function Z_TAP27
Private cPermite := ''

RpcSetType(3)
RpcSetEnv( "01" , "010001" , Nil, Nil, "EST", Nil )
								
cPermite := TAE27_CON('010003','09165715000250', '','000001015', '100','1') 

msgAlert(cPermite)      

Return


#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAU02
Autor....:              Marcelo Carneiro         
Data.....:              09/03/2016 
Descricao / Objetivo:   TAURA - ZERA ZZE
Doc. Origem:            
Solicitante:            Totvs
Uso......:              Marfrig
Obs......:              Zera ZZE
==========================================================================================================
*/

User Function MGFTAU02        // U_MGFTAU02    
Local aStru     := {}
Local nField    := 0
Local nFields   := 0                      
Local cDados    := ''

Local cQuery  := ''
Local nI      := 0                                                   
Local aEMPTeste :={'010002',;  
                   '010001',;  
				   '010003',;
				   '010005',;
				   '010006',;
				   '010007',;
				   '010008',;
				   '010012',;
				   '010013',;
				   '010015'}

RpcSetType(3)
RpcSetEnv( "01" , "010001" , Nil, Nil, "EST", Nil )


cUpd := "Delete from ZINTPROD " + CRLF
IF (TcSQLExec(cUpd) < 0)
	MemoWrite("c:\temp\Erro"+StrTran(Time(),":","")+".txt",TcSQLError())
	Return
EndIF

//dbSelectArea('ZINTPROD')                                 

cQuery  := " SELECT R_E_C_N_O_ REC, ZZE_DESCER "
cQuery  += " FROM ZZE010"
cQuery  += " Where ZZE_STATUS='2'"
cQuery  += " AND D_E_L_E_T_=' ' "
cQuery  += " AND ZZE_EMISSA >= '20170801'"
If Select("QRY_CARGA") > 0
	QRY_CARGA->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_CARGA",.T.,.F.)
dbSelectArea("QRY_CARGA")
QRY_CARGA->(dbGoTop())
While QRY_CARGA->(!EOF())
	//Reclock("ZINTPROD",.T.)
	//ZINTPROD->RECNO    := QRY_CARGA->REC
	//ZINTPROD->ERRO     := SUBSTR(IIF( At(".LOG",Upper(AllTrim(QRY_CARGA->ZZE_DESCER))) > 0 , U_zLerTxt(AllTrim(QRY_CARGA->ZZE_DESCER)),AllTrim(QRY_CARGA->ZZE_DESCER)),1,254)
	//ZINTPROD->(MsUnlock())                                         
	nI++                                                   
	cUpd := "INSERT INTO ZINTPROD VALUES(" + CRLF
	cUpd += Alltrim(STR(QRY_CARGA->REC)) +' ,'
	cErro := SUBSTR(IIF( At(".LOG",Upper(AllTrim(QRY_CARGA->ZZE_DESCER))) > 0 , U_zLerTxt(AllTrim(QRY_CARGA->ZZE_DESCER)),AllTrim(QRY_CARGA->ZZE_DESCER)),1,254)
	IF Empty(cErro)
	     cErro := 'NA'
	EndIF
	cUpd += "'"+cErro+"', ' ',"+Alltrim(STR(nI))+",0)"
	IF (TcSQLExec(cUpd) < 0)
		MemoWrite("c:\temp\Erro"+StrTran(Time(),":","")+".txt",TcSQLError())
		Return
	EndIF
	
	QRY_CARGA->(dbSKIP())
END

Return
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch" 

#define CRLF chr(13) + chr(10)
/*
==========================================================================================================
Programa.:              MGFTAU01
Autor....:              Marcelo Carneiro         
Data.....:              10/03/2017 
Descricao / Objetivo:   TAURA - JOB DE CADASTROS
Doc. Origem:            
Solicitante:            Totvs
Uso......:              Marfrig
Obs......:              Programa para colocar no Schedule.
==========================================================================================================
*/

User Function MGFTAU01(xPar)

	Local cFaile	:= GetSrvProfString("Startpath","") +"MGFTAU01_"
	Local 	nHdFaile
	
	Private _aMatriz   := {"01","010001"}  
	Private _aEmpresa  := 	{}  
	Private lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"
	Private _cParInt	:= IIF(ValType(xPar)=="A",xPar[1],xPar)
	Private _cDesInt	:= ""
	
	If _cParInt == "1"
		_cDesInt :="CLiente" 
	ElseIf _cParInt == "2"
		_cDesInt := "Fornecedor" 
	ElseIf _cParInt == "3"
		_cDesInt := "Transportadora" 
	ElseIf _cParInt == "4"
		_cDesInt := "Produto" 
	Else
		_cDesInt := "Indeterminado"
	EndIf

	If !_cParInt $ "1234"
		Conout("JOB com par�metro incorreto ou n�o informado : MGFTAU01 - " + _cDesInt + " " + DTOC(Date()) + " - " + TIME() )
		Return
	EndIf
	
	cFaile += _cParInt + ".TXT"

	if lIsBlind
		RpcSetType(3)
		RpcSetEnv(_aMatriz[1],_aMatriz[2])     

/*
		If !LockByName("MGFTAU01")
			Conout("JOB j� em Execu��o : MGFTAU01 - " + _cDesInt + " " + DTOC(dDATABASE) + " - " + TIME() )
			RpcClearEnv() 
			Return
		EndIf
*/

		nHdFaile := fCreate( cFaile )

		If nHdFaile == -1
			Conout("JOB j� em Execu��o : MGFTAU01 - " + _cDesInt + " " + DTOC(dDATABASE) + " - " + TIME() )
			RpcClearEnv() 
			Return
		EndIf

		conOut("********************************************************************************************************************"+ CRLF)       
		conOut("********************************************************************************************************************")       
		conOut('---------------------- Inicio do processamento - MGFTAU01 - Rotinas de Cadastros - ' + DTOC(dDATABASE) + " - " + TIME()  )
		conOut("********************************************************************************************************************"+ CRLF)       

		If _cParInt == "1"
			conOut("********************************************************************************************************************")       
			conOut('Inicio do processamento - MGFTAC11 - Clientes ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)
			U_MGFTAC11() //
			conOut("********************************************************************************************************************")       
			conOut('Final do processamento - MGFTAC11 - Clientes ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)       

			conOut("********************************************************************************************************************")       
			conOut('Inicio do processamento - MGFWSC07 - Endere�o de Entrega ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)       
			U_MGFWSC07({"01", "010001"} )
			conOut("********************************************************************************************************************")       
			conOut('Final do processamento - MGFWSC07 - Endere�o de Entrega ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)       

		ElseIf _cParInt == "2"
			conOut("********************************************************************************************************************")       
			conOut('Inicio do processamento - MGFTAC01 - Fornecedor ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)       
			U_MGFTAC01() //
			conOut("********************************************************************************************************************")       
			conOut('Final do processamento - MGFTAC01 - Fornecedor ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)       

		ElseIf _cParInt == "3"
			conOut("********************************************************************************************************************")       
			conOut('Inicio do processamento - MGFTAC02 - Transportadora ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)       
			U_MGFTAC02() //
			conOut("********************************************************************************************************************")       
			conOut('Final do processamento - MGFTAC02 - Transportadora ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)       

			conOut("********************************************************************************************************************")       
			conOut('Inicio do processamento - MGFTAC08 - Ve�culo ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)       
			U_MGFTAC08() //
			conOut("********************************************************************************************************************")       
			conOut('Final do processamento - MGFTAC08 - Ve�culo ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)

			conOut("********************************************************************************************************************")       
			conOut('Inicio do processamento - MGFTAC06 - Motorista/Ajudante ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)       
			U_MGFTAC06() //
			conOut("********************************************************************************************************************")       
			conOut('Final do processamento - MGFTAC06 - Motorista/Ajudante ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)       

		ElseIf _cParInt == "4"
			conOut("********************************************************************************************************************")       
			conOut('Inicio do processamento - MGFTAC05 - Produto ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)       
			U_MGFTAC05() //
			conOut("********************************************************************************************************************")       
			conOut('Final do processamento - MGFTAC05 - Produto ' + DTOC(dDATABASE) + " - " + TIME()  )    
			conOut("********************************************************************************************************************"+ CRLF)
		EndIf       

		Fclose( nHdFaile )

	EndIf   

Return

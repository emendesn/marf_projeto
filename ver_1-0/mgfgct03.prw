#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'
#include "fwmvcdef.ch"

/*
=====================================================================================
Programa.:              MGFGCT03
Autor....:              Luis Artuso
Data.....:              27/09/2016
Descricao / Objetivo:   Execucao do Ponto de Entrada CNTA300
Doc. Origem:            Contrato - GAP MGFGCT03
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function MGFGCT03

	Local aParam	:= {}
	Local cIdPonto	:= ""
	Local xRet
	local oModel
	local oMdlCN9
    local cont :=0
    local cnum :=""
    local cfil :=cfilant
        
	aParam		:= PARAMIXB

	cIdPonto	:= aParam[2]

	If ( cIdPonto == 'BUTTONBAR' )

		xRet := { {'Desconto Personalizado', 'Salvar', { || u_fQrySZR() }, 'Conceder desconto personalizado.' } }

	Else

		xRet	:= .T.

	EndIf

    
IF INCLUI	
	if ( cIdPonto == "FORMPOS" ) //.and. oModel:cId == "CN9MASTER"

	 oModel 		:= FWModelActive()
	 oMdlCN9		:= oModel:GetModel("CN9MASTER")

         IF PARAMIXB[3] == "CN9MASTER"
        	// S� GRAVA NA FILIAL MATRIZ
       			CFILANT := SUBSTR(CFIL,1,2)+"0001"

        	CNUM := CN300NUM()             

			oMdlCN9:LoadValue("CN9_NUMERO"	, CNUM )
    
         ENDIF
	//elseif cIdPonto == "MODELCOMMITNTTS"
    //  MSGALERT("AQUI1"+CFILANT)
	endif
ENDIF    

Return xRet
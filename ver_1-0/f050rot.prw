#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: FA050ROT
Autor...............: Marcelo Carneiro
Data................: 07/03/2018
Descrição / Objetivo: O ponto de entrada para chamada da função no menu principal
Doc. Origem.........: Tipo de Valor - CAP
Solicitante.........: Cliente
Uso.................: Marfrig
=====================================================================================
*/
User Function F050ROT           	                    
Local aRotina := ParamIxb

aAdd( aRotina, { "Tipo de Valor", "U_MGFFIN88(.F.)"	, 0, 8,, .F. } )
aAdd( aRotina, { "Log Aprovacao", "U_xMC8750M"		, 0, 8,, .F. } )

If GetNewPar('MGF_F050' , .F.) 
    aAdd( aRotina, { "Capa Cap - Contas à Pagar", "U_MGF06R32"	, 0, 8,, .F. } )
EndIf 

Return aRotina                                        


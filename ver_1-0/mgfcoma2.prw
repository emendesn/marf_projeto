#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


/*
=====================================================================================
Programa............: MGFCOMA2
Autor...............: Tarcisio Galeano
Data................: 10/2018
Descrição / Objetivo: Tratamento desconto pedido de compras
Doc. Origem.........:
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
user function MGFCOMA2()

 Local nPrunit := GDFieldGet("C7_PRECO") 
 Local nProrig := GDFieldGet("C7_ZPRCORI")

		//Calcula Nova Valor
		//nNewVal	:= Round(aCols[ni, nPosValUn] - ( ( nValDes / 100 ) * aCols[ni, nPosValUn]), TamSX3("C7_PRECO")[2])
 // verifica se ja tem desconto por valor
 If Empty( GDFieldGet("C7_ZVLDESC" ))
 

		nPrunit	:= Round( GDFieldGet("C7_ZPRCORI") - ( ( GDFieldGet("C7_ZDESC") / 100 ) * GDFieldGet("C7_ZPRCORI") ) , TamSX3("C7_PRECO")[2])
		nProrig	:= GDFieldGet("C7_ZPRCORI") 

		If MaFisFound("IT",N)
			MaFisRef("IT_PRCUNI","MT120",nPrunit)
			If ExistTrigger("C7_PRECO")
				RunTrigger(2,N)
			EndIf
		EndIf


		GdFieldPut( "C7_ZPRCORI" , nProrig) 
 Else
      msgalert("Ja existe desconto por valor, favor verificar ")
 
 Endif    
   // RestArea(aArea)

Return nPrunit 


/*
=====================================================================================
Programa............: MGFCOMA2
Autor...............: Tarcisio Galeano
Data................: 10/2018
Descrição / Objetivo: Tratamento desconto pedido de compras
Uso.................: Marfrig
=====================================================================================
*/

user function MGFCA2()

 Local nPrunit := GDFieldGet("C7_PRECO") 
 Local nProrig := GDFieldGet("C7_ZPRCORI") 

 // verifica se ja tem desconto por %
 If Empty( GDFieldGet("C7_ZDESC" ))

		//Calcula Nova Valor
		//nNewVal	:= Round(aCols[ni, nPosValUn] - ( ( nValDes / 100 ) * aCols[ni, nPosValUn]), TamSX3("C7_PRECO")[2])
		nPrunit	:= Round( GDFieldGet("C7_ZPRCORI") -  GDFieldGet("C7_ZVLDESC")  , TamSX3("C7_PRECO")[2])
		nProrig	:= GDFieldGet("C7_ZPRCORI") 

		If MaFisFound("IT",N)
			MaFisRef("IT_PRCUNI","MT120",nPrunit)
			If ExistTrigger("C7_PRECO")
				RunTrigger(2,N)
			EndIf
		EndIf


		GdFieldPut( "C7_ZPRCORI" , nProrig) 
     
 Else
      msgalert("Ja existe desconto por %, favor verificar ")
 
 Endif    


Return nPrunit                     



/*
=====================================================================================
Programa............: MGFCOTA2
Autor...............: Tarcisio Galeano
Data................: 10/2018
Descrição / Objetivo: Tratamento desconto cotação
Uso.................: Marfrig
=====================================================================================
*/

user function MGFCOTA2()

 	Local nPrunit := GDFieldGet("C8_PRECO") 
 	Local nProrig := GDFieldGet("C8_ZPRCORI")
	Local nPosPreco	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C8_PRECO' })
	Local nPosTotal	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C8_TOTAL' })
	Local nPosQuant	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C8_QUANT' })

		//Calcula Nova Valor
		//nNewVal	:= Round(aCols[ni, nPosValUn] - ( ( nValDes / 100 ) * aCols[ni, nPosValUn]), TamSX3("C7_PRECO")[2])
 // verifica se ja tem desconto por valor
 If Empty( GDFieldGet("C8_ZVLDESC" ))
 

		nPrunit	:= Round( GDFieldGet("C8_ZPRCORI") - ( ( GDFieldGet("C8_ZDESC") / 100 ) * GDFieldGet("C8_ZPRCORI") ) , TamSX3("C8_PRECO")[2])
		nProrig	:= GDFieldGet("C8_ZPRCORI") 

		aCols[n][nPosPreco]:= nPrunit

		If MaFisFound("IT",N)
			MaFisRef("IT_PRCUNI","MT150",nPrunit)
		EndIf

		If Abs(aCols[n][nPosTotal]-NoRound(aCols[n][nPosPreco]*aCols[n][nPosQuant],TamSx3("C8_TOTAL")[2]))<>0.09
			aCols[n][nPosTotal] := NoRound(aCols[n][nPosPreco]*aCols[n][nPosQuant],TamSx3("C8_TOTAL")[2])
			If MaFisFound("IT",n)
				MaFisRef("IT_VALMERC","MT150",aCols[n][nPosTotal])
			EndIf
		EndIf	

			If ExistTrigger("C8_PRECO")
				RunTrigger(2,N)
			EndIf


		GdFieldPut( "C8_ZPRCORI" , nProrig) 
 Else
      msgalert("Ja existe desconto por valor, favor verificar ")
 
 Endif    
   // RestArea(aArea)

Return nPrunit 


/*
=====================================================================================
Programa............: MGFCOA2
Autor...............: Tarcisio Galeano
Data................: 10/2018
Descrição / Objetivo: Tratamento desconto cotação
Uso.................: Marfrig
=====================================================================================
*/
user function MGFCOA2()

 Local nPrunit := GDFieldGet("C8_PRECO") 
 Local nProrig := GDFieldGet("C8_ZPRCORI") 
 Local nPosPreco	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C8_PRECO' })
 Local nPosTotal	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C8_TOTAL' })
 Local nPosQuant	:= aScan(aHeader, {|x| allTrim(x[2]) == 'C8_QUANT' })

 // verifica se ja tem desconto por %     
 If Empty( GDFieldGet("C8_ZDESC" ))

		nPrunit	:= Round( GDFieldGet("C8_ZPRCORI") -  GDFieldGet("C8_ZVLDESC")  , TamSX3("C8_PRECO")[2])
		nProrig	:= GDFieldGet("C8_ZPRCORI") 

		aCols[n][nPosPreco]:= nPrunit

		If MaFisFound("IT",N)
			MaFisRef("IT_PRCUNI","MT150",nPrunit)
		EndIf

		If Abs(aCols[n][nPosTotal]-NoRound(aCols[n][nPosPreco]*aCols[n][nPosQuant],TamSx3("C8_TOTAL")[2]))<>0.09
			aCols[n][nPosTotal] := NoRound(aCols[n][nPosPreco]*aCols[n][nPosQuant],TamSx3("C8_TOTAL")[2])
			If MaFisFound("IT",n)
				MaFisRef("IT_VALMERC","MT150",aCols[n][nPosTotal])
			EndIf
		EndIf	

			If ExistTrigger("C8_PRECO")
				RunTrigger(2,N)
			EndIf


		GdFieldPut( "C8_ZPRCORI" , nProrig) 
     
 Else
      msgalert("Ja existe desconto por %, favor verificar ")
 
 Endif    


Return nPrunit

/*
=====================================================================================
Programa............: MGFCOA2
Autor...............: Tarcisio Galeano
Data................: 10/2018
Descrição / Objetivo: gatilho para desconto cotação
Uso.................: Marfrig
=====================================================================================
*/
user function MGFCOTAG()

 Local nPrunit := GDFieldGet("C8_PRECO") 
 Local nDesc   := GDFieldGet("C8_ZDESC") 
 Local nDescv  := GDFieldGet("C8_ZVLDESC") 

 // verifica se ja tem desconto por %     

 
 If Empty( GDFieldGet("C8_ZDESC" ))

		nProrig	:= (nPrunit / nDesc) *100  

 Endif    

 If Empty( GDFieldGet("C8_ZVLDESC" ))

		nProrig	:= nPrunit + nDescv  

 Endif    

		GdFieldPut( "C8_ZPRCORI" , nProrig) 


Return nProrig 



/*
=====================================================================================
Programa............: MGFCOA2
Autor...............: Tarcisio Galeano
Data................: 10/2018
Descrição / Objetivo: gatilho para desconto cotação
Uso.................: Marfrig
=====================================================================================
*/
user function MGFCOAG()

 Local nPrunit := GDFieldGet("C7_PRECO") 
 Local nDesc   := GDFieldGet("C7_ZDESC") 
 Local nDescv  := GDFieldGet("C7_ZVLDESC") 

 // verifica se ja tem desconto por %     

 
 If Empty( GDFieldGet("C7_ZDESC" ))

		nProrig	:= (nPrunit / nDesc) *100  

 Endif    

 If Empty( GDFieldGet("C7_ZVLDESC" ))

		nProrig	:= nPrunit + nDescv  

 Endif    

		GdFieldPut( "C7_ZPRCORI" , nProrig) 


Return nProrig

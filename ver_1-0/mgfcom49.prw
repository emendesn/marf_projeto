#INCLUDE "rwmake.ch"
/*
============================================================================================================================
Programa.:              MGFCOM49 
Autor....:              Antonio Carlos        
Data.....:              16/10/2017                                                                                                            
Descricao / Objetivo:   Implementa��o do Ponto de Entrada MT120TEL que ser� utilizado para incluir campo Obs no aHeder do PC
Doc. Origem:            Compras - GAP ID068
Solicitante:            Cliente 
Uso......:              Marfrig
Obs......:              Manutencao Cadastro de Observa��es Espec�ficas do PC
============================================================================================================================
*/  
User Function MGFCOM49()
Private cString := "ZAO"

dbSelectArea("ZAO")

AxCadastro(cString,"Manutencao Cadastro de Observa��es")

Return
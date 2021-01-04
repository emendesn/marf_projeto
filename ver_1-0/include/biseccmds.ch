// ############################################################################################
// Projeto: BI-SEC - Módulo de Segurança BI
// Modulo : Include
// Fonte  : biSecCmds.ch
// ---------+-------------------------+--------------------------------------------------------
// Data     | Autor                   | Descricao
// ---------+-------------------------+--------------------------------------------------------
// 17.08.09 | 0000 - BI TEAM             | FNC 00000017644/2009
// -----------------------------------+--------------------------------------------------------

#ifndef _BISEC_CMDS_CH
#define _BISEC_CMDS_CH

// **************************************************************************************
// Comandos para definição de módulos de acesso
// **************************************************************************************

#command DEFINE SECURITY NAME <MODULE> DESCRIPTION <DESCR>;
  => function biSec<module>() ;;
        local cIdModule := biSecDMod( <"MODULE">, <DESCR> ) ;;
        local lOk := !Empty( cIdModule ) ;;
        local cIdProc := "" ;;
        local cIdOper := ""
        
#command ADD PROCESS NAME <process> DESCRIPTION <descr> [PARENT <parentProcess>];
  => if lOk ;;
        cIdProc := biSecDProc( cIdModule, <"PROCESS">, <DESCR> [, <"PARENTPROCESS">] ) ;;
        lOk := !Empty( cIdProc ) ;;
     endif

#command ADD OPERATION NAME <operation> DESCRIPTION <descr> [OPTIONS <option,...>];
  => if lOk ;;
        cIdOper := biSecDOper( cIdProc, <"OPERATION">, <DESCR> [, {<"option">}] ) ;;
        lOk := !Empty( cIdOper ) ;;
     endif

#command END SECURITY;
  => return lOk

#command ISAUTHORIZED <cProcessName> OPERATION <cOperationName> [OPTION <cOptionName>] [ONLY SUPER ADMIN];
  => 

#endif

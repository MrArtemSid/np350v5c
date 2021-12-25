// OS Version Detection - Rev 1.0
// Copyright (c) 1996-2010 Synaptics Incorporated. All rights reserved.
//
// This OS detection is targeted only to Windows systems from Win2K up
//

var eCurrentOS = {eosUnknown:0, eosWinNT4:1, eosWin2K:2, eosWinXP:3, eosWinXP64:4, 
  eosWinVista:5, eosWin7:6, eosWinNew:7};

function GetOSVersion()
{
  var	OS;
  var eOSType;

  OS = navigator.userAgent;
// Default is newer version of Windows OS, higher than 7.0 (Windows 7), since cannot be < Win2K
  eOSType = eCurrentOS.eosWinNew;  
  if ((OS.indexOf("Windows NT 5.1")!=-1) || (OS.indexOf("Windows XP")!=-1)) {
    eOSType = eCurrentOS.eosWinXP;
      }
  else if ((OS.indexOf("Windows NT 7.0")!=-1) || (OS.indexOf("Windows NT 6.1")!=-1)) {
    eOSType = eCurrentOS.eosWin7;
  }
  else if ((OS.indexOf("Windows NT 6.0")!=-1)) {
    eOSType = eCurrentOS.eosWinVista;
  }
  else if ((OS.indexOf("Windows NT 4.0")!=-1) || (OS.indexOf("WinNT4.0")!=-1) 
    || (OS.indexOf("WinNT")!=-1)) {
    eOSType = eCurrentOS.eosWinNT4;
  }
  else if ((OS.indexOf("Windows NT 5.2")!=-1) || (OS.indexOf("x64")!=-1)) {
    eOSType = eCurrentOS.eosWinXP64;
  }
  else if ((OS.indexOf("Windows NT 5.0")!=-1) || (OS.indexOf("Windows 2000")!=-1)) {
    eOSType = eCurrentOS.eosWin2K;
  }
  return eOSType;
}


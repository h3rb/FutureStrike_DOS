Unit FSInit;




Interface




Uses FSBasics, SPX_ES, SPX_VGA, DacPal;



Procedure InitPal;
  { Loads the palette and sets it}



Implementation


Procedure LoadPics( Var P : PicType; Fn : String );
Var X, Y, Z : Integer;
Begin
 P.Size.X := 0;
 P.Size.Y := 0;
 For X := 0 to 35 do P.Pic[x] := Nil;
 StackLoadVSP( VspPath + Fn, P.Pic, EMSGlobalMem, FALSE );
 P.Maxfrm := VSPCnt - 1;
 If VSPCnt = 0 Then Halt(9);
 For Z := 0 to P.Maxfrm do
  Begin
   ImageDims( VP(P.Pic[z])^, X, Y );
   If ( X * Y ) > ( P.Size.X * P.Size.Y ) then
    Begin
     P.Size.X := X;
     P.Size.Y := Y;
    End;
  End;
 P.Size.X := P.Size.X div 2;
 P.Size.Y := P.Size.Y div 2;
 P.OnScrn.X := 120 + P.Size.X;
 P.OnScrn.Y := 100 + P.Size.Y;
End;


Procedure InitShip;
Var
  X : Byte;
Begin
  Write(' þ Ships', Chr(13));
  For X := 1 to NumShipPics do LoadPics( Ship[x], ShipFiles[x] );
  Writeln(' x');
End;



Procedure InitPlanet;
Var
  X : Byte;
Begin
  Write(' þ Planets', Chr(13));
  For X := 1 to NumPlanetPics do LoadPics( Planet[x], PlanetFiles[x] );
  Writeln(' x');
End;



Procedure InitShot;
Var
  X : Byte;
Begin
  Write(' þ Shots', Chr(13));
  For X := 1 to NumShotPics do LoadPics( Shot[x], ShotFiles[x] );
  Writeln(' x');
End;



Procedure InitStatic;
Var
  X : Byte;
Begin
  Write(' þ Statics', Chr(13));
  For X := 1 to NumStaticPics do LoadPics( Static[x], StaticFiles[x] );
  Writeln(' x');
End;



Procedure InitMine;
Var
  X : Byte;
Begin
  Write(' þ Mines', Chr(13));
{  For X := 1 to NumMinePics do LoadPics( Mine[x], MineFiles[x] );}
  Writeln(' x');
End;



Procedure InitDebris;
Var
  X : Byte;
Begin
  Write(' þ Debris', Chr(13));
  For X := 1 to NumDebrisPics do LoadPics( Debris[x], DebrisFiles[x] );
  Writeln(' x');
End;



Procedure InitPal;
Var
  Pal : RGBList;
Begin
  LoadColors(UsePal, Pal, 256);
  FSetColors(Pal);
End;


Procedure GetCLParams;
Var X : Integer;
  TempStr : String;
Begin
  Map := True;
  Menu := False;
  For X := 1 to ParamCount do
    Begin
      TempStr := ParamStr(X);
      Case TempStr[2] of
        'M', 'm' : If TempStr[3] = '+' then Menu := True;
        'S', 's' : If TempStr[3] = '-' then Map := False;
      End;
    End;
End;



Procedure InitPlayerInfo;
Begin
  New(PlayerInfo);
  PlayerInfo^.Next := Nil;
  PlayerInfo^.D := DefaultObj;
  With PlayerInfo^.D do
    Begin
      CL.X := 0; CL.Y := 0;
      L.X := 0; L.Y := 0;
      RL.X := 0; RL.Y := 0;
      Dir := 0;
      PicSet := 3;
      HP := 15;
      ID := ShipID;
      Acc := 16;
      Time := 0;
    End;
End;



Procedure InitVars;
Begin
  WinMinX := 0;
  WinMinY := 0;
  WinMaxX := MaxX;
  WinMaxY := MaxY;
End;



Procedure InitDebugVars;
Begin
  QueryIdent := False;
  Map := True;
  Menu := False;
  Stop := False;
  Pause := False;
  TargetOn := False;
  MarkerOn := False;
End;



Begin
  GetCLParams;
  WriteLn('þ Initializing Sprites');
  InitShip;
  InitPlanet;
  InitShot;
  InitStatic;
  InitMine;
  InitDebris;
  InitPlayerInfo;
  InitVars;
  FadeStepsEGA64(DosPal, Black, 24);
End.

Program FutureStrike;


{version 2.0.1}


Uses FSBasics, FSInit, FSFunx, FSMap, FSMove, FSGraph, FSFrame, SPX_VGA, SPX_IMG,
     SPX_KEY, SPX_ES;



Procedure TempAddRandomPlanets(Num : Byte);
Var
  X : Byte;
  TempInfo : ObjInfoType;
Begin
  TempInfo := DefaultObj;
  For X := 1 to Num do
    Begin
      TempInfo.RL.X := Random(32000) - 16000;
      TempInfo.RL.Y := Random(32000) - 16000;
      TempInfo.PicSet := 1;
      TempInfo.MoveType := 6;
      TempInfo.ID := PlanetID;
      TempInfo.Dir := 0;
      CreateObj(TempInfo, PlanetHead, NumPlanet);
    End;
End;


Procedure TempAddRandomShips(Num : Byte);
Var
  X : Byte;
  TempInfo : ObjInfoType;
Begin
  TempInfo := DefaultObj;
  For X := 1 to Num do
    Begin
      If Random(2) = 1 then TempInfo.MoveType := 4 else
        TempInfo.MoveType := 1;
      TempInfo.RL.X := Random(32000) - 16000;
			TempInfo.RL.Y := Random(32000) - 16000;
      TempInfo.CL.X := 0;
			TempInfo.CL.Y := 0;
      TempInfo.ID := ShipID;
{      TempInfo.Dir := Random(36);
      TempInfo.HP := DefaultObj.HP;
      TempInfo.PicSet := Random(NumShipPics) + 1;
      If TempInfo.PicSet = NumShipPics Then TempInfo.HP := 100;}
      CreateObj(TempInfo, ShipHead, NumShip);
    End;
End;



Procedure Init;
Begin
 OpenMode(3);
 SetPageActive(2); {hahaha}
 LoadPCX(BackPCX);
 InitPal;
 FPCopy(Pages[2]^, Pages[3]^);
 FPCopy(Pages[3]^, Pages[1]^);
 Randomize;
 TempAddRandomPlanets(1);
 TempAddRandomShips(20);
End;



Begin
  Init;
  Repeat
    GetKeys(PlayerInfo^.D);
    RefreshBG;
    DoPlanetStuff;
    DoMineStuff;
    DoDebrisStuff;
    DoShotStuff;
    DoShipStuff;
    DrawPlayerShip(PlayerInfo^.D, Ship[PlayerInfo^.D.PicSet]);
    DoStaticStuff;
    CopyRect(0, 0, 239, 199, Pages[2]^, Pages[1]^);
    ShowMap;
    EraseMap;
  Until Esc;
End.
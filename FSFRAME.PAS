Unit FSFrame;



Interface



Uses FSBasics, FSFunx, FSMove, FSMap, FSGraph, SPX_FNC;



Procedure DoPlanetStuff;
Procedure DoShipStuff;
Procedure DoShotStuff;
Procedure DoStaticStuff;
Procedure DoMineStuff;
Procedure DoDebrisStuff;


Implementation



Procedure DoPlanetStuff;
Begin
  Cur1 := PlanetHead;
  While Cur1 <> Nil do
    Begin
      PutMap(Cur1^.D, 140);                           {put on scanner   }
      DrawObj(Cur1^.D, Planet[Cur1^.D.PicSet]);       {put on viewscreen}
      MoveType[Cur1^.D.MoveType](Cur1);               {move             }
    End;
End;


Procedure DoShipStuff;
Begin
  Cur1 := ShipHead;
	While Cur1 <> Nil do
		Begin
      PutMap(Cur1^.D, 39);                            {put on scanner   }
  		DrawObj(Cur1^.D, Ship[Cur1^.D.PicSet]);         {put on viewscreen}
 	   	Cur2 := ShotHead;
      While Cur2 <> Nil do {check if hit by a shot}
  			If ObjInBox(Cur2^.D, Cur1^.D, Ship[Cur1^.D.PicSet]) Then {if hit }
  	  	  Begin
            Inc(Cur1^.D.CL.X, SAR(Cur2^.D.CL.X, 4));{recoil effect of getting hit}
            Inc(Cur1^.D.CL.Y, SAR(Cur2^.D.CL.Y, 4));
            Cur2^.D.ID := StaticID;                 {change shot to explosion}
            Cur2^.D.MoveType := 3;
            Cur2^.D.Dir := 0;
            Cur2^.D.Time := 7;
  		 		  MoveObj(Cur2, ShotHead, StaticHead, NumShot, NumStatic);
  	    		Dec(Cur1^.D.HP);                        {change hit points}
		    	End
 				Else
					Cur2 := Cur2^.Next;
      MoveType[Cur1^.D.MoveType](Cur1);             {move             }
    End;
End;


Procedure DoShotStuff;
Begin
	Cur1 := ShotHead;
  While Cur1 <> Nil do
    Begin
      DrawObj(Cur1^.D, Shot[Cur1^.D.PicSet]);
      MoveType[Cur1^.D.MoveType](Cur1);
    End;
End;


Procedure DoStaticStuff;
Begin
	Cur1 := StaticHead;
  While Cur1 <> Nil do
    Begin
      DrawObj(Cur1^.D, Static[Cur1^.D.PicSet]);
      MoveType[Cur1^.D.MoveType](Cur1);
    End;
End;


Procedure DoMineStuff;
Begin
	Cur1 := MineHead;
  While Cur1 <> Nil do
    Begin
      DrawObj(Cur1^.D, Mine[Cur1^.D.PicSet]);
{     MoveType[Cur1^.D.MoveType](Cur1, PlayerInfo^.D);}
      Cur1 := Cur1^.Next;
    End;
End;


Procedure DoDebrisStuff;
Begin
	Cur1 := DebrisHead;
  While Cur1 <> Nil do
    Begin
      DrawObj(Cur1^.D, Debris[Cur1^.D.PicSet]);
      MoveType[Cur1^.D.MoveType](Cur1);
    End;
End;


End.
Unit FSMove;


{
Contains Object Movement Procedures
}






Interface






Uses SPX_Key, FSBasics, FSFunx, SPX_FNC;






Procedure Accelerate(Var S : ObjInfoType);
  {Accelerates Obj S in current direction at current acc w/ a limiting speed}

Procedure AccelerateWOLimit(Var S : ObjInfoType);
  {Accelerates Obj S in current direction at current acc w/o a limiting speed}

Procedure Decelerate(Var S : ObjInfoType);
  {Decelerates Obj S in current direction at current acc w/ a limiting speed}

Procedure DecelerateWOLimit(Var S : ObjInfoType);
  {Decelerates Obj S in current direction at current acc w/o a limiting speed}

{Procedure MovePlayer(Var D : ObjInfoType);
  {Moves the player on the big map}

Procedure MoveGuy(Var P : PObj);
  {Moves guy one frame according to current speed - checks HPs}

{Procedure MoveShotNAdvance(Var P : PObj; D : ObjInfoType);
  {Moves shot one frame according to current direction - checks time limit}

Procedure MovePlanet(Var P : PObj);
  {Moves planet so that it remains stationary}

{Procedure MoveStarbase(Var P : PObj; D : ObjInfoType);
  {Moves starbase so that it remains stationery, and rotates}

Procedure MoveStatic(Var P : PObj);
  {Moves Explosion so that it remains stationary - checks time limit}

Procedure MoveDebris(Var P : PObj);
  {Moves Debris}

{Procedure MoveShipExp(Var P : PObj; D : ObjInfoType);
  {Moves Explosion so that it remains stationary - checks time limit}


Procedure Drift(Var P : PObj);
  {Drifting Procedure}


Procedure MoveShot(Var P : PObj);
  {Shot Move Procedure}


Procedure GetKeys(Var S : ObjInfoType);
  {Gets User Input and modifies appropriate player info}


Procedure PutRandomDebris(Num : Byte; Var O : ObjInfoType);
  {Puts Random Debris at O.RL.X, O.RL.Y}



Const
  MoveType : Array[1..6] of MoveProcType =
{            (MoveGuy,
             MoveShotNAdvance,
             MovePlanet,
             MoveShotExp,
             MoveShipExp,
             MoveStarbase,}
             (Drift, MoveShot, MoveStatic, MoveGuy, MoveDebris, MovePlanet);





Implementation






Procedure RoundClipSpeed(Var C : IntCoordType);
Const
  MaxSpeed = 164 * 64;
  SpeedLimit = 164;
Var
  R : Integer;
  D : LongInt;
Begin
  R := Dist(0, 0, C.X, C.Y);
  If R > SpeedLimit Then
    Begin
      D := MaxSpeed div R;
      C.X := SAR(C.X * D, 6);
      C.Y := SAR(C.Y * D, 6);
    End;
End;


Procedure SquareClipSpeed(Var C : IntCoordType);
Const
  MaxSpeed = 144;
  MinSpeed = -144;
Begin
  IFix(C.X, MinSpeed, MaxSpeed);
  IFix(C.Y, MinSpeed, MaxSpeed);
End;


Procedure Accelerate(Var S : ObjInfoType);
Begin
  With S do
     Begin
       Inc(CL.X, SAR(TableMove[Dir].X * Acc, 4));
			 Dec(CL.Y, SAR(TableMove[Dir].Y * Acc, 4));
			 SquareClipSpeed(CL);
		 End;
End;


Procedure AccelerateWOLimit(Var S : ObjInfoType);
Begin
   With S do
		 Begin
			 Inc(CL.X, SAR(TableMove[Dir].X * Acc, 4));
			 Dec(CL.Y, SAR(TableMove[Dir].Y * Acc, 4));
     End;
End;


Procedure Decelerate(Var S : ObjInfoType);
Begin
   With S do
     Begin
			 Dec(CL.X, SAR(TableMove[Dir].X * Acc, 4));
			 Inc(CL.Y, SAR(TableMove[Dir].Y * Acc, 4));
			 SquareClipSpeed(CL);
		 End;
End;


Procedure DecelerateWOLimit(Var S : ObjInfoType);
Begin
   With S do
		 Begin
			 Dec(CL.X, SAR(TableMove[Dir].X * Acc, 4));
			 Inc(CL.Y, SAR(TableMove[Dir].Y * Acc, 4));
     End;
End;


Procedure Brake(Var S : ObjInfoType);
Begin
	If (S.CL.X > 0) Then
		Begin
			If (S.CL.X > S.Acc) Then Dec(S.CL.X, S.Acc)
			Else S.CL.X := 0;
		End
	Else If (S.CL.X < 0) Then
		Begin
			If (S.CL.X < S.Acc) Then Inc(S.CL.X, S.Acc)
			Else S.CL.X := 0;
		End;
	If (S.CL.Y > 0) Then
		Begin
			If (S.CL.Y > S.Acc) Then Dec(S.CL.Y, S.Acc)
			Else S.CL.Y := 0;
		End
	Else If (S.CL.Y < 0) Then
		Begin
			If (S.CL.Y < S.Acc) Then Inc(S.CL.Y, S.Acc)
			Else S.CL.Y := 0;
		End;
End;


Function Aim(Var S, T : ObjInfoType) : ShortInt;
Var
  TX, TY : LongInt;
  D : ShortInt;
Begin
  TX := S.RL.X - T.RL.X;
  TY := S.RL.Y - T.RL.Y;
  If TY = 0 Then
    D := 9
  Else
    D := AT(TX, TY);
  If TY > 0 Then Inc(D, 9)
    Else
      If TY < 0 Then Inc(D, 27);
  D := D Mod 36;
  Aim := D;
End;


Procedure TurnTowards(Var S : ObjInfoType; D : ShortInt);
Var
  T : Integer;
Begin
  If S.Dir <> D Then
    Begin
      T := (D - S.Dir + 36) mod 36;
      If T > 18 then
        Dec( S.Dir )
      else
        Inc( S.Dir );
      If S.Dir < 0 then Inc(S.Dir,36) else S.Dir := S.Dir MOD 36;
    End;
End;


Procedure Momentum(Var O : ObjInfoType);
Begin
  Inc(O.RL.X, O.CL.X);
  Inc(O.RL.Y, O.CL.Y);
End;


Procedure TransformCoords(Var O : ObjInfoType);
Begin
	O.L.X := SAR(O.RL.X - Camera.X, 4);
	O.L.Y := SAR(O.RL.Y - Camera.Y, 4);
End;


Procedure PutRandomDebris(Num : Byte; Var O : ObjInfoType);
Var
  TempInfo : ObjInfoType;
  X : Byte;
Begin
  TempInfo := DefaultObj;
  TempInfo.RL := O.RL;
  TempInfo.L := O.L;
  TempInfo.MoveType := 5;
  TempInfo.ID := DebrisID;
  For X := 1 to Num do
    Begin
      TempInfo.CL.X := SAR(O.CL.X, 2);
      TempInfo.CL.Y := SAR(O.CL.Y, 2);
      TempInfo.PicSet := Random(NumDebrisPics) + 1;
      TempInfo.Dir := Random(36);
      TempInfo.Acc := Random(32);
      Accelerate(TempInfo);
      TempInfo.Dir := Random(Debris[TempInfo.PicSet].MaxFrm + 1);
      CreateObj(TempInfo, DebrisHead, NumDebris);
    End;
End;


Procedure Drift(Var P : PObj);
Begin
  TransformCoords(P^.D);
  If Not Stop then Begin
    Momentum(P^.D);
    Inc(P^.D.Dir);
    If P^.D.Dir >= 36 then Dec(P^.D.Dir, 36);
  End;
{	If P^.D.HP < 1 Then
		Begin
      P^.D.ID := ExpID;
      MoveObj(P, StartGuy, StartMisc, NumGuys, NumMiscs);
      StartMisc^.D.MoveType := 5;
      StartMisc^.D.Dir := 0;
      StartMisc^.D.PicSet := 2;  {Ship Explosion, not Shot Explosion!
		End;}
  P := P^.Next;
End;



Procedure MoveShot(Var P : PObj);
Begin
  With P^ do
    Begin
      If Not Stop Then Begin
        Momentum(D);
        Inc(D.Dir);
        If (D.Dir > Shot[D.PicSet].MaxFrm) then Dec(D.Dir, Shot[D.PicSet].MaxFrm);
      	Dec(D.Time);
      End;
      TransformCoords(D);
    End;
 	If P^.D.Time = 0 Then
 		MoveObj(P, ShotHead, FreeHead, NumShot, NumFree)
  Else
    P := P^.Next;
End;


Procedure MoveStatic(Var P : PObj);
Begin
  With P^ do
    Begin
      If Not Stop Then Begin
      	Inc(D.Dir);
        If (D.Dir > Static[D.PicSet].MaxFrm) then Dec(D.Dir, Static[D.PicSet].MaxFrm);
        Dec(D.Time);
      End;
      TransformCoords(D);
    End;
  If P^.D.Time = 0 Then
		MoveObj(P, StaticHead, FreeHead, NumStatic, NumFree)
	Else
		P := P^.Next;
End;


Procedure MoveDebris(Var P : PObj);
Begin
  With P^ do
    Begin
      If Not Stop then Begin
        Momentum(D);
        Inc(D.Dir);
        If (D.Dir > Debris[D.PicSet].MaxFrm) then Dec(D.Dir, Debris[D.PicSet].MaxFrm);
      End;
      TransformCoords(D);
    End;
{	If P^.D.HP < 1 Then
		Begin
      P^.D.ID := ExpID;
      MoveObj(P, StartGuy, StartMisc, NumGuys, NumMiscs);
      StartMisc^.D.MoveType := 5;
      StartMisc^.D.Dir := 0;
      StartMisc^.D.PicSet := 2;  {Ship Explosion, not Shot Explosion!
		End;}
  P := P^.Next;
End;


Procedure MoveGuy(Var P : PObj);
Begin
  If Not Stop Then Begin
    Momentum(P^.D);
    TurnTowards(P^.D, Aim(P^.D, PlayerInfo^.D));
    Accelerate(P^.D);
  End;
  TransformCoords(P^.D);
	If P^.D.HP < 1 Then
		Begin
      P^.D.ID := StaticID;
      P^.D.MoveType := 3;
      P^.D.Dir := 0;
      P^.D.Time := 10;
      P^.D.PicSet := 2;     {Ship Explosion, not Shot Explosion!}
      PutRandomDebris(4, P^.D);
      MoveObj(P, ShipHead, StaticHead, NumShip, NumStatic);
		End
  Else
    P := P^.Next;
End;


Procedure MovePlanet(Var P : PObj);
Begin
  With P^ do
    Begin
      If Not Stop then Begin
        Inc(D.Dir);
        If (D.Dir > Debris[D.PicSet].MaxFrm) then Dec(D.Dir, Debris[D.PicSet].MaxFrm);
      End;
      TransformCoords(D);
    End;
{	If P^.D.HP < 1 Then
		Begin
      P^.D.ID := ExpID;
      MoveObj(P, StartGuy, StartMisc, NumGuys, NumMiscs);
      StartMisc^.D.MoveType := 5;
      StartMisc^.D.Dir := 0;
      StartMisc^.D.PicSet := 2;  {Ship Explosion, not Shot Explosion!
		End;}
  P := P^.Next;
End;


Procedure GetKeys(Var S : ObjInfoType);
Var
	Temp : ObjInfoType;
  G : Byte;
Begin
  QueryIdent := PortB = 15;
  If NP[4,1] Then Begin
    Inc(S.PicSet);
    If S.PicSet > NumShipPics - 1 Then S.PicSet := 1;
  End;
	If Plus then Begin
		Inc(S.Acc);
		BFix(S.Acc, 0, 32);
	End;
	If Minus then Begin
		Dec(S.Acc);
		BFix(S.Acc, 0, 32);
	End;
  If BSpc Then PlayerInfo^.D.PrimaryTarget := PlayerInfo^.D.PrimaryTarget^.Next;
  If NP[1,1] then ClearBuffer;
  If NP[2,1] then MarkerOn := Not MarkerOn;
	If NP[4,2] Then Inc(S.Dir);
	If NP[6,2] Then Dec(S.Dir);
	If S.Dir > 35 Then S.Dir := 0
		Else If S.Dir < 0 Then S.Dir := 35;
	If NP[5,2] Then Brake(S)
	Else
		Begin
			If NP[8,2] Then Begin
        AccelerateWOLimit(S);
        RoundClipSpeed(S.CL);
      End;
			If NP[2,2] Then Begin
        DecelerateWOLimit(S);
        RoundClipSpeed(S.CL);
      End;
		End;
  If Enter Then TargetOn := Not TargetOn;
  If NP[5,1] Then Stop := Not Stop;
  If NP[6,1] Then Menu := Not Menu;
	If (S.Time = 0) Then
    Begin
      If Space Then Begin  { Fire }
    		Temp := DefaultObj;
    		Temp.CL := PlayerInfo^.D.CL;
        Temp.RL := PlayerInfo^.D.RL;
    		Temp.Acc := 104 + Random(16);
        Temp.MoveType := 2;
        Temp.Dir := PlayerInfo^.D.Dir;
        AccelerateWOLimit(Temp);
        Temp.Dir := 0;
        Temp.Time := 28;
        Temp.ID := ShotID;
        CreateObj(Temp, ShotHead, NumShot);
        S.Time := 5;
      End;
    End
  Else
    Dec(S.Time);
  Momentum(S);
  Camera := S.RL;
  TransformCoords(S);
End;




Begin
End.
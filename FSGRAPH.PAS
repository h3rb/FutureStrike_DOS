Unit FSGraph;

{
Contains Graphic Routines - DrawProcs
}





Interface


Uses SPX_VGA, SPX_ES, SPX_FNC, FSBasics, FSFunx, FSStars;




Procedure DrawObj(Var S : ObjInfoType; Var P : PicType);
  {Procedure to Draw Objects where Dir is frame number}

Procedure RefreshBG;
  {Refreshes the Background}

Procedure DrawPlayerShip(Var S : ObjInfoType; Var P : PicType);
  {Draws the Player's Ship}

{Const
  DrawType : Array[1..1] of DrawProcType =
             (DrawObj);}



Implementation




Procedure RefreshBG;
Begin
{  For X := 0 to (241 div TileSize + 1) do
    For Y := 0 to (200 div TileSize + 1) do
      FPut_Clip((X * TileSize - CX), (Y * TileSize - CY), GetTile(X,Y)^, False);}
  Bar(0, 0, 239, 199, 0);
  MoveAndShowStars(PlayerInfo^.D.CL.X, PlayerInfo^.D.CL.Y);
End;




Procedure DrawObj(Var S : ObjInfoType; Var P : PicType);
Begin
	If Range(S.L.X, S.L.Y,-P.OnScrn.X, -P.OnScrn.Y, P.OnScrn.X, P.OnScrn.Y) Then
    Begin
      FtPut_Clip( S.L.X+120, S.L.Y+100, VP(P.Pic[S.Dir])^, True);
    End;
End;



Procedure DrawPlayerShip(Var S : ObjInfoType; Var P : PicType);
Begin
  FTPut(S.L.X+120, S.L.Y+100, VP(P.Pic[S.Dir])^, True);
End;



Begin
  InitStars;
End.
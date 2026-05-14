Unit FSStars;


{
Contains the 3 layered scrolling star stuff
}



Interface




Uses FSBasics, SPX_VGA, FSFUNX, Spx_FNC;




Const
  MaxStars = 70;



Type
  StarType = Record
    X, Y : Word;
    Level, Col : Byte;
  End;




Var
  Stars : Array[1..MaxStars] of StarType;




Procedure InitStars;
Procedure MoveAndShowStars(Var DXS, DYS : Integer);


Implementation



Procedure MoveAndShowStars(Var DXS, DYS : Integer);
Var
  S : Byte;
  CX, CY : Integer;
Begin
  CX := -(DXS);
  CY := -(DYS);
  For S := 1 to MaxStars do
    With Stars[S] do
      Begin
        Inc(X, SAR(SAL(CX, Level),3));
        Inc(Y, SAR(SAL(CY, Level),3));
        If X >= MaxXI then
          If X > 32767 Then Inc(X, MaxXI)
            Else Dec(X, MaxXI);
        If Y >= MaxYI then
          If Y > 32767 Then Inc(Y, MaxYI)
            Else Dec(Y, MaxYI);
        PSet(X SHR 4, Y SHR 4, DIST(MaxXI2, MaxYI2, X, Y) SHR 8 + Col);
      End;
End;


Procedure InitStars;
Var
  S : Byte;
Begin
  For S := 1 to MaxStars do
    With Stars[S] do
      Begin
        X := Random(MaxXI);
        Y := Random(MaxYI);
        Level := Random(3);
        Col := Random(4) + 16;
      End;
End;


End.
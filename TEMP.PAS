Program Temp;
Uses SPX_FNC, SPX_VGA, Crt;
Var
  X, Y, Z : LongInt;



Procedure SarD(Var X : LongInt);
inline( $66/$C1/$3E/x/$02 );       { sar   dword ptr [x],01h }


Procedure IncD(Var X : LongInt);
inline( $66/$FF/$06/x );           { inc   dword ptr [x] }



Begin
  ClrScr;
  For Z := 0 to 2048 do
    Begin
      X := Z * 1024 * 1024;
      Y := X;
      IncD(X);
      SarD(X);
      IncD(X);
      Y := (y + 1) div 4 + 1;
      If X = y Then WriteLn('Eureka!', X)
        else Begin writeLn('Da*n mail', X, Y); Halt(0); End;
    End;
End.



Unit FSFunx;


{
Contains all the generic functions and procedures
}






Interface






Uses FSBasics;






Procedure CreateObj(Var Obj : ObjInfoType; Var List : PObj; Var Num : Integer);
  {Adds the Object D to the List StartObj w/ Debug stuff NumObj}


Procedure MoveObj(Var Node, SList, TList : PObj; Var S, T : Integer);
  {Moves the Obj P from List S to List D w/ Debug stuff SNum & DNum}

Function Dist(X, Y, X2, Y2 : Integer) : Integer;
  {A Quick Distance Estimator}

Function AT(DX, DY : LongInt) : ShortInt;
{Function AT(I : Integer) : ShortInt;}
  {Returns the ArcTan * 16 of I}

Procedure BFix(Var A : Byte; Min, Max : Byte);
  {Clips A to Min..Max}

Procedure IFix(Var A : Integer; Min, Max : Integer);
  {Clips A to Min..Max}

Function ObjInBox(Var O, L : ObjInfoType; Var D : PicType) : Boolean;
  {Returns true if Object O is in a box located at L.L of size D.Size}

Implementation





Procedure CreateObj(Var Obj : ObjInfoType; Var List : PObj; Var Num : Integer);
Var Temp : PObj;
Begin
 If ( Freehead = Nil ) then New( Temp ) else
   Begin
    Temp     := Freehead;
    Freehead := Freehead^.Next;
   End;
 Temp^.Next := List;
 List       := Temp;
 Temp^.D := Obj;
 Inc(Num);
End;


Procedure MoveObj(Var Node, SList, TList : PObj; Var S, T : Integer);
Var Prev : PObj;
Begin
 If (Node = Nil) or (SList = Nil) then Halt(7);
 If (Node = SList) then
  Begin
   SList := SList^.Next;
   Node^.Next := TList;
   TList      := Node;
   Node       := Nil;
  End else
   Begin
    Prev := SList;
    While ( Prev^.Next <> Node ) do
     Begin
      If ( Prev^.Next = Nil) then Halt(9);
      Prev := Prev^.Next;
     End;
    Prev^.Next := Node^.Next;
    Node^.Next := TList;
    TList      := Node;
    Node       := Prev^.Next;
   End;
  Dec(S);
  Inc(T);
End;



Function AT(DX, DY : LongInt) : ShortInt;
Var
  I : Integer;
Begin
  If DY = 0 Then
    I := DX * 46
  Else
    I := DX shl 2 div DY;
  If (I < -46) then AT := -9
    Else If (I > 46) Then AT := 9
      Else
        AT := ATT[I];
End;

{Function AT(I : Integer) : ShortInt;
Begin
  If (I < -25) then AT := -9
    Else If (I > 25) Then AT := 9
      Else
        AT := ATT[I];
End;}


Function Dist(X, Y, X2, Y2 : Integer) : Integer;
Label
  skip, done;
Var
  Min : Integer;
Begin
 X2 := Abs(X2 - X);
  Y2 := Abs(Y2 - Y);
  If X2 > Y2 Then Min := Y2
    Else Min := X2;
{  Min := X2 + Y2 - (Min SHR 1)}
  Asm


{        mov   ax,x2       {AX = X2          }
{        sub   ax,x        {AX = AX - X      }
{        cwd               {AX = ABS(AX)     }
{        xor   ax,dx
{        sub   ax,dx
{        mov   bx,ax       {BX = AX          }
{
{        mov   ax,y2       {AX = Y2          }
{        sub   ax,y        {AX = AX - Y      }
{        cwd               {AX = ABS(AX)     }
{        xor   ax,dx
{        sub   ax,dx
{
{        cmp   bx,ax       {If BX > AX       }
{        jg    skip        {Jump to Skip     }
{        mov   cx,x2       {Else CX := X2    }
{        jmp   done        {Jump to done     }
{
{skip:   mov   cx,y2       {CX := Y2         }
{done:}

        mov   ax,x2       {AX := X2         }
        add   ax,y2       {AX := AX + Y2    }
        mov   cx,min
        sar   cX,1        {CX := CX shr 1   }
        sub   aX,cx       {AX := AX - CX    }
        mov   min,ax      {Min := AX        }
  End;
  Dist := Min;
End;




Procedure IFix(Var A : Integer; Min, Max : Integer);
Begin
  If A < Min
    Then A := Min
    Else
      If A > Max
        Then A := Max;
End;




Procedure BFix(Var A : Byte; Min, Max : Byte);
Begin
  If A < Min
    Then A := Min
    Else
      If A > Max
        Then A := Max;
End;


Function ObjInBox(Var O, L : ObjInfoType; Var D : PicType) : Boolean;
Begin
  ObjInBox := (O.L.X > L.L.X - D.Size.X) and (O.L.X < L.L.X + D.Size.X)
       and (O.L.Y > L.L.Y - D.Size.Y) and (O.L.Y < L.L.Y + D.Size.Y);
End;


Begin
End.

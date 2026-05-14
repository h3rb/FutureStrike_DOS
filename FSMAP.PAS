Unit FSMap;




{
Contains Map and Scanner Routines



Video Pages:

         _____________
        |             |    <--- Page 1: Visual Page
        | ____________|
        ||             |   <--- Page 2: Animated Page
        || ____________|
        |||             |  <--- Page 3: Background Page
        |||             |
        |||             |
         ||             |
         ||             |
          |_____________|

}





Interface





Uses SPX_VGA, FSFunx, FSBasics, SPX_FNC;





Procedure PutMap(Var O : ObjInfoType; C : Byte);
  {Puts a blip on the scanner}

Procedure EraseMap;
  {Refreshes the scanner background}

Procedure ShowMap;
  {Updates visual page scanner}





Implementation


Procedure PutMap(Var O : ObjInfoType; C : Byte);
Begin
  PSet( SAR(O.L.X, 6) + 279, SAR(O.L.Y, 6) + 158, C)
End;


Procedure EraseMap;
Begin
  CopyRect(249, 126, 310, 191, Pages[3]^, Pages[2]^);
End;


Procedure ShowMap;
Begin
  CopyRect(249, 126, 310, 191, Pages[2]^, Pages[1]^);
End;



Begin
End.
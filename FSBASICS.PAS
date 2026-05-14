Unit FSBasics;


{
Contains all the Constants, Types, Global Vars, Linked List Stuff,
 and Initialization Procedures


Object Definitions:

Type    |ID#| Damaging | Dockable | Takeable | Damageable |     Example      |
--------|---|----------|----------|----------|------------|------------------|
Ships   | 0 |  No      |   No     |   No     |    Yes     |       You        |
Planets | 1 |  No      |   Yes    |   No     |    No      |      Earth       |
Shots   | 2 |  Yes     |   No     |   No     |    No      |      Laser       |
Static  | 3 |  No      |   No     |   No     |    No      | Explosion/Beacon |
Mines   | 4 |  Yes     |   No     |   No     |    Yes     |  Mine/Asteroid   |
Debris  | 5 |  No      |   No     |   Yes    |    No      |      Debris      |
Deleted |255|  N/A     |   N/A    |   N/A    |    N/A     |        N/A       |
}






Interface







Uses
  SPX_KEY, SPX_VGA, SPX_ES, DACPal;







Const
{*******************Animation Screen Constants**************************}

  MaxX = 240;               { Size of Animation Screen     }
  MaxY = 200;
  MaxX2 = MaxX div 2;       { Middle of Animation Screen   }
  MaxY2 = MaxY div 2;
  MaxXI = MaxX * 16;        { Fixed-Point Screen Size      }
  MaxYI = MaxY * 16;
  MaxXI2 = MaxXI SHR 1;     { Fixed-Point Middle of Screen }
  MaxYI2 = MaxYI SHR 1;

{********************Extended Memory Constants*************************}

  EMSSize = 245000;         { Size of EMS memory to allocate }
  EMSWindowSize = 37000;    { Size of Largest Block in EMS }

{*********************File Constants***********************************}

  UsePal = 'GamePal.Pal';   { Palette File }
  BackPCX = 'H-Panel.PCX';  { PCX Background File }

{**********************Ship Constants**********************************}

  ShipID = 0;
  NumShipPics = 4;
  ShipFiles : Array[1..NumShipPics] of String =
  ('Xenok.VSP', 'Demon.VSP','Stinger.VSP', 'Denzadi.VSP');

{**********************Planet Constants********************************}
  PlanetID = 1;
  NumPlanetPics = 5;
  PlanetFiles : Array[1..NumPlanetPics] of String =
  ('Earth.VSP','Moon.VSP','StarBase.VSP','Mars.VSP','Saturn.VSP');

{**********************Shot Constants**********************************}

  ShotID = 2;
  NumShotPics = 1;
  ShotFiles : Array[1..NumShotPics] of String =
  ('Shot.VSP');

{**********************Static Constants********************************}
  StaticID = 3;
  NumStaticPics = 2;
  StaticFiles : Array[1..NumStaticPics] of String =
  ('ShotExp.VSP', 'ShipExp.VSP');

{**********************Mine Constants**********************************}
  MineID = 4;
  NumMinePics = 2;
  MineFiles : Array[1..NumMinePics] of String =
  ('Mine.VSP', 'Asteroid.VSP');

{**********************Debris Constants********************************}
  DebrisID = 5;
  NumDebrisPics = 1;
  DebrisFiles : Array[1..NumDebrisPics] of String =
  ('Debris1.VSP');

{**********************Deleted Constants*******************************}
  DeletedID = 255;

{**********************Path/File Constants*****************************}
  VSPPath = 'vsps\';



Type

  LongIntCoordType = Record
    X, Y : LongInt;
  End;

  IntCoordType = Record
    X, Y : Integer;
  End;

  ByteCoordType = Record
    X, Y : Byte;
  End;

  ShortIntCoordType = Record
    X, Y : ShortInt;
  End;

  PicType = Record
    Pic : Array[0..35] of PEMSDyData; { Bitmaps - up to 36 frames / directions  }
    MaxFrm : Byte;                    { Max Num of Bitmaps                      }
    OnScrn, Size : ByteCoordType;     { Half Screen + Half Size, Half Size      }
  End;

  PObj = ^Obj;

  ObjInfoType = Record
    CL : IntCoordType;                { Velocity / Momentum - Delta Location }
                                      {     pixels per frame * 16            }
    L : IntCoordType;                 { Location  (in pixels) relative to Camera }
    RL : LongIntCoordType;            { Location  (pixel location * 16)      }
    Dir : ShortInt;                   { Direction or Frame                   }
    Time : Byte;                      { Time left to live in frames          }
    PicSet : Byte;                    { Picture Set                          }
    HP : ShortInt;                    { Hit Points                           }
    ID : Byte;                        { Identification Byte                  }
    Acc : Byte;                       { Acceleration Factor in Pixels per frame per frame * 16 }
    PrimaryTarget : PObj;             { Pointer to Primary Target            }
    SecondaryTarget : PObj;           { Pointer to Secondary Target          }
    MoveType : Byte;                  { Index of Move Procedure Type         }
    DrawType : Byte;                  { Index of Drawing Calculation Procedure Type }
  End;


{ If futurestrike were in a tiled universe: The universe would be

  43+ terrabytes (128*128 pixel tiles)
                   or
  70,000+ terrabytes (handrawn background)               }


  Obj = Record
    Next : PObj;
    D : ObjInfoType;
  End;

  MoveProcType = Procedure (Var P : PObj);
  DrawProcType = Procedure (Var S : ObjInfoType; Var P : PicType);


Const
  DefaultObj : ObjInfoType =
  (CL: (X: 0; Y: 0);
   L : (X: 0; Y: 0);
   RL: (X: 0; Y: 0);
   Dir : 0;
   Time : 255;
   PicSet : 1;
   HP : 2;
   ID : DebrisID;
   Acc : 16;
   PrimaryTarget : Nil;
   SecondaryTarget : Nil;
   MoveType : 1;
   DrawType : 1 );


Var
  QueryIdent, Map, Menu, Stop, Pause, TargetOn, MarkerOn : Boolean;
                                      { Debug Boolean Mode Variables         }
  TargetC : Byte;                     { Target Color                         }
  DosPal, Black : EGA64Pal;           { Dos start pal, Black pal             }

  TableMove : Array[0..35] of ShortIntCoordType;
                                      { Sine / Cosine (X / Y) Table          }
                                      { For 36 directions                    }
  ATT : Array[-46..46] of ShortInt;   { Kinda Pathetic ArcTangent Table      }
{  ATT : Array[-25..25] of ShortInt;   { Pretty Pathetic ArcTangent Table     }

  EMSGlobalMem : PEMSStack;           { EMS Stack Pointer                    }

  ExitSave : Pointer;                 { Exit Procedure Save Pointer          }

                                      { Bitmap Pointer Variables             }
  Ship   : Array[1..NumShipPics  ] of PicType; { Ship Bitmaps                }
  Planet : Array[1..NumPlanetPics] of PicType; { Planet Bitmaps              }
  Shot   : Array[1..NumShotPics  ] of PicType; { Shot Bitmaps                }
  Static : Array[1..NumStaticPics] of PicType; { Static Bitmaps              }
  Mine   : Array[1..NumMinePics  ] of PicType; { Mine Bitmaps                }
  Debris : Array[1..NumDebrisPics] of PicType; { Debris Bitmaps              }

  PlayerInfo : PObj;    { Player Information }

                        { Obect List Heads, Debug Information }
  ShipHead, PlanetHead, ShotHead, StaticHead, MineHead, DebrisHead, FreeHead : PObj;
  NumShip, NumPlanet, NumShot, NumStatic, NumMine, NumDebris, NumFree : Integer;
  Cur1, Cur2 : PObj;
  Camera : LongIntCoordType;





Implementation






Procedure InitTables;
Var
  X : ShortInt;
Begin
  For X := 0 to 35 do
    Begin
      TableMove[X].X := Round(Cos(X/18*pi)*16);
      TableMove[X].Y := Round(Sin(X/18*pi)*16);
    End;
  For X := -46 to 46 do
    ATT[X] := Round( ArcTan( (X / 4) ) / Pi * 18 );
{  For X := -25 to 25 do
    ATT[X] := Round( ArcTan( X ) / Pi * 18 );}
End;



Procedure OutputEndInfo;
Begin
  SetEGA64Pal(Black);
  Write('Exit Status: ');
  Case ExitCode of
    0 : WriteLn('Normal Termination');
    7 : WriteLn('Linked List Error: Object to be deleted does not exist');
    8 : WriteLn('Misc Linked List Error: Misc object frame does not exist');
    10 : WriteLn('Memory Error: EMS could not be allocated');
    Else WriteLn('Run-Time Error Code = ', ExitCode);
  End;
End;


Procedure RestoreKeyRate;
Begin
  ASM                   {Should restore key repeat rate - doesn't - just sets it to fastest}
   mov AH, $03
   mov AL, $05
   mov BL, $00
   mov BH, $00
   int $16
  End;
End;


Procedure NewExitProc; Far;
Begin
  DeleteEMSStack(EMSGlobalMem);
  CloseMode;
  ClearKeyInt;
  OutputEndInfo;
  RestoreKeyRate;
  FadeStepsEGA64(Black,DosPal,24);
  SetEGA64Pal(DosPal);
  ExitProc := ExitSave;
End;


Procedure InitExitProc;
Begin
  ExitSave := ExitProc;
  ExitProc := @NewExitProc;
End;


Procedure InitPalettes;
Var
  X : Word;
Begin
  GetEGA64Pal(DosPal);
  For X := 0 to 191 do
    Black[X] := 0;
End;


Procedure InitEMS;
Begin
  WriteLn('þ Initializing EMS');
  ChangeTempBuffer(EMSWindowSize);
  EMSGlobalMem := CreateEMSStack(EMSSize);
  If EMSGlobalMem = Nil then Halt(10);
End;


Procedure InitLists;
Begin
  ShipHead   := Nil;   NumShip   := 0;
  PlanetHead := Nil;   NumPlanet := 0;
  ShotHead   := Nil;   NumShot   := 0;
  StaticHead := Nil;   NumStatic := 0;
  MineHead   := Nil;   NumMine   := 0;
  DebrisHead := Nil;   NumDebris := 0;
  FreeHead   := Nil;   NumFree   := 0;
End;


Begin
  InitExitProc;
  WriteLn('Future Strike v. 2.0.1');
  InitEMS;
  InitPalettes;
  InitTables;
  InitLists;
End.

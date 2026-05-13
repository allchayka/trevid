unit unRecords;

interface
uses
    StdCtrls;

Type
  TPathApp = record
  PathApp : string;
  PathPict : string;
  PathHlp : string;
  PathDoc : string;
  end;

type
  TVIDinf = record
   Duration: int64;
   FrameCount: int64;
   VideoWidth: LongInt;
   VideoHeight: LongInt;
   VideoCodec: string;
   AudioCodec: string;
   VideoFrameRateFps: Double;
   AvgBitRate: LongInt;
   AudioChannels: LongInt;
   AudioSamplesPerSec: LongInt;
   AudioBitsPerSample: LongInt;
   end;

type
  TAnsverRect = record
  id : integer;
  idR : integer;
  Rigth : Boolean;
  Ball : single;
  idAns : integer;
  check : TCheckBoxState;
  end;

type
  TRectFr = record
  id : integer;
  idGrR : integer;
  TimeB : integer;
  TimeE : integer;
  TimeBc : integer;
  TimeEc : integer;
  l, t, w, h : integer;
  seq : integer;
  flTime : Boolean;
  flCoord : Boolean;
  cntAns : integer;
  end;

type
  TGrRects = record
  id : integer;
  idR : integer;
  Name : string;
  Rem : string;
  seq : integer;
  Rct : array[0..50] of TRectFr;
  AnsvRct : array[0..100] of TAnsverRect;
  cntRct : integer;
  cntAnsvRct : integer;
  end;

type
  TAnsverText = record
  id : integer;
  idV : integer;
  idApp : integer;
  Seq : integer;
  idF : integer;
  Ansver : string;
  Group : Boolean;
  end;

type
  TFragments = record
  id : integer;
  idV : integer;
  Name : string;
  FileP : string;
  Rem : string;
  TimeF : integer;
  TimeB : integer;
  TimeE : integer;
  seq : integer;
  cntGr : integer;
  cntAnsvT : integer;
  GrRct : array[0..200] of TGrRects;
  AnsvT : array [0..300] of TAnsverText;
  end;

Type
  TLstAnsver = record
  indAnsvT : integer;
  indGrRects : integer;
  indAnsvRct : integer;
  end;


implementation

end.

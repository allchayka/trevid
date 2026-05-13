unit UnOptions;

interface

uses Classes, SysUtils, IniFiles,tren,unRecords;    //  ,unDataBase

type
  {???? ??? ??????}
  TDataBaseType = (dbtABS, dbtMySQL, dbtPGRES,dbtMSSQL, dbtSQLite, dbtADO);

  //TOrDataSet = class(TCollectionItem)
  //private
  //  FTableName : string;
  //  FDataSet : TDataSet;
  //public
  //  property TableName : string read FTableName write FTableName;
  //  property DataSet : TDataSet read FDataSet write FDataSet;
  //end;

  TrOptions = class (TObject)
  private
    fIniFile: TIniFile;
    fTypeDB : TDataBaseType;
    fTypeDBstr,fPathDB,fPathProg,fPathHlpFile : string;
//    PathDBPic : string;
    fPathVideo : string;
    fPathUpdate: string;
    fPathPic,fPathDoc,fPathHlp: string;
    fDirLogLocal : string;
    fPathTr : TPathApp;
  public
    constructor Create(aPathApp : string);
    destructor Destroy; override;
    property IniFile: TIniFile read fIniFile write fIniFile;
    property TypeDB: TDataBaseType read fTypeDB write fTypeDB;
    property TypeDBstr: string read fTypeDBstr write fTypeDBstr;
    property PathDB: string read fPathDB write fPathDB;
    property PathProg: string read fPathProg write fPathProg;
    property PathHlpFile: string read fPathHlpFile write fPathHlpFile;
    property PathVideo: string read fPathVideo write fPathVideo;
    property PathUpdate: string read fPathUpdate write fPathUpdate;
    property PathPic: string read fPathPic write fPathPic;
    property PathDoc: string read fPathDoc write fPathDoc;
    property PathHlp: string read fPathHlp write fPathHlp;
    property DirLogLocal: string read fDirLogLocal write fDirLogLocal;
    property PathTr: TPathApp read fPathTr write fPathTr;
  published
  end;

const
  //???????? ?? ?????????
  _Path = 'Path';
  _TypeDB = 'TypeDB';
  TypeDBdef = 'dbtABS';
  _PathDB = 'PathDB';
  PathDBdef ='dsgn.abs';
  _PathDBPic = 'PathDBPic';
  PathDBPicdef = 'pic.abs';
  _PathVideo = 'PathVideo';
  PathVideodef ='vid';
  _PathPic = 'PathPic';
  PathPicdef ='';
  _PathHlp = 'PathHlp';
  PathHlpdef ='';
  _PathHlpFile = 'PathHlpFile';
  PathHlpFiledef ='';
  _PathDoc = 'PathDoc';
  PathDocdef ='';
  _PathUpdate = 'PathUpdate';
  PathUpdatedef ='';

var rOptions : TrOptions;

implementation


constructor TrOptions.Create(aPathApp : string);
var
  FileName, pathDBd,pdl2: string;
  res : Boolean;
begin
//{$i-}
//  GetDir(0,IniPath);
//{$I+}
  pdl2 :=PathDelim+PathDelim;
  fPathProg:= aPathApp;
  FileName:=StringReplace(aPathApp+PathDelim+ 'tren.ini',pdl2,PathDelim,[rfReplaceAll]);
  fIniFile:=TIniFile.Create(FileName);
//  Ini.JvAppIniFileStorage1.FileName:=FileName;
  fTypeDBstr := fIniFile.ReadString (_Path,_TypeDB,TypeDBdef);
  if (fTypeDBstr = '') or (UpperCase(fTypeDBstr) = 'ABS') then fTypeDB := dbtABS
  else if UpperCase(fTypeDBstr) = 'MYSQL' then fTypeDB := dbtMySQL
  else if UpperCase(fTypeDBstr) = 'PGRES' then fTypeDB := dbtPGRES
  else if UpperCase(fTypeDBstr) = 'MSSQL' then fTypeDB := dbtMSSQL
  else if UpperCase(fTypeDBstr) = 'SQLITE' then fTypeDB := dbtSQLite
  ;

  pathDBd := StringReplace(aPathApp+PathDelim+ PathDBdef,pdl2,PathDelim,[rfReplaceAll]);
  fPathDB := fIniFile.ReadString (_Path,_PathDB,PathDBdef);
  if fPathDB='' then fPathDB:= StringReplace(aPathApp+PathDelim+ PathDBdef,pdl2,PathDelim,[rfReplaceAll]);
  //PathDBPic := IniFile.ReadString (_Path,_PathDBPic,PathDBPicdef);
  //if PathDBPic='' then PathDBPic:=PathDBPicdef;

  fPathUpdate := fIniFile.ReadString (_Path,_PathUpdate,PathUpdatedef);
  if fPathUpdate='' then fPathUpdate:= aPathApp+ PathUpdatedef;

  fPathVideo := fIniFile.ReadString (_Path,_PathVideo,aPathApp+PathVideodef);
  if fPathVideo = '' then fPathVideo := aPathApp+PathVideodef;
//  GetDir(0,PathTr.PathApp);
  fPathTr.PathApp := aPathApp;
  fPathTr.PathPict := fIniFile.ReadString (_Path,_PathPic,PathPicdef);
  fPathTr.PathPict := fIniFile.ReadString (_Path,_PathPic,PathPicdef);
  if fPathTr.PathPict='' then fPathTr.PathPict:=fPathTr.PathApp+ 'pic';   //+PathDelim
  fPathTr.PathHlp := fIniFile.ReadString (_Path,_PathHlp,PathHlpdef);
  if fPathTr.PathHlp='' then fPathTr.PathHlp:=fPathTr.PathApp+PathDelim+ 'Hlp';
  fPathHlpFile := fIniFile.ReadString (_Path,_PathHlpFile,PathHlpFiledef);
  if fPathHlpFile='' then fPathHlpFile:=fPathTr.PathApp+PathDelim+ 'help.htm';
  fPathTr.PathDoc := fIniFile.ReadString (_Path,_PathDoc,PathDocdef);
  if fPathTr.PathDoc='' then fPathTr.PathDoc:=fPathTr.PathApp+PathDelim+ 'Doc';
   fPathPic := fPathTr.PathPict;
   fPathDoc := fPathTr.PathDoc;
   fPathHlp := fPathTr.PathHlp;
  fDirLogLocal := aPathApp + PathDelim+ 'log';
  if not DirectoryExists(fDirLogLocal) then CreateDir(fDirLogLocal);

end;

destructor TrOptions.Destroy;
begin
  IniFile.Free;
end;

end.

unit unDataBase;

interface

uses
  Messages, SysUtils, Variants, Classes, DB, AdoConEd, ADODB, ABSMain, ASGSQLite3;

type
  {Типы баз данных}
  TDataBaseType = (dbtABS, dbtMySQL, dbtPGRES,dbtMSSQL,dbtSQLite,dbtADO);

  TOrDataSet = class(TCollectionItem)
  private
    FTableName : string;
    FDataSet : TDataSet;
  public
    property TableName : string read FTableName write FTableName;
    property DataSet : TDataSet read FDataSet write FDataSet;
  end;

  TOrDataSets = class(TCollection)
    private
      function GetItem(Index: Integer): TOrDataSet;
      procedure SetItem(Index: Integer; const Value: TOrDataSet);
    public
      destructor Destroy; override;
      function  Add: TOrDataSet;
      procedure Delete(Index: Integer);
      function Insert(Index: Integer): TOrDataSet;
      property Items[Index: Integer]: TOrDataSet read GetItem  write SetItem; default;
    end;

  TDBOrigin = class (TObject)
    private
      FABSDB : TABSDatabase;
      FADODB : TADOConnection;
      FSQLiteDB : TASQLite3DB;
      FTypeDB : TDataBaseType;
      FDBName : string;
      FConnectionString : string;
      FOrDatasets : TOrDataSets;
    protected
      function GetDataSet(Index: Integer): TOrDataSet;
    public
      property TypeDB : TDataBaseType read FTypeDB write FTypeDB;
      property DBName : string read FDBName write FDBName;
      property ConnectionString : string read FConnectionString write FConnectionString;
      property DataSets[Index: Integer]: TOrDataSet read GetDataSet;
      function CreateConnect(dbt: TDataBaseType; DBName, strConnect : string): Boolean;
      destructor Destroy; override;
      function Connected : Boolean;
      function DisConnected : Boolean;
      function Count(): Integer;
      function GetTableList(): string;
      function ExecSQL(sql : string): Boolean;
      function Table(Name : string): TDataSet;
      function QueryCreate(sql : string): TDataSet;
      function Data2SQLstr(fld : TField): string;
      function SQLFieldName(fn : string): string;
  end;

  TDsgnDBTables = class
  private
    FDsgnDB : TABSDatabase;
    Tdbt : TDataBaseType;
    FCounters : TABSTable;
    FObjType : TABSTable;
    FPaternAskInTask : TABSTable;
    FReaction : TABSTable;
    FVersion : TABSTable;
    FAnsverList : TABSTable;
    FAnsverPicture : TABSTable;
    FObjects : TABSTable;
    FClips : TABSTable;
    FAskType : TABSTable;
    FFragments : TABSTable;
    FRects : TABSTable;
    FGrRects : TABSTable;
    FAnsverText : TABSTable;
    FAnsverRect : TABSTable;
    FAsks : TABSTable;
    FDiary : TABSTable;
    FSubjects : TABSTable;
    FPupils : TABSTable;
    FQuestionForTask : TABSTable;
    FPatternTask : TABSTable;
    FTasks : TABSTable;
    // db connected?
    function GetConnected: Boolean;
    // connect / disconnect
    procedure SetConnected(value: boolean);
  public
    constructor Create(dbt: TDataBaseType; DBName, strConnect : string);
    destructor  Destroy; override;
    property DsgnDB         : TABSDatabase  read FDsgnDB write FDsgnDB;
    property Connected: boolean read GetConnected write SetConnected default false;
    property Counters          : TABSTable  read FCounters   write FCounters;
    property ObjType           : TABSTable  read FObjType  write FObjType;
    property PaternAskInTask   : TABSTable  read FPaternAskInTask write FPaternAskInTask;
    property Reaction          : TABSTable  read FReaction write FReaction;
    property Version           : TABSTable  read FVersion write FVersion;
    property AnsverList        : TABSTable  read FAnsverList write FAnsverList;
    property AnsverPicture     : TABSTable  read FAnsverPicture write FAnsverPicture;
    property Objects           : TABSTable  read FObjects write FObjects;
    property Clips             : TABSTable  read FClips write FClips;
    property AskType           : TABSTable  read FAskType write FAskType;
    property Fragments         : TABSTable  read FFragments write FFragments;
    property Rects             : TABSTable  read FRects write FRects;
    property GrRects           : TABSTable  read FGrRects write FGrRects;
    property AnsverText        : TABSTable  read FAnsverText write FAnsverText;
    property AnsverRect        : TABSTable  read FAnsverRect write FAnsverRect;
    property Asks              : TABSTable  read FAsks write FAsks;
    property Diary             : TABSTable  read FDiary write FDiary;
    property Subjects          : TABSTable  read FSubjects write FSubjects;
    property Pupils            : TABSTable  read FPupils write FPupils;
    property QuestionForTask   : TABSTable  read FQuestionForTask write FQuestionForTask;
    property PatternTask       : TABSTable  read FPatternTask write FPatternTask;
    property Tasks             : TABSTable  read FTasks write FTasks;
  end;
var
  DBConnections : TDBOrigin;

implementation

function ApplicationPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;
{TOrDataSets}
destructor TOrDataSets.Destroy; begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TOrDataSets.Add: TOrDataSet; begin
  Result := TOrDataSet(inherited Add);
end;
procedure TOrDataSets.Delete(Index: Integer); begin
  inherited Delete(Index);
end;
function TOrDataSets.GetItem(Index: Integer): TOrDataSet; begin
  Result := TOrDataSet(inherited Items[Index]);
end;
function TOrDataSets.Insert(Index: Integer): TOrDataSet; begin
  Result := TOrDataSet(inherited Insert(Index));
end;
procedure TOrDataSets.SetItem(Index: Integer; const Value: TOrDataSet); begin
  Items[Index].Assign(Value);
end;

{TDBOrigin}
function TDBOrigin.CreateConnect(dbt: TDataBaseType; DBName, strConnect : string): Boolean;
begin
  FDBName := DBName;
  FConnectionString := strConnect;
  FTypeDB := dbt;
  Result := Connected;
//  FADODB.Execute();
end;

destructor  TDBOrigin.Destroy;
begin
  if FABSDB <> nil then FABSDB.Free;
  if FADODB <> nil then FADODB.Free;
end;

function TDBOrigin.Connected : Boolean;
var lstTbl : TStringList;
    i : Integer;
    dst : TOrDataSet;

  procedure SetDataSetABS(tblN : string; var dset:TOrDataSet);
  var tblABS : TABSTable;
  begin
    tblABS := TABSTable.Create(nil);
    tblABS.DatabaseName := DBName;
    tblABS.Exclusive := False;
    tblABS.TableName := tblN;
    tblABS.Active := True;
    dset.FTableName := tblN;
    dset.FDataSet := tblABS;
  end;
  procedure SetDataSetADO(tblN : string; var dset:TOrDataSet);
  var tblADO : TADOTable;
  begin
    tblADO := TADOTable.Create(nil);
    tblADO.Connection := Self.FADODB;
    tblADO.TableName := tblN;
    tblADO.Active := True;
    dset.FTableName := tblN;
    dset.FDataSet := tblADO;
  end;
  procedure SetDataSetSQLite(tblN : string; var dset:TOrDataSet);
  var tblSQLite : TASQLite3Table;
  begin
    tblSQLite := TASQLite3Table.Create(nil);
    tblSQLite.Connection := Self.FSQLiteDB;
    tblSQLite.TableName := tblN;
    tblSQLite.Active := True;
    dset.FTableName := tblN;
    dset.FDataSet := tblSQLite;
  end;
begin
  try
    try
      if FTypeDB = dbtABS then begin
        if FABSDB <> nil then FABSDB.Free;
        FABSDB := TABSDatabase.Create(nil);
        FABSDB.DatabaseName := FDBName;
        FABSDB.DatabaseFileName := FConnectionString;
        FABSDB.MultiUser := True;
        FABSDB.Exclusive := False;
        FABSDB.Connected := True;
      end
      else if (FTypeDB = dbtMySQL) or (FTypeDB = dbtPGRES) or (FTypeDB = dbtMSSQL) then begin
        if FADODB <> nil then FADODB.Free;
        FADODB := TADOConnection.Create(nil);
        FADODB.ConnectionString := FConnectionString;
        FADODB.Mode := cmReadWrite;
        FADODB.LoginPrompt := False;
        FADODB.Connected := True;
      end
      else if FTypeDB = dbtSQLite then begin
        if FSQLiteDB <> nil then FSQLiteDB.Free;
        FSQLiteDB := TASQLite3DB.Create(nil);
        FSQLiteDB.DriverDLL := ApplicationPath + 'sqlite3.dll';
        FSQLiteDB.Database := FConnectionString;
        FSQLiteDB.Connected := True;
      end;

      lstTbl := TStringList.Create;
      try
        lstTbl.Text := GetTableList;
        if FOrDatasets<>nil then  FOrDatasets.Free;
        FOrDatasets := TOrDataSets.Create(TOrDataSet);
        for i := 0 to lstTbl.Count-1 do begin
          dst := FOrDatasets.Add;
          if FTypeDB = dbtABS then SetDataSetABS(lstTbl[i],dst)
          else if (FTypeDB = dbtMySQL) or (FTypeDB = dbtPGRES) or (FTypeDB = dbtMSSQL) then
            SetDataSetADO(lstTbl[i],dst)
            else if FTypeDB = dbtSQLite then
              SetDataSetSQLite(lstTbl[i],dst);
        end;
      finally
        lstTbl.Free;
      end;
    finally
    end;
    Result := True;
  except
    Result := False;
  end;
end;
function TDBOrigin.DisConnected : Boolean;
begin
  if FTypeDB = dbtABS then FABSDB.Connected := False
  else if (FTypeDB = dbtMySQL) or (FTypeDB = dbtPGRES) or (FTypeDB = dbtMSSQL) then
   FADODB.Connected := False
  else if FTypeDB = dbtSQLite then
    FSQLiteDB.Connected := False;
end;

function TDBOrigin.Count(): Integer;
begin
  Result :=FOrDatasets.Count;
end;

function TDBOrigin.GetDataSet(Index: Integer): TOrDataSet;
begin
  Result := FOrDatasets[Index];
//  if FTypeDB = dbtABS then Result := FABSDB.DataSets[Index]
//  else Result := FADODB.DataSets[Index];
end;
function TDBOrigin.GetTableList(): string;
var lstTbl : TStringList;
begin
  lstTbl := TStringList.Create;
  try
    if FTypeDB = dbtABS then FABSDB.GetTablesList(lstTbl)
      else if (FTypeDB = dbtMySQL) or (FTypeDB = dbtPGRES) or (FTypeDB = dbtMSSQL) then
        FADODB.GetTableNames(lstTbl)
        else if FTypeDB = dbtSQLite then
          FSQLiteDB.GetTableNames(lstTbl);

    Result :=lstTbl.Text;
  finally
    lstTbl.Free;
  end;
end;
function TDBOrigin.ExecSQL(sql : string): Boolean;
var adoSql : TADOQuery;
  SQLiteSQL : TASQLite3Query;
begin
  try
    if FTypeDB = dbtABS then
      begin
//        Create.
      end
      else if (FTypeDB = dbtMySQL) or (FTypeDB = dbtPGRES) or (FTypeDB = dbtMSSQL) then begin
        adoSql := TADOQuery.Create(nil);
        adoSql.Connection := FADODB;
        adoSql.SQL.Text := sql;
        FADODB.Connected :=True;
        adoSql.ExecSQL;
      end
      else if FTypeDB = dbtSQLite then begin
        SQLiteSQL := TASQLite3Query.Create(nil);
        SQLiteSQL.Connection := FSQLiteDB;
        SQLiteSQL.SQL.Text := sql;
 //       FADODB.Connected :=True;
        SQLiteSQL.ExecSQL;
      end;
    Result := True;
  except
    Result := False;
  end;
end;
function TDBOrigin.Table(Name : string): TDataSet;
var i : Integer;
begin
  Result := nil;
  for i := 0 to FOrDatasets.Count-1 do begin
    if UpperCase(FOrDatasets[i].FTableName)= UpperCase(Name) then begin
      Result := FOrDatasets[i].DataSet;
      Break;
    end;
  end;
end;

function TDBOrigin.QueryCreate(sql : string): TDataSet;
var adoSql : TADOQuery;
    absSql : TABSQuery;
    SQLiteSql : TASQLite3Query;
    sql1 : string;
begin
  try
//  TDataBaseType = (dbtABS, dbtMySQL, dbtPGRES,dbtMSSQL,dbtSQLite);
    if FTypeDB = dbtABS then begin
        absSql := TABSQuery.Create(nil);
 //       absSql.Database := FABSDB;
        absSql.DatabaseName := FABSDB.DatabaseName;
        absSql.SQL.Text := sql;
        FABSDB.Connected :=True;
        absSql.Open;
        Result := absSql;
      end
      else if (FTypeDB = dbtMySQL) or (FTypeDB = dbtPGRES) or (FTypeDB = dbtMSSQL) then begin
        adoSql := TADOQuery.Create(nil);
        adoSql.Connection := FADODB;
        adoSql.SQL.Text := sql;
        FADODB.Connected :=True;
        adoSql.Open;
        Result := adoSql;
      end
      else if FTypeDB = dbtSQLite then begin
          SQLiteSql := TASQLite3Query.Create(nil);
          SQLiteSql.Connection := FSQLiteDB;
          SQLiteSql.SQL.Text := sql;
//          SQLiteSql.Connected :=True;
          SQLiteSql.Open;
//          SQLiteSql.Free;
          Result := SQLiteSql;
      end;
  except
    Result := nil;
  end;
end;
//TDataBaseType = (dbtABS, dbtMySQL, dbtPGRES,dbtMSSQL)
function TDBOrigin.Data2SQLstr(fld : TField): string;
var s : string;
begin
  if fld.AsDateTime=0 then begin
    Result := ''; Exit;
  end;
  if FTypeDB=dbtABS then Result := FormatDateTime('dd.mm.yyyy', fld.AsDateTime)
  else if FTypeDB=dbtMySQL then Result:=FormatDateTime('yyyy-mm-dd',fld.AsDateTime)
  else if FTypeDB=dbtSQLite then Result:=FormatDateTime('yyyy-mm-dd',fld.AsDateTime)+ ' 00:00:00.000'
  ;
end;

function TDBOrigin.SQLFieldName(fn : string): string;
begin
  if (FTypeDB= dbtABS) or (FTypeDB= dbtSQLite) then Result := '['+fn+']'
  else if FTypeDB=dbtMySQL then Result := '`'+fn+'`'
  ;
end;

{TDsgnDBTables}
constructor TDsgnDBTables.Create(dbt: TDataBaseType; DBName, strConnect : string);

  function CreateDataSet(tblN : string) : TABSTable;
  begin
    Result := TABSTable.Create(nil);
    Result.DatabaseName := DBName;
    Result.Exclusive := False;
    Result.TableName := tblN;
    Result.Active := True;
  end;
begin
  if dbt = dbtABS then
  begin
    FDsgnDB := TABSDatabase.Create(nil);
    FDsgnDB.Exclusive := False;
    FDsgnDB.DatabaseFileName := strConnect;
    FDsgnDB.DatabaseName := DBName;
    FDsgnDB.Connected := True;

    FCounters        := CreateDataSet('Counters');
    FObjType         := CreateDataSet('ObjType');
    FPaternAskInTask := CreateDataSet('PaternAskInTask');
    FReaction        := CreateDataSet('Reaction');
    FVersion         := CreateDataSet('Version');
    FAnsverList      := CreateDataSet('AnsverList');
    FAnsverPicture   := CreateDataSet('AnsverPicture');
    FObjects         := CreateDataSet('Objects');
    FClips           := CreateDataSet('Clips');
    FAskType         := CreateDataSet('AskType');
    FFragments       := CreateDataSet('Fragments');
    FRects           := CreateDataSet('Rects');
    FGrRects         := CreateDataSet('GrRects');
    FAnsverText      := CreateDataSet('AnsverText');
    FAnsverRect      := CreateDataSet('AnsverRect');
    FAsks            := CreateDataSet('Asks');
    FDiary           := CreateDataSet('Diary');
    FSubjects        := CreateDataSet('Subjects');
    FPupils          := CreateDataSet('Pupils');
    FQuestionForTask := CreateDataSet('QuestionForTask');
    FPatternTask     := CreateDataSet('PatternTask');
    FTasks           := CreateDataSet('Tasks');

  end;
end;

destructor  TDsgnDBTables.Destroy;
begin
  FCounters.Free;
  FObjType.Free;
  FPaternAskInTask.Free;
  FReaction.Free;
  FVersion.Free;
  FAnsverList.Free;
  FAnsverPicture.Free;
  FObjects.Free;
  FClips.Free;
  FAskType.Free;
  FFragments.Free;
  FRects.Free;
  FGrRects.Free;
  FAnsverText.Free;
  FAnsverRect.Free;
  FAsks.Free;
  FDiary.Free;
  FSubjects.Free;
  FPupils.Free;
  FQuestionForTask.Free;
  FPatternTask.Free;
  FTasks.Free;

  FDsgnDB.Free;
end;
// db connected?
function TDsgnDBTables.GetConnected: Boolean;
begin
  Result := False;
  if Assigned(FDsgnDB) then Result := FDsgnDB.Connected;
end;
// connect / disconnect
procedure TDsgnDBTables.SetConnected(value: boolean);
begin
  if Assigned(FDsgnDB) then FDsgnDB.Connected := value;
end;

end.


{
Counters
ObjType
PaternAskInTask
Reaction
Version
AnsverList
AnsverPicture
Objects
Clips
AskType
Fragments
Rects
GrRects
AnsverText
AnsverRect
Asks
Diary
Subjects
Pupils
QuestionForTask
PatternTask
Tasks

'Counters'
'ObjType'
'PaternAskInTask'
'Reaction'
'Version'
'AnsverList'
'AnsverPicture'
'Objects'
'Clips'
'AskType'
'Fragments'
'Rects'
'GrRects'
'AnsverText'
'AnsverRect'
'Asks'
'Diary'
'Subjects'
'Pupils'
'QuestionForTask'
'PatternTask'
'Tasks'
}


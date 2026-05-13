unit UnTreeTopic;

//{$mode Delphi}

interface

uses
  Types, LCLType,Classes, SysUtils;

Type
  TrecSub = record
    IDt : Integer;
    AppIdt : Integer;
    IndInG : Integer;
    Disable : Boolean;
    Name,Rem : string;
  end;

Type
  TdSub = class;
  TdSubs = class;

  TdSub = class(TCollectionItem)
  private
    fIDt : Integer;
    fAppIdt : Integer;
    fIndInG : Integer;
    fDisable : Boolean;
    fName,fRem : string;
    dSubs : TdSubs;
  public
    property IDt: Integer read fIDt write fIDt;
    property AppIdt: Integer read fAppIdt write fAppIdt;
    property IndInG: Integer read fIndInG write fIndInG;
    property Disable: Boolean read fDisable write fDisable;
    property Name: string read fName write fName;
    property Rem: string read fRem write fRem;
    property Subs: TdSubs read dSubs write dSubs;
  published
  end;

  TdSubs = class(TCollection)
  private
    fRootSubs : TdSubs;
    function GetItem(Index: Integer): TdSub;
    procedure SetItem(Index: Integer; const Value: TdSub);
  public
    destructor Destroy; override;
    function  Add: TdSub;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TdSub;
    procedure AddRecord(recSub : TrecSub; andLost,andDis : Boolean);
    function GetNodeIdt(idt : Integer; ds:TdSubs): TdSub;
    property Items[Index: Integer]: TdSub read GetItem  write SetItem; default;
    property RootSubs: TdSubs read fRootSubs write fRootSubs;
  end;


implementation

{TdSubs}
destructor TdSubs.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TdSubs.Add: TdSub;
begin
  Result := TdSub(inherited Add);
  Result.dSubs := TdSubs.Create(TdSub);
  Result.dSubs.RootSubs := Self.RootSubs;
end;
procedure TdSubs.Delete(Index: Integer);
begin
  if Items[Index].dSubs<>nil then Items[Index].dSubs.Free;
  inherited Delete(Index);
end;
function TdSubs.GetItem(Index: Integer): TdSub;
begin
  Result := TdSub(inherited Items[Index]);
end;
function TdSubs.Insert(Index: Integer): TdSub;
begin
  Result := TdSub(inherited Insert(Index));
end;
procedure TdSubs.SetItem(Index: Integer; const Value: TdSub);
begin
  Items[Index].Assign(Value);
end;
procedure TdSubs.AddRecord(recSub : TrecSub; andLost,andDis : Boolean);
var ds,dsI : TdSub;
  procedure Set_dSub(r : TrecSub; d : TdSub); begin

    d.IDt:=r.IDt;
    d.AppIdt:=r.AppIdt;
    d.Disable:=r.Disable;
    d.IndInG:=r.IndInG;
    d.Name:=r.Name;
    d.Rem:=r.Rem;
  end;
begin
  if recSub.IDt = 1 then
      recSub.IDt := recSub.IDt;
  ds := nil;
  if (not andDis) and recSub.Disable then Exit;
  ds := GetNodeIdt(recSub.Idt,RootSubs);
  if ds=nil then
  begin
    if recSub.AppIdt=0 Then
        ds := RootSubs.Add
       else begin
         dsI := GetNodeIdt(recSub.AppIdt,RootSubs);
         if dsI<>nil then
            ds := dsI.dSubs.Add
         else if andLost then
            ds := RootSubs.Add;
       end;
  end else begin
    if ds.fAppIdt<> recSub.AppIdt then
    begin
       dsI := GetNodeIdt(recSub.AppIdt,RootSubs);
      if dsI=nil then
      begin
        dsI := Self.Add;
        dsI.IDt:=recSub.AppIdt;
      end;
      ds.Collection := dsI.dSubs
    end;
  end;
  if Assigned(ds) then
     Set_dSub (recSub,ds);
end;

function TdSubs.GetNodeIdt(idt : Integer; ds:TdSubs): TdSub;
var i,f : Integer;
  d : TdSub;
begin
  Result:=nil;
  if ds=nil then ds:= RootSubs;
  for i := 0 to Pred(ds.Count) do begin
    d :=ds[i];
    f:= d.fIDt;
    if f=idt then begin
      Result:=ds[i];
      Break;
    end
    else
    begin
      Result:=GetNodeIdt(idt,ds[i].dSubs);
      if Result<>nil then Break;
    end;
  end;
end;

end.


unit Utils;

interface
uses
  Controls,  SysUtils, Classes, StdCtrls, Forms, FileInfo;    //, ShellApi

function DelSpBefore(s : string) : string;
function StrNotAbz(s : string) : string;
function StrAbz(s : string) : string;
function StrAbz2Sp(s : string) : string;
function DivInt(a:int64;b:Double) : integer;
function FileVersion(): string;
//function FileVersion(AFileName:string): string;
//procedure CheckUpdate(PathUpdate : string;wnd:HWND);
function CropCap(cap:string;crop:Integer):string;
function StrToFloatC(s : string): Extended;
function StrToIntC(s : string): Integer;
function TimeStr(tm : integer) : string;
function GetVAlg(ind:Integer):TVerticalAlignment ;
function GetAlg(ind:Integer):TAlignment ;
procedure SetCombBoxVAlg(cbb : TComboBox; alg : TVerticalAlignment);
procedure SetCombBoxAlg(cbb : TComboBox; alg : TAlignment);
procedure SetCombBoxBvl(cbb : TComboBox; bvl : TBevelCut);
function GetBvl(ind:Integer): TBevelCut;

procedure StrToStrings(S, Sep: string; const List: TStrings; const AllowEmptyString: Boolean = True);

implementation

{function}
function CropCap(cap:string;crop:Integer):string;
begin
  if Length(cap)>crop then  Result:=Copy(cap,0,crop)+'...'
    else Result:=cap;
end;

function DelSpBefore(s : string) : string;
var I : Integer;
begin
  I:=0;
    while (I <= Length(S)) and (S[I] = ' ') do Inc(I);
//  if I>0 then

end;
function StrAbz2Sp(s : string) : string;
begin
  Result:=StringReplace(s,chr(13)+chr(10),' ',[rfReplaceAll]);
end;
function StrNotAbz(s : string) : string;
begin
  Result:=StringReplace(s,chr(13)+chr(10),chr(153),[rfReplaceAll]);
end;
function StrAbz(s : string) : string;
begin
  Result:=StringReplace(s,chr(153),chr(13)+chr(10),[rfReplaceAll]);
end;
function DivInt(a:int64;b:Double) : integer;
var c : integer;
begin
  c:=round(a/b);
  if c>a/b then c:=c-1;
  DivInt:=c;
end;

// --------------------------------------------------------------------------
//  Нахождение версии программы
// --------------------------------------------------------------------------
function FileVersion: string;
var
  FileVerInfo: TFileVersionInfo;
begin
  // получение версии файла
 FileVerInfo:=TFileVersionInfo.Create(nil);
 try
   FileVerInfo.ReadFileInfo;
   Result := FileVerInfo.VersionStrings.Values['FileVersion'];
 finally
//   FileVerInfo.Free;
 end;
end;

//function FileVersion(AFileName:string): string;
//var
//  szName: array[0..255] of Char;
//  P: Pointer;
//  Value: Pointer;
//  Len: UINT;
//  GetTranslationString:string;
//  FFileName: PChar;
//  FValid:boolean;
//  FSize: DWORD;
//  FHandle: DWORD;
//  FBuffer: PChar;
//begin
//  try
//    FFileName := StrPCopy(StrAlloc(Length(AFileName) + 1), AFileName);
//    FValid := False;
//    FSize := GetFileVersionInfoSize(FFileName, FHandle);
//    if FSize > 0 then
//      try
//        GetMem(FBuffer, FSize);
//        FValid := GetFileVersionInfo(FFileName, FHandle, FSize, FBuffer);
//      except
//        FValid := False;
//        raise;
//      end;
//    Result := '';
//    if FValid then
//      VerQueryValue(FBuffer, '\VarFileInfo\Translation', p, Len)
//    else p := nil;
//    if P <> nil then
//      GetTranslationString := IntToHex(MakeLong(HiWord(Longint(P^)), LoWord(Longint(P^))), 8);
//    if FValid then
//      begin
//        StrPCopy(szName, '\StringFileInfo\' + GetTranslationString + '\FileVersion');
//        if VerQueryValue(FBuffer, szName, Value, Len) then
//          Result := StrPas(PChar(Value));
//      end;
//  finally
//    try
//      if FBuffer <> nil then FreeMem(FBuffer, FSize);
//    except
//    end;
//    try
//      StrDispose(FFileName);
//    except
//    end;
//  end;
//end;

//procedure FileUpdate(Name_exe:string;Name_exe_new:string;wnd:HWND);
//var
//  f: textFile;
//  FileName,FileNameBak : string;
//  s,s1:string;
//begin
//    FileName := changefileext(paramstr(0), '.cmd');
//    FileNameBak := changefileext(paramstr(0), '.bak');
//    assignFile(f, FileName);
//    rewrite(f);
//    s:='Copy "'+Name_exe+'" "' + FileNameBak+'" /Y'+chr(13)+chr(10);
//    s:=s+':1'+chr(13)+chr(10);
//    s:=s+format('Erase "%s"', [paramstr(0)])+chr(13)+chr(10);
//    s:=s+format('If exist "%s" Goto 1', [paramstr(0)])+chr(13)+chr(10);
//    s:=s+'Copy "'+Name_exe_new+'" "' + Name_exe+'" /Y'+chr(13)+chr(10);
//    s:=s+'"'+Name_exe+'"'+chr(13)+chr(10);
//    s:=s+format('Erase "%s"', [FileName])+chr(13)+chr(10);
//    SetLength(s1, Length(S));
//    CharToOem(PChar(s),PChar(s1));
//    writeln(f, s1);
//    closefile(f);
//    ShellExecute(wnd, 'Open', PChar(FileName), nil, nil, sw_hide);
//    Application.Terminate;
//end;

//procedure CheckUpdate(PathUpdate : string;wnd:HWND);
//var
//  s,fileN : string;
//  Lst : TStrings;
//  i : integer;
//  ver_s, ver_s_new : string;
//  ver_d, ver_d_new : Double;
//  Name_exe,Name_exe_new : string;
//begin
//  GetDir(0,fileN);
// DeleteFile(fileN+'\*.bat');
// DeleteFile(fileN+'\*.cmd');
//  Name_exe := Application.ExeName;
//  s := ExtractFileName(Name_exe);
//    if not DirectoryExists(fileN+PathUpdate) then
//      if not CreateDir(fileN+PathUpdate) then
//        Exception.Create('Неудалось создать каталог '+fileN+PathUpdate);
//  Name_exe_new := PathUpdate+'\'+ChangeFileExt(s, '.exe');
//  if not FileExists(Name_exe_new) then Exit;
//  ver_s := FileVersion(Name_exe);
//  ver_s_new := FileVersion(Name_exe_new);
//  Lst:= TStringList.Create;
//  StrToStrings(ver_s,'.',Lst); ver_d :=0;
//  for i :=1 to Lst.Count do ver_d:= ver_d*1000+strtoint(Lst[i-1]);
//  Lst.Clear;
//  StrToStrings(ver_s_new,'.',Lst); ver_d_new :=0;
//  for i :=1 to Lst.Count do ver_d_new:= ver_d_new*1000+strtoint(Lst[i-1]);
//  Lst.Free;
//  if ver_d_new>ver_d then     //обновляемся
//    FileUpdate(Name_exe,Name_exe_new,wnd);
//end;

function GetBvl(ind:Integer): TBevelCut;
begin
  case ind of
   0: Result:=bvLowered;
   1: Result:=bvNone;
   2: Result:=bvRaised;
   3: Result:=bvSpace;
  end;

end;
procedure SetCombBoxBvl(cbb : TComboBox; bvl : TBevelCut);
begin
  case bvl of
    bvLowered: cbb.ItemIndex:=0;
    bvNone: cbb.ItemIndex:=1;
    bvRaised: cbb.ItemIndex:=2;
    bvSpace: cbb.ItemIndex:=3;
  end;
end;
procedure SetCombBoxAlg(cbb : TComboBox; alg : TAlignment);
begin
  case alg of
    taLeftJustify : cbb.ItemIndex:=0;
    taRightJustify : cbb.ItemIndex:=1;
    taCenter: cbb.ItemIndex:=2;
  end;
end;
procedure SetCombBoxVAlg(cbb : TComboBox; alg : TVerticalAlignment);
begin
  case alg of
    taAlignTop : cbb.ItemIndex:=0;
    taAlignBottom : cbb.ItemIndex:=1;
    taVerticalCenter : cbb.ItemIndex:=2;
  end;
end;
function GetAlg(ind:Integer):TAlignment ;
begin
  case ind of
    0: Result:=taLeftJustify;
    1: Result:=taRightJustify;
    2: Result:=taCenter;
  end;
end;
function GetVAlg(ind:Integer):TVerticalAlignment ;
begin
  case ind of
    0: Result:=taAlignTop;
    1: Result:=taAlignBottom;
    2: Result:=taVerticalCenter;
  end;
end;
function TimeStr(tm : integer) : string;
var hr,mnt : integer;
    hrs,mnts : string;
begin
  hr:=Abs(tm) div 60; mnt:=Abs(tm) mod 60;
  hrs:=inttostr(hr);mnts:=inttostr(mnt);
  if hr<10 then hrs:='0'+inttostr(hr);
  if mnt<10 then mnts:='0'+inttostr(mnt);
  TimeStr:=hrs+':'+mnts;
end;

function StrToIntC(s : string): Integer;
begin
  if s<>'' then Result:=StrToInt(s)
  else Result:=0;
end;

function StrToFloatC(s : string): Extended;
begin
  if s<>'' then Result:=StrToFloat(s)
  else Result:=0;
end;

function StrLeft(const S: string; Count: Integer): string;
begin
  Result := Copy(S, 1, Count);
end;

procedure StrToStrings(S, Sep: string; const List: TStrings; const AllowEmptyString: Boolean = True);
var
  I, L: Integer;
  Left: string;
begin
  Assert(List <> nil);
  List.BeginUpdate;
  try
    List.Clear;
    L := Length(Sep);
    I := Pos(Sep, S);
    while I > 0 do
    begin
      Left := StrLeft(S, I - 1);
      if (Left <> '') or AllowEmptyString then
        List.Add(Left);
      Delete(S, 1, I + L - 1);
      I := Pos(Sep, S);
    end;
    if (S <> '') or AllowEmptyString then
      List.Add(S);  // Ignore empty strings at the end (only if AllowEmptyString = False).
  finally
    List.EndUpdate;
  end;
end;

end.

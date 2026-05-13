unit XMLSer;

interface
uses
  Classes, SysUtils, TypInfo, Controls,ExtCtrls;

type
  TshXMLSerializer = class;
  EshXMLSerializerException = class(Exception);
  XMLSerializerException = class(Exception);
  EshXMLOpenTagNotFoundException = class(XMLSerializerException);
  EshXMLCloseTagNotFoundException = class(XMLSerializerException);
  EshXMLUnknownPropertyException = class(XMLSerializerException);

  TshXMLSerializerException = class of XMLSerializerException;

  TshXMLSerializer = class(TPersistent)
  private
//    Buffer: PChar;
//    BufferEnd: PChar;
//    BufferLength: DWORD;
//    TokenPtr : PChar;
//    ParentBs,ParentBe: PChar;
    OutStream: TStream;
//    procedure Check(Expr: Boolean; const Msg: string; E: TshXMLSerializerException);
    procedure WriteOutStream(const Value: string);
  protected
    procedure SerializeInternal(Component: TObject; Level: Integer = 1);
  public
    DefaultXMLHeader: string;
    tickCounter: DWORD;
    tickCount: DWORD;
    procedure Serialize(Component: TObject; Stream: TStream);
  published
  end;

implementation
//uses
//  JvResources, JvgUtils;

const
  ORDINAL_TYPES = [tkInteger, tkChar, tkEnumeration, tkSet];

var
  TAB: string;
  CR: string;
//  flE : Bool;

function DupStr(const Str: string; Count: Integer): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Count do
    Result := Result + Str;
end;


{TshXMLSerializer}

//{ пишет строку в выходящий поток. Исп-ся при сериализации }
procedure TshXMLSerializer.WriteOutStream(const Value: string);
var
  AnsiValue: AnsiString;
begin
  if Value <> '' then
  begin
    AnsiValue := AnsiString(Value);
    OutStream.Write(AnsiValue[1], Length(AnsiValue));
  end;
end;

procedure TshXMLSerializer.Serialize(Component: TObject; Stream: TStream);
var
  Result: string;
begin
  TAB :=  #9;
  CR := #13#10;
//  Result := '<?xml version="1.0" encoding="windows-1251"?>';
  Result := '<?xml version="1.0"?>';
  OutStream := Stream;
  WriteOutStream(Result);
  WriteOutStream(CR + '<' + Component.ClassName + '>');
  SerializeInternal(Component);
  WriteOutStream(CR + '</' + Component.ClassName + '>');
end;

procedure TshXMLSerializer.SerializeInternal(Component: TObject; Level: Integer = 1);
var
  PropInfo: PPropInfo;
  TypeInf, PropTypeInf: PTypeInfo;
  TypeData,TypeDataIn: PTypeData;
  I, J: Integer;
  AName, PropName, sPropValue: string;
  PropList: PPropList;
  NumProps,NumPropsIn: Word;
  PropObject: TObject;
  cntColIt : Integer;
  //{ Добавляет открывающий тег с заданным именем }
  procedure addOpenTag(const Value: string);
  begin
    WriteOutStream(CR + DupStr(TAB, Level) + '<' + Value + '>');
    Inc(Level);
  end;

  //{ Добавляет закрывающий тег с заданным именем }
  procedure addCloseTag(const Value: string; AddBreak: Boolean = False);
  begin
    Dec(Level);
    if AddBreak then
      WriteOutStream(CR + DupStr(TAB, Level));
    WriteOutStream('</' + Value + '>');
  end;

  //{ Добавляет значение в результирующую строку }
  procedure addValue(const Value: string);
  begin
    WriteOutStream(Value);
  end;

begin
  { Playing with RTTI }
  TypeInf := Component.ClassInfo;
  AName := {$IFDEF SUPPORTS_UNICODE}UTF8ToString{$ENDIF SUPPORTS_UNICODE}(TypeInf^.Name);
  TypeData := GetTypeData(TypeInf);
  NumProps := TypeData^.PropCount;

  GetMem(PropList, NumProps * SizeOf(Pointer));
  try
    //{ Получаем список свойств }
    GetPropInfos(TypeInf, PropList);

    for I := 0 to NumProps - 1 do
    begin
      PropName := {$IFDEF SUPPORTS_UNICODE}UTF8ToString{$ENDIF SUPPORTS_UNICODE}(PropList^[I]^.Name);

//      PropTypeInf := PropList^[I]^.PropType^;
      PropInfo := PropList^[I];
      PropTypeInf := PropInfo.PropType;

      //{ Хочет ли свойство, чтобы его сохранили ? }
      if not IsStoredProp(Component, PropInfo) then
        Continue;

      case PropTypeInf^.Kind of
        tkInteger, tkInt64, tkChar, tkEnumeration, tkFloat, tkString, tkSet,
        {$IFDEF UNICODE} tkUString, {$ENDIF}
        tkWChar, tkLString, tkWString, tkVariant:
          begin
            //{ Получение значения свойства }
            sPropValue := GetPropValue(Component, PropName, True);

            //{ Проверяем на пустое значение и значение по умолчанию }
            { Checking if value is empty or is default  [translated] }
            if (sPropValue = '') then  Continue;

            if (PropTypeInf^.Kind in ORDINAL_TYPES) and (sPropValue = IntToStr(PropInfo.Default)) then Continue;
            if (((sPropValue = 'True') and (PropInfo.Default=1))
            or ((sPropValue = 'False') and (PropInfo.Default=0))) then Continue;
            if (PropTypeInf^.Kind =tkEnumeration) and (PropInfo.Default>=0)then
             if sPropValue=GetEnumName(PropTypeInf,PropInfo.Default) then
              Continue;
            if (PropTypeInf^.Kind =tkFloat) and (sPropValue='0')then Continue;
            //{ Замена спецсимволов }
            { special characters placeholders  [translated] }
//            if FReplaceReservedSymbols then
//            begin
              sPropValue := StringReplace(sPropValue, '<', '&lt;', [rfReplaceAll]);
              sPropValue := StringReplace(sPropValue, '>', '&gt;', [rfReplaceAll]);
              // sPropValue := StringReplace(sPropValue, '&', '&', [rfReplaceAll]);
//            end;
            //{ Перевод в XML }
            addOpenTag(PropName);
            //{ Добавляем значение свойства в результат }
            addValue(sPropValue);
            addCloseTag(PropName);
          end;
        tkClass:
          //{ Для классовых типов рекурсивная обработка }
          begin
            PropObject := GetObjectProp(Component, PropInfo);
            if Assigned(PropObject) then
            begin
              //{ Для дочерних свойств-классов - рекурсивный вызов }
              //{ Индивидуальный подход к некоторым классам }
              if PropObject is TStrings then
              begin
                addOpenTag(PropName);
                sPropValue:=TStrings(PropObject).CommaText;
                sPropValue := StringReplace(sPropValue, '<', '&lt;', [rfReplaceAll]);
                sPropValue := StringReplace(sPropValue, '>', '&gt;', [rfReplaceAll]);
                WriteOutStream(sPropValue);
                addCloseTag(PropName, True);
              end
              else
              if PropObject is TCollection then
              begin
                TypeDataIn := GetTypeData(PropObject.ClassInfo);
                NumPropsIn := TypeDataIn^.PropCount;
                cntColIt := TCollection(PropObject).Count;

                if (cntColIt = 0) and (NumPropsIn=0) then
                   Continue;
                  addOpenTag(PropName);
                SerializeInternal(PropObject, Level);
                for J := 0 to (PropObject as TCollection).Count - 1 do
                begin
                  //{ Контейнерный тег по имени класса }
                  addOpenTag(TCollection(PropObject).Items[J].ClassName);
                  SerializeInternal(TCollection(PropObject).Items[J], Level);
                  addCloseTag(TCollection(PropObject).Items[J].ClassName, True);
                end;
                  addCloseTag(PropName, True);
              end
              else
              if PropObject is TPersistent then
              begin
                addOpenTag(PropName);
                SerializeInternal(PropObject, Level);
                addCloseTag(PropName, True);
              end;
              //{ Здесь можно добавить обработку остальных классов: TTreeNodes, TListItems }
            end;
            //{ После обработки свойств закрываем тег объекта }
          end;
      end;
    end;
  finally
    FreeMem(PropList, NumProps * SizeOf(Pointer));
  end;
end;


end.

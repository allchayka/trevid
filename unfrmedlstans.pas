unit unFrmEdLstAns;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Grids, rImgss;

type


  { TFrmEdLstAns }

  TFrmEdLstAns = class(TForm)
    btn1: TButton;
    btn2: TButton;
    Button1: TButton;
    butDel: TButton;
    Button2: TButton;
    mmo1: TMemo;
    mmoTxt: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    grdAnsvs: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure btn2Click(Sender: TObject);
    procedure butDelClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdAnsvsEditingDone(Sender: TObject);
    procedure grdAnsvsExit(Sender: TObject);
  private
     procedure GridToMemo();
  public
    procedure Edit(lstAns : TrAnsTxt);
  end;

var
  FrmEdLstAns: TFrmEdLstAns;
  TextLstAns : string;
  flOK : Boolean;

implementation

{$R *.lfm}

{ TFrmEdLstAns }

procedure TFrmEdLstAns.FormCreate(Sender: TObject);
begin
  grdAnsvs.ColCount:=3;
  grdAnsvs.ColWidths[0]:=20; grdAnsvs.ColWidths[1]:=50; grdAnsvs.ColWidths[2]:=500;
end;

procedure TFrmEdLstAns.grdAnsvsEditingDone(Sender: TObject);
begin
  GridToMemo;
end;

procedure TFrmEdLstAns.grdAnsvsExit(Sender: TObject);
begin
  GridToMemo;
end;

procedure TFrmEdLstAns.btn2Click(Sender: TObject);
begin
  flOK:=False;
  Close;
end;

procedure TFrmEdLstAns.butDelClick(Sender: TObject);
var i : Integer;
begin
   if grdAnsvs.Row=0 then Exit;
   if grdAnsvs.RowCount>2 then
   grdAnsvs.DeleteRow(grdAnsvs.Row)
   else if grdAnsvs.RowCount>1 then
   grdAnsvs.Rows[grdAnsvs.Row].Text:='';
   for i:=1 to grdAnsvs.RowCount do grdAnsvs.Cells[0,i]:=IntToStr(i);
  GridToMemo;
end;

procedure TFrmEdLstAns.Button1Click(Sender: TObject);
begin
  if (grdAnsvs.Cells[1,grdAnsvs.RowCount-1]='') and (grdAnsvs.RowCount=2) then

  else
  begin
    grdAnsvs.RowCount:=grdAnsvs.RowCount+1;
  end;
  grdAnsvs.Cells[0,grdAnsvs.RowCount-1]:=IntToStr(grdAnsvs.RowCount-1);
  grdAnsvs.Cells[1,grdAnsvs.RowCount-1]:=IntToStr(grdAnsvs.RowCount-1);
  grdAnsvs.Cells[2,grdAnsvs.RowCount-1]:='Ответ';
  GridToMemo;
end;

procedure TFrmEdLstAns.Button2Click(Sender: TObject);
var i : Integer;
begin
  if mmoTxt.Lines.Count=0 then Exit;
  for i:=0 to mmoTxt.Lines.Count-1 do
  begin
    if (grdAnsvs.Cells[1,grdAnsvs.RowCount-1]='') and (grdAnsvs.RowCount=2) then
    else grdAnsvs.RowCount:=grdAnsvs.RowCount+1;
    grdAnsvs.Cells[0,grdAnsvs.RowCount-1]:=IntToStr(grdAnsvs.RowCount-1);
    grdAnsvs.Cells[1,grdAnsvs.RowCount-1]:=IntToStr(grdAnsvs.RowCount-1);
    grdAnsvs.Cells[2,grdAnsvs.RowCount-1]:=mmoTxt.Lines[i];
  end;
  GridToMemo;
end;

procedure TFrmEdLstAns.GridToMemo();
var Ss: TStringStream;
  s: string;
begin
  s:='';
  Ss := TStringStream.Create(s);
  try
    grdAnsvs.SaveToCSVStream(Ss);
    mmo1.Lines.Text:=Ss.DataString;
    mmo1.Lines.Delete(0);
  finally
    Ss.Free;
  end;
  mmo1.ReadOnly:=True;

end;

procedure TFrmEdLstAns.Edit(lstAns : TrAnsTxt);
var Ss: TStringStream;
  s: string;
begin
  s := '"№",'+'"Порядок",'+'"Текст"'+#13+#10;
  s:=s+lstAns.Ans.Text;
  Ss := TStringStream.Create(s);
  grdAnsvs.LoadFromCSVStream(Ss);
  mmo1.Lines.Text:=lstAns.Ans.Text;

  if ShowModal = mrOk then
  begin
    lstAns.Ans.Text:=mmo1.Lines.Text;
  end;
end;

end.


unit UnFrameTopic;

{$mode Delphi}

interface

uses
  LMessages, LCLIntf, Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, JvgListBox,
  UnTreeTopic, unMessage;

type

  { TFrameTopic }

  TFrameTopic = class(TFrame)
    LstTopic: TJvgListBox;
    procedure LstTopicDblClick(Sender: TObject);
    procedure LstTopicMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    function FillLstTopic(iNode : TdSub) : Boolean;
  public
    ParentForm : TForm;
    TreeSub : TdSubs;
    curNode : TdSub;
    CurIDt : Integer;
    procedure Init();
  end;

implementation

{$R *.lfm}

{ TFrameTopic }
function TFrameTopic.FillLstTopic(iNode : TdSub) : Boolean;
var i,cnt : Integer;
  s : String;
  pNode : TdSub;
begin
    if iNode=nil then
    begin
      cnt := TreeSub.Count -1;
      LstTopic.Clear;
      for i := 0 to cnt do
      begin
//        s := IntToStr(TreeSub[i].IDt)+','+IntToStr(TreeSub[i].AppIdt)+','+IntToStr(TreeSub[i].IndInG)+','+TreeSub[i].Name;
        s := TreeSub[i].Name;
        LstTopic.AddItem(s,TreeSub[i]);
      end;
      Result := True;
    end else
    begin
      if iNode.Subs.Count = 0 then
      begin
        Result := False;
      end
      else
      begin
        LstTopic.Clear;
        pNode := TreeSub.GetNodeIdt(iNode.AppIdt,nil);
        if pNode=nil then
        LstTopic.AddItem('...',pNode)
          else LstTopic.AddItem(IntToStr(pNode.IDt)+','+'...',pNode);

        for i := 0 to Pred(iNode.Subs.Count) do
        begin
          s := IntToStr(iNode.Subs[i].IDt)+','+IntToStr(iNode.Subs[i].AppIdt)+','+IntToStr(iNode.Subs[i].IndInG)+','+iNode.Subs[i].Name;
          LstTopic.AddItem(s,iNode.Subs[i]);
        end;
        Result := True;
      end;
    end;
    curNode := iNode;
//    LstTopic.Sorted:=True;
//    LstTopic.Sorted:=False;
end;

procedure TFrameTopic.Init();
begin
  FillLstTopic(nil);
end;

procedure TFrameTopic.LstTopicMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var ItemUnderMouse:integer;
begin
  ItemUnderMouse:=LstTopic.ItemAtPos(Point(X,Y),true);
  if (ItemUnderMouse>-1) and (ItemUnderMouse<LstTopic.Count) then
    begin
      // Create a unique hint for the item we're above
      LstTopic.Hint := LstTopic.Items[ItemUnderMouse];
    end
  else
    LstTopic.Hint:='This is a listbox and you are not hovering an item';
  Application.ActivateHint(ClientToScreen(Point(X,Y)));
end;

procedure TFrameTopic.LstTopicDblClick(Sender: TObject);
var iNode : TdSub;
begin
     iNode := TdSub(LstTopic.SelectedObject);
     if not FillLstTopic(iNode) then
     SendMessage(ParentForm.Handle, WM_MY_MESSAGE,iNode.IDt,0);
end;

end.


unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    FontDialog: TFontDialog;
    ImageList1: TImageList;
    TaskListBox: TListBox;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure FontDialogApplyClicked(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FinalSave(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolBar1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
  private
    { private declarations }
    HasChanged: Boolean;
    function GetTaskFileName: string;
  protected
    {procedure Loaded; override;}
  public
    { public declarations }
    procedure LoadFromFile;
    procedure SaveToFile;
    property TaskFileName: string read GetTaskFileName;
  end;

var
  Form1: TForm1;

implementation

uses Patch, FormEx, About, Config, Streaming2;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
begin

end;

procedure TForm1.ToolBar1Click(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  LoadFromFile;
  FormAdjust(Self);
end;

procedure TForm1.FinalSave(Sender: TObject);
begin
  if HasChanged then SaveToFile;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FinalSave(Sender)
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if not AppConfig.LicenseAgreement then AboutBox.ShowModal
end;

procedure TForm1.FormChangeBounds(Sender: TObject);
begin
  HasChanged := True;
end;

procedure TForm1.FontDialogApplyClicked(Sender: TObject);
begin
  TaskListBox.Font := FontDialog.Font;
  HasChanged := True
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  FinalSave(Sender)
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  TaskListBox.Items.Insert(0, InputBox('Neue Aufgabe', '', 'Text ersetzen'));
  HasChanged := True
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
var alt, neu: Integer;
begin
  alt := TaskListBox.ItemIndex;
  if (alt >= 0) then begin
    neu := alt + 1;
    if neu < TaskListBox.Items.Count then begin
      TaskListBox.Items.Move(alt, neu);
      TaskListBox.ItemIndex := neu;
      HasChanged := True
    end
  end
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
var alt, neu: Integer;
begin
  alt := TaskListBox.ItemIndex;
  if alt > 0 then begin
    neu := alt - 1;
    TaskListBox.Items.Move(alt, neu);
    TaskListBox.ItemIndex := neu;
    HasChanged := True
  end;
end;

procedure TForm1.ToolButton5Click(Sender: TObject);
begin
  TaskListBox.Items.Delete(TaskListBox.ItemIndex);
  HasChanged := True;
end;

procedure TForm1.ToolButton6Click(Sender: TObject);
begin
  AboutBox.ShowModal
end;

procedure TForm1.ToolButton8Click(Sender: TObject);
begin
  FontDialog.Font := TaskListBox.Font;
  if FontDialog.Execute then begin
    TaskListBox.Font := FontDialog.Font;
    HasChanged := True
  end;
end;

procedure TForm1.ToolButton9Click(Sender: TObject);
begin
  with TaskListBox do
    if ItemIndex >= 0 then
      Items[ItemIndex] := InputBox('Aufgabe bearbeiten', '', Items[ItemIndex])
  else ShowMessage('Kein Eintrag ist zum Bearbeiten ausgewählt.')
end;

function TForm1.GetTaskFileName: string;
begin
  Result := BuildFileName(AppConfig.Dir, 'todo.res')
end;

procedure TForm1.LoadFromFile;
var
  S: TFileStream;
  SavedForm: TForm1;
begin
  if FileExists(TaskFileName) then begin
    if AppConfig.FileExists then begin
      Left := AppConfig.Left;
      Top := AppConfig.Top;
      Width := AppConfig.Width;
      Height := AppConfig.Height;
      BorderStyle := bsSizeable;
    end;
    S := TFileStream.Create(TaskFileName, fmOpenRead);
    try
      ReadBinaryFromStream(S, TComponent(TaskListBox));
      HasChanged := False
    finally
      S.Free
    end;
  end;
end;

procedure TForm1.SaveToFile;
var
  S: TFileStream;
begin
  if HasChanged then begin
    S := TFileStream.Create(TaskFileName, fmCreate);
    try
      AppConfig.Left := Left;
      AppConfig.Top := Top;
      AppConfig.Width := Width;
      AppConfig.Height := Height;
      WriteBinaryToStream(S, TaskListBox);
      HasChanged := False
    finally
      S.Free
    end;
  end;
end;

initialization

end.


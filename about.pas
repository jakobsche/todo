unit About;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls;

type

  { TAboutBox }

  TAboutBox = class(TForm)
    AgreementBox: TCheckBox;
    Button1: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    ImageList: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    ScrollBox3: TScrollBox;
    procedure AgreementBoxChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label3ChangeBounds(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

uses Config, Unit1;

{$R *.lfm}

{ TAboutBox }

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  AgreementBox.Checked := AppConfig.LicenseAgreement;
end;

procedure TAboutBox.AgreementBoxChange(Sender: TObject);
begin
  AppConfig.LicenseAgreement := AgreementBox.Checked
end;

procedure TAboutBox.Button1Click(Sender: TObject);
begin
  Close
end;

procedure TAboutBox.FormActivate(Sender: TObject);
begin

end;

procedure TAboutBox.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if not AgreementBox.Checked then Form1.Close
end;

procedure TAboutBox.FormResize(Sender: TObject);
begin

end;

procedure TAboutBox.FormShow(Sender: TObject);
begin

end;

procedure TAboutBox.Label1Click(Sender: TObject);
begin

end;

procedure TAboutBox.Label3ChangeBounds(Sender: TObject);
begin
  Label3.OptimalFill := True
end;

procedure TAboutBox.ToolButton1Click(Sender: TObject);
begin
  Paint
end;

end.


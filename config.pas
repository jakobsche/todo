unit Config;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

type

  { TAppConfig }

  TAppConfig = class(TComponent)
  private
    FHasChanged: Boolean;
    FHeight: Integer;
    FLeft: Integer;
    FLicenseAgreement: Boolean;
    FTop: Integer;
    FWidth: Integer;
    function GetDir: string;
    function GetFileExists: Boolean;
    function GetFileName: string;
    procedure SetHeight(AValue: Integer);
    procedure SetLeft(AValue: Integer);
    procedure SetLicenseAgreement(AValue: Boolean);
    procedure SetTop(AValue: Integer);
    procedure SetWidth(AValue: Integer);
  public
    constructor Create(AnOwner: TComponent); override;
    destructor Destroy; override;
    property Dir: string read GetDir;
    property FileName: string read GetFileName;
    property HasChanged: Boolean read FHasChanged;
    property FileExists: Boolean read GetFileExists;
  published
    property Left: Integer read FLeft write SetLeft;
    property Top: Integer read FTop write SetTop;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property LicenseAgreement: Boolean read FLicenseAgreement write SetLicenseAgreement;
  end;

var
  AppConfig: TAppConfig;

implementation

uses Patch, Streaming2, Unit1;

function TAppConfig.GetDir: string;
begin
  Result := SysUtils.GetAppConfigDir(False);
  ForceDirectories(Result)
end;

function TAppConfig.GetFileExists: Boolean;
begin
  Result := SysUtils.FileExists(FileName)
end;

function TAppConfig.GetFileName: string;
begin
  Result := BuildFileName(Dir, 'config')
end;

procedure TAppConfig.SetHeight(AValue: Integer);
begin
  if FHeight=AValue then Exit;
  FHeight:=AValue;
  FHasChanged := True
end;

procedure TAppConfig.SetLeft(AValue: Integer);
begin
  if FLeft=AValue then Exit;
  FLeft:=AValue;
  FHasChanged := True
end;

procedure TAppConfig.SetLicenseAgreement(AValue: Boolean);
begin
  if FLicenseAgreement=AValue then Exit;
  FLicenseAgreement:=AValue;
  FHasChanged := True
end;

procedure TAppConfig.SetTop(AValue: Integer);
begin
  if FTop=AValue then Exit;
  FTop:=AValue;
  FHasChanged := True
end;

procedure TAppConfig.SetWidth(AValue: Integer);
begin
  if FWidth=AValue then Exit;
  FWidth:=AValue;
  FHasChanged := True
end;

constructor TAppConfig.Create(AnOwner: TComponent);
var
  S: TFileStream;
begin
  inherited Create(AnOwner);
  if FileExists then begin
    S := TFileStream.Create(FileName, fmOpenRead);
    try
      try
        ReadBinaryFromStream(S, TComponent(Self));
      except
        on EReadError do DeleteFile(FileName);
      end;
      FHasChanged := False
    finally
      S.Free
    end;
  end;
end;

destructor TAppConfig.Destroy;
var
  S: TFileStream;
begin
  if HasChanged then begin
    S := TFileStream.Create(FileName, fmCreate);
    try
      WriteBinaryToStream(S, Self);
      FHasChanged := False
    finally
      S.Free
    end;
  end;
  inherited Destroy
end;

initialization

AppConfig := TAppConfig.Create(nil);

finalization

AppConfig.Free;

end.


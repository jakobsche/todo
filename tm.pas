unit TM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TTaskListManager }

  TTask = class(TComponent)
  private
    FCaption: string;
    FPosition: Integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  published
    property Caption: string read FCaption write FCaption;
    property Position: Integer read FPosition write FPosition;
  end;

  TTaskListManager = class;

  { TTaskStrings }

  TTaskStrings = class(TStrings)
  {liefert die Taskliste als TStrings-kompatibles Objekt}
  private
    FManager: TTaskListManager;
    property Manager: TTaskListManager read FManager write FManager;
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
  end;

  TTaskListManager = class(TComponent)
  private
    FTaskList: TList;
    FList: TTaskStrings;
    function GetTaskList: TList;
  private
    function GetList: TStrings;
    function GetTaskCount: Integer;
    function GetTasks(AnIndex: Integer): TTask;
    procedure SetList(AValue: TStrings);
    procedure SetTasks(AnIndex: Integer; AValue: TTask);
    property TaskList: TList read GetTaskList;
  public
    destructor Destroy; override;
    property TaskCount: Integer read GetTaskCount;
    property Tasks[AnIndex: Integer]: TTask read GetTasks write SetTasks;
  published
    property List: TStrings read GetList write SetList;
  end;

implementation

{ TTaskStrings }

function TTaskStrings.Get(Index: Integer): string;
begin
  Result := Manager.Tasks[Index].Caption
end;

function TTaskStrings.GetCount: Integer;
begin
  Result := Manager.TaskCount;
end;

{ TTask }

procedure TTask.AssignTo(Dest: TPersistent);
begin
  if Dest is TTask then begin
    TTask(Dest).Caption := Caption;
    TTask(Dest).Position := Position
  end
  else inherited AssignTo(Dest);
end;

{ TTaskListManager }

function TTaskListManager.GetTaskList: TList;
begin
  if not Assigned(FTaskList) then begin
    FTaskList := TList.Create
  end;
  Result := FTaskList
end;

function TTaskListManager.GetList: TStrings;
begin
  if not Assigned(FList) then begin
    FList := TTaskStrings.Create;
    FList.Manager := Self
  end;
  Result := FList
end;

function TTaskListManager.GetTaskCount: Integer;
begin
  if Assigned(FTaskList) then Result := FTaskList.Count
  else Result := 0
end;

function TTaskListManager.GetTasks(AnIndex: Integer): TTask;
begin
  Pointer(Result) := TaskList[AnIndex]
end;

procedure TTaskListManager.SetList(AValue: TStrings);
begin

end;

procedure TTaskListManager.SetTasks(AnIndex: Integer; AValue: TTask);
begin
  TTask(TaskList.Items[AnIndex]).Assign(AValue)
end;

destructor TTaskListManager.Destroy;
begin
  FTaskList.Free;
  inherited Destroy;
end;

end.


unit glRegistry;

interface

uses
  SysUtils, Classes, Registry, Variants, Windows;

type
  TmyValue = record
    mValue: Variant;
    mType: TVarType;
  end;
  TglRegistry = class(TComponent)
  private
    fCompanyName, fProjectName: string;
  protected
    { Protected declarations }
  public
    procedure SaveParam(KEY: HKEY; Name: string; Value: variant;
      ValueType: TVarType);
    function LoadParam(KEY: HKEY; Name: string;
      ValueType: TVarType): TmyValue;
    function CheckExistKey(KEY: HKEY; Name: string): boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CompanyName: string read fCompanyName write fCompanyName;
    property ProjectName: string read fProjectName write fProjectName;
  end;

procedure Register;

implementation

//{$R glRegistry}

procedure Register;
begin
  RegisterComponents('Golden Line', [TglRegistry]);
end;

{ TglRegistry }

function TglRegistry.CheckExistKey(KEY: HKEY; Name: string): boolean;
var
  R: TRegistry;
begin
  result := false;
  R := TRegistry.Create;
  R.RootKey := KEY;
  if R.OpenKey('Software\' + CompanyName + '\' + ProjectName + '\', false) then
    if r.ValueExists(Name) then
      result := true;
end;

constructor TglRegistry.Create(AOwner: TComponent);
begin
  inherited;
  fCompanyName := 'Icarus.Empire';
  fProjectName := 'NewProject';
end;

destructor TglRegistry.Destroy;
begin
  fCompanyName := '';
  fProjectName := '';
  inherited;
end;

function TglRegistry.LoadParam(KEY: HKEY; Name: string;
  ValueType: TVarType): TmyValue;
var
  R: TRegistry;
begin
  R := TRegistry.Create;
  R.RootKey := KEY;
  R.OpenKey('Software\' + CompanyName + '\' + ProjectName + '\', false);
  if not R.ValueExists(Name) then
  begin
    Result.mType := varError;
    exit;
  end;
  Result.mType := ValueType;
  case ValueType of
    varInteger:
      Result.mValue := R.ReadInteger(Name);
    varString:
      Result.mValue := R.ReadString(Name);
    varBoolean:
      Result.mValue := R.ReadBool(Name);
    varDate:
      Result.mValue := R.ReadDateTime(Name);
    varDouble:
      Result.mValue := R.ReadFloat(Name);
  end;
  R.CloseKey;
  R.Free;
end;

procedure TglRegistry.SaveParam(KEY: HKEY; Name: string; Value: variant;
  ValueType: TVarType);
var
  R: TRegistry;
begin
  R := TRegistry.Create;
  R.RootKey := KEY;
  R.OpenKey('Software\' + CompanyName + '\' + ProjectName + '\', true);
  case ValueType of
    varInteger:
      R.WriteInteger(Name, Value);
    varString:
      R.WriteString(Name, Value);
    varBoolean:
      R.WriteBool(Name, Value);
    varDate:
      R.WriteDateTime(Name, Value);
    varDouble:
      R.WriteFloat(Name, Value);
  end;
  R.CloseKey;
  R.Free;
end;

end.


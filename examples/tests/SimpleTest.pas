unit SimpleTest;

interface

type
  TSimpleClass = class
  private
    FName: string;
    FAge: Integer;
  public
    constructor Create(const AName: string; AAge: Integer);
    destructor Destroy; override;
    procedure SetName(const Value: string);
    function GetName: string;
    function IsAdult: Boolean;
    property Name: string read GetName write SetName;
    property Age: Integer read FAge write FAge;
  end;

implementation

constructor TSimpleClass.Create(const AName: string; AAge: Integer);
begin
  inherited Create;
  FName := AName;
  FAge := AAge;
end;

destructor TSimpleClass.Destroy;
begin
  // Clean up resources
  inherited Destroy;
end;

procedure TSimpleClass.SetName(const Value: string);
begin
  if Length(Value) > 0 then
    FName := Value
  else
    raise Exception.Create('Name cannot be empty');
end;

function TSimpleClass.GetName: string;
begin
  Result := FName;
end;

function TSimpleClass.IsAdult: Boolean;
begin
  Result := FAge >= 18;
end;

end.

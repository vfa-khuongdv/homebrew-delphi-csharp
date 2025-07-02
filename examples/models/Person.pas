unit Person;

interface

uses
  SysUtils;

type
  TPerson = class
  private
    FName: String;
    FAge: Integer;
  public
    constructor Create(const AName: String; const AAge: Integer);
    destructor Destroy; override;
    
    function GetFullInfo: String;
    procedure SetAge(const Value: Integer);
    
    property Name: String read FName write FName;
    property Age: Integer read FAge write SetAge;
  end;

implementation

constructor TPerson.Create(const AName: String; const AAge: Integer);
begin
  inherited Create;
  FName := AName;
  FAge := AAge;
end;

destructor TPerson.Destroy;
begin
  inherited Destroy;
end;

function TPerson.GetFullInfo: String;
begin
  Result := Format('%s is %d years old', [FName, FAge]);
end;

procedure TPerson.SetAge(const Value: Integer);
begin
  if Value >= 0 then
    FAge := Value
  else
    raise Exception.Create('Age cannot be negative');
end;

end.

unit CompanyManager;

interface

uses
  SysUtils, Classes,
  utils.StringHelper,
  models.Person,
  Employee;

type
  TCompanyManager = class
  private
    FEmployees: TObjectList;
    FCompanyName: String;
  public
    constructor Create(const ACompanyName: String);
    destructor Destroy; override;
    
    procedure AddEmployee(const AEmployee: TEmployee);
    function GetEmployeeCount: Integer;
    function FindEmployeeById(const AId: String): TEmployee;
    function GetCompanyReport: String;
    procedure RemoveEmployee(const AId: String);
    
    property CompanyName: String read FCompanyName write FCompanyName;
    property Employees: TObjectList read FEmployees;
  end;

implementation

constructor TCompanyManager.Create(const ACompanyName: String);
begin
  inherited Create;
  FCompanyName := TStringHelper.Capitalize(ACompanyName);
  FEmployees := TObjectList.Create(True); // Owns objects
end;

destructor TCompanyManager.Destroy;
begin
  FEmployees.Free;
  inherited Destroy;
end;

procedure TCompanyManager.AddEmployee(const AEmployee: TEmployee);
begin
  if AEmployee = nil then
    raise Exception.Create('Employee cannot be nil');
    
  if FindEmployeeById(AEmployee.EmployeeId) <> nil then
    raise Exception.Create('Employee with this ID already exists');
    
  FEmployees.Add(AEmployee);
end;

function TCompanyManager.GetEmployeeCount: Integer;
begin
  Result := FEmployees.Count;
end;

function TCompanyManager.FindEmployeeById(const AId: String): TEmployee;
var
  I: Integer;
  Employee: TEmployee;
begin
  Result := nil;
  for I := 0 to FEmployees.Count - 1 do
  begin
    Employee := TEmployee(FEmployees[I]);
    if Employee.EmployeeId = AId then
    begin
      Result := Employee;
      Break;
    end;
  end;
end;

function TCompanyManager.GetCompanyReport: String;
var
  I: Integer;
  Employee: TEmployee;
  Report: TStringList;
begin
  Report := TStringList.Create;
  try
    Report.Add(Format('Company: %s', [FCompanyName]));
    Report.Add(Format('Total Employees: %d', [GetEmployeeCount]));
    Report.Add('');
    Report.Add('Employee List:');
    
    for I := 0 to FEmployees.Count - 1 do
    begin
      Employee := TEmployee(FEmployees[I]);
      Report.Add(Format('%d. %s', [I + 1, Employee.GetEmployeeInfo]));
    end;
    
    Result := Report.Text;
  finally
    Report.Free;
  end;
end;

procedure TCompanyManager.RemoveEmployee(const AId: String);
var
  Employee: TEmployee;
begin
  Employee := FindEmployeeById(AId);
  if Employee <> nil then
    FEmployees.Remove(Employee)
  else
    raise Exception.Create('Employee not found');
end;

end.

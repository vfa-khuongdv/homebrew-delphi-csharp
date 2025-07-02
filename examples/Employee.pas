unit Employee;

interface

uses
  SysUtils,
  utils.StringHelper,  // Import từ thư mục utils
  models.Person;       // Import từ thư mục models

type
  TEmployee = class(TPerson)
  private
    FEmployeeId: String;
    FSalary: Double;
    FDepartment: String;
  public
    constructor Create(const AName: String; const AAge: Integer; 
                      const AEmployeeId: String; const ASalary: Double; 
                      const ADepartment: String);
    destructor Destroy; override;
    
    function GetEmployeeInfo: String;
    function GetFormattedSalary: String;
    procedure ValidateEmployeeData;
    
    property EmployeeId: String read FEmployeeId write FEmployeeId;
    property Salary: Double read FSalary write FSalary;
    property Department: String read FDepartment write FDepartment;
  end;

implementation

constructor TEmployee.Create(const AName: String; const AAge: Integer; 
                            const AEmployeeId: String; const ASalary: Double; 
                            const ADepartment: String);
begin
  inherited Create(AName, AAge);
  FEmployeeId := AEmployeeId;
  FSalary := ASalary;
  FDepartment := TStringHelper.Capitalize(ADepartment);
  ValidateEmployeeData;
end;

destructor TEmployee.Destroy;
begin
  inherited Destroy;
end;

function TEmployee.GetEmployeeInfo: String;
begin
  Result := Format('Employee %s (%s) - %s, Age: %d, Salary: %s', 
                   [FEmployeeId, Name, FDepartment, Age, GetFormattedSalary]);
end;

function TEmployee.GetFormattedSalary: String;
begin
  Result := Format('$%.2f', [FSalary]);
end;

procedure TEmployee.ValidateEmployeeData;
begin
  if TStringHelper.IsEmpty(FEmployeeId) then
    raise Exception.Create('Employee ID cannot be empty');
    
  if TStringHelper.IsEmpty(FDepartment) then
    raise Exception.Create('Department cannot be empty');
    
  if FSalary < 0 then
    raise Exception.Create('Salary cannot be negative');
    
  // Validate name using StringHelper
  if TStringHelper.IsEmpty(Name) then
    raise Exception.Create('Employee name cannot be empty');
end;

end.

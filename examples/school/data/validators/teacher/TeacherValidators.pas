unit TeacherValidators;

interface

uses
  System.SysUtils, System.RegularExpressions,
  TeacherModels;

type
  TTeacherValidator = class
  public
    function ValidateTeacher(const ATeacher: TTeacher): Boolean;
    function ValidateTeacherId(const ATeacherId: string): Boolean;
    function ValidateEmail(const AEmail: string): Boolean;
    function ValidatePhoneNumber(const APhoneNumber: string): Boolean;
    function ValidateName(const AName: string): Boolean;
    function ValidateDepartment(const ADepartment: string): Boolean;
    function ValidateSubject(const ASubject: string): Boolean;
    function ValidateSalary(const ASalary: Currency): Boolean;
    function GetValidationErrors(const ATeacher: TTeacher): TArray<string>;
  end;

implementation

function TTeacherValidator.ValidateTeacher(const ATeacher: TTeacher): Boolean;
begin
  Result := Assigned(ATeacher) and
            ValidateTeacherId(ATeacher.TeacherId) and
            ValidateName(ATeacher.FirstName) and
            ValidateName(ATeacher.LastName) and
            ValidateEmail(ATeacher.Email) and
            ValidatePhoneNumber(ATeacher.PhoneNumber) and
            ValidateDepartment(ATeacher.Department) and
            ValidateSubject(ATeacher.Subject) and
            ValidateSalary(ATeacher.Salary) and
            (ATeacher.DateOfBirth < Now) and
            (ATeacher.HireDate <= Now);
end;

function TTeacherValidator.ValidateTeacherId(const ATeacherId: string): Boolean;
begin
  // Teacher ID should be 4-8 characters, alphanumeric, typically starting with 'T'
  Result := (Length(ATeacherId) >= 4) and 
            (Length(ATeacherId) <= 8) and
            TRegEx.IsMatch(ATeacherId, '^[A-Za-z0-9]+$');
end;

function TTeacherValidator.ValidateEmail(const AEmail: string): Boolean;
const
  EmailPattern = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
begin
  Result := (Length(AEmail) > 0) and 
            TRegEx.IsMatch(AEmail, EmailPattern, [roIgnoreCase]);
end;

function TTeacherValidator.ValidatePhoneNumber(const APhoneNumber: string): Boolean;
const
  PhonePattern = '^\+?[1-9]\d{1,14}$'; // Basic international phone number format
begin
  Result := (Length(APhoneNumber) >= 7) and 
            (Length(APhoneNumber) <= 15) and
            TRegEx.IsMatch(APhoneNumber.Replace(' ', '').Replace('-', '').Replace('(', '').Replace(')', ''), PhonePattern);
end;

function TTeacherValidator.ValidateName(const AName: string): Boolean;
begin
  // Name should be 1-50 characters, letters and spaces only
  Result := (Length(AName) >= 1) and 
            (Length(AName) <= 50) and
            TRegEx.IsMatch(AName, '^[A-Za-z\s]+$');
end;

function TTeacherValidator.ValidateDepartment(const ADepartment: string): Boolean;
begin
  // Department should be 2-30 characters
  Result := (Length(ADepartment) >= 2) and (Length(ADepartment) <= 30);
end;

function TTeacherValidator.ValidateSubject(const ASubject: string): Boolean;
begin
  // Subject should be 2-50 characters
  Result := (Length(ASubject) >= 2) and (Length(ASubject) <= 50);
end;

function TTeacherValidator.ValidateSalary(const ASalary: Currency): Boolean;
begin
  // Salary should be positive and reasonable (between $20,000 and $200,000)
  Result := (ASalary >= 20000) and (ASalary <= 200000);
end;

function TTeacherValidator.GetValidationErrors(const ATeacher: TTeacher): TArray<string>;
var
  Errors: TArray<string>;
  ErrorCount: Integer;
begin
  SetLength(Errors, 12); // Maximum possible errors
  ErrorCount := 0;
  
  if not Assigned(ATeacher) then
  begin
    SetLength(Errors, 1);
    Errors[0] := 'Teacher object is nil';
    Exit(Errors);
  end;
  
  if not ValidateTeacherId(ATeacher.TeacherId) then
  begin
    Errors[ErrorCount] := 'Invalid Teacher ID: Must be 4-8 alphanumeric characters';
    Inc(ErrorCount);
  end;
  
  if not ValidateName(ATeacher.FirstName) then
  begin
    Errors[ErrorCount] := 'Invalid First Name: Must be 1-50 characters, letters and spaces only';
    Inc(ErrorCount);
  end;
  
  if not ValidateName(ATeacher.LastName) then
  begin
    Errors[ErrorCount] := 'Invalid Last Name: Must be 1-50 characters, letters and spaces only';
    Inc(ErrorCount);
  end;
  
  if not ValidateEmail(ATeacher.Email) then
  begin
    Errors[ErrorCount] := 'Invalid Email: Must be a valid email format';
    Inc(ErrorCount);
  end;
  
  if not ValidatePhoneNumber(ATeacher.PhoneNumber) then
  begin
    Errors[ErrorCount] := 'Invalid Phone Number: Must be 7-15 digits';
    Inc(ErrorCount);
  end;
  
  if not ValidateDepartment(ATeacher.Department) then
  begin
    Errors[ErrorCount] := 'Invalid Department: Must be 2-30 characters';
    Inc(ErrorCount);
  end;
  
  if not ValidateSubject(ATeacher.Subject) then
  begin
    Errors[ErrorCount] := 'Invalid Subject: Must be 2-50 characters';
    Inc(ErrorCount);
  end;
  
  if not ValidateSalary(ATeacher.Salary) then
  begin
    Errors[ErrorCount] := 'Invalid Salary: Must be between $20,000 and $200,000';
    Inc(ErrorCount);
  end;
  
  if ATeacher.DateOfBirth >= Now then
  begin
    Errors[ErrorCount] := 'Invalid Date of Birth: Must be in the past';
    Inc(ErrorCount);
  end;
  
  if ATeacher.HireDate > Now then
  begin
    Errors[ErrorCount] := 'Invalid Hire Date: Cannot be in the future';
    Inc(ErrorCount);
  end;
  
  if ATeacher.HireDate < ATeacher.DateOfBirth then
  begin
    Errors[ErrorCount] := 'Invalid Hire Date: Cannot be before birth date';
    Inc(ErrorCount);
  end;
  
  SetLength(Errors, ErrorCount);
  Result := Errors;
end;

end.

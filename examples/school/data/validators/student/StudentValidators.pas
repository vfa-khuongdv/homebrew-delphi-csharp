unit StudentValidators;

interface

uses
  System.SysUtils, System.RegularExpressions,
  StudentModels;

type
  TStudentValidator = class
  public
    function ValidateStudent(const AStudent: TStudent): Boolean;
    function ValidateStudentId(const AStudentId: string): Boolean;
    function ValidateEmail(const AEmail: string): Boolean;
    function ValidatePhoneNumber(const APhoneNumber: string): Boolean;
    function ValidateName(const AName: string): Boolean;
    function ValidateGrade(const AGrade: Integer): Boolean;
    function GetValidationErrors(const AStudent: TStudent): TArray<string>;
  end;

implementation

function TStudentValidator.ValidateStudent(const AStudent: TStudent): Boolean;
begin
  Result := Assigned(AStudent) and
            ValidateStudentId(AStudent.StudentId) and
            ValidateName(AStudent.FirstName) and
            ValidateName(AStudent.LastName) and
            ValidateEmail(AStudent.Email) and
            ValidatePhoneNumber(AStudent.PhoneNumber) and
            ValidateGrade(AStudent.Grade) and
            (AStudent.DateOfBirth < Now);
end;

function TStudentValidator.ValidateStudentId(const AStudentId: string): Boolean;
begin
  // Student ID should be 6-10 characters, alphanumeric
  Result := (Length(AStudentId) >= 6) and 
            (Length(AStudentId) <= 10) and
            TRegEx.IsMatch(AStudentId, '^[A-Za-z0-9]+$');
end;

function TStudentValidator.ValidateEmail(const AEmail: string): Boolean;
const
  EmailPattern = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
begin
  Result := (Length(AEmail) > 0) and 
            TRegEx.IsMatch(AEmail, EmailPattern, [roIgnoreCase]);
end;

function TStudentValidator.ValidatePhoneNumber(const APhoneNumber: string): Boolean;
const
  PhonePattern = '^\+?[1-9]\d{1,14}$'; // Basic international phone number format
begin
  Result := (Length(APhoneNumber) >= 7) and 
            (Length(APhoneNumber) <= 15) and
            TRegEx.IsMatch(APhoneNumber.Replace(' ', '').Replace('-', '').Replace('(', '').Replace(')', ''), PhonePattern);
end;

function TStudentValidator.ValidateName(const AName: string): Boolean;
begin
  // Name should be 1-50 characters, letters and spaces only
  Result := (Length(AName) >= 1) and 
            (Length(AName) <= 50) and
            TRegEx.IsMatch(AName, '^[A-Za-z\s]+$');
end;

function TStudentValidator.ValidateGrade(const AGrade: Integer): Boolean;
begin
  // Grade should be between 1 and 12
  Result := (AGrade >= 1) and (AGrade <= 12);
end;

function TStudentValidator.GetValidationErrors(const AStudent: TStudent): TArray<string>;
var
  Errors: TArray<string>;
  ErrorCount: Integer;
begin
  SetLength(Errors, 10); // Maximum possible errors
  ErrorCount := 0;
  
  if not Assigned(AStudent) then
  begin
    SetLength(Errors, 1);
    Errors[0] := 'Student object is nil';
    Exit(Errors);
  end;
  
  if not ValidateStudentId(AStudent.StudentId) then
  begin
    Errors[ErrorCount] := 'Invalid Student ID: Must be 6-10 alphanumeric characters';
    Inc(ErrorCount);
  end;
  
  if not ValidateName(AStudent.FirstName) then
  begin
    Errors[ErrorCount] := 'Invalid First Name: Must be 1-50 characters, letters and spaces only';
    Inc(ErrorCount);
  end;
  
  if not ValidateName(AStudent.LastName) then
  begin
    Errors[ErrorCount] := 'Invalid Last Name: Must be 1-50 characters, letters and spaces only';
    Inc(ErrorCount);
  end;
  
  if not ValidateEmail(AStudent.Email) then
  begin
    Errors[ErrorCount] := 'Invalid Email: Must be a valid email format';
    Inc(ErrorCount);
  end;
  
  if not ValidatePhoneNumber(AStudent.PhoneNumber) then
  begin
    Errors[ErrorCount] := 'Invalid Phone Number: Must be 7-15 digits';
    Inc(ErrorCount);
  end;
  
  if not ValidateGrade(AStudent.Grade) then
  begin
    Errors[ErrorCount] := 'Invalid Grade: Must be between 1 and 12';
    Inc(ErrorCount);
  end;
  
  if AStudent.DateOfBirth >= Now then
  begin
    Errors[ErrorCount] := 'Invalid Date of Birth: Must be in the past';
    Inc(ErrorCount);
  end;
  
  if Trim(AStudent.ClassName) = '' then
  begin
    Errors[ErrorCount] := 'Class Name cannot be empty';
    Inc(ErrorCount);
  end;
  
  SetLength(Errors, ErrorCount);
  Result := Errors;
end;

end.

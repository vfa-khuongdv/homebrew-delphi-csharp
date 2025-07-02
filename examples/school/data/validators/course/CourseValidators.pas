unit CourseValidators;

interface

uses
  System.SysUtils, System.RegularExpressions,
  CourseModels;

type
  TCourseValidator = class
  public
    function ValidateCourse(const ACourse: TCourse): Boolean;
    function ValidateCourseId(const ACourseId: string): Boolean;
    function ValidateCourseName(const ACourseName: string): Boolean;
    function ValidateDepartment(const ADepartment: string): Boolean;
    function ValidateCredits(const ACredits: Integer): Boolean;
    function ValidateMaxEnrollment(const AMaxEnrollment: Integer): Boolean;
    function ValidateSchedule(const ASchedule: string): Boolean;
    function ValidateClassroom(const AClassroom: string): Boolean;
    function GetValidationErrors(const ACourse: TCourse): TArray<string>;
  end;

implementation

function TCourseValidator.ValidateCourse(const ACourse: TCourse): Boolean;
begin
  Result := Assigned(ACourse) and
            ValidateCourseId(ACourse.CourseId) and
            ValidateCourseName(ACourse.CourseName) and
            ValidateDepartment(ACourse.Department) and
            ValidateCredits(ACourse.Credits) and
            ValidateMaxEnrollment(ACourse.MaxEnrollment) and
            ValidateSchedule(ACourse.Schedule) and
            ValidateClassroom(ACourse.Classroom);
end;

function TCourseValidator.ValidateCourseId(const ACourseId: string): Boolean;
begin
  // Course ID should be 6-10 characters, typically format like "CS101", "MATH201"
  Result := (Length(ACourseId) >= 4) and 
            (Length(ACourseId) <= 10) and
            TRegEx.IsMatch(ACourseId, '^[A-Za-z0-9]+$');
end;

function TCourseValidator.ValidateCourseName(const ACourseName: string): Boolean;
begin
  // Course name should be 3-100 characters
  Result := (Length(ACourseName) >= 3) and (Length(ACourseName) <= 100);
end;

function TCourseValidator.ValidateDepartment(const ADepartment: string): Boolean;
begin
  // Department should be 2-30 characters
  Result := (Length(ADepartment) >= 2) and (Length(ADepartment) <= 30);
end;

function TCourseValidator.ValidateCredits(const ACredits: Integer): Boolean;
begin
  // Credits should be between 1 and 6
  Result := (ACredits >= 1) and (ACredits <= 6);
end;

function TCourseValidator.ValidateMaxEnrollment(const AMaxEnrollment: Integer): Boolean;
begin
  // Max enrollment should be between 5 and 500
  Result := (AMaxEnrollment >= 5) and (AMaxEnrollment <= 500);
end;

function TCourseValidator.ValidateSchedule(const ASchedule: string): Boolean;
begin
  // Schedule should not be empty and should be reasonable length
  Result := (Length(ASchedule) >= 5) and (Length(ASchedule) <= 100);
end;

function TCourseValidator.ValidateClassroom(const AClassroom: string): Boolean;
begin
  // Classroom should be 2-20 characters
  Result := (Length(AClassroom) >= 2) and (Length(AClassroom) <= 20);
end;

function TCourseValidator.GetValidationErrors(const ACourse: TCourse): TArray<string>;
var
  Errors: TArray<string>;
  ErrorCount: Integer;
begin
  SetLength(Errors, 10); // Maximum possible errors
  ErrorCount := 0;
  
  if not Assigned(ACourse) then
  begin
    SetLength(Errors, 1);
    Errors[0] := 'Course object is nil';
    Exit(Errors);
  end;
  
  if not ValidateCourseId(ACourse.CourseId) then
  begin
    Errors[ErrorCount] := 'Invalid Course ID: Must be 4-10 alphanumeric characters';
    Inc(ErrorCount);
  end;
  
  if not ValidateCourseName(ACourse.CourseName) then
  begin
    Errors[ErrorCount] := 'Invalid Course Name: Must be 3-100 characters';
    Inc(ErrorCount);
  end;
  
  if not ValidateDepartment(ACourse.Department) then
  begin
    Errors[ErrorCount] := 'Invalid Department: Must be 2-30 characters';
    Inc(ErrorCount);
  end;
  
  if not ValidateCredits(ACourse.Credits) then
  begin
    Errors[ErrorCount] := 'Invalid Credits: Must be between 1 and 6';
    Inc(ErrorCount);
  end;
  
  if not ValidateMaxEnrollment(ACourse.MaxEnrollment) then
  begin
    Errors[ErrorCount] := 'Invalid Max Enrollment: Must be between 5 and 500';
    Inc(ErrorCount);
  end;
  
  if not ValidateSchedule(ACourse.Schedule) then
  begin
    Errors[ErrorCount] := 'Invalid Schedule: Must be 5-100 characters';
    Inc(ErrorCount);
  end;
  
  if not ValidateClassroom(ACourse.Classroom) then
  begin
    Errors[ErrorCount] := 'Invalid Classroom: Must be 2-20 characters';
    Inc(ErrorCount);
  end;
  
  if Trim(ACourse.CourseDescription) = '' then
  begin
    Errors[ErrorCount] := 'Course Description cannot be empty';
    Inc(ErrorCount);
  end;
  
  if Trim(ACourse.Instructor) = '' then
  begin
    Errors[ErrorCount] := 'Instructor cannot be empty';
    Inc(ErrorCount);
  end;
  
  SetLength(Errors, ErrorCount);
  Result := Errors;
end;

end.

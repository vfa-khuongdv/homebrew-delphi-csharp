unit CourseManager;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  CourseModels, CourseValidators;

type
  TCourseManager = class
  private
    FCourses: TObjectList<TCourse>;
    FCourseValidator: TCourseValidator;
    FCurrentYear: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    
    // Course CRUD operations
    function AddCourse(const ACourse: TCourse): Boolean;
    function RemoveCourse(const ACourseId: string): Boolean;
    function FindCourse(const ACourseId: string): TCourse;
    function UpdateCourse(const ACourseId: string; const ACourse: TCourse): Boolean;
    
    // Course queries
    function GetCourseCount: Integer;
    function GetCoursesByDepartment(const ADepartment: string): TObjectList<TCourse>;
    function GetCoursesByCredits(const ACredits: Integer): TObjectList<TCourse>;
    function SearchCourses(const ASearchTerm: string): TObjectList<TCourse>;
    
    // Academic operations
    procedure EnrollStudentInCourse(const ACourseId, AStudentId: string);
    procedure UnenrollStudentFromCourse(const ACourseId, AStudentId: string);
    function GetCourseEnrollment(const ACourseId: string): TStringList;
    
    // Administrative functions
    procedure InitializeYear(const AYear: Integer);
    procedure BackupData(const ABackupPath: string);
    function ValidateData: Boolean;
    function GenerateCourseReport(const ACourseId: string): string;
  end;

implementation

constructor TCourseManager.Create;
begin
  inherited Create;
  FCourses := TObjectList<TCourse>.Create(True);
  FCourseValidator := TCourseValidator.Create;
  FCurrentYear := 2024;
end;

destructor TCourseManager.Destroy;
begin
  FCourses.Free;
  FCourseValidator.Free;
  inherited Destroy;
end;

function TCourseManager.AddCourse(const ACourse: TCourse): Boolean;
begin
  Result := False;
  if Assigned(ACourse) and FCourseValidator.ValidateCourse(ACourse) then
  begin
    if FindCourse(ACourse.CourseId) = nil then
    begin
      FCourses.Add(ACourse);
      Result := True;
    end;
  end;
end;

function TCourseManager.RemoveCourse(const ACourseId: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FCourses.Count - 1 do
  begin
    if FCourses[I].CourseId = ACourseId then
    begin
      FCourses.Delete(I);
      Result := True;
      Break;
    end;
  end;
end;

function TCourseManager.FindCourse(const ACourseId: string): TCourse;
var
  Course: TCourse;
begin
  Result := nil;
  for Course in FCourses do
  begin
    if Course.CourseId = ACourseId then
    begin
      Result := Course;
      Break;
    end;
  end;
end;

function TCourseManager.UpdateCourse(const ACourseId: string; const ACourse: TCourse): Boolean;
var
  ExistingCourse: TCourse;
begin
  Result := False;
  ExistingCourse := FindCourse(ACourseId);
  if Assigned(ExistingCourse) and FCourseValidator.ValidateCourse(ACourse) then
  begin
    ExistingCourse.Assign(ACourse);
    Result := True;
  end;
end;

function TCourseManager.GetCourseCount: Integer;
begin
  Result := FCourses.Count;
end;

function TCourseManager.GetCoursesByDepartment(const ADepartment: string): TObjectList<TCourse>;
var
  Course: TCourse;
begin
  Result := TObjectList<TCourse>.Create(False);
  for Course in FCourses do
  begin
    if Course.Department = ADepartment then
      Result.Add(Course);
  end;
end;

function TCourseManager.GetCoursesByCredits(const ACredits: Integer): TObjectList<TCourse>;
var
  Course: TCourse;
begin
  Result := TObjectList<TCourse>.Create(False);
  for Course in FCourses do
  begin
    if Course.Credits = ACredits then
      Result.Add(Course);
  end;
end;

function TCourseManager.SearchCourses(const ASearchTerm: string): TObjectList<TCourse>;
var
  Course: TCourse;
  SearchTermLower: string;
begin
  Result := TObjectList<TCourse>.Create(False);
  SearchTermLower := LowerCase(ASearchTerm);
  
  for Course in FCourses do
  begin
    if (Pos(SearchTermLower, LowerCase(Course.CourseName)) > 0) or
       (Pos(SearchTermLower, LowerCase(Course.CourseId)) > 0) or
       (Pos(SearchTermLower, LowerCase(Course.Department)) > 0) then
      Result.Add(Course);
  end;
end;

procedure TCourseManager.EnrollStudentInCourse(const ACourseId, AStudentId: string);
var
  Course: TCourse;
begin
  Course := FindCourse(ACourseId);
  if Assigned(Course) then
    Course.EnrollStudent(AStudentId);
end;

procedure TCourseManager.UnenrollStudentFromCourse(const ACourseId, AStudentId: string);
var
  Course: TCourse;
begin
  Course := FindCourse(ACourseId);
  if Assigned(Course) then
    Course.UnenrollStudent(AStudentId);
end;

function TCourseManager.GetCourseEnrollment(const ACourseId: string): TStringList;
var
  Course: TCourse;
begin
  Result := TStringList.Create;
  Course := FindCourse(ACourseId);
  if Assigned(Course) then
    Result.Assign(Course.GetEnrolledStudents)
  else
    Result.Add('Course not found');
end;

procedure TCourseManager.InitializeYear(const AYear: Integer);
begin
  FCurrentYear := AYear;
  // Additional year initialization logic
end;

procedure TCourseManager.BackupData(const ABackupPath: string);
var
  BackupFile: TStringList;
  Course: TCourse;
begin
  BackupFile := TStringList.Create;
  try
    for Course in FCourses do
      BackupFile.Add(Course.ToJSON);
    
    ForceDirectories(ABackupPath);
    BackupFile.SaveToFile(ABackupPath + '\courses_backup.json');
  finally
    BackupFile.Free;
  end;
end;

function TCourseManager.ValidateData: Boolean;
var
  Course: TCourse;
begin
  Result := True;
  for Course in FCourses do
  begin
    if not FCourseValidator.ValidateCourse(Course) then
    begin
      Result := False;
      Break;
    end;
  end;
end;

function TCourseManager.GenerateCourseReport(const ACourseId: string): string;
var
  Course: TCourse;
  Report: TStringBuilder;
begin
  Course := FindCourse(ACourseId);
  if Assigned(Course) then
  begin
    Report := TStringBuilder.Create;
    try
      Report.AppendLine('=== COURSE REPORT ===');
      Report.AppendLine(Format('ID: %s', [Course.CourseId]));
      Report.AppendLine(Format('Name: %s', [Course.CourseName]));
      Report.AppendLine(Format('Department: %s', [Course.Department]));
      Report.AppendLine(Format('Credits: %d', [Course.Credits]));
      Report.AppendLine('=====================');
      Result := Report.ToString;
    finally
      Report.Free;
    end;
  end
  else
    Result := 'Course not found';
end;

end.

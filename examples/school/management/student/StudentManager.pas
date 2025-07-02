unit StudentManager;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  StudentModels, StudentValidators;

type
  TStudentManager = class
  private
    FStudents: TObjectList<TStudent>;
    FStudentValidator: TStudentValidator;
    FCurrentYear: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    
    // Student CRUD operations
    function AddStudent(const AStudent: TStudent): Boolean;
    function RemoveStudent(const AStudentId: string): Boolean;
    function FindStudent(const AStudentId: string): TStudent;
    function UpdateStudent(const AStudentId: string; const AStudent: TStudent): Boolean;
    
    // Student queries
    function GetStudentCount: Integer;
    function GetStudentsByGrade(const AGrade: Integer): TObjectList<TStudent>;
    function GetStudentsByClass(const AClassName: string): TObjectList<TStudent>;
    function SearchStudents(const ASearchTerm: string): TObjectList<TStudent>;
    
    // Academic operations
    procedure EnrollStudentInCourse(const AStudentId, ACourseId: string);
    procedure UnenrollStudentFromCourse(const AStudentId, ACourseId: string);
    function GetStudentTranscript(const AStudentId: string): TStringList;
    
    // Administrative functions
    procedure InitializeYear(const AYear: Integer);
    procedure BackupData(const ABackupPath: string);
    function ValidateData: Boolean;
    function GenerateStudentReport(const AStudentId: string): string;
  end;

implementation

constructor TStudentManager.Create;
begin
  inherited Create;
  FStudents := TObjectList<TStudent>.Create(True);
  FStudentValidator := TStudentValidator.Create;
  FCurrentYear := 2024;
end;

destructor TStudentManager.Destroy;
begin
  FStudents.Free;
  FStudentValidator.Free;
  inherited Destroy;
end;

function TStudentManager.AddStudent(const AStudent: TStudent): Boolean;
begin
  Result := False;
  if Assigned(AStudent) and FStudentValidator.ValidateStudent(AStudent) then
  begin
    if FindStudent(AStudent.StudentId) = nil then
    begin
      FStudents.Add(AStudent);
      Result := True;
    end;
  end;
end;

function TStudentManager.RemoveStudent(const AStudentId: string): Boolean;
var
  Student: TStudent;
  I: Integer;
begin
  Result := False;
  for I := 0 to FStudents.Count - 1 do
  begin
    if FStudents[I].StudentId = AStudentId then
    begin
      FStudents.Delete(I);
      Result := True;
      Break;
    end;
  end;
end;

function TStudentManager.FindStudent(const AStudentId: string): TStudent;
var
  Student: TStudent;
begin
  Result := nil;
  for Student in FStudents do
  begin
    if Student.StudentId = AStudentId then
    begin
      Result := Student;
      Break;
    end;
  end;
end;

function TStudentManager.UpdateStudent(const AStudentId: string; const AStudent: TStudent): Boolean;
var
  ExistingStudent: TStudent;
begin
  Result := False;
  ExistingStudent := FindStudent(AStudentId);
  if Assigned(ExistingStudent) and FStudentValidator.ValidateStudent(AStudent) then
  begin
    ExistingStudent.Assign(AStudent);
    Result := True;
  end;
end;

function TStudentManager.GetStudentCount: Integer;
begin
  Result := FStudents.Count;
end;

function TStudentManager.GetStudentsByGrade(const AGrade: Integer): TObjectList<TStudent>;
var
  Student: TStudent;
begin
  Result := TObjectList<TStudent>.Create(False);
  for Student in FStudents do
  begin
    if Student.Grade = AGrade then
      Result.Add(Student);
  end;
end;

function TStudentManager.GetStudentsByClass(const AClassName: string): TObjectList<TStudent>;
var
  Student: TStudent;
begin
  Result := TObjectList<TStudent>.Create(False);
  for Student in FStudents do
  begin
    if Student.ClassName = AClassName then
      Result.Add(Student);
  end;
end;

function TStudentManager.SearchStudents(const ASearchTerm: string): TObjectList<TStudent>;
var
  Student: TStudent;
  SearchTermLower: string;
begin
  Result := TObjectList<TStudent>.Create(False);
  SearchTermLower := LowerCase(ASearchTerm);
  
  for Student in FStudents do
  begin
    if (Pos(SearchTermLower, LowerCase(Student.FirstName)) > 0) or
       (Pos(SearchTermLower, LowerCase(Student.LastName)) > 0) or
       (Pos(SearchTermLower, LowerCase(Student.StudentId)) > 0) then
      Result.Add(Student);
  end;
end;

procedure TStudentManager.EnrollStudentInCourse(const AStudentId, ACourseId: string);
var
  Student: TStudent;
begin
  Student := FindStudent(AStudentId);
  if Assigned(Student) then
    Student.EnrollInCourse(ACourseId);
end;

procedure TStudentManager.UnenrollStudentFromCourse(const AStudentId, ACourseId: string);
var
  Student: TStudent;
begin
  Student := FindStudent(AStudentId);
  if Assigned(Student) then
    Student.UnenrollFromCourse(ACourseId);
end;

function TStudentManager.GetStudentTranscript(const AStudentId: string): TStringList;
var
  Student: TStudent;
begin
  Result := TStringList.Create;
  Student := FindStudent(AStudentId);
  if Assigned(Student) then
    Result.Assign(Student.GenerateTranscript)
  else
    Result.Add('Student not found');
end;

procedure TStudentManager.InitializeYear(const AYear: Integer);
begin
  FCurrentYear := AYear;
  // Additional year initialization logic
end;

procedure TStudentManager.BackupData(const ABackupPath: string);
var
  BackupFile: TStringList;
  Student: TStudent;
begin
  BackupFile := TStringList.Create;
  try
    for Student in FStudents do
      BackupFile.Add(Student.ToJSON);
    
    ForceDirectories(ABackupPath);
    BackupFile.SaveToFile(ABackupPath + '\students_backup.json');
  finally
    BackupFile.Free;
  end;
end;

function TStudentManager.ValidateData: Boolean;
var
  Student: TStudent;
begin
  Result := True;
  for Student in FStudents do
  begin
    if not FStudentValidator.ValidateStudent(Student) then
    begin
      Result := False;
      Break;
    end;
  end;
end;

function TStudentManager.GenerateStudentReport(const AStudentId: string): string;
var
  Student: TStudent;
  Report: TStringBuilder;
begin
  Student := FindStudent(AStudentId);
  if Assigned(Student) then
  begin
    Report := TStringBuilder.Create;
    try
      Report.AppendLine('=== STUDENT REPORT ===');
      Report.AppendLine(Format('ID: %s', [Student.StudentId]));
      Report.AppendLine(Format('Name: %s %s', [Student.FirstName, Student.LastName]));
      Report.AppendLine(Format('Grade: %d', [Student.Grade]));
      Report.AppendLine(Format('Class: %s', [Student.ClassName]));
      Report.AppendLine('======================');
      Result := Report.ToString;
    finally
      Report.Free;
    end;
  end
  else
    Result := 'Student not found';
end;

end.

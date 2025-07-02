unit TeacherManager;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  TeacherModels, TeacherValidators;

type
  TTeacherManager = class
  private
    FTeachers: TObjectList<TTeacher>;
    FTeacherValidator: TTeacherValidator;
    FCurrentYear: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    
    // Teacher CRUD operations
    function AddTeacher(const ATeacher: TTeacher): Boolean;
    function RemoveTeacher(const ATeacherId: string): Boolean;
    function FindTeacher(const ATeacherId: string): TTeacher;
    function UpdateTeacher(const ATeacherId: string; const ATeacher: TTeacher): Boolean;
    
    // Teacher queries
    function GetTeacherCount: Integer;
    function GetTeachersByDepartment(const ADepartment: string): TObjectList<TTeacher>;
    function GetTeachersBySubject(const ASubject: string): TObjectList<TTeacher>;
    function SearchTeachers(const ASearchTerm: string): TObjectList<TTeacher>;
    
    // Academic operations
    procedure AssignTeacherToCourse(const ATeacherId, ACourseId: string);
    procedure UnassignTeacherFromCourse(const ATeacherId, ACourseId: string);
    function GetTeacherSchedule(const ATeacherId: string): TStringList;
    
    // Administrative functions
    procedure InitializeYear(const AYear: Integer);
    procedure BackupData(const ABackupPath: string);
    function ValidateData: Boolean;
    function GenerateTeacherReport(const ATeacherId: string): string;
  end;

implementation

constructor TTeacherManager.Create;
begin
  inherited Create;
  FTeachers := TObjectList<TTeacher>.Create(True);
  FTeacherValidator := TTeacherValidator.Create;
  FCurrentYear := 2024;
end;

destructor TTeacherManager.Destroy;
begin
  FTeachers.Free;
  FTeacherValidator.Free;
  inherited Destroy;
end;

function TTeacherManager.AddTeacher(const ATeacher: TTeacher): Boolean;
begin
  Result := False;
  if Assigned(ATeacher) and FTeacherValidator.ValidateTeacher(ATeacher) then
  begin
    if FindTeacher(ATeacher.TeacherId) = nil then
    begin
      FTeachers.Add(ATeacher);
      Result := True;
    end;
  end;
end;

function TTeacherManager.RemoveTeacher(const ATeacherId: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FTeachers.Count - 1 do
  begin
    if FTeachers[I].TeacherId = ATeacherId then
    begin
      FTeachers.Delete(I);
      Result := True;
      Break;
    end;
  end;
end;

function TTeacherManager.FindTeacher(const ATeacherId: string): TTeacher;
var
  Teacher: TTeacher;
begin
  Result := nil;
  for Teacher in FTeachers do
  begin
    if Teacher.TeacherId = ATeacherId then
    begin
      Result := Teacher;
      Break;
    end;
  end;
end;

function TTeacherManager.UpdateTeacher(const ATeacherId: string; const ATeacher: TTeacher): Boolean;
var
  ExistingTeacher: TTeacher;
begin
  Result := False;
  ExistingTeacher := FindTeacher(ATeacherId);
  if Assigned(ExistingTeacher) and FTeacherValidator.ValidateTeacher(ATeacher) then
  begin
    ExistingTeacher.Assign(ATeacher);
    Result := True;
  end;
end;

function TTeacherManager.GetTeacherCount: Integer;
begin
  Result := FTeachers.Count;
end;

function TTeacherManager.GetTeachersByDepartment(const ADepartment: string): TObjectList<TTeacher>;
var
  Teacher: TTeacher;
begin
  Result := TObjectList<TTeacher>.Create(False);
  for Teacher in FTeachers do
  begin
    if Teacher.Department = ADepartment then
      Result.Add(Teacher);
  end;
end;

function TTeacherManager.GetTeachersBySubject(const ASubject: string): TObjectList<TTeacher>;
var
  Teacher: TTeacher;
begin
  Result := TObjectList<TTeacher>.Create(False);
  for Teacher in FTeachers do
  begin
    if Teacher.Subject = ASubject then
      Result.Add(Teacher);
  end;
end;

function TTeacherManager.SearchTeachers(const ASearchTerm: string): TObjectList<TTeacher>;
var
  Teacher: TTeacher;
  SearchTermLower: string;
begin
  Result := TObjectList<TTeacher>.Create(False);
  SearchTermLower := LowerCase(ASearchTerm);
  
  for Teacher in FTeachers do
  begin
    if (Pos(SearchTermLower, LowerCase(Teacher.FirstName)) > 0) or
       (Pos(SearchTermLower, LowerCase(Teacher.LastName)) > 0) or
       (Pos(SearchTermLower, LowerCase(Teacher.TeacherId)) > 0) or
       (Pos(SearchTermLower, LowerCase(Teacher.Department)) > 0) then
      Result.Add(Teacher);
  end;
end;

procedure TTeacherManager.AssignTeacherToCourse(const ATeacherId, ACourseId: string);
var
  Teacher: TTeacher;
begin
  Teacher := FindTeacher(ATeacherId);
  if Assigned(Teacher) then
    Teacher.AssignToCourse(ACourseId);
end;

procedure TTeacherManager.UnassignTeacherFromCourse(const ATeacherId, ACourseId: string);
var
  Teacher: TTeacher;
begin
  Teacher := FindTeacher(ATeacherId);
  if Assigned(Teacher) then
    Teacher.UnassignFromCourse(ACourseId);
end;

function TTeacherManager.GetTeacherSchedule(const ATeacherId: string): TStringList;
var
  Teacher: TTeacher;
begin
  Result := TStringList.Create;
  Teacher := FindTeacher(ATeacherId);
  if Assigned(Teacher) then
    Result.Assign(Teacher.GenerateSchedule)
  else
    Result.Add('Teacher not found');
end;

procedure TTeacherManager.InitializeYear(const AYear: Integer);
begin
  FCurrentYear := AYear;
  // Additional year initialization logic
end;

procedure TTeacherManager.BackupData(const ABackupPath: string);
var
  BackupFile: TStringList;
  Teacher: TTeacher;
begin
  BackupFile := TStringList.Create;
  try
    for Teacher in FTeachers do
      BackupFile.Add(Teacher.ToJSON);
    
    ForceDirectories(ABackupPath);
    BackupFile.SaveToFile(ABackupPath + '\teachers_backup.json');
  finally
    BackupFile.Free;
  end;
end;

function TTeacherManager.ValidateData: Boolean;
var
  Teacher: TTeacher;
begin
  Result := True;
  for Teacher in FTeachers do
  begin
    if not FTeacherValidator.ValidateTeacher(Teacher) then
    begin
      Result := False;
      Break;
    end;
  end;
end;

function TTeacherManager.GenerateTeacherReport(const ATeacherId: string): string;
var
  Teacher: TTeacher;
  Report: TStringBuilder;
begin
  Teacher := FindTeacher(ATeacherId);
  if Assigned(Teacher) then
  begin
    Report := TStringBuilder.Create;
    try
      Report.AppendLine('=== TEACHER REPORT ===');
      Report.AppendLine(Format('ID: %s', [Teacher.TeacherId]));
      Report.AppendLine(Format('Name: %s %s', [Teacher.FirstName, Teacher.LastName]));
      Report.AppendLine(Format('Department: %s', [Teacher.Department]));
      Report.AppendLine(Format('Subject: %s', [Teacher.Subject]));
      Report.AppendLine('======================');
      Result := Report.ToString;
    finally
      Report.Free;
    end;
  end
  else
    Result := 'Teacher not found';
end;

end.

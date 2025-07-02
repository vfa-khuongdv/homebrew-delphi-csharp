unit StudentModels;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections;

type
  TStudent = class
  private
    FStudentId: string;
    FFirstName: string;
    FLastName: string;
    FEmail: string;
    FPhoneNumber: string;
    FDateOfBirth: TDateTime;
    FGrade: Integer;
    FClassName: string;
    FEnrolledCourses: TStringList;
    FGrades: TDictionary<string, Double>;
  public
    constructor Create;
    destructor Destroy; override;
    
    // Properties
    property StudentId: string read FStudentId write FStudentId;
    property FirstName: string read FFirstName write FFirstName;
    property LastName: string read FLastName write FLastName;
    property Email: string read FEmail write FEmail;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
    property DateOfBirth: TDateTime read FDateOfBirth write FDateOfBirth;
    property Grade: Integer read FGrade write FGrade;
    property ClassName: string read FClassName write FClassName;
    property EnrolledCourses: TStringList read FEnrolledCourses;
    
    // Methods
    function GetFullName: string;
    function GetAge: Integer;
    procedure EnrollInCourse(const ACourseId: string);
    procedure UnenrollFromCourse(const ACourseId: string);
    procedure SetGrade(const ACourseId: string; const AGrade: Double);
    function GetGrade(const ACourseId: string): Double;
    function GetGPA: Double;
    function GenerateTranscript: TStringList;
    function ToJSON: string;
    procedure Assign(const AStudent: TStudent);
  end;

implementation

uses
  System.JSON, System.DateUtils;

constructor TStudent.Create;
begin
  inherited Create;
  FEnrolledCourses := TStringList.Create;
  FGrades := TDictionary<string, Double>.Create;
end;

destructor TStudent.Destroy;
begin
  FEnrolledCourses.Free;
  FGrades.Free;
  inherited Destroy;
end;

function TStudent.GetFullName: string;
begin
  Result := Format('%s %s', [FFirstName, FLastName]);
end;

function TStudent.GetAge: Integer;
begin
  Result := YearsBetween(Now, FDateOfBirth);
end;

procedure TStudent.EnrollInCourse(const ACourseId: string);
begin
  if FEnrolledCourses.IndexOf(ACourseId) = -1 then
    FEnrolledCourses.Add(ACourseId);
end;

procedure TStudent.UnenrollFromCourse(const ACourseId: string);
var
  Index: Integer;
begin
  Index := FEnrolledCourses.IndexOf(ACourseId);
  if Index >= 0 then
  begin
    FEnrolledCourses.Delete(Index);
    FGrades.Remove(ACourseId);
  end;
end;

procedure TStudent.SetGrade(const ACourseId: string; const AGrade: Double);
begin
  if FEnrolledCourses.IndexOf(ACourseId) >= 0 then
    FGrades.AddOrSetValue(ACourseId, AGrade);
end;

function TStudent.GetGrade(const ACourseId: string): Double;
begin
  if not FGrades.TryGetValue(ACourseId, Result) then
    Result := 0.0;
end;

function TStudent.GetGPA: Double;
var
  TotalGrades: Double;
  CourseId: string;
  Grade: Double;
  Count: Integer;
begin
  TotalGrades := 0.0;
  Count := 0;
  
  for CourseId in FGrades.Keys do
  begin
    if FGrades.TryGetValue(CourseId, Grade) then
    begin
      TotalGrades := TotalGrades + Grade;
      Inc(Count);
    end;
  end;
  
  if Count > 0 then
    Result := TotalGrades / Count
  else
    Result := 0.0;
end;

function TStudent.GenerateTranscript: TStringList;
var
  CourseId: string;
  Grade: Double;
begin
  Result := TStringList.Create;
  Result.Add(Format('Transcript for: %s', [GetFullName]));
  Result.Add(Format('Student ID: %s', [FStudentId]));
  Result.Add(Format('Grade: %d', [FGrade]));
  Result.Add(Format('Class: %s', [FClassName]));
  Result.Add('');
  Result.Add('Course Grades:');
  
  for CourseId in FGrades.Keys do
  begin
    if FGrades.TryGetValue(CourseId, Grade) then
      Result.Add(Format('  %s: %.2f', [CourseId, Grade]));
  end;
  
  Result.Add('');
  Result.Add(Format('GPA: %.2f', [GetGPA]));
end;

function TStudent.ToJSON: string;
var
  JSONObject: TJSONObject;
  CoursesArray: TJSONArray;
  GradesObject: TJSONObject;
  I: Integer;
  CourseId: string;
  Grade: Double;
begin
  JSONObject := TJSONObject.Create;
  try
    JSONObject.AddPair('studentId', FStudentId);
    JSONObject.AddPair('firstName', FFirstName);
    JSONObject.AddPair('lastName', FLastName);
    JSONObject.AddPair('email', FEmail);
    JSONObject.AddPair('phoneNumber', FPhoneNumber);
    JSONObject.AddPair('dateOfBirth', DateToISO8601(FDateOfBirth));
    JSONObject.AddPair('grade', TJSONNumber.Create(FGrade));
    JSONObject.AddPair('className', FClassName);
    
    // Add enrolled courses
    CoursesArray := TJSONArray.Create;
    for I := 0 to FEnrolledCourses.Count - 1 do
      CoursesArray.AddElement(TJSONString.Create(FEnrolledCourses[I]));
    JSONObject.AddPair('enrolledCourses', CoursesArray);
    
    // Add grades
    GradesObject := TJSONObject.Create;
    for CourseId in FGrades.Keys do
    begin
      if FGrades.TryGetValue(CourseId, Grade) then
        GradesObject.AddPair(CourseId, TJSONNumber.Create(Grade));
    end;
    JSONObject.AddPair('grades', GradesObject);
    
    Result := JSONObject.ToString;
  finally
    JSONObject.Free;
  end;
end;

procedure TStudent.Assign(const AStudent: TStudent);
begin
  if Assigned(AStudent) then
  begin
    FStudentId := AStudent.FStudentId;
    FFirstName := AStudent.FFirstName;
    FLastName := AStudent.FLastName;
    FEmail := AStudent.FEmail;
    FPhoneNumber := AStudent.FPhoneNumber;
    FDateOfBirth := AStudent.FDateOfBirth;
    FGrade := AStudent.FGrade;
    FClassName := AStudent.FClassName;
    FEnrolledCourses.Assign(AStudent.FEnrolledCourses);
    FGrades.Clear;
    FGrades.AddRange(AStudent.FGrades);
  end;
end;

end.

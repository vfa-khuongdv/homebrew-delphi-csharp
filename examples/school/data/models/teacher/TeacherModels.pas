unit TeacherModels;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections;

type
  TTeacher = class
  private
    FTeacherId: string;
    FFirstName: string;
    FLastName: string;
    FEmail: string;
    FPhoneNumber: string;
    FDateOfBirth: TDateTime;
    FDepartment: string;
    FSubject: string;
    FHireDate: TDateTime;
    FSalary: Currency;
    FAssignedCourses: TStringList;
    FQualifications: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    
    // Properties
    property TeacherId: string read FTeacherId write FTeacherId;
    property FirstName: string read FFirstName write FFirstName;
    property LastName: string read FLastName write FLastName;
    property Email: string read FEmail write FEmail;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
    property DateOfBirth: TDateTime read FDateOfBirth write FDateOfBirth;
    property Department: string read FDepartment write FDepartment;
    property Subject: string read FSubject write FSubject;
    property HireDate: TDateTime read FHireDate write FHireDate;
    property Salary: Currency read FSalary write FSalary;
    property AssignedCourses: TStringList read FAssignedCourses;
    property Qualifications: TStringList read FQualifications;
    
    // Methods
    function GetFullName: string;
    function GetAge: Integer;
    function GetYearsOfService: Integer;
    procedure AssignToCourse(const ACourseId: string);
    procedure UnassignFromCourse(const ACourseId: string);
    procedure AddQualification(const AQualification: string);
    procedure RemoveQualification(const AQualification: string);
    function GenerateSchedule: TStringList;
    function ToJSON: string;
    procedure Assign(const ATeacher: TTeacher);
  end;

implementation

uses
  System.JSON, System.DateUtils;

constructor TTeacher.Create;
begin
  inherited Create;
  FAssignedCourses := TStringList.Create;
  FQualifications := TStringList.Create;
end;

destructor TTeacher.Destroy;
begin
  FAssignedCourses.Free;
  FQualifications.Free;
  inherited Destroy;
end;

function TTeacher.GetFullName: string;
begin
  Result := Format('%s %s', [FFirstName, FLastName]);
end;

function TTeacher.GetAge: Integer;
begin
  Result := YearsBetween(Now, FDateOfBirth);
end;

function TTeacher.GetYearsOfService: Integer;
begin
  Result := YearsBetween(Now, FHireDate);
end;

procedure TTeacher.AssignToCourse(const ACourseId: string);
begin
  if FAssignedCourses.IndexOf(ACourseId) = -1 then
    FAssignedCourses.Add(ACourseId);
end;

procedure TTeacher.UnassignFromCourse(const ACourseId: string);
var
  Index: Integer;
begin
  Index := FAssignedCourses.IndexOf(ACourseId);
  if Index >= 0 then
    FAssignedCourses.Delete(Index);
end;

procedure TTeacher.AddQualification(const AQualification: string);
begin
  if FQualifications.IndexOf(AQualification) = -1 then
    FQualifications.Add(AQualification);
end;

procedure TTeacher.RemoveQualification(const AQualification: string);
var
  Index: Integer;
begin
  Index := FQualifications.IndexOf(AQualification);
  if Index >= 0 then
    FQualifications.Delete(Index);
end;

function TTeacher.GenerateSchedule: TStringList;
var
  I: Integer;
begin
  Result := TStringList.Create;
  Result.Add(Format('Schedule for: %s', [GetFullName]));
  Result.Add(Format('Teacher ID: %s', [FTeacherId]));
  Result.Add(Format('Department: %s', [FDepartment]));
  Result.Add(Format('Subject: %s', [FSubject]));
  Result.Add('');
  Result.Add('Assigned Courses:');
  
  for I := 0 to FAssignedCourses.Count - 1 do
    Result.Add(Format('  Course: %s', [FAssignedCourses[I]]));
  
  if FAssignedCourses.Count = 0 then
    Result.Add('  No courses assigned');
end;

function TTeacher.ToJSON: string;
var
  JSONObject: TJSONObject;
  CoursesArray, QualificationsArray: TJSONArray;
  I: Integer;
begin
  JSONObject := TJSONObject.Create;
  try
    JSONObject.AddPair('teacherId', FTeacherId);
    JSONObject.AddPair('firstName', FFirstName);
    JSONObject.AddPair('lastName', FLastName);
    JSONObject.AddPair('email', FEmail);
    JSONObject.AddPair('phoneNumber', FPhoneNumber);
    JSONObject.AddPair('dateOfBirth', DateToISO8601(FDateOfBirth));
    JSONObject.AddPair('department', FDepartment);
    JSONObject.AddPair('subject', FSubject);
    JSONObject.AddPair('hireDate', DateToISO8601(FHireDate));
    JSONObject.AddPair('salary', TJSONNumber.Create(FSalary));
    
    // Add assigned courses
    CoursesArray := TJSONArray.Create;
    for I := 0 to FAssignedCourses.Count - 1 do
      CoursesArray.AddElement(TJSONString.Create(FAssignedCourses[I]));
    JSONObject.AddPair('assignedCourses', CoursesArray);
    
    // Add qualifications
    QualificationsArray := TJSONArray.Create;
    for I := 0 to FQualifications.Count - 1 do
      QualificationsArray.AddElement(TJSONString.Create(FQualifications[I]));
    JSONObject.AddPair('qualifications', QualificationsArray);
    
    Result := JSONObject.ToString;
  finally
    JSONObject.Free;
  end;
end;

procedure TTeacher.Assign(const ATeacher: TTeacher);
begin
  if Assigned(ATeacher) then
  begin
    FTeacherId := ATeacher.FTeacherId;
    FFirstName := ATeacher.FFirstName;
    FLastName := ATeacher.FLastName;
    FEmail := ATeacher.FEmail;
    FPhoneNumber := ATeacher.FPhoneNumber;
    FDateOfBirth := ATeacher.FDateOfBirth;
    FDepartment := ATeacher.FDepartment;
    FSubject := ATeacher.FSubject;
    FHireDate := ATeacher.FHireDate;
    FSalary := ATeacher.FSalary;
    FAssignedCourses.Assign(ATeacher.FAssignedCourses);
    FQualifications.Assign(ATeacher.FQualifications);
  end;
end;

end.

unit CourseModels;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections;

type
  TCourse = class
  private
    FCourseId: string;
    FCourseName: string;
    FCourseDescription: string;
    FDepartment: string;
    FCredits: Integer;
    FMaxEnrollment: Integer;
    FInstructor: string;
    FSchedule: string;
    FClassroom: string;
    FEnrolledStudents: TStringList;
    FPrerequisites: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    
    // Properties
    property CourseId: string read FCourseId write FCourseId;
    property CourseName: string read FCourseName write FCourseName;
    property CourseDescription: string read FCourseDescription write FCourseDescription;
    property Department: string read FDepartment write FDepartment;
    property Credits: Integer read FCredits write FCredits;
    property MaxEnrollment: Integer read FMaxEnrollment write FMaxEnrollment;
    property Instructor: string read FInstructor write FInstructor;
    property Schedule: string read FSchedule write FSchedule;
    property Classroom: string read FClassroom write FClassroom;
    property EnrolledStudents: TStringList read FEnrolledStudents;
    property Prerequisites: TStringList read FPrerequisites;
    
    // Methods
    function GetCurrentEnrollment: Integer;
    function HasAvailableSpots: Boolean;
    function GetAvailableSpots: Integer;
    procedure EnrollStudent(const AStudentId: string);
    procedure UnenrollStudent(const AStudentId: string);
    function IsStudentEnrolled(const AStudentId: string): Boolean;
    procedure AddPrerequisite(const ACourseId: string);
    procedure RemovePrerequisite(const ACourseId: string);
    function GetEnrolledStudents: TStringList;
    function ToJSON: string;
    procedure Assign(const ACourse: TCourse);
  end;

implementation

uses
  System.JSON;

constructor TCourse.Create;
begin
  inherited Create;
  FEnrolledStudents := TStringList.Create;
  FPrerequisites := TStringList.Create;
end;

destructor TCourse.Destroy;
begin
  FEnrolledStudents.Free;
  FPrerequisites.Free;
  inherited Destroy;
end;

function TCourse.GetCurrentEnrollment: Integer;
begin
  Result := FEnrolledStudents.Count;
end;

function TCourse.HasAvailableSpots: Boolean;
begin
  Result := GetCurrentEnrollment < FMaxEnrollment;
end;

function TCourse.GetAvailableSpots: Integer;
begin
  Result := FMaxEnrollment - GetCurrentEnrollment;
  if Result < 0 then
    Result := 0;
end;

procedure TCourse.EnrollStudent(const AStudentId: string);
begin
  if HasAvailableSpots and (FEnrolledStudents.IndexOf(AStudentId) = -1) then
    FEnrolledStudents.Add(AStudentId);
end;

procedure TCourse.UnenrollStudent(const AStudentId: string);
var
  Index: Integer;
begin
  Index := FEnrolledStudents.IndexOf(AStudentId);
  if Index >= 0 then
    FEnrolledStudents.Delete(Index);
end;

function TCourse.IsStudentEnrolled(const AStudentId: string): Boolean;
begin
  Result := FEnrolledStudents.IndexOf(AStudentId) >= 0;
end;

procedure TCourse.AddPrerequisite(const ACourseId: string);
begin
  if FPrerequisites.IndexOf(ACourseId) = -1 then
    FPrerequisites.Add(ACourseId);
end;

procedure TCourse.RemovePrerequisite(const ACourseId: string);
var
  Index: Integer;
begin
  Index := FPrerequisites.IndexOf(ACourseId);
  if Index >= 0 then
    FPrerequisites.Delete(Index);
end;

function TCourse.GetEnrolledStudents: TStringList;
begin
  Result := TStringList.Create;
  Result.Assign(FEnrolledStudents);
end;

function TCourse.ToJSON: string;
var
  JSONObject: TJSONObject;
  StudentsArray, PrereqArray: TJSONArray;
  I: Integer;
begin
  JSONObject := TJSONObject.Create;
  try
    JSONObject.AddPair('courseId', FCourseId);
    JSONObject.AddPair('courseName', FCourseName);
    JSONObject.AddPair('courseDescription', FCourseDescription);
    JSONObject.AddPair('department', FDepartment);
    JSONObject.AddPair('credits', TJSONNumber.Create(FCredits));
    JSONObject.AddPair('maxEnrollment', TJSONNumber.Create(FMaxEnrollment));
    JSONObject.AddPair('instructor', FInstructor);
    JSONObject.AddPair('schedule', FSchedule);
    JSONObject.AddPair('classroom', FClassroom);
    
    // Add enrolled students
    StudentsArray := TJSONArray.Create;
    for I := 0 to FEnrolledStudents.Count - 1 do
      StudentsArray.AddElement(TJSONString.Create(FEnrolledStudents[I]));
    JSONObject.AddPair('enrolledStudents', StudentsArray);
    
    // Add prerequisites
    PrereqArray := TJSONArray.Create;
    for I := 0 to FPrerequisites.Count - 1 do
      PrereqArray.AddElement(TJSONString.Create(FPrerequisites[I]));
    JSONObject.AddPair('prerequisites', PrereqArray);
    
    Result := JSONObject.ToString;
  finally
    JSONObject.Free;
  end;
end;

procedure TCourse.Assign(const ACourse: TCourse);
begin
  if Assigned(ACourse) then
  begin
    FCourseId := ACourse.FCourseId;
    FCourseName := ACourse.FCourseName;
    FCourseDescription := ACourse.FCourseDescription;
    FDepartment := ACourse.FDepartment;
    FCredits := ACourse.FCredits;
    FMaxEnrollment := ACourse.FMaxEnrollment;
    FInstructor := ACourse.FInstructor;
    FSchedule := ACourse.FSchedule;
    FClassroom := ACourse.FClassroom;
    FEnrolledStudents.Assign(ACourse.FEnrolledStudents);
    FPrerequisites.Assign(ACourse.FPrerequisites);
  end;
end;

end.

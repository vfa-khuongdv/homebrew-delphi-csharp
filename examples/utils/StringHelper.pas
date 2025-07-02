unit StringHelper;

interface

uses
  SysUtils;

type
  TStringHelper = class
  public
    class function IsEmpty(const AValue: String): Boolean;
    class function Capitalize(const AValue: String): String;
    class function RemoveSpaces(const AValue: String): String;
    class function CountWords(const AValue: String): Integer;
  end;

implementation

class function TStringHelper.IsEmpty(const AValue: String): Boolean;
begin
  Result := Trim(AValue) = '';
end;

class function TStringHelper.Capitalize(const AValue: String): String;
begin
  if Length(AValue) = 0 then
    Result := ''
  else
    Result := UpperCase(AValue[1]) + LowerCase(Copy(AValue, 2, Length(AValue) - 1));
end;

class function TStringHelper.RemoveSpaces(const AValue: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AValue) do
  begin
    if AValue[I] <> ' ' then
      Result := Result + AValue[I];
  end;
end;

class function TStringHelper.CountWords(const AValue: String): Integer;
var
  Words: TStringList;
begin
  Words := TStringList.Create;
  try
    Words.Delimiter := ' ';
    Words.DelimitedText := Trim(AValue);
    Result := Words.Count;
  finally
    Words.Free;
  end;
end;

end.

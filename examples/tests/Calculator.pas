unit Calculator;

interface

uses
  SysUtils, Classes;

type
  TCalculator = class
  private
    FResult: Double;
  public
    constructor Create;
    destructor Destroy; override;
    
    function Add(A, B: Double): Double;
    function Subtract(A, B: Double): Double;
    function Multiply(A, B: Double): Double;
    function Divide(A, B: Double): Double;
    
    property Result: Double read FResult write FResult;
  end;

implementation

constructor TCalculator.Create;
begin
  inherited Create;
  FResult := 0.0;
end;

destructor TCalculator.Destroy;
begin
  inherited Destroy;
end;

function TCalculator.Add(A, B: Double): Double;
begin
  FResult := A + B;
  Result := FResult;
end;

function TCalculator.Subtract(A, B: Double): Double;
begin
  FResult := A - B;
  Result := FResult;
end;

function TCalculator.Multiply(A, B: Double): Double;
begin
  FResult := A * B;
  Result := FResult;
end;

function TCalculator.Divide(A, B: Double): Double;
begin
  if B <> 0 then
  begin
    FResult := A / B;
    Result := FResult;
  end
  else
    raise Exception.Create('Division by zero');
end;

end.

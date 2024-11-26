{***************************************************************************}
{                                                                           }
{           OpenPLZ API Delphi Client                                       }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           https://www.openplzapi.org                                      }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenPlzApi.ProblemDetails;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.JSON;

type

  /// <summary>
  /// An exception class representing a Problem Details response according to
  /// <see href="https://datatracker.ietf.org/doc/html/rfc9457">RFC 9457</see>
  /// </summary>
  EOPlzApiProblemDetailsException = class(Exception)
  private
    FType: string;
    FTitle: string;
    FStatus: Integer;
    FErrors: TDictionary<string, TArray<string>>;
    FTraceId: string;
    function ConvertToDictionary(AJsonObject: TJSONObject): TDictionary<string, TArray<string>>;
  public

    /// <summary>
    /// Initializes a new instance of <see cref="EProblemDetailsException" />
    /// </summary>
    /// <param name="AType">The type member of the Problem Details object</param>
    /// <param name="ATitle">The title member of the Problem Details object</param>
    /// <param name="AStatus">The status member of the Problem Details object</param>
    /// <param name="SomeErrors">The errors extension member of the Problem Details object</param>
    /// <param name="ATraceId">The traceId extension member of the Problem Details object</param>
    constructor Create(const AType, ATitle: string; AStatus: Integer;
      SomeErrors: TJSONObject; const ATraceId: string);

    /// <summary>
    /// Object destructor
    /// </summary>
    destructor Destroy; override;

  public

    /// <summary>
    /// The type member of the Problem Details object
    /// </summary>
    property &Type: string read FType;

    /// <summary>
    /// The title member of the Problem Details object
    /// </summary>
    property Title: string read FTitle;

    /// <summary>
    /// The status member of the Problem Details object
    /// </summary>
    property Status: Integer read FStatus;

    /// <summary>
    /// The errors extension member of the Problem Details object
    /// </summary>
    property Errors: TDictionary<string, TArray<string>> read FErrors;

    /// <summary>
    /// The traceId extension member of the Problem Details object
    /// </summary>
    property TraceId: string read FTraceId;

  end;

implementation

{ EOPlzApiProblemDetailsException }

constructor EOPlzApiProblemDetailsException.Create(const AType, ATitle: string;
  AStatus: Integer; SomeErrors: TJSONObject; const ATraceId: string);
begin
  inherited CreateFmt('[Open PLZ API] Error: %s (Status code %d)', [ATitle, AStatus]);
  FType := AType;
  FTitle := ATitle;
  FStatus := AStatus;
  FErrors := ConvertToDictionary(SomeErrors);
  FTraceId := ATraceId;
end;
destructor EOPlzApiProblemDetailsException.Destroy;
begin
  FErrors.Free;
  inherited;
end;
function EOPlzApiProblemDetailsException.ConvertToDictionary(AJsonObject: TJSONObject): TDictionary<string, TArray<string>>;
begin
  Result := TDictionary<string, TArray<string>>.Create;
  if AJsonObject <> nil then
  begin
    for var JsonPair in AJsonObject do
    begin
      var StringArray: TArray<string>;
      for var JsonValue in (JsonPair.JsonValue as TJSONArray) do
      begin
        StringArray := StringArray + [JsonValue.Value];
      end;
      Result.Add(JsonPair.JsonString.Value, StringArray);
    end;
  end;
end;

end.


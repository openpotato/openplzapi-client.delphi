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

unit OpenPlzApi.JsonHelper;

interface

uses
  System.Json,
  System.Generics.Collections,
  REST.Json;

type

  /// <summary>
  /// Static helper functions for <see cref="TJson"/>
  /// </summary>
  TJsonHelper = class helper for TJson
  public

    /// <summary>
    /// Deserializes a JSON string to a typed object list
    /// </summary>
    /// <param name="AJsonString">The JSON formatted string</param>
    /// <param name="SomeOptions">Options for deserialization</param>
    /// <returns>List of objects.</returns>
    class function JsonToList<T: class, constructor>(const AJsonString: string;
      SomeOptions: TJsonOptions = [joDateIsUTC, joDateFormatISO8601, joBytesFormatArray, joIndentCaseCamel]): TObjectList<T>; overload; static;

    /// <summary>
    /// Deserializes a JSON array to a typed object list
    /// </summary>
    /// <param name="AJsonArray">The JSON array string</param>
    /// <param name="SomeOptions">Options for deserialization</param>
    /// <returns>List of objects.</returns>
    class function JsonToList<T: class, constructor>(AJsonArray: TJSONArray;
      SomeOptions: TJsonOptions = [joDateIsUTC, joDateFormatISO8601, joBytesFormatArray, joIndentCaseCamel]): TObjectList<T>; overload; static;

  end;

implementation

{ TJsonHelper }

class function TJsonHelper.JsonToList<T>(const AJsonString: string; SomeOptions: TJsonOptions): TObjectList<T>;
begin
  var JsonValue := TJSONValue.ParseJSONValue(AJsonString);
  try
    if JsonValue is TJSONArray then
      Result := JsonToList<T>(JsonValue as TJSONArray, SomeOptions)
    else
      raise EJSONException.Create('Param AJsonString must be a JSON array');
  finally
    JsonValue.Free;
  end;
end;

class function TJsonHelper.JsonToList<T>(AJsonArray: TJSONArray; SomeOptions: TJsonOptions): TObjectList<T>;
begin
  Result := TObjectList<T>.Create;
  for var JsonValue in AJsonArray do
  begin
    Result.Add(TJson.JsonToObject<T>(TJSONObject(JsonValue), SomeOptions));
  end;
end;

end.


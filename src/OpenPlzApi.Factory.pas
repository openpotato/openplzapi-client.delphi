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

unit OpenPlzApi.Factory;

interface

uses
  System.Net.HttpClient,
  OpenPlzApi,
  OpenPlzApi.AT,
  OpenPlzApi.CH,
  OpenPlzApi.DE,
  OpenPlzApi.LI;

const
  OpenPLzApiBaseUrl= 'https://openplzapi.org';

type

  /// <summary>
  /// An API client factory for all supported API clients (German, Austrian,
  /// Swiss or Liechtenstein)
  /// </summary>
  TOPlzApiClientFactory = class
  public

    /// <summary>
    /// Class function which returns a new instance of a <see cref="TOPlzApiBaseClient" /> derived class
    /// </summary>
    /// <typeparam name="T">The derived class type</typeparam>
    /// <param name="ABaseUrl">The base url of the OpenPLZ API service</param>
    /// <returns>The instance of the <see cref="TOPlzApiBaseClient" /> derived class.</returns>
    class function CreateClient<T: TOPlzApiBaseClient>(
      const ABaseUrl: string = OpenPLzApiBaseUrl): T; overload;

    /// <summary>
    /// Class function which returns a new instance of a <see cref="TOPlzApiAbstractClient" /> derived class
    /// </summary>
    /// <typeparam name="T">The derived class type</typeparam>
    /// <param name="AHttpClient">An HTTP client instance</param>
    /// <param name="ABaseUrl">The base url of the OpenPLZ API service</param>
    /// <returns>The instance of the <see cref="TOPlzApiBaseClient" /> derived class.</returns>
    class function CreateClient<T: TOPlzApiBaseClient>(
      AHttpClient: THTTPClient;
      const ABaseUrl: string = OpenPLzApiBaseUrl): T; overload;

  end;

implementation

uses
  System.Rtti, System.SysUtils;

{ TOPlzApiClientFactory }

class function TOPlzApiClientFactory.CreateClient<T>(const ABaseUrl: string): T;
begin
  var RttiContext := TRttiContext.Create;
  try

    var RttiType := RttiContext.GetType(T);

    for var RttiMethod in RttiType.GetMethods do
    begin
      if RttiMethod.IsConstructor and (Length(RttiMethod.GetParameters) = 1) and
         (RttiMethod.GetParameters[0].ParamType.Handle = TypeInfo(string)) then
      begin
        Exit(T(RttiMethod.Invoke(T, [ABaseUrl]).AsObject));
      end;
    end;

    raise EInvalidOpException.CreateFmt('No matching constructor found for type %s', [RttiType.QualifiedName]);

  finally
    RttiContext.Free;
  end;
end;

class function TOPlzApiClientFactory.CreateClient<T>(AHttpClient: THTTPClient; const ABaseUrl: string): T;
begin
  var RttiContext := TRttiContext.Create;
  try

    var RttiType := RttiContext.GetType(T);

    for var RttiMethod in RttiType.GetMethods do
    begin
      if RttiMethod.IsConstructor and (Length(RttiMethod.GetParameters) = 2) and
         (RttiMethod.GetParameters[0].ParamType.Handle = TypeInfo(THTTPClient)) and
         (RttiMethod.GetParameters[1].ParamType.Handle = TypeInfo(string)) then
      begin
        Exit(T(RttiMethod.Invoke(T, [AHttpClient, ABaseUrl]).AsObject));
      end;
    end;

    raise EInvalidOpException.CreateFmt('No matching constructor found for type %s', [RttiType.QualifiedName]);

  finally
    RttiContext.Free;
  end;
end;

end.

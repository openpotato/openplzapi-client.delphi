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

unit OpenPlzApi;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.NetConsts,
  System.Net.HttpClient,
  System.Net.UrlClient,
  System.JSON,
  REST.Json,
  REST.Json.Types,
  OpenPlzApi.Pagination,
  OpenPlzApi.ProblemDetails;

type

  /// <summary>
  /// Abstract base entity for all OpenPLZ API entities
  /// </summary>
  TOPlzApiEntity = class abstract
  public
    constructor Create;
  end;

  /// <summary>
  /// Abstract base client for all supported countries
  /// </summary>
  TOPlzApiBaseClient = class abstract
  private
    FBaseUrl: string;
    FHttpClient: THTTPClient;
    FHttpClientOwned: Boolean;
    procedure HandleProblemDetails(const AResponse: IHTTPResponse);
  protected
    function GetList<T: TOPlzApiEntity, constructor>(const ARelativeURL: string): IReadOnlyCollection<T>;
    function GetPage<T: TOPlzApiEntity, constructor>(const ARelativeURL: string; ANextPageFunc: TFunc<IReadOnlyPagedCollection<T>>): IReadOnlyPagedCollection<T>;
  public
    constructor Create(const ABaseUrl: string); overload; virtual;
    constructor Create(AHttpClient: THTTPClient; const ABaseUrl: string); overload; virtual;
    destructor Destroy; override;
  public
    property BaseUrl: string read FBaseUrl;
  end;

implementation

uses
  OpenPlzApi.JsonHelper;

{ TOPlzApiEntity }

constructor TOPlzApiEntity.Create;
begin
end;

{ TOPlzApiAbstractClient }

constructor TOPlzApiBaseClient.Create(const ABaseUrl: string);
begin
  FBaseUrl := ABaseUrl;
  FHttpClient := THTTPClient.Create;
  FHttpClient.UserAgent := 'OpenPLZ API Delphi Client';
  FHttpClientOwned := true;
end;

constructor TOPlzApiBaseClient.Create(AHttpClient: THTTPClient; const ABaseUrl: string);
begin
  FBaseUrl := ABaseUrl;
  FHttpClient := AHTTPClient;
  FHttpClientOwned := false;
end;

destructor TOPlzApiBaseClient.Destroy;
begin
  if FHttpClientOwned then
  begin
    FHttpClient.Free;
    FHttpClient := nil;
  end;
  inherited;
end;

function TOPlzApiBaseClient.GetList<T>(const ARelativeURL: string): IReadOnlyCollection<T>;
begin
  var HttpResponseContent := TStringStream.Create('', TEncoding.UTF8);
  try

    var Url := FBaseUrl + '/' + ARelativeURL;
    var AcceptHeader := TNetHeader.Create('Accept', 'application/json');
    var HttpResponse := FHttpClient.Get(URL, HttpResponseContent, [AcceptHeader]);

    if HttpResponse.StatusCode = 200 then
    begin
      Result := TReadOnlyCollection<T>.Create(TJson.JsonToList<T>(HttpResponseContent.DataString));
    end else
      HandleProblemDetails(HttpResponse);

  finally
    HttpResponseContent.Free;
  end;
end;

function TOPlzApiBaseClient.GetPage<T>(const ARelativeURL: string; ANextPageFunc: TFunc<IReadOnlyPagedCollection<T>>): IReadOnlyPagedCollection<T>;
begin
  var HttpResponseContent := TStringStream.Create('', TEncoding.UTF8);
  try

    var Url := FBaseUrl + '/' + ARelativeURL;
    var AcceptHeader := TNetHeader.Create('Accept', 'application/json');
    var HttpResponse := FHttpClient.Get(URL, HttpResponseContent, [AcceptHeader]);

    if HttpResponse.StatusCode = 200 then
    begin
      Result := TReadOnlyPagedCollection<T>.Create(
        TJson.JsonToList<T>(HttpResponseContent.DataString),
        StrToIntDef(HttpResponse.HeaderValue['x-page'], -1),
        StrToIntDef(HttpResponse.HeaderValue['x-page-size'], -1),
        StrToIntDef(HttpResponse.HeaderValue['x-total-pages'], -1),
        StrToIntDef(HttpResponse.HeaderValue['x-total-count'], -1),
        ANextPageFunc
      );
    end else
      HandleProblemDetails(HttpResponse);

  finally
    HttpResponseContent.Free;
  end;
end;

procedure TOPlzApiBaseClient.HandleProblemDetails(const AResponse: IHTTPResponse);
begin
  if AResponse.StatusCode >= 400 then
  begin
    var s := AResponse.GetMimeType();
    if s.StartsWith('application/problem+json', true) then
    begin
      var JsonObject := TJSONObject.ParseJSONValue(AResponse.ContentAsString) as TJSONObject;
      try
        raise EOPlzApiProblemDetailsException.Create(
          JsonObject.GetValue<string>('type', ''),
          JsonObject.GetValue<string>('title', ''),
          JsonObject.GetValue<Integer>('status', -1),
          JsonObject.GetValue<TJSONObject>('errors', nil),
          JsonObject.GetValue<string>('traceId', '')
        );
      finally
        JsonObject.Free;
      end;
    end else
      raise ENetException.CreateFmt('[Open PLZ API] Error: %s (Status code %d)', [AResponse.StatusText, AResponse.StatusCode]);
  end;
end;

end.

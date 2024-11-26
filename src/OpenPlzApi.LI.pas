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

unit OpenPlzApi.LI;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetEncoding,
  REST.Json,
  OpenPlzApi,
  OpenPlzApi.Pagination;

type

  /// <summary>
  /// Represents a Liechtenstein commune (Gemeinde)
  /// </summary>
  TCommune = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
    FElectoralDistrict: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property ElectoralDistrict: string read FElectoralDistrict;
  end;

  /// <summary>
  /// A stripped down version of TCommune
  /// </summary>
  TCommuneSummary = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
  end;

  /// <summary>
  /// Represents a locality in Liechtenstein
  /// </summary>
  TLocality = class(TOPlzApiEntity)
  private
    FPostalCode: string;
    FName: string;
    FCommune: TCommuneSummary;
  public
    property PostalCode: string read FPostalCode;
    property Name: string read FName;
    property Commune: TCommuneSummary read FCommune;
  end;

  /// <summary>
  /// Street types
  /// </summary>
  TStreetStatus = (ssNone, ssPlanned, ssReal, ssOutdated);

  /// <summary>
  /// Represents a street in Liechtenstein
  /// </summary>
  TStreet = class(TOPlzApiEntity)
  private
    FPostalCode: string;
    FLocality: string;
    FName: string;
    FKey: string;
    FCommune: TCommuneSummary;
    FStatus: string;
    function GetStatus: TStreetStatus;
  public
    property PostalCode: string read FPostalCode;
    property Locality: string read FLocality;
    property Name: string read FName;
    property Key: string read FKey;
    property Commune: TCommuneSummary read FCommune;
    property Status: TStreetStatus read GetStatus;
  end;

  /// <summary>
  /// Client for the Liechtenstein API endpoint of the OpenPLZ API
  /// </summary>
  TOPlzApiClientForLiechtenstein = class(TOPlzApiBaseClient)
  public

    /// <summary>
    /// Returns all communes (Gemeinden)
    /// </summary>
    function GetCommunes(): IReadOnlyCollection<TCommune>;

    /// <summary>
    /// Returns all localities whose postal code and/or name matches the given patterns
    /// and gives back a paged list of results.
    /// </summary>
    function GetLocalities(const APostalCode, AName: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TLocality>;

    /// <summary>
    /// Returns all streets whose name, postal code and/or name matches the given patterns
    /// and gives back a paged list of results.
    /// </summary>
    function GetStreets(const AName, APostalCode, ALocality: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TStreet>;

    /// <summary>
    /// Performs a full-text search using the street name, postal code and locality
    /// and gives back a paged list of results.
    /// </summary>
    function PerformFullTextSearch(const ASearchTerm: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TStreet>;

  end;

implementation

uses
  OpenPlzApi.StrUtils;

{ TStreet }

function TStreet.GetStatus: TStreetStatus;
begin
  if FStatus = 'None' then Result := ssNone else
  if FStatus = 'Planned' then Result := ssPlanned else
  if FStatus = 'Real' then Result := ssReal else
  if FStatus = 'Outdated' then Result := ssOutdated else
  raise ENotSupportedException.Create('Unknown status');
end;

{ TOPlzApiClientForLiechtenstein }

function TOPlzApiClientForLiechtenstein.GetCommunes: IReadOnlyCollection<TCommune>;
begin
  Result := GetList<TCommune>('li/Communes');
end;

function TOPlzApiClientForLiechtenstein.GetLocalities(const APostalCode, AName: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TLocality>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APostalCode <> '' then UrlParams := CombineStr(UrlParams, Format('postalCode=%s', [TNetEncoding.Url.Encode(APostalCode)]), '&');
  if AName <> '' then UrlParams := CombineStr(UrlParams, Format('name=%s', [TNetEncoding.Url.Encode(AName)]), '&');
  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TLocality>(CombineStr('li/Localities', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TLocality>
    begin
      Result := GetLocalities(APostalCode, AName, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForLiechtenstein.GetStreets(const AName, APostalCode, ALocality: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TStreet>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if AName <> '' then UrlParams := CombineStr(UrlParams, Format('name=%s', [TNetEncoding.Url.Encode(AName)]), '&');
  if APostalCode <> '' then UrlParams := CombineStr(UrlParams, Format('postalCode=%s', [TNetEncoding.Url.Encode(APostalCode)]), '&');
  if ALocality <> '' then UrlParams := CombineStr(UrlParams, Format('locality=%s', [TNetEncoding.Url.Encode(ALocality)]), '&');
  if APageIndex > 0 then UrlParams := CombineStr(UrlParams, Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TStreet>(CombineStr('li/Streets', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TStreet>
    begin
      Result := GetStreets(AName, APostalCode, ALocality, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForLiechtenstein.PerformFullTextSearch(const ASearchTerm: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TStreet>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if ASearchTerm <> '' then UrlParams := CombineStr(UrlParams, Format('searchterm=%s', [TNetEncoding.Url.Encode(ASearchTerm)]), '&');
  if APageIndex > 0 then UrlParams := CombineStr(UrlParams, Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TStreet>(CombineStr('li/FullTextSearch', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TStreet>
    begin
      Result := PerformFullTextSearch(ASearchTerm, APageIndex + 1, APageSize);
    end);

end;

end.

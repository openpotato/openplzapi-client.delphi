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

unit OpenPlzApi.CH;

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
  /// Represents a Swiss canton (Kanton)
  /// </summary>
  TCanton = class(TOPlzApiEntity)
  private
    FKey: string;
    FHistoricalCode: string;
    FName: string;
    FShortName: string;
  public
    property Key: string read FKey;
    property HistoricalCode: string read FHistoricalCode;
    property Name: string read FName;
    property ShortName: string read FShortName;
  end;

  /// <summary>
  /// A stripped down version of TCanton
  /// </summary>
  TCantonSummary = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
    FShortName: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property ShortName: string read FShortName;
  end;

  /// <summary>
  /// Represents a Swiss district (Bezirk)
  /// </summary>
  TDistrict = class(TOPlzApiEntity)
  private
    FKey: string;
    FHistoricalCode: string;
    FName: string;
    FShortName: string;
    FCanton: TCantonSummary;
  public
    property Key: string read FKey;
    property HistoricalCode: string read FHistoricalCode;
    property Name: string read FName;
    property ShortName: string read FShortName;
    property Canton: TCantonSummary read FCanton;
  end;

  /// <summary>
  /// A stripped down version of TDistrict
  /// </summary>
  TDistrictSummary = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
    FShortName: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property ShortName: string read FShortName;
  end;

  /// <summary>
  /// Represents a Swiss commune (Gmeinde)
  /// </summary>
  TCommune = class(TOPlzApiEntity)
  private
    FKey: string;
    FHistoricalCode: string;
    FName: string;
    FShortName: string;
    FCanton: TCantonSummary;
    FDistrict: TDistrictSummary;
  public
    property Key: string read FKey;
    property HistoricalCode: string read FHistoricalCode;
    property Name: string read FName;
    property ShortName: string read FShortName;
    property Canton: TCantonSummary read FCanton;
    property District: TDistrictSummary read FDistrict;
  end;

  /// <summary>
  /// A stripped down version of TCommune
  /// </summary>
  TCommuneSummary = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
    FShortName: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property ShortName: string read FShortName;
  end;

  /// <summary>
  /// Represents a locality in Switzerland
  /// </summary>
  TLocality = class(TOPlzApiEntity)
  private
    FPostalCode: string;
    FName: string;
    FDistrict: TDistrictSummary;
    FCanton: TCantonSummary;
    FCommune: TCommuneSummary;
  public
    property PostalCode: string read FPostalCode;
    property Name: string read FName;
    property District: TDistrictSummary read FDistrict;
    property Canton: TCantonSummary read FCanton;
    property Commune: TCommuneSummary read FCommune;
  end;

  /// <summary>
  /// Street types
  /// </summary>
  TStreetStatus = (ssNone, ssPlanned, ssReal, ssOutdated);

  /// <summary>
  /// Represents a street in Switzerland
  /// </summary>
  TStreet = class(TOPlzApiEntity)
  private
    FPostalCode: string;
    FLocality: string;
    FName: string;
    FKey: string;
    FDistrict: TDistrictSummary;
    FCanton: TCantonSummary;
    FCommune: TCommuneSummary;
    FStatus: string;
    function GetStatus: TStreetStatus;
  public
    property PostalCode: string read FPostalCode;
    property Locality: string read FLocality;
    property Name: string read FName;
    property Key: string read FKey;
    property District: TDistrictSummary read FDistrict;
    property Canton: TCantonSummary read FCanton;
    property Commune: TCommuneSummary read FCommune;
    property Status: TStreetStatus read GetStatus;
  end;

  /// <summary>
  /// Client for the Swiss API endpoint of the OpenPLZ API
  /// </summary>
  TOPlzApiClientForSwitzerland = class(TOPlzApiBaseClient)
  public

    /// <summary>
    /// Returns all cantons (Kantone).
    /// </summary>
    function GetCantons: IReadOnlyCollection<TCanton>;

    /// <summary>
    /// Returns all districts (Bezirke) within a canton (Kanton)
    /// and gives back a paged list of results.
    /// </summary>
    function GetDistrictsByCanton(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TDistrict>;

    /// <summary>
    /// Returns all communes (Gemeinden) within a canton (Kanton)
    /// and gives back a paged list of results.
    /// </summary>
    function GetCommunesByCanton(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TCommune>;

    /// <summary>
    /// Returns all communes (Gemeinden) within a district (Bezirk)
    /// and gives back a paged list of results.
    /// </summary>
    function GetCommunesByDistrict(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TCommune>;

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

{ TOPlzApiClientForSwitzerland }

function TOPlzApiClientForSwitzerland.GetCantons: IReadOnlyCollection<TCanton>;
begin
  Result := GetList<TCanton>('ch/Cantons');
end;

function TOPlzApiClientForSwitzerland.GetDistrictsByCanton(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TDistrict>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TDistrict>(CombineStr(Format('ch/Cantons/%s/Districts', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TDistrict>
    begin
      Result := GetDistrictsByCanton(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForSwitzerland.GetCommunesByCanton(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TCommune>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TCommune>(CombineStr(Format('ch/Cantons/%s/Communes', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TCommune>
    begin
      Result := GetCommunesByCanton(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForSwitzerland.GetCommunesByDistrict(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TCommune>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TCommune>(Format('ch/Districts/%s/Communes', [AKey]),

    function(): IReadOnlyPagedCollection<TCommune>
    begin
      Result := GetCommunesByDistrict(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForSwitzerland.GetLocalities(const APostalCode, AName: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TLocality>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APostalCode <> '' then UrlParams := CombineStr(UrlParams, Format('postalCode=%s', [TNetEncoding.Url.Encode(APostalCode)]), '&');
  if AName <> '' then UrlParams := CombineStr(UrlParams, Format('name=%s', [TNetEncoding.Url.Encode(AName)]), '&');
  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TLocality>(CombineStr('ch/Localities', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TLocality>
    begin
      Result := GetLocalities(APostalCode, AName, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForSwitzerland.GetStreets(const AName, APostalCode, ALocality: string;
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

  Result := GetPage<TStreet>(CombineStr('ch/Streets', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TStreet>
    begin
      Result := GetStreets(AName, APostalCode, ALocality, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForSwitzerland.PerformFullTextSearch(const ASearchTerm: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TStreet>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if ASearchTerm <> '' then UrlParams := CombineStr(UrlParams, Format('searchterm=%s', [TNetEncoding.Url.Encode(ASearchTerm)]), '&');
  if APageIndex > 0 then UrlParams := CombineStr(UrlParams, Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TStreet>(CombineStr('ch/FullTextSearch', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TStreet>
    begin
      Result := PerformFullTextSearch(ASearchTerm, APageIndex + 1, APageSize);
    end);

end;

end.

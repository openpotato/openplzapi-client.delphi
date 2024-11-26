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

unit OpenPlzApi.AT;

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
  /// Represents an Austrian federal province (Bundesland)
  /// </summary>
  TFederalProvince = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
  end;

  /// <summary>
  /// A stripped down version of TFederalProvince
  /// </summary>
  TFederalProvinceSummary = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
  end;

  /// <summary>
  /// Represents an Austrian district (Bezirk)
  /// </summary>
  TDistrict = class(TOPlzApiEntity)
  public
    FKey: string;
    FCode: string;
    FName: string;
    FFederalProvince: TFederalProvinceSummary;
  public
    property Key: string read FKey;
    property Code: string read FCode;
    property Name: string read FName;
    property FederalProvince: TFederalProvinceSummary read FFederalProvince;
  end;

  /// <summary>
  /// A stripped down version of TDistrict
  /// </summary>
  TDistrictSummary = class(TOPlzApiEntity)
  private
    FKey: string;
    FCode: string;
    FName: string;
  public
    property Key: string read FKey;
    property Code: string read FCode;
    property Name: string read FName;
  end;

  /// <summary>
  /// Represents an Austrian municipality (Gemeinde)
  /// </summary>
  TMunicipality = class(TOPlzApiEntity)
  private
    FKey: string;
    FCode: string;
    FName: string;
    FDistrict: TDistrictSummary;
    FFederalProvince: TFederalProvinceSummary;
    FMultiplePostalCodes: boolean;
    FPostalCode: string;
    FStatus: string;
  public
    property Key: string read FKey;
    property Code: string read FCode;
    property Name: string read FName;
    property District: TDistrictSummary read FDistrict;
    property FederalProvince: TFederalProvinceSummary read FFederalProvince;
    property MultiplePostalCodes: boolean read FMultiplePostalCodes;
    property PostalCode: string read FPostalCode;
    property Status: string read FStatus;
  end;

  /// <summary>
  /// A stripped down version of TMunicipality
  /// </summary>
  TMunicipalitySummary = class
  private
    FKey: string;
    FCode: string;
    FName: string;
    FStatus: string;
  public
    property Key: string read FKey;
    property Code: string read FCode;
    property Name: string read FName;
    property Status: string read FStatus;
  end;

  /// <summary>
  /// Represents a locality in Austria
  /// </summary>
  TLocality = class(TOPlzApiEntity)
  private
    FPostalCode: string;
    FName: string;
    FKey: string;
    FDistrict: TDistrictSummary;
    FFederalProvince: TFederalProvinceSummary;
    FMunicipality: TMunicipalitySummary;
  public
    property PostalCode: string read FPostalCode;
    property Name: string read FName;
    property Key: string read FKey ;
    property District: TDistrictSummary read FDistrict;
    property FederalProvince: TFederalProvinceSummary read FFederalProvince;
    property Municipality: TMunicipalitySummary read FMunicipality;
  end;

  /// <summary>
  /// Represents a street in Austria
  /// </summary>
  TStreet = class(TOPlzApiEntity)
  private
    FPostalCode: string;
    FLocality: string;
    FName: string;
    FKey: string;
    FDistrict: TDistrictSummary;
    FFederalProvince: TFederalProvinceSummary;
    FMunicipality: TMunicipalitySummary;
  public
    property PostalCode: string read FPostalCode;
    property Locality: string read FLocality;
    property Name: string read FName;
    property Key: string read FKey;
    property District: TDistrictSummary read FDistrict;
    property FederalProvince: TFederalProvinceSummary read FFederalProvince;
    property Municipality: TMunicipalitySummary read FMunicipality;
  end;

  /// <summary>
  /// Client for the Austrian API endpoint of the OpenPLZ API
  /// </summary>
  TOPlzApiClientForAustria = class(TOPlzApiBaseClient)
  public

    /// <summary>
    /// Returns all federal provinces (Bundesländer).
    /// </summary>
    function GetFederalProvinces: IReadOnlyCollection<TFederalProvince>;

    /// <summary>
    /// Returns all districts (Bezirke) within a federal province (Bundesland)
    /// and gives back a paged list of results.
    /// </summary>
    function GetDistrictsByFederalProvince(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TDistrict>;

    /// <summary>
    /// Returns all municipalities (Gemeinden) within a federal province (Bundesland)
    /// and gives back a paged list of results.
    /// </summary>
    function GetMunicipalitiesByFederalProvince(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TMunicipality>;

    /// <summary>
    /// Returns all municipalities (Gemeinden) within a district (Bezirk)
    /// and gives back a paged list of results.
    /// </summary>
    function GetMunicipalitiesByDistrict(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TMunicipality>;

    /// <summary>
    /// Returns all localities whose postal code and/or name matches the given patterns
    /// and gives back a paged list of results.
    /// </summary>
    function GetLocalities(const APostalCode, AName: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TLocality>;

    /// <summary>
    /// Returns all streets whose name, postal code and/or name matches the given patterns.
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

{ TOPlzApiClientForAustria }

function TOPlzApiClientForAustria.GetFederalProvinces: IReadOnlyCollection<TFederalProvince>;
begin
  Result := GetList<TFederalProvince>('at/FederalProvinces');
end;

function TOPlzApiClientForAustria.GetDistrictsByFederalProvince(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TDistrict>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TDistrict>(CombineStr(Format('at/FederalProvinces/%s/Districts', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TDistrict>
    begin
      Result := GetDistrictsByFederalProvince(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForAustria.GetMunicipalitiesByFederalProvince(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TMunicipality>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TMunicipality>(CombineStr(Format('at/FederalProvinces/%s/Municipalities', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TMunicipality>
    begin
      Result := GetMunicipalitiesByFederalProvince(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForAustria.GetMunicipalitiesByDistrict(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TMunicipality>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TMunicipality>(CombineStr(Format('at/Districts/%s/Municipalities', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TMunicipality>
    begin
      Result := GetMunicipalitiesByDistrict(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForAustria.GetLocalities(const APostalCode, AName: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TLocality>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APostalCode <> '' then UrlParams := CombineStr(UrlParams, Format('postalCode=%s', [TNetEncoding.Url.Encode(APostalCode)]), '&');
  if AName <> '' then UrlParams := CombineStr(UrlParams, Format('name=%s', [TNetEncoding.Url.Encode(AName)]), '&');
  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TLocality>(CombineStr('at/Localities', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TLocality>
    begin
      Result := GetLocalities(APostalCode, AName, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForAustria.GetStreets(const AName, APostalCode, ALocality: string;
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

  Result := GetPage<TStreet>(CombineStr('at/Streets', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TStreet>
    begin
      Result := GetStreets(AName, APostalCode, ALocality, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForAustria.PerformFullTextSearch(const ASearchTerm: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TStreet>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if ASearchTerm <> '' then UrlParams := CombineStr(UrlParams, Format('searchterm=%s', [TNetEncoding.Url.Encode(ASearchTerm)]), '&');
  if APageIndex > 0 then UrlParams := CombineStr(UrlParams, Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TStreet>(CombineStr('at/FullTextSearch', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TStreet>
    begin
      Result := PerformFullTextSearch(ASearchTerm, APageIndex + 1, APageSize);
    end);

end;

end.

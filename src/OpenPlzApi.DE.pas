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

unit OpenPlzApi.DE;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetEncoding,
  REST.Json,
  REST.Json.Types,
  OpenPlzApi,
  OpenPlzApi.Pagination;

type

  /// <summary>
  /// Represents a German federal state (Bundesland)
  /// </summary>
  TFederalState = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
    FSeatOfGovernment: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property SeatOfGovernment: string read FSeatOfGovernment;
  end;

  /// <summary>
  /// A stripped down version of TFederalState
  /// </summary>
  TFederalStateSummary = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
  end;

  /// <summary>
  /// Represents a German government region (Regierungsbezirk)
  /// </summary>
  TGovernmentRegion = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
    FAdministrativeHeadquarters: string;
    FFederalState: TFederalStateSummary;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property AdministrativeHeadquarters: string read FAdministrativeHeadquarters;
    property FederalState: TFederalStateSummary read FFederalState;
  end;

  /// <summary>
  /// A stripped down version of TGovernmentRegion
  /// </summary>
  TGovernmentRegionSummary = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
  end;

  /// <summary>
  /// Represents a German district (Kreisd)
  /// </summary>
  TDistrict = class(TOPlzApiEntity)
  public
    FKey: string;
    FName: string;
    FAdministrativeHeadquarters: string;
    FType: string;
    FFederalState: TFederalStateSummary;
    FGovernmentRegion: TGovernmentRegionSummary;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property DistrictType: string read FType;
    property AdministrativeHeadquarters: string read FAdministrativeHeadquarters;
    property FederalState: TFederalStateSummary read FFederalState;
    property GovernmentRegion: TGovernmentRegionSummary read FGovernmentRegion;
  end;

  /// <summary>
  /// A stripped down version of TDistrict
  /// </summary>
  TDistrictSummary = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
    FType: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property DistrictType: string read FType;
  end;

  /// <summary>
  /// Represents a German municipal association (Gemeindeverband)
  /// </summary>
  TMunicipalAssociation = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
    FDistrict: TDistrictSummary;
    FFederalState: TFederalStateSummary;
    FGovernmentRegion: TGovernmentRegionSummary;
    FMultiplePostalCodes: boolean;
    FPostalCode: string;
    FType: string;
    FAdministrativeHeadquarters: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property District: TDistrictSummary read FDistrict;
    property FederalState: TFederalStateSummary read FFederalState;
    property GovernmentRegion: TGovernmentRegionSummary read FGovernmentRegion;
    property MultiplePostalCodes: boolean read FMultiplePostalCodes;
    property PostalCode: string read FPostalCode;
    property AssociationType: string read FType;
    property AdministrativeHeadquarters: string read FAdministrativeHeadquarters;
  end;

  /// <summary>
  /// A stripped down version of TMunicipalAssociation
  /// </summary>
  TMunicipalAssociationSummary = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
    FType: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property AssociationType: string read FType;
  end;

  /// <summary>
  /// Represents a German municipality (Gemeinde)
  /// </summary>
  TMunicipality = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
    FAssociation: TMunicipalAssociationSummary;
    FDistrict: TDistrictSummary;
    FFederalState: TFederalStateSummary;
    FGovernmentRegion: TGovernmentRegionSummary;
    FMultiplePostalCodes: boolean;
    FPostalCode: string;
    FType: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property Association: TMunicipalAssociationSummary read FAssociation;
    property District: TDistrictSummary read FDistrict;
    property FederalState: TFederalStateSummary read FFederalState;
    property GovernmentRegion: TGovernmentRegionSummary read FGovernmentRegion;
    property MultiplePostalCodes: boolean read FMultiplePostalCodes;
    property PostalCode: string read FPostalCode;
    property MunicipalityType: string read FType;
  end;

  /// <summary>
  /// A stripped down version of TMunicipality
  /// </summary>
  TMunicipalitySummary = class(TOPlzApiEntity)
  private
    FKey: string;
    FName: string;
    FType: string;
  public
    property Key: string read FKey;
    property Name: string read FName;
    property MunicipalityType: string read FType;
  end;

  /// <summary>
  /// Represents a locality in Germany
  /// </summary>
  TLocality = class(TOPlzApiEntity)
  private
    FPostalCode: string;
    FName: string;
    FDistrict: TDistrictSummary;
    FFederalState: TFederalStateSummary;
    FMunicipality: TMunicipalitySummary;
  public
    property PostalCode: string read FPostalCode;
    property Name: string read FName;
    property District: TDistrictSummary read FDistrict;
    property FederalState: TFederalStateSummary read FFederalState;
    property Municipality: TMunicipalitySummary read FMunicipality;
  end;

  /// <summary>
  /// Represents a street in Germany
  /// </summary>
  TStreet = class(TOPlzApiEntity)
  private
    FPostalCode: string;
    FLocality: string;
    FName: string;
    FBorough: string;
    FSuburb: string;
    FDistrict: TDistrictSummary;
    FFederalState: TFederalStateSummary;
    FMunicipality: TMunicipalitySummary;
  public
    property PostalCode: string read FPostalCode;
    property Locality: string read FLocality;
    property Name: string read FName;
    property Borough: string read FBorough;
    property Suburb: string read FSuburb;
    property District: TDistrictSummary read FDistrict;
    property FederalState: TFederalStateSummary read FFederalState;
    property Municipality: TMunicipalitySummary read FMunicipality;
  end;

  /// <summary>
  /// Client for the German API endpoint of the OpenPLZ API
  /// </summary>
  TOPlzApiClientForGermany = class(TOPlzApiBaseClient)
  public

    /// <summary>
    /// Returns all federal states (Bundesländer).
    /// </summary>
    function GetFederalStates: IReadOnlyCollection<TFederalState>;

    /// <summary>
    /// Returns all government regions (Regierungsbezirke) within a federal state (Bundesland)
    /// and gives back a paged list of results.
    /// </summary>
    function GetGovernmentRegionsByFederalState(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TGovernmentRegion>;

    /// <summary>
    /// Returns all districts (Kreise) within a federal state (Bundesland) and gives back a
    /// paged list of results.
    /// </summary>
    function GetDistrictsByFederalState(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TDistrict>;

    /// <summary>
    /// Returns all districts (Kreise) within a government region (Regierungsbezirk) and gives back a
    /// paged list of results.
    /// </summary>
    function GetDistrictsByGovernmentRegion(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TDistrict>;

    /// <summary>
    /// Returns all municipal associations (Gemeindeverbände) within a federal state (Bundesland) and
    /// gives back a paged list of results.
    /// </summary>
    function GetMunicipalAssociationsByFederalState(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TMunicipalAssociation>;

    /// <summary>
    /// Returns all municipal associations (Gemeindeverbände) within a government region (Regierungsbezirk)
    /// and gives back a paged list of results.
    /// </summary>
    function GetMunicipalAssociationsByGovernmentRegion(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TMunicipalAssociation>;

    /// <summary>
    /// Returns all municipal associations (Gemeindeverbände) within a district (Kreis) and gives back a
    /// paged list of results.
    /// </summary>
    function GetMunicipalAssociationsByDistrict(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TMunicipalAssociation>;

    /// <summary>
    /// Returns all municipalities (Gemeinden) within a federal state (Bundesland) and gives back a
    /// paged list of results.
    /// </summary>
    function GetMunicipalitiesByFederalState(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TMunicipality>;

    /// <summary>
    /// Returns all municipalities (Gemeinden) within a government region (Regierungsbezirk) and gives back a
    /// paged list of results.
    /// </summary>
    function GetMunicipalitiesByGovernmentRegion(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TMunicipality>;

    /// <summary>
    /// Returns all municipalities (Gemeinden) within a district (Kreis) and gives back a
    /// paged list of results.
    /// </summary>
    function GetMunicipalitiesByDistrict(const AKey: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TMunicipality>;

    /// <summary>
    /// Returns all localities whose postal code and/or name matches the given patterns and gives back a
    /// paged list of results.
    /// </summary>
    function GetLocalities(const APostalCode, AName: string;
      APageIndex: Integer = 1; APageSize: Integer = 50): IReadOnlyPagedCollection<TLocality>;

    /// <summary>
    /// Returns all streets whose name, postal code and/or name matches the given patterns and gives back a
    /// paged list of results.
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

{ TOPlzApiClient }

function TOPlzApiClientForGermany.GetFederalStates: IReadOnlyCollection<TFederalState>;
begin
  Result := GetList<TFederalState>('de/FederalStates');
end;

function TOPlzApiClientForGermany.GetDistrictsByFederalState(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TDistrict>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TDistrict>(CombineStr(Format('de/FederalStates/%s/Districts', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TDistrict>
    begin
      Result := GetDistrictsByFederalState(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForGermany.GetDistrictsByGovernmentRegion(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TDistrict>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TDistrict>(CombineStr(Format('de/GovernmentRegions/%s/Districts', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TDistrict>
    begin
      Result := GetDistrictsByGovernmentRegion(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForGermany.GetGovernmentRegionsByFederalState(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TGovernmentRegion>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TGovernmentRegion>(CombineStr(Format('de/FederalStates/%s/GovernmentRegions', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TGovernmentRegion>
    begin
      Result := GetGovernmentRegionsByFederalState(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForGermany.GetMunicipalAssociationsByFederalState(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TMunicipalAssociation>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TMunicipalAssociation>(CombineStr(Format('de/FederalStates/%s/MunicipalAssociations', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TMunicipalAssociation>
    begin
      Result := GetMunicipalAssociationsByFederalState(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForGermany.GetMunicipalAssociationsByGovernmentRegion(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TMunicipalAssociation>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TMunicipalAssociation>(CombineStr(Format('de/GovernmentRegions/%s/MunicipalAssociations', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TMunicipalAssociation>
    begin
      Result := GetMunicipalAssociationsByGovernmentRegion(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForGermany.GetMunicipalAssociationsByDistrict(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TMunicipalAssociation>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TMunicipalAssociation>(CombineStr(Format('de/Districts/%s/MunicipalAssociations', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TMunicipalAssociation>
    begin
      Result := GetMunicipalAssociationsByDistrict(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForGermany.GetMunicipalitiesByFederalState(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TMunicipality>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TMunicipality>(CombineStr(Format('de/FederalStates/%s/Municipalities', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TMunicipality>
    begin
      Result := GetMunicipalitiesByFederalState(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForGermany.GetMunicipalitiesByGovernmentRegion(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TMunicipality>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TMunicipality>(CombineStr(Format('de/GovernmentRegions/%s/Municipalities', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TMunicipality>
    begin
      Result := GetMunicipalitiesByGovernmentRegion(AKey, APageIndex + 1, APageSize);
    end);

end;


function TOPlzApiClientForGermany.GetMunicipalitiesByDistrict(const AKey: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TMunicipality>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TMunicipality>(CombineStr(Format('de/Districts/%s/Municipalities', [AKey]), UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TMunicipality>
    begin
      Result := GetMunicipalitiesByDistrict(AKey, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForGermany.GetLocalities(const APostalCode, AName: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TLocality>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if APostalCode <> '' then UrlParams := CombineStr(UrlParams, Format('postalCode=%s', [TNetEncoding.Url.Encode(APostalCode)]), '&');
  if AName <> '' then UrlParams := CombineStr(UrlParams, Format('name=%s', [TNetEncoding.Url.Encode(AName)]), '&');
  if APageIndex > 0 then UrlParams := CombineStr(UrlParams,Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TLocality>(CombineStr('de/Localities', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TLocality>
    begin
      Result := GetLocalities(APostalCode, AName, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForGermany.GetStreets(const AName, APostalCode, ALocality: string;
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

  Result := GetPage<TStreet>(CombineStr('de/Streets', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TStreet>
    begin
      Result := GetStreets(AName, APostalCode, ALocality, APageIndex + 1, APageSize);
    end);

end;

function TOPlzApiClientForGermany.PerformFullTextSearch(const ASearchTerm: string;
  APageIndex, APageSize: Integer): IReadOnlyPagedCollection<TStreet>;
var
  UrlParams: string;
begin

  UrlParams := '';

  if ASearchTerm <> '' then UrlParams := CombineStr(UrlParams, Format('searchterm=%s', [TNetEncoding.Url.Encode(ASearchTerm)]), '&');
  if APageIndex > 0 then UrlParams := CombineStr(UrlParams, Format('page=%d', [APageIndex]), '&');
  if APageSize > 0 then UrlParams := CombineStr(UrlParams, Format('pageSize=%d', [APageSize]), '&');

  Result := GetPage<TStreet>(CombineStr('de/FullTextSearch', UrlParams, '?'),

    function(): IReadOnlyPagedCollection<TStreet>
    begin
      Result := PerformFullTextSearch(ASearchTerm, APageIndex + 1, APageSize);
    end);

end;

end.

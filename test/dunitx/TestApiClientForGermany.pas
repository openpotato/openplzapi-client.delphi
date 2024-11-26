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

unit TestApiClientForGermany;

interface

uses
  DUnitX.TestFramework,
  OpenPlzApi.Factory,
  OpenPlzApi.DE;

type
  {$M+}
  [TestFixture]
  TTestObject = class
  published
    procedure TestFederalStates;
    procedure TestGovernmentRegionsByFederalState;
    procedure TestDistrictsByFederalState;
    procedure TestDistrictsByGovernmentRegion;
    procedure TestMunicipalAssociationsByFederalState;
    procedure TestMunicipalAssociationsByDistrict;
    procedure TestMunicipalitiesByFederalState;
    procedure TestMunicipalitiesByDistrict;
    procedure TestLocalities;
    procedure TestStreets;
    procedure TestFullTextSearch;
  end;
  {$M-}

implementation

{ TTestObject }

procedure TTestObject.TestFederalStates;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var FederalStates := OPlzApiClient.GetFederalStates;

    Assert.IsTrue(FederalStates.Count = 16);

    var Exists_Berlin := false;
    var Exists_RheinlandPfalz := false;

    for var FederalState in FederalStates do
    begin
      if FederalState.Name = 'Berlin' then Exists_Berlin := true else
      if FederalState.Name = 'Rheinland-Pfalz' then Exists_RheinlandPfalz := true;
    end;

    Assert.IsTrue(Exists_Berlin);
    Assert.IsTrue(Exists_RheinlandPfalz);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestGovernmentRegionsByFederalState;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var GovernmentRegions := OPlzApiClient.GetGovernmentRegionsByFederalState('09', 1, 10);

    Assert.IsTrue(GovernmentRegions.Count > 0);

    var Exists_Key := false;

    for var GovernmentRegion in GovernmentRegions do
    begin
      if GovernmentRegion.Key = '091' then
      begin
        Exists_Key := true;
        Assert.IsTrue(GovernmentRegion.Name = 'Oberbayern');
        Assert.IsTrue(GovernmentRegion.FederalState.Key = '09');
        Assert.IsTrue(GovernmentRegion.FederalState.Name = 'Bayern');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestDistrictsByFederalState;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var Districts := OPlzApiClient.GetDistrictsByFederalState('09', 1, 10);

    Assert.IsTrue(Districts.Count > 0);

    var Exists_Key := false;

    for var District in Districts do
    begin
      if District.Key = '09161' then
      begin
        Exists_Key := true;
        Assert.IsTrue(District.Name = 'Ingolstadt');
        Assert.IsTrue(District.DistrictType = 'Kreisfreie Stadt');
        Assert.IsTrue(District.AdministrativeHeadquarters = 'Ingolstadt');
        Assert.IsTrue(District.GovernmentRegion.Key = '091');
        Assert.IsTrue(District.GovernmentRegion.Name = 'Oberbayern');
        Assert.IsTrue(District.FederalState.Key = '09');
        Assert.IsTrue(District.FederalState.Name = 'Bayern');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestDistrictsByGovernmentRegion;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var Districts := OPlzApiClient.GetDistrictsByGovernmentRegion('091', 1, 10);

    Assert.IsTrue(Districts.Count > 0);

    var Exists_Key := false;

    for var District in Districts do
    begin
      if District.Key = '09161' then
      begin
        Exists_Key := true;
        Assert.IsTrue(District.Name = 'Ingolstadt');
        Assert.IsTrue(District.DistrictType = 'Kreisfreie Stadt');
        Assert.IsTrue(District.AdministrativeHeadquarters = 'Ingolstadt');
        Assert.IsTrue(District.GovernmentRegion.Key = '091');
        Assert.IsTrue(District.GovernmentRegion.Name = 'Oberbayern');
        Assert.IsTrue(District.FederalState.Key = '09');
        Assert.IsTrue(District.FederalState.Name = 'Bayern');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestMunicipalAssociationsByFederalState;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var MunicipalAssociations := OPlzApiClient.GetMunicipalAssociationsByFederalState('09', 1, 10);

    Assert.IsTrue(MunicipalAssociations.Count > 0);

    var Exists_Key := false;

    for var MunicipalAssociation in MunicipalAssociations do
    begin
      if MunicipalAssociation.Key = '091715101' then
      begin
        Exists_Key := true;
        Assert.IsTrue(MunicipalAssociation.Name = 'Emmerting (VGem)');
        Assert.IsTrue(MunicipalAssociation.AssociationType = 'Verwaltungsgemeinschaft');
        Assert.IsTrue(MunicipalAssociation.AdministrativeHeadquarters = 'Emmerting');
        Assert.IsTrue(MunicipalAssociation.District.Key = '09171');
        Assert.IsTrue(MunicipalAssociation.District.Name = 'Altötting');
        Assert.IsTrue(MunicipalAssociation.District.DistrictType = 'Landkreis');
        Assert.IsTrue(MunicipalAssociation.FederalState.Key = '09');
        Assert.IsTrue(MunicipalAssociation.FederalState.Name = 'Bayern');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestMunicipalAssociationsByDistrict;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var MunicipalAssociations := OPlzApiClient.GetMunicipalAssociationsByDistrict('09180', 1, 30);

    Assert.IsTrue(MunicipalAssociations.Count > 0);

    var Exists_Key := false;

    for var MunicipalAssociation in MunicipalAssociations do
    begin
      if MunicipalAssociation.Key = '091805133' then
      begin
        Exists_Key := true;
        Assert.IsTrue(MunicipalAssociation.Name = 'Saulgrub (VGem)');
        Assert.IsTrue(MunicipalAssociation.AssociationType = 'Verwaltungsgemeinschaft');
        Assert.IsTrue(MunicipalAssociation.AdministrativeHeadquarters = 'Saulgrub');
        Assert.IsTrue(MunicipalAssociation.District.Key = '09180');
        Assert.IsTrue(MunicipalAssociation.District.Name = 'Garmisch-Partenkirchen');
        Assert.IsTrue(MunicipalAssociation.District.DistrictType = 'Landkreis');
        Assert.IsTrue(MunicipalAssociation.FederalState.Key = '09');
        Assert.IsTrue(MunicipalAssociation.FederalState.Name = 'Bayern');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestMunicipalitiesByFederalState;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var Municipalities := OPlzApiClient.GetMunicipalitiesByFederalState('09', 1, 10);

    Assert.IsTrue(Municipalities.Count > 0);

    var Exists_Key := false;

    for var Municipality in Municipalities do
    begin
      if Municipality.Key = '09161000' then
      begin
        Exists_Key := true;
        Assert.IsTrue(Municipality.Name = 'Ingolstadt');
        Assert.IsTrue(Municipality.MunicipalityType = 'Kreisfreie Stadt');
        Assert.IsTrue(Municipality.PostalCode = '85047');
        Assert.IsTrue(Municipality.MultiplePostalCodes = true);
        Assert.IsTrue(Municipality.District.Key = '09161');
        Assert.IsTrue(Municipality.District.Name = 'Ingolstadt');
        Assert.IsTrue(Municipality.District.DistrictType = 'Kreisfreie Stadt');
        Assert.IsTrue(Municipality.GovernmentRegion.Key = '091');
        Assert.IsTrue(Municipality.GovernmentRegion.Name = 'Oberbayern');
        Assert.IsTrue(Municipality.FederalState.Key = '09');
        Assert.IsTrue(Municipality.FederalState.Name = 'Bayern');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestMunicipalitiesByDistrict;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var Municipalities := OPlzApiClient.GetMunicipalitiesByDistrict('09180', 1, 10);

    Assert.IsTrue(Municipalities.Count > 0);

    var Exists_Key := false;

    for var Municipality in Municipalities do
    begin
      if Municipality.Key = '09180112' then
      begin
        Exists_Key := true;
        Assert.IsTrue(Municipality.Name = 'Bad Kohlgrub');
        Assert.IsTrue(Municipality.MunicipalityType = 'Kreisangehörige Gemeinde');
        Assert.IsTrue(Municipality.PostalCode = '82433');
        Assert.IsTrue(Municipality.MultiplePostalCodes = false);
        Assert.IsTrue(Municipality.District.Key = '09180');
        Assert.IsTrue(Municipality.District.Name = 'Garmisch-Partenkirchen');
        Assert.IsTrue(Municipality.District.DistrictType = 'Landkreis');
        Assert.IsTrue(Municipality.GovernmentRegion.Key = '091');
        Assert.IsTrue(Municipality.GovernmentRegion.Name = 'Oberbayern');
        Assert.IsTrue(Municipality.FederalState.Key = '09');
        Assert.IsTrue(Municipality.FederalState.Name = 'Bayern');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestLocalities;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var Localities := OPlzApiClient.GetLocalities('56566', '', 1, 10);

    Assert.IsTrue(Localities.Count > 0);

    var Exists_Name := false;
    var Exists_PostalCode := false;

    for var Locality in Localities do
    begin
      if (Locality.PostalCode = '56566') and (Locality.Name = 'Neuwied') then
      begin
        Exists_PostalCode := true;
        Exists_Name := true;
        Assert.IsTrue(Locality.Municipality.Key = '07138045');
        Assert.IsTrue(Locality.Municipality.Name = 'Neuwied, Stadt');
        Assert.IsTrue(Locality.Municipality.MunicipalityType = 'Stadt');
        Assert.IsTrue(Locality.District.Key = '07138');
        Assert.IsTrue(Locality.District.Name = 'Neuwied');
        Assert.IsTrue(Locality.FederalState.Key = '07');
        Assert.IsTrue(Locality.FederalState.Name = 'Rheinland-Pfalz');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_PostalCode);
    Assert.IsTrue(Exists_Name);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestStreets;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var Streets := OPlzApiClient.GetStreets('Pariser Platz', '', '', 1, 10);

    Assert.IsTrue(Streets.Count > 0);

    var Exists_Name := false;
    var Exists_PostalCode := false;

    for var Street in Streets do
    begin
      if (Street.Name = 'Pariser Platz') and (Street.PostalCode = '10117') then
      begin
        Exists_Name := true;
        Exists_PostalCode := true;
        Assert.IsTrue(Street.Locality = 'Berlin');
        Assert.IsTrue(Street.Municipality.Key = '11000000');
        Assert.IsTrue(Street.Municipality.Name = 'Berlin, Stadt');
        Assert.IsTrue(Street.Municipality.MunicipalityType = 'Kreisfreie Stadt');
        Assert.IsTrue(Street.FederalState.Key = '11');
        Assert.IsTrue(Street.FederalState.Name = 'Berlin');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Name);
    Assert.IsTrue(Exists_PostalCode);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestFullTextSearch;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var Streets := OPlzApiClient.PerformFullTextSearch('Berlin Pariser Platz', 1, 10);

    Assert.IsTrue(Streets.Count > 0);
    Assert.IsTrue(Streets.PageIndex = 1);
    Assert.IsTrue(Streets.PageSize = 10);
    Assert.IsTrue(Streets.TotalPages >= 1);
    Assert.IsTrue(Streets.TotalCount >= 1);

    var Exists_Name := false;
    var Exists_PostalCode := false;

    for var Street in Streets do
    begin
      if (Street.Name = 'Pariser Platz') and (Street.PostalCode = '10117') then
      begin
        Exists_Name := true;
        Exists_PostalCode := true;
        Assert.IsTrue(Street.Locality = 'Berlin');
        Assert.IsTrue(Street.Municipality.Key = '11000000');
        Assert.IsTrue(Street.Municipality.Name = 'Berlin, Stadt');
        Assert.IsTrue(Street.Municipality.MunicipalityType = 'Kreisfreie Stadt');
        Assert.IsTrue(Street.FederalState.Key = '11');
        Assert.IsTrue(Street.FederalState.Name = 'Berlin');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Name);
    Assert.IsTrue(Exists_PostalCode);

  finally
    OPlzApiClient.Free;
  end;
end;

end.

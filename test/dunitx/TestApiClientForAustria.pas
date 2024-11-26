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

unit TestApiClientForAustria;

interface

uses
  DUnitX.TestFramework,
  OpenPlzApi.Factory,
  OpenPlzApi.AT;

type
  {$M+}
  [TestFixture]
  TTestObject = class
  published
    procedure TestFederalProvinces;
    procedure TestDistrictsByFederalProvince;
    procedure TestMunicipalitiesByFederalProvince;
    procedure TestMunicipalitiesByDistrict;
    procedure TestLocalities;
    procedure TestStreets;
    procedure TestFullTextSearch;
  end;
  {$M-}

implementation

uses
  System.Net.HttpClient;

{ TTestObject }

procedure TTestObject.TestFederalProvinces;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForAustria>();
  try
    var FederalProvinces := OPlzApiClient.GetFederalProvinces;

    Assert.IsTrue(FederalProvinces.Count = 9);

    var Exists_Wien := false;
    var Exists_Burgenland := false;

    for var FederalProvince in FederalProvinces do
    begin
      if FederalProvince.Name = 'Wien' then Exists_Wien := true else
      if FederalProvince.Name = 'Burgenland' then Exists_Burgenland := true;
    end;

    Assert.IsTrue(Exists_Wien);
    Assert.IsTrue(Exists_Burgenland);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestDistrictsByFederalProvince;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForAustria>();
  try
    var Districts := OPlzApiClient.GetDistrictsByFederalProvince('7', 1, 10);

    Assert.IsTrue(Districts.Count > 0);

    var Exists_Key := false;

    for var District in Districts do
    begin
      if District.Key = '701' then
      begin
        Exists_Key := true;
        Assert.IsTrue(District.Code = '701');
        Assert.IsTrue(District.Name = 'Innsbruck-Stadt');
        Assert.IsTrue(District.FederalProvince.Key = '7');
        Assert.IsTrue(District.FederalProvince.Name = 'Tirol');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestMunicipalitiesByFederalProvince;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForAustria>();
  try
    var Municipalities := OPlzApiClient.GetMunicipalitiesByFederalProvince('7', 1, 10);

    Assert.IsTrue(Municipalities.Count > 0);

    var Exists_Key := false;

    for var Municipality in Municipalities do
    begin
      if Municipality.Key = '70101' then
      begin
        Exists_Key := true;
        Assert.IsTrue(Municipality.Code = '70101');
        Assert.IsTrue(Municipality.Name = 'Innsbruck');
        Assert.IsTrue(Municipality.PostalCode = '6020');
        Assert.IsTrue(Municipality.MultiplePostalCodes = true);
        Assert.IsTrue(Municipality.Status = 'Statutarstadt');
        Assert.IsTrue(Municipality.District.Key = '701');
        Assert.IsTrue(Municipality.District.Code = '701');
        Assert.IsTrue(Municipality.District.Name = 'Innsbruck-Stadt');
        Assert.IsTrue(Municipality.FederalProvince.Key = '7');
        Assert.IsTrue(Municipality.FederalProvince.Name = 'Tirol');
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
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForAustria>();
  try
    var Municipalities := OPlzApiClient.GetMunicipalitiesByDistrict('701', 1, 10);

    Assert.IsTrue(Municipalities.Count > 0);

    var Exists_Key := false;

    for var Municipality in Municipalities do
    begin
      if Municipality.Key = '70101' then
      begin
        Exists_Key := true;
        Assert.IsTrue(Municipality.Code = '70101');
        Assert.IsTrue(Municipality.Name = 'Innsbruck');
        Assert.IsTrue(Municipality.PostalCode = '6020');
        Assert.IsTrue(Municipality.MultiplePostalCodes = true);
        Assert.IsTrue(Municipality.Status = 'Statutarstadt');
        Assert.IsTrue(Municipality.District.Key = '701');
        Assert.IsTrue(Municipality.District.Code = '701');
        Assert.IsTrue(Municipality.District.Name = 'Innsbruck-Stadt');
        Assert.IsTrue(Municipality.FederalProvince.Key = '7');
        Assert.IsTrue(Municipality.FederalProvince.Name = 'Tirol');
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
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForAustria>();
  try
    var Localities := OPlzApiClient.GetLocalities('', 'Wien', 1, 10);

    Assert.IsTrue(Localities.Count > 0);

    var Exists_Key := false;

    for var Locality in Localities do
    begin
      if (Locality.Key = '17223') and (Locality.Municipality.Code = '90401') then
      begin
        Exists_Key := true;
        Assert.IsTrue(Locality.Name = 'Wien, Innere Stadt');
        Assert.IsTrue(Locality.PostalCode = '1010');
        Assert.IsTrue(Locality.Municipality.Key = '90001');
        Assert.IsTrue(Locality.Municipality.Name = 'Wien');
        Assert.IsTrue(Locality.Municipality.Status = 'Statutarstadt');
        Assert.IsTrue(Locality.District.Key = '900');
        Assert.IsTrue(Locality.District.Code = '904');
        Assert.IsTrue(Locality.District.Name = 'Wien  4., Wieden');
        Assert.IsTrue(Locality.FederalProvince.Key = '9');
        Assert.IsTrue(Locality.FederalProvince.Name = 'Wien');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestStreets;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForAustria>();
  try
    var Streets := OPlzApiClient.GetStreets('', '1020', '', 1, 10);

    Assert.IsTrue(Streets.Count > 0);

    var Exists_Key := false;

    for var Street in Streets do
    begin
      if Street.Key = '900017' then
      begin
        Exists_Key := true;
        Assert.IsTrue(Street.Name = 'Adambergergasse');
        Assert.IsTrue(Street.PostalCode = '1020');
        Assert.IsTrue(Street.Locality = 'Wien, Leopoldstadt');
        Assert.IsTrue(Street.Municipality.Key = '90001');
        Assert.IsTrue(Street.Municipality.Code = '90201');
        Assert.IsTrue(Street.Municipality.Name = 'Wien');
        Assert.IsTrue(Street.Municipality.Status = 'Statutarstadt');
        Assert.IsTrue(Street.District.Key = '900');
        Assert.IsTrue(Street.District.Code = '902');
        Assert.IsTrue(Street.District.Name = 'Wien  2., Leopoldstadt');
        Assert.IsTrue(Street.FederalProvince.Key = '9');
        Assert.IsTrue(Street.FederalProvince.Name = 'Wien');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestFullTextSearch;
var
  HttpClient: THTTPClient;
begin
  HttpClient := THTTPClient.Create;
  try
    var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForAustria>(HttpClient);
    try

      var Streets := OPlzApiClient.PerformFullTextSearch('1020 Adambergergasse', 1, 10);

      Assert.IsTrue(Streets.Count > 0);
      Assert.IsTrue(Streets.PageIndex = 1);
      Assert.IsTrue(Streets.PageSize = 10);
      Assert.IsTrue(Streets.TotalPages >= 1);
      Assert.IsTrue(Streets.TotalCount >= 1);

      var Exists_Key := false;

      for var Street in Streets do
      begin
        if Street.Key = '900017' then
        begin
          Exists_Key := true;
          Assert.IsTrue(Street.Name = 'Adambergergasse');
          Assert.IsTrue(Street.PostalCode = '1020');
          Assert.IsTrue(Street.Locality = 'Wien, Leopoldstadt');
          Assert.IsTrue(Street.Municipality.Key = '90001');
          Assert.IsTrue(Street.Municipality.Code = '90201');
          Assert.IsTrue(Street.Municipality.Name = 'Wien');
          Assert.IsTrue(Street.Municipality.Status = 'Statutarstadt');
          Assert.IsTrue(Street.District.Key = '900');
          Assert.IsTrue(Street.District.Code = '902');
          Assert.IsTrue(Street.District.Name = 'Wien  2., Leopoldstadt');
          Assert.IsTrue(Street.FederalProvince.Key = '9');
          Assert.IsTrue(Street.FederalProvince.Name = 'Wien');
          Break;
        end;
      end;

      Assert.IsTrue(Exists_Key);

    finally
      OPlzApiClient.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

end.

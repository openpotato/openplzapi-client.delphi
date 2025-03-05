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

unit TestApiClientForSwitzerland;

interface

uses
  DUnitX.TestFramework,
  OpenPlzApi.Factory,
  OpenPlzApi.CH;

type
  {$M+}
  [TestFixture]
  TTestObject = class
  published
    procedure TestCantons;
    procedure TestDistrictsByCanton;
    procedure TestCommunesByCanton;
    procedure TestCommunesByDistrict;
    procedure TestLocalities;
    procedure TestStreets;
    procedure TestFullTextSearch;
  end;
  {$M-}

implementation

{ TTestObject }

procedure TTestObject.TestCantons;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForSwitzerland>();
  try
    var Cantons := OPlzApiClient.GetCantons;

    Assert.IsTrue(Cantons.Count = 26);

    var Exists_Zuerich := false;
    var Exists_Aargau := false;

    for var Canton in Cantons do
    begin
      if Canton.Name = 'Zürich' then Exists_Zuerich := true else
      if Canton.Name = 'Aargau' then Exists_Aargau := true;
    end;

    Assert.IsTrue(Exists_Zuerich);
    Assert.IsTrue(Exists_Aargau);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestDistrictsByCanton;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForSwitzerland>();
  try
    var Districts := OPlzApiClient.GetDistrictsByCanton('10', 1, 10);

    Assert.IsTrue(Districts.Count > 0);

    var Exists_Key := false;

    for var District in Districts do
    begin
      if district.Key = '1001' then
      begin
        Exists_Key := true;
        Assert.IsTrue(District.Name = 'District de la Broye');
        Assert.IsTrue(District.HistoricalCode = '10107');
        Assert.IsTrue(District.Canton.Key = '10');
        Assert.IsTrue(District.Canton.ShortName = 'FR');
        Assert.IsTrue(District.Canton.Name = 'Fribourg / Freiburg');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestCommunesByCanton;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForSwitzerland>();
  try
    var Communes := OPlzApiClient.GetCommunesByCanton('10', 1, 10);

    Assert.IsTrue(Communes.Count > 0);

    var Exists_Key := false;

    for var Commune in Communes do
    begin
      if Commune.Key = '2008' then
      begin
        Exists_Key := true;
        Assert.IsTrue(Commune.Name = 'Châtillon (FR)');
        Assert.IsTrue(Commune.HistoricalCode = '11419');
        Assert.IsTrue(Commune.ShortName = 'Châtillon (FR)');
        Assert.IsTrue(Commune.District.Key = '1001');
        Assert.IsTrue(Commune.District.Name = 'District de la Broye');
        Assert.IsTrue(Commune.Canton.Key = '10');
        Assert.IsTrue(Commune.Canton.ShortName = 'FR');
        Assert.IsTrue(Commune.Canton.Name = 'Fribourg / Freiburg');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestCommunesByDistrict;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForSwitzerland>();
  try
    var Communes := OPlzApiClient.GetCommunesByDistrict('1002', 1, 10);

    Assert.IsTrue(Communes.Count > 0);

    var Exists_Key := false;

    for var Commune in Communes do
    begin
      if Commune.Key = '2063' then
      begin
        Exists_Key := true;
        Assert.IsTrue(Commune.Name = 'Billens-Hennens');
        Assert.IsTrue(Commune.HistoricalCode = '14103');
        Assert.IsTrue(Commune.ShortName = 'Billens-Hennens');
        Assert.IsTrue(Commune.District.Key = '1002');
        Assert.IsTrue(Commune.District.Name = 'District de la Glâne');
        Assert.IsTrue(Commune.Canton.Key = '10');
        Assert.IsTrue(Commune.Canton.ShortName = 'FR');
        Assert.IsTrue(Commune.Canton.Name = 'Fribourg / Freiburg');
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
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForSwitzerland>();
  try
    var Localities := OPlzApiClient.GetLocalities('', 'Zürich', 1, 10);

    Assert.IsTrue(Localities.Count > 0);

    var Exists_Name := false;
    var Exists_PostalCode := false;

    for var Locality in Localities do
    begin
      if (Locality.PostalCode = '8001') and (Locality.Name = 'Zürich') then
      begin
        Exists_Name := true;
        Exists_PostalCode := true;
        Assert.IsTrue(Locality.Commune.Key = '261');
        Assert.IsTrue(Locality.Commune.Name = 'Zürich');
        Assert.IsTrue(Locality.Commune.ShortName = 'Zürich');
        Assert.IsTrue(Locality.District.Key = '112');
        Assert.IsTrue(Locality.District.Name = 'Bezirk Zürich');
        Assert.IsTrue(Locality.Canton.Key = '1');
        Assert.IsTrue(Locality.Canton.ShortName = 'ZH');
        Assert.IsTrue(Locality.Canton.Name = 'Zürich');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Name);
    Assert.IsTrue(Exists_PostalCode);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestStreets;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForSwitzerland>();
  try
    var Streets := OPlzApiClient.GetStreets('Bederstrasse', '8002', '', 1, 10);

    Assert.IsTrue(Streets.Count > 0);

    var Exists_Key := false;

    for var Street in Streets do
    begin
      if Street.Key = '10098541' then
      begin
        Exists_Key := true;
        Assert.IsTrue(Street.Name = 'Bederstrasse');
        Assert.IsTrue(Street.PostalCode = '8002');
        Assert.IsTrue(Street.Locality = 'Zürich');
        Assert.IsTrue(Street.Status = ssReal);
        Assert.IsTrue(Street.Commune.Key = '261');
        Assert.IsTrue(Street.Commune.Name = 'Zürich');
        Assert.IsTrue(Street.Commune.ShortName = 'Zürich');
        Assert.IsTrue(Street.District.Key = '112');
        Assert.IsTrue(Street.District.Name = 'Bezirk Zürich');
        Assert.IsTrue(Street.Canton.Key = '1');
        Assert.IsTrue(Street.Canton.ShortName = 'ZH');
        Assert.IsTrue(Street.Canton.Name = 'Zürich');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestFullTextSearch;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForSwitzerland>();
  try
    var Streets := OPlzApiClient.PerformFullTextSearch('8002 Bederstrasse', 1, 10);

    Assert.IsTrue(Streets.Count > 0);
    Assert.IsTrue(Streets.PageIndex = 1);
    Assert.IsTrue(Streets.PageSize = 10);
    Assert.IsTrue(Streets.TotalPages >= 1);
    Assert.IsTrue(Streets.TotalCount >= 1);

    var Exists_Key := false;

    for var Street in Streets do
    begin
      if Street.Key = '10098541' then
      begin
        Exists_Key := true;
        Assert.IsTrue(Street.Name = 'Bederstrasse');
        Assert.IsTrue(Street.PostalCode = '8002');
        Assert.IsTrue(Street.Locality = 'Zürich');
        Assert.IsTrue(Street.Status = ssReal);
        Assert.IsTrue(Street.Commune.Key = '261');
        Assert.IsTrue(Street.Commune.Name = 'Zürich');
        Assert.IsTrue(Street.Commune.ShortName = 'Zürich');
        Assert.IsTrue(Street.District.Key = '112');
        Assert.IsTrue(Street.District.Name = 'Bezirk Zürich');
        Assert.IsTrue(Street.Canton.Key = '1');
        Assert.IsTrue(Street.Canton.ShortName = 'ZH');
        Assert.IsTrue(Street.Canton.Name = 'Zürich');
        Break;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

end.

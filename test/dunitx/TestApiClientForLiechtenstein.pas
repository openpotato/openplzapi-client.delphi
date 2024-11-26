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

unit TestApiClientForLiechtenstein;

interface

uses
  DUnitX.TestFramework,
  OpenPlzApi.Factory,
  OpenPlzApi.LI;

type
  {$M+}
  [TestFixture]
  TTestObject = class
  published
    procedure TestCommunes;
    procedure TestLocalities;
    procedure TestStreets;
    procedure TestFullTextSearch;
  end;
  {$M-}

implementation

{ TTestObject }

procedure TTestObject.TestCommunes;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForLiechtenstein>();
  try
    var Communes := OPlzApiClient.GetCommunes;

    Assert.IsTrue(Communes.Count = 11);

    var Exists_Triesen := false;
    var Exists_Planken := false;

    for var Commune in Communes do
    begin
      if Commune.Name = 'Triesen' then Exists_Triesen := true else
      if Commune.Name = 'Planken' then Exists_Planken := true;
    end;

    Assert.IsTrue(Exists_Triesen);
    Assert.IsTrue(Exists_Planken);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestLocalities;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForLiechtenstein>();
  try
    var Localities := OPlzApiClient.GetLocalities('', 'Vaduz', 1, 10);

    Assert.IsTrue(Localities.Count > 0);
    Assert.IsTrue(Localities.PageIndex = 1);
    Assert.IsTrue(Localities.PageSize = 10);
    Assert.IsTrue(Localities.TotalPages >= 1);
    Assert.IsTrue(Localities.TotalCount >= 1);

    var Exists_Name := false;
    var Exists_PostalCode := false;

    for var Locality in Localities do
    begin
      if (Locality.PostalCode = '9490') and (Locality.Name = 'Vaduz') then
      begin
        Exists_Name := true;
        Exists_PostalCode := true;
        Assert.IsTrue(Locality.Commune.Key = '7001');
        Assert.IsTrue(Locality.Commune.Name = 'Vaduz');
        Exit;
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
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForLiechtenstein>();
  try
    var Streets := OPlzApiClient.GetStreets('Alte Landstrasse', '9490', '', 1, 10);

    Assert.IsTrue(Streets.Count > 0);
    Assert.IsTrue(Streets.PageIndex = 1);
    Assert.IsTrue(Streets.PageSize = 10);
    Assert.IsTrue(Streets.TotalPages >= 1);
    Assert.IsTrue(Streets.TotalCount >= 1);

    var Exists_Key := false;

    for var Street in Streets do
    begin
      if Street.Key = '89440155' then
      begin
        Exists_Key := true;
        Assert.IsTrue(Street.Name = 'Alte Landstrasse');
        Assert.IsTrue(Street.PostalCode = '9490');
        Assert.IsTrue(Street.Locality = 'Vaduz');
        Assert.IsTrue(Street.Status = ssReal);
        Assert.IsTrue(Street.Commune.Key = '7001');
        Assert.IsTrue(Street.Commune.Name = 'Vaduz');
        Exit;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestFullTextSearch;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForLiechtenstein>();
  try
    var Streets := OPlzApiClient.PerformFullTextSearch('9490 Alte Landstrasse', 1, 10);

    Assert.IsTrue(Streets.Count > 0);
    Assert.IsTrue(Streets.PageIndex = 1);
    Assert.IsTrue(Streets.PageSize = 10);
    Assert.IsTrue(Streets.TotalPages >= 1);
    Assert.IsTrue(Streets.TotalCount >= 1);

    var Exists_Key := false;

    for var Street in Streets do
    begin
      if Street.Key = '89440155' then
      begin
        Exists_Key := true;
        Assert.IsTrue(Street.Name = 'Alte Landstrasse');
        Assert.IsTrue(Street.PostalCode = '9490');
        Assert.IsTrue(Street.Locality = 'Vaduz');
        Assert.IsTrue(Street.Status = ssReal);
        Assert.IsTrue(Street.Commune.Key = '7001');
        Assert.IsTrue(Street.Commune.Name = 'Vaduz');
        Exit;
      end;
    end;

    Assert.IsTrue(Exists_Key);

  finally
    OPlzApiClient.Free;
  end;
end;

end.

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

unit TestApiClientAspects;

interface

uses
  DUnitX.TestFramework,
  OpenPlzApi.Factory,
  OpenPlzApi.DE,
  OpenPlzApi.ProblemDetails;

type
  {$M+}
  [TestFixture]
  TTestObject = class
  published
    procedure TestPaging;
    procedure TestProblemDetails;
  end;
  {$M-}

implementation

{ TTestObject }

procedure TTestObject.TestPaging;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try
    var StreetPage := OPlzApiClient.PerformFullTextSearch('Berlin Platz', 1, 10);

    var Exists_Name := false;
    var Exists_PostalCode := false;
    var pageIndex := 1;

    while StreetPage <> nil do
    begin

      Assert.IsTrue(StreetPage.Count > 0);
      Assert.IsTrue(StreetPage.PageIndex = pageIndex);
      Assert.IsTrue(StreetPage.PageSize = 10);
      Assert.IsTrue(StreetPage.TotalPages >= 2);
      Assert.IsTrue(StreetPage.TotalCount >= 10);

      for var Street in StreetPage do
      begin
        if (Street.Name = 'Pariser Platz') and (Street.PostalCode = '10117') then
        begin
          Assert.IsTrue(Street.Locality = 'Berlin');
          Assert.IsTrue(Street.Municipality.Key = '11000000');
          Assert.IsTrue(Street.Municipality.Name = 'Berlin, Stadt');
          Assert.IsTrue(Street.Municipality.MunicipalityType = 'Kreisfreie Stadt');
          Assert.IsTrue(Street.FederalState.Key = '11');
          Assert.IsTrue(Street.FederalState.Name = 'Berlin');
          Exists_Name := true;
          Exists_PostalCode := true;
          Break;
        end;
      end;

      Inc(PageIndex);

      StreetPage := StreetPage.GetNextPage();

    end;

    Assert.IsTrue(Exists_Name);
    Assert.IsTrue(Exists_PostalCode);

  finally
    OPlzApiClient.Free;
  end;
end;

procedure TTestObject.TestProblemDetails;
begin
  var OPlzApiClient := TOPlzApiClientFactory.CreateClient<TOPlzApiClientForGermany>();
  try

    Assert.WillRaise(
      procedure
      begin
        OPlzApiClient.PerformFullTextSearch('Berlin Platz', 1, 99);
      end,
      EOPlzApiProblemDetailsException
    );

    Assert.WillRaise(
      procedure
      begin
        OPlzApiClient.GetStreets('', '', '',  1, 10);
      end,
      EOPlzApiProblemDetailsException
    );

  finally
    OPlzApiClient.Free;
  end;
end;

end.

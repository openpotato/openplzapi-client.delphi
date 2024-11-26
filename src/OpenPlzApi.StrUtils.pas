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

unit OpenPlzApi.StrUtils;

interface

/// <summary>
/// Concatenates two individual strings into a single string by placing a
/// connecting string between them.
/// </summary>
/// <param name="S1">The first string </param>
/// <param name="S2">The second string</param>
/// <param name="Link">The connecting string</param>
/// <returns>The concatenated string.</returns>
function CombineStr(const S1, S2, Link: string): string;

implementation

function CombineStr(const S1, S2, Link: string): string;
begin
  if (S1 <> '') and (S2 <> '') then Result := S1 + Link + S2
  else Result := S1 + S2;
end;

end.

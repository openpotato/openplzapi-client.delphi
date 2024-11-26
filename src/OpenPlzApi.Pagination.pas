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

unit OpenPlzApi.Pagination;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type

  /// <summary>
  /// Represents a read-only collection of elements that can be accessed by index.
  /// </summary>
  IReadOnlyCollection<T: class> = interface

    /// <summary>
    /// Returns the number of elements in the list
    /// </summary>
    /// <returns>Number of elements</returns>
    function GetCount: NativeInt;

    /// <summary>
    /// Returns the element at the specified index
    /// </summary>
    /// <returns>An element</returns>
    function GetItem(Index: NativeInt): T;

    /// <summary>
    /// Returns whether the list is empty
    /// </summary>
    /// <returns>TRUE, if the list is empty</returns>
    function IsEmpty: Boolean;

    /// <summary>
    /// Returns the first element in the list or nil
    /// </summary>
    /// <returns>An element or nil</returns>
    function First: T;

    /// <summary>
    /// Returns the last element in the list or nil
    /// </summary>
    /// <returns>An element or nil</returns>
    function Last: T;

    /// <summary>
    /// Creates and returns the enumerator instance for enumeration support
    /// </summary>
    /// <returns>An enumerator</returns>
    function GetEnumerator: TEnumerator<T>;

    /// <summary>
    /// The number of elements in the list
    /// </summary>
    property Count: NativeInt read GetCount;

    /// <summary>
    /// Indexed element access
    /// </summary>
    property Items[Index: NativeInt]: T read GetItem; default;

  end;

  /// <summary>
  /// A <see cref="IReadOnlyCollection{T}"/> with additional pagination information
  /// </summary>
  IReadOnlyPagedCollection<T: class> = interface(IReadOnlyCollection<T>)

    /// <summary>
    /// Returns the page index
    /// </summary>
    /// <returns>Page index</returns>
    function GetPageIndex: NativeInt;

    /// <summary>
    /// Returns the page size
    /// </summary>
    /// <returns>Page size</returns>
    function GetPageSize: NativeInt;

    /// <summary>
    /// Returns the total count of pages of the remote list
    /// </summary>
    /// <returns>Page index</returns>
    function GetTotalPages: NativeInt;

    /// <summary>
    /// Returns the total count of items of the remote list
    /// </summary>
    /// <returns>Page index</returns>
    function GetTotalCount: NativeInt;

    /// <summary>
    /// Returns whether this is the last page within a page collection
    /// </summary>
    /// <returns>TRUE, if this is the last page</returns>
    function IsLastPage: Boolean;

    /// <summary>
    /// Creates and returns the next page or nil
    /// </summary>
    /// <returns>A new page or nil</returns>
    function GetNextPage: IReadOnlyPagedCollection<T>;

    /// <summary>
    /// The page index
    /// </summary>
    property PageIndex: NativeInt read GetPageIndex;

    /// <summary>
    /// The page size
    /// </summary>
    property PageSize: NativeInt read GetPageSize;

    /// <summary>
    /// The total count of pages of the original list
    /// </summary>
    property TotalPages: NativeInt read GetTotalPages;

    /// <summary>
    /// The total count of items of the original list
    /// </summary>
    property TotalCount: NativeInt read GetTotalCount;

  end;

  /// <summary>
  /// A read-only collection of elements that can be accessed by index.
  /// </summary>
  TReadOnlyCollection<T: class> = class(TInterfacedObject, IReadOnlyCollection<T>)
  private
    FList: TObjectList<T>;
  private

    /// <summary>
    /// Returns the number of elements in the list
    /// </summary>
    /// <returns>Number of elements</returns>
    function GetCount: NativeInt; inline;

    /// <summary>
    /// Returns the element at the specified index
    /// </summary>
    /// <returns>An element</returns>
    function GetItem(Index: NativeInt): T; inline;

    type
      TEnumerator = class(TEnumerator<T>)
      private
        FList: IReadOnlyCollection<T>;
        FIndex: NativeInt;
        function GetCurrent: T; inline;
      protected
        function DoGetCurrent: T; override;
        function DoMoveNext: Boolean; override;
      public
        constructor Create(const AList: IReadOnlyCollection<T>);
        function MoveNext: Boolean; inline;
        property Current: T read GetCurrent;
      end;

    /// <summary>
    /// Creates and returns the enumerator instance for enumeration support
    /// </summary>
    /// <returns>An enumerator</returns>
    function GetEnumerator: TEnumerator<T>; inline;

  public

    /// <summary>
    /// Initializes a new instance of <see cref="TReadOnlyCollection{T}" />
    /// </summary>
    /// <param name="AList">The inner list</param>
    constructor Create(AList: TObjectList<T>);

    /// <summary>
    /// Destroys the instance
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Returns whether the list is empty
    /// </summary>
    /// <returns>TRUE, if the list is empty</returns>
    function IsEmpty: Boolean; inline;

    /// <summary>
    /// Returns the first element in the list or nil
    /// </summary>
    /// <returns>An element or nil</returns>
    function First: T; inline;

    /// <summary>
    /// Returns the last element in the list or nil
    /// </summary>
    /// <returns>An element or nil</returns>
    function Last: T; inline;

  end;

  /// <summary>
  /// A <see cref="TReadOnlyCollection{T}"/> with additional pagination information
  /// </summary>
  TReadOnlyPagedCollection<T: class> = class(TReadOnlyCollection<T>, IReadOnlyPagedCollection<T>)
  private
    FPageIndex: Integer;
    FPageSize: Integer;
    FTotalCount: Integer;
    FTotalPages: Integer;
    FNextPageFunc: TFunc<IReadOnlyPagedCollection<T>>;
  private

    /// <summary>
    /// Returns the page index
    /// </summary>
    /// <returns>Page index</returns>
    function GetPageIndex: NativeInt; inline;

    /// <summary>
    /// Returns the page size
    /// </summary>
    /// <returns>Page size</returns>
    function GetPageSize: NativeInt; inline;

    /// <summary>
    /// Returns the total count of pages of the remote list
    /// </summary>
    /// <returns>Page index</returns>
    function GetTotalPages: NativeInt; inline;

    /// <summary>
    /// Returns the total count of items of the remote list
    /// </summary>
    /// <returns>Page index</returns>
    function GetTotalCount: NativeInt; inline;

  public

    /// <summary>
    /// Initializes a new instance of <see cref="TReadOnlyPagedCollection{T}" />
    /// </summary>
    /// <param name="AList">The inner list</param>
    /// <param name="APageIndex">The page index</param>
    /// <param name="APageSize">The page size</param>
    /// <param name="AnyTotalPages">The total count of pages of the original list</param>
    /// <param name="AnyTotalCount">The total count of items of the original list</param>
    /// <param name="ANextPageFunc">An anonymous function for creating the next page</param>
    constructor Create(AList: TObjectList<T>; APageIndex, APageSize, AnyTotalPages, AnyTotalCount: Integer;
      ANextPageFunc: TFunc<IReadOnlyPagedCollection<T>>);

    /// <summary>
    /// Creates and returns the next page or nil
    /// </summary>
    /// <returns>A new page or nil</returns>
    function GetNextPage: IReadOnlyPagedCollection<T>;

    /// <summary>
    /// Returns whether this is the last page within the remote page collection
    /// </summary>
    /// <returns>TRUE, if this is the last page</returns>
    function IsLastPage: Boolean;

  end;

implementation

{ IReadOnlyCollection<T> }

constructor TReadOnlyCollection<T>.Create(AList: TObjectList<T>);
begin
  inherited Create;
  FList := AList;
end;

destructor TReadOnlyCollection<T>.Destroy;
begin
  FList.Free;
  inherited;
end;

function TReadOnlyCollection<T>.IsEmpty: Boolean;
begin
  Result := FList.Count = 0;
end;

function TReadOnlyCollection<T>.First: T;
begin
  Result := FList.First;
end;

function TReadOnlyCollection<T>.Last: T;
begin
  Result := FList.Last;
end;

function TReadOnlyCollection<T>.GetCount: NativeInt;
begin
  Result := FList.Count;
end;

function TReadOnlyCollection<T>.GetItem(Index: NativeInt): T;
begin
  Result := FList[Index];
end;

constructor TReadOnlyCollection<T>.TEnumerator.Create(const AList: IReadOnlyCollection<T>);
begin
  inherited Create;
  FList := AList;
  FIndex := -1;
end;

function TReadOnlyCollection<T>.TEnumerator.GetCurrent: T;
begin
  Result := FList[FIndex];
end;

function TReadOnlyCollection<T>.TEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FList.Count - 1;
  if Result then
    Inc(FIndex);
end;

function TReadOnlyCollection<T>.TEnumerator.DoGetCurrent: T;
begin
  Result := Current;
end;

function TReadOnlyCollection<T>.TEnumerator.DoMoveNext: Boolean;
begin
  Result := MoveNext;
end;

function TReadOnlyCollection<T>.GetEnumerator: TEnumerator<T>;
begin
  Result := TEnumerator.Create(Self);
end;

{ TReadOnlyPagedCollection<T> }

constructor TReadOnlyPagedCollection<T>.Create(AList: TObjectList<T>; APageIndex, APageSize, AnyTotalPages, AnyTotalCount: Integer;
  ANextPageFunc: TFunc<IReadOnlyPagedCollection<T>>);
begin
  inherited Create(AList);
  FPageIndex := APageIndex;
  FPageSize := APageSize;
  FTotalPages := AnyTotalPages;
  FTotalCount := AnyTotalCount;
  FNextPageFunc := ANextPageFunc;
end;

function TReadOnlyPagedCollection<T>.IsLastPage: Boolean;
begin
  Result := (FPageIndex * FPageSize) >= FTotalCount;
end;

function TReadOnlyPagedCollection<T>.GetNextPage: IReadOnlyPagedCollection<T>;
begin
  if IsLastPage then
    Result := nil
  else
    Result := FNextPageFunc();
end;

function TReadOnlyPagedCollection<T>.GetPageIndex: NativeInt;
begin
  Result := FPageIndex;
end;

function TReadOnlyPagedCollection<T>.GetPageSize: NativeInt;
begin
  Result := FPageSize;
end;

function TReadOnlyPagedCollection<T>.GetTotalPages: NativeInt;
begin
  Result := FTotalPages;
end;

function TReadOnlyPagedCollection<T>.GetTotalCount: NativeInt;
begin
  Result := FTotalCount;
end;

end.


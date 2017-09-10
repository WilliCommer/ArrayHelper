{*******************************************************}
{                                                       }
{ ArrayHelper  version 1.0                              }
{ extends class TArray                                  }
{                                                       }
{ Copyright(c) 2017 by Willi Commer (wcs)               }
{ Licence GNU                                           }
{                                                       }
{ For examples see procedure Test_All_Helper_Functions  }
{                                                       }
{*******************************************************}


unit ArrayHelper;


{  $DEFINE TEST_FUNCTION}  // change to deactive test function


interface
uses
  System.Classes, System.SysUtils, System.RTLConsts, System.Generics.Defaults, System.Generics.Collections;

type

  // callback function for function Map
  TArrayMapCallback<T> = reference to function(var Value: T; Index: integer): boolean;

  // callback function for function Find
  TArrayFindCallback<T> = reference to function(const Value: T): boolean;

  // extends class TArray
  TArrayHelper = class helper for TArray
    // add item to array
    class function Add<T>(var Values: TArray<T>; Item: T): integer;

    // delete item at index
    class procedure Delete<T>(var Values: TArray<T>; Index: integer);

    // insert item at index
    class procedure Insert<T>(var Values: TArray<T>; Index: integer; Value: T);

    // append array
    class procedure AddRange<T>(var Values: TArray<T>; const ValuesToInsert: array of T); static;

    // insert array at index
    class procedure InsertRange<T>(var Values: TArray<T>; Index: Integer; const ValuesToInsert: array of T); static;

    // get index of equal item
    class function IndexOf<T>(var Values: TArray<T>; Item: T): integer; overload; static;

    // get index of equal item (using IComparer)
    class function IndexOf<T>(var Values: TArray<T>; Item: T; const Comparer: IComparer<T>): integer; overload; static;

    // is a equal item is member of values
    class function Contains<T>(var Values: TArray<T>; Item: T): boolean; overload; static;

    // is a equal item is member of values (using IComparer)
    class function Contains<T>(var Values: TArray<T>; Item: T; const Comparer: IComparer<T>): boolean; overload; static;

    // compare two arrays
    class function Compare<T>(const Values, ValuesToCompare: TArray<T>): boolean; overload; static;

    // compare two arrays (using IComparer)
    class function Compare<T>(const Values, ValuesToCompare: TArray<T>; const Comparer: IComparer<T>): boolean; overload; static;

    // find with callback
    class function Find<T>(const Values: TArray<T>; const Callback: TArrayFindCallback<T>; const StartIndex: integer = 0): integer; overload; static;

    // return an array filtered and converted by callback function
    class function Map<T>(const Values: TArray<T>; const Callback: TArrayMapCallback<T>): TArray<T>; static;


{$IFDEF TEST_FUNCTION}
    // test, debug and example function
    class procedure Test_All_Helper_Functions;
{$ENDIF TEST_FUNCTION}

  end;


implementation


{ TArrayHelper }

class function TArrayHelper.Add<T>(var Values: TArray<T>; Item: T): integer;
begin
  Result := Length(Values);
  SetLength(Values,Result+1);
  Values[Result] := Item;
end;


class procedure TArrayHelper.Delete<T>(var Values: TArray<T>; Index: integer);
var
  I: Integer;
begin
  if (Index < Low(Values)) or (Index > High(Values)) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  for I := Index+1 to High(Values) do
    Values[I-1] := Values[I];
  SetLength(Values, length(Values)-1);
end;


class procedure TArrayHelper.Insert<T>(var Values: TArray<T>; Index: integer; Value: T);
var
  I,H: Integer;
begin
  if (Index < Low(Values)) or (Index > length(Values)) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  H := High(Values);
  SetLength(Values, length(Values)+1);
  for I := H downto Index do
    Values[I+1] := Values[I];
  Values[Index] := Value;
end;


class procedure TArrayHelper.InsertRange<T>(var Values: TArray<T>; Index: Integer; const ValuesToInsert: array of T);
var
  I,L,H: Integer;
begin
  L := length(ValuesToInsert);
  if L = 0 then EXIT;
  if (Index < Low(Values)) or (Index > length(Values)) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  H := High(Values);
  SetLength(Values, length(Values) + L);
  for I := H downto Index do
    Values[I+L] := Values[I];
  for I := Low(ValuesToInsert) to High(ValuesToInsert) do
    Values[Index+I] := ValuesToInsert[I];
end;


class procedure TArrayHelper.AddRange<T>(var Values: TArray<T>; const ValuesToInsert: array of T);
var
  I,Index: Integer;
begin
  Index := length(Values);
  SetLength(Values, length(Values) + length(ValuesToInsert));
  for I := Low(ValuesToInsert) to High(ValuesToInsert) do
    Values[Index+I] := ValuesToInsert[I];
end;


class function TArrayHelper.IndexOf<T>(var Values: TArray<T>; Item: T; const Comparer: IComparer<T>): integer;
begin
  for Result := Low(Values) to High(Values) do
    if Comparer.Compare(Values[Result], Item) = 0 then EXIT;
  Result := -1;
end;


class function TArrayHelper.IndexOf<T>(var Values: TArray<T>; Item: T): integer;
begin
  Result := IndexOf<T>(Values, Item, TComparer<T>.Default);
end;



class function TArrayHelper.Contains<T>(var Values: TArray<T>; Item: T; const Comparer: IComparer<T>): boolean;
begin
  Result := IndexOf<T>(Values, Item, Comparer) <> -1;
end;



class function TArrayHelper.Contains<T>(var Values: TArray<T>; Item: T): boolean;
begin
  Result := Contains<T>(Values, Item, TComparer<T>.Default);
end;



class function TArrayHelper.Compare<T>(const Values, ValuesToCompare: TArray<T>; const Comparer: IComparer<T>): boolean;
var
  I: Integer;
begin
  if length(Values) <> length(ValuesToCompare) then EXIT( FALSE );
  for I := Low(Values) to High(Values) do
    if Comparer.Compare(Values[I], ValuesToCompare[I]) <> 0 then EXIT( FALSE );
  Result := TRUE;
end;


class function TArrayHelper.Compare<T>(const Values, ValuesToCompare: TArray<T>): boolean;
begin
  Result := Compare<T>(Values, ValuesToCompare, TComparer<T>.Default);
end;



class function TArrayHelper.Find<T>(const Values: TArray<T>; const Callback: TArrayFindCallback<T>;
  const StartIndex: integer): integer;
begin
  if (length(Values) = 0) or (StartIndex < 0) or (StartIndex > High(Values)) then EXIT( -1 );
  for Result := StartIndex to High(Values) do
    if Callback(Values[Result]) then EXIT;
  Result := -1;
end;



class function TArrayHelper.Map<T>(const Values: TArray<T>; const Callback: TArrayMapCallback<T>): TArray<T>;
var
  Item: T;
  I: Integer;
begin
  Result := NIL;
  for I := Low(Values) to High(Values) do
  begin
    Item := Values[I];
    if Callback(Item, I) then
      Add<T>(Result, Item);
  end;
end;





{$IFDEF TEST_FUNCTION}

function CompareJokerFunction(const Value: string): boolean;
begin
  Result := LowerCase(Value) = 'joker';
end;


class procedure TArrayHelper.Test_All_Helper_Functions;
var
  AI: TArray<integer>;
  AStr: TArray<string>;
  I,N: Integer;
begin
  // Add
  AI := NIL;
  assert( TArray.Add<integer>(AI,1) = 0 );
  assert( TArray.Add<integer>(AI,2) = 1 );
  assert( TArray.Add<integer>(AI,3) = 2 );

  // IndexOf
  assert( TArray.IndexOf<integer>(AI,1) = 0 );
  assert( TArray.IndexOf<integer>(AI,2) = 1 );
  assert( TArray.IndexOf<integer>(AI,5) = -1 );

  // Contains
  assert( TArray.Contains<integer>(AI,2) = TRUE );
  assert( TArray.Contains<integer>(AI,5) = FALSE );
  assert( TArray.Contains<integer>(AI,5, TComparer<integer>.Construct(
    function(const Left, Right: integer): Integer
    begin
      Result := Left - (Right + 4);
    end
  )) = FALSE );


  // Delete
  TArray.Delete<integer>(AI,1);
  assert( TArray.Contains<integer>(AI,2) = FALSE );
  assert( length(AI) = 2 );
  try TArray.Delete<integer>(AI,2); assert(TRUE); except end;  // exception expected
  TArray.Delete<integer>(AI,0);  assert( length(AI) = 1 );
  TArray.Delete<integer>(AI,0);  assert( length(AI) = 0 );
  try TArray.Delete<integer>(AI,0); assert(TRUE); except end;  // exception expected

  // Insert
  AStr := NIL;
  TArray.Insert<string>(AStr, 0, 'one');
  TArray.Insert<string>(AStr, 0, 'two');
  assert( length(AStr) = 2 );
  assert( AStr[0] = 'two' );
  assert( AStr[1] = 'one' );

  TArray.Insert<string>(AStr, 2, 'three');
  assert( (length(AStr) = 3) and (AStr[2] = 'three') );

  // AddRange
  AI := NIL;
  TArray.AddRange<integer>(AI, TArray<integer>.Create(4,5,6));
  assert( (length(AI) = 3) and (AI[2] = 6) );
  TArray.AddRange<integer>(AI, TArray<integer>.Create(10,11,12));
  assert( (length(AI) = 6) and (AI[5] = 12) and (AI[0] = 4) );

  // InsertRange
  AI := NIL;
  TArray.InsertRange<integer>(AI, 0, TArray<integer>.Create(4,5,6));
  assert( (length(AI) = 3) and (AI[2] = 6) );
  TArray.InsertRange<integer>(AI, 0, TArray<integer>.Create(10,11,12));
  assert( (length(AI) = 6) and (AI[5] = 6) and (AI[0] = 10) );
  TArray.InsertRange<integer>(AI, 3, TArray<integer>.Create(21,22));
  assert( (length(AI) = 8) and (AI[7] = 6) and (AI[0] = 10) and (AI[3] = 21) );

  // Find
  AI := NIL;
  AStr := TArray<string>.Create('4','king','joker','7','JOKER','joker','ace','joker');
  I := -1;
  repeat
    I := TArray.Find<string>(AStr, CompareJokerFunction, I+1);
    if I >= 0 then TArray.Add<integer>(AI, I);
  until I < 0;
  assert( TArray.Compare<integer>(AI, TArray<integer>.Create(2,4,5,7)) );


  // Map
  AI := NIL;
  for I := 1 to 50 do TArray.Add<integer>(AI, I);
  AI := TArray.Map<integer>(AI,
    function(var Value: integer; Index: integer): boolean
    begin
      Result := (Value >= 10) and (Value < 20);
      if Result then
        Value := Value + 100;
    end
  );
  assert( length(AI) = 10 );
  assert( AI[1] = 111 );

  // Map <string>
  AStr := TArray<string>.Create('Mon','Tues','Wednes','Thurs','Fri','Satur','Sun');
  AStr := TArray.Map<string>( AStr,
    function(var Value: string; Index: integer): boolean
    begin
      Result := TRUE;
      Value := Value + 'day';
    end
  );
  assert( TArray.Contains<string>(AStr, 'Monday') );
  assert( TArray.Contains<string>(AStr, 'Sunday') );

end;

{$ENDIF TEST_FUNCTION}


end.



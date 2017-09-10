# ArrayHelper

Delphi class helper for TArray. Class functions Add, Delete, IndexOf, Map and more, including examples and test.

## Usage

Add ArrayHelpher to your 'uses'.

	var
	  A: TArray<string>;
	begin
	  A := NIL;
	  TArray.Insert<string>( A, 0, 'one' );
	  TArray.Add<string>( A, 'two' );
	  if TArray.Contains<string>( A, 'one' ) then  ...
 

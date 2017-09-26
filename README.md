# ArrayHelper

Delphi class helper for TArray. Class functions Add, Delete, IndexOf, Map and more, including examples and test.

Dynamic arrays are smart because its memory usage is handled by the memory
manager. But the function libraries are lean and differs from object based.
Based on TArray class, that gives Sort and Binary search, this unit will
extend TArray with functions available for TList or TStrings.

The next level is TArrayRecord<T> record type. It wraps a record around
the dynamic array. This give us the ability to use dynamic arrays like
objects with out the pain to organize the final Free call.

There are test functions with examples included.


## Usage

Add ArrayHelpher to your 'uses' section.

use TArray like this

	var
	  A: TArray<string>;
	begin
	  A := NIL;
	  TArray.Insert<string>( A, 0, 'one' );
	  TArray.Add<string>( A, 'two' );
	  if TArray.Contains<string>( A, 'one' ) then  ...

use TArrayRecord like this
	  
	var
	  A: TArrayRecord<string>;
	begin
	  A.SetValues(['a','b','c']);
	  A.Add('d');
	  assert(  A.Count = 4 );    // same as length(A.Items);
	  assert(  A[1] = 'b' );
	  assert(  A.IndexOf('a') = 0 );
      ..

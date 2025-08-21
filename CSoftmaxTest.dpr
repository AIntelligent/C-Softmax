program CSoftmaxTest;

{$APPTYPE CONSOLE}

{$R *.res}

//
// C-Softmax - 2025.08.25
//
// Author:
//       Kartal, Hakan Emre,
//       <hek@nula.com.tr>,
//       ORCID:0000-0002-3952-7235
//
//  Copyright (c) 2025 Kartal, Hakan Emre
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
{
  Output:

        r = 3, d = 2

        T = [
          [     1,000000,     2,000000 ],
          [     3,000000,     1,000000 ],
          [     2,000000,     3,000000 ]
        ]

        vecomega = [ 0,8000, 0,4000 ]

        vecalpha = [ 0,3000, 0,5000, 0,7000 ]

        vecbeta  = [ 0,1000, -0,2000, 0,3000 ]

        C-Softmax( T ) = [ 0,0826, 0,2773, 0,6401 ], Sum = 1.000000
}

uses
  SysUtils,
  Math;

type
  TVector = array of Double;
  TMatrix = array of TVector;

  TVectorHelper = record helper for TVector
    function Normalized() : TVector;
    function Sum() : Double;
    function Max() : Double;
    function Mul( const inValue : Double ) : TVector; overload;
    function Mul( const inVector : TVector ) : TVector; overload;
    function Add( const inValue : Double ) : TVector; overload;
    function Add( const inVector : TVector ) : TVector; overload;
    function ToString( const inPrecision : Integer = 4; const inPadding : Integer = 6 ) : string;
  end;

  TMatrixHelper = record helper for TMatrix
    function ToString( const inIndent : Integer = 2; const inPrecision : Integer = 6; const inPadding : Integer = 12 ) : string;
  end;

{$REGION ' TVectorHelper '}

function TVectorHelper.Normalized() : TVector;
var
  j : Integer;
  l_fSum : Double;
begin
  SetLength(Result, Length(Self));

  l_fSum := Self.Sum();

  for j := Low(Self) to High(Self) do
    Result[ j ] := Self[ j ] / l_fSum;
end;

function TVectorHelper.Sum() : Double;
var
  j : Integer;
begin
  Result := 0.0;

  for j := Low(Self) to High(Self) do
    Result := Result + Self[ j ];
end;

function TVectorHelper.Max() : Double;
var
  j : Integer;
begin
  if (Length(Self) > 0) then
    begin
      Result := Self[ 0 ];

      for j := 1 to High(Self) do
        if (Self[ j ] > Result) then
          Result := Self[ j ];
    end
  else
    Result := -Infinity;
end;

function TVectorHelper.Mul( const inValue : Double ) : TVector;
var
  j : Integer;
begin
  SetLength(Result, Length(Self));

  for j := Low(Self) to High(Self) do
    Result[ j ] := inValue * Self[ j ];
end;

function TVectorHelper.Mul( const inVector : TVector ) : TVector;
var
  j : Integer;
begin
  Assert(Length(inVector) = Length(Self));

  SetLength(Result, Length(Self));

  for j := Low(Self) to High(Self) do
    Result[ j ] := Self[ j ] * inVector[ j ];
end;

function TVectorHelper.Add( const inValue : Double ) : TVector;
var
  j : Integer;
begin
  SetLength(Result, Length(Self));

  for j := Low(Self) to High(Self) do
    Result[ j ] := Self[ j ] + inValue;
end;

function TVectorHelper.Add( const inVector : TVector ) : TVector;
var
  j : Integer;
begin
  Assert(Length(inVector) = Length(Self));

  SetLength(Result, Length(Self));

  for j := Low(Self) to High(Self) do
    Result[ j ] := Self[ j ] + inVector[ j ];
end;

function TVectorHelper.ToString( const inPrecision, inPadding : Integer ) : string;
var
  j : Integer;
  l_strValue : string;
begin
  Result := string.Empty;

  for j := Low(Self) to High(Self) do
  begin
    l_strValue := Format( '%.*f', (. inPrecision, Self[ j ] .) );
    l_strValue := Format( '%*s', (. inPadding, l_strValue .) );

    if (string.IsNullOrEmpty(Result)) then
      Result := l_strValue
    else
      Result := Result + ', ' + l_strValue;
  end;

  if (not string.IsNullOrEmpty(Result)) then
    Result := '[ ' + Result + ' ]';
end;

{$ENDREGION}

{$REGION ' TMatrixHelper '}

function TMatrixHelper.ToString( const inIndent, inPrecision, inPadding : Integer ) : string;
var
  i, l_iLPad : Integer;
  l_strLine : string;
begin
  Result := string.Empty;

  for i := Low(Self) to High(Self) do
  begin
    l_strLine := Self[ i ].ToString( inPrecision, inPadding );
    l_iLPad := (inIndent + Length(l_strLine));

    l_strLine := Format( '%*s', [ l_iLPad, l_strLine ] );

    if (string.IsNullOrEmpty(Result)) then
      Result := l_strLine
    else
      Result := Result + ','^J^M + l_strLine;
  end;

  if (not string.IsNullOrEmpty(Result)) then
    Result := '['^J^M + Result + ^J^M']';
end;

{$ENDREGION}

var
  r : Integer = 3;
  d : Integer = 2;
  vecomega,
  vecalpha,
  vecbeta : TVector;
  tau : Double;

function C_softmax( T : TMatrix ) : TVector;
var
  i : Integer;
  omega_normalized,
  alpha_normalized : TVector;
  s, z,
  z_shifted,
  exp_z: TVector;
  max_z,
  sum_exp_z : Double;
begin
  SetLength(Result, r);
  SetLength(s, r);
  SetLength(z, r);
  SetLength(z_shifted, r);
  SetLength(exp_z, r);

  omega_normalized := vecomega.Normalized();

  // s = T @ omega_normalized + beta
  for i := 0 to r - 1 do
    s[ i ] := T[ i ].Mul( omega_normalized ).Sum() + vecbeta[ i ];

  alpha_normalized := vecalpha.Normalized();

  // z = (s + tau * ln(alpha_normalized)) / tau
  for i := 0 to r - 1 do
    z[ i ] := (s[ i ] + tau * Ln( alpha_normalized[ i ] )) / tau;

  // For (overflow protection)...
  max_z := z.Max();

  // z_shifted = z - max_z & exp_z = exp( z_shifted )
  z_shifted := z.Add( -max_z );

  for i := 0 to r - 1 do
    exp_z[ i ] := Exp( z_shifted[ i ] );

  sum_exp_z := exp_z.Sum();

  for i := 0 to r - 1 do
    Result[ i ] := exp_z[ i ] / sum_exp_z;
end;

var
  T : TMatrix;
  l_arrResult : TVector;

begin
  SetLength(T, r, d);
    T         [ 0 ][ 0 ] := 1.0;
    T         [ 0 ][ 1 ] := 2.0;
    T         [ 1 ][ 0 ] := 3.0;
    T         [ 1 ][ 1 ] := 1.0;
    T         [ 2 ][ 0 ] := 2.0;
    T         [ 2 ][ 1 ] := 3.0;

  SetLength(vecomega, d);
    vecomega  [ 0 ] := 0.8;
    vecomega  [ 1 ] := 0.4;

  SetLength(vecalpha, r);
    vecalpha  [ 0 ] := 0.3;
    vecalpha  [ 1 ] := 0.5;
    vecalpha  [ 2 ] := 0.7;

  SetLength(vecbeta, r);
    vecbeta   [ 0 ] := 0.1;
    vecbeta   [ 1 ] := -0.2;
    vecbeta   [ 2 ] := 0.3;

  tau := 1.0;

  WriteLn( 'r = ', r, ', d = ', d );

  WriteLn( #13#10'T = ', T.ToString() );

  WriteLn( #13#10'vecomega = ', vecomega.ToString() );

  WriteLn( #13#10'vecalpha = ', vecalpha.ToString() );

  WriteLn( #13#10'vecbeta  = ', vecbeta.ToString() );

  l_arrResult := C_softmax( T );

  WriteLn( #13#10'C-Softmax( T ) = ', l_arrResult.ToString(), ', Sum = ', l_arrResult.Sum():0:6 );

  ReadLn;
end.

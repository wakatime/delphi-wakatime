  {$IF CompilerVersion >= 36.0}
    {$DEFINE DELPHI_12_0_ATHENS_UP}
  {$ELSEIF CompilerVersion >= 35.0}
    {$DEFINE DELPHI_11_3_ALEXANDRIA_UP}
  {$ELSEIF CompilerVersion >= 34.0}
    {$DEFINE DELPHI_10_4_SYDNEY_UP}
  {$ELSEIF CompilerVersion >= 33.0}
    {$DEFINE DELPHI_10_3_RIO_UP}
  {$ELSEIF CompilerVersion >= 32.0}
    {$DEFINE DELPHI_10_2_TOKYO_UP}
  {$ELSEIF CompilerVersion >= 31.0}
    {$DEFINE DELPHI_10_1_BERLIN_UP}
  {$ELSEIF CompilerVersion >= 30.0}
    {$DEFINE DELPHI_10_SEATTLE_UP}
  {$ELSEIF CompilerVersion >= 29.0}
    {$DEFINE DELPHI_XE8_UP}
  {$ELSEIF CompilerVersion >= 28.0}
    {$DEFINE DELPHI_XE7_UP}
  {$ELSEIF CompilerVersion >= 27.0}
    {$DEFINE DELPHI_XE6_UP}
  {$ELSEIF CompilerVersion >= 26.0}
    {$DEFINE DELPHI_XE5_UP}
  {$ELSEIF CompilerVersion >= 25.0}
    {$DEFINE DELPHI_XE4_UP}
  {$ELSEIF CompilerVersion >= 24.0}
    {$DEFINE DELPHI_XE3_UP}
  {$ELSEIF CompilerVersion >= 23.0}
    {$DEFINE DELPHI_XE2_UP}
  {$ELSEIF CompilerVersion >= 22.0}
    {$DEFINE DELPHI_XE_UP}
  {$ELSEIF CompilerVersion >= 21.0}
    {$DEFINE DELPHI_2010_UP}
  {$ELSEIF CompilerVersion >= 20.0}
    {$DEFINE DELPHI_2009_UP}
  {$ELSEIF CompilerVersion >= 19.0}
    {$DEFINE DELPHI_2007_FOR_NET_UP}
  {$ELSEIF CompilerVersion >= 18.5}
    {$DEFINE DELPHI_2007_UP}
  {$ELSEIF CompilerVersion >= 18.0}
    {$DEFINE DELPHI_2006_UP}
  {$ELSEIF CompilerVersion >= 17.0}
    {$DEFINE DELPHI_2005_UP}
  {$ELSEIF CompilerVersion >= 16.0}
    {$DEFINE DELPHI_8_FOR_NET_UP}
  {$ELSEIF CompilerVersion >= 15.0}
    {$DEFINE DELPHI_7_UP}
  {$ELSEIF CompilerVersion >= 14.0}
    {$DEFINE DELPHI_6_UP}
  {$IFEND}

{$IF CompilerVersion = 36.0}
  {$DEFINE DELPHI_12_0_ATHENS}
{$ELSEIF CompilerVersion = 35.0}
  {$DEFINE DELPHI_11_3_ALEXANDRIA}
{$ELSEIF CompilerVersion = 34.0}
  {$DEFINE DELPHI_10_4_SYDNEY}
{$ELSEIF CompilerVersion = 33.0}
  {$DEFINE DELPHI_10_3_RIO}
{$ELSEIF CompilerVersion = 32.0}
  {$DEFINE DELPHI_10_2_TOKYO}
{$ELSEIF CompilerVersion = 31.0}
  {$DEFINE DELPHI_10_1_BERLIN}
{$ELSEIF CompilerVersion = 30.0}
  {$DEFINE DELPHI_10_SEATTLE}
{$ELSEIF CompilerVersion = 29.0}
  {$DEFINE DELPHI_XE8}
{$ELSEIF CompilerVersion = 28.0}
  {$DEFINE DELPHI_XE7}
{$ELSEIF CompilerVersion = 27.0}
  {$DEFINE DELPHI_XE6}
{$ELSEIF CompilerVersion = 26.0}
  {$DEFINE DELPHI_XE5}
{$ELSEIF CompilerVersion = 25.0}
  {$DEFINE DELPHI_XE4}
{$ELSEIF CompilerVersion = 24.0}
  {$DEFINE DELPHI_XE3}
{$ELSEIF CompilerVersion = 23.0}
  {$DEFINE DELPHI_XE2}
{$ELSEIF CompilerVersion = 22.0}
  {$DEFINE DELPHI_XE}
{$ELSEIF CompilerVersion = 21.0}
  {$DEFINE DELPHI_2010}
{$ELSEIF CompilerVersion = 20.0}
  {$DEFINE DELPHI_2009}
{$ELSEIF CompilerVersion = 19.0}
  {$DEFINE DELPHI_2007_FOR_NET}
{$ELSEIF CompilerVersion = 18.5}
  {$DEFINE DELPHI_2007}
{$ELSEIF CompilerVersion = 18.0}
  {$DEFINE DELPHI_2006}
{$ELSEIF CompilerVersion = 17.0}
  {$DEFINE DELPHI_2005}
{$ELSEIF CompilerVersion = 16.0}
  {$DEFINE DELPHI_8_FOR_NET}
{$ELSEIF CompilerVersion = 15.0}
  {$DEFINE DELPHI_7}
{$ELSEIF CompilerVersion = 14.0}
  {$DEFINE DELPHI_6}
{$IFEND}

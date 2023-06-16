  {$IF CompilerVersion >= 33.0}
    {$DEFINE DELPHI_10_3_RIO_UP}
  {$IFEND}
  {$IF CompilerVersion >= 32.0}
    {$DEFINE DELPHI_10_2_TOKYO_UP}
  {$IFEND}
  {$IF CompilerVersion >= 31.0}
    {$DEFINE DELPHI_10_1_BERLIN_UP}
  {$IFEND}
  {$IF CompilerVersion >= 30.0}
    {$DEFINE DELPHI_10_SEATTLE_UP}
  {$IFEND}
  {$IF CompilerVersion >= 29.0}
    {$DEFINE DELPHI_XE8_UP}
  {$IFEND}
  {$IF CompilerVersion >= 28.0}
    {$DEFINE DELPHI_XE7_UP}
  {$IFEND}
  {$IF CompilerVersion >= 27.0}
    {$DEFINE DELPHI_XE6_UP}
  {$IFEND}
  {$IF CompilerVersion >= 26.0}
    {$DEFINE DELPHI_XE5_UP}
  {$IFEND}
  {$IF CompilerVersion >= 25.0}
    {$DEFINE DELPHI_XE4_UP}
  {$IFEND}
  {$IF CompilerVersion >= 24.0}
    {$DEFINE DELPHI_XE3_UP}
  {$IFEND}
  {$IF CompilerVersion >= 23.0}
    {$DEFINE DELPHI_XE2_UP}
  {$IFEND}
  {$IF CompilerVersion >= 22.0}
    {$DEFINE DELPHI_XE_UP}
  {$IFEND}
  {$IF CompilerVersion >= 21.0}
    {$DEFINE DELPHI_2010_UP}
  {$IFEND}
  {$IF CompilerVersion >= 20.0}
    {$DEFINE DELPHI_2009_UP}
  {$IFEND}
  {$IF CompilerVersion >= 19.0}
    {$DEFINE DELPHI_2007_FOR_NET_UP}
  {$IFEND}
  {$IF CompilerVersion >= 18.5}
    {$DEFINE DELPHI_2007_UP}
  {$IFEND}
  {$IF CompilerVersion >= 18.0}
    {$DEFINE DELPHI_2006_UP}
  {$IFEND}
  {$IF CompilerVersion >= 17.0}
    {$DEFINE DELPHI_2005_UP}
  {$IFEND}
  {$IF CompilerVersion >= 16.0}
    {$DEFINE DELPHI_8_FOR_NET_UP}
  {$IFEND}
  {$IF CompilerVersion >= 15.0}
    {$DEFINE DELPHI_7_UP}
  {$IFEND}
  {$IF CompilerVersion >= 14.0}
    {$DEFINE DELPHI_6_UP}
  {$IFEND}


{$IF CompilerVersion = 33.0}
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

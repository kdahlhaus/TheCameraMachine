/*
 Copyright (C) 2011 J. Coliz <maniacbug@ymail.com>

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 version 2 as published by the Free Software Foundation.
 */

// STL includes
// C includes
// Library includes
#include <RTClib.h>
// Project includes
#include <SerialLineIn.h>

IRtc* SerialLineIn::rtc = NULL;

/****************************************************************************/

inline uint8_t conv2d(const char* p)
{
    uint8_t v = 0;
    if ('0' <= *p && *p <= '9')
        v = *p - '0';
    return 10 * v + *++p - '0';
}

/****************************************************************************/

SerialLineIn::SerialLineIn(void): current(buf)
{
}

/****************************************************************************/

void SerialLineIn::dispatch(void) 
{
  DateTime now;
  if ( rtc )
  {
    now = rtc->now_unixtime();
  }
  switch (toupper(*buf))
  {
    case 'D':
      // Dyymmdd: Set date
      if ( rtc )
      {
	now = DateTime(2000+conv2d(buf+1),conv2d(buf+3),conv2d(buf+5),now.hour(),now.minute(),now.second());
	rtc->adjust(now.unixtime());
      }
      else
	printf_P(PSTR("SERL Error: No RTC set\n\r"));
      break;
    case 'T':
      // Thhmmss: Set time
      if ( rtc )
      {
	now = DateTime(now.year(),now.month(),now.day(),conv2d(buf+1),conv2d(buf+3),conv2d(buf+5));
	rtc->adjust(now.unixtime());
      }
      else
	printf_P(PSTR("SERL Error: No RTC set\n\r"));
    case 'E':
      break;
  }
}

/****************************************************************************/

void SerialLineIn::update(void) 
{
  while ( Serial.available() )
  {
    char c = Serial.read();
    Serial.print(c);
    if ( c != '\n' && c != '\r' )
      *current++ = c;
    
    if ( current >= buf + sizeof(buf) - 1 || c == '\n' || c == '\r' )
    {
      *current = 0;
      dispatch();
      current = buf;
    }
  }
}

/****************************************************************************/

// vim:cin:ai:sts=2 sw=2 ft=cpp

/*
 Copyright (C) 2012 J. Coliz <maniacbug@ymail.com>

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 version 2 as published by the Free Software Foundation.
 */

// Library includes
#include <Wire.h>
#include <SPI.h>
#include <EEPROM.h>
#include <SoftwareSerial.h>
#include <MemoryFree.h>
#include <AnyRtc.h>
#include <Tictocs.h>
//Project includes
#include "RtcEvTable.h"
#include "signals.h"
#include "events.h"

// Warning, these tables must be in clock order, earliest events first

//
// MAIN EVENT TABLE for handicam
//

const RtcEvTable::evline events_table[] PROGMEM = {
  //YY,MM,DD HH MM SS,CH, signal
  { 12, 4,26,13, 0, 0, 0,signal_fire_camera },
  { 12, 4,26,14, 0, 0, 0,signal_fire_camera },
  { 12, 4,26,15, 0, 0, 0,signal_fire_camera },
  { 12, 4,26,16, 0, 0, 0,signal_fire_camera },
  { 12, 4,26,17, 0, 0, 0,signal_fire_camera },
  { 12, 4,26,18, 0, 0, 0,signal_fire_camera },
  { 12, 4,26,19, 0, 0, 0,signal_fire_camera },
  { 12, 4,26,20, 0, 0, 0,signal_fire_camera },
  
};
int num_events = sizeof(events_table)/sizeof(RtcEvTable::evline);

const Sequence::Entry seq_fire_camera_entries[] PROGMEM = {
  // wait ms, then do this
  { 0	    , signal_power_on },
  { 10000   , signal_start_record },
  { 60000   , signal_stop_record },
  { 10000   , signal_power_off  },
  { 0, 0 }, // always terminate with a {0,0}
};
// vim:cin:ai:sts=2 sw=2 ft=cpp

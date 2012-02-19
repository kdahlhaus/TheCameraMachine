/*
 Copyright (C) 2012 J. Coliz <maniacbug@ymail.com>

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 version 2 as published by the Free Software Foundation.
 */

// Framework includes
#if ARDUINO < 100
#include <WProgram.h>
#else
#include <Arduino.h>
#endif
#include <Wire.h>
#include <SPI.h>
#include <EEPROM.h>
#include <SoftwareSerial.h>

// Library includes
#include <MemoryFree.h>
#include <AnyRtc.h>
#include <Tictocs.h>
// Project includes
#include "hardware.h"
#include "objects.h"
#include "rtc.h"
#include "signals.h"
#include "events.h"
#include "printf.h"

const int marker = 0; // Unused

#ifdef VERSION_H
#include <version.h>
#else
const char program_version[] = "Unknown";
#endif

void setup(void)
{
  //
  // Announce
  //

  Serial.begin(57600);
  printf_begin();
  printf_P(PSTR("\n\rTheCameraMachine - maniacbug@ymail.com\n\r"));
  printf_P(PSTR("VER. %s\n\r"),program_version);
  printf_P(PSTR("FREE %u\n\r"),freeMemory());
  
  //
  // Pin Symbols
  //

#if NATIVE
  pinSymbol(test_switch_pin,"test_switch");
  pinSymbol(record_button_pin,"record_button");
  pinSymbol(other_led_pin,"other_led");
  pinSymbol(power_led_pin,"power_led");
  pinSymbol(record_led_pin,"record_led");
  pinSymbol(power_relay_pin,"power_relay");
  pinSymbol(alt_relay_pin,"alt_relay");
  pinSymbol(lanc_rx_pin,"lanc_rx");
  pinSymbol(lanc_tx_pin,"lanc_tx");
#endif

  //
  // Begin objects
  //

  rtc_begin();
  test_switch.begin(up);
  record_button.begin(up);
  power_led.begin(NULL);
  record_led.begin(NULL);
  other_led.begin(NULL);
  power_relay.begin(NULL);
  alt_relay.begin(NULL);
  camera.begin(NULL);
  fire_camera.begin(up,NULL);
  tty.begin(up);

  //
  // Logger symbols
  //

  logger.setSymbol(signal_power_on, PSTR("power_on"));
  logger.setSymbol(signal_power_off, PSTR("power_off"));
  logger.setSymbol(signal_start_record, PSTR("start_record"));
  logger.setSymbol(signal_stop_record, PSTR("stop_record"));
  logger.setSymbol(signal_alt_relay_on, PSTR("alt_relay_on"));
  logger.setSymbol(signal_alt_relay_off, PSTR("alt_relay_off"));
  logger.setSymbol(signal_other_led_on, PSTR("other_led_on"));
  logger.setSymbol(signal_other_led_off, PSTR("other_led_off"));
  logger.setSymbol(signal_toggle_record, PSTR("toggle_record"));
  logger.setSymbol(signal_fire_camera, PSTR("fire_camera"));

  logger.setSymbol(&test_switch, PSTR("test_switch"));
  logger.setSymbol(&record_button, PSTR("record_button"));
  logger.setSymbol(&power_relay, PSTR("power_relay"));
  logger.setSymbol(&alt_relay, PSTR("alt_relay"));
  logger.setSymbol(&power_led, PSTR("power_led"));
  logger.setSymbol(&record_led, PSTR("record_led"));
  logger.setSymbol(&other_led, PSTR("other_led"));
  logger.setSymbol(&camera, PSTR("camera"));
  logger.setSymbol(events.channel(0), PSTR("events ch#0"));
  logger.setSymbol(&fire_camera, PSTR("fire_camera"));
  logger.setSymbol(fire_camera.channel(0), PSTR("fire_camera ch#0"));
  
  // Begin the logger after all the symbols are set.
  logger.begin();
  conn.setLogger(&logger);
  
  // Begin the main events after the logger is set up
  events.begin(up);
}

void loop(void)
{
  up.update();
}
// vim:cin:ai:sts=2 sw=2 ft=cpp

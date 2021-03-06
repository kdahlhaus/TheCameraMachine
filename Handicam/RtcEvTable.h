/*
 Copyright (C) 2011 J. Coliz <maniacbug@ymail.com>

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 version 2 as published by the Free Software Foundation.
 */

#ifndef __RTCEVTABLE_H__
#define __RTCEVTABLE_H__

// STL includes
// C includes
// Library includes
#include <Connector.h>
#include <IUpdate.h>
// Project includes

class Updater;

/**
 * Maintains a list of time values and a signal to emit.  Monitors RTC time
 * and emits the signal when the time for each passes.
 *
 * This is currently application-specific only because it relies on the
 * logger by name.  This is not needed.  It could rely on a SimpleLibrary*.
 * Or even a 'dictionary' interface.
 */

class RtcEvTable: public IUpdate
{
public:
  typedef uint8_t ev_t;
  typedef ev_t evline[8];
  struct Channel: Connectable
  {
    Channel(Connector& _conn): Connectable(_conn)
    {
    }
    void emit(uint8_t signal)
    {
      Connectable::emit(signal);
    }
  };
private:
  const evline* table;
  const evline* current;
  Channel* channels;
  uint8_t num_lines;
  uint8_t num_channels;
protected:
  void update(void);
  bool is_time_now(void) const;
  ev_t current_channel(void) const;
  ev_t current_signal(void) const;
public:
  RtcEvTable(Connector& _conn,const evline* events,uint8_t num_lines, uint8_t num_channels = 1);
  virtual ~RtcEvTable();
  void begin(void);
  void begin(Updater&);
  void reset(void) { current = table; }
  void invalidate(void);
  bool is_valid(void) const;
  virtual uint32_t whenNext(void) const;
  Channel* channel(uint8_t);
};

/**
 * Specialization of RtcEvTable for use as a stand-alone timer-
 * based event table
 *
 * Listens for a signal, and then starts 
 */

class SignalEvTable: public RtcEvTable, public Connectable
{
  uint8_t signal_start;
  uint32_t started_at;
protected:
  virtual void onNotify(const Connectable* ,uint8_t signal );
public:
  SignalEvTable(Connector& _conn,uint8_t _signal_launch,const evline* events,uint8_t num_lines, uint8_t num_channels = 1);
  void begin(void) { RtcEvTable::begin(); }
  void begin(Updater&,Connectable* _who);
  void listen(Connectable* _who);
  virtual uint32_t whenNext(void) const;
};

#endif // __RTCEVTABLE_H__
// vim:cin:ai:sts=2 sw=2 ft=cpp

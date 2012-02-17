// STL includes
// C includes
// Framework includes
#if ARDUINO < 100
#include <WProgram.h>
#else
#include <Arduino.h>
#endif
// Library includes
// Project includes
#include "signals.h"
#include "LancControl.h"

/****************************************************************************/

LancControl::LancControl(Connector& _conn, int _rx_pin, int _tx_pin):
  Connectable(_conn), is_recording(false), lanc_serial(_rx_pin,_tx_pin) 
{
}

/****************************************************************************/

void LancControl::begin(void)
{
  lanc_serial.begin(9600);
  lanc_serial.print("ATZ");
  while (lanc_serial.available())
    Serial.write(lanc_serial.read());
}

/****************************************************************************/

void LancControl::listen(Connectable* _who)
{
  Connectable::listen(_who,signal_power_on);
  Connectable::listen(_who,signal_power_off);
  Connectable::listen(_who,signal_toggle_record);
}

/****************************************************************************/

bool LancControl::isRecording(void) const
{
  return is_recording;
}

/****************************************************************************/

void LancControl::onNotify(const Connectable* ,uint8_t signal )
{
  int i;

  switch (signal)
  {
  case signal_power_on:
    printf_P(PSTR("LANC Power Up\n\r"));

    i=3;
    while(i--)
    {
      lanc_serial.print("atsp\r\n");
      delay(100);
    }

    break;
  case signal_power_off:
    printf_P(PSTR("LANC Power Down\n\r"));

    lanc_serial.print("105e\r\n");
    delay(100);
    lanc_serial.write(32);

    break;
  case signal_start_record:
    is_recording = true;
    printf_P(PSTR("LANC Recording\n\r"));

    lanc_serial.print("103a\r\n");
    delay(100);
    lanc_serial.write(32);

    break;
  case signal_stop_record:
    is_recording = false;
    printf_P(PSTR("LANC Stopping\n\r"));
    lanc_serial.print("1033\r\n");
    delay(100);
    lanc_serial.write(32);
    
    break;
  case signal_toggle_record:
    is_recording = ! is_recording;
    if ( is_recording )
    {
      emit(signal_start_record);
      printf_P(PSTR("LANC Recording\n\r"));
      lanc_serial.print("103a\r\n");
      delay(100);
      lanc_serial.write(32);
    }
    else
    {
      emit(signal_stop_record);
      printf_P(PSTR("LANC Stopping\n\r"));
      lanc_serial.print("1033\r\n");
      delay(100);
      lanc_serial.write(32);
    }
    break;
  }
}

/****************************************************************************/
// vim:cin:ai:sts=2 sw=2 ft=cpp

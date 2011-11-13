#include <RTClib.h>
#include <RtcEvent.h>

#include <events.h>
#include <objects.h>
#include <signals.h>

MyRtcEvent::MyRtcEvent(int y, int m, int d, int hh, int mm, int ss, uint8_t signal):
  RtcEvent(::conn,DateTime(y,m,d,hh,mm,ss).unixtime(),signal), w(DateTime(y,m,d,hh,mm,ss).unixtime())
{
}

MyRtcEvent re[] = {
  MyRtcEvent(2011,11,10,6,0,0,signal_power_on),
  MyRtcEvent(2011,11,10,6,1,0,signal_start_record),
  MyRtcEvent(2011,11,10,6,2,0,signal_stop_record),
  MyRtcEvent(2011,11,10,6,3,0,signal_power_off)
};
int num_re = sizeof(re)/sizeof(re[0]);

void events_begin(void)
{
  MyRtcEvent *curr = re, *end = re + num_re; 
  while ( curr < end )
  {
    curr->begin();
    up.add(curr);
    ++curr;
  }
}
// vim:cin:ai:sts=2 sw=2 ft=cpp

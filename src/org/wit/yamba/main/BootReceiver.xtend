package  org.wit.yamba.main

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.preference.PreferenceManager
import android.util.Log

class BootReceiver extends BroadcastReceiver
{
  static val TAG = typeof(BootReceiver).simpleName
  static val DEFAULT_INTERVAL = AlarmManager.INTERVAL_FIFTEEN_MINUTES

  override onReceive(Context context, Intent intent) 
  {
    val prefs = PreferenceManager.getDefaultSharedPreferences(context)
    val interval = Long.parseLong(prefs.getString("interval", Long.toString(DEFAULT_INTERVAL)))

    val operation = PendingIntent.getService(context, -1, new Intent(context, typeof(RefreshService)), PendingIntent.FLAG_UPDATE_CURRENT)

    val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    if (interval == 0) 
    {
      alarmManager.cancel(operation)
      Log.d(TAG, "cancelling repeat operation")
    } 
    else 
    {
      alarmManager.setInexactRepeating(AlarmManager.RTC, System.currentTimeMillis(), interval, operation)
      Log.d(TAG, "setting repeat operation for: " + interval)
    }
    Log.d(TAG, "onReceived")
  }
}
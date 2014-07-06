package org.wit.yamba.main

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

class NotificationReceiver extends BroadcastReceiver 
{
  public static final int NOTIFICATION_ID = 42;

  override onReceive(Context context, Intent intent) 
  {
    val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    val count               = intent.getIntExtra("count", 0)
    val operation           = PendingIntent.getActivity(context, -1, new Intent(context, typeof(MainActivity)), PendingIntent.FLAG_ONE_SHOT)
    val notification        = new Notification.Builder(context)
                                  .setContentTitle("New tweets!")
                                  .setContentText("You've got " + count + " new tweets")
                                  .setSmallIcon(android.R.drawable.sym_action_email)
                                  .setContentIntent(operation)
                                  .setAutoCancel(true)
                                  .build()
    notificationManager.notify(NOTIFICATION_ID, notification)
  }
}
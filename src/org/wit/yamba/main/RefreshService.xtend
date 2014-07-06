package  org.wit.yamba.main

import android.app.IntentService
import android.content.Intent
import android.util.Log
import android.preference.PreferenceManager
import android.text.TextUtils
import android.widget.Toast
import com.marakana.android.yamba.clientlib.YambaClient
import com.marakana.android.yamba.clientlib.YambaClientException
import com.marakana.android.yamba.clientlib.YambaClient.Status
import android.content.ContentValues
import org.wit.yamba.model.StatusContract

class RefreshService extends IntentService
{
  val TAG = typeof(RefreshService).simpleName
  
  new()
  {
    super(typeof(RefreshService).simpleName)
  }
   
  override onCreate()
  {
    super.onCreate();
    Log.d(TAG, "onCreated")
  }
   
  override protected onHandleIntent(Intent intent) 
  {
    val prefs    = PreferenceManager.getDefaultSharedPreferences(this)
    val username = prefs.getString("username", "")
    val password = prefs.getString("password", "")
      
    if (TextUtils.isEmpty(username) || TextUtils.isEmpty(password))
    {
      Toast.makeText(this, "Please update your username and password", Toast.LENGTH_LONG).show
      return
    }
 
    Log.d(TAG, "onStarted");

    val values = new ContentValues
    
    val cloud = new YambaClient(username, password);
    try
    {
      val timeline = cloud.getTimeline(20)
      var count = 0
      for (Status it : timeline)
      { 
        values.clear
        values.put(StatusContract.Column.ID, it.getId());
        values.put(StatusContract.Column.USER, it.getUser());
        values.put(StatusContract.Column.MESSAGE, it.getMessage());
        values.put(StatusContract.Column.CREATED_AT, it.getCreatedAt().getTime());

        val uri = getContentResolver().insert(StatusContract.CONTENT_URI, values);
        if (uri != null)
        {
          count = count + 1
          Log.d(TAG, String.format("%s: %s", it.getUser(), it.getMessage()))
        }
      }
      if (count > 0)
      {
        sendBroadcast(new Intent("org.wit.yamba.action.NEW_STATUSES").putExtra("count", count))
      }
    }
    catch (YambaClientException e)
    {
      Log.e(TAG, "Failed to fetch the timeline", e)
      e.printStackTrace();
    }
    return;
  }
  
  override onDestroy()
  {
    super.onDestroy
    Log.d(TAG, "onDestroyed")
  }
} 
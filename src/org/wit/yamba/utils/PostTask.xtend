package org.wit.yamba.utils

import android.os.AsyncTask
import android.app.ProgressDialog
import android.widget.Toast
import android.util.Log
import com.marakana.android.yamba.clientlib.YambaClient
import android.preference.PreferenceManager
import android.text.TextUtils
import android.content.Intent
import android.app.Activity

import org.wit.yamba.controllers.SettingsActivity

class PostTask extends AsyncTask<String, Void, String>
{
  var ProgressDialog progress
  var Activity       activity
  var String         TAG
  
  new (Activity activity, String tag)
  {
    this.activity = activity
    this.TAG      = tag
  }
    
  def override onPreExecute()
  {
    progress = ProgressDialog.show(activity, "Posting", "Please wait...")
    progress.cancelable = true 
  }

  def override doInBackground(String... it)
  {
    try
    {
      val prefs    = PreferenceManager.getDefaultSharedPreferences(activity)
      val username = prefs.getString("username", "")
      val password = prefs.getString("password", "")
      
      if (TextUtils.isEmpty(username) || TextUtils.isEmpty(password))
      {
        activity.startActivity(new Intent(activity, typeof(SettingsActivity)))
        return "Please update your username and password"
      }

      val cloud = new YambaClient(username, password)
      cloud.postStatus(get(0))

      Log.d(TAG, "Successfully posted to the cloud: " + get(0))
      "Successfully posted"
    }
    catch (Exception e)
    {
      Log.e(TAG, "Failed to post to the cloud", e)
      e.printStackTrace
      "Failed to post"
    }
  }

  def override onPostExecute(String result)
  {
    progress.dismiss
    if (this != null && result != null)
    {
      Toast.makeText(activity, result, Toast.LENGTH_LONG).show
    }
  }
}

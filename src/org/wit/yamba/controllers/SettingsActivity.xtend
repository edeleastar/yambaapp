package  org.wit.yamba.controllers

import android.os.Bundle
import org.wit.yamba.main.SubActivity
import org.wit.yamba.R
import android.content.Intent
import android.content.SharedPreferences
import android.preference.PreferenceFragment
import android.preference.PreferenceManager

class SettingsActivity extends SubActivity
{
  override onCreate(Bundle savedInstanceState) 
  {
	  super.onCreate(savedInstanceState);
    if (savedInstanceState == null) fragmentManager.beginTransaction.add(android.R.id.content, new SettingsFragment).commit
  } 
}

class SettingsFragment extends PreferenceFragment
{
  var SharedPreferences prefs
  
  val update =
  [
    SharedPreferences sharedPreferences, String key |
    activity.sendBroadcast(new Intent("org.wit.yamba.action.UPDATED_INTERVAL"))
  ]
  
  override onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState)
    addPreferencesFromResource(R.xml.settings)
  }

  override onStart()
  {
    super.onStart
    prefs = PreferenceManager.getDefaultSharedPreferences(activity)
    prefs.registerOnSharedPreferenceChangeListener(update)
  }

  override onStop()
  {
    super.onStop
    prefs.unregisterOnSharedPreferenceChangeListener(update)
  } 
}
package org.wit.yamba.main

import org.wit.yamba.R
import android.app.Activity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.content.Intent
import android.widget.Toast
import org.wit.yamba.controllers.SettingsActivity
import org.wit.yamba.controllers.StatusActivity
import org.wit.yamba.model.StatusContract

class MainActivity extends Activity 
{
  override onCreate(Bundle savedInstanceState) 
  {
   super.onCreate(savedInstanceState);
   contentView = R.layout.activity_main
  } 

	override onCreateOptionsMenu(Menu menu)
	{
		menuInflater.inflate(R.menu.main, menu)
		true
	} 

	override onOptionsItemSelected(MenuItem item) 
	{
	 switch (item.itemId)   
	 {
		  case R.id.action_settings :	startActivity (new Intent(this, typeof(SettingsActivity)))
      case R.id.action_tweet    : startActivity (new Intent(this, typeof(StatusActivity)))
      case R.id.action_refresh  : startService  (new Intent(this, typeof(RefreshService)))
      case R.id.action_purge    :
      {
        val rows = contentResolver.delete(StatusContract.CONTENT_URI, null, null)
        Toast.makeText(this, "Deleted "+rows+" rows", Toast.LENGTH_LONG).show
      }
		}
		true 
	}
}
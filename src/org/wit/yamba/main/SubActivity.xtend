package  org.wit.yamba.main

import android.app.Activity
import android.os.Bundle
import android.content.Intent
import android.view.MenuItem
import org.wit.yamba.main.MainActivity

class SubActivity extends Activity
{
  override onCreate(Bundle savedInstanceState) 
  {
    super.onCreate(savedInstanceState);
    actionBar.displayHomeAsUpEnabled = true
  } 

  override onOptionsItemSelected(MenuItem item)
  {
    switch (item.itemId)
    {
      case android.R.id.home :  startActivity(new Intent(this, typeof(MainActivity)).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP))
      default                :  super.onOptionsItemSelected(item)
    }
    true
  }   
}
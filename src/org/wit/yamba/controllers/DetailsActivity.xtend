package org.wit.yamba.controllers

import android.os.Bundle
import org.wit.yamba.main.SubActivity
import org.wit.yamba.R
import android.app.Fragment
import android.content.ContentUris
import android.text.format.DateUtils
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.TextView
import org.wit.yamba.model.StatusContract

class DetailsActivity extends SubActivity
{
  override onCreate(Bundle savedInstanceState) 
  {
	  super.onCreate(savedInstanceState)
	  
    if (savedInstanceState == null) fragmentManager.beginTransaction.add(android.R.id.content, new DetailsFragment).commit
  }  
}

public class DetailsFragment extends Fragment
{
  var TextView textUser
  var TextView textMessage
  var TextView textCreatedAt

  override onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
  {
    val view = inflater.inflate(R.layout.list_item, null, false)

    textUser      =  view.findViewById(R.id.list_item_text_user)       as TextView
    textMessage   =  view.findViewById(R.id.list_item_text_message)    as TextView
    textCreatedAt =  view.findViewById(R.id.list_item_text_created_at) as TextView

    view
  }

  override onResume()
  {
    super.onResume
    val id = activity.intent.getLongExtra(StatusContract.Column.ID, -1)

    updateView(id)
  }
 
  def updateView(long id)
  {
    if (id == -1)
    {
      textUser.text      = ""
      textMessage.text   = ""
      textCreatedAt.text = ""
      return
    }

    val uri = ContentUris.withAppendedId(StatusContract.CONTENT_URI, id)

    val cursor = activity.contentResolver.query(uri, null, null, null, null)
    if (!cursor.moveToFirst)
      return

    val user      = cursor.getString(cursor.getColumnIndex(StatusContract.Column.USER))
    val message   = cursor.getString(cursor.getColumnIndex(StatusContract.Column.MESSAGE))
    val createdAt = cursor.getLong(cursor.getColumnIndex(StatusContract.Column.CREATED_AT))

    textUser.text      = user
    textMessage.text   = message
    textCreatedAt.text = DateUtils.getRelativeTimeSpanString(createdAt)
  }
}
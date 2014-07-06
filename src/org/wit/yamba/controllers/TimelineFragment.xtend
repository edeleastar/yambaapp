package  org.wit.yamba.controllers

import org.wit.yamba.R
import android.app.ListFragment
import android.app.LoaderManager.LoaderCallbacks
import android.content.CursorLoader
import android.content.Intent
import android.content.Loader
import android.database.Cursor
import android.os.Bundle
import android.text.format.DateUtils
import android.util.Log
import android.view.View
import android.widget.ListView
import android.widget.SimpleCursorAdapter
import android.widget.SimpleCursorAdapter.ViewBinder
import android.widget.TextView
import android.widget.Toast
import org.wit.yamba.model.StatusContract

class MyViewBinder implements ViewBinder
{
  override setViewValue(View view, Cursor cursor, int columnIndex)
  {
    var long timestamp;
    switch (view.id)
    {
      case R.id.list_item_text_created_at:
      {
        timestamp = cursor.getLong(columnIndex)
        val relTime = DateUtils.getRelativeTimeSpanString(timestamp)
        val textView = view as TextView
        textView.text = relTime
        true
      }
      case R.id.list_item_freshness:
      {
        timestamp = cursor.getLong(columnIndex);
        val freshnessView = view as FreshnessView
        freshnessView.timestamp  = timestamp
        true
    }
    default: false
    }
  }
}

public class TimelineFragment extends ListFragment implements LoaderCallbacks<Cursor>
{
  static val TAG = typeof(TimelineFragment).simpleName
  static val String[] FROM = newArrayList ( StatusContract.Column.USER, 
                                            StatusContract.Column.MESSAGE,
                                            StatusContract.Column.CREATED_AT, 
                                            StatusContract.Column.CREATED_AT)
  static val int[] TO      = newArrayList ( R.id.list_item_text_user, 
                                            R.id.list_item_text_message,
                                            R.id.list_item_text_created_at, 
                                            R.id.list_item_freshness)
  static val LOADER_ID = 42;
  var SimpleCursorAdapter mAdapter
  val binder = new MyViewBinder

  override onActivityCreated(Bundle savedInstanceState)
  {
    super.onActivityCreated(savedInstanceState)

    mAdapter = new SimpleCursorAdapter(activity, R.layout.list_item, null, FROM, TO, 0)
    mAdapter.viewBinder = binder

    setListAdapter(mAdapter)

    loaderManager.initLoader(LOADER_ID, null, this)
  }

  override onListItemClick(ListView l, View v, int position, long id)
  {
    val fragment = fragmentManager.findFragmentById(R.id.fragment_details) as DetailsFragment

    if (fragment != null && fragment.isVisible)
    {
      fragment.updateView(id)
    }
    else
    {
      startActivity(new Intent(activity, typeof(DetailsActivity)).putExtra(StatusContract.Column.ID, id));
    }
  }

  override onCreateLoader(int id, Bundle args)
  {
    if (id != LOADER_ID)
      return null;
    Log.d(TAG, "onCreateLoader");

    val uri = StatusContract.CONTENT_URI
    return new CursorLoader(activity, uri, null, null, null, StatusContract.DEFAULT_SORT)
  }

  override onLoadFinished(Loader<Cursor> loader, Cursor cursor)
  {
    val fragment = fragmentManager.findFragmentById(R.id.fragment_details) as DetailsFragment

    if (fragment != null && fragment.isVisible && cursor.count == 0)
    {
      fragment.updateView(-1)
      Toast.makeText(activity, "No data", Toast.LENGTH_LONG).show
    }

    Log.d(TAG, "onLoadFinished with cursor: " + cursor.count)
    mAdapter.swapCursor(cursor)
  }

  override onLoaderReset(Loader<Cursor> loader)
  {
    mAdapter.swapCursor(null)
  }
}

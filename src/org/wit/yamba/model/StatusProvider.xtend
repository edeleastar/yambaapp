package  org.wit.yamba.model

import android.content.ContentProvider
import android.content.ContentUris
import android.content.ContentValues
import android.content.UriMatcher
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteQueryBuilder
import android.net.Uri
import android.text.TextUtils
import android.util.Log
import org.wit.yamba.model.DbHelper
import org.wit.yamba.model.StatusContract

class StatusProvider extends ContentProvider
{
  static val TAG = typeof(StatusProvider).simpleName
  
  var DbHelper dbHelper;

  static var UriMatcher sURIMatcher = 
  {
    val matcher = new UriMatcher(UriMatcher.NO_MATCH)
    matcher.addURI(StatusContract.AUTHORITY, StatusContract.TABLE, StatusContract.STATUS_DIR);    
    matcher.addURI(StatusContract.AUTHORITY, StatusContract.TABLE + "/#", StatusContract.STATUS_ITEM)
    matcher
  }
  
  override onCreate()
  {
    dbHelper = new DbHelper(getContext());
    Log.d(TAG, "onCreated");
    return false;
  }

  override String getType(Uri uri)
  {
    switch (sURIMatcher.match(uri))
    {
      case StatusContract.STATUS_DIR: 
      {
        Log.d(TAG, "gotType: " + StatusContract.STATUS_TYPE_DIR)
        return StatusContract.STATUS_TYPE_DIR
      }
      case StatusContract.STATUS_ITEM:
      {
        Log.d(TAG, "gotType: " + StatusContract.STATUS_TYPE_ITEM)
        return StatusContract.STATUS_TYPE_ITEM
      }
      default: throw new IllegalArgumentException("Illegal uri: " + uri)
    }
  }

  override insert(Uri uri, ContentValues values)
  {
    var Uri ret = null

    // Assert correct uri
    if (sURIMatcher.match(uri) != StatusContract.STATUS_DIR)
    {
      throw new IllegalArgumentException("Illegal uri: " + uri)
    }

    val db = dbHelper.writableDatabase
    val rowId = db.insertWithOnConflict(StatusContract.TABLE, null, values, SQLiteDatabase.CONFLICT_IGNORE)

    // Was insert successful?
    if (rowId != -1)
    {
      val id = values.getAsLong(StatusContract.Column.ID)
      ret = ContentUris.withAppendedId(uri, id)
      Log.d(TAG, "inserted uri: " + ret)

      // Notify that data for this uri has changed
      context.contentResolver.notifyChange(uri, null)
    }
    ret
  }

  override update(Uri uri, ContentValues values, String selection, String[] selectionArgs)
  {
    var String where
    var long   id

    switch (sURIMatcher.match(uri))
    {
      case StatusContract.STATUS_DIR  :  where = selection 
      case StatusContract.STATUS_ITEM :
      { 
         id    = ContentUris.parseId(uri)
         where = StatusContract.Column.ID + "=" + id + if (TextUtils.isEmpty(selection)) "" else " and ( " + selection + " )"
      }                                                                    
      default: throw new IllegalArgumentException("Illegal uri: " + uri)
    }

    val db  = dbHelper.writableDatabase
    val ret = db.update(StatusContract.TABLE, values, where, selectionArgs)
    if (ret > 0)
    {
      // Notify that data for this uri has changed
      context.contentResolver.notifyChange(uri, null)
    }
    Log.d(TAG, "updated records: " + ret);
    ret
  }

  // Implement Purge feature
  // Use db.delete()
  // DELETE FROM status WHERE id=? AND user='?'
  // uri: content://com.marakana.android.yamba.StatusProvider/status/47
  
  override delete(Uri uri, String selection, String[] selectionArgs)
  {
    var String where;

    switch (sURIMatcher.match(uri))
    {
    case StatusContract.STATUS_DIR:
    {
      // so we count deleted rows
      where = if (selection == null)  "1" else selection
    }
    case StatusContract.STATUS_ITEM:
    {
      val id = ContentUris.parseId(uri);
      where = StatusContract.Column.ID + "=" + id + if (TextUtils.isEmpty(selection)) "" else " and ( " + selection + " )"
     }
    default: throw new IllegalArgumentException("Illegal uri: " + uri)
    }

    val db  = dbHelper.getWritableDatabase()
    val ret = db.delete(StatusContract.TABLE, where, selectionArgs)

    if (ret > 0)
    {
      // Notify that data for this uri has changed
      context.contentResolver.notifyChange(uri, null)
    }
    Log.d(TAG, "deleted records: " + ret)
    ret
  }

  // SELECT username, message, created_at FROM status WHERE user='bob' ORDER
  // BY created_at DESC;
  
  override query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder)
  {
    val qb = new SQLiteQueryBuilder()
    qb.setTables(StatusContract.TABLE)

    switch (sURIMatcher.match(uri))
    {
    case StatusContract.STATUS_DIR: Log.d (TAG, "dir")
      
    case StatusContract.STATUS_ITEM:
      qb.appendWhere(StatusContract.Column.ID + "=" + uri.getLastPathSegment())
    default:
      throw new IllegalArgumentException("Illegal uri: " + uri)
    }

    val orderBy = if (TextUtils.isEmpty(sortOrder))  StatusContract.DEFAULT_SORT else sortOrder

    val db = dbHelper.getReadableDatabase
    val cursor = qb.query(db, projection, selection, selectionArgs, null, null, orderBy)

    // register for uri changes
    cursor.setNotificationUri(getContext().getContentResolver(), uri)

    Log.d(TAG, "queried records: " + cursor.count)
    return cursor
  }
} 
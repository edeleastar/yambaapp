package org.wit.yamba.model

import android.net.Uri;
import android.provider.BaseColumns;

class StatusContract
{
  // DB specific constants
  public static val DB_NAME    = "timeline.db"
  public static val DB_VERSION = 1
  public static val TABLE      = "status"

  // Provider specific constants
  // content://com.marakana.android.yamba.StatusProvider/status
  public static val AUTHORITY        = "org.wit.yamba.StatusProvider"
  public static val CONTENT_URI      = Uri.parse("content://" + AUTHORITY + "/" + TABLE)
  public static val STATUS_ITEM      = 1
  public static val STATUS_DIR       = 2
  public static val STATUS_TYPE_ITEM = "vnd.android.cursor.item/vnd.org.wit.yamba.provider.status"
  public static val STATUS_TYPE_DIR  = "vnd.android.cursor.dir/vnd.org.wit.yamba.provider.status"
  public static val DEFAULT_SORT     = Column.CREATED_AT + " DESC"

  static class Column
  {
    public static val ID         = BaseColumns._ID
    public static val USER       = "user"
    public static val MESSAGE    = "message"
    public static val CREATED_AT = "created_at"
  }
}

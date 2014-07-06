package org.wit.yamba.model

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log

class DbHelper extends SQLiteOpenHelper
{
  static val TAG = typeof(DbHelper).simpleName

  new(Context context)
  {
    super(context, StatusContract.DB_NAME, null, StatusContract.DB_VERSION)
  }

  override onCreate(SQLiteDatabase db)
  {
    val sql = String.format("create table %s (%s int primary key, %s text, %s text, %s int)", 
                             StatusContract.TABLE,
                             StatusContract.Column.ID, 
                             StatusContract.Column.USER, 
                             StatusContract.Column.MESSAGE,
                             StatusContract.Column.CREATED_AT)
    Log.d(TAG, "onCreate with SQL: " + sql)
    db.execSQL(sql)
  }

  override onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion)
  {
    db.execSQL("drop table if exists " + StatusContract.TABLE)
    onCreate(db)
  }
}
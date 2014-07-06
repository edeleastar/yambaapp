package  org.wit.yamba.controllers

import android.os.Bundle
import org.wit.yamba.main.SubActivity
import org.wit.yamba.R
import android.widget.EditText
import android.widget.Button
import android.util.Log
import android.text.Editable
import android.widget.TextView
import android.graphics.Color
import android.view.View.OnClickListener
import android.app.Fragment
import android.view.LayoutInflater
import android.view.ViewGroup
import org.wit.yamba.utils.AfterTextChanged
import org.wit.yamba.utils.TextWatcherAdapter
import org.wit.yamba.utils.PostTask

class StatusActivity extends SubActivity
{
  override onCreate(Bundle savedInstanceState) 
  {
    super.onCreate(savedInstanceState);
    if (savedInstanceState == null) fragmentManager.beginTransaction.add(android.R.id.content, new StatusFragment).commit
  } 
} 

class StatusFragment extends Fragment
{
  val TAG = typeof(StatusFragment).getSimpleName
  
  var EditText mTextStatus 
  var TextView mTextCount 
  var Button   mButtonTweet 
  var int      mDefaultColor
    
  var update =    
  [ 
    val status = mTextStatus.text.toString
    val postTask = new PostTask(activity, TAG)
    postTask.execute(status)
    Log.d(TAG, "onClicked")
  ]  as OnClickListener
   
  var textChanged = 
  [ 
    Editable statusText |
    val count       = 140 - statusText.length
    mTextCount.text = Integer.toString(count)
    switch (count)
    {
      case count < 50 : mTextCount.textColor = Color.RED
      default         : mTextCount.textColor = mDefaultColor
    }
  ] as AfterTextChanged

  override onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
  {   
    val view      = inflater.inflate(R.layout.fragment_status, null, false)
   
    mTextStatus   = view.findViewById(R.id.status_text)         as EditText
    mTextCount    = view.findViewById(R.id.status_text_count)   as TextView
    mButtonTweet  = view.findViewById(R.id.status_button_tweet) as Button
    mDefaultColor = mTextCount.textColors.defaultColor
    
    mButtonTweet.onClickListener = update 
    mTextStatus.addTextChangedListener(new TextWatcherAdapter(textChanged))
    
    view
  }
}
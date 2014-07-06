package  org.wit.yamba.controllers

import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Paint.Style
import android.util.AttributeSet
import android.view.View

public class FreshnessView extends View
{
  static val LINE_HEIGHT = 30
  
  var long  timestamp = -1
  var Paint paint

  new(Context context, AttributeSet attrs)
  {
    super(context, attrs)

    paint = new Paint
    paint.setARGB(255, 0, 255, 0)
    paint.setStyle(Style.FILL_AND_STROKE)
    paint.setStrokeWidth(LINE_HEIGHT)

    setMinimumHeight(LINE_HEIGHT)
  }

  override onDraw(Canvas canvas)
  {
    super.onDraw(canvas)
    if (timestamp == -1)
      return
    val delta = System.currentTimeMillis() - timestamp
    val hours = delta / 3600000.0
    val multiplier = 1 - (Math.min(hours, 24) / 24.0)
    val width = (getWidth() * multiplier) as int
    canvas.drawLine(0, 0, width, 0, paint);
  }

  def setTimestamp(long timestamp)
  {
    this.timestamp = timestamp
    this.invalidate
  }
}
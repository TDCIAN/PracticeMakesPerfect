package com.example.part2chapter2

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.util.AttributeSet
import android.view.View


class WaveformView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
): View(context, attrs, defStyleAttr) {

    private var ampList = mutableListOf<Float>()
    private var rectList = mutableListOf<RectF>()

    val rectF = RectF(20f, 30f, 20f + 30f, 30f + 60f)
    val redPaint = Paint().apply {
        color = Color.RED
    }

    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)

        canvas?.drawRect(rectF, redPaint)
    }

    fun addAmplitude(maxAmplitude: Float) {

        ampList.add(maxAmplitude)
        rectList.clear()

        val rectWidth = 10f
        val maxRect = (this.width / rectWidth).toInt()

        val amps = ampList.takeLast(maxRect)

        for ((i, amp) in amps.withIndex()) {
            val rectF = RectF()
            rectF.top = 0f
            rectF.bottom = amp
            rectF.left = i * rectWidth
            rectF.right = rectF.left + rectWidth

            rectList.add(rectF)
        }

        invalidate()
    }
}
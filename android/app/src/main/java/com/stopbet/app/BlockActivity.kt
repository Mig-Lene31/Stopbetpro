package com.stopbet.app

import android.app.Activity
import android.os.Bundle
import android.os.CountDownTimer
import android.widget.TextView
import android.view.ViewGroup
import android.view.Gravity
import android.widget.LinearLayout
import android.widget.Button

class BlockActivity : Activity() {
  private var remainingMs: Long = 12 * 60 * 60 * 1000
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val prefs = getSharedPreferences("stopbet_prefs_v1", MODE_PRIVATE)
    val until = prefs.getLong("block_until", 0L)
    if (until > System.currentTimeMillis()) remainingMs = until - System.currentTimeMillis()
    val reason = intent.getStringExtra("blocked_reason") ?: prefs.getString("block_reason","Bloqueado")
    val layout = LinearLayout(this)
    layout.orientation = LinearLayout.VERTICAL; layout.gravity = Gravity.CENTER; layout.setPadding(40,40,40,40)
    val title = TextView(this); title.textSize = 22f; title.text = "Bloqueado"; layout.addView(title)
    val reasonView = TextView(this); reasonView.text = "Motivo: $reason"; reasonView.setPadding(0,20,0,20); layout.addView(reasonView)
    val timerView = TextView(this); timerView.textSize = 20f; layout.addView(timerView)
    val ok = Button(this); ok.text="Entendi"; ok.isEnabled=false; layout.addView(ok)
    setContentView(layout, ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
    object : CountDownTimer(remainingMs,1000){
      override fun onTick(m: Long){ val h=m/3600000; val min=(m/60000)%60; val s=(m/1000)%60; timerView.text=String.format("%02d:%02d:%02d",h,min,s) }
      override fun onFinish(){ timerView.text="Bloqueio finalizado"; ok.isEnabled=true; finish() }
    }.start()
  }
}

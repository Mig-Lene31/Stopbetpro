package com.stopbet.app

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log

import com.stopbet.app.BlockActivity

class BlockerAccessibilityService : AccessibilityService() {
  private val TAG = "BlockerAccessibility"
  private val handler = Handler(Looper.getMainLooper())

  override fun onServiceConnected(){
    val info = AccessibilityServiceInfo()
    info.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED
    info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
    info.packageNames = null
    info.flags = AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS or AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS
    serviceInfo = info
    Log.i(TAG,"Accessibility connected")
  }
  override fun onAccessibilityEvent(event: AccessibilityEvent?){
    // skeleton: JS engine (blockEngine) handles rules; native service just exposes accessibility capability
  }
  override fun onInterrupt(){}
}

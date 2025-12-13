package com.stopbet.app.androidnative

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityEvent
import android.content.Intent
import android.util.Log
import com.stopbet.app.BlockActivity

class BlockerAccessibilityService : AccessibilityService() {

    private val blockedApps = listOf(
        "com.bet365.bet365",
        "com.betfair.exchange",
        "com.betano.app",
        "com.blaze.app"
    )

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.packageName == null) return

        val pkg = event.packageName.toString()

        if (blockedApps.contains(pkg)) {
            Log.d("BLOCKER", "App bloqueado: $pkg")
            val intent = Intent(this, BlockActivity::class.java)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
    }

    override fun onInterrupt() {}
}

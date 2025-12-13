#!/usr/bin/env bash
set -e

mkdir -p android/app/src/main/java/com/stopbet/app/androidnative

cat > android/app/src/main/java/com/stopbet/app/BlockActivity.kt << 'END1'
package com.stopbet.app

import android.app.Activity
import android.os.Bundle
import android.view.WindowManager

class BlockActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        window.addFlags(
            WindowManager.LayoutParams.FLAG_FULLSCREEN or
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
        )
    }

    override fun onBackPressed() {
    }
}
END1

cat > android/app/src/main/java/com/stopbet/app/androidnative/BlockerAccessibilityService.kt << 'END2'
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
END2

echo "Arquivos criados com sucesso!"

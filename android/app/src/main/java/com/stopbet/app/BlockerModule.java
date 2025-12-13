package com.stopbet.app;

import android.content.Intent;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class BlockerModule extends ReactContextBaseJavaModule {
    private final ReactApplicationContext reactContext;

    public BlockerModule(ReactApplicationContext context) {
        super(context);
        this.reactContext = context;
    }

    @Override
    public String getName() {
        return "BlockerModule";
    }

    @ReactMethod
    public void activateBlock() {
        Intent intent = new Intent(reactContext, BlockActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        reactContext.startActivity(intent);
    }
}

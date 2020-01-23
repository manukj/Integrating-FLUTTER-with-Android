package com.example.flutterandroiddemo;

import android.annotation.SuppressLint;
import android.util.Log;

import androidx.core.content.ContextCompat;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "changeTheme";
    private static final String TAG = "MainActivity";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {

        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            result.success(fetchStyleColors());
                        }
                );
    }

    Map<String, String> fetchStyleColors() {
        Map<String, String> colors = new HashMap<>();
        colors.put("colorPrimaryDark", getColorStringFromId(R.color.colorPrimaryDark));
        colors.put("colorPrimary", getColorStringFromId(R.color.colorPrimary));
        colors.put("colorAccent",  getColorStringFromId(R.color.colorAccent));
        Log.e(TAG, "getColorStringFromId: "+ colors);
        Log.e(TAG, "fetchStyleColors: "+Integer.toHexString(ContextCompat.getColor(this, R.color.colorAccent) ));
        return colors;
    }

    String getColorStringFromId(int id) {
       String color = "#" + Integer.toHexString(ContextCompat.getColor(this,id));
        Log.e(TAG, "getColorStringFromId: "+ color);
        return color;
    }

}

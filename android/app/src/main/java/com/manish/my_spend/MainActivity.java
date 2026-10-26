package com.manish.my_spend;

import android.content.ComponentName;
import android.content.pm.PackageManager;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.manish.my_spend/app_icon";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("changeIcon")) {
                        String iconName = call.argument("iconName");
                        changeAppIcon(iconName);
                        result.success(true);
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }

    private void changeAppIcon(String iconName) {
        String packageName = getPackageName();
        PackageManager pm = getPackageManager();

        String defaultAlias = packageName + ".MainActivityDefault";
        String darkAlias = packageName + ".MainActivityDark";

        String targetEnable = defaultAlias;
        if ("dark".equalsIgnoreCase(iconName)) {
            targetEnable = darkAlias;
        }

        if (pm.getComponentEnabledSetting(new ComponentName(packageName, targetEnable)) == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
            return;
        }

        pm.setComponentEnabledSetting(
            new ComponentName(packageName, targetEnable),
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        );

        String targetDisable = targetEnable.equals(defaultAlias) ? darkAlias : defaultAlias;
        pm.setComponentEnabledSetting(
            new ComponentName(packageName, targetDisable),
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        );
    }
}

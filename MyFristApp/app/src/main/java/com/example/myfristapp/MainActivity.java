package com.example.myfristapp;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button safe = (Button)findViewById(R.id.safe);

        safe.setOnClickListener(new OnClickListener() {
            public void onClick(View arg) {
                Intent safeIntent =
                        new Intent(MainActivity.this, SafeActivity.class);
                startActivity(safeIntent);
            }
        });
        Button pace = (Button)findViewById(R.id.pace);

        pace.setOnClickListener(new OnClickListener() {
            public void onClick(View arg) {
                Intent paceIntent =
                        new Intent(MainActivity.this, PaceActivity.class);
                startActivity(paceIntent);
            }
        });
        Button scan = (Button)findViewById(R.id.scan);

        scan.setOnClickListener(new OnClickListener() {
            public void onClick(View arg) {
                Intent scanIntent =
                        new Intent(MainActivity.this, ScanActivity.class);
                startActivity(scanIntent);
            }
        });

        Button setting = (Button)findViewById(R.id.settings);

        setting.setOnClickListener(new OnClickListener() {
            public void onClick(View arg) {
                Intent settingIntent =
                        new Intent(MainActivity.this, SettingActivity.class);
                startActivity(settingIntent);
            }
        });
    }
}

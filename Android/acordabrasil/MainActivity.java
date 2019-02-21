package com.politeapp.acordabrasil;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.TimePicker;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;

import java.util.Calendar;
import java.util.Random;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    AlarmManager alarmManager;
    private PendingIntent pendingIntent;
    private TimePicker timePicker;
    private ImageButton setButton;
    private ImageButton unsetButton;
    private TextView alarmCfg;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        AdView adView = (AdView) findViewById(R.id.adView);
        AdRequest adRequest = new AdRequest.Builder().build();
        adView.loadAd(adRequest);

        // Controls
        timePicker = (TimePicker) findViewById(R.id.timePicker);
        setButton = (ImageButton) findViewById(R.id.setButton);
        setButton.setOnClickListener(this);
        unsetButton = (ImageButton) findViewById(R.id.unsetButton);
        unsetButton.setOnClickListener(this);
        alarmCfg = (TextView) findViewById(R.id.alarmCfg);

        // Alarm Manager
        alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);
    }

    @Override
    public void onClick(View v) {

        if (v == setButton) {
            Log.d("Button", "Set Button Pressed");
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.HOUR_OF_DAY, timePicker.getCurrentHour());
            cal.set(Calendar.MINUTE, timePicker.getCurrentMinute());
            Intent intent = new Intent(MainActivity.this, AlarmReceiver.class);

            // Clear previous alarms
            if (pendingIntent != null) {
                alarmManager.cancel(pendingIntent);
            }

            pendingIntent = PendingIntent.getBroadcast(MainActivity.this, 0, intent, 0);
            alarmManager.set(AlarmManager.RTC, cal.getTimeInMillis(), pendingIntent);
            // Set alarm cfg text with alarm time.
            StringBuilder builder = new StringBuilder();
            builder.append(timePicker.getCurrentHour());
            builder.append(":");
            builder.append(String.format("%02d",timePicker.getCurrentMinute()));
            alarmCfg.setText(builder.toString());


        } else if (v == unsetButton) {
            Log.d("Button", "Clear Button Pressed");
            alarmManager.cancel(pendingIntent);
            alarmCfg.setText(R.string.alarm_cfg_placeholder);
        }
    }
}

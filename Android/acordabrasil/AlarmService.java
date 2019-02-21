package com.politeapp.acordabrasil;

import android.app.IntentService;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.MediaPlayer;
import android.net.Uri;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import java.util.Random;

/**
 * Created by andre on 11/2/15.
 */
public class AlarmService extends IntentService {

    private NotificationManager notificationManager;
    private MediaPlayer mediaPlayer;

    public AlarmService() {
        super("Discurso da Presidenta!");
    }

    private MediaPlayer createMediaPlayerWithRandomAudio() {
        String[] sounds = { "dia_das_criancas",
                "essa_e_minha_vida_saudavel",
                "eu_to_saudando_a_mandioca",
                "mulher_sapiens",
                "nao_vamos_colocar_uma_meta",
                "o_meio_ambiente_e_uma_ameaca",
                "eu_sou_roraimada",
                "estoque_de_vento",
                "ta_chovendo_medicos"};
        String sound = (sounds[new Random().nextInt(sounds.length)]);
        Log.d("Media Player", sound);
        Uri uri = Uri.parse("android.resource://com.politeapp.acordabrasil/raw/" + sound);
        MediaPlayer mp = MediaPlayer.create(this, uri);

        // Release mediaPlayer on completion
        mp.setOnCompletionListener(
                new MediaPlayer.OnCompletionListener() {
                    @Override
                    public void onCompletion(MediaPlayer mp) {
                        Log.d("MediaPlayer", "OnCompletion received");
                        mp.release();
                    }
                }
        );

        return mp;
    }

    @Override
    protected void onHandleIntent(Intent intent) {

        sendNotification("Discurso da Presidenta!");
        // Plays audio.
        mediaPlayer = createMediaPlayerWithRandomAudio();
        mediaPlayer.start();
        // Release the wake lock.
        AlarmReceiver.completeWakefulIntent(intent);
    }

    private void sendNotification(String msg) {
        Log.d("Alarm Service", "Sending Notification");
        notificationManager = (NotificationManager)
                this.getSystemService(Context.NOTIFICATION_SERVICE);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0,
                new Intent(this, MainActivity.class), 0);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this)
                .setContentTitle("Discurso da Presidenta!")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setStyle(new NotificationCompat.BigTextStyle().bigText(msg))
                .setContentText(msg);
        builder.setContentIntent(pendingIntent);
        notificationManager.notify(1, builder.build());
    }
}

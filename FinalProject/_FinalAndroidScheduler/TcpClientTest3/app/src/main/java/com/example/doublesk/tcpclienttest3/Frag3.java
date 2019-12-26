package com.example.doublesk.tcpclienttest3;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

//weather fragment

public class Frag3 extends Fragment {
    public static Frag3 newInstance() {
        return new Frag3();
    }
    TcpThread tcp;
    Handler msgHandler;
    TextView popText,ptyText,skyText,t1hText,tmnText,tmxText;
    String ip = "13.125.131.249";
    String weatherMsg = "Android_weather";
    weatherParsing wp;

    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_frag3, container, false);

        popText = (TextView)v.findViewById(R.id.popText);
        ptyText = (TextView)v.findViewById(R.id.ptyText);
        skyText = (TextView)v.findViewById(R.id.skyText);
        t1hText = (TextView)v.findViewById(R.id.t1hText);
        tmnText = (TextView)v.findViewById(R.id.tmnText);
        tmxText = (TextView)v.findViewById(R.id.tmxText);



        msgHandler = new Handler() {

            public void handleMessage(Message msg) {

                if(msg.what == 2222) {
                    Log.d("Tag","weteeere   msg : "+msg.obj.toString());
                    wp = new weatherParsing(msg.obj.toString());
                    popText.setText("강수확률 : "+wp.pop);
                    ptyText.setText("강수형태 : "+wp.pty);
                    skyText.setText("하늘형태 : "+wp.sky);
                    t1hText.setText("현재온도 : "+wp.t1h);
                    tmnText.setText("최저온도 : "+wp.tmn);
                    tmxText.setText("최고온도 : "+wp.tmx);

                    try {
                        tcp.socket.close();
                        tcp.ThreadCheck();
                    }catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        };


        return v;
    }

    @Override
    public void onStart() {
        super.onStart();
        tcp = new TcpThread(ip,80, msgHandler);
        tcp.clientStart(weatherMsg);

    }
}
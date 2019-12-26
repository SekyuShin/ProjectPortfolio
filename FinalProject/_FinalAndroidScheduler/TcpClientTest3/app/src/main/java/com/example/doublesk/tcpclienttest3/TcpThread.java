package com.example.doublesk.tcpclienttest3;

import android.os.Handler;
import android.os.Message;
import android.util.Log;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;

public class TcpThread {
    private  String ip ;//= "192.168.219.100"; // IP
    private int port ;//= 3000; // PORT번호
    //private String ip = "13.125.131.249";
    //private int port = 80; //80
    Handler msgHandler; //android.os.handler
    SocketClient client;
    ReceiveThread receive;
    SendThread send;
    Socket socket;
    String msg;

    TcpThread(String ip, int port, Handler msgHandler) {
        this.ip = ip;
        this.port = port;
        this.msgHandler = msgHandler;
    }
    public void ThreadCheck() {
        //Log.d("Test","socket: " +socket.close())
        Log.d("Test","client : "+client.isAlive());
        Log.d("Test","send : "+send.isAlive());
        Log.d("Test","revieve : "+receive.isAlive());
    }

    public void clientStart(String msg) {
        //Log.d("Test","clientStart : "+msg);
        Log.d("Test","ip : "+ip+"  port : "+port);
        this.msg = msg;
        client = new SocketClient(ip,port,msg);
        client.start();

    }

    private class SocketClient extends Thread{
        boolean threadAlive;
        String ip;
        String str;
        int port;
        //DataOutputStream output = null;
        public SocketClient(String ip, int port,String str) {
            this.ip = ip;
            this.port = port;
            this.str = str;
            threadAlive = true;
        }

        @Override
        public void run() {
            super.run();
            try {
                socket = new Socket(ip,port);
                send = new SendThread(socket,str);
                send.start();
                Log.d("Test","TcpThread send.isAlive() : "+send.isAlive());
                receive = new ReceiveThread(socket);
                receive.start();
                Log.d("Test","TcpThread recieve.isAlive() : "+receive.isAlive());
                while(receive.isAlive()) ;
                Log.d("Test","TcpThread client end ");
                //ThreadCheck();
            }catch(Exception e) {
                e.printStackTrace();
            }
        }
    }

    private class ReceiveThread extends Thread{
        Socket socket = null;
        BufferedReader in;
        boolean isAlive ;
        public ReceiveThread(Socket socket) {
            this.socket = socket;
            isAlive = true;
            try {
                in= new BufferedReader(new InputStreamReader(this.socket.getInputStream()));
            } catch(Exception e) {
                e.printStackTrace();
            }

        }

        @Override
        public void run() {
            super.run();
            try {
                while(in!=null){
                    String msg = in.readLine();

                    if(msg != null) {
                        Message _msg =msgHandler.obtainMessage();
                        _msg.what = 2222;
                        _msg.obj = msg;
                        msgHandler.sendMessage(_msg);
                        Log.d("Test","TcpThread recieve msg "+msg);
                        break;
                    }
                }
            } catch(Exception e1) {
                e1.printStackTrace();
            }
        }
    }
    private class SendThread extends Thread{
        Socket socket;
        String sendmsg;


        PrintWriter out;
        public SendThread(Socket socket,String sendmsg) {
            this.socket = socket;
            this.sendmsg = sendmsg;
            try {
                out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(this.socket.getOutputStream())),
                        true);
            }catch(Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public void run() {
            super.run();
            try {
                Log.d("Test","TcpThread sendMsg : "+sendmsg);
                out.print(sendmsg);
                out.flush();
            }catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

}

package com.example.doublesk.tcpclienttest3;

import android.annotation.SuppressLint;
import android.app.TimePickerDialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import org.threeten.bp.LocalDate;
import org.threeten.bp.LocalDateTime;
import org.threeten.bp.format.DateTimeFormatter;

//update and delete fragment

public class Frag2 extends Fragment implements View.OnClickListener { //update, delete
    Context context;
    TextView textText,startText,endText;
    Button updateBtn,deleteBtn;
    MainActivity activity;
    TcpThread tcp;
    Handler msgHandler2;
    String pstart,pend,ptext;
    LocalDateTime ld;

    String ip = "13.125.131.249";
    public static Frag2 newInstance() {
        return new Frag2();
    }
    @SuppressLint("HandlerLeak")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_frag2, container, false);
        updateBtn = (Button) v.findViewById(R.id.updateBtn);
        deleteBtn = (Button) v.findViewById(R.id.deleteBtn);
        textText =  v.findViewById(R.id.textText);
        startText = v.findViewById(R.id.startText);
        endText = v.findViewById(R.id.endText);
        context = container.getContext();
        activity = (MainActivity)getActivity();


        Bundle extra = this.getArguments();
        Log.d("Test","frag2 onCreate");
        if(extra != null) {
            extra = getArguments();
            pstart= (String)extra.getString("start");
            pend= (String)extra.getString("end");
            ptext= (String)extra.getString("text");

            startText.setText(spacingFormat(pstart));
            endText.setText(spacingFormat(pend));
            textText.setText(ptext);

            ld = LocalDateTime.parse(pstart, DateTimeFormatter.ofPattern("yyyyMMddHHmm"));

            Log.d("Test","fra2 update and delete date : "+ptext+" "+pstart+" "+pend);
            Log.d("Test","fra2 LocalDate : "+ld);
        }

        msgHandler2 = new Handler() {
            public void handleMessage(Message msg) {
                //super.handleMessage(msg);
                if (msg.what == 2222) {
                    Toast.makeText(context,msg.obj.toString(),Toast.LENGTH_SHORT).show();
                   // Log.d("Test","Fra1 handler msg : "+msg.obj.toString());
                    //tcp.ThreadCheck();
                    try {
                        tcp.socket.close();
                        tcp.ThreadCheck();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        };

        updateBtn.setOnClickListener(this);
        deleteBtn.setOnClickListener(this);
        textText.setOnClickListener(this);
        endText.setOnClickListener(this);
        startText.setOnClickListener(this);
        return v;

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.updateBtn:
                String msg = "Android_update_";//we are free_201906190900_201906191400_we have exam_201906191300_201906191400";
                String startLdt = notSpacingFormat(startText.getText().toString());
                String endLdt = notSpacingFormat(endText.getText().toString());
                if(!checkCalendarDate(startLdt,endLdt)) {
                    Log.d("Test","error : "+startLdt+":"+endLdt+" "+checkCalendarDate(startLdt,endLdt));
                    Toast.makeText(getContext(),"The date format is invalid.",Toast.LENGTH_SHORT).show();
                    break;
                }
                if(textText.getText().toString() == "") {
                    Toast.makeText(getContext(),"The date format is invalid.",Toast.LENGTH_SHORT).show();
                    break ;
                }
                msg+=activity.dh.updateDate(ptext,pstart,pend,textText.getText().toString(),startLdt,endLdt);
                tcp = new TcpThread(ip, 80, msgHandler2);
                tcp.clientStart(msg);
                activity.setFrag(0);
                activity.setDialogListDate(LocalDate.from(ld));
                activity.Dialog();
                break;
            case R.id.deleteBtn:
                String msg2 = "Android_delete_";//we have exam_201906191300_201906191400";
                msg2+=activity.dh.deleteDate(ptext,pstart,pend);
                //Log.d("Test","delete Data : "+msg2);
                tcp = new TcpThread(ip, 80, msgHandler2);
                tcp.clientStart(msg2);
                //Log.d("Test","what");
                activity.setFrag(0);

                if(activity.dh.checkControlDate(LocalDate.from(ld)) >=1000) { //not null
                     activity.setDialogListDate(LocalDate.from(ld));
                     activity.Dialog();
                }
                break;
            case R.id.textText:
                TextDialogFragment e = new TextDialogFragment();
                e.setDialogListener(new TextDialogFragment.MyDialogListener() {
                    @Override
                    public void myCallback(String textString) {
                        //Log.d("Test","callback : "+textString);
                        textText.setText(textString);
                    }

                    @Override
                    public String myCall() {
                        return textText.getText().toString();
                    }
                });
                e.show(getActivity().getSupportFragmentManager(), TextDialogFragment.TAG_TEXT);
                break;
            case R.id.endText:
                startDialog(false,v);
                break;
            case R.id.startText:
                startDialog(true,v);
                break;
        }
    }

    void startDialog(final boolean checkStart,View v) {
        LocalDateTime ld2;
        if(checkStart) {
            ld2 = LocalDateTime.parse(startText.getText().toString(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        } else {
            ld2 = LocalDateTime.parse(endText.getText().toString(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        }
        TimePickerDialog dialog;
        TimePickerDialog.OnTimeSetListener listener = new TimePickerDialog.OnTimeSetListener() {
            @Override
            public void onTimeSet(TimePicker view, int hourOfDay, int min) {

                LocalDateTime ldt = LocalDateTime.of(ld.getYear(),ld.getMonth(),ld.getDayOfMonth(),hourOfDay,min);
                if(checkStart) {
                    startText.setText(ldt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
                }else {
                    endText.setText(ldt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
                }

            }
        };

        dialog = new TimePickerDialog(v.getContext(),android.R.style.Theme_Holo_Light_Dialog_MinWidth,listener,ld2.getHour(),ld2.getMinute(),false);

        dialog.show();
    }
    String notSpacingFormat(String ex) {
        ex=ex.replace('-', ' ');
        ex=ex.replace(':', ' ');
        ex = ex.replaceAll(" ", "");
        return ex;
    }
    String spacingFormat(String ex) {

        ex = ex.substring(0,4)+'-'+ex.substring(4,6)+'-'+ex.substring(6,8)+' '+ex.substring(8,10)+':'+ex.substring(10);
        return ex;
    }
    boolean checkCalendarDate(String str,String str2) {
        if(str.compareTo(str2)<0) {
            return true;
        }
        return false;
    }


}
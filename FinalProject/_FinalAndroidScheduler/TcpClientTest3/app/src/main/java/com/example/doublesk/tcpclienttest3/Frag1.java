package com.example.doublesk.tcpclienttest3;

import android.annotation.SuppressLint;
import android.app.TimePickerDialog;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import org.threeten.bp.LocalDate;
import org.threeten.bp.LocalDateTime;
import org.threeten.bp.LocalTime;
import org.threeten.bp.format.DateTimeFormatter;

//insert fragment

public class Frag1 extends Fragment implements View.OnClickListener {

    Context context;
    Button addBtn;
    TextView textText,startText,endText;
    TcpThread tcp;
    Handler msgHandler;
    LocalDate insertDate;
    MainActivity activity;
    LocalTime now;


    @SuppressLint("HandlerLeak")
    String ip = "13.125.131.249";
    public static Frag1 newInstance() {
        return new Frag1();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_frag1, container, false);
        addBtn = (Button)v.findViewById(R.id.addBtn);
        textText = v.findViewById(R.id.textText);
        startText = v.findViewById(R.id.startText);
        endText =  v.findViewById(R.id.endText);
        context = container.getContext();
        activity = (MainActivity)getActivity();


        Bundle extra = this.getArguments();
        //Log.d("Test","frag1 onCreateView" +extra);
        if(extra != null) {
            extra = getArguments();
            insertDate= (LocalDate)extra.getSerializable("dayList");
            //Log.d("Test","frag1 onCreateView insertDate : " +insertDate);
            now = LocalTime.now();
            LocalDateTime ldt = LocalDateTime.of(insertDate,now);
            LocalDateTime ldt2 = ldt.plusMinutes(30);
            startText.setText(ldt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
            endText.setText(ldt2.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));

        }

        msgHandler = new Handler() {

            public void handleMessage(Message msg) {
                if(msg.what == 2222) {
                   // Log.d("Tag","Fra1 handler msg : "+msg.obj.toString());
                    Toast.makeText(context,msg.obj.toString(),Toast.LENGTH_SHORT).show();
                    //tcp.ThreadCheck();
                    try {
                        tcp.socket.close();
                        tcp.ThreadCheck();
                    }catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        };





        addBtn.setOnClickListener(this);
        textText.setOnClickListener(this);
        endText.setOnClickListener(this);
        startText.setOnClickListener(this);
        // Inflate the layout for this fragment

        return v;
    }

    String notSpacingFormat(String ex) {
        ex=ex.replace('-', ' ');
        ex=ex.replace(':', ' ');
        ex = ex.replaceAll(" ", "");
        return ex;
    }

    @Override
    public void onClick(View v) {
        switch(v.getId()) {
            case R.id.addBtn:
                String msg="Android_insert_";//we are free_201906190900_201906191400";
                String startLdt = notSpacingFormat(startText.getText().toString());
                String endLdt = notSpacingFormat(endText.getText().toString());
                if(!checkCalendarDate(startLdt,endLdt)){
                    //Log.d("Test","error : "+startLdt+":"+endLdt+" "+checkCalendarDate(startLdt,endLdt));
                    Toast.makeText(getContext(),"The date format is invalid.",Toast.LENGTH_SHORT).show();
                    break ;
            }
                if(textText.getText().toString() == "") {
                    Toast.makeText(getContext(),"The date format is invalid.",Toast.LENGTH_SHORT).show();
                    break ;
                }
                //Log.d("Test","preData msg : "+textText.getText().toString()+startLdt+endLdt);
                msg+=activity.dh.insertDate(textText.getText().toString(),startLdt,endLdt); //
                //Log.d("Test","insertData msg : "+msg);
                tcp = new TcpThread(ip,80, msgHandler);
                tcp.clientStart(msg);

                activity.setFrag(0);
                activity.setDialogListDate(insertDate);
                activity.Dialog();
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
                        if(textText.getText().toString().equals("please input text")) {
                            textText.setTextColor(Color.parseColor("#000000"));
                            return "";
                        }
                        else return textText.getText().toString();
                    }
                });
                e.show(getActivity().getSupportFragmentManager(), TextDialogFragment.TAG_TEXT);
                break;
            case R.id.startText:
                startDialog(true,v);
                break;
            case R.id.endText:
                startDialog(false,v);
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

                LocalDateTime ldt = LocalDateTime.of(insertDate.getYear(),insertDate.getMonth(),insertDate.getDayOfMonth(),hourOfDay,min);
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

    boolean checkCalendarDate(String str,String str2) {
        if(str.compareTo(str2)<0) {
            return true;
        }
        return false;
    }


}

package com.example.doublesk.tcpclienttest3;


import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Toast;

import com.prolificinteractive.materialcalendarview.CalendarDay;
import com.prolificinteractive.materialcalendarview.MaterialCalendarView;
import com.prolificinteractive.materialcalendarview.OnDateSelectedListener;

import org.threeten.bp.LocalDate;
import org.threeten.bp.format.DateTimeFormatter;
import org.threeten.bp.temporal.TemporalAdjusters;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executors;

// calendar fragment

/**
 * A simple {@link Fragment} subclass.
 */
public class FragMain extends Fragment implements OnDateSelectedListener {
    //ParsingDates pd = new ParsingDates();
    TcpThread tcp;
    Handler msgHandler;
    Button refreshBtn;
    MainActivity activity;
    private Context context;
    String ip = "13.125.131.249";
    MaterialCalendarView materialCalendarView;
    CalendarDay curDay = CalendarDay.today();


    public static FragMain newInstance() {
        return new FragMain();
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)  {
        View v = inflater.inflate(R.layout.fragment_frag_main, container, false);
        //Log.d("Test","FraMain onCreateView");
        activity = (MainActivity)getActivity();
        materialCalendarView = v.findViewById(R.id.calendarView);
        materialCalendarView.addDecorators(
                new SundayDecorator(),
                new SaturdayDecorator()
        );
        materialCalendarView.setSelectedDate(curDay);
        materialCalendarView.setOnDateChangedListener(this);
        materialCalendarView.setPadding(0,-20,0,30);


        if(activity.dh.checkEmpty()) {
            LocalDate td = LocalDate.now();
            String str =  "Android_list_";
            str+=(td.minusMonths(1).with(TemporalAdjusters.firstDayOfMonth()).format(DateTimeFormatter.BASIC_ISO_DATE));
            str+='_';
            str+=(td.plusMonths(1).with(TemporalAdjusters.lastDayOfMonth()).format(DateTimeFormatter.BASIC_ISO_DATE));
            tcp = new TcpThread(ip,80, msgHandler);
            tcp.clientStart(str);
        } else {
            new ApiSimulator(activity.dh.getControlDate()).executeOnExecutor(Executors.newSingleThreadExecutor());
        }
        refreshBtn = (Button)v.findViewById(R.id.refreshBtn); //refresh btn



        refreshBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {  //refresh btn
                activity.dh.allClear();


                startActivity(new Intent(getContext(),MainActivity.class));
//                LocalDate td = LocalDate.now();
//                materialCalendarView.addDecorators(
//                        new SundayDecorator(),
//                        new SaturdayDecorator()
//                );
//                String str =  "Android_list_";
//                str+=(td.minusMonths(1).with(TemporalAdjusters.firstDayOfMonth()).format(DateTimeFormatter.BASIC_ISO_DATE));
//                str+='_';
//                str+=(td.plusMonths(1).with(TemporalAdjusters.lastDayOfMonth()).format(DateTimeFormatter.BASIC_ISO_DATE));
//                tcp = new TcpThread(ip,80, msgHandler);
//                tcp.clientStart(str);
        }
        });


        return v;
    }



    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //Log.d("Test","fra_main onCreate");
        //Log.d("Test","check empty"+activity.dh.checkEmpty());
        context = getContext();

        msgHandler = new Handler() {
            public void handleMessage(Message msg) {
                if(msg.what == 2222) {
                    //Log.d("Test","FraMain Handler msg : "+msg.obj.toString());
                    //activity.mList.clear();
                    //activity.mList.setGlobalList(msg.obj.toString());
                    activity.dh.allClear();

                    activity.dh.setDates(msg.obj.toString());
                    if(activity.dh.checkEmpty()) {
                        Log.d("Test","empty sleeping now"+activity.dh.checkEmpty());
                    }
                    new ApiSimulator(activity.dh.getControlDate()).executeOnExecutor(Executors.newSingleThreadExecutor());

                    //adapter = new ListViewAdapter(activity.mList.getGlobalList()) ;
                    //listView.setAdapter(adapter);
                    try {
                        tcp.socket.close();
                        tcp.ThreadCheck();
                    }catch (Exception e) {
                        e.printStackTrace();
                    }
                    Toast.makeText(getContext(),"request list",Toast.LENGTH_SHORT).show();
                }
            }
        };
    }
    public void onDateSelected(@NonNull MaterialCalendarView widget, @NonNull CalendarDay date, boolean selected) {
        boolean check = false;


        LocalDate td = date.getDate();//= .format(DateTimeFormatter.BASIC_ISO_DATE)
        Toast.makeText(context,""+td,Toast.LENGTH_SHORT).show();
       // Log.d("Test","onDateSelected : "+activity.dh.checkControlDate(td));

        if(activity.dh.checkControlDate(td) < 1000) { //blank
            Bundle bundle = new Bundle();
            bundle.putSerializable("dayList",td);
            activity.frag1.setArguments(bundle);
            activity.setFrag(1);
        }else {
            activity.setDialogListDate(td);
            activity.Dialog();
        }

    }
    private class ApiSimulator extends AsyncTask<Void, Void, List<CalendarDay>> {
        ArrayList<LocalDate> ldates ;
        ApiSimulator(ArrayList<LocalDate> ldates) {
            this.ldates = ldates;
        }

        @Override
        protected List<CalendarDay> doInBackground(@NonNull Void... voids) {
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            final ArrayList<CalendarDay> dates = new ArrayList<>();
            for(int i=0;i<ldates.size();i++) {
                CalendarDay day = CalendarDay.from(ldates.get(i));
                dates.add(day);
            }
            //temp = LocalDate.of(2019,10,4);


            return dates;
        }

        @Override
        protected void onPostExecute(@NonNull List<CalendarDay> calendarDays) {
            super.onPostExecute(calendarDays);

//            if (isFinishing()) {
//                return;
//            }

            materialCalendarView.addDecorator(new EventDecorator(Color.RED, calendarDays));
        }
    }

}


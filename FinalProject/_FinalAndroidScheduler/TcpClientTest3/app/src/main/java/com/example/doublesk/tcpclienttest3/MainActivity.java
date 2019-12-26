package com.example.doublesk.tcpclienttest3;

import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;

import org.threeten.bp.LocalDate;

public class MainActivity extends AppCompatActivity implements View.OnClickListener{

    Button btn0,btn3;
    FragmentManager fm;
    FragmentTransaction tran;
    Frag1 frag1;
    Frag2 frag2;
    Frag3 frag3;

    FragMain fragMain;
    DateHash dh = null;
    LocalDate dayList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
       // Log.d("Test","MainActivity onCreate ");

        setContentView(R.layout.activity_main);
        btn0 = (Button)findViewById(R.id.btn0);
        btn3 = (Button)findViewById(R.id.btn3);

        dh = (DateHash)getApplication();
       // Log.d("Test","dh.check : "+dh.checkEmpty()); //한번이라도 써야 오류 안남 ㅡㅡ
        btn0.setOnClickListener(this);
        btn3.setOnClickListener(this);



        //cv = (CalendarView)findViewById(R.id.cal_view);

        frag1 = new Frag1();
        frag2 = new Frag2();
        frag3 = new Frag3();

        fragMain = new FragMain();

        setFrag(0);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn0:
                setFrag(0);
                break;
            case R.id.btn3:
                setFrag(3);
                break;


        }
    }
    public void setFrag(int n) {
        fm = getSupportFragmentManager();
        tran = fm.beginTransaction();
        //Log.d("Test","n = "+n);
        switch(n) {
            case 0:
               // Log.d("Test","frag0 exe");
                tran.replace(R.id.main_fram,fragMain);
                tran.commit();
                break;
            case 1:
               // Log.d("Test","frag1 exe"); //insert
                tran.replace(R.id.main_fram,frag1);
                tran.commit();
                break;
            case 2:
               // Log.d("Test","frag2 exe"); //update, delete
                tran.replace(R.id.main_fram,frag2);
                tran.commit();
                break;
            case 3:
               // Log.d("Test","frag3 exe");
                tran.replace(R.id.main_fram,frag3);
                tran.commit();
                break;


        }
    }
    public void setDialogListDate(LocalDate ld) {
        dayList = ld;
    }
    public void Dialog(){
       // Log.d("Test","startDialog");
        AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
        LayoutInflater inflater = getLayoutInflater();
        View view = inflater.inflate(R.layout.dialog_list, null);
        builder.setView(view);

        final ListView listView = (ListView)view.findViewById(R.id.listView2);
        Button insertBtn = (Button)view.findViewById(R.id.d_insertBtn);



        final AlertDialog dialog;// = builder.create();
        final ListViewAdapter adapter;

        adapter = new ListViewAdapter(dh.getCalDate(dayList));
        listView.setAdapter(adapter);

        //Log.d("Test","list maked");


        dialog = builder.create();
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Bundle bundle = new Bundle();
                bundle.putString("start",dh.getCalDate(dayList).getStart(position));
                bundle.putString("end",dh.getCalDate(dayList).getEnd(position));
                bundle.putString("text",dh.getCalDate(dayList).getText(position));
                frag2.setArguments(bundle);
                setFrag(2);
                dialog.dismiss();
            }
        });
        dialog.setCancelable(true);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        dialog.show();
       // Log.d("Test","show dialog");
        insertBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Bundle bundle = new Bundle();
                bundle.putSerializable("dayList",dayList);
                frag1.setArguments(bundle);
                setFrag(1);
                dialog.dismiss();
            }
        });
    }

}

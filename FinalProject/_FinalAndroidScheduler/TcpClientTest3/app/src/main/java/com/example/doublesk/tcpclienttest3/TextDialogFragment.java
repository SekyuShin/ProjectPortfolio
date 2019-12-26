package com.example.doublesk.tcpclienttest3;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

public class TextDialogFragment extends DialogFragment implements View.OnClickListener {
    public static final String TAG_TEXT = "dialog_event";
    String textString;
    private MyDialogListener myListener;
    private Fragment fragment;
    EditText textET;
    public static TextDialogFragment getInstance() {
        TextDialogFragment e = new TextDialogFragment();
        return e;
    }
    public void setDialogListener(MyDialogListener dialogListener){
        this.myListener = dialogListener;
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        //Log.d("Test","Dialog onCreateView");
        View v = inflater.inflate(R.layout.text_dialog_fragment,container);
        textET = v.findViewById(R.id.dialogEditText);
        Button btn = v.findViewById(R.id.dialogBtn);
        fragment = getActivity().getSupportFragmentManager().findFragmentByTag(TAG_TEXT);
        textET.setText(myListener.myCall());
        btn.setOnClickListener(this);
        return v;
    }


    @Override
    public void onClick(View v) {
       // Toast.makeText(getContext(), "Test",Toast.LENGTH_SHORT).show();
        textString = textET.getText().toString();
        myListener.myCallback(textString);
        dismiss();
    }
    public interface MyDialogListener {
         void myCallback(String textString);
         String myCall();
    }

}

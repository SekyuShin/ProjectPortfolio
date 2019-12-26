package com.example.doublesk.tcpclienttest3;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

public class ListViewAdapter extends BaseAdapter {
    private ArrayList<ListViewItem> listViewItemList = new ArrayList<>();

    ListViewAdapter(Dates mArrayList) {

        for (int i = 0; i < mArrayList.getSize(); i++) {
            ListViewItem item = new ListViewItem();

            item.setText(mArrayList.getText(i));
            item.setStart( spacingFormat(mArrayList.getStart(i)));
            item.setEnd( spacingFormat(mArrayList.getEnd(i)));

            listViewItemList.add(item);
        }
    }

    @Override
    public int getCount() {
        return listViewItemList.size();
    }

    @Override
    public Object getItem(int position) {
        return listViewItemList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        final int pos = position;
        final Context context = parent.getContext();
        // "listview_item" Layout을 inflate하여 convertView 참조 획득.
        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.listview_item, parent, false);
        }
        // 화면에 표시될 View(Layout이 inflate된)으로부터 위젯에 대한 참조 획득
        TextView text = (TextView) convertView.findViewById(R.id.textView0);
        TextView start = (TextView) convertView.findViewById(R.id.textView1);
        TextView end = (TextView) convertView.findViewById(R.id.textView2);

        // Data Set(listViewItemList)에서 position에 위치한 데이터 참조 획득
        ListViewItem listViewItem = listViewItemList.get(position);

        // 아이템 내 각 위젯에 데이터 반영
        text.setText(listViewItem.getText());
        start.setText(listViewItem.getStart());
        end.setText(listViewItem.getEnd());

        return convertView;
    }

    public void addItem(String text, String start, String end) {
        ListViewItem item = new ListViewItem();

        item.setText(text);
        item.setStart(start);
        item.setEnd(end);

        listViewItemList.add(item);
    }
    String spacingFormat(String ex) {

        ex = ex.substring(0,4)+'-'+ex.substring(4,6)+'-'+ex.substring(6,8)+' '+ex.substring(8,10)+':'+ex.substring(10);
        return ex;
    }
}
package com.example.doublesk.tcpclienttest3;

public class ListViewItem {
    private String text ;
    private String start ;
    private String end ;


    public void setText(String title) {
        text = title ;
    }
    public void setStart(String desc) {
        start = desc ;
    }
    public void setEnd(String desc) {
        end = desc ;
    }


    public String getText() {
        return this.text ;
    }
    public String getStart() {
        return this.start ;
    }
    public String getEnd() {
        return this.end ;
    }
}

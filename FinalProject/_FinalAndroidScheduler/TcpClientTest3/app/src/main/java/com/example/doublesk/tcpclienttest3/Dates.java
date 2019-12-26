package com.example.doublesk.tcpclienttest3;

import java.util.ArrayList;
import java.util.Collections;


public class Dates {
	ArrayList<DatesElement> date = new ArrayList<>();


	void addCalDate(String start,String end, String text) {
		DatesElement de = new DatesElement();
		de.start = start;
		de.end = end;
		de.text = text;

		this.date.add(de);
		Collections.sort(date);
	}
	int getSize() {
		return date.size();
	}
	String getStart(int i) {
		return date.get(i).start;
	}
	String getEnd(int i) {
		return date.get(i).end;
	}
	String getText(int i) {
		return date.get(i).text;


	}
	void clear() {
		date.clear();
	}
	void delete(int i) {
		date.remove(i);
	}

}

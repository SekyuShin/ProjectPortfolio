package com.example.doublesk.tcpclienttest3;

public class DatesElement implements Comparable<DatesElement>{
	String start = new String();
	String end = new String();
	String text = new String();
	@Override
	public int compareTo(DatesElement de) {
		// TODO Auto-generated method stub
		return this.start.compareTo(de.start);
	}
}

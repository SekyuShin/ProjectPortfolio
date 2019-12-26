package com.example.doublesk.tcpclienttest3;

import android.app.Application;

import org.threeten.bp.LocalDate;

import java.util.ArrayList;
import java.util.HashMap;

public class DateHash extends Application {
	private String str;
	private int size = 0;

	private ArrayList<LocalDate> controlDate ;
	private HashMap<LocalDate,Dates> dates ;
	private ArrayList<Dates> calDate ;

    @Override
    public void onCreate() {
        super.onCreate();
       // Log.d("Test","datehash onCreate");
        controlDate = new ArrayList<>();
        dates = new HashMap<>();
        calDate = new ArrayList<>();

    }

    void setDates(String str) {
		this.str = str;

		allClear();
		makeDates();
	}
	
	void makeDates() {
		LocalDate pdate = LocalDate.of(1999,12,11);
		sizeControlDates();
		int cnt = 0;
		for (int i = 1; i < size; i+=3) {
			LocalDate date;
			String tempDate = str.split("_")[i];
			String END = str.split("_")[i+1];
			String TEXT = str.split("_")[i+2];
			int year,month,day;
			year = Integer.parseInt(tempDate.substring(0,4));
			month = Integer.parseInt(tempDate.substring(4,6));
			day = Integer.parseInt(tempDate.substring(6,8));
			
			date = LocalDate.of(year, month, day);
			if(!pdate.equals(date)) { //not equal
				pdate = date;
				Dates cd = new Dates();
				cd.addCalDate(tempDate,END,TEXT);
				calDate.add(cd);
				controlDate.add(date);
				cnt++;
				
			} else {
				calDate.get(cnt-1).addCalDate(tempDate,END,TEXT);
			}
			
        }
		for(int i=0;i<controlDate.size();i++) {
			dates.put(controlDate.get(i),calDate.get(i));
		}
		
	}
	
	

	void sizeControlDates()  {
		String s_size = str.split("_")[0];
		s_size = s_size.substring(1);
		size = Integer.parseInt(s_size);
		str = str.substring(s_size.length()+1);
		size*=3;
        
    }
	public ArrayList<LocalDate> getControlDate() {
		return controlDate;
	}
	public ArrayList<Dates> getCalDate() {
		return calDate;
	}
	
	HashMap<LocalDate,Dates> getDates() {
		return dates;
	}
	
	Dates getCalDate(LocalDate td) {
		return dates.get(td);
	}

	
	//get �κ�
	int getControlDateSize() {
		return controlDate.size();
	}
	int getCalDateSize(int i) {
		return calDate.get(i).getSize();
	}
	int getDateListSize(LocalDate td) {
		return dates.get(td).getSize();
	}
	
	Dates getDateList (LocalDate td) {
		return dates.get(td);
	}
	
	int checkControlDate(LocalDate td) {
		int cnt = 0;

		for (LocalDate i : controlDate) {
			if (i.isEqual(td)) {
				return cnt+1000;
			}
			else if(i.isBefore(td))
				cnt++;
		}
		return cnt;

	}
	
	//����Ʈ
	String insertDate(String text,String start,String end) {
		int year,month,day;
		int cnt=0;

		year = Integer.parseInt(start.substring(0,4));
		month = Integer.parseInt(start.substring(4,6));
		day = Integer.parseInt(start.substring(6,8));
		LocalDate td = LocalDate.of(year, month, day);

		cnt = checkControlDate(td);
		if(cnt>=1000) {
			dates.get(td).addCalDate(start, end, text);
		}else {
			Dates d = new Dates();
			d.addCalDate(start, end, text);
			calDate.add(cnt,d);
			controlDate.add(cnt,td);
			dates.put(controlDate.get(cnt), calDate.get(cnt));
		}

		return text+"_"+start+"_"+end;

	}
	String updateDate(String ptext,String pstart,String pend,String text,String start,String end) {
		int year,month,day;
		int size;
		year = Integer.parseInt(pstart.substring(0,4));
		month = Integer.parseInt(pstart.substring(4,6));
		day = Integer.parseInt(pstart.substring(6,8));
		LocalDate td = LocalDate.of(year, month, day);
		deleteDate(ptext,pstart,pend);
		insertDate(text,start,end);

		return ptext+"_"+pstart+"_"+pend+"_"+text+"_"+start+"_"+end;
	}
	void deleteKey(LocalDate td) {

		for(int cnt = 0;cnt<getControlDateSize();cnt++) {
			if(controlDate.get(cnt).isEqual(td)) {
				controlDate.remove(cnt);
				dates.remove(td);
			}
		}
	}
	String deleteDate(String text,String start,String end) {
		//isempty
		int year,month,day;
		int size;
		year = Integer.parseInt(start.substring(0,4));
		month = Integer.parseInt(start.substring(4,6));
		day = Integer.parseInt(start.substring(6,8));
		LocalDate td = LocalDate.of(year, month, day);

		if(dates.containsKey(td)) {
			//Log.d("Test","DateHash : ");
			//Log.d("Test",""+dates.get(td).getSize());
			size = dates.get(td).getSize();
		}else {
			return "error";
		}
		if(size == 1) {
			dates.get(td).clear(); //caldate remove
			deleteKey(td); //controlDate and dates remove
		}else if(size == 0){
			return "error";
		}else {
			for(int i=0;i<getDateListSize(td);i++) {
				if(dates.get(td).getStart(i).equals(start)) {
					if(dates.get(td).getEnd(i).equals(end)) {
						if(dates.get(td).getText(i).equals(text)) {
							dates.get(td).delete(i);
						}
					}
				}
			}
		}
        return text+"_"+start+"_"+end;
	}

	void allClear() {
		controlDate.clear();
		dates.clear();
		calDate.clear();
	}
//	void show() {
//		for(LocalDate d:getControlDate()) {
//			Dates td1 = getDateList(d);
//			 for(int j=0;j<getDateListSize(d);j++) {
//				 Log.d("Test",td1.getStart(j)+" "+td1.getEnd(j)+" "+td1.getText(j));
//			 }
//		}
//	}
	boolean checkEmpty() {
        return dates.isEmpty();
    }
	

}

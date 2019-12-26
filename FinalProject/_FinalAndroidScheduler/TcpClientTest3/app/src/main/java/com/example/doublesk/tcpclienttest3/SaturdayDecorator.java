package com.example.doublesk.tcpclienttest3;

import android.graphics.Color;
import android.text.style.ForegroundColorSpan;

import com.prolificinteractive.materialcalendarview.CalendarDay;
import com.prolificinteractive.materialcalendarview.DayViewDecorator;
import com.prolificinteractive.materialcalendarview.DayViewFacade;
import org.threeten.bp.DayOfWeek;

public class SaturdayDecorator implements DayViewDecorator {

    //private final Calendar calendar = Calendar.getInstance();

    public SaturdayDecorator() {
    }

    @Override
    public boolean shouldDecorate(CalendarDay day) {
        final DayOfWeek weekDay = day.getDate().getDayOfWeek();
        //day.copyTo(calendar);
        //int weekDay = calendar.get(Calendar.DAY_OF_WEEK);

        return weekDay == DayOfWeek.SATURDAY;
    }

    @Override
    public void decorate(DayViewFacade view) {
        view.addSpan(new ForegroundColorSpan(Color.BLUE));
    }
}
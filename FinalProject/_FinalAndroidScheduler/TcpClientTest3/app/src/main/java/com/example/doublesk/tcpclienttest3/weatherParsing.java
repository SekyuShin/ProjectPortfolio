package com.example.doublesk.tcpclienttest3;

class weatherParsing {

    String pop ="";
    String pty;
    String sky;
    String t1h;
    String tmn;
    String tmx;

    weatherParsing(String str1) {
        this.pop = str1.split("_")[1];
        this.tmx = str1.split("_")[2];
        this.tmn = str1.split("_")[3];
        this.pty = str1.split("_")[4];
        this.sky = str1.split("_")[5];
        this.t1h = str1.split("_")[6];
        //Log.d("Test","parsing result = "+pop+pty+sky+t1h+tmn+tmx);
    }
    boolean checkWeather() {
            return pop.isEmpty();

    }

}

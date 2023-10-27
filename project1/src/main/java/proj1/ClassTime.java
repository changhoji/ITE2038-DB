package proj1;

import java.util.ArrayList;

public class ClassTime {
    private String day;
    private int beginHour;
    private int beginMinute;
    private int endHour;
    private int endMinute;
    private boolean eLearning = false;

    public ClassTime() {

    }

    public ClassTime(String begin, String end) {
        if (begin.equals("NO") || end.equals("NO")) {
            eLearning = true;
            return;
        }
        ArrayList<String> days = new ArrayList<String>();
        days.add("월");
        days.add("화");
        days.add("수");
        days.add("목");
        days.add("금");
        days.add("토");
        days.add("일");

        day = days.get(begin.charAt(0)-'1');
        beginHour = Integer.parseInt(begin.substring(1, 3));
        beginMinute = Integer.parseInt(begin.substring(3, 5));
        endHour = Integer.parseInt(end.substring(1, 3));
        endMinute = Integer.parseInt(end.substring(3, 5));

        if (endToMin() > 18*60 || day.equals("토")) eLearning = true;
    }

    public String getDay() {
        return day;
    }

    public boolean iseLearning() { return eLearning; }

    public String toString() {
        return String.format("%s요일: %02d:%02d ~ %02d:%02d", day, beginHour, beginMinute, endHour, endMinute);
    }

    public int beginToMin() {
        return beginHour*60+beginMinute;
    }
    public int endToMin() {
        return endHour*60+endMinute;
    }
}

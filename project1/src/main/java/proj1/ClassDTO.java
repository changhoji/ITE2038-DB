package proj1;

import java.util.*;

public class ClassDTO {
    private int class_id;
    private int class_no;
    private String course_id;
    private int major_id;
    private String name;
    private int credit;
    private int year;
    private int lecturer_id;
    private String lecturer_name;
    private int person_max;
    private int opened;
    private int room_id;
    private int building_id;
    private String building_name;
    private ArrayList<ClassTime> times;
    private int enrolled;
    private boolean eLearning;
    private int occupancy;

    public int getOccupancy() {
        return occupancy;
    }

    public void setOccupancy(int occupancy) {
        this.occupancy = occupancy;
    }

    public int getClassId() { return class_id; }
    public int getClassNo() { return class_no; }
    public String getCourseId() { return course_id; }
    public int getMajorId() { return major_id; }
    public String getName() { return name; }
    public int getCredit() { return credit; }
    public int getYear() { return year; }
    public int getBuildingId() { return building_id; }
    public int getLecturerId() {
        return lecturer_id;
    }
    public String getLecturerName() { return lecturer_name; }
    public int getPersonMax() {
        return person_max;
    }
    public int getOpened() {
        return opened;
    }
    public int getRoomId() {
        return room_id;
    }
    public String getBuildingName() { return building_name; }
    public ArrayList<ClassTime> getTimes() {
        return times;
    }
    public int getEnrolled() { return enrolled; }

    public boolean iseLearning() {
        return eLearning;
    }

    public void seteLearning(boolean eLearning) {
        this.eLearning = eLearning;
    }

    public ClassDTO() {}
    public ClassDTO(int class_id, int class_no, String course_id, int major_id, String name, int credit, int year, int lecturer_id, String lecturer_name, int person_max, int opened, int room_id, int building_id, String building_name, ArrayList<ClassTime> times, int enrolled, boolean eLearning, int occupancy) {
        this.class_id = class_id;
        this.class_no = class_no;
        this.course_id = course_id;
        this.major_id = major_id;
        this.name = name;
        this.credit = credit;
        this.year = year;
        this.lecturer_id = lecturer_id;
        this.lecturer_name = lecturer_name;
        this.person_max = person_max;
        this.opened = opened;
        this.room_id = room_id;
        this.building_id = building_id;
        this.building_name = building_name;
        this.times = times;
        this.enrolled = enrolled;
        this.eLearning = eLearning;
        this.occupancy = occupancy;
    }

}

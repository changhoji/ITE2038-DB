package proj1;

public class StudentDTO {
    private int student_id;
    private String name;
    private String sex;
    private int major_id;
    private int lecturer_id;
    private int year;
    private int user_id;
    private int creditSum;
    private String lecturerName;
    private String majorName;
    private String state;

    public String getState() {
        return state;
    }

    public StudentDTO() {}

    public StudentDTO(int _student_id, String _name, String _sex, int _major_id, int _lecturer_id, int _year, int _user_id, int creditSum, String lecturerName, String majorName, String state) {
        student_id = _student_id;
        name = _name;
        sex = _sex;
        major_id = _major_id;
        lecturer_id = _lecturer_id;
        year = _year;
        user_id = _user_id;
        this.creditSum = creditSum;
        this.lecturerName = lecturerName;
        this.majorName = majorName;
        this.state = state;
    }

    public int getStudentId() { return student_id; }
    public String getName() { return name; }
    public String getSex() { return sex; }
    public int getMajorId() { return major_id; }
    public int getLecturer_id() { return lecturer_id; }
    public int getYear() { return year; }
    public int getUserId() { return user_id; }
    public int getCreditSum() { return creditSum; }
    public String getLecturerName() { return lecturerName; }
    public String getMajorName() { return majorName; }


}

package proj1;

public class CreditsDTO {
    private String courseId;
    private String courseName;
    private int year;
    private String grade;
    private int credit;

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public int getCredit() {
        return credit;
    }

    public void setCredit(int credit) {
        this.credit = credit;
    }

    public CreditsDTO(String courseId, String courseName, int year, String grade, int credit) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.year = year;
        this.grade = grade;
        this.credit = credit;
    }
}

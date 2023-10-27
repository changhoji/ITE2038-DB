package proj1;

public class CourseDTO {
    private String courseId;
    private String courseName;
    private int credit;
    private double diff;

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

    public int getCredit() {
        return credit;
    }

    public void setCredit(int credit) {
        this.credit = credit;
    }

    public double getDiff() {
        return diff;
    }

    public void setDiff(int diff) {
        this.diff = diff;
    }

    public CourseDTO(String courseId, String courseName, int credit, double diff) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.credit = credit;
        this.diff = diff;
    }
}

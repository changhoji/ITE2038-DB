package proj1;

import java.util.ArrayList;

public class Attribute {
    private String state;
    private String oldState;
    private StudentDTO student;
    private int userId;
    private String searchType;
    private String searchValue;
    private String searchYear;
    private boolean isAdmin;
    private ArrayList<ClassDTO> classes;
    private String message;
    private String msgType;
    private int classId;

    public int getClassId() {
        return classId;
    }

    public void setClassId(int classId) {
        this.classId = classId;
    }

    public String getMsgType() {
        return msgType;
    }

    public void setMsgType(String msgType) {
        this.msgType = msgType;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getOldState() {
        return oldState;
    }

    public void setOldState(String oldState) {
        this.oldState = oldState;
    }

    public ArrayList<ClassDTO> getClasses() {
        return classes;
    }

    public void setClasses(ArrayList<ClassDTO> classes) {
        this.classes = classes;
    }

    public boolean getIsAdmin() {
        return isAdmin;
    }

    public void setIsAdmin(boolean admin) {
        isAdmin = admin;
    }

    public Attribute() {}

    public String getSearchType() {
        return searchType;
    }

    public void setSearchType(String searchType) {
        this.searchType = searchType;
    }

    public String getSearchValue() {
        return searchValue;
    }

    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    public String getSearchYear() {
        return searchYear;
    }

    public void setSearchYear(String searchYear) {
        this.searchYear = searchYear;
    }

    public String getState() {
        return state;
    }
    public StudentDTO getStudent() {
        return student;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setState(String state) {
        this.state = state;
    }
    public void setStudent(StudentDTO student) {
        this.student = student;
    }

}

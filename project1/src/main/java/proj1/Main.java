package proj1;

public class Main {
    final private DAO dao = new DAO();
    public Main() {}
    
    //검색 조건으로 찾기
    public void searchClass(Attribute attb) {
        String where = "";
        if (!attb.getSearchValue().equals("")) { //검색 값이 존재하면 그 값으로 검색
            if (attb.getSearchType().equals("class.name")) { //과목이름일때만 like 검색
                where = "WHERE class.name LIKE "+"'%"+attb.getSearchValue()+"%'";
            }
            else {
                where = "WHERE " + attb.getSearchType() + "='"+attb.getSearchValue()+"'";
            }
        }
        if (!attb.getSearchYear().equals("전체")) { //년도에 대해 검색, 전체가 아닐때만 where문을 추가하고 전체일 때는 안써도 됨
            where = where + " AND opened="+Integer.parseInt(attb.getSearchYear());
        }

        attb.setClasses(dao.getClasses(where));
    }
    
    //모든 수업 찾기
    public void searchAll(Attribute attb) {
        attb.setClasses(dao.getClasses(""));
    }
    
    //지정과목 찾기
    public void searchMy(Attribute attb) {
        String where = "WHERE opened=2022 AND class.year="+attb.getStudent().getYear()+" AND class.major_id="+attb.getStudent().getMajorId();
        attb.setClasses(dao.getClasses(where));
    }
    
    //희망수업 찾기
    public void searchWish(Attribute attb) {
        String where = "WHERE class_id IN ("+
                "SELECT class_id " +
                "FROM wish " +
                "WHERE student_id="+attb.getStudent().getStudentId()+")";

        attb.setClasses(dao.getClasses(where));
    }

    //신청수업 찾기
    public void searchEnroll(Attribute attb) {
        String where = "WHERE class_id IN ("+
                "SELECT class_id " +
                "FROM enroll " +
                "WHERE student_id="+attb.getStudent().getStudentId()+")";

        attb.setClasses(dao.getClasses(where));
    }

    //올해 (2022년) 수업 찾기
    public void searchNow(Attribute attb) {
        String where = "WHERE opened=2022";
        attb.setClasses(dao.getClasses(where));
    }
}

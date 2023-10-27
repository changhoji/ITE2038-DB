package proj1;

import java.util.*;
import java.sql.*;

public class DAO {
    private String dbUrl = "jdbc:mysql://localhost:3307/db2021035487?serverTimezone=Asia/Seoul";
    private String dbId = "root";
    private String dbPassword = "240785";

    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public DAO() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //로그인 진행
    public int doLogin(String id, String pw) {
        String sql = "SELECT * FROM user";
        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                if (id.equals(rs.getString("username")) && pw.equals(rs.getString("password"))) {
                    return rs.getInt("user_id");
                }
            }

            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    //user_id로 학생 정보를 반환
    public StudentDTO getStudent(int user_id) {
        String sql = "SELECT * FROM student join lecturer join major on student.lecturer_id=lecturer.lecturer_id and student.major_id=major.major_id WHERE user_id="+user_id;
        StudentDTO res = new StudentDTO();

        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (rs.next()) {}
            int id = rs.getInt("student_id");
            String name = rs.getString("name");
            String sex = rs.getString("sex");
            int major = rs.getInt("major_id");
            int lecturer = rs.getInt("lecturer_id");
            String lecturerName = rs.getString("lecturer.name");
            int year = rs.getInt("year");
            int user = rs.getInt("user_id");
            String majorName = rs.getString("major.name");
            String state = rs.getString("state");

            int creditSum = 0;

            ArrayList<ClassDTO> enrolled = getClasses("WHERE class_id IN (SELECT class_id FROM enroll WHERE student_id="+id+")");

            int sumCredit = 0;
            for (ClassDTO c: enrolled) {
                sumCredit += c.getCredit();
            }

            res = new StudentDTO(id, name, sex, major, lecturer, year, user, sumCredit, lecturerName, majorName, state);

            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    //user_id로 admin 계정으로 로그인했는지 확인
    public boolean justifyIsAdmin(int user_id) {
        String sql = "SELECT COUNT(*) AS cnt FROM admin WHERE user_id="+user_id;
        boolean res = false;

        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                if (rs.getInt("cnt") == 1) {
                    res = true;
                }
            }

            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return res;
    }

    //main.jsp에서 보여줄 class들을 arraylist에 담아 반환
    public ArrayList<ClassDTO> getClasses(String where) {
        ArrayList<ClassDTO> classes = new ArrayList<>();
        String sql = "SELECT * FROM class JOIN lecturer JOIN room JOIN building"+
                " ON class.lecturer_id=lecturer.lecturer_id AND class.room_id=room.room_id AND room.building_id=building.building_id";
            sql += " "+where;

        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ClassDTO obj = new ClassDTO();

                int class_id = rs.getInt("class_id");
                int class_no = rs.getInt("class_no");
                String course_id = rs.getString("course_id");
                int major_id = rs.getInt("major_id");
                String name = rs.getString("class.name");
                int credit = rs.getInt("credit");
                int year = rs.getInt("year");
                int lecturer_id = rs.getInt("lecturer_id");
                String lecturer_name = rs.getString("lecturer.name");
                int person_max = rs.getInt("person_max");
                int opened = rs.getInt("opened");
                int room_id = rs.getInt("room_id");
                int building_id = rs.getInt("building_id");
                String building_name = rs.getString("building.name");
                int occupancy = rs.getInt("occupancy");

                ArrayList<ClassTime> times = new ArrayList<ClassTime>();
                boolean eLearning = false;

                pstmt = conn.prepareStatement("SELECT * FROM time WHERE class_id="+class_id);
                ResultSet rsTimes = pstmt.executeQuery();

                while (rsTimes.next()) { //수업에 해당하는 시간들 추가
                    String begin = rsTimes.getString("begin");
                    String end = rsTimes.getString("end");

                    ClassTime t = new ClassTime(begin, end);
                    if (t.iseLearning()) eLearning = true; //시간중 하나라도 elaerning이면
                    times.add(t);
                }

                pstmt = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM enroll WHERE class_id="+class_id);
                ResultSet rsEnroll = pstmt.executeQuery();

                int enrolled = 0;
                while (rsEnroll.next()) {
                    enrolled = rsEnroll.getInt("cnt");
                }


                if(rsTimes != null) rsTimes.close();
                if (rsEnroll != null) rsEnroll.close();

                obj = new ClassDTO(class_id, class_no, course_id, major_id, name, credit, year, lecturer_id, lecturer_name, person_max, opened, room_id, building_id, building_name, times, enrolled, eLearning, occupancy);

                classes.add(obj);
            }

            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return classes;
    }
    
    // 수강편람 페이지에서 희망추가 값에 들어가는 html 코드를 반환
    public String wishString(Attribute attb, ClassDTO c, String beforeState) {
        String result = "";
        String sql = "SELECT COUNT(*) AS cnt FROM wish WHERE student_id="+attb.getStudent().getStudentId()+" AND class_id="+c.getClassId();

        if (c.getOpened() != 2022) return "";

        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            boolean exist = false;
            if (rs.next()) {
                if (rs.getInt("cnt") == 0) { //희망신청 안한 수업
                    result = "<form action='form.jsp' method='post'>" +
                                "<input type='text' name='before-page' value='main' class='hidden'>"+
                                "<input type='text' name='before-state' value='"+beforeState+"' class='hidden'>" +
                                "<input type='text' name='state' value='addWish' class='hidden'>" +
                                "<input type='text' name='class-id' value='"+c.getClassId()+"' class='hidden'>" +
                                "<input type='text' name='user-id' value='"+attb.getUserId()+"' class='hidden'>" +
                                "<input type='submit' value='추가'>" +
                             "</form>";
                }
                else { //희망신청 한 수업은 취소버튼 출력
                    result = "<form action='form.jsp' method='post'>" +
                            "<input type='text' name='before-page' value='main' class='hidden'>"+
                            "<input type='text' name='before-state' value='"+beforeState+"' class='hidden'>" +
                            "<input type='text' name='state' value='delWish' class='hidden'>" +
                            "<input type='text' name='class-id' value='"+c.getClassId()+"' class='hidden'>" +
                            "<input type='text' name='user-id' value='"+attb.getUserId()+"' class='hidden'>" +
                            "<input type='submit' value='삭제'>" +
                            "</form>";
                }
            }
            if (conn != null) conn.close();
            if (pstmt != null) pstmt.close();
            if (rs != null) rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    // 수강편람 페이지에서 수강신청 값에 들어가는 html 코드를 반환
    public String enrollString(Attribute attb, ClassDTO c, String oldState) {
        String result = "";
        String sql = "SELECT COUNT(*) AS cnt FROM enroll WHERE student_id="+attb.getStudent().getStudentId()+" AND class_id="+c.getClassId();

        if (c.getOpened() != 2022) return "";

        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery(); //해당 신청이 존재하는지 구함

            sql = "SELECT * FROM credits WHERE student_id="+attb.getStudent().getStudentId()+" AND course_id="+"'"+c.getCourseId()+"'";
            pstmt = conn.prepareStatement(sql);
            ResultSet rsGrade = pstmt.executeQuery();
            double beforeGrade = -1;
            if (rsGrade.next()) {
                beforeGrade = getGradeValue(rsGrade.getString("grade"));
            }

            boolean exist = false;
            if (rs.next()) {
                if (rs.getInt("cnt") == 0 && beforeGrade <= 2.5) { //수강 안했거나 C+ 이하만 수강신청 가능
                    result = "<form action='form.jsp' method='post'>" +
                            "<input type='text' name='before-page' value='main' class='hidden'>"+
                            "<input type='text' name='before-state' value='"+oldState+"' class='hidden'>" +
                            "<input type='text' name='state' value='addEnroll' class='hidden'>" +
                            "<input type='text' name='class-id' value='"+c.getClassId()+"' class='hidden'>" +
                            "<input type='text' name='user-id' value='"+attb.getUserId()+"' class='hidden'>";
                    if (beforeGrade >= 0) result += "<input type='submit' value='신청(재수강)'>";
                    else result += "<input type='submit' value='신청'>";

                    result += "</form>";
                }
                else if (rs.getInt("cnt") == 1) {
                    result = "<form action='form.jsp' method='post'>" +
                            "<input type='text' name='before-page' value='main' class='hidden'>"+
                            "<input type='text' name='before-state' value='"+oldState+"' class='hidden'>" +
                            "<input type='text' name='state' value='delEnroll' class='hidden'>" +
                            "<input type='text' name='class-id' value='"+c.getClassId()+"' class='hidden'>" +
                            "<input type='text' name='user-id' value='"+attb.getUserId()+"' class='hidden'>" +
                            "<input type='submit' value='취소'>";
                }
            }
            if (conn != null) conn.close();
            if (pstmt != null) pstmt.close();
            if (rs != null) rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    //문자열로 된 성적을 double로 반환
    public double getGradeValue(String grade) {
        if (grade.equals("A+")) return 4.5;
        else if (grade.equals("A0")) return 4.0;
        else if (grade.equals("B+")) return 3.5;
        else if (grade.equals("B0")) return 3.0;
        else if (grade.equals("C+")) return 2.5;
        else if (grade.equals("C0")) return 2.0;
        else if (grade.equals("D+")) return 1.5;
        else if (grade.equals("D0")) return 1.0;
        else if (grade.equals("F")) return 0;

        return 0;
    }

    //희망수업에 추가
    public void addWish(int sId, int cId) {
        String sql = "INSERT INTO wish VALUES ("+sId+", "+cId+")";
        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            if (conn != null) conn.close();
            if (pstmt != null) pstmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //희망수업에서 제거
    public void delWish(int sId, int cId) {
        String sql = "DELETE FROM wish WHERE student_id="+sId+" AND class_id="+cId;
        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            if (conn != null) conn.close();
            if (pstmt != null) pstmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //수강신청
    public int addEnroll(int sId, int cId, boolean isAdmin) {
        String sql = "";
        ClassDTO theClass = getClasses("WHERE class_id="+cId).get(0); //신청하고자 하는 수업
        ArrayList<ClassDTO> enrolled = getClasses("WHERE class_id IN (SELECT class_id FROM enroll WHERE student_id="+sId+")");

        int sumCredit = 0;
        for (ClassDTO c: enrolled) {
            sumCredit += c.getCredit();
        }
        if (sumCredit+theClass.getCredit() > 18)
            return 1; //학점 초과 오류
        if (theClass.getPersonMax() <= theClass.getEnrolled() && !isAdmin) //admin이면 수강정원과 관계없이 가능
            return 2; //수강정원 초과 오류
        if (theClass.getEnrolled() >= theClass.getOccupancy() && isAdmin) //admin으로 왔을 때 수강정원과는 상관없지만 강의실 정원보다 많아지면 신청 불가능
            return 5;

        if (!theClass.iseLearning()) { //수강신청하는 수업이 E-러닝 강의가 아니라면 겹치는지 확인해야함
            for (ClassDTO c : enrolled) { //theClass: 추가하려는 수업, c: 겹치는지 확인할 for문안의 수업
                if (c.iseLearning()) continue; //E-러닝 강좌면 겹치는일 없음
                for (ClassTime t : c.getTimes()) {
                    for (ClassTime theTime: theClass.getTimes()) { //theTime: 이 과목의 시간, t: 확인할 시간
                        if (!t.getDay().equals(theTime.getDay())) continue; //요일이 다르면 볼필요 없음
                        if (theTime.endToMin() > t.beginToMin() || t.endToMin() > theTime.beginToMin()) return 3; //시간 겹침 오류
                    }
                }
            }
        }
        
        try { //db에 추가하는 과정
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);

            if (isAdmin) { //admin이면 room의 정원을 초과하는지 봐야함
                sql = "SELECT * FROM room WHERE room_id="+theClass.getRoomId();
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                rs.next();
                if (rs.getInt("occupancy") <= theClass.getEnrolled()) return 4; //추가했을때 room의 정원을 초과한다면 불가능
            }

            pstmt = conn.prepareStatement("INSERT INTO enroll VALUES ("+sId+", "+cId+")");
            pstmt.executeUpdate();

            if (pstmt != null) pstmt.close();
            if (rs != null) rs.close();
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
        return 0; //정상 신청
    }

    //수강신청 취소
    public void delEnroll(int sId, int cId) {
        String sql = "DELETE FROM enroll WHERE student_id="+sId+" AND class_id="+cId;
        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            if (conn != null) conn.close();
            if (pstmt != null) pstmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //학생 로그인 id변경
    public int changeId(int uId, int sId, String newId) {
        if (newId.isEmpty()) return 1; //is empty
        else if (newId.length() > 15) return 2; //too long

        String sql = "";
        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);

            sql = "SELECT username FROM user WHERE user_id="+uId;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            rs.next();
            if (rs.getString("username").equals(newId)) return 3; //same id before and after

            sql = "SELECT * FROM user WHERE username='"+newId+"'";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) return 4; //already exist this username

            sql = "SELECT * FROM student WHERE student_id='"+newId+"' AND student_id!="+sId;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) return 5; //다른 학생의 학번으로 id지정 불가

            sql = "UPDATE user SET username='"+newId+"' WHERE user_id="+uId;
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }

        return 0;
    }

    //학생 로그인 비밀번호 변경
    public int changePw(int uId, String newPw) {
        if (newPw.isEmpty()) return 1; //is empty
        else if (newPw.length() > 15) return 2; //too long

        String sql = "";
        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);

            sql = "SELECT password FROM user WHERE user_id="+uId;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            rs.next();
            if (rs.getString("password").equals(newPw)) return 3; //same id before and after

            sql = "UPDATE user SET password='"+newPw+"' WHERE user_id="+uId;
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }

        return 0;
    }

    //해당 시간에 sId의 학생이 신청한 수업 중 시간표에 해당하는 수업 이름을 반환
    public String showTable(int sId, int row, String col) {
        int temp = 8*60+row*30;
        ArrayList<ClassDTO> enrolled = getClasses("WHERE class_id IN (SELECT class_id FROM enroll WHERE student_id="+sId+")");
        for (ClassDTO c: enrolled) {
            if (c.iseLearning()) {
                continue;
            }
            for (ClassTime t: c.getTimes()) {
                if (!t.getDay().equals(col)) continue;
                if (t.beginToMin() <= temp && temp < t.endToMin())
                    return c.getName();
            }
        }
        return "";
    }

    //폐강 기능
    public void delClass(int cId) {
        String sql = "";

        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);

            sql = "DELETE FROM enroll WHERE class_id="+cId;
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            sql = "DELETE FROM wish WHERE class_id="+cId;
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            sql = "DELETE FROM time WHERE class_id="+cId;
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            sql = "DELETE FROM class WHERE class_id="+cId;
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //수강정원 변경 기능
    public int changePersonMax(int cId, int newMax) {
        String sql = "";
        ClassDTO c = getClasses("WHERE class_id="+cId).get(0); //변경할 수업

        if (newMax <= 0) return 1; //newMax는 1 이상의 정수여야 함
        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);

            sql = "SELECT * FROM room WHERE room_id="+c.getRoomId();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            rs.next();
            if (rs.getInt("occupancy") < newMax && !c.iseLearning()) return 2; //room의 정원이 newMax를 초과하고 e러닝이 아니면 불가능


            sql = "SELECT COUNT(*) AS cnt FROM enroll WHERE class_id="+cId;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            rs.next();
            if (rs.getInt("cnt") > newMax) return 3; //현재 수강신청한 인원보다는 많아야 함

            //예외상황이 아니면 정상처리
            sql = "UPDATE class SET person_max="+newMax+" WHERE class_id="+cId;
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //admin으로 studentInfo.jsp에 접근했을때 입력한 학생 학번으로 정보를 볼 학생을 구함
    public int searchStudent(Attribute attb, int sId) {
        String sql;
        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);

            sql = "SELECT * FROM student WHERE student_id="+sId;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                return 1; //그런 학생 없음.
            }
            attb.setStudent(getStudent(rs.getInt("user_id")));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //학생의 상태 변경
    public void changeState(Attribute attb, String newState) {
        attb.setState("general");
        String sql = "";

        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);

            sql = String.format("UPDATE student SET state='%s' WHERE student_id=%d", newState, attb.getStudent().getStudentId());
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        searchStudent(attb, attb.getStudent().getStudentId());
    }

    //admin으로 학생의 정보를 볼 때 표시할 성적들을 구함
    public ArrayList<CreditsDTO> getCredits(int sId) {
        ArrayList<CreditsDTO> credits = new ArrayList<>();
        String sql = "";

        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);

            sql = String.format("SELECT * FROM credits NATURAL JOIN course WHERE student_id=%d ORDER BY year DESC", sId);
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String courseId = rs.getString("course_id");
                String courseName = rs.getString("name");
                int year = rs.getInt("year");
                String grade = rs.getString("grade");
                int credit = rs.getInt("credit");

                CreditsDTO cd = new CreditsDTO(courseId, courseName, year, grade, credit);
                credits.add(cd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return credits;
    }

    //olap 통계기능으로 10개의 과목을 구함
    public ArrayList<CourseDTO> getStatistic() {
        ArrayList<CourseDTO> courses = new ArrayList<>();
        String sql = "";

        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);

            sql = "WITH credits_ AS ( -- credits_: 문자열로 된 과목 점수를 실수로 바꾼 table\n" +
                    "        SELECT\n" +
                    "            student_id,\n" +
                    "            course_id,\n" +
                    "            credit, (\n" +
                    "                CASE\n" +
                    "                    WHEN grade = 'A+' then 4.5\n" +
                    "                    WHEN grade = 'A0' then 4.0\n" +
                    "                    WHEN grade = 'B+' then 3.5\n" +
                    "                    WHEN grade = 'B0' then 3.0\n" +
                    "                    WHEN grade = 'C+' then 2.5\n" +
                    "                    WHEN grade = 'C0' then 2.0\n" +
                    "                    WHEN grade = 'D+' then 1.5\n" +
                    "                    WHEN grade = 'D0' then 1.0\n" +
                    "                    ELSE 0\n" +
                    "                END\n" +
                    "            ) AS grade\n" +
                    "        FROM\n" +
                    "            credits\n" +
                    "    ),\n" +
                    "    studentAvg AS ( -- studentAvg: 각각의 학생의 성적 평균을 구한 table\n" +
                    "        SELECT\n" +
                    "            student_id,\n" +
                    "            sum(grade * credit) / sum(credit) AS average_grade -- 그 학생의 평균 성적 (학점*점수의 합 / 학점의 합)\n" +
                    "        FROM credits_\n" +
                    "        GROUP BY student_id\n" +
                    "    ),\n" +
                    "    creditsDiff AS ( -- creditsDiff: 각각 성적에 대해 그 학생의 평균과의 편차를 구한 table\n" +
                    "        SELECT course_id, credit, average_grade - grade AS diff_grade -- 성적의 편차 (그 학생에 대한)\n" +
                    "        FROM credits_ JOIN studentAvg ON credits_.student_id = studentAvg.student_id\n" +
                    "    ),\n" +
                    "    courseDiffAvg AS ( -- courseDiffAvg: course의 편차의 평균을 구한 TABLE\n" +
                    "        SELECT course_id, sum(diff_grade*credit) / sum(credit) AS diff_avg -- 그 과목 성적의 평균 편차 (학점*편차의 합 / 학점의 합)\n" +
                    "        FROM creditsDiff\n" +
                    "        GROUP BY course_id\n" +
                    "    )\n" +
                    "SELECT course.course_id as course_id, diff_avg, name, credit\n" +
                    "FROM courseDiffAvg JOIN course ON courseDiffAvg.course_id = course.course_id\n" +
                    "ORDER BY diff_avg DESC\n" +
                    "LIMIT 10; -- 10개만 출력";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String courseId = rs.getString("course_id");
                String courseName = rs.getString("name");
                int credit = rs.getInt("credit");
                double diff = rs.getDouble("diff_avg");

                CourseDTO c = new CourseDTO(courseId, courseName, credit, diff);
                courses.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return courses;
    }

    //수업 설강
    public void createClass(Attribute attb, String classNo, String majorId, String name, String credit, String year, String lecturerId, String personMax, String roomId, String time) {
        String sql = "";

        if (classNo.isEmpty() || majorId.isEmpty() || name.isEmpty() || classNo.isEmpty() || year.isEmpty() || lecturerId.isEmpty() || personMax.isEmpty() || roomId.isEmpty()) {
            attb.setMessage("시간을 제외한 영역에는 값이 입력되어야 합니다.");
            attb.setMsgType("error");
            return;
        }
        String[] times = null;  //times: time을 단순히 ","로 split한것

        ArrayList<ClassTime> classTimes = new ArrayList<>();
        if (!time.isEmpty()) {
            times = time.split(",");
            for (String t: times) {
                if (t.charAt(0)-'1' < 0 || t.charAt(0)-'1' >= 7) {
                    attb.setMessage("시간에 유효하지 않은 요일 정보가 있습니다.");
                    attb.setMsgType("error");
                    return;
                }
                String begin = t.substring(0, 5);
                String end = t.substring(0, 1)+t.substring(5, 9);

                classTimes.add(new ClassTime(begin, end));
            }
        }

        try {
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);

            //강의실 정원 초과하는지 확인
            sql = "SELECT * FROM room WHERE room_id="+roomId;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            rs.next();
            
            if (Integer.parseInt(personMax) > rs.getInt("occupancy")) {
                attb.setMessage("강의실 정원을 초과하는 수강정원입니다.");
                attb.setMsgType("error");
                return;
            }
            
            //추가할 수업의 classId를 구함
            sql = "SELECT MAX(class_id) AS max FROM class";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            rs.next();
            int classId = rs.getInt("max")+1;
            
            //추가할 수업의 courseId를 구함
            sql = String.format("SELECT course_id FROM class WHERE class_no=%s", classNo);
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            rs.next();
            String courseId = rs.getString("course_id");

            //추가할 time이 같은 room_id를 사용하는 수업의 시간과 겹칠경우 체크
            ArrayList<ClassDTO> classes = getClasses("WHERE class.room_id="+roomId);

            for (ClassDTO c: classes) {
                if (c.iseLearning()) continue; //eLearnign이면 볼필요 없음
                for (ClassTime t: c.getTimes()) { //t: room을 사용하는 class들의 시간
                    for (ClassTime theTime: classTimes) { //theTime: 추가할 수업의 살펴보고 있는 시간
                        if (theTime.iseLearning()) continue;
                        if (!t.getDay().equals(theTime.getDay())) continue; //요일이 다르면 볼필요 없음
                        if (theTime.endToMin() > t.beginToMin() || t.endToMin() > theTime.beginToMin()) {
                            attb.setMessage("강의실 시간이 겹칩니다");
                            attb.setMsgType("error");
                            return;
                        }
                    }
                }
            }

            //class에 추가하는 쿼리 처리
            sql = String.format("INSERT INTO class VALUES (%s, %s, '%s', %s, '%s', %s, %s, %s, %s, %s, %s)",
                    classId, classNo, courseId, majorId, name, credit, year, lecturerId, personMax, 2022, roomId);
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            //time에 추가하는 쿼리 처리
            if (times != null) {
                int i = 0;
                for (String t : times) {
                    sql = String.format("INSERT INTO time (class_id, period, begin, end) VALUES (%s, %s, '%s', '%s')",
                            classId, ++i, t.substring(0, 5), t.substring(0, 1)+t.substring(5, 9));
                    pstmt = conn.prepareStatement(sql);
                    pstmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            attb.setMessage("other error");
            attb.setMsgType("error");
            e.printStackTrace();
            return;
        }
        attb.setMessage("수업 설강 성공");
        attb.setMsgType("success");
    }
}

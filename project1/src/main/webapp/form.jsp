<%--
  Created by IntelliJ IDEA.
  User: onkkn
  Date: 2022-10-29
  Time: 오전 2:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="proj1.*" %>
<%@ include file="global.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.Array" %>
<html>
<head>
    <link rel="stylesheet" href="css/common.css">
    <title>Title</title>
    <%
        request.setCharacterEncoding("UTF-8");
    %>
</head>
<body>
<%
    state = request.getParameter("state");
    beforePage = request.getParameter("before-page");
    nav = request.getParameter("nav");
    attributes.setMessage(null);

    if (state.equals("toLogin")) {%>
        <jsp:forward page="login.jsp"/>
<%  }

    if (beforePage != null && beforePage.equals("login")) {
        String id = request.getParameter("id");
        String pw = request.getParameter("pw");

        int loginResult = dao.doLogin(id, pw);
        // 로그인 실패시
        if (loginResult == -1) {
            attributes.setMessage("로그인 실패");
            attributes.setMsgType("error");
            request.setAttribute("attb", attributes); %>
            <jsp:forward page="login.jsp"/>

    <%  //로그인 성공시
        } else {
            attributes.setUserId(loginResult);
            attributes.setIsAdmin(dao.justifyIsAdmin(loginResult));
            attributes.setState("now");

            //admin이 아니라면 학생정보 얻기
            if (!attributes.getIsAdmin())
                attributes.setStudent(dao.getStudent(loginResult));

            //처음에 main으로 갈때도 classes가 필요함
            attributes.setClasses(dao.getClasses("WHERE opened=2022"));
            request.setAttribute("attb", attributes); %>

            <jsp:forward page="main.jsp"/>
    <%  }
    }

    //로그인에서 온게 아니면 항상 로그인 성공한 상태이므로 isAdmin과 getStudent를 일괄적으로 처리
    userId = Integer.parseInt(request.getParameter("user-id"));
    attributes.setUserId(userId);
    if (dao.justifyIsAdmin(userId)) {
        attributes.setIsAdmin(true);
    }
    else {
        attributes.setIsAdmin(false);
        attributes.setStudent(dao.getStudent(userId));
    }

    if (nav != null) { //nav바 이동 처리
        switch (nav) {
            case "main": //수강편람 이동
                Main func = new Main();
                func.searchNow(attributes);
                attributes.setState("now");
                request.setAttribute("attb", attributes); %>
                <jsp:forward page="main.jsp"/> <%
                break;
            case "studentInfo": //학생정보 이동
                if (attributes.getIsAdmin()) {
                    attributes.setState("select"); //admin에서 studentInfo로 처음 갈때.
                }
                else {
                    attributes.setState("student"); //학생 표시
                }
                request.setAttribute("attb", attributes); %>
                <jsp:forward page="studentInfo.jsp"/> <%
                break;
            case "statistics":
                attributes.setState("general");
                request.setAttribute("attb", attributes); %>
                <jsp:forward page="statistics.jsp"/> <%
                break;
            case "createClass":
                attributes.setState("general");
                request.setAttribute("attb", attributes); %>
                <jsp:forward page="createClass.jsp"/> <%
            default:
                break;
        }

    }

    //main에서 왔을때
    if (beforePage.equals("main") && (state.length() <= 6 || state.length() >= 12)) {
        //수업 검색 begin
        Main func = new Main();

        //검색사항이 있을때
        if (state.equals("search-class")) {
            attributes.setSearchType(request.getParameter("search-select"));
            attributes.setSearchValue(request.getParameter("search-value"));
            attributes.setSearchYear(request.getParameter("year"));

            func.searchClass(attributes);
        } else if (state.equals("my")) { //지정과목 검색
            func.searchMy(attributes);
        } else if (state.equals("wish")) { //희망수업 검색
            func.searchWish(attributes);
        } else if (state.equals("enroll")) { //신청한 수업 검색
            func.searchEnroll(attributes);
        } else if (state.equals("all")) {
            func.searchAll(attributes);
        } else if (state.equals("now")) {
            func.searchNow(attributes);
        }
        attributes.setState(state);
        request.setAttribute("attb", attributes); %>
        <jsp:forward page="main.jsp"/>
<%--      수업 검색 end --%>
<%  }
    //희망 | 수강 신청에 대한 처리일때
    else if (beforePage.equals("main") && !attributes.getIsAdmin()) {
        Main func = new Main();

        //희망, 수강 -> 신청, 삭제에 대한 경우
        attributes.setState(request.getParameter("before-state"));
        int cId = Integer.parseInt(request.getParameter("class-id"));
        beforeState = request.getParameter("before-state");

        int res = -1;
        if (state.equals("addWish")) {
            dao.addWish(attributes.getStudent().getStudentId(), cId);
        } else if (state.equals("delWish")) {
            dao.delWish(attributes.getStudent().getStudentId(), cId);
        } else if (state.equals("addEnroll")) {
            res = dao.addEnroll(attributes.getStudent().getStudentId(), cId, false);

            //수강신청 결과에 대한 처리
            switch (res) {
                case 0:
                    attributes.setMessage("수강신청 성공");
                    attributes.setMsgType("success");
                    attributes.setStudent(dao.getStudent(userId));
                    break;
                case 1:
                    attributes.setMessage("최대 학점을 초과했습니다.");
                    break;
                case 2:
                    attributes.setMessage("수강 정원을 초과했습니다.");
                    break;
                case 3:
                    attributes.setMessage("수업 시간이 중복됩니다.");
                    break;

            }
            if (res != 0) attributes.setMsgType("error");
        } else if (state.equals("delEnroll")) {
            dao.delEnroll(attributes.getStudent().getStudentId(), cId);
        }

        //그전에 보고있던 수업들 목록을 그대로 볼 수 있게함
        switch (beforeState) {
            case "all":
                func.searchAll(attributes);
                break;
            case "my":
                func.searchMy(attributes);
                break;
            case "wish":
                func.searchWish(attributes);
                break;
            case "enroll":
                func.searchEnroll(attributes);
                break;
            case "now":
            case "search-class":
                func.searchNow(attributes);
                break;
            default:
                break;
        }

        attributes.setState(state);
        request.setAttribute("attb", attributes); %>
        <jsp:forward page="main.jsp"/>
<%  }
    //main에서 admin으로 넘어왔을때
    else if (beforePage.equals("main") && state.equals("modifyClass")) {
        int cId = Integer.parseInt(request.getParameter("class-id"));
        attributes.setClassId(cId);
        request.setAttribute("attb", attributes); %>
        <jsp:forward page="classInfo.jsp"/>
<%  }
    else if (beforePage.equals("studentInfo")) {
        if (state.equals("changId")) { //아이디 변경 처리
            String newId = request.getParameter("newId");
            int res = dao.changeId(attributes.getUserId(), attributes.getStudent().getStudentId(), newId);
            switch (res) {
                case 1:
                    attributes.setMessage("빈 아이디입니다.");
                    break;
                case 2:
                    attributes.setMessage("15자 이내로 입력해주세요.");
                    break;
                case 3:
                    attributes.setMessage("아이디가 이전과 같습니다");
                    break;
                case 4:
                    attributes.setMessage("이미 존재하는 아이디입니다.");
                    break;
                case 5:
                    attributes.setMessage("다른 학생의 학번은 아이디로 지정할 수 없습니다..");
                    break;
                case 0:
                    attributes.setMessage("아이디 변경 성공");
            }

            if (res != 0) {
                attributes.setMsgType("error");
                request.setAttribute("attb", attributes);
            } else {
                attributes.setMsgType("success");
                request.setAttribute("attb", attributes);
            } %>
            <jsp:forward page="studentInfo.jsp"/>
<%      }
        else if (state.equals("changePw")) {
            String newPw = request.getParameter("newPw");
            int res = dao.changePw(attributes.getUserId(), newPw);
            switch (res) {
                case 1:
                    attributes.setMessage("빈 비밀번호입니다.");
                    break;
                case 2:
                    attributes.setMessage("15자 이내로 입력해주세요.");
                    break;
                case 3:
                    attributes.setMessage("비밀번호가 이전과 같습니다.");
                    break;
                case -1:
                    attributes.setMessage("undefined error");
                    break;
                case 0:
                    attributes.setMessage("비밀번호 변경 성공");
                    break;
            }
            if (res == 0) {
                attributes.setMsgType("success");
                request.setAttribute("attb", attributes);
            } else {
                attributes.setMsgType("error");
                request.setAttribute("attb", attributes);
            } %>
            <jsp:forward page="studentInfo.jsp"/>
<%      }
        else if (state.equals("searchStudent")) {
            int sId = Integer.parseInt(request.getParameter("studentId"));
            dao.searchStudent(attributes, sId);
            attributes.setState("general");
            request.setAttribute("attb", attributes); %>
            <jsp:forward page="studentInfo.jsp"/>
<%      }
        else if (state.equals("changeState")) {
            String newState = request.getParameter("newState");
            dao.changeState(attributes, newState);
            request.setAttribute("attb", attributes); %>
            <jsp:forward page="studentInfo.jsp"/>
<%      }
    } else if (beforePage.equals("classInfo")) { //수강 허용 반영이나 과목 증원 기능
        int cId = Integer.parseInt(request.getParameter("class-id"));
        attributes.setClassId(cId);

        if (state.equals("changePersonMax")) {
            int newMax = Integer.parseInt(request.getParameter("newPersonMax"));
            int res = dao.changePersonMax(cId, newMax);
            switch (res) {
                case 1:
                    attributes.setMessage("1 이상의 정수여야 합니다.");
                    break;
                case 2:
                    attributes.setMessage("강의실 정원이 바뀔 정원보다 커야 합니다.");
                    break;
                case 3:
                    attributes.setMessage("현재 신청인원 이상이어야 합니다.");
                    break;
                case 0:
                    attributes.setMessage("정원 변경 완료");
                    attributes.setMsgType("success");
                    break;
            }
            if (res != 0) attributes.setMsgType("error");
        }
        else if (state.equals("insertStudent")) {
            int sId = Integer.parseInt(request.getParameter("student-id"));
            int res = dao.addEnroll(sId, cId, true);
        }
        else if (state.equals("deleteClass")) {
            Main func = new Main();
            dao.delClass(cId);
            attributes.setState("now");
            func.searchNow(attributes);
            request.setAttribute("attb", attributes); %>
            <jsp:forward page="main.jsp"/>
    <%  }
        request.setAttribute("attb", attributes); %>
        <jsp:forward page="classInfo.jsp"/>
<%  } else if (beforePage.equals("createClass")) {
        String classNo = request.getParameter("classNo");
        String majorId = request.getParameter("majorId");
        String name = request.getParameter("name");
        String credit = request.getParameter("credit");
        String year = request.getParameter("year");
        String lecturerId = request.getParameter("lecturerId");
        String personMax = request.getParameter("personMax");
        String roomId = request.getParameter("roomId");
        String time = request.getParameter("time");

        dao.createClass(attributes, classNo, majorId, name, credit, year, lecturerId, personMax, roomId, time);
        request.setAttribute("attb", attributes); %>
        <jsp:forward page="createClass.jsp"/> <%
    }
%>

</body>
</html>
